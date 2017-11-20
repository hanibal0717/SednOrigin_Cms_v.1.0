(function($){ 		  
	$.fn.popupWindow = function(instanceSettings){
		$(this).unbind("click");

		return this.each(function(){
		
		$(this).click(function(){
		
		//$.fn.popupWindow.defaultSettings = {
		defaultSettings = {
			centerBrowser:0, // center window over browser window? {1 (YES) or 0 (NO)}. overrides top and left
			centerScreen:0, // center window over entire screen? {1 (YES) or 0 (NO)}. overrides top and left
			height:500, // sets the height in pixels of the window.
			left:0, // left position when the window appears.
			location:0, // determines whether the address bar is displayed {1 (YES) or 0 (NO)}.
			menubar:0, // determines whether the menu bar is displayed {1 (YES) or 0 (NO)}.
			resizable:1, // whether the window can be resized {1 (YES) or 0 (NO)}. Can also be overloaded using resizable.
			scrollbars:0, // determines whether scrollbars appear on the window {1 (YES) or 0 (NO)}.
			status:0, // whether a status line appears at the bottom of the window {1 (YES) or 0 (NO)}.
			width:500, // sets the width in pixels of the window.
			windowName:null, // name of window set from the name attribute of the element that invokes the click
			windowURL:null, // url used for the popup
			top:0, // top position when the window appears.
			toolbar:0 // determines whether a toolbar (includes the forward and back buttons) is displayed {1 (YES) or 0 (NO)}.
		};
		
		//oSets = $.extend(true, {}, $.fn.popupWindow.defaultSettings, instanceSettings || {});
		var o = $.extend(true, defaultSettings, instanceSettings );
		var oSets = JSON.parse(JSON.stringify(o));;
		var windowFeatures =    'height=' + oSets.height +
								',width=' + oSets.width +
								',toolbar=' + oSets.toolbar +
								',scrollbars=' + oSets.scrollbars +
								',status=' + oSets.status + 
								',resizable=' + oSets.resizable +
								',location=' + oSets.location +
								',menuBar=' + oSets.menubar;

				oSets.windowName = this.name || oSets.windowName;
				oSets.windowURL = this.href || oSets.windowURL;
				var centeredY,centeredX;
			
				if(oSets.centerBrowser){
						
					if ($.browser.msie) {//hacked together for IE browsers
						centeredY = (window.screenTop - 120) + ((((document.documentElement.clientHeight + 120)/2) - (oSets.height/2)));
						centeredX = window.screenLeft + ((((document.body.offsetWidth + 20)/2) - (oSets.width/2)));
					}else{
						centeredY = window.screenY + (((window.outerHeight/2) - (oSets.height/2)));
						centeredX = window.screenX + (((window.outerWidth/2) - (oSets.width/2)));
					}
					window.open(oSets.windowURL, oSets.windowName, windowFeatures+',left=' + centeredX +',top=' + centeredY).focus();
				}else if(oSets.centerScreen){
					centeredY = (screen.height - oSets.height)/2;
					centeredX = (screen.width - oSets.width)/2;
					window.open(oSets.windowURL, oSets.windowName, windowFeatures+',left=' + centeredX +',top=' + centeredY).focus();
				}else{
					window.open(oSets.windowURL, oSets.windowName, windowFeatures+',left=' + oSets.left +',top=' + oSets.top)//.focus();	
				}
				return false;
			});
			
		});	
	};
})(jQuery);

function clone(obj) {
    if (null == obj || "object" != typeof obj) return obj;
    var copy = {};
    for (var attr in obj) {
        if (obj.hasOwnProperty(attr)) copy[attr] = obj[attr];
    }
    return copy;
}
