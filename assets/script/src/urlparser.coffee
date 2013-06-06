class @UrlParser 
	constructor: (@url) ->
		@type = if @url.indexOf('soundcloud') != -1 then 'soundcloud' else @type
		@type = if @url.indexOf('youtube') != -1 then 'youtube' else @type

		if @type == 'soundcloud'
			@id = @url

		if @type == 'youtube'
			@id = @url.split('?v=').pop()