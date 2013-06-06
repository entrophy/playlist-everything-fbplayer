
type_map = {
	'www.youtube.com': 'Youtube'
	'soundcloud.com': 'Soundcloud'
}

class @Song
	@YOUTUBE: 'Youtube'
	@SOUNDCLOUD: 'Soundcloud'

	url_domain: (url) ->
		a = document.createElement 'a'
		a.href = url
		a.hostname

	constructor: (data) ->
		@id = data.id
		@title = data.name

		@link = data.link
		@domain = @url_domain @link

		@origin = type_map[@domain]
		@playable = !!@origin