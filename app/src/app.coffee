express = require 'express'
jade = require 'jade'
stylus = require 'stylus'

app = express()

app.configure () ->

	app.use('/css', stylus.middleware({
		src: __dirname + '/../../assets/stylus',
		dest: __dirname + '/../../assets/css'
	}))

	app.engine('jade', jade.__express)
	app.set('views', __dirname + '/../../assets/jade')
	app.set('view engine', 'jade')
	
	app.use('/script', express.static(__dirname + '/../../assets/script/bin'))
	app.use('/css', express.static(__dirname + '/../../assets/css'))
	app.use('/image', express.static(__dirname + '/../../assets/image'))

app.get '*', (req, res, next) ->
	res.render('index')

app.listen 3000, () ->
	console.log "listening on port 3000"