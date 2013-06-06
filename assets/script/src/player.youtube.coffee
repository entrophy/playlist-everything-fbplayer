
class @PlayerYoutube extends @PlayerAbstract
	constructor: () ->

	element: (@id) ->

	load: (url, callback) ->
		@create()

		@_player = new YT.Player 'pe-player-youtube', {
			height: '200',
			width: '328',
			videoId: url,
			playerVars: {
				modestbranding: 1,
				controls: 0
			},
			events: {
				onReady: () ->
					callback()

				onStateChange: (event) =>
					if event.data == 0
						if @finishcallback
							@finishcallback()
				
			}
		}

	finish: (callback) ->
		console.log "youtube bind finish"
		@finishcallback = callback

	play: () ->
		if @_player
			@_player.playVideo()

	pause: () ->
		if @_player
			@_player.pauseVideo()

	stop: () ->
		if @_player
			@_player.stopVideo()

	create: () ->
		elem = $('<div />')
		elem.attr('id', 'pe-player-youtube')

		$('#' + @id).append(elem);

	destroy: () ->
		console.log "youtube destroy"

		$('#pe-player-youtube').remove()
		