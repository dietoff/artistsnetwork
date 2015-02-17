ArtistsModule = require 'lib/graphModule'
application = require 'application'
module.exports = class GraphView extends Backbone.Marionette.ItemView
	template: 'views/templates/graph'
	# id: 'region-graph'

	onShow: ->
		# application.module 'GraphModule', (GraphModule, template) ->
		# 	this == GraphModule
		# 	myData = 'this is private data'
		# 	myFunction = ->
		#     	console.log "is thereany other way??"
		#     	return

		#   # Public Data And Functions
		#   # -------------------------
		#   	GraphModule.someData = 'public data'

		#   	GraphModule.someFunction = ->
		#   		console.log "look like this is working!"
		#   		return
		#     return
		console.log "inside graph item view"
		application.GraphModule.someFunction()