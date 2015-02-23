ArtistsModule = require 'lib/graphModule'
application = require 'application'
module.exports = class GraphView extends Backbone.Marionette.ItemView
	@startWithParent = false
	template: 'views/templates/graph'
	id: 'graph-map'
	$el: $('graph-map') # gget the element as a leaflet dom el
	artistNodes: []
	links: []
	
	onThisArtist: (node) =>
		console.log "onThisArtist"
		# _thisNode = $("#"+"node-#{node}")
		# console.log "_thisNode", _thisNode
		# _thisNode.css("r", 120)
		@artistNodes = application.GraphModule.getAllArtists()
		# console.log "@artistNodes", @artistNodes
		@vis = application.GraphModule.getGraph()
		@_m = application.GraphModule.getMap()

		# L.DomEvent.removeListener.removeListener(L.DomUtil.get($("graph"))
		for key, value of @artistNodes
			if value.name == node
				_thisNodes = @vis.selectAll('g.node')
				_thisNode = $("#"+"node-#{value.id}")
				d3.select(_thisNode[0]
				).transition(
				).duration(1000
				# ).style("color", "rgb(72,72,72)"
				# ).style("background-color", "white"
				).style("opacity", 0.8).attr("r", 10).style("fill", "black")
				# console.log "_thisNode", _thisNode
				# _thisNode.css("r", 120)
				# _thisNode = _thisNodes.filter((d, i) =>
				#   if d.name == node & 1 then this else null
				# )
				# console.log "_thisNode", _thisNode
				
				# good example http://bl.ocks.org/d3noob/5141528
				# using the example to bind transitions
				# get and highlight and ...


			else
				# get, and node for that artist
	
	onShow: ->
		$(document).ready =>
			



