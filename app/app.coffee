express = require 'express'
coffeescript = require 'connect-coffee-script'
jade = require 'jade'
stylus = require 'stylus'
nib = require 'nib'

app = express()

app.configure () ->

	app.use('/script', coffeescript({
		src: __dirname + '/../assets/script',
		dest: __dirname + '/../assets/build/script',
		bare: true
	}))

	app.use('/css', stylus.middleware({
		src: __dirname + '/../assets/stylus',
		dest: __dirname + '/../assets/build/css',
		compile: (str, path) ->
			stylus(str).set('filename', path).set('compress', false).use(nib())
	}))

	app.engine('jade', jade.__express)
	app.set('views', __dirname + '/../assets/jade')
	app.set('view engine', 'jade')
	
	app.use('/script', express.static(__dirname + '/../assets/build/script'))
	app.use('/css', express.static(__dirname + '/../assets/build/css'))
	app.use('/image', express.static(__dirname + '/../assets/image'))

app.get '/fb-channel', (req, res, next) ->
	res.render('util/fb-channel')

app.get '/player', (req, res, next) ->
	res.render('player/player')

app.get '*', (req, res, next) ->
	res.render('index')

app.listen (process.env.VCAP_APP_PORT || 3000), () ->
	console.log "listening on port " + (process.env.VCAP_APP_PORT || 3000)