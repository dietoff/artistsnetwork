application = require('application')

application.module 'BiotrajModule', (BiotrajModule, App, Backbone, Marionette, $, _) ->
  @startWithParent = false
  BiotrajModule.Controller =

      BiotrajModule: =>
        console.log "makeBiotrajModule"
        BiotrajModule.putBiotrajGraph()
        return
      Location: =>
        application.ViewController.network()
        
        


      # write methods
      # # getAllNodes
      # # getNodesBy(name, value)

  class BiotrajModule.Router extends Marionette.AppRouter
    appRoutes:
      "BiotrajModule" : "BiotrajModule"
      'location' : 'Location'

  API = 

    BiotrajModule: () ->
      BiotrajModule.Controller.BiotrajModule()   

    Location: () ->
      application.vent.trigger "network"
      

  BiotrajModule.addInitializer ->
    new BiotrajModule.Router
      controller: API 
  BiotrajModule.addInitializer ->

  # The context of the function is also the module itself
  this == BiotrajModule

  # => true
  # Private Data And Functions
  # --------------------------
  myData = 'this is private data'

  # Public Data And Functions
  # -------------------------
  BiotrajModule.someData = 'public data'

  BiotrajModule.makeBiotrajModule = () ->
    console.log "makeBiotrajModule"

  BiotrajModule.putBiotrajGraph= () ->
    module.exports = class BiotrajView extends Backbone.Marionette.LayoutView
          template: 'views/templates/biotraj'
          id: 'biotraj-graph'
          el: '#biotraj-graph'
          # ui: 'switch-person' : '#person-graph'
          # triggers: 'click @ui.switch-person' : 'switch-person:do:view'
          # regions:
          #   person: "#person-graph"
        initialize: ->

        onShow: ->
#             $("biotraj-graph").html('<canvas>
# <script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
# <script src="jquery.zoomooz.min.js"></script>

# <center><p>Plot maps of selected biographies.</p></center><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1001.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1002.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1003.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1004.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1005.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1006.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1007.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1008.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1009.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1010.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1011.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1012.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1013.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1014.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1015.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1016.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1017.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1018.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1019.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1020.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1021.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1022.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1023.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1024.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1025.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1026.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1027.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1028.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1029.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1030.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1031.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1032.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1033.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1034.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1035.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1036.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1037.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1038.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1039.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1040.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1041.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1042.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1043.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1044.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1045.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1046.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1047.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1048.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1049.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1050.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1051.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1052.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1053.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1054.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1055.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1056.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1057.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1058.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1059.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1060.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1061.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1062.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1063.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1064.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1065.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1066.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1067.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1068.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1069.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1070.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1071.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1073.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1074.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1075.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1076.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1077.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1078.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1079.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1080.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1081.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1082.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1083.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1084.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1085.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1086.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1087.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1088.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1090.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1092.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1093.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1094.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1095.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1096.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1097.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1098.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1099.png" width="200px"></div><div class="zoomTarget" data-targetsize="0.8" data-closeclick="true"><img src="pmimages/1100.png" width="200px"></div></canvas>'


#             )
            # $(document).ready =>
              

            #d3 code mainly from http://bl.ocks.org/mbostock/4062045 and http://bl.ocks.org/mbostock/2706022
            
      # ---
      # generated by js2coffee 2.0.1
            @on "switch-biotraj:do:view", =>
            console.log "switch-biotraj trigger"
            # @biosView = new BiosView()      
            # @regionBios.show(@biosView)
            # @orgGraphView = new OrgGraphView()
            # @regionGraph.show(@orgGraphView)
            # application.GraphModule.Controller.makeOrgGraph()
    
    console.log @
    console.log BiotrajModule
    application.module("GraphModule").stop()
    # application.layout.remove(application.GraphView)
    application.layout.content.empty()
    $("#content").html("")
    $("svg").html("")
    $("svg").css("height", "0px")
    $("#content").append "<div id='biotraj-graph'></div>"
    # console.log personView
    @layout = new BiotrajView()
    console.log application
    # application.layout.header.show("headerView")
    BiotrajModule.layout.render()

    


  