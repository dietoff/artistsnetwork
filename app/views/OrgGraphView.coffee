# ArtistsModule = require 'lib/graphModule'
application = require 'application'
# Butterfly = require 'lib/Butterfly'
module.exports = class OrgGraphView extends Backbone.Marionette.ItemView
	@startWithParent = false
	template: 'views/templates/orggraph'
	id: 'region-graph'
	$el: $('#region-graph') # gget the element as a leaflet dom el
	artistNodes: []
	links: []
	
	initialize: ->
		console.log "OrgGraphView initialized"
		# graph = application.GraphModule.getGraph()
		# console.log "graph" , graph
		force = application.GraphModule.getForce()
		console.log "graph" , force

	onThisArtist: (node) =>
		# console.log "onThisArtist"
		# _thisNode = $("#"+"node-#{node}")
		# console.log "_thisNode", _thisNode
		# _thisNode.css("r", 120)
		# @artistNodes = application.GraphModule.getAllArtists()
		# console.log "@artistNodes", @artistNodes
		# @vis = application.GraphModule.getGraph()
		# @_m = application.GraphModule.getMap()

		# L.DomEvent.removeListener.removeListener(L.DomUtil.get($("graph"))
		# for key, value of @artistNodes
			# if value.name == node
				# _thisNodes = @vis.selectAll('g.node')
				# _thisNode = $("#"+"node-#{value.id}")
				# d3.select(_thisNode[0]
				# ).transition(
				# ).duration(1000
				
				
				# ).style("opacity", 0.8).attr("r", 10).style("fill", "black")
				
			# else
	
	onShow: ->
		# if application.GraphModule.getGraph() is undefined
		# 	application.GraphModule.makeGraph()
		# @_m = application.GraphModule.getMap()
		# map = $("#map-region").append("<div id='map'></div>")
		# # console.log "size", $("body")[0].clientHeight
		# # $("#map").css("height", $("body")[0].clientHeight)
		# if application.GraphModule.getMap() is undefined
		# 	application.GraphModule.makeMap()
		# application.Butterfly.start()
		# application.Butterfly.makeButterfly()
		$(document).ready =>
			application.GraphModule.makeOrgGraph()
			# console.log "d3.select", d3.select("#region-graph")
			# console.log "graph", graph[0]
			# $("#region-graph").append "somethinf"
			# $("#region-graph").append graph[0]
			# console.log @$el
	onRender: ->
		



