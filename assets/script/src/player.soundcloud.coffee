
class @PlayerSoundcloud extends @PlayerAbstract
	constructor: () ->

	element: (@id) ->

	load: (url, callback) ->
		@create()
		@_player = SC.Widget($('#pe-player-soundcloud')[0])

		@_player.bind SC.Widget.Events.READY, () ->
			callback()

		@_player.load url, {
			show_comments: false,
			liking: false,
			sharing: false,
			buying: false,
			download: false,
			show_artwork: false,
			show_playcount: false,
			show_comments: false,
			show_user: false
		}

	finish: (callback) ->
		if @_player
			@_player.bind SC.Widget.Events.FINISH, callback
			
	play: () ->
		if @_player
			@_player.play()

	pause: () ->
		if @_player
			@_player.pause()

	stop: () ->
		if @_player
			@_player.pause()

	create: () ->
		console.log "soundcloud create"

		elem = $('<iframe />');
		elem.attr('id', 'pe-player-soundcloud')
		elem.attr('src', 'https://w.soundcloud.com/player/?url=')
		elem.attr('frameborder', 'no')
		elem.attr('scrolling', 'no')
		elem.attr('width', '100%')
		elem.attr('height', '200')

		$('#' + @id).append(elem)

	destroy: () ->
		console.log "soundcloud destroy"

		$('#pe-player-soundcloud').remove()