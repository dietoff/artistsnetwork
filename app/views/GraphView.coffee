ArtistsModule = require 'lib/graphModule'
application = require 'application'
module.exports = class GraphView extends Backbone.Marionette.ItemView
	template: 'views/templates/graph'
	id: 'graph'
	$el: $('#graph')

	onShow: ->
		# application.module 'GraphModule', (GraphModule, template) ->
		# 	this == GraphModule
		# 	myData = 'this is private data'
		# 	myFunction = ->
		#     	console.log "is thereany other way??"
		#     	return

		#   # Public Data And Functions
		#   # -------------------------
		#   	GraphModule.someData = 'public data'

		#   	GraphModule.someFunction = ->
		#   		console.log "look like this is working!"
		#   		return
		#     return
		console.log "inside graph item view"
		# application.GraphModule.someFunction()
		@el = @$el
		console.log "@el", @el
		nodes = []
		links = []
		nodes.push {'name': "Abbas Kiarostami", 'id': 0}
		nodes.push {'name': "Tehran", 'id': 1}
		links.push {'source': 0, "target": 1}
		w = $(@el).innerWidth()
		h = $(@el).innerHeight()
		console.log "myGraph el", @id
		vis = @vis = d3.select('#graph').append('svg:svg').attr('width', 400).attr('height', 600)
		@force = d3.layout.force().gravity(.05).distance(200).charge(-100).size([
			400
			600
		])
		@nodes = @force.nodes(nodes)
		console.log "@nodes", @nodes
		@links = @force.links()
		link = @vis.selectAll('line.link').data(links, (d) ->
			d.source.id + '-' + d.target.id
		)
		link.enter().insert('line').attr 'class', 'link'
		link.exit().remove()
		node = @vis.selectAll('g.node').data(nodes, (d) ->
			d.name
		)
		nodeEnter = node.enter().append('g').attr('class', 'node').call(@force.drag)
		nodeEnter.append('circle').attr('r', 15).style('fill', 'black').attr('x', '-8px').attr('y', '-8px').attr('width', '4px').attr 'height', '4px'
		nodeEnter.append('text').attr('class', 'nodetext').attr('dx', 12).attr('dy', '.35em').text (d) ->
			d.name
		node.exit().remove()
		@force.on 'tick', ->
			# console.log d
			link.attr('x1', (d) ->
				console.log d
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

