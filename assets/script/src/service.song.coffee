# safeMap = (data, callback) ->
# 	if _.isArray(data)
# 		for item in data
# 			callback(item)
# 	else
# 		callback(data)

# class @SongService
# 	constructor: () ->
# 		@songs = []
# 		@songs_by_id = {}

# 		@callbacks = []

# 	exists: (song) ->
# 		@songs_by_id[song.id]

# 	add: (data) ->
# 		if _.isArray(data)
# 			for item in data
# 				@add(item)
# 		else
# 			song = new window.Song(data)

# 			if song.playable && !@exists(song)
# 				@songs_by_id[song.id] = song
# 				@songs.push(song)

# 				for callback in @callbacks['add'] || []
# 					callback.call(@, song)

# 	clear: () ->
# 		@songs.length = []
# 		@songs_by_id = {}

# 	on: (event, callback) ->
# 		(@callbacks[event] = @callbacks[event] || []).push(callback)

# 	all: () ->
# 		@songs