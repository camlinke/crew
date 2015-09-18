express = require 'express'
expressHandlebars = require 'express-handlebars'
mongoose = require 'mongoose'
bodyParser = require 'body-parser'

app = express()

app.use bodyParser.urlencoded {extended: true}

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
    return

app.get '/:group', (req, res) ->
    Chat.find({
        'group': 1234
    }).exec (err, msgs) ->
        res.send(msgs)
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

server = app.listen '4000', ->
    host = server.address().address
    port = server.address().port

    console.log "Example app listening at http://#{host}:#{port}"
    return