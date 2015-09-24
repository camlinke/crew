express = require 'express'
router = express.Router()

app.get '/users/create', (req, res) ->
    res.render 'username'

app.post '/users/create', (req, res) ->
    req.session.username = req.body.username
    res.redirect "/groups/#{req.session.group}"

module.exports = router