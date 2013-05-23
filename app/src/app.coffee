express = require 'express'
jade = require 'jade'
stylus = require 'stylus'
nib = require 'nib'

app = express()

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

app.get '/fb-channel', (req, res, next) ->
	res.render('util/fb-channel')

app.get '*', (req, res, next) ->
	res.render('index')

app.listen 3000, () ->
	console.log "listening on port 3000"