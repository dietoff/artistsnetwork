exports.config =
  # See docs at http://brunch.readthedocs.org/en/latest/config.html.
  files:
    javascripts:
      defaultExtension: 'coffee'
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^vendor||^bower_components/  
        'test/javascripts/test.js': /^test[\\/](?!vendor)/
        'test/javascripts/test-vendor.js': /^test[\\/](?=vendor)/
      order:
        before: [
          'vendor/scripts/console-helper.js'
          'bower_components/jquery/dist/jquery.js'
          'bower_components/underscore/underscore.js'
          'bower_components/backbone/backbone.js'
          'bower_components/marionette/lib/backbone.marionette.js'
          'bower_components/bootstrap/dist/js/bootstrap.js'
          'bower_components/mapbox.js/mapbox.js'
          'bower_components/d3/d3.js'
          'bower_components/queue-async/queue.js'
          'vendor/scripts/paratext.js'
        ]
        after: [
          'test/vendor/scripts/test-helper.js'
        ]

    stylesheets:
      defaultExtension: 'styl'
      joinTo:
        'stylesheets/app.css': /^app(\/|\\)views(\/|\\)styles(\/|\\)/
        'stylesheets/vendor.css': /^vendor(\/|\\)styles||^bower_components/
        'test/stylesheets/vendor.css': /^test(\/|\\)vendor(\/|\\)styles(\/|\\)/
      order:
        before: [
          'bower_components/bootstrap/dist/css/bootstrap.css'
          'bower_components/bootstrap/dist/css/bootstrap-theme.css'
          'bower_components/mapbox.js/mapbox.css'

        ]
        after: []

    templates:
      defaultExtension: 'hbs'
      joinTo: 'javascripts/app.js'
