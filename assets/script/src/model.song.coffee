
type_map = {
	'www.youtube.com': 'Youtube'
	'soundcloud.com': 'Soundcloud'
}

class @Song
	@YOUTUBE: 'Youtube'
	@SOUNDCLOUD: 'Soundcloud'

	constructor: (data) ->
		@id = data.id
		@title = data.name

		@link = data.link

		@origin = type_map[data.caption]
		@playable = !!@origin