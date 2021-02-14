// Generated by Haxe 4.1.5
(function ($global) { "use strict";
var electron_main_App = require("electron").app;
var electron_main_BrowserWindow = require("electron").BrowserWindow;
var feint_assets_macros_ApplicationSettings = function() { };
var feint_system_FeintElectron = function() { };
feint_system_FeintElectron.main = function() {
	electron_main_App.on("ready",function(e) {
		var win = new electron_main_BrowserWindow({ width : 640, height : 640, useContentSize : true, resizable : false, webPreferences : { nodeIntegration : true}});
		win.removeMenu();
		win.on("closed",function() {
			win = null;
		});
		win.loadFile("index.html");
		console.log("feint/system/FeintElectron.hx:28:",__dirname);
	});
	electron_main_App.on("window-all-closed",function(e) {
		if(process.platform != "darwin") {
			electron_main_App.quit();
		}
	});
};
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
haxe_iterators_ArrayIterator.prototype = {
	hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
};
var js_node_KeyValue = {};
js_node_KeyValue.get_key = function(this1) {
	return this1[0];
};
js_node_KeyValue.get_value = function(this1) {
	return this1[1];
};
var js_node_stream_WritableNewOptionsAdapter = {};
js_node_stream_WritableNewOptionsAdapter.from = function(options) {
	if(!Object.prototype.hasOwnProperty.call(options,"final")) {
		Object.defineProperty(options,"final",{ get : function() {
			return options.final_;
		}});
	}
	return options;
};
var js_node_url_URLSearchParamsEntry = {};
js_node_url_URLSearchParamsEntry._new = function(name,value) {
	var this1 = [name,value];
	return this1;
};
js_node_url_URLSearchParamsEntry.get_name = function(this1) {
	return this1[0];
};
js_node_url_URLSearchParamsEntry.get_value = function(this1) {
	return this1[1];
};
feint_system_FeintElectron.main();
})({});

//# sourceMappingURL=feint-electron.js.map