express = require 'express'
expressHandlebars = require 'express-handlebars'

app = express()

# app.set 'port', process.env.PORT || 4000

app.engine 'handlebars', expressHandlebars {defaultLayout: 'main'}
app.set 'view engine', 'handlebars'

app.get '/', (req, res) ->
    res.render 'home'
    return

server = app.listen '4000', ->
    host = server.address().address
    port = server.address().port

    console.log "Example app listening at http://#{host}:#{port}"
    return