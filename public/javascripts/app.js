(function(/*! Brunch !*/) {
  'use strict';

  var globals = typeof window !== 'undefined' ? window : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};

  var has = function(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function(root, name) {
    var results = [], parts, part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join('/').split('/');
    } else {
      parts = name.split('/');
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute, path);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    cache[name] = module;
    definition(module.exports, localRequire(name), module);
    return module.exports;
  };

  var require = function(name, loaderPath) {
    var path = expand(name, '.');
    if (loaderPath == null) loaderPath = '/';

    if (has(cache, path)) return cache[path].exports;
    if (has(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has(cache, dirIndex)) return cache[dirIndex].exports;
    if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '" from '+ '"' + loaderPath + '"');
  };

  var define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has(bundle, key)) {
          modules[key] = bundle[key];
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  var list = function() {
    var result = [];
    for (var item in modules) {
      if (has(modules, item)) {
        result.push(item);
      }
    }
    return result;
  };

  globals.require = require;
  globals.require.define = define;
  globals.require.register = define;
  globals.require.list = list;
  globals.require.brunch = true;
})();
require.register("application", function(exports, require, module) {
var Application,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

require('lib/view_helper');

Application = (function(_super) {
  __extends(Application, _super);

  function Application() {
    this.initialize = __bind(this.initialize, this);
    return Application.__super__.constructor.apply(this, arguments);
  }

  Application.prototype.initialize = function() {
    this.on("start", (function(_this) {
      return function(options) {
        Backbone.history.start();
        return typeof Object.freeze === "function" ? Object.freeze(_this) : void 0;
      };
    })(this));
    this.addInitializer((function(_this) {
      return function(options) {
        var AppLayout, HeaderFooter;
        AppLayout = require('views/AppLayout');
        _this.layout = new AppLayout();
        HeaderFooter = require('lib/HeaderFooter');
        _this.layout.on("render", function() {
          console.log("onRender");
          return _this.module("HeaderFooter").start();
        });
        return _this.layout.render();
      };
    })(this));
    this.addInitializer((function(_this) {
      return function(options) {
        var BiotrajModule, OrgGraph, PersonModule, Router;
        Router = require('lib/router');
        OrgGraph = require('lib/OrgGraph');
        PersonModule = require('lib/PersonModule');
        BiotrajModule = require('lib/BiotrajModule');
        _this.vent = new Backbone.Wreqr.EventAggregator();
        _this.vent.on('netwotk', function() {
          Backbone.history.navigate("", {
            trigger: false
          });
          return Backbone.history.navigate("location", {
            trigger: false
          });
        });
        _this.vent.on('addNodes', function(d) {
          return Backbone.history.navigate("graph/" + d.name, {
            trigger: true
          });
        });
        _this.vent.on('getLinksBy', function(d) {
          return _this.GraphModule.Controller.getLinksBy(d);
        });
        _this.vent.on('organization', function() {
          _this.OrgGraph.Controller.OrgGraph();
          Backbone.history.navigate("", {
            trigger: false
          });
          return Backbone.history.navigate("organization", {
            trigger: false
          });
        });
        _this.vent.on("person", function() {
          console.log("preson in vent");
          console.log(_this);
          _this.module("PersonModule").start();
          return Backbone.history.navigate("person", {
            trigger: false
          });
        });
        _this.vent.on("biotraj", function() {
          console.log("biotraj in vent");
          _this.module("BiotrajModule").start();
          return Backbone.history.navigate("biotraj", {
            trigger: false
          });
        });
        return _this.router = new Router();
      };
    })(this));
    return this.start();
  };

  return Application;

})(Backbone.Marionette.Application);

module.exports = new Application();
});

;require.register("initialize", function(exports, require, module) {
var application;

application = require('application');

$(function() {
  return application.initialize();
});
});

;require.register("lib/BiotrajModule", function(exports, require, module) {
var application,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

application = require('application');

application.module('BiotrajModule', function(BiotrajModule, App, Backbone, Marionette, $, _) {
  var API, myData;
  this.startWithParent = false;
  BiotrajModule.Controller = {
    BiotrajModule: (function(_this) {
      return function() {
        console.log("makeBiotrajModule");
        BiotrajModule.putBiotrajGraph();
      };
    })(this),
    Location: (function(_this) {
      return function() {
        return application.ViewController.network();
      };
    })(this)
  };
  BiotrajModule.Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.appRoutes = {
      "BiotrajModule": "BiotrajModule",
      'location': 'Location'
    };

    return Router;

  })(Marionette.AppRouter);
  API = {
    BiotrajModule: function() {
      return BiotrajModule.Controller.BiotrajModule();
    },
    Location: function() {
      return application.vent.trigger("network");
    }
  };
  BiotrajModule.addInitializer(function() {
    return new BiotrajModule.Router({
      controller: API
    });
  });
  BiotrajModule.addInitializer(function() {});
  this === BiotrajModule;
  myData = 'this is private data';
  BiotrajModule.someData = 'public data';
  BiotrajModule.makeBiotrajModule = function() {
    return console.log("makeBiotrajModule");
  };
  return BiotrajModule.putBiotrajGraph = function() {
    var BiotrajView;
    module.exports = BiotrajView = (function(_super) {
      __extends(BiotrajView, _super);

      function BiotrajView() {
        return BiotrajView.__super__.constructor.apply(this, arguments);
      }

      BiotrajView.prototype.template = 'views/templates/biotraj';

      BiotrajView.prototype.id = 'biotraj-graph';

      BiotrajView.prototype.el = '#biotraj-graph';

      return BiotrajView;

    })(Backbone.Marionette.LayoutView);
    ({
      initialize: function() {},
      onShow: function() {
        this.on("switch-biotraj:do:view", (function(_this) {
          return function() {};
        })(this));
        return console.log("switch-biotraj trigger");
      }
    });
    console.log(this);
    console.log(BiotrajModule);
    application.module("GraphModule").stop();
    application.layout.content.empty();
    $("#content").html("");
    $("svg").html("");
    $("svg").css("height", "0px");
    $("#content").append("<div id='biotraj-graph'></div>");
    this.layout = new BiotrajView();
    console.log(application);
    return BiotrajModule.layout.render();
  };
});
});

;require.register("lib/HeaderFooter", function(exports, require, module) {
var application,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

application = require('application');

application.module('HeaderFooter', function(HeaderFooter, App, Backbone, Marionette, $, _) {
  var API, myData;
  this.startWithParent = false;
  HeaderFooter.Controller = {
    HeaderFooter: (function(_this) {
      return function() {
        console.log("makeHeaderFooter");
      };
    })(this),
    Location: (function(_this) {
      return function() {
        console.log("applicatoin in header router", application);
        application.ViewController.network();
      };
    })(this),
    Person: (function(_this) {
      return function() {
        console.log("person in header modfu;e");
      };
    })(this)
  };
  HeaderFooter.Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.appRoutes = {
      "HeaderFooter": "HeaderFooter",
      'location': 'Location',
      'person': 'Person',
      'biotraj': 'Biotraj'
    };

    return Router;

  })(Marionette.AppRouter);
  API = {
    HeaderFooter: function() {
      return HeaderFooter.Controller.HeaderFooter();
    },
    Location: function() {
      return application.vent.trigger("network");
    },
    Person: function() {
      return application.vent.trigger("person");
    },
    Biotraj: function() {
      return application.vent.trigger("biotraj");
    }
  };
  HeaderFooter.addInitializer(function() {
    return new HeaderFooter.Router({
      controller: API
    });
  });
  HeaderFooter.addInitializer(function() {
    module.exports = HeaderFooter = (function(_super) {
      __extends(HeaderFooter, _super);

      function HeaderFooter() {
        return HeaderFooter.__super__.constructor.apply(this, arguments);
      }

      HeaderFooter.prototype.template = 'views/templates/headerfooter';

      HeaderFooter.prototype.id = 'header';

      HeaderFooter.prototype.el = '#header';

      HeaderFooter.prototype.ui = {
        'switch-organization': '#organization'
      };

      HeaderFooter.prototype.triggers = {
        'click @ui.switch-organization': 'switch-organization:do:view'
      };

      HeaderFooter.prototype.regions = {
        header: "#header"
      };

      return HeaderFooter;

    })(Backbone.Marionette.LayoutView);
    ({
      initialize: function() {},
      onShow: function() {
        var update;
        $(document).ready((function(_this) {
          return function() {
            _this.on("switch-organization:do:view", function() {});
            return console.log("switch-organization trigger");
          };
        })(this));
        update = function() {
          var inputvalue;
          inputvalue = $("searchinput").val();
          return console.log("this inout", inputvalue);
        };
        update();
        return $('input').change(update);
      }
    });
    this.layout = new HeaderFooter();
    console.log(application);
    return this.layout.render();
  });
  this === HeaderFooter;
  myData = 'this is private data';
  HeaderFooter.someData = 'public data';
  return HeaderFooter.makeHeaderFooter = function() {
    return console.log("makeHeaderFooter");
  };
});
});

;require.register("lib/OrgGraph", function(exports, require, module) {
var application,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

application = require('application');

application.module('OrgGraph', function(OrgGraph, App, Backbone, Marionette, $, _) {
  var API, myData, toggle;
  this.startWithParent = true;
  OrgGraph.Controller = {
    OrgGraph: (function(_this) {
      return function() {
        OrgGraph.makeOrgGraph();
      };
    })(this),
    highlightNodesBy: (function(_this) {
      return function(sourceNode) {
        _this._links.forEach(function(link) {
          if (link.source.name === sourceNode.name) {
            _this.vis.selectAll("circle").filter(function(d, i) {
              return d.name === link.target.name;
            }).transition().duration(100).style("opacity", 1).attr("r", 10).style("fill", function(d) {
              return _this.color(d.group);
            }).style("stroke", function(d) {
              return _this.color(d.group);
            }).style("stroke-width", 4).transition().duration(900).style("opacity", 1).attr("r", 20).style("stroke", function(d) {
              return _this.color(d.group);
            }).style("stroke-width", 1).transition().delay(50).duration(200).attr("r", function(d) {
              if (d.group === 2) {
                return Math.sqrt(d.value) * 20;
              }
            }).style("stroke", function(d) {
              return _this.color(d.group);
            }).style("fill", function(d) {
              return _this.color(d.group);
            }).style("stroke-width", 0);
            _this.vis.selectAll("text.nodetext").filter(function(d, i) {
              return d.name === link.target.name;
            }).transition().duration(600).style("opacity", 1);
            return;
          }
        });
      };
    })(this),
    resetHighlightNodesBy: (function(_this) {
      return function() {
        _this.vis.selectAll("circle").transition().duration(500).style("opacity", 0.6).attr("r", function(d) {
          if (d.group === 2) {
            return Math.sqrt(d.value) * 2;
          } else {
            return 2;
          }
        }).style("stroke-width", 1);
        return _this.vis.selectAll("text.nodetext").transition().duration(500).style("opacity", 0);
      };
    })(this)
  };
  OrgGraph.Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.appRoutes = {
      "OrgGraph": "OrgGraph",
      "highlightNodesBy": "highlightNodesBy",
      "resetHighlightNodesBy": "resetHighlightNodesBy"
    };

    return Router;

  })(Marionette.AppRouter);
  API = {
    OrgGraph: function() {
      return OrgGraph.Controller.OrgGraph();
    },
    highlightNodesBy: function(d) {
      return OrgGraph.Controller.highlightNodesBy(d);
    },
    resetHighlightNodesBy: function() {
      return OrgGraph.Controller.resetHighlightNodesBy();
    }
  };
  App.addInitializer(function() {
    var textResponse;
    return textResponse = $.ajax({
      url: "http://localhost:3001/artistsbygroup/2",
      success: function(nodes) {
        var artist, eachcnt, i, id, _i, _len, _links, _nodes;
        id = 0;
        this.artistNodes = [];
        for (_i = 0, _len = nodes.length; _i < _len; _i++) {
          artist = nodes[_i];
          this.artistNodes.push({
            'name': artist.source,
            'id': id,
            'group': artist.group
          });
          id = id + 1;
        }
        _links = nodes;
        _links.sort(function(a, b) {
          if (a.source > b.source) {
            return 1;
          } else if (a.source < b.source) {
            return -1;
          } else {
            if (a.target > b.target) {
              return 1;
            }
            if (a.target < b.target) {
              return -1;
            } else {
              return 0;
            }
          }
        });
        i = 0;
        console.log("sorted?", _links);
        while (i < _links.length) {
          if (i !== 0 && _links[i].source === _links[i - 1].source && _links[i].target === _links[i - 1].target) {
            _links[i].linknum = _links[i - 1].linknum + 1;
          } else {
            _links[i].linknum = 1;
          }
          i++;
        }
        _nodes = {};
        _links.forEach(function(link) {
          var r;
          r = 50;
          link.source = _nodes[link.source] || (_nodes[link.source] = {
            name: link.source,
            group: 1,
            value: 1,
            r: 50
          });
          link.target = _nodes[link.target] || (_nodes[link.target] = {
            name: link.target,
            group: link.group,
            lat: link.lat,
            long: link.long,
            value: 1,
            r: 50
          });
        });
        OrgGraph._nodes = _nodes;
        OrgGraph._links = _links;
        eachcnt = 0;
        d3.values(_nodes).forEach((function(_this) {
          return function(sourceNode) {
            _links.forEach(function(link) {
              if (link.source.name === sourceNode.name && link.target.name !== sourceNode.name) {
                link.target.value += 1;
              }
            });
          };
        })(this));
        console.log("_links", _links);
        return console.log("_nodes", _nodes);
      }
    });
  });
  App.addInitializer(function() {
    return new OrgGraph.Router({
      controller: API
    });
  });
  this === OrgGraph;
  myData = 'this is private data';
  toggle = 0;
  OrgGraph.someData = 'public data';
  return OrgGraph.makeOrgGraph = function() {
    var clusters, color, force, height, j, link, linkedByIndex, links, m, n, node, nodeEnter, nodes, optArray, padding, searchNode, svg, tick, viewCenter, vis, width, zoom, _artistNodes, _links, _nodes;
    $("svg").html("");
    $("svg").css("height", "0px");
    $("#biotraj-graph").remove();
    width = $("#content")[0].clientWidth;
    height = 1100;
    padding = 1.5;
    color = d3.scale.category20();
    _nodes = nodes = this._nodes;
    _links = links = this._links;
    n = d3.values(_nodes).length;
    console.log("number of nodes:", n);
    m = 3;
    svg = vis = this.vis = d3.select('#content  ').append('svg:svg').attr('width', width).attr('height', width);
    force = this.force = d3.layout.force().gravity(.6).linkDistance(50).charge(-150).linkStrength(1).friction(0.9).size([width, height]).on("tick", tick);
    this.nodes = this.force.nodes(d3.values(_nodes));
    this.links = this.force.links();
    link = svg.selectAll('.link').data(_links);
    link.enter().insert("line", ".node").attr("class", "link").style("stroke", "lightgray").style("stroke-width", function(d, i) {
      return Math.sqrt(d.target.value);
    }).style("opacity", 0.3);
    link.exit().remove();
    node = this.vis.selectAll('g.node').data(d3.values(_nodes), function(d) {
      return d.name;
    });
    this.color = d3.scale.category10();
    color = this.color;
    _artistNodes = this._nodes;
    nodes = _nodes;
    nodeEnter = node.enter().append('g').attr('class', 'node').attr("x", 14).attr("dy", "5.35em").call(this.force.drag);
    nodeEnter.append('circle').property("id", (function(_this) {
      return function(d, i) {
        return "node-" + i;
      };
    })(this)).attr('r', function(d) {
      if (d.group === 2) {
        return Math.sqrt(d.value) * 2;
      } else {
        return 2;
      }
    }).attr('x', '-1px').attr('y', '10px').attr('width', '4px').attr('height', '4px').style("stroke", "none").style("opacity", 0.6).style('fill', (function(_this) {
      return function(d) {
        return _this.color(d.group);
      };
    })(this)).on('mouseover', function(d, i) {}).on('mouseout', function(d, i) {}).on('touchstart', function(d, i) {}).on('touchend', function(d, i) {}).call(force.drag);
    node.exit().remove();
    clusters = OrgGraph.clusters;
    zoom = d3.behavior.zoom();
    viewCenter = [];
    viewCenter[0] = -1 * zoom.translate()[0] + 0.5 * width / zoom.scale();
    viewCenter[1] = -1 * zoom.translate()[1] + 0.5 * height / zoom.scale();
    node.transition().duration(750).delay(function(d, i) {
      return i * 5;
    }).attrTween('r', function(d) {
      var i;
      i = d3.interpolate(0, d.radius);
      return function(t) {
        return d.radius = i(t);
      };
    });
    tick = function(e) {
      link.attr('x1', function(d) {
        if (d.source.value) {
          return e.alpha * 100 / d.source.value + d.source.x + 100;
        } else {
          return d.source.x + 400;
        }
      }).attr('y1', function(d) {
        if (d.source.value) {
          return e.alpha * 100 / d.source.value + d.source.y;
        } else {
          return d.source.y;
        }
      }).attr('x2', function(d) {
        if (d.target.value) {
          return d.target.x - 100 - (e.alpha * Math.sqrt(d.target.value));
        } else {
          return d.target.x - 100;
        }
      }).attr('y2', function(d) {
        if (d.value) {
          return d.target.y - 100 - (e.alpha * Math.sqrt(d.target.value));
        } else {
          return d.target.y;
        }
      });
      node.attr('transform', function(d) {
        var x, y;
        if (d.group === 1) {
          if (d.value) {
            x = e.alpha * 100 / d.value + d.x + 100;
            y = e.alpha * 100 / d.value + d.y;
          } else {
            x = d.x + 400;
            y = d.y;
          }
          return 'translate(' + x + ',' + y + ')';
        } else {
          if (d.value) {
            x = d.x - e.alpha * 100 / d.value - 100;
            y = d.y - e.alpha * 100 / d.value;
          } else {
            x = d.x - 100;
            y = d.y;
          }
          return 'translate(' + x + ',' + y + ')';
        }
      });
    };
    this.force.on('tick', tick).start();
    optArray = [];
    j = 0;
    nodes = d3.values(_nodes);
    while (j < nodes.length - 1) {
      optArray.push(nodes[j].name);
      j++;
    }
    optArray = optArray.sort();
    toggle = 0;
    linkedByIndex = {};
    j = 0;
    while (j < nodes.length) {
      linkedByIndex[j + ',' + j] = 1;
      j++;
    }
    links.forEach(function(d) {
      linkedByIndex[d.source.index + ',' + d.target.index] = 1;
    });
    node.append('text').style("font-family", "Gill Sans").attr('fill', function(d) {
      return d3.lab(color(d.group)).darker(2);
    }).attr("opacity", 0.3).attr('x', 14).attr('dy', '.35em').text(function(d) {
      return d.name;
    });
    node.on('click', function(d, i) {
      var neighboring;
      neighboring = function(a, b) {
        return linkedByIndex[a.index + ',' + b.index];
      };
      if (toggle === 0) {
        OrgGraph.Controller.highlightNodesBy(d);
        d = d3.select(this).node().__data__;
        node.selectAll("circle").transition(100).style('opacity', function(o) {
          if (neighboring(d, o) | neighboring(o, d)) {
            return 1;
          } else {
            return 0.1;
          }
        });
        node.selectAll("text").transition(100).style('opacity', function(o) {
          if (neighboring(d, o) | neighboring(o, d)) {
            return 1;
          } else {
            return 0.2;
          }
        }).style('font-size', function(o) {
          if (neighboring(d, o) | neighboring(o, d)) {
            return 20;
          } else {
            return 12;
          }
        });
        link.transition(100).style('opacity', function(o) {
          if (d.index === o.source.index | d.index === o.target.index) {
            return 1;
          } else {
            return 0.1;
          }
        });
        toggle = 1;
      } else {
        node.selectAll("circle").transition(100).style('opacity', 0.6);
        link.transition(100).style('opacity', 1);
        node.selectAll("text").transition(100).style('opacity', 0.3).style('font-size', 14);
        OrgGraph.Controller.resetHighlightNodesBy(d);
        toggle = 0;
      }
    });
    return searchNode = function() {
      var selected;
      node = this.vis.selectAll('g.node');
      if (selectedVal === 'none') {
        node.style('stroke', 'white').style('stroke-width', '1');
      } else {
        selected = node.filter(function(d, i) {
          return d.name !== selectedVal;
        });
        selected.style('opacity', '0');
        link = svg.selectAll('.link');
        link.style('opacity', '0');
        d3.selectAll('.node, .link').transition().duration(3000).style('opacity', 1);
      }
    };
  };
});
});

;require.register("lib/PersonModule", function(exports, require, module) {
var application,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

application = require('application');

application.module('PersonModule', function(PersonModule, App, Backbone, Marionette, $, _) {
  var API, myData;
  this.startWithParent = false;
  PersonModule.Controller = {
    PersonModule: (function(_this) {
      return function() {
        console.log("makePersonModule");
        PersonModule.putPersonGraph();
      };
    })(this),
    Location: (function(_this) {
      return function() {
        return application.ViewController.network();
      };
    })(this)
  };
  PersonModule.Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.appRoutes = {
      "PersonModule": "PersonModule",
      'location': 'Location'
    };

    return Router;

  })(Marionette.AppRouter);
  API = {
    PersonModule: function() {
      return PersonModule.Controller.PersonModule();
    },
    Location: function() {
      return application.vent.trigger("network");
    }
  };
  PersonModule.addInitializer(function() {
    return new PersonModule.Router({
      controller: API
    });
  });
  PersonModule.addInitializer(function() {});
  this === PersonModule;
  myData = 'this is private data';
  PersonModule.someData = 'public data';
  PersonModule.makePersonModule = function() {
    return console.log("makePersonModule");
  };
  return PersonModule.putPersonGraph = function() {
    var PersonView;
    module.exports = PersonView = (function(_super) {
      __extends(PersonView, _super);

      function PersonView() {
        return PersonView.__super__.constructor.apply(this, arguments);
      }

      PersonView.prototype.template = 'views/templates/person';

      PersonView.prototype.id = 'person-graph';

      PersonView.prototype.el = '#person-graph';

      return PersonView;

    })(Backbone.Marionette.LayoutView);
    ({
      initialize: function() {},
      onShow: function() {
        this.on("switch-person:do:view", (function(_this) {
          return function() {};
        })(this));
        return console.log("switch-person trigger");
      }
    });
    console.log(this);
    console.log(PersonModule);
    application.module("GraphModule").stop();
    application.layout.content.empty();
    $("#biotraj-graph").remove();
    $("#content").html("");
    $("#content").append("<div id='person-graph'></div>");
    this.layout = new PersonView();
    console.log(application);
    return PersonModule.layout.render();
  };
});
});

;require.register("lib/graphModule", function(exports, require, module) {
var application,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

application = require('application');

application.module('GraphModule', function(GraphModule, App, Backbone, Marionette, $, _) {
  var API, ifControl, inWidth, myData, stopForce;
  this.startWithParent = false;
  GraphModule.Controller = {
    highlightLinksBy: (function(_this) {
      return function(sourceNode) {
        _this._m.closePopup();
        _this.popupGroup.clearLayers();
        _this.vis.selectAll("line").filter(function(d, i) {
          return d.source.name === sourceNode.name;
        }).transition().duration(200).style("opacity", 0.9);
      };
    })(this),
    resetHighlightLinksBy: (function(_this) {
      return function() {
        return _this.vis.selectAll("line").style("opacity", 0.0);
      };
    })(this),
    highlightNodesBy: (function(_this) {
      return function(sourceNode) {
        var color;
        _this.nodeGroup.eachLayer(function(layer) {
          var timeout;
          _this.popupGroup.clearLayers();
          layer.setStyle({
            opacity: 0.4,
            fillOpacity: 0.4,
            weight: 2,
            clickable: false
          });
          timeout = 0;
          _this.markers.eachLayer(function(layer) {
            return layer.setStyle({
              opacity: 0.1,
              clickable: false
            });
          });
          return setTimeout((function() {
            $(L.DomUtil.get(layer._container)).animate({
              fillOpacity: 0.3,
              opacity: 0.3
            }, 10, function() {});
          }));
        });
        color = _this.color;
        _this._links.forEach(function(link) {
          if (link.source.name === sourceNode.name) {
            _this.markers.eachLayer(function(layer) {
              return layer.setStyle({
                opacity: 0.6,
                clickable: true
              });
            });
            _this.nodeGroup.eachLayer(function(layer) {
              var ltlng, popup, timeout;
              if (layer.options.className === ("" + link.target.index)) {
                popup = new L.Popup();
                ltlng = new L.LatLng(layer._latlng.lat, layer._latlng.lng);
                popup.setLatLng(ltlng);
                popup.setContent("");
                popup.setContent(layer.options.id);
                _this.popupGroup.addLayer(popup);
                layer.bringToFront();
                timeout = 0;
                return setTimeout((function() {
                  $(L.DomUtil.get(layer._container)).animate({
                    fillOpacity: 0.8,
                    opacity: 0.9
                  }, 1, function() {
                    return layer.setStyle({
                      fillOpacity: 0.8,
                      weight: 2,
                      clickable: true
                    });
                  });
                }));
              }
            });
          }
        });
      };
    })(this),
    resetHighlightNodesBy: (function(_this) {
      return function() {
        _this.vis.selectAll("circle").transition().duration(500).style("opacity", 0.6).attr("r", function(d) {
          if (d.group) {
            return 0;
          } else {
            return 0;
          }
        }).style("stroke-width", 1);
        return _this.vis.selectAll("text.nodetext").transition().duration(500).style("opacity", 0);
      };
    })(this),
    showBio: (function(_this) {
      return function(d) {
        var textResponse;
        L.DomUtil.setOpacity(L.DomUtil.get(_this._bios_domEl), 0.75);
        _this.fx.run(L.DomUtil.get(_this._bios_domEl), L.point(-$(_this._m.getContainer())[0].clientWidth / 3, 40), 0.5);
        L.DomUtil.get(_this._bios_domEl).innerHTML = "";
        if (_this.biosFetched === void 0) {
          return textResponse = $.ajax({
            url: "http://localhost:3001/biosby/" + d.name,
            success: function(result) {
              var $el;
              $el = $('#bios');
              _this.biosTextResults = result;
              L.DomUtil.get(_this._bios_domEl).innerHTML = "";
              return L.DomUtil.get(_this._bios_domEl).innerHTML += "" + _this.biosTextResults[0].__text;
            }
          });
        } else {

        }
      };
    })(this),
    makeOrgGraph: (function(_this) {
      return function() {};
    })(this),
    allNodes: (function(_this) {
      return function() {
        return _this._nodes;
      };
    })(this),
    allLinks: (function(_this) {
      return function() {
        return _this._links;
      };
    })(this)
  };
  GraphModule.Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.appRoutes = {
      "highlightLinksBy": "highlightLinksBy",
      "resetHighlightLinksBy": "resetHighlightLinksBy",
      "highlightNodesBy": "highlightNodesBy",
      "resetHighlightNodesBy": "resetHighlightNodesBy",
      "showBio": "showBio"
    };

    return Router;

  })(Marionette.AppRouter);
  API = {
    map: function() {
      return GraphModule.Controller.makeMap();
    },
    highlightLinksBy: function(d) {
      return GraphModule.Controller.highlightLinksBy(d);
    },
    resetHighlightLinksBy: function() {
      return GraphModule.Controller.resetHighlightLinksBy(d);
    },
    highlightNodesBy: function(d) {
      return GraphModule.Controller.highlightNodesBy(d);
    },
    resetHighlightNodesBy: function() {
      return GraphModule.Controller.resetHighlightNodesBy();
    },
    startForce: function() {
      return GraphModule.Controller.startForce();
    },
    stopForce: function() {
      return GraphModule.Controller.stopForce();
    },
    showBio: function(d) {
      return GraphModule.Controller.showBio(d);
    }
  };
  App.addInitializer(function() {
    return new GraphModule.Router({
      controller: API
    });
  });
  this === GraphModule;
  myData = 'this is private data';
  ifControl = false;
  inWidth = 60;
  stopForce = (function(_this) {
    return function() {
      _this.force.stop();
    };
  })(this);
  GraphModule.someData = 'public data';
  GraphModule.connectBios = function(_m, d, i) {
    var points;
    return points = [];
  };
  GraphModule.getAllNodes = function() {
    var artistNodes;
    artistNodes = [];
    d3.json('http://localhost:3001/artists', (function(_this) {
      return function(error, nodes) {
        var artist, id, _i, _len;
        id = 0;
        for (_i = 0, _len = nodes.length; _i < _len; _i++) {
          artist = nodes[_i];
          artistNodes.push({
            'name': artist.source,
            'id': id,
            'group': artist.group
          });
          id = id + 1;
        }
        return _this.artistNodes = artistNodes;
      };
    })(this));
    return this.artistNodes;
  };
  GraphModule.makeBioController = function() {
    var divControl;
    divControl = L.Control.extend({
      initialize: (function(_this) {
        return function() {
          var disable3D, position, _domEl, _domObj;
          position = "left";
          _domEl = L.DomUtil.create('div', "container " + "bioController" + "-info");
          L.DomUtil.enableTextSelection(_domEl);
          _this._m.getContainer().getElementsByClassName("leaflet-control-container")[0].appendChild(_domEl);
          _domObj = $(L.DomUtil.get(_domEl));
          _domObj.css('width', $(_this._m.getContainer())[0].clientWidth / 4);
          _domObj.css('height', $(_this._m.getContainer())[0].clientHeight / 1.3);
          _domObj.css('background-color', 'white');
          _domObj.css("font-family", "Gill Sans");
          _domObj.css("font-size", "24");
          _domObj.css('overflow', 'auto');
          _domObj.css('line-height', '28px');
          L.DomUtil.setOpacity(L.DomUtil.get(_domEl), 0.0);
          L.DomUtil.setPosition(L.DomUtil.get(_domEl), L.point(-$(_this._m.getContainer())[0].clientWidth / 1.2, 0), disable3D = 0);
          _this.position = L.point(-$(_this._m.getContainer())[0].clientWidth / 1.05, 0);
          _this.fx = new L.PosAnimation();
          _this.fx.run(L.DomUtil.get(_domEl), position, 0.9);
          _this._bios_domEl = _domEl;
          _this._m.on("click", function() {
            _this.fx.run(L.DomUtil.get(_domEl), _this.position, 0.9);
            return console.log("click on map");
          });
          return _this._d3BiosEl = d3.select(_domEl);
        };
      })(this)
    });
    new divControl();
  };
  GraphModule.makeGraph = function() {
    this.$el = $('graph-map');
    d3.json('http://localhost:3001/artists', (function(_this) {
      return function(error, nodes) {
        var artist, circle, color, each, eachcnt, force, fx, h, i, id, link, links, ltlong, node, nodeEnter, nodeGroup, offset, vis, w, _artistNodes, _i, _j, _len, _len1, _links, _m, _nodes, _ref, _textDomEl, _textDomObj;
        id = 0;
        _this.artistNodes = [];
        for (_i = 0, _len = nodes.length; _i < _len; _i++) {
          artist = nodes[_i];
          _this.artistNodes.push({
            'name': artist.source,
            'id': id,
            'group': artist.group
          });
          id = id + 1;
        }
        _links = nodes;
        _links.sort(function(a, b) {
          if (a.source > b.source) {
            return 1;
          } else if (a.source < b.source) {
            return -1;
          } else {
            if (a.target > b.target) {
              return 1;
            }
            if (a.target < b.target) {
              return -1;
            } else {
              return 0;
            }
          }
        });
        i = 0;
        while (i < _links.length) {
          if (i !== 0 && _links[i].source === _links[i - 1].source && _links[i].target === _links[i - 1].target) {
            _links[i].linknum = _links[i - 1].linknum + 1;
          } else {
            _links[i].linknum = 1;
          }
          i++;
        }
        _nodes = {};
        _links.forEach(function(link) {
          link.source = _nodes[link.source] || (_nodes[link.source] = {
            name: link.source,
            value: 1
          });
          link.target = _nodes[link.target] || (_nodes[link.target] = {
            name: link.target,
            group: link.group,
            lat: link.lat,
            long: link.long,
            value: 1
          });
        });
        d3.values(_nodes).forEach(function(sourceNode) {
          _links.forEach(function(link) {
            if (link.source.name === sourceNode.name && link.target.name !== sourceNode.name) {
              link.target.value += 1;
            }
          });
        });
        _m = _this.getMap();
        _this._nodes = _nodes;
        _this._links = _links;
        eachcnt = 0;
        nodeGroup = L.layerGroup([]);
        _this.color = d3.scale.category10();
        color = _this.color;
        _ref = d3.values(_nodes);
        for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
          each = _ref[_j];
          eachcnt = 1 + eachcnt;
          try {
            if (each.group === 1 && each.lat) {
              ltlong = new L.LatLng(+each.lat, +each.long);
              circle = new L.CircleMarker(ltlong, {
                color: color(each.group),
                opacity: 0.5,
                fillOpacity: 0.5,
                weight: 1,
                className: "" + (eachcnt - 1),
                id: "" + each.name,
                clickable: true
              }).setRadius(Math.sqrt(each.value) * 5).bindPopup("<p style='font-size:12px; line-height:10px; font-style:bold;'><a>" + each.name + "</p><p style='font-size:12px; font-style:italic; line-height:10px;'>" + (each.value - 1) + " artists connected to this location</p>");
              nodeGroup.addLayer(circle);
            }
          } catch (_error) {}
        }
        nodeGroup.eachLayer(function(layer) {
          _this.markers = new L.MarkerClusterGroup([], {
            maxZoom: 8,
            spiderfyOnMaxZoom: true,
            zoomToBoundsOnClick: true,
            spiderfyDistanceMultiplier: 2
          });
          _this.markers.addTo(_this._m);
          layer.on("click", function(e) {
            var textResponse;
            _this.markers.clearLayers();
            return textResponse = $.ajax({
              url: "http://localhost:3001/artstsby/" + layer.options.id,
              success: function(nodes) {
                var currentzoom, marker;
                currentzoom = _this._m.getZoom();
                marker = new L.CircleMarker([]);
                return nodes.forEach(function(artist) {
                  var artistNode;
                  artistNode = new L.LatLng(+artist.lat, +artist.long);
                  marker = new L.CircleMarker(artistNode, {
                    color: d3.lab("blue").darker(-2),
                    opacity: 0.5,
                    fillOpacity: 0.5,
                    weight: 1,
                    clickable: true
                  }).setRadius(7).bindPopup("<p>" + artist.source + "</p>");
                  return _this.markers.addLayer(marker);
                });
              }
            });
          });
          return;
          if (each.group === 1 && each.lat) {
            if (each.lat !== "0") {
              _this._nodesGeojsjon.features.push({
                "type": "Feature",
                "id": "" + eachcnt,
                "geometry": {
                  "type": "point",
                  "coordinates": [+each.lat, +each.long]
                },
                "properties": each.name
              });
            }
            return eachcnt = 1 + eachcnt;
          }
        });
        _this.nodeGroup = nodeGroup;
        _textDomEl = L.DomUtil.create('svg', 'graph_upleaflet-zoom-hide', _this.$el[0]);
        _m.getPanes().overlayPane.appendChild(_textDomEl);
        nodeGroup.addTo(_this._m);
        _textDomEl.innerHTML += "<svg class='graph  '></svg>";
        L.DomUtil.enableTextSelection(_textDomEl);
        offset = L.DomUtil.getViewportOffset(_textDomEl);
        _textDomObj = $(L.DomUtil.get(_textDomEl));
        w = $(_m.getContainer())[0].clientWidth;
        h = $(_m.getContainer())[0].clientHeight;
        fx = new L.PosAnimation();
        vis = _this.vis = d3.select('.graph').append('svg:svg').attr('width', w).attr('height', h);
        force = _this.force = d3.layout.force().gravity(.25).linkDistance(40).size([w, h]);
        _this.nodes = _this.force.nodes(d3.values(_nodes));
        links = _this.force.links();
        link = _this.vis.selectAll('.link').data(_links);
        node = _this.vis.selectAll('g.node').data(d3.values(_nodes), function(d) {
          return d.name;
        });
        color = _this.color;
        _artistNodes = _this._nodes;
        nodeEnter = node.enter().append('g').attr('class', 'node').call(_this.force.drag);
        nodeEnter.append('circle').property("id", function(d, i) {
          return "node-" + i;
        }).attr('r', function(d) {
          var _ref1;
          if (_ref1 = d.group, __indexOf.call([0, 1, 2, 3], _ref1) >= 0) {
            return 10;
          } else {
            return 0;
          }
        }).attr('x', '-1px').attr('y', '-1px').attr('width', '4px').attr('height', '4px').style("stroke", "none").style("opacity", 0.6).style('fill', function(d) {
          if (d.group) {
            return _this.color(1);
          } else {
            return "node";
          }
        });
        nodeEnter.append('text').attr('class', 'nodetext').attr('dx', 12).attr('dy', '.35em').style("opacity", 0.9).attr("fill", function(d, i) {
          return "gray";
        }).attr('id', function(d, i) {
          return i;
        }).text(function(d, i) {
          return d.name;
        });
        node.exit().remove();
        _this.noFollowLinks = true;
        _this.force.on('tick', function() {
          var e;
          try {
            node.attr('transform', function(d) {
              if (d.group === 1 && d.lat) {
                return 'translate(' + _m.latLngToLayerPoint(L.latLng(d.lat, d.long)).x + ',' + _m.latLngToLayerPoint(L.latLng(d.lat, d.long)).y + ')';
              } else {
                return 'translate(' + d.x + ',' + d.y + ')';
              }
            });
            link.attr('x1', function(d) {
              return d.source.x;
            }).attr('y1', function(d) {
              return d.source.y;
            }).attr('x2', function(d) {
              if (d.target.lat) {
                return _m.latLngToLayerPoint(L.latLng(d.target.lat, d.target.long)).x;
              } else {
                return d.target.x;
              }
            }).attr('y2', function(d) {
              if (d.target.long && (document.getElementById("line-" + d.source.index))) {
                return _m.latLngToLayerPoint(L.latLng(d.target.lat, d.target.long)).y;
              } else {
                return d.target.y;
              }
            });
          } catch (_error) {
            e = _error;
          }
        });
        _this.force.on('start', function() {
          return link.property("id", function(d, i) {
            return "linksource-" + d.source.index;
          });
        });
        return _this.force.start();
      };
    })(this));
  };
  GraphModule.makeMap = function() {
    L.mapbox.accessToken = "pk.eyJ1IjoiYXJtaW5hdm4iLCJhIjoiSTFteE9EOCJ9.iDzgmNaITa0-q-H_jw1lJw";
    try {
      this._m = L.mapbox.map("map", "arminavn.jhehgjan", {
        zoomAnimation: true,
        dragAnimation: true,
        attributionControl: false,
        zoomAnimationThreshold: 10,
        inertiaDeceleration: 4000,
        animate: true,
        duration: 1.75,
        zoomControl: false,
        doubleClickZoom: false,
        infoControl: false,
        easeLinearity: 0.1,
        maxZoom: 5
      });
    } catch (_error) {
      $("#map-region").append("<div id='map'></div>");
    }
    this._m.setView([42.34, 0.12], 3);
    this._m.boxZoom.enable();
    this._m.scrollWheelZoom.disable();
    this._m.on('zoomstart', (function(_this) {
      return function() {
        return _this.force.stop();
      };
    })(this));
    this._m.on('zoomend dragend', (function(_this) {
      return function() {
        return _this.force.start();
      };
    })(this));
    this._m.on("click", (function(_this) {
      return function() {
        return _this._m.setView([42.34, 0.12], 3);
      };
    })(this));
  };
  GraphModule.getGraph = function() {
    var graph;
    graph = this.vis;
    return graph;
  };
  GraphModule.getForce = function() {
    var force;
    force = this.force;
    return force;
  };
  GraphModule.getMap = function() {
    var map;
    map = this._m;
    return map;
  };
  GraphModule.getAllArtists = function() {
    return this._text;
  };
  GraphModule.makeDivList = function($el, Width, Height, _margin, text) {
    var biosRegion, color, e, id, key, value, _ref, _ref1;
    try {
      L.DomUtil.addClass(L.DomUtil.get("map-region"), "col-md-10");
    } catch (_error) {
      e = _error;
      $("#content").html('<div class="row" id="main-content"> <div class="row" > <div id="switch" class="col-md-2 col-md-offset-2"> <span class="glyphicon-class"></span><a><span id="switch-icon" class="glyphicon glyphicon-cog">  </span></a> </div> </div> <div class="row" > <div class="col-md-2" id="region-bios"> </div> <div class="col-md-12" id="map-region"> <div class="col-md-6" id="region-graph"> </div> </div> </div>');
      $el = $('#main-content');
    }
    id = 0;
    this.artistBios = [];
    console.log("@_nodes before parsing out the names", this._nodes);
    if (this._nodes) {
      text = [];
      _ref = this._nodes;
      for (key in _ref) {
        value = _ref[key];
        if (_ref1 = value.group, __indexOf.call([1, 2, 3, 4], _ref1) >= 0) {

        } else {
          text.push({
            name: value.name,
            id: value.index,
            group: value.group
          });
        }
      }
    } else {
      this._text = text;
    }
    this._m = GraphModule.getMap();
    this.popupGroup = L.layerGroup([]);
    this.popupGroup.addTo(this._m);
    biosRegion = $("#region-bios");
    this._textDomEl = L.DomUtil.create('div', 'container paratext-info');
    this._el = L.DomUtil.create('svg', 'svg');
    biosRegion.append(this._textDomEl);
    L.DomUtil.enableTextSelection(this._textDomEl);
    this._textDomObj = $(L.DomUtil.get(this._textDomEl));
    this.inWidth = $el[0].clientWidth / 5;
    this._textDomObj.css('width', $el[0].clientWidth);
    this._textDomObj.css('height', "970");
    this._textDomObj.css('background-color', 'none');
    this._textDomObj.css('overflow', 'auto');
    L.DomUtil.setOpacity(L.DomUtil.get(this._textDomEl), .8);
    color = this.color;
    this._d3text = d3.select(".paratext-info").append("ul").style("list-style-type", "none").style("padding-left", "0px").style('overflow', 'auto').attr("id", "bios-list").attr("width", $el[0].clientWidth).attr("height", $el[0].clientHeight);
    this._d3li = this._d3text.selectAll("li").data(text).enter().append("li");
    return this._d3li.style("font-family", "Gill Sans").style("font-size", "16px").style("line-height", "1").style("border", "0px solid black").style("margin-top", "20px").style("padding-right", "20px").style("padding-left", "40px").attr("id", (function(_this) {
      return function(d, i) {
        _this.artistBios.push({
          'name': d.name,
          'id': i
        });
        return "line-" + i;
      };
    })(this)).on("mouseover", function(d) {
      return $(this).css('cursor', 'pointer');
    }).on("click", function(d, i) {
      L.DomEvent.disableClickPropagation(this);
      d3.select(this).transition().duration(0).style("color", "black").style("background-color", function(d, i) {
        return "white";
      }).style("opacity", 1);
      d3.select(this).transition().duration(1000).style("color", "rgb(72,72,72)").style("background-color", (function(_this) {
        return function(d, i) {
          id = d3.select(_this).attr("id").replace("line-", "");
          return color(1);
        };
      })(this)).style("opacity", 1);
    }).append("text").text((function(_this) {
      return function(d, i) {
        var timeout, _ref2;
        if (_ref2 = d.group, __indexOf.call([0, 1, 2, 3], _ref2) >= 0) {

        } else {
          _this._leafletli = L.DomUtil.get("line-" + i);
          timeout = void 0;
          L.DomEvent.addListener(_this._leafletli, 'click', function(e) {
            d3.selectAll(_this._d3li[0]).style("color", "black").style("background-color", "white").style("opacity", 1);
            GraphModule.Controller.resetHighlightLinksBy();
            GraphModule.Controller.resetHighlightNodesBy();
            timeout = 0;
            timeout = setTimeout(function() {
              _this._m._initPathRoot();
              if (timeout !== 0) {
                timeout = 0;
                GraphModule.Controller.highlightNodesBy(d);
                return GraphModule.Controller.showBio(d);
              }
            }, 600);
          }, function() {
            return;
            return e.stopPropagation();
          });
          return d.name;
        }
      };
    })(this)).style("font-family", "Gill Sans").style("font-size", "14px").style("color", "black").transition().duration(1).delay(1).style("opacity", 1);
  };
  return this._textDomEl;
});
});

;require.register("lib/router", function(exports, require, module) {
var BiosCollection, BiosModel, BiosView, GraphView, NetworkView, OrganizationView, Router, application,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

application = require('application');

NetworkView = require('views/NetworkView');

BiosView = require('views/BiosView');

GraphView = require('views/GraphView');

BiosModel = require('models/biosModel');

BiosCollection = require('models/biosCollection');

OrganizationView = require('views/OrgGraphView');

module.exports = Router = (function(_super) {
  var ViewController;

  __extends(Router, _super);

  function Router() {
    return Router.__super__.constructor.apply(this, arguments);
  }

  ViewController = Marionette.Controller.extend({
    network: function() {
      $("svg").html("");
      $("svg").css("height", "0px");
      this.nv = new NetworkView();
      return application.layout.content.show(this.nv);
    },
    bios: function() {
      var bv;
      bv = new BiosView;
      return application.layout.content.show(bv);
    },
    addNodes: function(node) {
      if (this.nv === void 0) {
        this.nv = new NetworkView();
        application.layout.content.show(this.nv);
        this.gv = new GraphView();
        this.nv.regionGraph.show(this.gv);
      } else if (this.gv === void 0) {
        this.gv = new GraphView();
        this.nv.regionGraph.show(this.gv);
        if (application.GraphModule.getGraph() === void 0) {
          application.GraphModule.makeGraph();
        }
      }
      return this.gv.onThisArtist(node);
    },
    offArtist: function() {
      return this.gv.offThisArtist();
    },
    organization: function() {
      this.nv.remove(this.graphView);
      return application.vent.trigger("organization");
    },
    location: function() {
      console.log("application in ;ocation call");
      if (this.nv === void 0) {
        this.nv = new NetworkView();
        application.layout.content.show(this.nv);
        this.gv = new GraphView();
        this.nv.regionGraph.show(this.gv);
      } else if (this.gv === void 0) {
        this.gv = new GraphView();
        this.nv.regionGraph.show(this.gv);
        if (application.GraphModule.getGraph() === void 0) {
          application.GraphModule.makeGraph();
        }
      }
      return application.vent.trigger("location");
    },
    personView: function() {
      console.log("personview in ViewController");
      this.nv.remove(this.gv);
      return application.PersonModule.putPersonGraph();
    },
    biotrajView: function() {
      console.log("biotraj in ViewController");
      this.nv.remove(this.gv);
      return application.BiotrajModule.putBiotrajGraph();
    }
  });

  ViewController = new ViewController;

  Router.prototype.controller = ViewController;

  Router.prototype.appRoutes = {
    '': 'network',
    'bios': 'bios',
    'graph/:node': 'addNodes',
    'offArtist': 'offArtist',
    'organization': 'organization',
    'location': 'location',
    'person': 'personView',
    'biotraj': 'biotrajView'
  };

  return Router;

})(Backbone.Marionette.AppRouter);
});

;require.register("lib/view_helper", function(exports, require, module) {
Handlebars.registerHelper('pick', function(val, options) {
  return options.hash[val];
});
});

;require.register("models/artistCollection", function(exports, require, module) {
var ArtistCollection, ArtistModel,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ArtistModel = require('models/artistModel');

module.exports = ArtistCollection = (function(_super) {
  __extends(ArtistCollection, _super);

  function ArtistCollection() {
    return ArtistCollection.__super__.constructor.apply(this, arguments);
  }

  ArtistCollection.prototype.url = 'http://localhost:3001/artists/';

  ArtistCollection.prototype.model = ArtistModel;

  return ArtistCollection;

})(Backbone.Collection);
});

;require.register("models/artistModel", function(exports, require, module) {
var ArtistModel,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = ArtistModel = (function(_super) {
  __extends(ArtistModel, _super);

  function ArtistModel() {
    return ArtistModel.__super__.constructor.apply(this, arguments);
  }

  ArtistModel.prototype.urlRoot = 'http://localhost:3001/artists/';

  ArtistModel.prototype.idAttribute = '_id';

  ArtistModel.prototype.defaults = {};

  return ArtistModel;

})(Backbone.Model);
});

;require.register("models/biosCollection", function(exports, require, module) {
var BiosCollection, BiosModel,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BiosModel = require('models/biosModel');

module.exports = BiosCollection = (function(_super) {
  __extends(BiosCollection, _super);

  function BiosCollection() {
    return BiosCollection.__super__.constructor.apply(this, arguments);
  }

  BiosCollection.prototype.url = 'http://localhost:3001/bios/';

  BiosCollection.prototype.model = BiosModel;

  return BiosCollection;

})(Backbone.Collection);
});

;require.register("models/biosModel", function(exports, require, module) {
var BiosModel,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = BiosModel = (function(_super) {
  __extends(BiosModel, _super);

  function BiosModel() {
    return BiosModel.__super__.constructor.apply(this, arguments);
  }

  BiosModel.prototype.urlRoot = 'http://localhost:3001/bios/';

  BiosModel.prototype.idAttribute = '_id';

  BiosModel.prototype.defaults = {};

  return BiosModel;

})(Backbone.Model);
});

;require.register("models/collection", function(exports, require, module) {
var Collection,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = Collection = (function(_super) {
  __extends(Collection, _super);

  function Collection() {
    return Collection.__super__.constructor.apply(this, arguments);
  }

  return Collection;

})(Backbone.Collection);
});

;require.register("models/model", function(exports, require, module) {
var Model,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = Model = (function(_super) {
  __extends(Model, _super);

  function Model() {
    return Model.__super__.constructor.apply(this, arguments);
  }

  return Model;

})(Backbone.Model);
});

;require.register("views/AppLayout", function(exports, require, module) {
var AppLayout, application,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

application = require('application');

module.exports = AppLayout = (function(_super) {
  __extends(AppLayout, _super);

  function AppLayout() {
    return AppLayout.__super__.constructor.apply(this, arguments);
  }

  AppLayout.prototype.template = 'views/templates/appLayout';

  AppLayout.prototype.el = "body";

  AppLayout.prototype.regions = {
    content: "#content",
    header: "#header"
  };

  return AppLayout;

})(Backbone.Marionette.LayoutView);
});

;require.register("views/BioView", function(exports, require, module) {
var BioView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = BioView = (function(_super) {
  __extends(BioView, _super);

  function BioView() {
    return BioView.__super__.constructor.apply(this, arguments);
  }

  BioView.prototype.template = 'views/templates/Bio';

  BioView.prototype.onShow = function() {
    return console.log("inside Bio item view");
  };

  return BioView;

})(Backbone.Marionette.ItemView);
});

;require.register("views/BiosView", function(exports, require, module) {
var BioView, BiosCollection, BiosModel, BiosView, application,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

application = require('application');

BiosModel = require('models/biosModel');

BiosCollection = require('models/biosCollection');

BioView = require('views/BioView');

module.exports = BiosView = (function(_super) {
  __extends(BiosView, _super);

  function BiosView() {
    return BiosView.__super__.constructor.apply(this, arguments);
  }

  BiosView.prototype.template = 'views/templates/bios';

  BiosView.prototype.id = 'bios';

  BiosView.prototype.$el = $('#bios');

  BiosView.prototype.ui = {
    'name': '#bio-list'
  };

  BiosView.prototype.initialize = function() {};

  BiosView.prototype.onShow = function() {
    var Height, Width, height, textResponse, width, _margin;
    _margin = {
      t: 20,
      l: 30,
      b: 30,
      r: 30
    };
    width = 800;
    height = 800;
    Height = height;
    Width = width;
    textResponse = $.ajax({
      url: "http://localhost:3001/artists",
      success: function(result) {
        var $el;
        $el = $('#bios');
        application.GraphModule.makeDivList($el, Width, Height, _margin, result);
        return application.GraphModule.makeBioController();
      }
    });
  };

  return BiosView;

})(Backbone.Marionette.LayoutView);
});

;require.register("views/GraphView", function(exports, require, module) {
var GraphView, application,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

application = require('application');

module.exports = GraphView = (function(_super) {
  __extends(GraphView, _super);

  function GraphView() {
    this.onThisArtist = __bind(this.onThisArtist, this);
    return GraphView.__super__.constructor.apply(this, arguments);
  }

  GraphView.startWithParent = false;

  GraphView.prototype.template = 'views/templates/graph';

  GraphView.prototype.id = 'graph-map';

  GraphView.prototype.$el = $('graph-map');

  GraphView.prototype.artistNodes = [];

  GraphView.prototype.links = [];

  GraphView.prototype.initialize = function() {};

  GraphView.prototype.onThisArtist = function(node) {};

  GraphView.prototype.onShow = function() {
    var map;
    application.GraphModule.makeGraph();
    this._m = application.GraphModule.getMap();
    map = $("#map-region").append("<div id='map'></div>");
    return $(document).ready((function(_this) {
      return function() {
        return application.GraphModule.makeMap();
      };
    })(this));
  };

  return GraphView;

})(Backbone.Marionette.ItemView);
});

;require.register("views/HomeView", function(exports, require, module) {
var HomeView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = HomeView = (function(_super) {
  __extends(HomeView, _super);

  function HomeView() {
    return HomeView.__super__.constructor.apply(this, arguments);
  }

  HomeView.prototype.id = 'home-view';

  HomeView.prototype.template = 'views/templates/home';

  return HomeView;

})(Backbone.Marionette.ItemView);
});

;require.register("views/NetworkView", function(exports, require, module) {
var BiosView, GraphModule, GraphView, NetworkView, OrgGraphView, application,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

application = require('application');

GraphModule = require('lib/graphModule');

GraphView = require('views/GraphView');

OrgGraphView = require('views/OrgGraphView');

BiosView = require('views/BiosView');

module.exports = NetworkView = (function(_super) {
  __extends(NetworkView, _super);

  function NetworkView() {
    return NetworkView.__super__.constructor.apply(this, arguments);
  }

  NetworkView.prototype.template = 'views/templates/network';

  NetworkView.prototype.id = 'main-content';

  NetworkView.prototype.$el = $('#main-content');

  NetworkView.prototype.ui = {
    'switch-organization': '#organization'
  };

  NetworkView.prototype.triggers = {
    'click @ui.switch-organization': 'switch-organization:do:view'
  };

  NetworkView.prototype.regions = {
    mapGraph: "#map-region",
    regionBios: "#region-bios",
    regionGraph: "#region-graph"
  };

  NetworkView.prototype.initialize = function() {
    return this.regionManager.addRegions(this.regions);
  };

  NetworkView.prototype.onShow = function() {
    $(document).ready((function(_this) {
      return function() {};
    })(this));
    console.log(application);
    this.on("switch-organization:do:view", (function(_this) {
      return function() {
        console.log("switch-organization trigger");
        _this.biosView = new BiosView();
        _this.regionBios.show(_this.biosView);
        _this.orgGraphView = new OrgGraphView();
        _this.regionGraph.show(_this.orgGraphView);
        return application.GraphModule.Controller.makeOrgGraph();
      };
    })(this));
    this.biosView = new BiosView();
    this.graphView = new GraphView();
    this.regionGraph.show(this.graphView);
    return this.regionBios.show(this.biosView);
  };

  return NetworkView;

})(Backbone.Marionette.LayoutView);
});

;require.register("views/OrgGraphView", function(exports, require, module) {
var OrgGraphView, application,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

application = require('application');

module.exports = OrgGraphView = (function(_super) {
  __extends(OrgGraphView, _super);

  function OrgGraphView() {
    this.onThisArtist = __bind(this.onThisArtist, this);
    return OrgGraphView.__super__.constructor.apply(this, arguments);
  }

  OrgGraphView.startWithParent = false;

  OrgGraphView.prototype.template = 'views/templates/orggraph';

  OrgGraphView.prototype.id = 'region-graph';

  OrgGraphView.prototype.$el = $('#region-graph');

  OrgGraphView.prototype.artistNodes = [];

  OrgGraphView.prototype.links = [];

  OrgGraphView.prototype.initialize = function() {
    var force;
    console.log("OrgGraphView initialized");
    force = application.GraphModule.getForce();
    return console.log("graph", force);
  };

  OrgGraphView.prototype.onThisArtist = function(node) {};

  OrgGraphView.prototype.onShow = function() {
    return $(document).ready((function(_this) {
      return function() {
        return application.GraphModule.makeOrgGraph();
      };
    })(this));
  };

  OrgGraphView.prototype.onRender = function() {};

  return OrgGraphView;

})(Backbone.Marionette.ItemView);
});

;require.register("views/templates/appLayout", function(exports, require, module) {
var __templateData = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "<div id=\"header\" class=\"container\"></div>\n<div id=\"content\" class=\"container\"></div>\n";
  },"useData":true});
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("views/templates/bio", function(exports, require, module) {
var __templateData = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "<li></li>";
  },"useData":true});
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("views/templates/bios", function(exports, require, module) {
var __templateData = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "<div></div>";
  },"useData":true});
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("views/templates/biotraj", function(exports, require, module) {
var __templateData = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "<script src=\"jquery.zoomooz.min.js\"></script>\n\n<center><p>Plot maps of selected biographies.</p></center>\n<div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1001.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1002.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1003.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1004.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1005.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1006.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1007.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1008.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1009.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1010.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1011.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1012.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1013.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1014.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1015.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1016.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1017.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1018.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1019.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1020.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1021.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1022.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1023.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1024.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1025.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1026.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1027.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1028.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1029.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1030.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1031.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1032.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1033.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1034.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1035.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1036.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1037.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1038.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1039.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1040.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1041.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1042.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1043.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1044.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1045.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1046.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1047.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1048.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1049.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1050.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1051.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1052.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1053.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1054.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1055.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1056.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1057.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1058.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1059.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1060.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1061.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1062.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1063.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1064.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1065.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1066.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1067.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1068.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1069.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1070.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1071.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1073.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1074.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1075.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1076.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1077.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1078.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1079.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1080.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1081.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1082.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1083.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1084.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1085.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1086.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1087.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1088.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1090.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1092.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1093.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1094.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1095.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1096.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1097.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1098.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1099.png\" width=\"200px\"></div><div class=\"zoomTarget\" data-targetsize=\"0.8\" data-closeclick=\"true\"><img src=\"pmimages/1100.png\" width=\"200px\"></div>";
  },"useData":true});
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("views/templates/graph", function(exports, require, module) {
var __templateData = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "<div></div>";
  },"useData":true});
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("views/templates/headerfooter", function(exports, require, module) {
var __templateData = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "\n	<div class=\"row\" id=\"header\">\n		<nav class=\"navbar navbar-default navbar-fixed top\" role=\"navigation\" style=\"background-color: #FFFFFF; border-color: #FFFFFF;\">\n			<div class=\"container\">\n				<div class=\"navbar-header\">\n					<button type=\"button\" class=\"navbar-toggle\" data-toggle=\"collapse\" data-target=\"#headercollapse\">\n						<span class=\"icon-bar\"></span>\n						<span class=\"icon-bar\"></span>\n						<span class=\"icon-bar\"></span>\n					</button>\n					<a href=\"/\" class=\"navbar-brand\" style=\"font-size: xx-large; line-height: 55%;\">\n					</a>\n				</div>\n				<div class=\"collapse navbar-collapse\" id=\"headercollapse\"style=\"padding: 0px;\">\n					<ul class=\"nav navbar-nav navbar-right\">\n								<li>\n									<a id=\"location\" href=\"#/\" data-toggle=\"portfilter\" data-target=\"location\">\n										location\n									</a>\n								</li>\n								<li>\n									<a id=\"person\" href=\"#/person\" data-toggle=\"portfilter\" data-target=\"person\">\n										person\n									</a>\n								</li>\n								<li>\n									<a id=switch-organization\" href=\"#/organization\" data-toggle=\"portfilter\" data-target=\"organization\">\n										organization\n									</a>\n								</li>\n								<li>\n									<a id=biotraj\" href=\"#/biotraj\" data-toggle=\"portfilter\" data-target=\"biotraj\">\n										biotrajectories\n									</a>\n								</li>\n					</ul>\n					<ul class=\"nav navbar-nav navbar-left\">\n						\n						<li><a id=\"\" href=\"#\" data-toggle=\"portfilter\" data-target=\"\">MENAM Art Map</a></li>\n						\n						<li><a id=\"\" href=\"#/\" data-toggle=\"portfilter\" data-target=\"\"></a></li>\n						<li><a id=\"\" href=\"#/\" data-toggle=\"portfilter\" data-target=\"\"></a></li>\n						<!-- <li class=\"dropdown\">\n							<a href=\"#\" class=\"dropdown-toggle\" data-toggle=\"dropdown\"><b class=\"caret\"></b></a>\n							<ul class=\"dropdown-menu\">\n								<li><a id=\"\" href=\"#/\" data-toggle=\"portfilter\" data-target=\"\"></a></li>\n						  		<li><a id=\"\" href=\"#/\" data-toggle=\"portfilter\" data-target=\"\"></a></li>\n						  		<li><a id=\"\" href=\"#gsa/\" data-toggle=\"portfilter\" data-target=\"\"></a></li>\n							</ul>\n						</li> -->\n						<li><a id=\"datadl\" href=\"#datadl/\" data-toggle=\"portfilter\" data-target=\"download\"></a></li>\n						 </div>\n					</ul>\n\n				</div>\n			</div>\n		</nav>\n	</div>\n";
  },"useData":true});
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("views/templates/home", function(exports, require, module) {
var __templateData = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "<div class=\"row\">\n  <div class=\"col-md-12\">\n  </div>\n  </div>\n</div>\n\n<div class=\"row\">\n</div>\n\n<div class=\"row\">\n	<div class=\"col-md-12\">\n	</div>\n</div>";
  },"useData":true});
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("views/templates/network", function(exports, require, module) {
var __templateData = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "\n\n<div class=\"row\" id=\"main-content\">\n\n<div class=\"row\" >\n  <div class=\"col-md-2 col-sm-4 col-xs-4\" id=\"region-bios\">\n  </div>  \n <div class=\"col-md-12 col-sm-8 col-xs-8\" id=\"map-region\">\n 	<div class=\"col-md-6\" id=\"region-graph\">\n 	</div>\n </div>\n</div>\n\n<div class=\"row\">\n</div>\n\n<div id=\"footer\">\n    <div class=\"container\">\n        <div class=\"row\">\n            <br>\n            <br>\n              <div class=\"col-md-8\">\n                <left>\n                  <a href=\"\" class=\"img-circle\" alt=\"the-brains\"></a>\n                  <br>\n                  <p class=\"footertext\">A project by NULab for Texts, Maps, And Networks – Northeastern University – Dietmar Offenhuber– Chris Riedl– Nick Beauchamp – Visualization: Armin Akhavan– Rohith Vallu</p> \n\n                </left>\n              </div>\n        </div>\n    </div>\n</div>\n\n";
  },"useData":true});
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("views/templates/orggraph", function(exports, require, module) {
var __templateData = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "<div></div>\n";
  },"useData":true});
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("views/templates/person", function(exports, require, module) {
var __templateData = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "<canvas>\n<script>\nvar links = [\n	{\"source\":0,\"target\":1,\"value\":2},{\"source\":0,\"target\":3,\"value\":2},{\"source\":0,\"target\":24,\"value\":2},{\"source\":0,\"target\":50,\"value\":2},{\"source\":0,\"target\":53,\"value\":2},{\"source\":0,\"target\":54,\"value\":2},{\"source\":0,\"target\":59,\"value\":2},{\"source\":0,\"target\":65,\"value\":3},{\"source\":0,\"target\":68,\"value\":2},{\"source\":0,\"target\":73,\"value\":2},{\"source\":0,\"target\":94,\"value\":2},{\"source\":0,\"target\":97,\"value\":2},{\"source\":1,\"target\":3,\"value\":2},{\"source\":1,\"target\":7,\"value\":2},{\"source\":1,\"target\":24,\"value\":2},{\"source\":1,\"target\":50,\"value\":2},{\"source\":1,\"target\":53,\"value\":2},{\"source\":1,\"target\":54,\"value\":2},{\"source\":1,\"target\":59,\"value\":2},{\"source\":1,\"target\":60,\"value\":2},{\"source\":1,\"target\":65,\"value\":2},{\"source\":1,\"target\":68,\"value\":2},{\"source\":1,\"target\":73,\"value\":2},{\"source\":1,\"target\":94,\"value\":2},{\"source\":1,\"target\":97,\"value\":2},{\"source\":1,\"target\":98,\"value\":2},{\"source\":2,\"target\":4,\"value\":2},{\"source\":2,\"target\":99,\"value\":2},{\"source\":3,\"target\":5,\"value\":2},{\"source\":3,\"target\":6,\"value\":2},{\"source\":3,\"target\":19,\"value\":2},{\"source\":3,\"target\":24,\"value\":3},{\"source\":3,\"target\":25,\"value\":2},{\"source\":3,\"target\":26,\"value\":2},{\"source\":3,\"target\":30,\"value\":2},{\"source\":3,\"target\":31,\"value\":2},{\"source\":3,\"target\":100,\"value\":2},{\"source\":3,\"target\":34,\"value\":2},{\"source\":3,\"target\":39,\"value\":2},{\"source\":3,\"target\":41,\"value\":2},{\"source\":3,\"target\":42,\"value\":2},{\"source\":3,\"target\":49,\"value\":2},{\"source\":3,\"target\":50,\"value\":2},{\"source\":3,\"target\":52,\"value\":2},{\"source\":3,\"target\":53,\"value\":3},{\"source\":3,\"target\":54,\"value\":2},{\"source\":3,\"target\":56,\"value\":2},{\"source\":3,\"target\":59,\"value\":3},{\"source\":3,\"target\":60,\"value\":2},{\"source\":3,\"target\":65,\"value\":2},{\"source\":3,\"target\":66,\"value\":2},{\"source\":3,\"target\":68,\"value\":2},{\"source\":3,\"target\":69,\"value\":4},{\"source\":3,\"target\":70,\"value\":2},{\"source\":3,\"target\":72,\"value\":2},{\"source\":3,\"target\":73,\"value\":2},{\"source\":3,\"target\":101,\"value\":2},{\"source\":3,\"target\":82,\"value\":2},{\"source\":3,\"target\":84,\"value\":2},{\"source\":3,\"target\":86,\"value\":2},{\"source\":3,\"target\":102,\"value\":2},{\"source\":3,\"target\":89,\"value\":2},{\"source\":3,\"target\":91,\"value\":4},{\"source\":3,\"target\":93,\"value\":4},{\"source\":3,\"target\":94,\"value\":5},{\"source\":3,\"target\":103,\"value\":3},{\"source\":3,\"target\":97,\"value\":3},{\"source\":3,\"target\":104,\"value\":3},{\"source\":4,\"target\":5,\"value\":3},{\"source\":4,\"target\":32,\"value\":2},{\"source\":4,\"target\":38,\"value\":3},{\"source\":4,\"target\":39,\"value\":3},{\"source\":4,\"target\":80,\"value\":2},{\"source\":4,\"target\":99,\"value\":7},{\"source\":5,\"target\":6,\"value\":2},{\"source\":5,\"target\":32,\"value\":3},{\"source\":5,\"target\":38,\"value\":4},{\"source\":5,\"target\":39,\"value\":5},{\"source\":5,\"target\":80,\"value\":4},{\"source\":5,\"target\":99,\"value\":3},{\"source\":5,\"target\":94,\"value\":2},{\"source\":5,\"target\":105,\"value\":3},{\"source\":5,\"target\":104,\"value\":2},{\"source\":6,\"target\":39,\"value\":2},{\"source\":6,\"target\":104,\"value\":2},{\"source\":7,\"target\":40,\"value\":2},{\"source\":7,\"target\":57,\"value\":2},{\"source\":7,\"target\":106,\"value\":2},{\"source\":7,\"target\":63,\"value\":2},{\"source\":7,\"target\":68,\"value\":2},{\"source\":7,\"target\":83,\"value\":2},{\"source\":7,\"target\":94,\"value\":3},{\"source\":7,\"target\":107,\"value\":2},{\"source\":7,\"target\":108,\"value\":2},{\"source\":7,\"target\":104,\"value\":2},{\"source\":8,\"target\":89,\"value\":2},{\"source\":9,\"target\":31,\"value\":3},{\"source\":9,\"target\":53,\"value\":2},{\"source\":9,\"target\":59,\"value\":2},{\"source\":9,\"target\":68,\"value\":2},{\"source\":9,\"target\":72,\"value\":2},{\"source\":9,\"target\":78,\"value\":2},{\"source\":9,\"target\":79,\"value\":2},{\"source\":9,\"target\":85,\"value\":2},{\"source\":9,\"target\":109,\"value\":2},{\"source\":9,\"target\":95,\"value\":2},{\"source\":9,\"target\":96,\"value\":2},{\"source\":9,\"target\":104,\"value\":2},{\"source\":9,\"target\":110,\"value\":2},{\"source\":10,\"target\":40,\"value\":2},{\"source\":10,\"target\":51,\"value\":2},{\"source\":10,\"target\":111,\"value\":2},{\"source\":10,\"target\":89,\"value\":3},{\"source\":11,\"target\":19,\"value\":2},{\"source\":11,\"target\":20,\"value\":2},{\"source\":12,\"target\":84,\"value\":2},{\"source\":12,\"target\":94,\"value\":2},{\"source\":13,\"target\":90,\"value\":3},{\"source\":13,\"target\":112,\"value\":3},{\"source\":14,\"target\":108,\"value\":2},{\"source\":15,\"target\":33,\"value\":2},{\"source\":15,\"target\":48,\"value\":2},{\"source\":15,\"target\":68,\"value\":2},{\"source\":15,\"target\":84,\"value\":2},{\"source\":15,\"target\":113,\"value\":2},{\"source\":16,\"target\":22,\"value\":2},{\"source\":16,\"target\":48,\"value\":3},{\"source\":16,\"target\":63,\"value\":2},{\"source\":16,\"target\":114,\"value\":3},{\"source\":17,\"target\":31,\"value\":2},{\"source\":17,\"target\":57,\"value\":2},{\"source\":17,\"target\":88,\"value\":2},{\"source\":17,\"target\":93,\"value\":2},{\"source\":17,\"target\":96,\"value\":2},{\"source\":17,\"target\":104,\"value\":2},{\"source\":18,\"target\":41,\"value\":2},{\"source\":19,\"target\":24,\"value\":2},{\"source\":19,\"target\":37,\"value\":2},{\"source\":19,\"target\":41,\"value\":2},{\"source\":19,\"target\":48,\"value\":2},{\"source\":19,\"target\":50,\"value\":2},{\"source\":19,\"target\":58,\"value\":2},{\"source\":19,\"target\":62,\"value\":2},{\"source\":19,\"target\":68,\"value\":2},{\"source\":19,\"target\":75,\"value\":3},{\"source\":19,\"target\":81,\"value\":2},{\"source\":19,\"target\":102,\"value\":2},{\"source\":19,\"target\":113,\"value\":2},{\"source\":19,\"target\":115,\"value\":2},{\"source\":19,\"target\":93,\"value\":2},{\"source\":19,\"target\":103,\"value\":2},{\"source\":19,\"target\":116,\"value\":2},{\"source\":20,\"target\":22,\"value\":2},{\"source\":20,\"target\":36,\"value\":2},{\"source\":20,\"target\":37,\"value\":2},{\"source\":20,\"target\":45,\"value\":2},{\"source\":20,\"target\":73,\"value\":2},{\"source\":20,\"target\":79,\"value\":2},{\"source\":20,\"target\":113,\"value\":2},{\"source\":21,\"target\":117,\"value\":2},{\"source\":22,\"target\":31,\"value\":2},{\"source\":22,\"target\":36,\"value\":2},{\"source\":22,\"target\":41,\"value\":2},{\"source\":22,\"target\":45,\"value\":3},{\"source\":22,\"target\":46,\"value\":4},{\"source\":22,\"target\":48,\"value\":2},{\"source\":22,\"target\":49,\"value\":2},{\"source\":22,\"target\":52,\"value\":2},{\"source\":22,\"target\":53,\"value\":3},{\"source\":22,\"target\":59,\"value\":2},{\"source\":22,\"target\":63,\"value\":2},{\"source\":22,\"target\":73,\"value\":2},{\"source\":22,\"target\":79,\"value\":3},{\"source\":22,\"target\":118,\"value\":2},{\"source\":23,\"target\":94,\"value\":2},{\"source\":24,\"target\":41,\"value\":2},{\"source\":24,\"target\":42,\"value\":2},{\"source\":24,\"target\":50,\"value\":2},{\"source\":24,\"target\":51,\"value\":2},{\"source\":24,\"target\":53,\"value\":2},{\"source\":24,\"target\":54,\"value\":2},{\"source\":24,\"target\":59,\"value\":2},{\"source\":24,\"target\":65,\"value\":2},{\"source\":24,\"target\":68,\"value\":2},{\"source\":24,\"target\":73,\"value\":2},{\"source\":24,\"target\":119,\"value\":2},{\"source\":24,\"target\":120,\"value\":2},{\"source\":24,\"target\":93,\"value\":2},{\"source\":24,\"target\":94,\"value\":2},{\"source\":24,\"target\":103,\"value\":2},{\"source\":24,\"target\":97,\"value\":2},{\"source\":25,\"target\":34,\"value\":2},{\"source\":26,\"target\":49,\"value\":2},{\"source\":26,\"target\":52,\"value\":2},{\"source\":26,\"target\":66,\"value\":2},{\"source\":26,\"target\":69,\"value\":2},{\"source\":27,\"target\":121,\"value\":2},{\"source\":28,\"target\":108,\"value\":2},{\"source\":28,\"target\":122,\"value\":2},{\"source\":29,\"target\":46,\"value\":2},{\"source\":29,\"target\":123,\"value\":2},{\"source\":29,\"target\":124,\"value\":2},{\"source\":30,\"target\":59,\"value\":2},{\"source\":30,\"target\":70,\"value\":2},{\"source\":30,\"target\":73,\"value\":2},{\"source\":30,\"target\":89,\"value\":2},{\"source\":30,\"target\":93,\"value\":2},{\"source\":31,\"target\":52,\"value\":2},{\"source\":31,\"target\":53,\"value\":3},{\"source\":31,\"target\":55,\"value\":2},{\"source\":31,\"target\":63,\"value\":2},{\"source\":31,\"target\":68,\"value\":2},{\"source\":31,\"target\":72,\"value\":2},{\"source\":31,\"target\":79,\"value\":2},{\"source\":31,\"target\":85,\"value\":2},{\"source\":31,\"target\":125,\"value\":2},{\"source\":31,\"target\":93,\"value\":2},{\"source\":31,\"target\":97,\"value\":2},{\"source\":31,\"target\":109,\"value\":2},{\"source\":31,\"target\":95,\"value\":2},{\"source\":31,\"target\":104,\"value\":2},{\"source\":32,\"target\":38,\"value\":2},{\"source\":32,\"target\":39,\"value\":3},{\"source\":32,\"target\":99,\"value\":2},{\"source\":33,\"target\":61,\"value\":2},{\"source\":33,\"target\":68,\"value\":2},{\"source\":33,\"target\":83,\"value\":2},{\"source\":33,\"target\":84,\"value\":2},{\"source\":33,\"target\":113,\"value\":2},{\"source\":33,\"target\":126,\"value\":2},{\"source\":34,\"target\":117,\"value\":2},{\"source\":35,\"target\":48,\"value\":2},{\"source\":36,\"target\":37,\"value\":2},{\"source\":36,\"target\":40,\"value\":2},{\"source\":36,\"target\":41,\"value\":2},{\"source\":36,\"target\":42,\"value\":2},{\"source\":36,\"target\":45,\"value\":2},{\"source\":36,\"target\":53,\"value\":2},{\"source\":36,\"target\":58,\"value\":4},{\"source\":36,\"target\":59,\"value\":2},{\"source\":36,\"target\":61,\"value\":2},{\"source\":36,\"target\":73,\"value\":2},{\"source\":36,\"target\":76,\"value\":2},{\"source\":36,\"target\":79,\"value\":2},{\"source\":36,\"target\":91,\"value\":2},{\"source\":36,\"target\":113,\"value\":2},{\"source\":36,\"target\":98,\"value\":2},{\"source\":37,\"target\":40,\"value\":2},{\"source\":37,\"target\":48,\"value\":2},{\"source\":37,\"target\":68,\"value\":2},{\"source\":37,\"target\":73,\"value\":2},{\"source\":37,\"target\":113,\"value\":2},{\"source\":38,\"target\":39,\"value\":4},{\"source\":38,\"target\":80,\"value\":3},{\"source\":38,\"target\":99,\"value\":3},{\"source\":38,\"target\":105,\"value\":2},{\"source\":39,\"target\":80,\"value\":3},{\"source\":39,\"target\":99,\"value\":3},{\"source\":39,\"target\":94,\"value\":2},{\"source\":39,\"target\":105,\"value\":2},{\"source\":39,\"target\":104,\"value\":2},{\"source\":40,\"target\":48,\"value\":2},{\"source\":40,\"target\":49,\"value\":2},{\"source\":40,\"target\":51,\"value\":3},{\"source\":40,\"target\":64,\"value\":2},{\"source\":40,\"target\":68,\"value\":2},{\"source\":40,\"target\":73,\"value\":2},{\"source\":40,\"target\":101,\"value\":2},{\"source\":40,\"target\":127,\"value\":2},{\"source\":40,\"target\":89,\"value\":3},{\"source\":40,\"target\":126,\"value\":2},{\"source\":40,\"target\":94,\"value\":2},{\"source\":40,\"target\":116,\"value\":2},{\"source\":41,\"target\":42,\"value\":2},{\"source\":41,\"target\":46,\"value\":2},{\"source\":41,\"target\":53,\"value\":2},{\"source\":41,\"target\":58,\"value\":2},{\"source\":41,\"target\":59,\"value\":2},{\"source\":41,\"target\":61,\"value\":2},{\"source\":41,\"target\":91,\"value\":2},{\"source\":41,\"target\":113,\"value\":2},{\"source\":41,\"target\":103,\"value\":2},{\"source\":41,\"target\":96,\"value\":2},{\"source\":42,\"target\":50,\"value\":2},{\"source\":42,\"target\":115,\"value\":2},{\"source\":42,\"target\":93,\"value\":2},{\"source\":42,\"target\":98,\"value\":3},{\"source\":43,\"target\":71,\"value\":2},{\"source\":43,\"target\":94,\"value\":2},{\"source\":44,\"target\":128,\"value\":2},{\"source\":45,\"target\":49,\"value\":2},{\"source\":45,\"target\":52,\"value\":2},{\"source\":45,\"target\":53,\"value\":2},{\"source\":45,\"target\":79,\"value\":2},{\"source\":46,\"target\":53,\"value\":2},{\"source\":46,\"target\":129,\"value\":2},{\"source\":46,\"target\":79,\"value\":2},{\"source\":46,\"target\":118,\"value\":2},{\"source\":47,\"target\":117,\"value\":2},{\"source\":48,\"target\":53,\"value\":2},{\"source\":48,\"target\":63,\"value\":3},{\"source\":48,\"target\":68,\"value\":2},{\"source\":48,\"target\":113,\"value\":2},{\"source\":49,\"target\":53,\"value\":2},{\"source\":49,\"target\":87,\"value\":2},{\"source\":50,\"target\":53,\"value\":2},{\"source\":50,\"target\":54,\"value\":2},{\"source\":50,\"target\":59,\"value\":2},{\"source\":50,\"target\":60,\"value\":2},{\"source\":50,\"target\":65,\"value\":2},{\"source\":50,\"target\":68,\"value\":2},{\"source\":50,\"target\":73,\"value\":2},{\"source\":50,\"target\":75,\"value\":2},{\"source\":50,\"target\":94,\"value\":2},{\"source\":50,\"target\":97,\"value\":2},{\"source\":50,\"target\":130,\"value\":2},{\"source\":50,\"target\":98,\"value\":2},{\"source\":51,\"target\":68,\"value\":2},{\"source\":51,\"target\":131,\"value\":2},{\"source\":51,\"target\":132,\"value\":2},{\"source\":51,\"target\":127,\"value\":2},{\"source\":51,\"target\":89,\"value\":2},{\"source\":51,\"target\":120,\"value\":2},{\"source\":51,\"target\":97,\"value\":2},{\"source\":52,\"target\":73,\"value\":2},{\"source\":52,\"target\":89,\"value\":2},{\"source\":52,\"target\":97,\"value\":2},{\"source\":53,\"target\":54,\"value\":2},{\"source\":53,\"target\":58,\"value\":2},{\"source\":53,\"target\":59,\"value\":3},{\"source\":53,\"target\":61,\"value\":2},{\"source\":53,\"target\":63,\"value\":2},{\"source\":53,\"target\":65,\"value\":2},{\"source\":53,\"target\":68,\"value\":2},{\"source\":53,\"target\":72,\"value\":2},{\"source\":53,\"target\":73,\"value\":2},{\"source\":53,\"target\":79,\"value\":2},{\"source\":53,\"target\":82,\"value\":2},{\"source\":53,\"target\":102,\"value\":2},{\"source\":53,\"target\":89,\"value\":2},{\"source\":53,\"target\":91,\"value\":2},{\"source\":53,\"target\":113,\"value\":2},{\"source\":53,\"target\":93,\"value\":2},{\"source\":53,\"target\":94,\"value\":3},{\"source\":53,\"target\":97,\"value\":2},{\"source\":54,\"target\":57,\"value\":2},{\"source\":54,\"target\":59,\"value\":2},{\"source\":54,\"target\":65,\"value\":2},{\"source\":54,\"target\":68,\"value\":2},{\"source\":54,\"target\":73,\"value\":2},{\"source\":54,\"target\":83,\"value\":2},{\"source\":54,\"target\":94,\"value\":2},{\"source\":54,\"target\":97,\"value\":2},{\"source\":55,\"target\":125,\"value\":2},{\"source\":56,\"target\":91,\"value\":2},{\"source\":56,\"target\":113,\"value\":2},{\"source\":56,\"target\":107,\"value\":2},{\"source\":57,\"target\":61,\"value\":2},{\"source\":57,\"target\":63,\"value\":2},{\"source\":57,\"target\":68,\"value\":2},{\"source\":57,\"target\":83,\"value\":2},{\"source\":57,\"target\":88,\"value\":2},{\"source\":57,\"target\":96,\"value\":2},{\"source\":57,\"target\":104,\"value\":2},{\"source\":58,\"target\":59,\"value\":2},{\"source\":58,\"target\":61,\"value\":2},{\"source\":58,\"target\":91,\"value\":2},{\"source\":58,\"target\":113,\"value\":2},{\"source\":59,\"target\":61,\"value\":2},{\"source\":59,\"target\":65,\"value\":2},{\"source\":59,\"target\":68,\"value\":2},{\"source\":59,\"target\":70,\"value\":2},{\"source\":59,\"target\":73,\"value\":2},{\"source\":59,\"target\":78,\"value\":2},{\"source\":59,\"target\":82,\"value\":2},{\"source\":59,\"target\":89,\"value\":2},{\"source\":59,\"target\":91,\"value\":3},{\"source\":59,\"target\":113,\"value\":2},{\"source\":59,\"target\":93,\"value\":2},{\"source\":59,\"target\":94,\"value\":2},{\"source\":59,\"target\":97,\"value\":2},{\"source\":59,\"target\":95,\"value\":2},{\"source\":60,\"target\":94,\"value\":2},{\"source\":60,\"target\":98,\"value\":3},{\"source\":61,\"target\":91,\"value\":2},{\"source\":61,\"target\":113,\"value\":2},{\"source\":61,\"target\":126,\"value\":2},{\"source\":62,\"target\":75,\"value\":2},{\"source\":62,\"target\":102,\"value\":2},{\"source\":63,\"target\":68,\"value\":2},{\"source\":63,\"target\":79,\"value\":2},{\"source\":63,\"target\":83,\"value\":3},{\"source\":63,\"target\":104,\"value\":2},{\"source\":64,\"target\":68,\"value\":2},{\"source\":64,\"target\":76,\"value\":2},{\"source\":64,\"target\":89,\"value\":2},{\"source\":65,\"target\":68,\"value\":2},{\"source\":65,\"target\":73,\"value\":2},{\"source\":65,\"target\":94,\"value\":2},{\"source\":65,\"target\":97,\"value\":2},{\"source\":65,\"target\":108,\"value\":2},{\"source\":66,\"target\":69,\"value\":2},{\"source\":67,\"target\":133,\"value\":2},{\"source\":68,\"target\":70,\"value\":2},{\"source\":68,\"target\":72,\"value\":2},{\"source\":68,\"target\":73,\"value\":2},{\"source\":68,\"target\":127,\"value\":2},{\"source\":68,\"target\":83,\"value\":2},{\"source\":68,\"target\":84,\"value\":2},{\"source\":68,\"target\":85,\"value\":2},{\"source\":68,\"target\":88,\"value\":2},{\"source\":68,\"target\":89,\"value\":2},{\"source\":68,\"target\":113,\"value\":3},{\"source\":68,\"target\":94,\"value\":2},{\"source\":68,\"target\":97,\"value\":2},{\"source\":68,\"target\":109,\"value\":2},{\"source\":68,\"target\":95,\"value\":2},{\"source\":68,\"target\":104,\"value\":2},{\"source\":69,\"target\":134,\"value\":2},{\"source\":69,\"target\":91,\"value\":3},{\"source\":69,\"target\":94,\"value\":3},{\"source\":69,\"target\":107,\"value\":2},{\"source\":70,\"target\":87,\"value\":2},{\"source\":70,\"target\":89,\"value\":3},{\"source\":70,\"target\":93,\"value\":2},{\"source\":71,\"target\":94,\"value\":2},{\"source\":72,\"target\":79,\"value\":2},{\"source\":72,\"target\":85,\"value\":2},{\"source\":72,\"target\":94,\"value\":2},{\"source\":72,\"target\":95,\"value\":2},{\"source\":72,\"target\":104,\"value\":2},{\"source\":73,\"target\":135,\"value\":2},{\"source\":73,\"target\":85,\"value\":2},{\"source\":73,\"target\":89,\"value\":2},{\"source\":73,\"target\":94,\"value\":2},{\"source\":73,\"target\":97,\"value\":2},{\"source\":73,\"target\":95,\"value\":2},{\"source\":74,\"target\":94,\"value\":2},{\"source\":74,\"target\":136,\"value\":2},{\"source\":75,\"target\":102,\"value\":2},{\"source\":75,\"target\":108,\"value\":2},{\"source\":76,\"target\":89,\"value\":2},{\"source\":77,\"target\":107,\"value\":2},{\"source\":78,\"target\":79,\"value\":2},{\"source\":78,\"target\":91,\"value\":2},{\"source\":78,\"target\":92,\"value\":2},{\"source\":78,\"target\":96,\"value\":2},{\"source\":78,\"target\":110,\"value\":2},{\"source\":79,\"target\":96,\"value\":2},{\"source\":79,\"target\":110,\"value\":2},{\"source\":80,\"target\":99,\"value\":2},{\"source\":80,\"target\":105,\"value\":3},{\"source\":81,\"target\":93,\"value\":2},{\"source\":82,\"target\":91,\"value\":2},{\"source\":82,\"target\":92,\"value\":2},{\"source\":82,\"target\":93,\"value\":2},{\"source\":83,\"target\":104,\"value\":2},{\"source\":84,\"target\":113,\"value\":2},{\"source\":84,\"target\":94,\"value\":2},{\"source\":85,\"target\":95,\"value\":2},{\"source\":85,\"target\":104,\"value\":2},{\"source\":86,\"target\":97,\"value\":2},{\"source\":87,\"target\":89,\"value\":2},{\"source\":87,\"target\":93,\"value\":2},{\"source\":87,\"target\":116,\"value\":2},{\"source\":88,\"target\":96,\"value\":2},{\"source\":88,\"target\":104,\"value\":2},{\"source\":89,\"target\":120,\"value\":2},{\"source\":89,\"target\":93,\"value\":2},{\"source\":90,\"target\":136,\"value\":2},{\"source\":90,\"target\":112,\"value\":3},{\"source\":91,\"target\":113,\"value\":2},{\"source\":91,\"target\":94,\"value\":3},{\"source\":91,\"target\":103,\"value\":2},{\"source\":92,\"target\":93,\"value\":2},{\"source\":93,\"target\":96,\"value\":2},{\"source\":93,\"target\":104,\"value\":2},{\"source\":94,\"target\":103,\"value\":2},{\"source\":94,\"target\":97,\"value\":2},{\"source\":94,\"target\":136,\"value\":3},{\"source\":94,\"target\":107,\"value\":3},{\"source\":94,\"target\":108,\"value\":2},{\"source\":94,\"target\":137,\"value\":2},{\"source\":94,\"target\":104,\"value\":3},{\"source\":95,\"target\":104,\"value\":2},{\"source\":96,\"target\":104,\"value\":2},{\"source\":96,\"target\":110,\"value\":2}	\n];\n\nvar nodes = [\n	{\"name\":\"Abdullah Al Saadi\",\"group\":6},{\"name\":\"Abdulnasser Gharem\",\"group\":6},{\"name\":\"Adam Henein\",\"group\":1},{\"name\":\"Adel Abidin\",\"group\":4},{\"name\":\"Adham Wanly\",\"group\":1},{\"name\":\"Ahmad Osman\",\"group\":1},{\"name\":\"Ahmed Alsoudani\",\"group\":1},{\"name\":\"Ahmed Mater\",\"group\":3},{\"name\":\"Aisha Khalid\",\"group\":6},{\"name\":\"Akram Zaatari\",\"group\":1},{\"name\":\"Ala Ebtekar\",\"group\":6},{\"name\":\"Amar Kanwar\",\"group\":2},{\"name\":\"Amir H. Fallah\",\"group\":3},{\"name\":\"Ammar Al Attar\",\"group\":3},{\"name\":\"Athier\",\"group\":3},{\"name\":\"Ay e Erkmen\",\"group\":5},{\"name\":\"Ayreen Anastas\",\"group\":5},{\"name\":\"Basim Magdy \",\"group\":1},{\"name\":\"Burak Arikan\",\"group\":5},{\"name\":\"CAMP\",\"group\":2},{\"name\":\"Cevdet Erek\",\"group\":5},{\"name\":\"Dia Al-Azzawi \",\"group\":4},{\"name\":\"Doa Aly\",\"group\":5},{\"name\":\"Ebtisam Abdulaziz\",\"group\":3},{\"name\":\"Eungie Joo\",\"group\":6},{\"name\":\"Fahrelnissa Zeid\",\"group\":4},{\"name\":\"Farid Belkahia\",\"group\":4},{\"name\":\"Farshid Maleki\",\"group\":8},{\"name\":\"Fateh Moudarres\",\"group\":3},{\"name\":\"Fatima Al Qadiri\",\"group\":7},{\"name\":\"Fay al Baghriche \",\"group\":6},{\"name\":\"Fouad Elkoury\",\"group\":1},{\"name\":\"Gamal el-Sigini\",\"group\":1},{\"name\":\"Gita Meh\",\"group\":5},{\"name\":\"Hafidh al-Droubi\",\"group\":4},{\"name\":\"Haig Aivazian\",\"group\":5},{\"name\":\"Hala Elkoussy\",\"group\":5},{\"name\":\"Halil Altindere\",\"group\":5},{\"name\":\"Hamed Nada\",\"group\":1},{\"name\":\"Hamed Owais\",\"group\":1},{\"name\":\"Hamra Abbas\",\"group\":6},{\"name\":\"Haris Epaminonda\",\"group\":5},{\"name\":\"Haroon Mirza \",\"group\":2},{\"name\":\"Hassan Massoudy\",\"group\":3},{\"name\":\"Hesam Rahmanian\",\"group\":10},{\"name\":\"Hrair Sarkissian\",\"group\":5},{\"name\":\"Iman Issa\",\"group\":5},{\"name\":\"Ismail al-Shaikhly\",\"group\":4},{\"name\":\"Jalal Toufic\",\"group\":5},{\"name\":\"Jananne Al-Ani\",\"group\":4},{\"name\":\"Jawad Al Malhi\",\"group\":6},{\"name\":\"Jayce Salloum\",\"group\":6},{\"name\":\"Jumana Emil Abboud\",\"group\":4},{\"name\":\"Lamia Joreige\",\"group\":6},{\"name\":\"Lamya Gargash\",\"group\":6},{\"name\":\"Lara Baladi\",\"group\":1},{\"name\":\"Larissa Sansour\",\"group\":5},{\"name\":\"Laurent Grasso\",\"group\":1},{\"name\":\"Lawrence Abu Hamdan \",\"group\":5},{\"name\":\"Maha Maamoun\",\"group\":6},{\"name\":\"Manal Al Dowayan\",\"group\":2},{\"name\":\"Mariam Ghani\",\"group\":5},{\"name\":\"Marwan Rechmaoui\",\"group\":2},{\"name\":\"Melik Ohanian\",\"group\":5},{\"name\":\"Meri  Alg n Ringborg \",\"group\":6},{\"name\":\"Moataz Nasr\",\"group\":6},{\"name\":\"Mohammed Melehi\",\"group\":4},{\"name\":\"Mohsen Ahmadvand\",\"group\":9},{\"name\":\"Mona Hatoum\",\"group\":6},{\"name\":\"Mona Saudi\",\"group\":4},{\"name\":\"Monir Shahroudy Farmanfarmaian\",\"group\":6},{\"name\":\"Mounir Al-Shaarani\",\"group\":3},{\"name\":\"mounir fatmi\",\"group\":1},{\"name\":\"Mounira Al Solh\",\"group\":6},{\"name\":\"Murtaza Vali\",\"group\":3},{\"name\":\"N.S. Harsha\",\"group\":2},{\"name\":\"Nevin Aladag\",\"group\":6},{\"name\":\"Nicky Nodjoumi\",\"group\":3},{\"name\":\"Nil Yalter\",\"group\":1},{\"name\":\"Rabih Mrou \",\"group\":5},{\"name\":\"Ragheb Ayad\",\"group\":1},{\"name\":\"Rasheed Araeen\",\"group\":2},{\"name\":\"Rashid Masharawi\",\"group\":6},{\"name\":\"Reem Al Ghaith\",\"group\":5},{\"name\":\"Robert MacPherson\",\"group\":3},{\"name\":\"Rosalind Nashashibi\",\"group\":1},{\"name\":\"Rula Halawani\",\"group\":4},{\"name\":\"Runa Islam\",\"group\":6},{\"name\":\"Sa dane Afif\",\"group\":1},{\"name\":\"Shahzia Sikander\",\"group\":6},{\"name\":\"Shaikha Al Mazrou\",\"group\":3},{\"name\":\"Sharif Waked\",\"group\":5},{\"name\":\"Steve Reinke\",\"group\":6},{\"name\":\"Susan Hefuna\",\"group\":6},{\"name\":\"Tarek Al-Ghoussein\",\"group\":3},{\"name\":\"Yto Barrada\",\"group\":1},{\"name\":\"Ziad Antar\",\"group\":1},{\"name\":\"Taysir Batniji\",\"group\":6},{\"name\":\"Yazan Khalili\",\"group\":2},{\"name\":\"Seif Wanly\",\"group\":1},{\"name\":\"Georges Sabbagh\",\"group\":4},{\"name\":\"Nadia Kaabi-Linke\",\"group\":4},{\"name\":\"Sarah Abu Abdallah\",\"group\":2},{\"name\":\"Tarek Atoui\",\"group\":5},{\"name\":\"Zineb Sedira\",\"group\":1},{\"name\":\"Youssef Kamel\",\"group\":1},{\"name\":\"Lulwah Al-Homoud\",\"group\":3},{\"name\":\"Walid Siti\",\"group\":3},{\"name\":\"Youssef Abdelk \",\"group\":3},{\"name\":\"Walid Raad\",\"group\":1},{\"name\":\"Zoulikha-Bouabdellah\",\"group\":1},{\"name\":\"Pouran-Jinchi\",\"group\":6},{\"name\":\"Zeinab Al Hashemi\",\"group\":3},{\"name\":\"Simryn Gill\",\"group\":5},{\"name\":\"Ren  Gabri\",\"group\":5},{\"name\":\"Sophia Al Maria\",\"group\":2},{\"name\":\"Wael Shawky\",\"group\":6},{\"name\":\"Khalid al-Jader\",\"group\":4},{\"name\":\"Sherif El Azma\",\"group\":5},{\"name\":\"Rayyane Tabet\",\"group\":6},{\"name\":\"Shirin Neshat\",\"group\":6},{\"name\":\"Nargess Hashemi\",\"group\":8},{\"name\":\"Ziad Dalloul\",\"group\":3},{\"name\":\"Khalid Al Gharaballi\",\"group\":7},{\"name\":\"Nadia Ayari\",\"group\":7},{\"name\":\"Setareh Shahbazi\",\"group\":1},{\"name\":\"Sophie Ernst\",\"group\":5},{\"name\":\"Raeda Saadeh\",\"group\":6},{\"name\":\"Niyaz-Azadikhah\",\"group\":10},{\"name\":\"Mona Marzouk\",\"group\":5},{\"name\":\"Waheeda Malullah\",\"group\":6},{\"name\":\"Naeem Mohaiemen\",\"group\":6},{\"name\":\"Nida Sinnokrot\",\"group\":6},{\"name\":\"Shahrzad Changalvaee\",\"group\":9},{\"name\":\"Rachid Kora chi\",\"group\":4},{\"name\":\"Raed Yassin\",\"group\":6},{\"name\":\"Wafaa Bilal\",\"group\":3},{\"name\":\"Youssef Nabil\",\"group\":3}\n];\n\n\n//d3 code mainly from http://bl.ocks.org/mbostock/4062045 and http://bl.ocks.org/mbostock/2706022\n\nvar width = 1200,\n    height = 700;\n    \nvar color = d3.scale.category20();\n\nvar svg = d3.select(\"body\").append(\"svg\")\n    .attr(\"width\", width)\n    .attr(\"height\", height);\n\nvar force = d3.layout.force()\n    .nodes(nodes)\n    .links(links)\n    .size([width, height])\n    .linkDistance(60)\n    .charge(-500)\n    .linkStrength(0.7)\n    .gravity(0.3)\n    .on(\"tick\", tick)\n    .start();\n    \n\nvar link = svg.selectAll(\".link\")\n    .data(force.links())\n  .enter().append(\"line\")\n    .attr(\"class\", \"link\")\n    .style(\"stroke\",\"lightgray\")\n    .style(\"stroke-width\", function(d) { return Math.sqrt(d.value); });\n\nvar node = svg.selectAll(\".node\")\n    .data(force.nodes())\n  .enter().append(\"g\")\n    .attr(\"class\", \"node\")\n    .on(\"mouseover\", mouseover)\n    .on(\"mouseout\", mouseout)\n    .on(\"touchstart\", mouseover)\n    .on(\"touchend\", mouseout)\n    .call(force.drag)\n     .on('click', connectedNodes);\n\nnode.append(\"circle\")\n	.style(\"fill\", function(d) { return color(d.group); })\n    .attr(\"r\", 5);\n\nnode.append(\"text\")\n    .attr(\"x\", 14)\n    .attr(\"dy\", \".35em\")\n    .text(function(d) { return d.name; });\n\nfunction tick() {\n  link\n      .attr(\"x1\", function(d) { return d.source.x; })\n      .attr(\"y1\", function(d) { return d.source.y; })\n      .attr(\"x2\", function(d) { return d.target.x; })\n      .attr(\"y2\", function(d) { return d.target.y; });\n\n  node\n      .attr(\"transform\", function(d) { return \"translate(\" + d.x + \",\" + d.y + \")\"; });\n}\n\nfunction mouseover() {\n  d3.select(this).select(\"circle\").transition()\n      .duration(750)\n      .attr(\"r\", 12);\n  d3.select(this).select(\"text\").transition()\n      .duration(750)\n      .style(\"font-size\", \"20px\");\n}\n\nfunction mouseout() {\n  d3.select(this).select(\"circle\").transition()\n      .duration(750)\n      .attr(\"r\", 5);\n  d3.select(this).select(\"text\").transition()\n      .duration(750)\n      .style(\"font-size\", \"10px\");\n}\n\n//SEARCH BOX \n//code from http://www.coppelia.io/2014/07/an-a-to-z-of-extra-features-for-the-d3-force-layout/\nvar optArray = [];\nfor (var i = 0; i < nodes.length - 1; i++) {\n    optArray.push(nodes[i].name);\n}\noptArray = optArray.sort();\nfunction searchNode() {\n    //find the node\n    var selectedVal = document.getElementById('search').value;\n    var node = svg.selectAll(\".node\");\n    if (selectedVal == \"none\") {\n        node.style(\"stroke\", \"white\").style(\"stroke-width\", \"1\");\n    } else {\n        var selected = node.filter(function (d, i) {\n            return d.name != selectedVal;\n        });\n        selected.style(\"opacity\", \"0\");\n        var link = svg.selectAll(\".link\")\n        link.style(\"opacity\", \"0\");\n        d3.selectAll(\".node, .link\").transition()\n            .duration(3000)\n            .style(\"opacity\", 1);\n    }\n}\n\n\n//SUBNET HIGHLIGHT\n//code from http://www.coppelia.io/2014/07/an-a-to-z-of-extra-features-for-the-d3-force-layout/\n//Toggle stores whether the highlighting is on\nvar toggle = 0;\n//Create an array logging what is connected to what\nvar linkedByIndex = {};\nfor (i = 0; i < nodes.length; i++) {\n    linkedByIndex[i + \",\" + i] = 1;\n};\nlinks.forEach(function (d) {\n    linkedByIndex[d.source.index + \",\" + d.target.index] = 1;\n});\n//This function looks up whether a pair are neighbours  \nfunction neighboring(a, b) {\n    return linkedByIndex[a.index + \",\" + b.index];\n}\n//do it\nfunction connectedNodes() {\n    if (toggle == 0) {\n        //Reduce the opacity of all but the neighbouring nodes\n        d = d3.select(this).node().__data__;\n        node.style(\"opacity\", function (o) {\n            return neighboring(d, o) | neighboring(o, d) ? 1 : 0.1;\n        });\n        link.style(\"opacity\", function (o) {\n            return d.index==o.source.index | d.index==o.target.index ? 1 : 0.1;\n        });\n        toggle = 1;\n    } else {\n        //Put them back to opacity=1\n        node.style(\"opacity\", 1);\n        link.style(\"opacity\", 1);\n        toggle = 0;\n    }\n}\n</script>\n\n</canvas>";
  },"useData":true});
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;
//# sourceMappingURL=app.js.map