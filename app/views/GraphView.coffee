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
				id = 0
				for artist in nodes
					# if artist.source == 'Abbas Kiarostami'
					console.log artist.source
					@artistNodes.push {'name' :artist.source, 'id': id}
					id = id + 1
				console.log "@artistNodes", @artistNodes
				@el = @$el
				# console.log "@el", @el
				nodes = @artistNodes

				#  good example:  http://jsfiddle.net/bc4um7pc/
				# nodes.push {'name': "Abbas Kiarostami", 'id': 0}
				nodes.push {'name': "Tehran", 'id': 1}
				links.push {'source': 2, "target": 1}
				links.push {'source': 5, "target": 2}
				links.push {'source': 1, "target": 2}
				console.log links
				w = $(@el).innerWidth()
				h = $(@el).innerHeight()
				# console.log "myGraph el", @id
				vis = @vis = d3.select('#graph').append('svg:svg').attr('width', w).attr('height', 400)
				@force = d3.layout.force().gravity(.05).distance(200).charge(-100).size([
					w
					400
				])
				@nodes = @force.nodes(nodes)
				# console.log "@nodes", @nodes
				links = @force.links()
				link = @vis.selectAll('.link').data(links, (d) ->
					d.source.id + '-' + d.target.id
				)
				link.enter().insert("line", ".node").attr("class", "link")
				link.exit().remove()
				node = @vis.selectAll('g.node').data(nodes, (d) ->
					d.name
				)
				nodeEnter = node.enter().append('g').attr('class', 'node').call(@force.drag)
				nodeEnter.append('circle').attr('r', 5).style('fill', 'black').attr('x', '-8px').attr('y', '-8px').attr('width', '4px').attr 'height', '4px'
				nodeEnter.append('text').attr('class', 'nodetext').attr('dx', 12).attr('dy', '.35em')#.text (d) ->
					# d.name
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

