// Generated by CoffeeScript 1.7.1
var Chat, Group, app, bodyParser, cookieParser, db, express, expressHandlebars, groupSchema, http, io, messageSchema, mongoose, server, session;

express = require('express');

app = express();

http = require('http').Server(app);

io = require('socket.io')(http);

expressHandlebars = require('express-handlebars');

mongoose = require('mongoose');

bodyParser = require('body-parser');

cookieParser = require('cookie-parser')();

session = require('cookie-session')({
  secret: 'secret'
});

app.use(bodyParser.urlencoded({
  extended: true
}));

app.use(express["static"](__dirname + '/public'));

app.use(cookieParser);

app.use(session);

io.use(function(socket, next) {
  var req, res;
  req = socket.handshake;
  res = {};
  return cookieParser(req, res, function(err) {
    if (err) {
      return next(err);
    }
    return session(req, res, next);
  });
});

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

groupSchema = mongoose.Schema({
  created: Date,
  endDate: Date,
  groupName: String,
  password: String
});

Chat = mongoose.model('Chat', messageSchema);

Group = mongoose.model('Group', groupSchema);

app.get('/', function(req, res) {
  return res.render('home');
});

app.get('/groups/:group', function(req, res) {
  return Group.find({
    'groupName': req.params.group
  }).exec(function(err, group) {
    if (group && group.endDate < new Date()) {
      return Chat.find({
        'group': req.params.group
      }).exec(function(err, msgs) {
        var foo, username;
        if (!req.session.username) {
          foo = "bar";
          req.session.group = req.params.group;
          return res.redirect('/users/create');
        } else {
          username = req.session.username;
          req.session.groupName = groupName;
          return res.render('group', {
            msgs: msgs,
            group: group,
            username: username
          });
        }
      });
    }
  });
});

app.get('/users/create', function(req, res) {
  return res.render('username');
});

app.post('/users/create', function(req, res) {
  req.session.username = req.body.username;
  return res.redirect("/groups/" + req.session.group);
});

app.post('/groups/create', function(req, res) {
  return Chat.find({
    'group': req.body.groupName
  }).exec(function(err, group) {
    var error, g;
    if (group.length > 0) {
      error = "group already exists";
      console.log(error);
      return res.redirect("/");
    } else {
      g = {
        created: +(new Date),
        endDate: +(new Date) + 86400000,
        groupName: req.body.groupName,
        password: ""
      };
      group = new Group(g);
      return group.save(function(err, savedGroup) {
        return res.redirect("/groups/" + req.body.groupName);
      });
    }
  });
});

io.on('connection', function(socket) {
  var currentSession;
  currentSession = socket.handshake.session;
  console.log("User: " + currentSession.username + " is in group: " + currentSession.group);
  socket.on('chat message', function(msg) {
    var chat, datetime, message;
    datetime = +new Date();
    message = {
      created: datetime,
      content: msg,
      username: currentSession.username,
      group: currentSession.group
    };
    chat = new Chat(message);
    return chat.save(function(err, savedMessage) {
      console.log(savedMessage);
      return io.emit('chat message', {
        msg: msg,
        username: currentSession.username,
        datetime: datetime
      });
    });
  });
  return socket.on('disconnect', function() {
    return console.log('user disconnected');
  });
});

server = http.listen('4000', function() {
  var host, port;
  host = server.address().address;
  port = server.address().port;
  console.log("Example app listening at http://" + host + ":" + port);
});
