express = require 'express'
app = express()
http = require('http').Server app
io = require('socket.io')(http)
expressHandlebars = require 'express-handlebars'
mongoose = require 'mongoose'
bodyParser = require 'body-parser'

app.use bodyParser.urlencoded {extended: true}
app.use express.static __dirname + '/public'

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

Chat = mongoose.model 'Chat', messageSchema

app.get '/', (req, res) ->
    res.render 'home'

app.get '/:group', (req, res) ->
    Chat.find({
        'group': req.params.group
    }).exec (err, msgs) ->
        console.log msgs
        group = req.params.group
        res.render 'group', { msgs: msgs, group: group }
    # res.send "id is set to #{req.params.group}"

app.post '/:group/msg', (req, res) ->
    msg = {
        created: new Date(),
        content: req.body.message,
        username: 'camlinke',
        group: req.params.group
    }
    chat = new Chat(msg)
    chat.save (err, savedChat) ->
        console.log savedChat
    res.send 'created'

io.on 'connection', (socket) ->
    console.log 'a user connected'

    socket.on 'disconnect', ->
        console.log 'user disconnected'

server = http.listen '4000', ->
    host = server.address().address
    port = server.address().port

    console.log "Example app listening at http://#{host}:#{port}"
    return