(function(){
	var q = [],
		load = function (v_opt){
			var version = v_opt || "1.7.2";
		
			loadScript("http://ajax.googleapis.com/ajax/libs/jquery/" + version + "/jquery.min.js", function(){
				doJquery();
			});
		},
	
		loadScript = function (url, callback) {
			var sNew = document.createElement("script");
			sNew.async = true;
			sNew.src = url;
			if ( "function" === typeof(callback) ) {
				sNew.onload = function() {
					callback();
					sNew.onload = sNew.onreadystatechange = undefined; // clear it out to avoid getting called twice
				};
				sNew.onreadystatechange = function() {
					if ( "loaded" === sNew.readyState || "complete" === sNew.readyState ) {
						sNew.onload();
					}
				};
			}
			var s0 = document.getElementsByTagName('script')[0];
			s0.parentNode.insertBefore(sNew, s0);
		},

		doJquery = function() {
			for ( var i=0; i < q.length; i++ ) {
					var cmd = q[i];
					doCommand(cmd);
			}
			q = undefined; // as a flat that future commands should be done immediately
		},

		addCommand = window["$"] = function(cmd) {
			if ( "undefined" === typeof(q) ) {
					doCommand(cmd);
			}
			else {
					q.push(cmd);
			}
		},

		doCommand = function(cmd) {
			if ( "function" === typeof(cmd) ) {
				$(cmd);
			}
		};
		
		addCommand.load = load;

}());