ArtistModel = require 'models/artistModel'
ArtistCollection = require 'models/artistCollection'	
GraphView = require 'views/GraphView'	
BiosView = require 'views/BiosView'	
Nodes = new ArtistCollection

module.exports = class NetworkView extends Backbone.Marionette.LayoutView
	template: 'views/templates/network'
	id: 'main-content'
	$el: $('#main-content')
	# el: 'div'
	regions:
		regionBios: "#region-bios"
		regionGraph: "#region-graph"
	initialize: ->
		
		# Nodes.fetch
		# 	done: (data)->
		# 		console.log "network view"
		# 		@collection = Nodes
		# 		console.log "Nodes", Nodes
		# 		@render
		# 	@collection = Nodes	
  #   	@listenTo(@collection, "change:model")
	
	# onBeforeRender: ->
	# 	console.log "onBeforeRender"
	# 	console.log "@collection", @collection
	onShow: ->
		console.log @regionManager
		@regionManager.addRegions @regions
		console.log "regions", @regions
		# console.log "collection", @collection
		width = 960
		height = 500
		# @graphView = new GraphView()
		# @regionGraph.show(@graphView)
		@biosView = new BiosView()
		@regionBios.show(@biosView)	
		# svg = d3.select("network-view").append("svg").attr("width", width).attr("height", height)

		# force = d3.layout.force().gravity(.05).distance(100).charge(-100).size([width, height])
		# for each in @collection
			# console.log "each", each

		# force.nodes(nodes).links(links).start()


	
