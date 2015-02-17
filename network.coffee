class ArtistsNetwork
  constructor: (@text) ->

  options: 
    height: 800
    width: 900
    category: ''
    type: ''
    
  
  properties:
    f_id: ''
    height: 800
    width: 900
    _margin: 
      t: 20
      l: 30
      b: 30
      r: 30

  initialize: (data, options) ->
    _this = this
    L.setOptions _this, options
    return 

  category: (newCategory) ->
    @options.category = newCategory
    this

  type: (newType) ->
    @options.type = newType
    this

  nodes: ->
    nodes = []
    edges = []
    d3.json 'http://localhost:3001/artists', (error, node) =>
      for each in node
        nodes.push {'name': each.source}
        edges.push {'source': each.source, target: each.target}
      for each in node
        nodes.push {'name': each.target}
    @nodes = nodes

  makeNetwork: (artist, lineindex) ->
    console.log "@options.width", @options.width
    console.log "arist in the make makeNetwork", artist, lineindex
    nodes = []
    edges = []
    d3.json 'http://localhost:3001/artists', (error, node) =>
      for each in node
        nodes.push {'name': each.source}
        edges.push {'source': each.source, target: each.target}
      for each in node
        nodes.push {'name': each.target}
      console.log nodes, edges
      
      color = d3.scale.category20()
      force = d3.layout.force().charge(-120).linkDistance(30).size([
        @options.width/2
        @options.height/2
      ])
      force.nodes(nodes).start()
      svg = d3.select('svg').attr("transform", "translate(" + @properties._margin.l + "," + @properties._margin.t + ")")
      if @node isnt undefined
        @node.data([]).exit()
        @node = svg.selectAll('.node').data(nodes).enter()
        .append('circle')
        .attr('class', 'node')
        .attr('r', 5)
        .style('fill', (d, i) ->
          # console.log "d", d.name
          # console.log "artist.Name", artist.Name
          if d.name == artist.Name
            'black'
          else
            'none'
        )
        .on("mouseenter", (d,i) =>
          console.log "d", d
        ).call(force.drag)
        console.log "node isnt undefined",node
      else
        node = svg.selectAll('.node').data(nodes).enter()
        .append('circle')
        .attr('class', 'node')
        .attr('r', 5)
        .style('fill', (d, i) ->
          # console.log "d", d.name
          # console.log "artist.Name", artist.Name
          if d.name == artist.Name
            'black'
          else
            'none'
        )
        .on("mouseenter", (d,i) =>
          console.log "d", d
        ).call(force.drag)
      force.links(edges)
      link = svg.selectAll('.link').data(edges).enter().append('line').attr('class', 'link').style('stroke-width', (d) ->
        Math.sqrt 1
      )
      @node = node
      force.on 'tick', ->
        link.attr('x1', (d) ->
          d.source.x
        ).attr('y1', (d) ->
          d.source.y
        ).attr('x2', (d) ->
          d.target.x
        ).attr 'y2', (d) ->
          d.target.y
        node.attr('cx', (d) ->
          d.x
        ).attr 'cy', (d) ->
          d.y



  
  addNode: (id) ->
    console.log id
    nodes = @nodes
    nodes.push 'id': id
    @update()
    return

  removeNode: (id) ->
    links = @links
    i = 0
    n = @findNode(id)
    while i < links.length
      if links[i]['source'] == n or links[i]['target'] == n
        links.splice i, 1
      else
        i++
    index = @findNodeIndex(id)
    nodes = @nodes
    if index != undefined
      nodes.splice index, 1
      @update()
    return

  addLink: (sourceId, targetId) ->
    sourceNode = @findNode(sourceId)
    targetNode = @findNode(targetId)
    links = @links
    if sourceNode != undefined and targetNode != undefined
      links.push
        'source': sourceNode
        'target': targetNode
      @update()
    return

  findNode: (id) ->
    nodes = @nodes
    i = 0
    while i < nodes.length
      if nodes[i].id == id
        return nodes[i]
      i++
    return

  findNodeIndex: (id) ->
    nodes = @nodes
    i = 0
    while i <  nodes.length
      if nodes[i].id == id
        return i
      i++
    return

  myGraph: (el) ->

    # set up the D3 visualisation in the specified element
    elH = '#' + "#{el}"
    w = $(elH).innerWidth()
    h = $(elH).innerHeight()
    console.log "#{elH}" , d3.select("#{elH}")
    console.log "myGraph el",el
    vis = @vis = d3.select("#{elH}").append('svg:svg').attr('width', 400).attr('height', 400)
    # console.log "@vis", @vis
    @force = d3.layout.force().gravity(.05).distance(100).charge(-100).size([
      w
      h
    ])
    @nodes = @force.nodes()
    console.log "@nodes", @nodes
    @links = @force.links()

    

    # Make it all go
    # update()
    return

  update: ->
    links = @links
    link = @vis.selectAll('line.link').data(links, (d) ->
      d.source.id + '-' + d.target.id
    )
    link.enter().insert('line').attr 'class', 'link'
    link.exit().remove()
    nodes = @nodes
    node = @vis.selectAll('g.node').data(nodes, (d) ->
      d.id
    )
    nodeEnter = node.enter().append('g').attr('class', 'node').call(@force.drag)
    nodeEnter.append('circle').attr('r', 15).style('fill', 'black').attr('x', '-8px').attr('y', '-8px').attr('width', '16px').attr 'height', '16px'
    nodeEnter.append('text').attr('class', 'nodetext').attr('dx', 12).attr('dy', '.35em').text (d) ->
      d.id
    node.exit().remove()
    @force.on 'tick', ->
      console.log d
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
    # Restart the force layout.
    @force.start()
    return
  
  visulize: () ->

    svg = d3.select('body').append('svg').attr('width', @properties.width/2).attr('height', @properties.height/2)
    console.log "inside visulize"
    Height = @options.height
    Width = @options.width
    @_textDomEl = document.createElement('div')
    console.log @_textDomEl
    $('body').append @_textDomEl
    $(@_textDomEl).attr( "id", "ArtistsViz" )
    @myGraph("ArtistsViz")
    @_textDomObj = $(@_textDomEl).attr( "id", "ArtistsViz" )
    @_textDomObj.css('width', Width/2)
    @_textDomObj.css('height', Height)
    @_textDomObj.css('background-color', 'white')
    @_textDomObj.css('overflow', 'visibile')
    # L.DomUtil.setOpacity(L.DomUtil.get(@_textDomEl), .8)
    # @_d3text = d3.select("ArtistsViz")
    console.log "@text", @text
    @_d3text = d3.select(@_textDomEl).append('div').attr("width", @properties.width + @properties._margin.l + @properties._margin.r).attr("height", @properties.height + @properties._margin.t + @properties._margin.b)#.append("g")
    .attr("transform", "translate(" + @properties._margin.l + "," + @properties._margin.t + ")")
    .append("ul").style("list-style-type", "none").style("padding-left", "0px")
    .attr("width", Width/3 )
    .attr("height", Height-80)
    @_d3li = @_d3text
    .selectAll("li")
    .data(@text)
    .enter()
    .append("li")
    @_d3li.style("font-family", "Helvetica")
    .style("line-height", "2")
    .style("border", "0px solid gray")
    .style("margin-top", "15px")
    .style("padding-top", "15px")
    .style("padding-bottom", "15px")
    .style("padding-right", "20px")
    .style("padding-left", "40px")
    .attr("id", (d, i) =>
       "line-#{i}" 
      )
    .text((d,i) =>
      # console.log d
      d.FirstParagraph   
    )
    .style("font-size", "12px")
    .style("color", "rgb(72,72,72)" )
    .on("mouseover", (d,i) ->
      console.log @, this
      $(this).css('cursor','pointer')
      d3.select(this).transition().duration(0).style("color", "black").style("background-color", "rgb(208,208,208) ").style "opacity", 1
      # _this.makeNetwork(this)
      return 
    ).on("mouseenter", (d,i) =>
      console.log "@stttttttt", this
      id = "line-#{i}"
      @addNode(d)
      @addLink(1, 1)
    ).on("mouseout", (d,i) ->
      d3.select(this).transition().duration(1000).style("color", "rgb(72,72,72)").style("background-color", "white").style "opacity", 1
      return
    )  
    .transition().duration(1).delay(1).style("opacity", 1)
    console.log @_d3text
    @_textDomEl

# # You can do this from the console as much as you like...
# graph.addNode 'Cause'
# graph.addNode 'Effect'
# graph.addLink 'Cause', 'Effect'
# graph.addNode 'A'
# graph.addNode 'B'
# graph.addLink 'A', 'B'

# ---
# generated by js2coffee 2.0.1
d3.json 'http://localhost:3001/bios', (error, text) ->
  console.log "text", text
  artistsList = new ArtistsNetwork(text).visulize()






d3force: ->
  nodes = []
  nodeToEdge = []
  edges = []
  d3.json 'http://localhost:3001/artists', (error, node) ->
    for each in node
      nodes.push {'name': each.source}
      edges.push {'source': each.source, target: each.target}
    for each in node
      nodes.push {'name': each.target}
    # getEdge(nodes)
    draw(nodes, edges)
    # return
  getEdge = (nodes) ->
    # console.log "nodes", nodes
    # console.log "first" , nodes
    d3.json 'http://localhost:3001/armoryedges', (error, edge) ->
      # console.log nodes
      console.log "nodes", nodes
      # draw(nodes, edge)
      # return



  draw = (nodes, edge) ->
    width = 960
    height = 500
    svg = d3.select('body').append('svg').attr('width', width).attr('height', height)
    color = d3.scale.category20()
    force = d3.layout.force().charge(-120).linkDistance(30).size([
      width
      height
    ])
    # edges = []
    # console.log "nodes", nodes
    # console.log "edge", edge.rows
    # force.nodes(nodes)
    # console.log nodes


    # console.log "nodes", nodes
    count = 0
    # console.log force.nodes
    # for each in edge
    #   # console.log "each", each
    #   # sourceIndex = nodes[count]
    #   # console.log "sourceIndex", sourceIndex
    #   # console.log nodes
    #   # targetIndex = findTargetIndex(each, nodes, count)
    #   # console.log targetIndex
    #   # console.log "sourceIndex", sourceIndex
    #   edges.push {'source': each.Source, 'target': each.Target, value: 1 , "weight": 1} 
    #   count = count + 1
    # console.log "before draw links", edges
    console.log nodes.length
    console.log edges.length
    
    
    
    force.nodes(nodes)
    console.log nodes
    console.log edges
    # console.log force
    force.linkStrength(0.1).links(edges).start()
    node = svg.selectAll('.node').data(nodes).enter().append('circle').attr('class', 'node').attr('r', 5).style('fill', 'black').call(force.drag)
    # node = svg.selectAll('.node').data(nodes).enter().append('circle').attr('class', 'node').attr('r', 5).style('fill', (d) ->
      # color d.group
    # ).call(force.drag)
    # drawLinks(edges)
    force.tick()
    link = svg.selectAll('.link').data(edges).enter().append('line').attr('class', 'link').style('stroke-width', (d) ->
      Math.sqrt 1
    )
    force.on 'tick', ->
      link.attr('x1', (d) ->
        d.source.x
      ).attr('y1', (d) ->
        d.source.y
      ).attr('x2', (d) ->
        d.target.x
      ).attr 'y2', (d) ->
        d.target.y
      node.attr('cx', (d) ->
        d.x
      ).attr 'cy', (d) ->
        d.y

  findSourceIndex = (each, nodes, count) ->
    # console.log "each", each.Source
    for artist in nodes[count..nodes.lenght]
      # console.log artist
      return artist if each.Source == artist.name
  findTargetIndex = (each, nodes, count) ->
    # console.log "target", target
    # console.log nodes
    for artist in nodes[count..nodes.lenght]
      # console.log artist
      return artist if each.Target == artist.name
    # return
  drawLinks = (edges) ->
    color = d3.scale.category20()
    # Here we define that we will use the force layout an we add
    # some parameters to setup the basic layout of the graph 

    force1 = d3.layout.force().charge(-120).linkDistance(30).size([
      960
      500
    ])

    ### Here we include the graph in the page ###
    svg = d3.select('body').append('svg').attr('width', 960).attr('height', 500)
    ### format data ###
    my_links = $.map(edges, (d) ->
      # console.log d
      {
        'source': d.source
        'target': d.target
        'value': d.weight
        'origin': d
      }
    )
    # https://groups.google.com/forum/#!topic/d3-js/R4l4VNvPuo4
    nodeMap = {}
    nodes.forEach (x) ->
      nodeMap[x.id] = x
      return
    # links = links.map((x) ->
    #   {
    #     source: nodeMap[x.source]
    #     target: nodeMap[x.target]
    #     value: x.weight
    #   }
    # )
    console.log my_links
    force1.nodes(nodes).links(my_links).start()

    # console.log "inside draw links"
    # console.log "edges inside draw links", edges
    link = svg.selectAll('.link').data(edges).enter().append('line').attr('class', 'link').style('stroke-width', (d) ->
      Math.sqrt 1
    )
    node = svg.selectAll('.node').data(nodes).enter().append('circle').attr('class', 'node').attr('r', 5).style('fill', (d) ->
      # console.log d
      color switch
        when d.group == 'Person' then 1
        when d.group == 'Location' then 2
        when d.group == 'Orgainzation' then 3
        when d.group == 'Date' then 4
        else 5
      # color d.group
    ).call(force.drag)
    # console.log "edges inside draw links", edges
    console.log node
    # node.append('title').text (d) ->
    #   d.name
    force.on 'tick', ->
      link.attr('x1', (d) ->
        d.source.x
      ).attr('y1', (d) ->
        d.source.y
      ).attr('x2', (d) ->
        d.target.x
      ).attr 'y2', (d) ->
        d.target.y
      node.attr('cx', (d) ->
        d.x
      ).attr 'cy', (d) ->
        d.y
    return
# ---
# generated by js2coffee 2.0.1