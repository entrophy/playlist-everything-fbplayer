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
	'soundcloud',

	'mousetrap',
	'jquery.xdomainajax'

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

	app.controller 'PageCtrl', ($scope, $http, $rootScope, $location, FBService, Queue) ->
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

		$scope.login = () ->
			FB.login (response) ->
				console.log "here new:"
				console.log response

				if response.status == "connected"
					$scope.loadPage()

			return false

		$scope.loadPage = () =>
			$scope.resetVisibility()
			$scope.visible.loading = true
			$scope.$apply()

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
					console.log posts

					for post in posts
						song = new Song(post)

						###console.log post.caption
						console.log song###
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

		Mousetrap.bind 'space', () ->
			Queue.playOrPause()
			return false

		Mousetrap.bind 'right', () ->
			Queue.next()
			return false

		Mousetrap.bind 'left', () ->
			Queue.prev()
			return false

	angular.bootstrap(document, ['PlaylistEverythingFacebookPlayer'])
