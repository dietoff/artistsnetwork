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
		for key, value of @artistNodes
			if value.name == node
				# good example http://bl.ocks.org/d3noob/5141528
				# using the example to bind transitions
				# get and highlight and ...

			else
				# get, and node for that artist

	onShow: ->
		$(document).ready =>
			d3.json 'http://localhost:3001/armoryedges', (error, nodes) =>
				w = 640
				h = 480
				id = 0
				for artist in nodes
					# make a list of artist names when data arrives and keep it
					@artistNodes.push {'name' :artist.source, 'id': id, 'edgetype': artist.edgetype}
					id = id + 1
				
				# using the data to create links and nodes in format
				_links = nodes
				# sort links by source, then target
				_links.sort (a, b) ->
				  	if a.source > b.source
				    	1
				  	else if a.source < b.source
				  		-1
				  	else
				  		if a.target > b.target
				  			return 1
				  		if a.target < b.target
				  			-1
				  		else
				  			0
				i = 0
				# any links with duplicate source and target get an incremented 'linknum'
				while i < _links.length
					if i != 0 and _links[i].source == _links[i - 1].source and _links[i].target == _links[i - 1].target
						_links[i].linknum = _links[i - 1].linknum + 1
					else
						_links[i].linknum = 1
					i++
				
				_nodes = {}
				# Compute the distinct nodes from the links.
				_links.forEach (link) ->
					link.source = _nodes[link.source] or (_nodes[link.source] = name: link.source)
					link.target = _nodes[link.target] or (_nodes[link.target] = name: link.target)
					return
				_m = application.GraphModule.getMap()
				_textDomEl = L.DomUtil.create('div', 'graph_up', @$el[0])
				_textDomEl.innerHTML = "<div class=graph'></div>"
				console.log _textDomEl
				L.DomUtil.enableTextSelection(_textDomEl) 
				# L.DomEvent.disableClickPropagation(_textDomEl)
				_m.getPanes().overlayPane.appendChild(_textDomEl)
				_textDomObj = $(L.DomUtil.get(_textDomEl))
				draggable = new L.Draggable(_textDomEl)
				draggable.disable()
				_textDomEl.firstChild.onmousedown = _textDomEl.firstChild.ondblclick = L.DomEvent.stopPropagation
				L.DomEvent.addListener _textDomEl, 'mouseover', ((e) ->
        			$(e.target).css('cursor','default')
        			e.preventDefault()
				_textDomObj.css('width', $(_m.getContainer())[0].clientWidth/2)
				_textDomObj.css('height', $(_m.getContainer())[0].clientHeight)
				_textDomObj.css('right', $(_m.getContainer())[0].clientWidth/4)
				_textDomObj.css('background-color', 'white')
				_textDomObj.css('overflow', 'scroll')
				@el = @$el
				L.DomUtil.setPosition(L.DomUtil.get(_textDomEl), L.point($(_m.getContainer())[0].clientWidth/2, 0), disable3D=0) 
				nodes = @artistNodes
				fx = new L.PosAnimation()
				#  good example:  http://jsfiddle.net/bc4um7pc/
				vis = @vis = d3.select('.graph').append('svg:svg').attr('width', w).attr('height', h)
				@force = d3.layout.force().gravity(.15).linkDistance(100).charge(-80).size([
					w
					h
				])
				@nodes = @force.nodes(d3.values(_nodes))
				links = @force.links()
				link = @vis.selectAll('.link').data(_links)
				link.enter().insert("line", ".node").attr("class", "link")
				link.exit().remove()
				


				# path = @vis.append('svg:g').selectAll('path').data(@force.links()).enter().append('svg:path').attr('class', (d) ->
				# 	'link ' + d.edgetype
				# ).attr('id', (d, i) ->
				# 	'linkId_' + i
				# ).attr('marker-end', (d) ->
				# 	'url(#' + d.edgetype + ')'
				# )
				node = @vis.selectAll('g.node').data(d3.values(_nodes), (d) ->
					d.name
				)
				nodeEnter = node.enter().append('g').attr('class', 'node').call(@force.drag)
				nodeEnter.append('circle').attr('r', w/225).style('fill', (d) =>
					if @artistNodes[d.name]
						if @artistNodes[d.name].edgetype == 'Date'
							return 'red'
						else
							return 'black'
				).attr('x', '-8px').attr('y', '-8px').attr('width', '4px').attr 'height', '4px'
				nodeEnter.append('text').attr('class', 'nodetext').attr('dx', 12).attr('dy', '.35em').attr('id', (d,i) ->
					return i
				).text (d) ->
					return d.name
				node.exit().remove()
				

				@force.on 'tick', =>
					link.attr('x1', (d) ->
						d.source.x
					).attr('y1', (d) ->
						d.source.y
					).attr('x2', (d) ->
						d.target.x
					).attr 'y2', (d) ->
						d.target.y
					node.attr('transform', (d) ->
						'translate(' + d.x + ',' + d.y + ')'
					).style('fill', (d) =>
						if @artistNodes[d.name]
							if @artistNodes[d.name].edgetype == 'Date'
								return 'red'
							else
								return 'black'
					)
					return
				
				@force.on 'start', =>
					@force.tick()
				@force.start()



