// Generated by CoffeeScript 1.6.2
(function() {
  var app, express, jade, nib, stylus;

  express = require('express');

  jade = require('jade');

  stylus = require('stylus');

  nib = require('nib');

  app = express();

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

  app.get('/fb-channel', function(req, res, next) {
    return res.render('util/fb-channel');
  });

  app.get('/player', function(req, res, next) {
    return res.render('player/player');
  });

  app.get('*', function(req, res, next) {
    return res.render('index');
  });

  app.listen(process.env.VCAP_APP_PORT || 80, function() {
    return console.log("listening on port " + (process.env.VCAP_APP_PORT || 80));
  });

}).call(this);
