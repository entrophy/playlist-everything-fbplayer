class @FBService
	constructor: () ->
		@type = null
		@url = null
		@nextUrl = null

		@request = 0

	setType: (@type) ->

	setUrl: (url) ->
		@url = $.trim(url)
		@url = @url.split('?')
		@url = @url.shift()

	getUrl: () ->
		@url

	getItemUrl: () ->
		if @type == 'page'
			@_url + '/posts'
		else if @type == 'group'
			@_url + '/feed'

	getNextItemUrl: () ->
		if @nextUrl
			@nextUrl
		else
			if @type == 'page'
				@url + '/posts'
			else if @type == 'group'
				@url + '/feed'

	getPage: (callback) ->
		err = null
		page = null

		if @getUrl()

			do (r = @request) =>
				FB.api @getItemUrl(), (response) =>
					if r == @request
						if response.error
							switch response.error.code
								when 803 then err = "invalid"
								else err = "private"

							callback(err, page)
						else
							do (r = @request) =>
								FB.api @getUrl(), (response) =>
									if r == @request
										if response.error
											switch response.error.code
												when 803 then err = "invalid"
												when 104 then err = "private"

											callback(err, page)
										else
											page = response

											callback(err, page)

	getGroups: (callback) ->
		err = null
		groups = []

		do (r = @request) =>
			FB.api '/me/groups', (response) =>
				if r == @request
					groups = response.data

					callback(err, groups)

	getItems: (callback) ->
		err = null
		items = []

		do (r = @request) =>
			FB.api @getNextItemUrl(), (response) =>
				if r == @request
					if response.error
						switch response.error.code
							when 803 then err = "invalid"
							else err = "private"

						callback(err, items)
					else
						if (response.paging)
							@nextUrl = response.paging.next

						items = response.data

						callback(err, items)

	clear: () ->
		@type = null
		@url = null
		@nextUrl = null
		@request++
