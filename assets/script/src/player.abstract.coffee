class @PlayerAbstract

	constructor: () ->

	element: (element) ->
		throw new Error "element(element): Unimplemented"

	load: (url) ->
		throw new Error "load(url): Unimplemented"

	play: () ->
		throw new Error "play(): Unimplemented"

	pause: () ->
		throw new Error "pause(): Unimplemented"

	stop: () ->
		throw new Error "stop(): Unimplemented"

	on: (event, callback) ->
		throw new Error "on(event, callback): Unimplemented"

	destroy: () ->
		throw new Error "destroy(): Unimplemented"

class @Queue
	constructor: () ->
		@songs = []
		@player = null
		@index = 0
		@playing = false

	add: (song) ->
		console.log "add"

		@songs.push(song)

		if @songs.length == 1
			@playing = true
			@loadAndPlay()

	remove: (index) ->
		console.log "remove"
		console.log index
		@songs.splice(index, 1)

	play: (index) ->
		console.log "play"
		if @player
			@player.play()
			@playing = true

	pause: () ->
		console.log "pause"
		if @player
			@player.pause()
			@playing = false

	stop: () ->
		console.log "stop"
		if @player
			@player.stop()
			@playing = false

	prev: () ->
		console.log "prev"
		
		if @index - 1 >= 0
			@index--

			@loadAndPlay()

	next: () ->
		console.log "next"
		
		if @index + 1 < @songs.length
			@index++

			@loadAndPlay()

	load: () ->
		if @player
			if (song = @songs[@index])
				@player.load song.link, () =>
					@player.finish () =>
						@next()

					return

	loadAndPlay: () ->
		if @player
			if (song = @songs[@index])
				@player.load song.link, () =>
					@player.finish () =>
						@next()

					if @isPlaying()
						@play()

	isPlaying: () ->
		return @playing

class @UrlParser 
	constructor: (@url) ->
		@type = if @url.indexOf('soundcloud') != -1 then 'soundcloud' else @type
		@type = if @url.indexOf('youtube') != -1 then 'youtube' else @type

		if @type == 'soundcloud'
			@id = @url

		if @type == 'youtube'
			@id = @url.split('?v=').pop()

class @Player extends @PlayerAbstract

	@Events: {
		READY: 'ready'
	}

	element: (@id) ->

	load: (url, callback) ->
		url = new UrlParser(url)

		if @_player
			@_player.destroy()

		if url.type == 'soundcloud'
			@_player = new PlayerSoundcloud()
			@_player.element(@id)
			@_player.load(url.id, callback)

		if url.type == 'youtube'
			@_player = new PlayerYoutube()
			@_player.element(@id)
			@_player.load(url.id, callback)

	finish: (callback) ->
		if @_player
			@_player.finish(callback)

	play: () ->
		if @_player
			@_player.play()

	pause: () ->
		if @_player
			@_player.pause()

	stop: () ->
		if @_player
			@_player.stop()

@onYouTubeIframeAPIReady = () =>
	if @Player.ready
		@Player.ready()