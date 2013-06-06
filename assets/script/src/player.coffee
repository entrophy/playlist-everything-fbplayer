

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

	destroy: () ->
		if @_player
			@_player.destroy()
