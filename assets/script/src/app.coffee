console.log "Playlist Everything Facebook Player"

# todo:
# [ ] access token time issue
# [ ] facebook login stopped working
# [ ] create player

# todo (not release important):
# [ ] make cancelling facebook loads possible
# [ ] make communication between controllers sane
# [ ] do angular tutorial, damn

FBLoadedCallback = () ->
	console.log "NIOPE"

window.fbAsyncInit = () ->
	FB.init({
		appId: '228230950634896',
		channelUrl: '//playlisteverything.eu01.aws.af.cm/fb-channel', # /fb-channel ? 
		status: true,
		cookie: true, 
		xfbml: true
	});

	FB.Event.subscribe 'auth.authResponseChange', (response) ->
		FBLoadedCallback()

player = new Player()
player.element 'player'

queue = new Queue()
queue.player = player

$(document).ready () ->
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



app = angular.module('PlaylistEverythingFacebookPlayer', []).config ($locationProvider) ->
	$locationProvider.html5Mode(true)

app.service 'SongService', @SongService
app.service 'FBService', @FBService

app.controller 'SongsCtrl', ($scope, SongService, FBService) ->
	console.log " --> SongsCtrl"

	($scope.resetVisibility = () ->
		$scope.visible = {}
		$scope.visible.loading = false
	)()

	$scope.songs = []

	SongService.on 'add', (song) ->
		queue.add(song)
		$scope.songs = SongService.all()
		$scope.$apply()

	SongService.on 'remove', (song) ->
		$scope.songs = SongService.all()
		$scope.$apply()

	$scope.loadPosts = () ->
		if !$scope.visible.loading
			$scope.visible.loading = true
			FBService.getPosts (err, posts) ->
				console.log err
				SongService.add(posts)
				$scope.visible.loading = false

			$scope.$apply()

		return false

	# YURK!
	$scope.$on 'loadPosts', () =>
		$scope.loadPosts()

	$(window).scroll () ->
		if $(window).scrollTop() + $(window).height() == $(document).height()
			$scope.loadPosts()

app.controller 'PageCtrl', ($scope, $rootScope, $location, SongService, FBService) ->
	console.log " --> PageCtrl"

	($scope.resetVisibility = () ->
		$scope.visible = {}
		$scope.visible.invalid = false
		$scope.visible.private = false
		$scope.visible.page = false
		$scope.visible.search = true
	)()

	$scope.page = null
	$scope.url = $location.absUrl().split('/').pop()

	$scope.loadPage = () =>
		$scope.resetVisibility()

		FBService.setPageUrl($scope.url)

		FBService.getPage (err, page) =>
			console.log err
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

			$scope.$apply()

		return false

	$scope.unloadPage = () ->
		$scope.page = null
		$scope.resetVisibility()

		$('#url-search').focus()

		SongService.clear()
		FBService.clear()

		return false

	FBLoadedCallback = () =>
		if $scope.url
			$scope.loadPage()


	# setTimeout () => 
	# 	if $scope.url
	# 		$scope.loadPage()
	# , 400

	@


		
do (d = document) ->
	id = 'facebook-jssdk'
	ref = d.getElementsByTagName('script')[0]

	if !d.getElementById(id)
		js = d.createElement('script')
		js.id = id
		js.async = true
		js.src = '//connect.facebook.net/en_US/all.js'
		ref.parentNode.insertBefore(js, ref)