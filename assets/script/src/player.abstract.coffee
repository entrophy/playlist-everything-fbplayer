class @PlayerAbstract

	constructor: () ->

	element: (element) ->
		throw new Error "element(element): Unimplemented"

	load: (url) ->
		throw new Error "load(url): Unimplemented"

	play: () ->
		throw new Error "play(): Unimplemented"

	pause: () ->
		throw new Error "pause(): Unimplemented"

	stop: () ->
		throw new Error "stop(): Unimplemented"

	on: (event, callback) ->
		throw new Error "on(event, callback): Unimplemented"

	destroy: () ->
		throw new Error "destroy(): Unimplemented"