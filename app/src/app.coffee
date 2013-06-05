express = require 'express'
jade = require 'jade'
stylus = require 'stylus'
nib = require 'nib'

app = express()

cors = (req, res, next) ->
	res.header('Access-Control-Allow-Origin', '*')
	res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
	res.header('Access-Control-Allow-Credentials', 'true')
	res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With, X-File-Name')

	next()

app.configure () ->

	app.use('/css', stylus.middleware({
		src: __dirname + '/../../assets/stylus',
		dest: __dirname + '/../../assets/css',
		compile: (str, path) ->
			stylus(str).set('filename', path).set('compress', false).use(nib())
	}))

	app.engine('jade', jade.__express)
	app.set('views', __dirname + '/../../assets/jade')
	app.set('view engine', 'jade')
	
	app.use('/script', express.static(__dirname + '/../../assets/script/bin'))
	app.use('/css', express.static(__dirname + '/../../assets/css'))
	app.use('/image', express.static(__dirname + '/../../assets/image'))

app.get '/fb-channel', cors, (req, res, next) ->
	res.render('util/fb-channel')

app.get '/player', cors, (req, res, next) ->
	res.render('player/player')

app.get '*', cors, (req, res, next) ->
	res.render('index')

app.listen (process.env.VCAP_APP_PORT || 80), () ->
	console.log "listening on port " + (process.env.VCAP_APP_PORT || 80)

		