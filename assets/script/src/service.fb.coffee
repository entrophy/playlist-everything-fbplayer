class @FBService
	constructor: () ->
		@_posts = []
		@_url = null
		@_nextUrl = null

	setPageUrl: (url) ->
		@_url = $.trim(url)

	getPageUrl: () ->
		@_url

	getPostUrl: () ->
		@_url + '/posts'

	getNextPostUrl: () ->
		if @_nextUrl
			@_nextUrl
		else
			@_url + '/posts'

	# getGroup: (callback) ->
	# 	err = null
	# 	page = null

	# 	console.log "get group"

	# 	if @getPageUrl()
	# 		url = 'https://www.facebook.com/groups/' + @getPageUrl() + '/'

	# 		FB.api '/me/groups', (response) ->
	# 			console.log response

	# 			if response.error
	# 				switch response.error.code
	# 					else err = "private"

	# 				callback(err, page)
	# 			else
	# 				console.log "GOT GROUPS LOL"

	getPage: (callback) ->
		err = null
		page = null

		if @getPageUrl()
			FB.api @getPostUrl(), (response) =>
				console.log response
				if response.error
					switch response.error.code
						when 803 then err = "invalid"
						else err = "private"

					console.log "HER FØRST"
					callback(err, page)
				else
					FB.api @getPageUrl(), (response) =>
						if response.error
							switch response.error.code
								when 803 then err = "invalid"
								when 104 then err = "private"

							callback(err, page)
						else
							page = response

							console.log "HER BAGEFTER"
							callback(err, page)

	getPosts: (callback) ->
		err = null
		posts = []

		FB.api @getNextPostUrl() , (response) =>
			console.log response
			if response.error
				switch response.error.code
					when 803 then err = "invalid"
					when 104 then err = "private"

				callback(err, posts)
			else
				console.log response.paging
				if (response.paging)
					@_nextUrl = response.paging.next

				# posts = @_posts = @_posts.concat(response.data)
				posts = response.data

				callback(err, posts)

	clear: () ->
		@_posts = []
		@_url = null
		@_nextUrl = null