
class @PlayerSoundcloud extends @PlayerAbstract
	constructor: () ->

	element: (@id) ->

	#element: (@element) ->
		#@_player = SC.Widget(@element)

	load: (url, callback) ->
		#@element.style.display = 'block'

		@create()
		#$('#pe-player-soundcloud').show()

		@_player = SC.Widget($('#pe-player-soundcloud')[0])

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

		@_player.bind SC.Widget.Events.READY, () ->
			callback()

	finish: (callback) ->
		@_player.bind SC.Widget.Events.FINISH, callback
			
	play: () ->
		@_player.play()

	pause: () ->
		@_player.pause()

	stop: () ->
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
		#elem.hide()

		$('#' + @id).append(elem);

	destroy: () ->
		console.log "soundcloud destroy"

		$('#pe-player-soundcloud').remove()