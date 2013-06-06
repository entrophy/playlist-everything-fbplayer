class @UrlParser 
	constructor: (@url) ->
		@type = if @url.indexOf('soundcloud') != -1 then 'soundcloud' else @type
		@type = if @url.indexOf('youtube') != -1 then 'youtube' else @type

		if @type == 'soundcloud'
			@id = @url

		if @type == 'youtube'
			regex = /(?:https?\:\/\/)?\/\/(?:[0-9A-Z-]+\.)?(?:youtu\.be\/|youtube\.com\S*[^\w\-\s])([\w\-]{11})(?=[^\w\-]|$)(?![?=&+%\w]*(?:['"][^<>]*>|<\/a>))[?=&+%\w-]*/ig
			matches = regex.exec @url
			@id = matches[1]