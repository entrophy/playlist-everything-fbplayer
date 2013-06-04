class Initializer
	constructor: () ->
		@callbacks = []

	ready: (callback) ->
		@callbacks.push(callback)

	done: _.after 3, () ->
		setTimeout () =>
			for callback in @callbacks
				callback()

			$('#wrapper').show()
			$('#preloader').hide()
		, 1000

@init = new Initializer()

$(document).ready () ->
	# jquery ready
	console.log "jquery ready"
	init.done()