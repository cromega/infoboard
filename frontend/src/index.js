'use strict';

require("./css/style.scss")

var Elm = require('./App').Elm
Elm.App.init({node: document.getElementById('app')});