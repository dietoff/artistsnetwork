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

  GraphModule.someFunction = ->
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
    return

  GraphModule.getMap = ->
    map = @_m
    return map

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
            _this._viewSet = _this._m.getCenter() if _this._viewSet is undefined
             # showLocation(d)
          L.DomEvent.addListener @_leafletli, 'mouseout', (e) ->
            timeout = 0
            e.stopPropagation()
            application.vent.trigger 'addNodes', d
            setTimeout (->
              $(L.DomUtil.get(_this._domEl)).animate
                opacity: 0
              , 100, ->

              return

            # Animation complete.
            )
            # L.DomUtil.setOpacity(L.DomUtil.get(_this._domEl), 0)
            # _this.removeAnyLocation()

          L.DomEvent.addListener @_leafletli, 'mouseover', (e) ->
            # L.DomUtil.getViewportOffset(_domEl)
            $(this).css('cursor','pointer')
            e.stopPropagation()
            # _this.clearMap()
            # _this.removeAnyLocation()
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
                _this._viewSet = _this._m.getCenter() if _this._viewSet is undefined
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
          return 
        ).on("mouseout", (d,i) ->
          d3.select(this).transition().duration(1000).style("color", "rgb(72,72,72)").style("background-color", "white").style "opacity", 1
          return
        )  
        .transition().duration(1).delay(1).style("opacity", 1)
        @_m.whenReady =>
          @_m.setView([
            42.34
            -71.12
          ], 13)
        @_textDomEl
      onSetView: (map) =>
        @_m = map


    )
    console.log @_m
    div = new textControl()
    @_m.addControl div
    return @_m

  return





