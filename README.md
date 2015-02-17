using [brunch](http://brunch.io/) for skeleton/environment.
# application dev setup

npm needs to be installed. If using *NIX machines you can use [Homebrew](http://brew.sh):
```
brew install npm
```
mongodb could be installed with brew:
```
brew install mongodb
```

## development

clone/download the repo and cd into the folder

### install brunch
```
npm install -g brunch
```
### starting the mongodb
```
mongod --path data/db --rest
```
### running the development servers, and watch the project to re-compile
```
node server.js
brunch watch --server
```

### check out the bios' view on `localhost:3333/`

# based on the Brunch with Marionette:
## Brunch with Marionette
This is a simple coffee skeleton for [Brunch](http://brunch.io/) which utilizes [MarionetteJS](http://marionettejs.com/).

Main languages are [CoffeeScript](http://coffeescript.org/),
[Stylus](http://learnboost.github.com/stylus/) and
[Handlebars](http://handlebarsjs.com/).

## Other
Versions of software the skeleton uses:

* Twitter Bootstrap 3.2.0
* MarionetteJS 1.8.8

### (MIT License)
We assume no rights or liablities for the code contained.  All libraries are owned and licensed by the ownsers.  Use at your own risk.

Distributed under MIT license.
