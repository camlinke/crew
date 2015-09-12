express = require 'express'
app = express()

# app.set 'port', process.env.PORT || 4000

app.get '/', (req, res) ->
    res.send('Hello World!')
    return

server = app.listen '4000', () ->
    host = server.address().address
    port = server.address().port

    console.log "Example app listening at http://#{host}:#{port}"
    return