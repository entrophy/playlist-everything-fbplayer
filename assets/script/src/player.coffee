link = "http://www.youtube.com/watch?v=FU4cnelEdi4"
id = "FU4cnelEdi4"

sclink = "https://soundcloud.com/noisia/mark-knight-ft-skin-nothing"



@Player.ready = () ->

	player = new Player()
	player.element 'player'

	queue = new Queue()
	queue.player = player

	url = 'https://soundcloud.com/noisia/mark-knight-ft-skin-nothing'
	url = 'http://www.youtube.com/watch?v=FU4cnelEdi4'

	queue.add { 
		link: 'https://soundcloud.com/noisia/mark-knight-ft-skin-nothing'
	}

	queue.add { 
		link: 'http://www.youtube.com/watch?v=FU4cnelEdi4'
	}

	# hack
	queue.load()


	$('#prev').click () ->
		console.log "click prev"
		queue.prev()
	$('#play').click () ->
		console.log "click play"
		queue.play()
	$('#pause').click () ->
		console.log "click pause"
		queue.pause()
	$('#stop').click () ->
		console.log "click stop"
		queue.pause()
	$('#next').click () ->
		console.log "click next"
		queue.next()

	# youtube = new Player.Youtube()
	# youtube.element 'ytplayer'
	# youtube.load 'FU4cnelEdi4'

	# $('#ytplay').click () ->
	# 	console.log "click play!"
	# 	youtube.play()
	# $('#ytpause').click () ->
	# 	youtube.pause()
	# 	console.log "click pause"
	# $('#ytstop').click () ->
	# 	youtube.stop()
	# 	console.log "click stop"

	# soundcloud = new Player.Soundcloud()
	# soundcloud.element 'scplayer'
	# soundcloud.load 'https://soundcloud.com/noisia/mark-knight-ft-skin-nothing'

	# $('#scplay').click () ->
	# 	console.log "click play!"
	# 	soundcloud.play()
	# $('#scpause').click () ->
	# 	soundcloud.pause()
	# 	console.log "click pause"
	# $('#scstop').click () ->
	# 	soundcloud.stop()
	# 	console.log "click stop"

# 	"player api ready"
# @onYouTubeIframeAPIReady = () ->
# 	console.log "WAT!"
# 	player = new YT.Player 'ytplayer', {
# 		height: '390',
# 		width: '640',
# 		videoId: 'FU4cnelEdi4',
# 		events: {
# 			onPlayerReady: () ->
# 				console.log "onPlayerReady"
# 				console.log arguments
# 			onReady: () ->
# 				console.log "onReady"
# 				console.log arguments
# 				# this is the shit

# 			onPlayerStateChange: () ->
# 				console.log "onPlayerStateChange"
# 				console.log arguments
# 			onStateChange: () ->
# 				console.log "onStateChange"
# 				console.log arguments
# 		}
# 	}

# 	$('#ytplay').click () ->
# 		console.log "click play"
# 		player.playVideo()
# 	$('#ytpause').click () ->
# 		player.pauseVideo()
# 		console.log "click pause"
# 	$('#ytstop').click () ->
# 		player.stopVideo()
# 		console.log "click stop"

# 	console.log player

# widget = SC.Widget('scplayer')
# widget.load "https://soundcloud.com/noisia/mark-knight-ft-skin-nothing", {
# 	show_comments: false,
# 	liking: false,
# 	sharing: false,
# 	buying: false,
# 	download: false
# }

# widget.bind SC.Widget.Events.READY, () ->
# 	console.log "SC.Widget.Events.READY"
# 	console.log arguments

# $('#scplay').click () ->
# 		widget.play()
# 		console.log "click play"
# 	$('#scpause').click () ->
# 		widget.pause()
# 		console.log "click pause"
# 	$('#scstop').click () ->
# 		widget.pause()
# 		console.log "click stop"

# load
# play, pause stop
# events: ready!