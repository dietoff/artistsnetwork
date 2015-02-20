# load the requirements
# ArtistModel = require 'models/artistModel'
# ArtistCollection = require 'models/artistCollection'	
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
		regionBios: "#region-bios"
		regionGraph: "#region-graph"
	initialize: ->

	onShow: ->
		# do when view is rendered
		@regionManager.addRegions @regions
		@graphView = new GraphView()
		@regionGraph.show(@graphView)
		


	
