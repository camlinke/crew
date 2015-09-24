app.get '/group/:group', (req, res) ->
    Chat.find({
        'group': req.params.group
    }).exec (err, msgs) ->
        if !req.session.username
            foo = "bar"
            req.session.group = req.params.group
            res.redirect '/users/create'
        else
            group = req.params.group
            username = req.session.username
            req.session.group = group
            res.render 'group', { msgs: msgs, group: group, username: username }
    # res.send "id is set to #{req.params.group}"

app.post '/createGroup', (req, res) ->
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
                res.redirect "/group/#{req.body.groupName}"

module.exports = router