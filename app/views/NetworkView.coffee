# load the requirements
# ArtistModel = require 'models/artistModel'
# ArtistCollection = require 'models/artistCollection'	
application = require 'application'
GraphModule = require 'lib/graphModule'
GraphView = require 'views/GraphView'	
BiosView = require 'views/BiosView'	
# Nodes = new ArtistCollection

module.exports = class NetworkView extends Backbone.Marionette.LayoutView
	template: 'views/templates/network'
	id: 'main-content'
	$el: $('#main-content')
	ui: 'switch' : '#switch-icon'
	triggers: 'click @ui.switch' : 'switch:do:view'
	# el: 'div'
	# setup two primary regions 
	regions:
		mapGraph: "#map-region"
		regionBios: "#region-bios"
		regionGraph: "#region-graph"
	initialize: ->

	onShow: ->
		$(document).ready =>
		# application.GraphModule.makeMap()
		@regionManager.addRegions @regions
		console.log application
		# do when view is rendered
		# @regionManager.addRegions @regions
		
		@biosView = new BiosView()
		@regionBios.on "show", =>
			@on "switch:do:view", =>
				console.log @regionGraph
				console.log @, this
				console.log _this
		@regionBios.show(@biosView)
		@graphView = new GraphView()
		
		@regionGraph.show(@graphView)

	
		


	
