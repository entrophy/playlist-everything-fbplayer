r = 0
done = () ->
	if ++r == 3
		ready()

define [
	'jquery', 
	'underscore', 
	'angular',
	'youtube',
	'facebook',
	'soundcloud'

	# 'service.fb',
	# 'service.song',

	# 'model.song',
	# 'urlparser',
	# 'player.abstract',
	# 'player.soundcloud',
	# 'player.youtube'
	# 'player',
	# 'queue'
], () ->

	# console.log "jquery"
	# console.log $
	# console.log "underscore"
	# console.log _
	# console.log "angular"
	# console.log angular

	# console.log "SoundCloud"
	# console.log SC

	$(document).ready () ->
		# console.log "document ready"
		done()

window.onYouTubeIframeAPIReady = () =>
	# console.log "YouTube callback"
	# console.log YT
	done()

window.fbAsyncInit = () =>
	# console.log "Facebook callback"
	# console.log FB
	done()

ready = () =>
	console.log 'DONE \\o/ The fun can start'

	$('#preloader').hide()
	$('#wrapper').show()

	FB.init({
		appId: '228230950634896',
		channelUrl: '/fb-channel',
		status: true,
		cookie: true, 
		xfbml: true
	});

	app = angular.module('PlaylistEverythingFacebookPlayer', []).config ($locationProvider) ->
		$locationProvider.html5Mode(true)

	app.service 'FBService', @FBService
	app.service 'Queue', @Queue

	app.controller 'PageCtrl', ($scope, $rootScope, $location, FBService, Queue) ->
		console.log " --> PageCtrl"

		$scope.page = null
		$scope.url = $location.absUrl().split('/').pop()

		($scope.resetVisibility = () ->
			$scope.visible = {}
			$scope.visible.invalid = false
			$scope.visible.private = false
			$scope.visible.page = false
			$scope.visible.search = true
			$scope.visible.loading = false
		)()

		$scope.loadPage = () =>
			$scope.resetVisibility()
			$scope.visible.loading = true

			FBService.setPageUrl($scope.url)

			FBService.getPage (err, page) =>
				if err == "invalid"
					$scope.visible.invalid = true
				else if err == "private"
					$scope.visible.private = true
				else
					$scope.visible.search = false
					$scope.visible.page = true

					$scope.page = page

					$location.path(page.link.split('/').pop())
					$location.replace()

					# YURK!
					$rootScope.$broadcast("loadPosts")

				$scope.visible.loading = false
				$scope.$apply()

			return false

		$scope.unloadPage = () ->
			FBService.clear()

			$scope.page = null
			$scope.resetVisibility()

			$('#url-search').focus()

			# YURK!
			$rootScope.$broadcast("uploadPosts")

			return false

	app.controller 'SongCtrl', ($scope, $rootScope,FBService, Queue) ->
		console.log " --> SongCtrl"

		$scope.songs = []

		($scope.resetVisibility = () ->
			$scope.visible = {}
			$scope.visible.loading = false
			$scope.visible.more = false
		)()

		Queue.on 'add', (song) ->
			$scope.songs = Queue.getAllSongs()
			$scope.$apply()

		# YURK!
		$scope.$on 'loadPosts', () =>
			$scope.loadPosts()
		# YURK!
		$scope.$on 'uploadPosts', () =>
			$scope.unloadPosts()

		$scope.loadPosts = () ->
			if !$scope.visible.loading # if not already loading
				$scope.visible.more = false
				$scope.visible.loading = true

				len = $scope.songs.length

				FBService.getPosts (err, posts) ->
					for post in posts
						song = new Song(post)

						if song.playable
							Queue.add(song)

					$scope.visible.loading = false
					$scope.visible.more = len < $scope.songs.length


					$scope.$apply()

			return false

		$scope.unloadPosts = () ->
			Queue.clear()
			$scope.resetVisibility()

			return false

	app.controller 'ControlsCtrl', ($scope, Queue) ->
		$scope.play = () ->
			Queue.play()

		$scope.pause = () ->
			Queue.pause()

		$scope.stop = () ->
			Queue.stop()

		$scope.next = () ->
			Queue.next()

		$scope.prev = () ->
			Queue.prev()

	# console.log "booootstrap?"
	# angular.element(document).ready () ->
	# 	console.log "reeeady?"
	angular.bootstrap(document, ['PlaylistEverythingFacebookPlayer'])

# console.log "Playlist Everything Facebook Player"

# # todo:
# # [ ] access token time issue
# # [ ] facebook login stopped working
# # [ ] create player

# # todo (not release important):
# # [ ] make cancelling facebook loads possible
# # [ ] make communication between controllers sane
# # [ ] do angular tutorial, damn

# window.fbAsyncInit = () ->
# 	# fb ready
# 	console.log "fb ready"
# 	init.done()

# 	FB.init({
# 		appId: '228230950634896',
# 		channelUrl: '//playlisteverything.eu01.aws.af.cm/fb-channel', # /fb-channel ? 
# 		status: true,
# 		cookie: true, 
# 		xfbml: true
# 	});

# 	FB.Event.subscribe 'auth.authResponseChange', (response) ->
# 		# facebook auth is ready!

# player = new Player()
# player.element 'player'

# queue = new Queue()
# queue.player = player

# $(document).ready () ->
# 	$('#prev').click () ->
# 		console.log "click prev"
# 		queue.prev()
# 	$('#play').click () ->
# 		console.log "click play"
# 		queue.play()
# 	$('#pause').click () ->
# 		console.log "click pause"
# 		queue.pause()
# 	$('#stop').click () ->
# 		console.log "click stop"
# 		queue.pause()
# 	$('#next').click () ->
# 		console.log "click next"
# 		queue.next()

# app = angular.module('PlaylistEverythingFacebookPlayer', []).config ($locationProvider) ->
# 	$locationProvider.html5Mode(true)

# app.service 'SongService', @SongService
# app.service 'FBService', @FBService

# app.controller 'SongsCtrl', ($scope, SongService, FBService) ->
# 	console.log " --> SongsCtrl"

# 	($scope.resetVisibility = () ->
# 		$scope.visible = {}
# 		$scope.visible.loading = false
# 	)()

# 	$scope.songs = []

# 	SongService.on 'add', (song) ->
# 		queue.add(song)
# 		$scope.songs = SongService.all()
# 		$scope.$apply()

# 	SongService.on 'remove', (song) ->
# 		$scope.songs = SongService.all()
# 		$scope.$apply()

# 	$scope.loadPosts = () ->
# 		if !$scope.visible.loading
# 			$scope.visible.loading = true
# 			FBService.getPosts (err, posts) ->
# 				console.log err
# 				SongService.add(posts)
# 				$scope.visible.loading = false

# 			$scope.$apply()

# 		return false

# 	# YURK!
# 	$scope.$on 'loadPosts', () =>
# 		$scope.loadPosts()

# 	# $(window).scroll () ->
# 	# 	if $(window).scrollTop() + $(window).height() == $(document).height()
# 	# 		$scope.loadPosts()

# app.controller 'PageCtrl', ($scope, $rootScope, $location, SongService, FBService) ->
# 	console.log " --> PageCtrl"

# 	($scope.resetVisibility = () ->
# 		$scope.visible = {}
# 		$scope.visible.invalid = false
# 		$scope.visible.private = false
# 		$scope.visible.page = false
# 		$scope.visible.search = true
# 	)()

# 	$scope.page = null
# 	$scope.url = $location.absUrl().split('/').pop()

# 	$scope.loadPage = () =>
# 		$scope.resetVisibility()

# 		FBService.setPageUrl($scope.url)

# 		FBService.getPage (err, page) =>
# 			console.log err
# 			if err == "invalid"
# 				$scope.visible.invalid = true
# 			else if err == "private"
# 				$scope.visible.private = true
# 			else
# 				$scope.visible.search = false
# 				$scope.visible.page = true

# 				$scope.page = page

# 				$location.path(page.link.split('/').pop())
# 				$location.replace()

# 				# YURK!
# 				# $rootScope.$broadcast("loadPosts")

# 			$scope.$apply()

# 		return false

# 	$scope.unloadPage = () ->
# 		$scope.page = null
# 		$scope.resetVisibility()

# 		$('#url-search').focus()

# 		SongService.clear()
# 		FBService.clear()

# 		return false

# 	@

# angular.element(document).ready () ->
# 	angular.bootstrap(document, ['PlaylistEverythingFacebookPlayer'])
		
# do (d = document) ->
# 	id = 'facebook-jssdk'
# 	ref = d.getElementsByTagName('script')[0]

# 	if !d.getElementById(id)
# 		js = d.createElement('script')
# 		js.id = id
# 		js.async = true
# 		js.src = '//connect.facebook.net/en_US/all.js'
# 		ref.parentNode.insertBefore(js, ref)