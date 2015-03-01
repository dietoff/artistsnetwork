application = require('application')

application.module 'OrgGraph', (OrgGraph, App, Backbone, Marionette, $, _) ->
  @startWithParent = true
  OrgGraph.Controller =

      OrgGraph: =>
        console.log "makeOrgGraph"
        OrgGraph.makeOrgGraph()
        
        return


      # write methods
      # # getAllNodes
      # # getNodesBy(name, value)

  class OrgGraph.Router extends Marionette.AppRouter
    appRoutes:
      "OrgGraph" : "OrgGraph"

  API = 

    OrgGraph: () ->
      OrgGraph.Controller.OrgGraph()   

  App.addInitializer ->
    new OrgGraph.Router
      controller: API 
  # The context of the function is also the module itself
  this == OrgGraph

  # => true
  # Private Data And Functions
  # --------------------------
  myData = 'this is private data'
  toggle = 0

  # Public Data And Functions
  # -------------------------
  OrgGraph.someData = 'public data'

  OrgGraph.makeOrgGraph = () ->
    console.log application
    @_nodes = application.GraphModule.Controller.allNodes()
    @_links = application.GraphModule.Controller.allLinks()
    width = 1200
    height = 700
    # vis = @vis = d3.select('.graph').append('svg:svg').attr('width', width).attr('height', 700)
    # console.log @vis
    console.log "inside make makeOrgGraph"
    color = d3.scale.category20()

    _nodes = nodes = @_nodes
    _links = links = @_links
    console.log links
    console.log "links and nodes", links, nodes
    # svg = d3.select('body').append('svg').attr('width', width).attr('height', height)
    # console.log svg
    svg = vis = @vis = d3.select('#content  ').append('svg:svg').attr('width', width).attr('height', width)
    force = @force = d3.layout.force(
    ).gravity(.3
    ).linkDistance(60
    ).charge(-100
    ).linkStrength(0.7
    ).gravity(0.3
    ).size([
      width
      width
    ])
    @nodes = @force.nodes(d3.values(_nodes))
    @links = @force.links()
    link = svg.selectAll('.link').data(_links)
    link.enter().insert("line", ".node").attr("class", "link").style("stroke","lightgray").style("stroke-width", 2).style("opacity", 0.8)
    link.exit().remove()
    
    node = @vis.selectAll('g.node'
    ).data(d3.values(_nodes), (d) ->
      d.name
    )
    @color = d3.scale.category10()
    color = @color
    _artistNodes = @_nodes
    nodes = _nodes
    nodeEnter = node.enter().append('g').attr('class', 'node').call(@force.drag)
    # nodeEnter.attr("class", "leaflet-zoom-hide")
    nodeEnter.append('circle').property("id", (d, i) => "node-#{i}").attr('r', (d) ->
      if d.group in [0..3]
        return 10
      else
        return 10
    ).attr('x', '-1px').attr('y', '-1px').attr('width', '4px').attr('height', '4px'
    ).style("stroke", "none"
    ).style("opacity", 0.6).style('fill', (d) =>
      if d.group 
        return @color(1)  #(d.group)
      else
        return @color(2)
    ).on('mouseover', (d, i) ->
      console.log "mouseover"
      d3.select(this).select('circle').transition().duration(750).attr 'r', 12
      d3.select(this).select('text').transition().duration(750).style 'font-size', '20px'
      return
    ).on('mouseout', (d,i) ->
      d3.select(this).select('circle').transition().duration(750).attr 'r', 5
      d3.select(this).select('text').transition().duration(750).style 'font-size', '10px'
      return
    ).on('touchstart', (d, i) ->
      console.log "mouseover"
      d3.select(this).select('circle').transition().duration(750).attr 'r', 12
      d3.select(this).select('text').transition().duration(750).style 'font-size', '20px'
      return
    ).on('touchend', (d,i) ->
      d3.select(this).select('circle').transition().duration(750).attr 'r', 5
      d3.select(this).select('text').transition().duration(750).style 'font-size', '10px'
      return
    ).call(force.drag
    
    )
    nodeEnter.append('text').attr('class', 'nodetext').attr('dx', 12).attr('dy', '.35em').style("opacity", 0).attr("fill", (d, i) ->
      return "gray" #color(i)
    ).attr('id', (d,i) ->
      return i
    )

    node.exit().remove()
    # force = d3.layout.force().nodes(nodes).links(links).size([
    #   width
    #   height
    # ]).linkDistance(60).charge(-500).linkStrength(0.7).gravity(0.3)
    # link = svg.selectAll('.link').data(force.links()).enter().append('line').attr('class', 'link').style('stroke', 'lightgray').style('stroke-width', (d) ->
      # Math.sqrt d.value
    # )
    # node = svg.selectAll('.node').data(force.nodes()).enter().append('g').attr('class', 'node').on('mouseover', mouseover).on('mouseout', mouseout).on('touchstart', mouseover).on('touchend', mouseout).call(force.drag).on('dblclick', connectedNodes)

    tick = ->
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


    @force.on('tick', tick).start()

      #do it

        
    optArray = []
    j = 0
    nodes =  d3.values(_nodes)
    console.log "nodes.length", d3.values(_nodes).length
    while j < nodes.length - 1
      console.log "inside while"
      optArray.push nodes[j].name
      console.log nodes[j].name
      j++
    optArray = optArray.sort()
    console.log optArray
    # $ ->
    #   $('#search').autocomplete source: optArray
    #   return
    #SUBNET HIGHLIGHT
    #code from http://www.coppelia.io/2014/07/an-a-to-z-of-extra-features-for-the-d3-force-layout/
    #Toggle stores whether the highlighting is on
    # @toggle = 0
    toggle = 0
    console.log "toggle", toggle
    #Create an array logging what is connected to what
    linkedByIndex = {}
    j = 0
    while j < nodes.length
      linkedByIndex[j + ',' + j] = 1
      j++
    links.forEach (d) ->
      linkedByIndex[d.source.index + ',' + d.target.index] = 1
      return
    console.log "linkedByIndex", linkedByIndex

    

    node.append('circle').style('fill', (d) ->
      color d.group
    ).attr 'r', 5
    # node.append('text').attr('x', 14).attr('dy', '.35em').text (d) ->
      # d.name

    # ---
    # generated by js2coffee 2.0.1
    # @force.start()
    node.on('dblclick', (d, i) ->
      neighboring = (a, b) ->
        linkedByIndex[a.index + ',' + b.index]
      if toggle == 0
        #Reduce the opacity of all but the neighbouring nodes
        d = d3.select(this).node().__data__
        console.log "node", d
        node.selectAll("circle").style 'opacity', (o) ->
          console.log "o", o
          console.log "neighboring(d, o)", neighboring(d, o)
          if neighboring(d, o) | neighboring(o, d) then 1 else 0.1
        link.style 'opacity', (o) ->
          if d.index == o.source.index | d.index == o.target.index then 1 else 0.1
        toggle = 1
      else
        #Put them back to opacity=1
        node.selectAll("circle").style 'opacity', 1
        link.style 'opacity', 1
        toggle = 0
      return
    )

    searchNode = ->
      #find the node
      selectedVal = document.getElementById('search').value
      node = @vis.selectAll('g.node')
      console.log node
      if selectedVal == 'none'
        node.style('stroke', 'white').style 'stroke-width', '1'
      else
        selected = node.filter((d, i) ->
          d.name != selectedVal
        )
        selected.style 'opacity', '0'
        link = svg.selectAll('.link')
        link.style 'opacity', '0'
        d3.selectAll('.node, .link').transition().duration(3000).style 'opacity', 1
      return

    #This function looks up whether a pair are neighbours  

    

    # ---
    # generated by js2coffee 2.0.1
    # console.log "makeOrgGraph"
    # else 
    console.log "makeOrgGraph"