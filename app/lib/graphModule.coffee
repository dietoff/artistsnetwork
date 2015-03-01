# night used
application = require('application')

application.module 'GraphModule', (GraphModule, App, Backbone, Marionette, $, _) ->
  @startWithParent = false
  GraphModule.Controller =

      highlightLinksBy: (sourceNode) =>
        @vis.selectAll("line").filter((d, i) ->
          d.source.name == sourceNode.name
        ).transition().duration(200).style("opacity", 0.9)
        return

      resetHighlightLinksBy: =>
        @vis.selectAll("line").style("opacity", 0.0)

      highlightNodesBy: (sourceNode) =>
        # selectedNodes = []
        @_links.forEach (link) => 
            if link.source.name == sourceNode.name
              @vis.selectAll("circle").filter((d, i) =>
                d.name == link.target.name
                # selectedNodes.push 'lat': +d.lat, 'long': +d.long if d.name == link.target.name
              ).on("click", (d, i) =>
              ).transition().duration(1
              ).style("opacity", 0.5
              ).attr("r", 5
              ).style("fill", (d) =>
                return @color(1)# @color(sourceNode.id)
              ).style("stroke", (d) =>
                return  @color(1)# @color(sourceNode.id)
              ).style("stroke-width", 4
              ).text( (d, i) =>
                _leafletli = L.DomUtil.get("node-#{i}")
                timeout = undefined
                L.DomEvent.addListener _leafletli, 'click', (e) =>
                  # d3.selectAll(nodeEnter[0]).style("color", "black").style("background-color", "white"
                  # ).style "opacity", 1
                  timeout = 0
                  timeout = setTimeout(->
                    # 
                    # @_m._initPathRoot()
                    if timeout isnt 0 
                      timeout = 0
                      # GraphModule.Controller.highlightNodesBy(d)
                  , 600)
                  return 
                , ->

                  return
                  e.stopPropagation()
                return d.name
              ).transition().duration(900
              ).style("opacity", 1
              ).attr("r", 20
              ).style("stroke", (d) =>
                return  @color(1) #@color(sourceNode.id)
              # ).style("fill", (d) =>
              #   return "none"
              ).style("stroke-width", 1
              ).transition().delay(50).duration(200
              ).attr("r", 10
              ).style("stroke", (d) =>
                return @color(1)# @color(sourceNode.id)
              ).style("fill", (d) =>
                return @color(1)#@color(sourceNode.id)
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
          if d.group
            return 0
          else 
            return 0
        ).style("stroke-width", 1)
        @vis.selectAll("text.nodetext").transition().duration(500).style("opacity", 0)


      showBio: (d) =>
        L.DomUtil.setOpacity(L.DomUtil.get(@_bios_domEl), 0.75)
        @fx.run(L.DomUtil.get(@_bios_domEl), L.point(-$(@_m.getContainer())[0].clientWidth/3, 40), 0.5)
        if @biosFetched is undefined
          textResponse = $.ajax
                      url: "http://localhost:3001/biosby/#{d.name}"
                      success: (result) ->
                        $el = $('#bios')
                        @biosTextResults = result
      
      makeOrgGraph: () =>
        console.log "makeOrgGraph inside GraphModule that should be removed"

      allNodes: () =>
        return @_nodes

      allLinks: () =>
        return @_links
      # startForce: =>
      #   @force.start()

      # stopForce: =>
      #   @force.stop()

      # write methods
      # # getAllNodes
      # # getNodesBy(name, value)

  class GraphModule.Router extends Marionette.AppRouter
    appRoutes:
      "highlightLinksBy" : "highlightLinksBy"
      "resetHighlightLinksBy" : "resetHighlightLinksBy"
      "highlightNodesBy" : "highlightNodesBy"
      "resetHighlightNodesBy" : "resetHighlightNodesBy"
      "showBio" : "showBio"

  API = 

    map: () ->
      GraphModule.Controller.makeMap() 

    highlightLinksBy: (d) ->
      GraphModule.Controller.highlightLinksBy(d)

    resetHighlightLinksBy: () ->
      GraphModule.Controller.resetHighlightLinksBy(d)   

    highlightNodesBy: (d) ->
      GraphModule.Controller.highlightNodesBy(d)    

    resetHighlightNodesBy: -> 
      GraphModule.Controller.resetHighlightNodesBy()

    startForce: () ->
      GraphModule.Controller.startForce()      

    stopForce: () ->
      GraphModule.Controller.stopForce()      

    showBio: (d) ->
      GraphModule.Controller.showBio(d)

  App.addInitializer ->
    new GraphModule.Router
      controller: API 
  # The context of the function is also the module itself
  this == GraphModule

  # => true
  # Private Data And Functions
  # --------------------------
  myData = 'this is private data'
  ifControl = false
  # noFollowLinks = true
  inWidth = 60
  stopForce = =>
    @force.stop()
    return

  # Public Data And Functions
  # -------------------------
  GraphModule.someData = 'public data'

  GraphModule.connectBios = (_m, d, i) ->
    points = []
    # points.push _m.layerPointToLatLng(_m.latLngToLayerPoint(L.latLng(d.lat, d.long)))
    # points.push _m.layerPointToLatLng(_m.containerPointToLayerPoint([L.DomUtil.getViewportOffset(document.getElementById("line-#{i}")).x + 30 + $(_m.getContainer())[0].clientWidth/3, L.DomUtil.getViewportOffset(document.getElementById("line-#{i}")).y]))
  GraphModule.getAllNodes = ->
    artistNodes = []
    d3.json 'http://localhost:3001/artists', (error, nodes) =>
      id = 0
      for artist in nodes
        # make a list of artist names when data arrives and keep it
        artistNodes.push {'name' :artist.source, 'id': id, 'group': artist.group}
        id = id + 1
      @artistNodes = artistNodes
    return @artistNodes

  GraphModule.makeBioController = ->
    divControl = L.Control.extend(  
      initialize: =>
        position = "left"
        _domEl = L.DomUtil.create('div', "container " + "bioController" + "-info")
        L.DomUtil.enableTextSelection(_domEl)  
        @_m.getContainer().getElementsByClassName("leaflet-control-container")[0].appendChild(_domEl)
        _domObj = $(L.DomUtil.get(_domEl))
        _domObj.css('width', $(@_m.getContainer())[0].clientWidth/3)
        _domObj.css('height', $(@_m.getContainer())[0].clientHeight/3)
        _domObj.css('background-color', 'white')
        L.DomUtil.setOpacity(L.DomUtil.get(_domEl), 0.0)
        L.DomUtil.setPosition(L.DomUtil.get(_domEl), L.point(-$(@_m.getContainer())[0].clientWidth/1.2, 0), disable3D=0)
        @fx = new L.PosAnimation()
        @fx.run(L.DomUtil.get(_domEl), position, 0.9)
        @_bios_domEl = _domEl
        @_d3BiosEl = d3.select(_domEl)
    )
    new divControl()
    return #_domEl

  GraphModule.makeGraph = ->
    @$el = $('graph-map')
    d3.json 'http://localhost:3001/artists', (error, nodes) =>
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
        # Compute the distinct nodes from the links.
        _links.forEach (link) ->
          link.source = _nodes[link.source] or (_nodes[link.source] = name: link.source)
          link.target = _nodes[link.target] or (_nodes[link.target] = {name: link.target, group: link.group, lat: link.lat, long: link.long})

          return
        _m = @getMap()
        @_nodes = _nodes
        @_links = _links
        _textDomEl = L.DomUtil.create('div', 'graph_up', @$el[0])
        _textDomEl.innerHTML += "<div class='graph'></div>"
        L.DomUtil.enableTextSelection(_textDomEl) 
        # L.DomEvent.disableClickPropagation(_textDomEl )
        # L.DomEvent.disableClickPropagation(L.DomUtil.get(_textDomEl))

        # L.DomEvent.disableClickPropagation(_textDomEl)
        _m.getPanes().overlayPane.appendChild(_textDomEl)
        offset = L.DomUtil.getViewportOffset _textDomEl
        _textDomObj = $(L.DomUtil.get(_textDomEl))
        draggable = new L.Draggable(_textDomEl)
        draggable.disable()
        # L.DomEvent.disableClickPropagation(_textDomEl )
        # L.DomEvent.disableClickPropagation(_textDomObj )
        _textDomEl.onmousedown = _textDomEl.ondblclick = L.DomEvent.stop
        _textDomEl.firstChild.onmousedown = _textDomEl.firstChild.ondblclick = L.DomEvent.stop
        L.DomEvent.addListener _textDomEl, 'mouseover', ((e) ->
          $(e.target).css('cursor','default')
          e.preventDefault()
        )
        _textDomObj.css('width', $(_m.getContainer())[0].clientWidth)
        _textDomObj.css('height', $(_m.getContainer())[0].clientHeight)
        # _textDomObj.css('right', $(_m.getContainer())[0].clientWidth/4)
        _textDomObj.css('background-color', 'none')
        _textDomObj.css('overflow', 'scroll')
        @el = @$el
        # L.DomEvent.disableClickPropagation(@$el )

        # set the location of the force graph's elemetnt using leaflet
        # L.DomUtil.setPosition(L.DomUtil.get(_textDomEl), offset, $(_m.getContainer())[0].clientHeight - $(_m.getContainer())[0].clientHeight/0.98), disable3D=0) 
        w = $(_m.getContainer())[0].clientWidth#/1.2
        h = $(_m.getContainer())[0].clientHeight
        nodes = @artistNodes
        fx = new L.PosAnimation()
        #  good example:  http://jsfiddle.net/bc4um7pc/
        _graphEl = $(L.DomUtil.get('graph'))
        _graphEl.onmousedown = L.DomEvent.stop
        # L.DomEvent.disableClickPropagation(_graphEl) 
        L.DomEvent.addListener _graphEl, 'click', (e) ->
            L.DomEvent.stopPropagation e
            return


        # setup the color scale
        @color = d3.scale.category10()
        # some basic example http://jsfiddle.net/simonraper/bpKG4/light/
        vis = @vis = d3.select('.graph').append('svg:svg').attr('width', w).attr('height', h)
        force = @force = d3.layout.force(
        ).gravity(.25
        ).linkDistance(40
        # ).charge(-80
        ).size([
          w
          h
        ])
        @nodes = @force.nodes(d3.values(_nodes))
        links = @force.links()
        link = @vis.selectAll('.link').data(_links)
        # link.enter().insert("line", ".node").attr("class", "link").style("opacity", 0.1)
        # link.exit().remove()
        
        node = @vis.selectAll('g.node'
        ).data(d3.values(_nodes), (d) ->
          d.name
        )
        color = @color
        _artistNodes = @_nodes
        nodeEnter = node.enter().append('g').attr('class', 'node').call(@force.drag)
        nodeEnter.attr("class", "leaflet-zoom-hide")
        nodeEnter.append('circle').property("id", (d, i) => "node-#{i}").attr('r', (d) ->
          if d.group in [0..3]
            return 10
          else
            return 0
        ).attr('x', '-1px').attr('y', '-1px').attr('width', '4px').attr('height', '4px'
        ).style("stroke", "none"
        ).style("opacity", 0.6).style('fill', (d) =>
          if d.group 
            return @color(1)  #(d.group)
          else
            return "node"
        )
        nodeEnter.append('text').attr('class', 'nodetext').attr('dx', 12).attr('dy', '.35em').style("opacity", 0).attr("fill", (d, i) ->
          return "gray" #color(i)
        ).attr('id', (d,i) ->
          return i
        ).text((d, i) ->
          if d.group in [0..3]
            _leafletli = L.DomUtil.get("node-#{i}")
            timeout = undefined
            L.DomEvent.addListener _leafletli, 'click', (e) =>
              # d3.selectAll(nodeEnter[0]).style("color", "black").style("background-color", "white"
              # ).style "opacity", 1
              timeout = 0
              timeout = setTimeout(->
                # 
                # @_m._initPathRoot()
                if timeout isnt 0 
                  timeout = 0
                  # GraphModule.Controller.highlightNodesBy(d)
              , 600)
              return 
            , ->

              return
              e.stopPropagation()

            return d.name# color(d.group)
        )

        node.exit().remove()


        @noFollowLinks = true
        @force.on 'tick', =>
          try
            node.attr('transform', (d) =>
              if d.group == 1 and d.lat
                'translate(' + _m.latLngToLayerPoint(L.latLng(d.long, d.lat)).x + ',' + _m.latLngToLayerPoint(L.latLng(d.long, d.lat)).y + ')'
              else
                'translate(' + d.x + ',' + d.y + ')'
            )
            link.attr('x1', (d) =>
              d.source.x
            ).attr('y1', (d) =>
              d.source.y
            ).attr('x2', (d) ->
              if d.target.long and (document.getElementById("line-#{d.source.index}")) and $("#line-#{d.source.index}").position().top < 1000 and $("#line-#{d.source.index}").position().top > 15
                _m.latLngToLayerPoint(L.latLng(d.target.long, d.target.lat)).x
              else
                d.target.x
            ).attr 'y2', (d) ->
              if d.target.long and (document.getElementById("line-#{d.source.index}")) and $("#line-#{d.source.index}").position().top < 1000 and $("#line-#{d.source.index}").position().top > 15
                _m.latLngToLayerPoint(L.latLng(d.target.long, d.target.lat)).y
              else
                d.target.y
          catch e
          return
        
        @force.on 'start', =>
          link.property("id", (d, i) => 
            "linksource-#{d.source.index}"
          ) 
        #   @force.tick()

        @force.start()
    return


  GraphModule.makeMap = ->
    L.mapbox.accessToken = "pk.eyJ1IjoiYXJtaW5hdm4iLCJhIjoiSTFteE9EOCJ9.iDzgmNaITa0-q-H_jw1lJw"
    try 
      @_m = L.mapbox.map("map", "arminavn.jhehgjan
        ",
          zoomAnimation: false
          dragAnimation: false
          attributionControl: false
          zoomAnimationThreshold: 10
          inertiaDeceleration: 4000
          animate: false
          duration: 1.75
          # zoomControl: false
          infoControl: false
          easeLinearity: 0.1
          )
    catch
      $("#map-region").append("<div id='map'></div>")
    @_m.setView([
              42.34
              0.12
            ], 3)
    @_m.boxZoom.enable()
    @_m.scrollWheelZoom.disable()
    @_m.dragging.disable()
    @_m.on 'zoomstart', =>
      @force.stop()
    @_m.on 'zoomend dragend', =>
      @force.start()
    return

  GraphModule.getGraph = ->
    graph = @vis
    return graph
  GraphModule.getForce = ->
    force = @force
    return force
  GraphModule.getMap = ->
    map = @_m
    return map

  GraphModule.getAllArtists = ->
    return @_text


  GraphModule.makeDivList = ($el, Width, Height, _margin, text)->
        # L.DomUtil.removeClass(L.DomUtil.get("region-bios"), "col-md-2")
        # L.DomUtil.removeClass(L.DomUtil.get("map-region"), "col-md-12")
        try
          L.DomUtil.addClass(L.DomUtil.get("map-region"), "col-md-10")
        catch e
          
          $("#content").html '<div class="row" id="main-content">
                                <div class="row" >
                                  <div id="switch" class="col-md-2 col-md-offset-2">
                                    <span class="glyphicon-class"></span><a><span id="switch-icon" class="glyphicon glyphicon-cog">  </span></a>
                                  </div>
                                </div>
                              <div class="row" >
                                <div class="col-md-2" id="region-bios">
                                </div>  
                               <div class="col-md-12" id="map-region">
                                <div class="col-md-6" id="region-graph">
                                </div>
                               </div>
                              </div>'
          $el = $('#main-content')        
        
        id = 0
        @artistBios = []
        # for bios in text
          # make a list of artist names when data arrives and keep it
          # @artistNodes.push {'name' :artist.source, 'id': id, 'group': artist.group}
          # id = id + 1
        # text = []
        if @_nodes
          text = []
          for key, value of @_nodes            
            if value.group in [1..4]
            
            else  
              text.push {name: value.name, id: value.index, group: value.group}
        # else
        #   text = GraphModule.getAllNodes()
        else
          @_text = text
        @_m = GraphModule.getMap()  
        # create the control container with a particular class name

        biosRegion = $("#region-bios")
        @_textDomEl = L.DomUtil.create('div', 'container paratext-info')
        @_el = L.DomUtil.create('svg', 'svg')
        # @_m.getPanes().overlayPane.appendChild(@_el)
        
        biosRegion.append @_textDomEl
        # @_textDomEl_innerdiv = L.DomUtil.create('div', 'container paratext-info', 'container paratext-info')
        L.DomUtil.enableTextSelection(@_textDomEl)  
        # @_m.getPanes().overlayPane.appendChild(@_textDomEl)
        @_textDomObj = $(L.DomUtil.get(@_textDomEl))
        @inWidth = $el[0].clientWidth/5
        @_textDomObj.css('width', $el[0].clientWidth)
        @_textDomObj.css('height', "700px")
        @_textDomObj.css('background-color', 'none')
        @_textDomObj.css('overflow', 'scroll')
        L.DomUtil.setOpacity(L.DomUtil.get(@_textDomEl), .8)

        # here it needs to check to see if there is any vewSet avalable if not it should get it from the lates instance or somethign
        color = @color
        # @_viewSet = @_m.getCenter() if @_viewSet is undefined
        @_d3text = d3.select(".paratext-info")
        .append("ul"
        ).style("list-style-type", "none"
        ).style("padding-left", "0px"
        ).style('overflow', 'scroll'
        ).attr("id", "bios-list")
        .attr("width", $el[0].clientWidth)
        .attr("height", $el[0].clientHeight)
        @_d3li = @_d3text
        .selectAll("li")
        .data(text)
        .enter()
        .append("li")
        @_d3li.style("font-family", "Gill Sans").style("font-size", "12px")
        .style("line-height", "1")
        .style("border", "0px solid black")
        .style("margin-top", "20px")
        .style("padding-right", "20px")
        .style("padding-left", "40px")
        .attr("id", (d, i) =>
            @artistBios.push {'name' :d.name, 'id': i}
            return "line-#{i}" 
        ).on("mouseover", (d) ->
          $(this).css('cursor','pointer')
        ).on("click", (d,i) ->
          L.DomEvent.disableClickPropagation(this) 
          d3.select(this).transition().duration(0).style("color", "black").style("background-color", (d, i) ->
            "white"
          ).style "opacity", 1
          d3.select(this).transition().duration(1000).style("color", "rgb(72,72,72)").style("background-color", (d, i) =>
            id = d3.select(this).attr("id").replace("line-", "")
            return color(1) # color(id)
          ).style("opacity", 1)
          
          return
        ).append("text").text((d,i) =>
          if d.group in[0..3]

          else
            @_leafletli = L.DomUtil.get("line-#{i}")
            timeout = undefined
            L.DomEvent.addListener @_leafletli, 'click', (e) =>
              d3.selectAll(@_d3li[0]).style("color", "black").style("background-color", "white"
              ).style "opacity", 1
              GraphModule.Controller.resetHighlightLinksBy()
              GraphModule.Controller.resetHighlightNodesBy()
              timeout = 0
              timeout = setTimeout(->
                # 
                _this._m._initPathRoot()
                if timeout isnt 0 
                  timeout = 0
                  GraphModule.Controller.highlightNodesBy(d)
                  GraphModule.Controller.showBio(d)
              , 600)
              return 
            , ->

              return
              e.stopPropagation()
            # L.DomEvent.addListener @_leafletli, 'mouseout', (e) =>
            #   timeout = 0
              
            #   # @force.resume()
            #   setTimeout (->
            #     $(L.DomUtil.get(_this._domEl)).animate
            #       opacity: 0
            #     , 100, ->

            #     return

            #   # Animation complete.
            #   )
            # L.DomEvent.addListener @_leafletli, 'mouseover', (e) ->
            #   _this.force.stop()
            #   $(this).css('cursor','pointer')
            #   e.stopPropagation()

            #   timeout = setTimeout(->
            #     # 
            #     _this._m._initPathRoot()
            #     if timeout isnt 0 
            #       timeout = 0
            #       GraphModule.Controller.highlightNodesBy(d)
            #   , 900)
            #   return 
            # , ->

            #   return
            d.name
        ).style("font-family", "Gill Sans").style("font-size", "14px"
        ).style("color", "black"
        ).transition().duration(1).delay(1).style("opacity", 1
        )

    return @_textDomEl

  return





