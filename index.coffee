express = require 'express'
app = express()
http = require('http').Server app
io = require('socket.io')(http)
expressHandlebars = require 'express-handlebars'
mongoose = require 'mongoose'
bodyParser = require 'body-parser'

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
    res.render 'home'

app.get '/groups/:group', (req, res) ->
    Group.find({
        'groupName': req.params.group,
    }).exec (err, group) ->
        if group and group.endDate < new Date()
            Chat.find({
                'group': req.params.group
            }).exec (err, msgs) ->
                if !req.session.username
                    foo = "bar"
                    req.session.group = req.params.group
                    res.redirect '/users/create'
                else
                    username = req.session.username
                    req.session.groupName = groupName
                    res.render 'group', { msgs: msgs, group: group, username: username }
    # res.send "id is sdet to #{req.params.group}"

app.get '/users/create', (req, res) ->
    res.render 'username'

app.post '/users/create', (req, res) ->
    req.session.username = req.body.username
    res.redirect "/groups/#{req.session.group}"


app.post '/groups/create', (req, res) ->
    Chat.find({
        'group': req.body.groupName
    }).exec (err, group) ->
        if group.length > 0
            error = "group already exists"
            console.log error
            res.redirect "/"
        else
            g = {
                created: +new Date,
                endDate: +new Date + 86400000,
                groupName: req.body.groupName,
                password: ""
            }
            group = new Group(g)
            group.save (err, savedGroup) ->
                res.redirect "/groups/#{req.body.groupName}"


io.on 'connection', (socket) ->
    currentSession = socket.handshake.session
    console.log "User: #{currentSession.username} is in group: #{currentSession.group}"

    socket.on 'chat message', (msg) ->
        datetime = +new Date()
        message = {
            created: datetime,
            content: msg,
            username: currentSession.username
            group: currentSession.group
        }
        chat = new Chat(message)
        chat.save (err, savedMessage) ->
            console.log savedMessage
            io.emit 'chat message', {msg: msg, username: currentSession.username, datetime: datetime}

    socket.on 'disconnect', ->
        console.log 'user disconnected'

server = http.listen '4000', ->
    host = server.address().address
    port = server.address().port

    console.log "Example app listening at http://#{host}:#{port}"
    return