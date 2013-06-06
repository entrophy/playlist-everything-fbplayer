class @FBService
	constructor: () ->
		@type = null
		@url = null
		@nextUrl = null

	setType: (@type) ->

	setUrl: (url) ->
		@url = $.trim(url)

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
			FB.api @getItemUrl(), (response) =>
				if response.error
					switch response.error.code
						when 803 then err = "invalid"
						else err = "private"

					callback(err, page)
				else
					FB.api @getUrl(), (response) =>
						if response.error
							switch response.error.code
								when 803 then err = "invalid"
								when 104 then err = "private"

							callback(err, page)
						else
							page = response

							callback(err, page)

	getItems: (callback) ->
		err = null
		items = []

		FB.api @getNextItemUrl() , (response) =>
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