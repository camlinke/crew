express = require 'express'
app = express()
http = require('http').Server app
io = require('socket.io')(http)
expressHandlebars = require 'express-handlebars'
mongoose = require 'mongoose'
bodyParser = require 'body-parser'
moment = require 'moment'

cookieParser = require('cookie-parser')()
session = require('cookie-session')({secret: 'secret'})

app.use bodyParser.urlencoded {extended: true}
app.use express.static __dirname + '/public'
app.use cookieParser
app.use session

io.use (socket, next) ->
    req = socket.handshake
    res = {}
    cookieParser req, res, (err) ->
        if err
            return next err
        session req, res, next

# app.set 'port', process.env.PORT || 4000

app.engine 'handlebars', expressHandlebars {defaultLayout: 'main'}
app.set 'view engine', 'handlebars'

mongoose.connect 'mongodb://localhost:27017/crew_db'
db = mongoose.connection
db.on 'error', console.error.bind console, 'connection error:'
db.once 'open', (callback) ->
    # Yay

messageSchema = mongoose.Schema {
    created: Date,
    content: String,
    username: String,
    group: String
}

groupSchema = mongoose.Schema {
    created: Date,
    endDate: Date,
    groupName: String,
    password: String
}

Chat = mongoose.model 'Chat', messageSchema
Group = mongoose.model 'Group', groupSchema

app.get '/', (req, res) ->
    dateTomorrow = moment().add(1, 'days').format 'MM/DD/YY'
    res.render 'home', { dateTomorrow: dateTomorrow}

app.get '/test', (req, res) ->
    res.send "testssss"

app.get '/groups/:group', (req, res) ->
    Group.find({
        'groupName': req.params.group,
    }).lean().exec (err, group) ->
        if group.length > 0 and group[0].endDate > new Date()
            group = group[0]
            Chat.find({
                'group': req.params.group
            }).lean().exec (err, msgs) ->
                console.log msgs
                if !req.session.username
                    req.session.group = req.params.group
                    res.redirect '/users/create'
                else
                    username = req.session.username
                    req.session.groupName = group.groupName
                    msgs.map (msg) -> msg.created = moment(msg.created).fromNow() #format "MM/DD/YY"
                    group.endDate = moment(group.endDate).fromNow() #format "MM/DD/YY"
                    res.render 'group', { msgs: msgs, group: group, username: username }
        else
            res.redirect "/"
    # res.send "id is sdet to #{req.params.group}"

app.get '/users/create', (req, res) ->
    res.render 'username'

app.post '/users/create', (req, res) ->
    req.session.username = req.body.username
    res.redirect "/groups/#{req.session.groupName}"


app.post '/groups/create', (req, res) ->
    groupName = req.body.groupName.replace /// ///g,''
    endDate = req.body.endDate
    Chat.find({
        'group': groupName
    }).exec (err, group) ->
        if group.length > 0
            error = "group already exists"
            console.log error
            res.redirect "/"
        else
            g = {
                created: +new Date,
                endDate: new Date(endDate),
                groupName: groupName,
                password: ""
            }
            group = new Group(g)
            group.save (err, savedGroup) ->
                res.redirect "/groups/#{groupName}"


io.on 'connection', (socket) ->
    currentSession = socket.handshake.session
    console.log "User: #{currentSession.username} is in group: #{currentSession.groupName}"

    socket.on 'chat message', (msg) ->
        datetime = +new Date()
        message = {
            created: datetime,
            content: msg,
            username: currentSession.username
            group: currentSession.groupName
        }
        chat = new Chat(message)
        chat.save (err, savedMessage) ->
            console.log savedMessage
            io.emit 'chat message', {msg: msg, username: currentSession.username, datetime: moment(datetime).fromNow()}#format("MM/DD/YY")

    socket.on 'disconnect', ->
        console.log 'user disconnected'

server = http.listen '4000', ->
    host = server.address().address
    port = server.address().port

    console.log "Example app listening at http://#{host}:#{port}"
    return