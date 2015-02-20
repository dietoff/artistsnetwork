# load the requirements
# ArtistModel = require 'models/artistModel'
# ArtistCollection = require 'models/artistCollection'	
application = require 'application'
GraphView = require 'views/GraphView'	
BiosView = require 'views/BiosView'	
# Nodes = new ArtistCollection

module.exports = class NetworkView extends Backbone.Marionette.LayoutView
	template: 'views/templates/network'
	id: 'main-content'
	$el: $('#main-content')
	# el: 'div'
	# setup two primary regions 
	regions:
		mapGraph: "#map-region"
		regionBios: "#region-bios"
		regionGraph: "#region-graph"
	initialize: ->

	onShow: ->
		application.GraphModule.makeMap()
		@regionManager.addRegions @regions
		# do when view is rendered
		# @regionManager.addRegions @regions
		
		@biosView = new BiosView()
		# @graphView = new GraphView()
		@regionBios.show(@biosView)
		# @regionNetwork.show(@graphView)
		


	
