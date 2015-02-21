# night used
application = require('application')
application.module 'GraphModule', (GraphModule, App, Backbone, Marionette, $, _) ->
  # The context of the function is also the module itself
  this == GraphModule
  # => true
  # Private Data And Functions
  # --------------------------
  myData = 'this is private data'

  myFunction = ->
    console.log myData
    return

  # Public Data And Functions
  # -------------------------
  GraphModule.someData = 'public data'

  GraphModule.makeGraph = ->
    @$el = $('graph-map')
    @artistNodes = []
    d3.json 'http://localhost:3001/armoryedges', (error, nodes) =>
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
          # console.log "inside for each", link, _nodes

          return
        _m = @getMap()
        _textDomEl = L.DomUtil.create('div', 'graph_up', @$el[0])
        _textDomEl.innerHTML += "<div class='graph'></div>"
        console.log "_m", _m
        L.DomUtil.enableTextSelection(_textDomEl) 
        L.DomEvent.disableClickPropagation(_textDomEl )
        L.DomEvent.disableClickPropagation(L.DomUtil.get(_textDomEl))

        # L.DomEvent.disableClickPropagation(_textDomEl)
        _m.getPanes().overlayPane.appendChild(_textDomEl)
        _textDomObj = $(L.DomUtil.get(_textDomEl))
        draggable = new L.Draggable(_textDomEl)
        draggable.disable()
        L.DomEvent.disableClickPropagation(_textDomEl )
        L.DomEvent.disableClickPropagation(_textDomObj )
        _textDomEl.onmousedown = _textDomEl.ondblclick = L.DomEvent.stop
        _textDomEl.firstChild.onmousedown = _textDomEl.firstChild.ondblclick = L.DomEvent.stop
        L.DomEvent.addListener _textDomEl, 'mouseover', ((e) ->
          $(e.target).css('cursor','default')
          e.preventDefault()
        )
        _textDomObj.css('width', $(_m.getContainer())[0].clientWidth)
        _textDomObj.css('height', $(_m.getContainer())[0].clientHeight)
        # _textDomObj.css('right', $(_m.getContainer())[0].clientWidth/4)
        _textDomObj.css('background-color', 'white')
        _textDomObj.css('overflow', 'scroll')
        @el = @$el
        L.DomEvent.disableClickPropagation(@$el )
        L.DomUtil.setPosition(L.DomUtil.get(_textDomEl), L.point($(_m.getContainer())[0].clientWidth - $(_m.getContainer())[0].clientWidth/1.2, $(_m.getContainer())[0].clientHeight - $(_m.getContainer())[0].clientHeight/0.98), disable3D=0) 
        w = $(_m.getContainer())[0].clientWidth/1.2
        h = $(_m.getContainer())[0].clientHeight
        nodes = @artistNodes
        fx = new L.PosAnimation()
        #  good example:  http://jsfiddle.net/bc4um7pc/
        _graphEl = $(L.DomUtil.get('graph'))
        _graphEl.onmousedown = L.DomEvent.stop
        L.DomEvent.disableClickPropagation(_graphEl) 
        L.DomEvent.addListener _graphEl, 'click', (e) ->
            L.DomEvent.stopPropagation e
            return
        # console.log "_graphEl", _graphEl  
        vis = @vis = d3.select('.graph').append('svg:svg').attr('width', w).attr('height', h)
        force = @force = d3.layout.force().gravity(.15).linkDistance(100).charge(-80).size([
          w
          h
        ])
        @nodes = @force.nodes(d3.values(_nodes))
        links = @force.links()
        link = @vis.selectAll('.link').data(_links)
        link.enter().insert("line", ".node").attr("class", "link")
        link.exit().remove()
        
        node = @vis.selectAll('g.node').data(d3.values(_nodes), (d) ->
          d.name
        )
        nodeEnter = node.enter().append('g').attr('class', 'node').call(@force.drag)
        nodeEnter.append('circle').property("id", (d, i) => "node-#{i}").attr('r', w/225).style('fill', (d) =>
          if @artistNodes[d.name]
            console.log @artistNodes[d.name].edgetype
            if @artistNodes[d.name].edgetype == 'Organization'
              return 'red'
            else if @artistNodes[d.name].edgetype == 'Location'
              return 'blue'
            else if @artistNodes[d.name].edgetype == 'Date'
              return 'gray'
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
          )
          return
        
        # @force.on 'start', =>
        #   @force.tick()

        @force.start()

        L.DomUtil.addClass(_textDomEl, "leaflet-control-container")
        L.DomUtil.removeClass(_textDomEl, "graph_up")
    console.log "d3", d3
    console.log "looks like this is the best!"
    return

  GraphModule.makeMap = ->
    console.log d3
    map = $("#map-region").append("<div id='map'></div>")
    L.mapbox.accessToken = "pk.eyJ1IjoiYXJtaW5hdm4iLCJhIjoiSTFteE9EOCJ9.iDzgmNaITa0-q-H_jw1lJw"
    @_m = L.mapbox.map("map", "arminavn.l943a2kc",
        zoomAnimation: true
        attributionControl: false
        zoomAnimationThreshold: 4
        inertiaDeceleration: 4000
        animate: true
        duration: 1.75
        zoomControl: false
        infoControl: false
        easeLinearity: 0.1
        )
    # credits = L.control.attribution().addTo(map)
    # credits.addAttribution({"attribution": "<a href='https://www.mapbox.com/about/maps/' target='_blank'>&copy; Mapbox &copy; OpenStreetMap</a> <a class='mapbox-improve-map' href='https://www.mapbox.com/map-feedback/' target='_blank'>Improve this map</a>"});
    @_m.setView([
              42.34
              -71.12
            ], 13)
    @_m.boxZoom.enable()
    @_m.scrollWheelZoom.disable()
    @_m.dragging.disable()
    console.log "@_m", @_m
    return

  GraphModule.getGraph = ->
    graph = @vis
    return graph
  GraphModule.getMap = ->
    map = @_m
    return map

  GraphModule.getAllArtists = ->
    return @artistNodes
  GraphModule.makeControler = ($el, Width, Height, _margin, text, @_m)->
    console.log $el
    textControl = L.Control.extend(
      options:
        position: "topleft"
      onAdd: (map) =>
        @_m = map  
          # create the control container with a particular class name

        @_textDomEl = L.DomUtil.create('div', 'container paratext-info')
        @_el = L.DomUtil.create('svg', 'svg')
        @_m.getPanes().overlayPane.appendChild(@_el)
        # @_textDomEl_innerdiv = L.DomUtil.create('div', 'container paratext-info', 'container paratext-info')
        L.DomUtil.enableTextSelection(@_textDomEl)  
        @_m.getPanes().overlayPane.appendChild(@_textDomEl)
        @_textDomObj = $(L.DomUtil.get(@_textDomEl))
        @_textDomObj.css('width', $(@_m.getContainer())[0].clientWidth/3)
        @_textDomObj.css('height', $(@_m.getContainer())[0].clientHeight)
        @_textDomObj.css('background-color', 'white')
        @_textDomObj.css('overflow', 'scroll')
        L.DomUtil.setOpacity(L.DomUtil.get(@_textDomEl), .8)
        # here it needs to check to see if there is any vewSet avalable if not it should get it from the lates instance or somethign
        @_viewSet = @_m.getCenter() if @_viewSet is undefined
        L.DomUtil.setPosition(L.DomUtil.get(@_textDomEl), L.point(40, -65), disable3D=0)
        @_d3text = d3.select(".paratext-info")
        .append("ul").style("list-style-type", "none").style("padding-left", "0px")
        .attr("width", $(@_m.getContainer())[0].clientWidth/3 )
        .attr("height", $(@_m.getContainer())[0].clientHeight-80)
        @_d3li = @_d3text
        .selectAll("li")
        .data(text)
        .enter()
        .append("li")
        @_d3li.style("font-family", "Helvetica")
        .style("line-height", "2")
        .style("border", "0px solid gray")
        .style("margin-top", "10px")
        .style("padding-right", "20px")
        .style("padding-left", "40px")
        .attr("id", (d, i) =>
           "line-#{i}" 
          )
        .text((d,i) =>
          @_leafletli = L.DomUtil.get("line-#{i}")
          timeout = undefined
          L.DomEvent.addListener @_leafletli, 'click', (e) ->
            e.stopPropagation()
            # _this.hide_context()
            # _this.removeAnyLocation()
            # _this.setViewByLocation(d)
            # _this.showLocation(d)
            # _this._viewSet = _this._m.getCenter() if _this._viewSet is undefined
             # showLocation(d)
          L.DomEvent.addListener @_leafletli, 'mouseout', (e) =>
            timeout = 0
            # e.stopPropagation()
            setTimeout (->
              $(L.DomUtil.get(_this._domEl)).animate
                opacity: 0
              , 100, ->

              return

            # Animation complete.
            )
          L.DomEvent.addListener @_leafletli, 'mouseover', (e) ->
            # L.DomUtil.getViewportOffset(_domEl)
            $(this).css('cursor','pointer')
            # e.stopPropagation()
            # _this.clearMap()
            # _this.removeAnyLocation()
            application.vent.trigger 'addNodes', d
            application.vent.trigger 'onArtist', d
            timeout = setTimeout(->
              _this._m._initPathRoot()
              if timeout isnt 0 
                console.log "d", d
                # _this.setViewByLocation(d)
                # _this.showLocation(d)
                # _this.vizLocation(d, i)
                
                # _this.find_relations(d)
                # _this.show_contexts(d, e)
                timeout = 0
                # _this._viewSet = _this._m.getCenter() if _this._viewSet is undefined
            , 900)
            return 
          , ->
            return
          d.Name   
        )
        .style("font-size", "16px")
        .style("color", "rgb(72,72,72)" )
        .on("mouseover", (d,i) ->
          $(this).css('cursor','pointer')
          d3.select(this).transition().duration(0).style("color", "black").style("background-color", "rgb(208,208,208) ").style "opacity", 1
          L.DomEvent.disableClickPropagation(this) 
          L.DomEvent.disableClickPropagation($("#graph_up")) 
          return 
        ).on("mouseout", (d,i) ->
          d3.select(this).transition().duration(1000).style("color", "rgb(72,72,72)").style("background-color", "white").style "opacity", 1
          L.DomEvent.disableClickPropagation(this) 
          return
        )  
        .transition().duration(1).delay(1).style("opacity", 1)
        # @_m.whenReady =>
        #   @_m.setView([
        #     42.34
        #     -71.12
        #   ], 13)
        @_textDomEl
      onSetView: (map) =>
        @_m = map


    )
    console.log @_m
    div = new textControl()
    @_m.addControl div
    return @_m

  return





