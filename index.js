// Generated by CoffeeScript 1.7.1
var Chat, app, bodyParser, db, express, expressHandlebars, messageSchema, mongoose, server;

express = require('express');

expressHandlebars = require('express-handlebars');

mongoose = require('mongoose');

bodyParser = require('body-parser');

app = express();

app.use(bodyParser.urlencoded({
  extended: true
}));

app.engine('handlebars', expressHandlebars({
  defaultLayout: 'main'
}));

app.set('view engine', 'handlebars');

mongoose.connect('mongodb://localhost:27017/crew_db');

db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));

db.once('open', function(callback) {});

messageSchema = mongoose.Schema({
  created: Date,
  content: String,
  username: String,
  group: String
});

Chat = mongoose.model('Chat', messageSchema);

app.get('/', function(req, res) {
  res.render('home');
});

app.get('/:group', function(req, res) {
  return Chat.find({
    'group': 1234
  }).exec(function(err, msgs) {
    return res.send(msgs);
  });
});

app.post('/:group/msg', function(req, res) {
  var chat, msg;
  msg = {
    created: new Date(),
    content: req.body.message,
    username: 'camlinke',
    group: req.params.group
  };
  chat = new Chat(msg);
  chat.save(function(err, savedChat) {
    return console.log(savedChat);
  });
  return res.send('created');
});

server = app.listen('4000', function() {
  var host, port;
  host = server.address().address;
  port = server.address().port;
  console.log("Example app listening at http://" + host + ":" + port);
});
