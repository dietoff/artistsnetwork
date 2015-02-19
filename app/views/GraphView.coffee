ArtistsModule = require 'lib/graphModule'
application = require 'application'
module.exports = class GraphView extends Backbone.Marionette.ItemView
	template: 'views/templates/graph'
	id: 'graph'
	$el: $('#graph')
	artistNodes: []
	links: []
	onShow: ->
		$(document).ready =>
			# @el = $('#region-bios')
			d3.json 'http://localhost:3001/artists', (error, nodes) =>
				console.log "nodes", nodes
				w = $(@el).innerWidth()
				h = $(@el).innerHeight()
				id = 0
				for artist in nodes
					# if artist.source == 'Abbas Kiarostami'
					console.log artist.source
					@artistNodes.push {'name' :artist.source, 'id': id}
					id = id + 1
				
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

				# force = @vis = d3.layout.force().nodes(d3.values(_nodes)).links(_links).size([
				#   600
				#   600
				# ]).linkDistance(150).charge(-300).on('tick', tick).start()

				# svg = d3.select('#graph').append('svg:svg').attr('width', 600).attr('height', 600)

				# svg.append('svg:defs').selectAll('marker').data([
				#   'Location'
				#   'Address'
				#   'Organization'
				#   'Origin'
				# ]).enter().append('svg:marker').attr('id', String).attr('viewBox', '0 -5 10 10').attr('refX', 30).attr('refY', -4.5).attr('markerWidth', 6).attr('markerHeight', 6).attr('orient', 'auto').append('svg:path').attr 'd', 'M0,-5L10,0L0,5'


				
					

				# linktext = svg.append('svg:g').selectAll('g.linklabelholder').data(force.links())

				# linktext.enter().append('g').attr('class', 'linklabelholder').append('text').attr('class', 'linklabel').style('font-size', '13px').attr('x', '50').attr('y', '-20').attr('text-anchor', 'start').style('fill', '#000').append('textPath').attr('xlink:href', (d, i) ->
				#   '#linkId_' + i
				# ).text (d) ->
				#   d.type
				
				# circle = svg.append('svg:g').selectAll('circle').data(force.nodes()).enter().append('svg:circle').attr('r', 20).style('fill', '#FD8D3C').call(force.drag)
				# text = svg.append('svg:g').selectAll('g').data(force.nodes()).enter().append('svg:g')
				# text.append('svg:text').attr('x', '-1em').attr('y', '.31em').style('font-size', '13px').text (d) ->
				#   d.name

				# tick = ->
				# 	path.attr 'd', (d) ->
				# 		dx = d.target.x - d.source.x
				# 		dy = d.target.y - d.source.y
				# 		dr = 75 / d.linknum
				# 		#linknum is defined above
				# 		'M' + d.source.x + ',' + d.source.y + 'A' + dr + ',' + dr + ' 0 0,1 ' + d.target.x + ',' + d.target.y
				# 	circle.attr 'transform', (d) ->
				# 		'translate(' + d.x + ',' + d.y + ')'
				# 	text.attr 'transform', (d) ->
				# 		'translate(' + d.x + ',' + d.y + ')'
				# 	return



				console.log "@artistNodes", @artistNodes
				@el = @$el
				nodes = @artistNodes

				#  good example:  http://jsfiddle.net/bc4um7pc/
				nodes.push {'name': "Tehran", 'id': 1}
				@links.push {'source': 2, "target": 1}
				@links.push {'source': 5, "target": 2}
				@links.push {'source': 1, "target": 2}
				console.log @links
				w = $(@el).innerWidth()
				h = $(@el).innerHeight()
				console.log $(@el)
				vis = @vis = d3.select('#graph').append('svg:svg').attr('width', 1000).attr('height', 1000)
				@force = d3.layout.force().gravity(.05).distance(200).charge(-100).size([
					1000
					1000
				])
				console.log "_links", _links
				console.log "_nodes", _nodes
				@nodes = @force.nodes(d3.values(_nodes))
				links = @force.links()
				link = @vis.selectAll('.link').data(_links)
				link.enter().insert("line", ".node").attr("class", "link")
				link.exit().remove()
				node = @vis.selectAll('g.node').data(d3.values(_nodes), (d) ->
					d.name
				)


				path = @vis.append('svg:g').selectAll('path').data(@force.links()).enter().append('svg:path').attr('class', (d) ->
					'link ' + d.edgetype
				).attr('id', (d, i) ->
					'linkId_' + i
				).attr('marker-end', (d) ->
					'url(#' + d.edgetype + ')'
				)

				nodeEnter = node.enter().append('g').attr('class', 'node').call(@force.drag)
				nodeEnter.append('circle').attr('r', 5).style('fill', 'black').attr('x', '-8px').attr('y', '-8px').attr('width', '4px').attr 'height', '4px'
				nodeEnter.append('text').attr('class', 'nodetext').attr('dx', 12).attr('dy', '.35em').text (d) ->
				node.exit().remove()
				@force.on 'tick', ->
					link.attr('x1', (d) ->
						d.source.x
					).attr('y1', (d) ->
						d.source.y
					).attr('x2', (d) ->
						d.target.x
					).attr 'y2', (d) ->
						d.target.y
					node.attr 'transform', (d) ->
						'translate(' + d.x + ',' + d.y + ')'
					return
				
				@force.start()

