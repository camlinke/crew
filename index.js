// Generated by CoffeeScript 1.7.1
var Chat, Group, app, bodyParser, cookieParser, db, express, expressHandlebars, groupSchema, http, io, messageSchema, moment, mongoose, server, session;

express = require('express');

app = express();

http = require('http').Server(app);

io = require('socket.io')(http);

expressHandlebars = require('express-handlebars');

mongoose = require('mongoose');

bodyParser = require('body-parser');

moment = require('moment');

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
  var dateTomorrow;
  dateTomorrow = moment().add(1, 'days').format('MM/DD/YY');
  return res.render('home', {
    dateTomorrow: dateTomorrow
  });
});

app.get('/test', function(req, res) {
  return res.send("testssss");
});

app.get('/groups/:group', function(req, res) {
  return Group.find({
    'groupName': req.params.group
  }).lean().exec(function(err, group) {
    var dateTomorrow, error;
    if (group.length > 0 && group[0].endDate > new Date()) {
      group = group[0];
      return Chat.find({
        'group': req.params.group
      }).lean().exec(function(err, msgs) {
        var username;
        console.log(msgs);
        if (!req.session.username) {
          req.session.groupName = req.params.groupName;
          return res.redirect('/users/create');
        } else {
          username = req.session.username;
          req.session.groupName = group.groupName;
          msgs.map(function(msg) {
            return msg.created = moment(msg.created).fromNow();
          });
          group.endDate = moment(group.endDate).fromNow();
          return res.render('group', {
            msgs: msgs,
            group: group,
            username: username
          });
        }
      });
    } else {
      error = "Unable to find group";
      dateTomorrow = moment().add(1, 'days').format('MM/DD/YY');
      return res.render("home", {
        error: error,
        dateTomorrow: dateTomorrow
      });
    }
  });
});

app.get('/users/create', function(req, res) {
  return res.render('username');
});

app.post('/users/create', function(req, res) {
  req.session.username = req.body.username;
  return res.redirect("/groups/" + req.session.groupName);
});

app.post('/groups/create', function(req, res) {
  var endDate, groupName;
  groupName = req.body.groupName.replace(/(?:)/g, '');
  endDate = req.body.endDate;
  return Chat.find({
    'group': groupName
  }).exec(function(err, group) {
    var error, g;
    if (group.length > 0) {
      error = "Group already exists";
      console.log(error);
      return res.redirect("/error/exists");
    } else {
      g = {
        created: +(new Date),
        endDate: new Date(endDate),
        groupName: groupName,
        password: ""
      };
      group = new Group(g);
      return group.save(function(err, savedGroup) {
        return res.redirect("/groups/" + groupName);
      });
    }
  });
});

app.get('/error/exists', function(req, res) {
  var dateTomorrow, error;
  error = "Group already exists";
  dateTomorrow = moment().add(1, 'days').format('MM/DD/YY');
  return res.render('home', {
    error: error,
    dateTomorrow: dateTomorrow
  });
});

app.get('/logout', function(req, res) {
  req.session = null;
  return res.redirect('/');
});

io.on('connection', function(socket) {
  var currentSession;
  currentSession = socket.handshake.session;
  console.log("User: " + currentSession.username + " is in group: " + currentSession.groupName);
  socket.on('chat message', function(msg) {
    var chat, datetime, message;
    datetime = +new Date();
    message = {
      created: datetime,
      content: msg,
      username: currentSession.username,
      group: currentSession.groupName
    };
    chat = new Chat(message);
    return chat.save(function(err, savedMessage) {
      console.log(savedMessage);
      return io.emit('chat message', {
        msg: msg,
        username: currentSession.username,
        datetime: moment(datetime).fromNow()
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
