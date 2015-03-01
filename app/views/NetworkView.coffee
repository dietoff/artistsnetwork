# load the requirements
# ArtistModel = require 'models/artistModel'
# ArtistCollection = require 'models/artistCollection'	
application = require 'application'
GraphModule = require 'lib/graphModule'
GraphView = require 'views/GraphView'	
OrgGraphView = require 'views/OrgGraphView'	
BiosView = require 'views/BiosView'	
# Nodes = new ArtistCollection

module.exports = class NetworkView extends Backbone.Marionette.LayoutView
	template: 'views/templates/network'
	id: 'main-content'
	$el: $('#main-content')
	ui: 'switch-organization' : '#organization'
	triggers: 'click @ui.switch-organization' : 'switch-organization:do:view'
	# el: 'div'
	# setup two primary regions 
	regions:
		mapGraph: "#map-region"
		regionBios: "#region-bios"
		regionGraph: "#region-graph"
	initialize: ->
		@regionManager.addRegions @regions
		# application.module("HeaderFooter").start()
	onShow: ->
		$(document).ready =>
			
			# @el = $('#region-bios')
			# ajax the data, when load setup
				# application.GraphModule.makeControler(@$el, Width, Height, _margin, text,  @_m)	
				# console.log "@_m", @_m
				# console.log textControl
				# @_m.whenReady =>
					# console.log "mapredy"
					# console.log d3.select($("#bios-list")[0])[0]
			# 		d3.selectAll("text").attr("x", () ->
			# 			return $(@).position().left
			# 		).attr("y", () ->
			# 			return $(@).position().top
			# 		)
			# 		console.log $("#region-bios")[0]
			# $("li").on 'mouseover', (e) =>
			# 	console.log "gets the mouse over"
				# @el = $('#region-bios')
				# creat a DOM elements and add to the view
		# application.GraphModule.makeMap()
		console.log application
		# do when view is rendered
		# @regionManager.addRegions @regions
		@on "switch-organization:do:view", =>
			console.log "switch-organization trigger"
			# @remove(@graphView)
			# @getRegion('content').show(@networkView)
			# @regionBios.show(@graphView)
			@biosView = new BiosView()			
			@regionBios.show(@biosView)
			@orgGraphView = new OrgGraphView()
			@regionGraph.show(@orgGraphView)
			application.GraphModule.Controller.makeOrgGraph()
		@biosView = new BiosView()
		@graphView = new GraphView()
		@regionGraph.show(@graphView)
		@regionBios.show(@biosView)
		


	
