class @Queue
	constructor: () ->
		@songs = []
		@callbacks = []
		@index = 0
		@playing = false

		player = new window.Player()
		player.element('player')

		@player = player

	add: (song) ->
		console.log "add"

		@songs.push(song)

		if @songs.length == 1
			@playing = true
			@loadAndPlay()

		for callback in @callbacks['add'] || []
			callback.call(@, song)

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


	on: (event, callback) ->
		(@callbacks[event] = @callbacks[event] || []).push(callback)

	getAllSongs: () ->
		@songs

	clear: () ->
		@removeAll()

		if @player
			@player.destroy()

	removeAll: () ->
		if @player
			@stop()
			
		@songs.length = 0



