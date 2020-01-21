'use strict';

//require("./style.scss")

var Elm = require('./Home').Elm
var target = document.getElementById('app');

var app = Elm.Home.init({node: target});
