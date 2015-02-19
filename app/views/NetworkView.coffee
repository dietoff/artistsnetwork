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
	regions:
		regionBios: "#region-bios"
		regionGraph: "#region-graph"
	initialize: ->

	onShow: ->
		@regionManager.addRegions @regions
		width = 960
		height = 500
		@graphView = new GraphView()
		@regionGraph.show(@graphView)
		


	
