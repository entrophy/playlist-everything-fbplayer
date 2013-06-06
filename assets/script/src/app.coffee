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

	'mousetrap'
], () ->
	$(document).ready () ->
		done()

window.onYouTubeIframeAPIReady = () =>
	done()

window.fbAsyncInit = () =>
	done()

ready = () =>
	app = angular.module('PlaylistEverythingFacebookPlayer', []).config ($locationProvider) ->
		$locationProvider.html5Mode(true)

	app.service 'FBService', @FBService
	app.service 'Queue', @Queue

	FB.init({
		appId: '228230950634896',
		channelUrl: '/fb-channel',
		status: true,
		cookie: true, 
		xfbml: true
	});

	FB.getLoginStatus (response) ->
		$('#preloader').hide()
		$('#wrapper').show()

	app.controller 'LoginCtrl', ($scope) ->
		$scope.visible = false

		FB.getLoginStatus (response) ->
			if response.status != "connected"
				$scope.$apply () ->
					$scope.visible = true
			else
				$scope.$apply () ->
					$scope.visible = false

			
		FB.Event.subscribe 'auth.authResponseChange', (response) ->
			if response.status != "connected"
				$scope.$apply () ->
					$scope.visible = true
			else
				$scope.$apply () ->
					$scope.visible = false
				
		$scope.login = () ->
			FB.login (response) ->
				if response.status == "connected"
					$scope.visible = false
			, { scope: 'user_groups' }
					
			return false

	app.controller 'AppCtrl', ($scope) ->
		$scope.visible = false

		FB.Event.subscribe 'auth.authResponseChange', (response) ->
			if response.status == "connected"
				$scope.$apply () ->
					$scope.visible = true
			else
				$scope.$apply () ->
					$scope.visible = false


	app.controller 'PageCtrl', ($scope, $rootScope, FBService) ->
		$scope.url = ''

		($scope.resetVisibility = () ->
			$scope.visible = {}
			$scope.visible.all = true
			$scope.visible.invalid = false
			$scope.visible.loading = false
		)()

		$scope.selectPage = () =>
			if $scope.url
				$scope.resetVisibility()
				$scope.visible.loading = true

				FBService.setType('page')
				FBService.setUrl($scope.url)

				FBService.getPage (err, page) =>
					$scope.$apply () ->
						$scope.visible.loading = false

						if err == "invalid"
							$scope.visible.invalid = true
						else
							$scope.visible.all = false
							$rootScope.$broadcast("selectPage", page)
				
			return false

		$scope.$on 'select', () ->
			$scope.resetVisibility()
			$scope.visible.all = false

		$scope.$on 'deselect', () ->
			$scope.resetVisibility()

	app.controller 'GroupCtrl', ($scope, $rootScope, FBService) ->
		$scope.groups = []

		($scope.resetVisibility = () ->
			$scope.visible = {}
			$scope.visible.all = true
			$scope.visible.loading = false
		)()

		FB.Event.subscribe 'auth.authResponseChange', (response) ->
			if response.status == "connected"
				$scope.$apply () ->
					$scope.visible.loading = true

				FBService.getGroups (err, groups) ->
					$scope.$apply () ->
						$scope.visible.loading = false
						$scope.groups = groups
			else
				$scope.$apply () ->
					$scope.visible.loading = false


		$scope.selectGroup = (group) ->
			$scope.visible.all = false

			FBService.setType('group')
			FBService.setUrl(group.id)

			$rootScope.$broadcast 'selectGroup', group

		$scope.$on 'select', () ->
			$scope.resetVisibility()
			$scope.visible.all = false

		$scope.$on 'deselect', () ->
			$scope.resetVisibility()


	app.controller 'InfoCtrl', ($scope, $rootScope) ->
		$scope.visible = false

		$scope.title = ''
		$scope.description = ''

		$scope.$on 'selectGroup', (event, group) ->
			$scope.title = group.name
			$scope.description = ''
			$scope.visible = true

			$rootScope.$broadcast 'select'

		$scope.$on 'selectPage', (event, page) ->
			$scope.title = page.name
			$scope.description = page.about
			$scope.visible = true

			$rootScope.$broadcast 'select'

		$scope.deselect = () ->
			$scope.visible = false

			$rootScope.$broadcast 'deselect'


	app.controller 'QueueCtrl', ($scope, FBService, Queue) ->
		($scope.resetVisibility = () ->
			$scope.visible = {}
			$scope.visible.all = false
			$scope.visible.loading = false
			$scope.visible.more = false
		)()

		$scope.songs = []
		$scope.current = 0

		$scope.loadSongs = () ->
			if !$scope.visible.loading # if not already loading
				$scope.visible.more = false
				$scope.visible.loading = true

				len = $scope.songs.length

				FBService.getItems (err, items) ->
					for item in items
						song = new Song(item)

						if song.playable
							Queue.add(song)

					$scope.$apply () ->
						$scope.visible.loading = false
						$scope.visible.more = len < $scope.songs.length

		$scope.play = (index) ->
			Queue.playByIndex(index)

		$scope.pause = () ->
			Queue.pause()

		Queue.on 'add', (song) ->
			$scope.$apply () ->
				$scope.songs = Queue.getAllSongs()

		Queue.on 'change', (song, index) ->
			$scope.$apply () ->
				$scope.current = index

		Queue.on 'last', () ->
			$scope.$apply () ->
				$scope.loadSongs()
			
		$scope.$on 'selectPage', (event, page) ->
			$scope.visible.all = true
			$scope.loadSongs()

		$scope.$on 'selectGroup', (event, group) ->
			$scope.visible.all = true
			$scope.loadSongs()

		$scope.$on 'deselect', (event) ->
			$scope.resetVisibility()
			Queue.clear()
			FBService.clear()

	app.controller 'ControlsCtrl', ($scope, Queue) ->
		$scope.visible = false

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

		$scope.$on 'select', (event) ->
			$scope.visible = true

		$scope.$on 'deselect', (event) ->
			$scope.visible = false

	angular.bootstrap(document, ['PlaylistEverythingFacebookPlayer'])
