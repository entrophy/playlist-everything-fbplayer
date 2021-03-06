class @Queue
	constructor: () ->
		console.log "QUEUE constructor"
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
			@emit 'play', []
			@loadAndPlay()

		@emit 'add', [song]

	removeByIndex: (index) ->
		console.log index
		@songs.splice(index, 1)

	play: () ->
		@playing = true
		@emit 'play', []

		if @player
			@player.play()

	playByIndex: (index) ->
		@stop()
		@index = index
		@emit 'change', [@index]
		@playing = true
		@emit 'play', []
		@loadAndPlay()

	pause: () ->
		@playing = false
		@emit 'pause', []

		if @player
			@player.pause()

	playOrPause: () ->
		if @player
			if @isPlaying()
				@pause()
			else
				@play()

	playOrPauseByIndex: (index) ->
		if @player
			if @isPlaying()
				@pause()
			else
				@playByIndex(index)

	stop: () ->
		@playing = false
		@emit 'stop', []

		if @player
			@player.stop()

	prev: () ->
		if @index - 1 >= 0
			@index--
			@emit 'change', [@index]

			@loadAndPlay()

	next: () ->
		if @index + 1 < @songs.length
			@index++
			@emit 'change', [@index]

			@loadAndPlay()

	load: () ->
		if @player
			if (song = @songs[@index])
				player = @player.load song.link, () =>
					@player.finish () =>
						@next()

					@emit 'load', [@index]

					if @index == @songs.length - 1
						@emit 'last'

					return

				player.error (error) =>
					@next()

	loadAndPlay: () ->
		if @player
			if (song = @songs[@index])
				player = @player.load song.link, () =>
					@player.finish () =>
						@next()

					if @isPlaying()
						@play()

					@emit 'load', [@index]

					if @index == @songs.length - 1
						@emit 'last'

				player.error (error) =>
					@next()

	isPlaying: () ->
		return @playing

	on: (event, callback) ->
		(@callbacks[event] = @callbacks[event] || []).push(callback)

	emit: (event, args = []) ->
		for callback in @callbacks[event] || []
			callback.apply(@, args)

	getAllSongs: () ->
		@songs

	clear: () ->
		@removeAll()
		@index = 0
		@playing = false
		@emit 'stop', []

		if @player
			@player.destroy()

	removeAll: () ->
		if @player
			@stop()

		@songs.length = 0
