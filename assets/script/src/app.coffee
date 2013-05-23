console.log "Playlist Everything Facebook Player"

class SongService
	constructor: () ->
		@songs = []
		@callbacks = []

	add: (song) ->
		for callback in @callbacks['add'] || []
			callback.call(@, song)

	on: (event, callback) ->
		(@callbacks[event] = @callbacks[event] || []).push(callback)

app = angular.module('PlaylistEverythingFacebookPlayer', [])

app.factory 'SongService', () ->
	new SongService()

app.controller 'SongListCtrl', ($scope, SongService) ->
	$scope.songs = [{ title: 'test' }]

	SongService.on 'add', (song) ->
		console.log "!!!"
		console.log song

	@

app.controller 'UrlSearchCtrl', ($scope, SongService) ->
	$scope.url = undefined
	$scope.invalid = false
	$scope.private = false

	console.log ("here")

	$scope.change = _.debounce () =>
		console.log $scope.url

		$scope.invalid = false
		$scope.private = false
		$scope.$apply()

		# need to parse groups

		if $scope.url
			FB.api $scope.url, (response) ->
				if response.error && response.error.code == 803
					# page does not exist
					$scope.invalid = true
					$scope.$apply()

				else
					#page does exists
					$scope.invalid = false
					$scope.$apply()

					FB.api $scope.url + '/posts', (response) ->
						if response.error && response.error.code == 104
							# requires access
							$scope.private = true
							$scope.$apply()
						else
							# is public
							$scope.private = false
							$scope.$apply()

							console.log response
							SongService.add({ title: 'a song' })
							

		# test
		# FB.api 'http://www.facebook.com/electronicnstuff', (response) ->
		# 	console.log (response)

		# if !$scope.isValid($scope.url)
		# 	console.log "NOPE"
		# else if !$scope.isPublic($scope.url)
		# 	console.log "NOPE"
		# else
		# 	console.log "YES"
			# todo: load the content (valid and public)
	, 400

	$scope.isValid = (url) ->
		console.log "checking if valid"
		# todo: check if the url is a facebook page or group through the FB api

		return false

	$scope.isPublic = (url) ->
		console.log "checking if public"
		# todo: check if the page or group is public available or requires login through the FB api

		return false

	@

window.fbAsyncInit = () ->
	FB.init({
		appId: '228230950634896',
		channelUrl: '//www.playlist-everything.dk:3000/fb-channel', # /fb-channel ? 
		status: true,
		cookie: true, 
		xfbml: true
	});

	FB.Event.subscribe 'auth.authResponseChange', (response) ->
		if response.status == 'connected'
			testAPI()
		else if response.status == 'not_authorized'
			FB.login()
		else
			FB.login()
		
do (d = document) ->
	id = 'facebook-jssdk'
	ref = d.getElementsByTagName('script')[0]

	if !d.getElementById(id)
		js = d.createElement('script')
		js.id = id
		js.async = true
		js.src = '//connect.facebook.net/en_US/all.js'
		ref.parentNode.insertBefore(js, ref)

testAPI = () ->
	console.log('Welcome!  Fetching your information.... ');

	FB.api '/me', (response) ->
		console.log('Good to see you, ' + response.name + '.');


$('document').ready () ->
