express = require 'express'
jade = require 'jade'

app = express()

app.configure () ->
	app.use('/script', express.static(__dirname + '/../../assets/script/bin'))
	
	app.engine('jade', jade.__express)
	
	app.set('views', __dirname + '/../../assets/jade')
	app.set('view engine', 'jade')
	

app.get '*', (req, res, next) ->
	res.render('index')

app.listen 3000, () ->
	console.log "listening on port 3000"