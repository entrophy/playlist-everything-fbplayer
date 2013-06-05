// Generated by CoffeeScript 1.6.2
(function() {
  var app, cors, express, jade, nib, stylus;

  express = require('express');

  jade = require('jade');

  stylus = require('stylus');

  nib = require('nib');

  app = express();

  cors = function(req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS');
    res.header('Access-Control-Allow-Credentials', 'true');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With, X-File-Name');
    return next();
  };

  app.configure(function() {
    app.use('/css', stylus.middleware({
      src: __dirname + '/../../assets/stylus',
      dest: __dirname + '/../../assets/css',
      compile: function(str, path) {
        return stylus(str).set('filename', path).set('compress', false).use(nib());
      }
    }));
    app.engine('jade', jade.__express);
    app.set('views', __dirname + '/../../assets/jade');
    app.set('view engine', 'jade');
    app.use('/script', express["static"](__dirname + '/../../assets/script/bin'));
    app.use('/css', express["static"](__dirname + '/../../assets/css'));
    return app.use('/image', express["static"](__dirname + '/../../assets/image'));
  });

  app.get('/fb-channel', cors, function(req, res, next) {
    return res.render('util/fb-channel');
  });

  app.get('/player', cors, function(req, res, next) {
    return res.render('player/player');
  });

  app.get('*', cors, function(req, res, next) {
    return res.render('index');
  });

  app.listen(process.env.VCAP_APP_PORT || 80, function() {
    return console.log("listening on port " + (process.env.VCAP_APP_PORT || 80));
  });

}).call(this);
