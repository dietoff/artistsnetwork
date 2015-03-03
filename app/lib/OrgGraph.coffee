application = require('application')

application.module 'OrgGraph', (OrgGraph, App, Backbone, Marionette, $, _) ->
  @startWithParent = true
  OrgGraph.Controller =

      OrgGraph: =>
        OrgGraph.makeOrgGraph()
        
        return
      highlightNodesBy: (sourceNode) =>
        # selectedNodes = []
        # @vis.selectAll("circle").style("opacity", 0.0)
        @_links.forEach (link) => 
            if link.source.name == sourceNode.name
              @vis.selectAll("circle").filter((d, i) =>
                d.name == link.target.name
                # selectedNodes.push 'lat': +d.lat, 'long': +d.long if d.name == link.target.name
              ).transition().duration(100
              ).style("opacity", 1
              ).attr("r", 10
              ).style("fill", (d) =>
                return @color(d.group)# @color(sourceNode.id)
              ).style("stroke", (d) =>
                return  @color(d.group)# @color(sourceNode.id)
              ).style("stroke-width", 4
              ).transition().duration(900
              ).style("opacity", 1
              ).attr("r", 20
              ).style("stroke", (d) =>
                return  @color(d.group) #@color(sourceNode.id)
              # ).style("fill", (d) =>
              #   return "none"
              ).style("stroke-width", 1
              ).transition().delay(50).duration(200
              ).attr("r", (d) ->
                if d.group == 2
                  return Math.sqrt(d.value) * 20
              ).style("stroke", (d) =>
                return @color(d.group)# @color(sourceNode.id)
              ).style("fill", (d) =>
                return @color(d.group)#@color(sourceNode.id)
              ).style("stroke-width", 0
              # ).transition().duration(0
              # ).style("opacity", 0.8
              # ).attr("r", 5
              # ).style("fill", (d) =>
              #   return @color(sourceNode.id)
              )
              @vis.selectAll("text.nodetext").filter((d, i) =>
                d.name == link.target.name
              ).transition().duration(600).style("opacity", 1)

              return
            return
        # lats = [] 
        # longs = []
        # selectedNodes.forEach (d) =>
        #   lats.push d.lat
        #   longs.push d.long
        # minlat = d3.min(lats)
        # minlong = d3.min(longs)
        # maxlat = d3.max(lats)
        # maxlong = d3.max(longs)
        # sw = [minlat, minlong]
        # ne = [maxlat, maxlong]
        # if @_m.getBounds().contains([sw, ne]) is false
        # @_m.fitBounds([sw, ne], {pan: {animate: false}})
        # else
          # @_m.fitBounds([sw, ne], {pan: {animate: false}})
          # @_mm.setView(center, zoom, {pan: {animate: false}});
        # onSetView: (map) =>
        #   @force.start()
        # @_m.whenReady =>
        #   @force.start()

        return

      resetHighlightNodesBy: =>
        @vis.selectAll("circle").transition().duration(500).style("opacity", 0.6).attr("r", (d) ->
          if d.group == 2
            return Math.sqrt(d.value) * 2
          else 
            return 2
        ).style("stroke-width", 1)
        @vis.selectAll("text.nodetext").transition().duration(500).style("opacity", 0)
      
            
      # write methods
      # # getAllNodes
      # # getNodesBy(name, value)

  class OrgGraph.Router extends Marionette.AppRouter
    appRoutes:
      "OrgGraph" : "OrgGraph"
      "highlightNodesBy" : "highlightNodesBy"
      "resetHighlightNodesBy" : "resetHighlightNodesBy"
  API = 

    OrgGraph: () ->
      OrgGraph.Controller.OrgGraph()

    highlightNodesBy: (d) ->
      OrgGraph.Controller.highlightNodesBy(d)

    resetHighlightNodesBy: () ->
      OrgGraph.Controller.resetHighlightNodesBy()
  App.addInitializer ->
    textResponse = $.ajax
                url: "http://localhost:3001/artistsbygroup/2"
                success: (nodes) ->
                  id = 0
                  @artistNodes = [] 
                  for artist in nodes
                    # make a list of artist names when data arrives and keep it
                    @artistNodes.push {'name' :artist.source, 'id': id, 'group': artist.group}
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
                  clusters = new Array(4)
                  # Compute the distinct nodes from the links.
                  _links.forEach (link) ->
                    r= 50
                    link.source = _nodes[link.source] or (_nodes[link.source] = name: link.source, group: 1, value:1, r: 50, cluster: 1)
                    link.target = _nodes[link.target] or (_nodes[link.target] = {name: link.target, group: link.group, lat: link.lat, long: link.long, value:1, r: 50, cluster: link.group})
                    return
                  OrgGraph._nodes = _nodes
                  OrgGraph._links = _links
                  d3.values((_nodes)).forEach (sourceNode) =>
                    _links.forEach (link) => 
                      if link.source.name == sourceNode.name and link.target.name != sourceNode.name
                      # console.log "count", count
                        link.target.value += 1
                      return
                    return
                  clusters
                  console.log "_links", _links
                  console.log "_nodes", _nodes
                  OrgGraph.clusters = clusters
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
    $("svg").html("")
    $("svg").css("height", "0px")
    # @_nodes = application.GraphModule.Controller.allNodes()
    # @_links = application.GraphModule.Controller.allLinks()
    width = $("#content")[0].clientWidth
    height = 1100
    padding = 1.5
    clusterPadding = 6
    maxRadius = 12
    
    # number of distinct clusters
    # color = d3.scale.category10().domain(d3.range(m))
    # The largest node for each cluster.
    # clusters = new Array(m)
    # vis = @vis = d3.select('.graph').append('svg:svg').attr('width', width).attr('height', 700)
    color = d3.scale.category20()

    _nodes = nodes = @_nodes
    _links = links = @_links
    n = d3.values((_nodes)).length
    m = 3
    # clusters = new Array(m)
    # _nodes = d3.range(n).map(->
    #   i = Math.floor(Math.random() * m)
    #   r = Math.sqrt((i + 1) / m * -Math.log(Math.random())) * maxRadius
    #   d = 
    #     cluster: i
    #     radius: r
    #   if !clusters[i] or r > clusters[i].radius
    #     clusters[i] = d
    #   d
    # )
    # svg = d3.select('body').append('svg').attr('width', width).attr('height', height)
    svg = vis = @vis = d3.select('#content  ').append('svg:svg').attr('width', width).attr('height', width)
    force = @force = d3.layout.force(
    ).gravity(.6
    ).linkDistance(50
    ).charge(-150
    ).linkStrength(1
    ).friction(0.9
    ).size([
      width
      height
    ]).on("tick", tick)
    @nodes = @force.nodes(d3.values(_nodes))
    @links = @force.links()
    link = svg.selectAll('.link').data(_links)
    link.enter().insert("line", ".node").attr("class", "link").style("stroke","lightgray").style("stroke-width", (d, i) -> 
        return Math.sqrt(d.target.value)
      ).style("opacity", 0.3)
    link.exit().remove()
    
    node = @vis.selectAll('g.node'
    ).data(d3.values(_nodes), (d) ->
      d.name
    )
    @color = d3.scale.category10()
    color = @color
    _artistNodes = @_nodes
    nodes = _nodes
    nodeEnter = node.enter().append('g').attr('class', 'node').attr("x", 14).attr("dy", "5.35em").call(@force.drag)
    # nodeEnter.attr("class", "leaflet-zoom-hide")
    nodeEnter.append('circle').property("id", (d, i) => "node-#{i}").attr('r', (d) ->
      if d.group == 2
        return Math.sqrt(d.value) * 2
      else
        return 2
    ).attr('x', '-1px').attr('y', '10px').attr('width', '4px').attr('height', '4px'
    ).style("stroke", "none"
    ).style("opacity", 0.6).style('fill', (d) =>
      return @color(d.group)
    ).on('mouseover', (d, i) ->
      # OrgGraph.Controller.highlightNodesBy(d)
      # d3.select(this).select('circle').transition().duration(750).attr 'opacity', 0.7
      # d3.select(this).select('text').transition().duration(750).attr('opacity', 0.7).style 'font-size', '26px'
      return
    ).on('mouseout', (d,i) ->
      # OrgGraph.Controller.resetHighlightNodesBy()
      # d3.select(this).select('circle').transition().duration(750).attr 'r', 10
      # d3.select(this).select('text').transition().duration(750).style 'font-size', '10px'
      return
    ).on('touchstart', (d, i) ->
      # d3.select(this).select('circle').transition().duration(750).attr 'r', 12
      # d3.select(this).select('text').transition().duration(750).style 'font-size', '20px'
      return
    ).on('touchend', (d,i) ->
      # d3.select(this).select('circle').transition().duration(750).attr 'r', 5
      # d3.select(this).select('text').transition().duration(750).style 'font-size', '10px'
      return
    ).call(force.drag
    
    )

    node.exit().remove()
    clusters =  OrgGraph.clusters
    # force = d3.layout.force().nodes(nodes).links(links).size([
    #   width
    #   height
    # ]).linkDistance(60).charge(-500).linkStrength(0.7).gravity(0.3)
    # link = svg.selectAll('.link').data(force.links()).enter().append('line').attr('class', 'link').style('stroke', 'lightgray').style('stroke-width', (d) ->
      # Math.sqrt d.value
    # )
    # node = svg.selectAll('.node').data(force.nodes()).enter().append('g').attr('class', 'node').on('mouseover', mouseover).on('mouseout', mouseout).on('touchstart', mouseover).on('touchend', mouseout).call(force.drag).on('dblclick', connectedNodes)

    zoom = d3.behavior.zoom()
    

    viewCenter = []
    viewCenter[0] = -1 * zoom.translate()[0] + 0.5 * width / zoom.scale()
    viewCenter[1] = -1 * zoom.translate()[1] + 0.5 * height / zoom.scale()
    # graphTransform = force.attribute("transform")
    # console.log graphTransform
    node.transition().duration(750).delay((d, i) ->
      i * 5
    ).attrTween 'r', (d) ->
      i = d3.interpolate(0, d.radius)
      (t) ->
        d.radius = i(t)
    
    # Move d to be adjacent to the cluster node.
    cluster = (alpha) ->
      (d) ->
        `var cluster`
        cluster = clusters[d.group]
        if cluster == d
          return
        x = d.x - cluster.x
        y = d.y - cluster.y
        l = Math.sqrt(x * x + y * y)
        r = d.radius + cluster.radius
        if l != r
          l = (l - r) / l * alpha
          d.x -= x *= l
          d.y -= y *= l
          cluster.x += x
          cluster.y += y
        return
    collide = (alpha) ->
      quadtree = d3.geom.quadtree(nodes)
      (d) ->
        r = d.radius + maxRadius + Math.max(padding, clusterPadding)
        nx1 = d.x - r
        nx2 = d.x + r
        ny1 = d.y - r
        ny2 = d.y + r
        quadtree.visit (quad, x1, y1, x2, y2) ->
          `var r`
          if quad.point and quad.point != d
            x = d.x - quad.point.x
            y = d.y - quad.point.y
            l = Math.sqrt(x * x + y * y)
            r = d.radius + quad.point.radius + (if d.cluster == quad.point.cluster then padding else clusterPadding)
            if l < r
              l = (l - r) / l * alpha
              d.x -= x *= l
              d.y -= y *= l
              quad.point.x += x
              quad.point.y += y
          x1 > nx2 or x2 < nx1 or y1 > ny2 or y2 < ny1
        return
    (t) ->
      d.radius = i(t)
    
    tick = (e) ->
      # console.log e.alpha
      link.attr('x1', (d) ->
        if d.source.value
          e.alpha * 100/d.source.value + d.source.x + 100
        else
          d.source.x + 400
      ).attr('y1', (d) ->
        if d.source.value
          e.alpha * 100/d.source.value + d.source.y
        else
          d.source.y
      ).attr('x2', (d) ->
        if d.target.value 
          d.target.x  - 100 - (e.alpha * Math.sqrt(d.target.value))
        else
          d.target.x  - 100 
      ).attr 'y2', (d) ->
        if d.value 
          d.target.y - 100 - (e.alpha * Math.sqrt(d.target.value))
        else
          d.target.y
      # node.each(cluster(10 * e.alpha * e.alpha)).each(collide(.5)).attr('cx', (d) ->
        # d.x
      # ).attr 'cy', (d) ->
        # d.y
      node.attr('transform', (d) ->
        # console.log d
        if d.group == 1
          if d.value
            x = e.alpha * 100/d.value + d.x + 100
            y = e.alpha * 100/d.value + d.y
          else
            x = d.x + 400
            y = d.y
          'translate(' + x + ',' + y + ')'
        else 
          if d.value
            x = d.x - e.alpha * 100/d.value - 100
            y = d.y - e.alpha * 100/d.value
          else
            x = d.x - 100
            y = d.y
          'translate(' + x + ',' + y + ')'
        
      )
      return


    @force.on('tick', tick).start()

      #do it

        
    optArray = []
    j = 0
    nodes =  d3.values(_nodes)
    while j < nodes.length - 1
      optArray.push nodes[j].name
      j++
    optArray = optArray.sort()
    # $ ->
    #   $('#search').autocomplete source: optArray
    #   return
    #SUBNET HIGHLIGHT
    #code from http://www.coppelia.io/2014/07/an-a-to-z-of-extra-features-for-the-d3-force-layout/
    #Toggle stores whether the highlighting is on
    # @toggle = 0
    toggle = 0
    #Create an array logging what is connected to what
    linkedByIndex = {}
    j = 0
    while j < nodes.length
      linkedByIndex[j + ',' + j] = 1
      j++
    links.forEach (d) ->
      linkedByIndex[d.source.index + ',' + d.target.index] = 1
      return

    

    # node.append('circle').style('fill', (d) ->
    #   color d.group
    # ).attr 'r', 5
    node.append('text').style("font-family", "Gill Sans").attr('fill', (d) ->
      return d3.lab(color(d.group)).darker(2)
    ).attr("opacity", 0.3).attr('x', 14).attr('dy', '.35em').text (d) ->
      d.name

    # ---
    # generated by js2coffee 2.0.1
    # @force.start()
    node.on('click', (d, i) ->

      neighboring = (a, b) ->
        linkedByIndex[a.index + ',' + b.index]
      if toggle == 0
        OrgGraph.Controller.highlightNodesBy(d)
        #Reduce the opacity of all but the neighbouring nodes
        d = d3.select(this).node().__data__
        node.selectAll("circle").transition(100).style 'opacity', (o) ->
          if neighboring(d, o) | neighboring(o, d) then 1 else 0.1
        node.selectAll("text").transition(100).style('opacity', (o) ->
          if neighboring(d, o) | neighboring(o, d) then 1 else 0.2
        ).style('font-size', (o) ->
          if neighboring(d, o) | neighboring(o, d) then 20 else 12
        )
        link.transition(100).style 'opacity', (o) ->
          if d.index == o.source.index | d.index == o.target.index then 1 else 0.1
        toggle = 1
      else
        #Put them back to opacity=1
        node.selectAll("circle").transition(100).style 'opacity', 0.6
        link.transition(100).style 'opacity', 1
        node.selectAll("text").transition(100).style('opacity',  0.3
        ).style('font-size', 14
        )
        OrgGraph.Controller.resetHighlightNodesBy(d)
        toggle = 0
      return
    )

    searchNode = ->
      #find the node
      selectedVal = document.getElementById('search').value
      node = @vis.selectAll('g.node')
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
    # else 