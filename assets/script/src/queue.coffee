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
		@songs.push(song)

		if @songs.length == 1
			@playing = true
			@loadAndPlay()

		for callback in @callbacks['add'] || []
			callback.call(@, song)

	removeByIndex: (index) ->
		console.log index
		@songs.splice(index, 1)

	play: () ->
		@playing = true

		if @player
			@player.play()

	playByIndex: (index) ->
		@stop()
		@index = index
		@playing = true
		@loadAndPlay()

	pause: () ->
		console.log "PAUSING"
		@playing = false

		if @player
			@player.pause()

	playOrPause: () ->
		if @player
			if @isPlaying()
				@pause()
			else
				@play()

	stop: () ->
		@playing = false

		if @player
			@player.stop()

	prev: () ->
		if @index - 1 >= 0
			@index--

			@loadAndPlay()

	next: () ->
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
