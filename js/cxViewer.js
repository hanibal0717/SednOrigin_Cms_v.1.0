		var _os  = navigator.userAgent;  
		var _app = navigator.appName;

		var serverURL           = "http://203.249.125.81:9000";		
		var rdagentURL          = serverURL + "/DataServer/rdagent.jsp";
		var rdagent             = serverURL + "/DataServer/rdagent.jsp";
		var path_ActiveX        = serverURL + "/DataServer/cxViewer/activex";
		var path_Plugin         = serverURL + "/DataServer/cxViewer/plugin";
		var path_multiViewer    = serverURL + "/DataServer/cxViewer/applet";		
		var path_multiViewerLib = path_multiViewer + "lib/";

		//var jars = path_multiViewer + "javard.jar";
		
		

		var jars = path_multiViewer + "javard.jar," + path_multiViewerLib + "barbecue-1.5-beta1.jar," + path_multiViewerLib + "barcode4j.jar," + path_multiViewerLib + "batik-all-flex.jar,"+ path_multiViewerLib + "ChartDirector_s.jar," + path_multiViewerLib + "iText-4.2.0-m2.jar,"+ path_multiViewerLib + "jai_codec.jar," + path_multiViewerLib + "poi-3.2-FINAL-20081019.jar," + path_multiViewerLib + "poi-scratchpad-3.2-FINAL-20081019.jar," + path_multiViewerLib + "swfutils.jar";

		
		if(_os.indexOf("Linux") != -1 || _os.indexOf("Macintosh") != -1 ) {  
			

		alert("not Windows");

					document.write('<OBJECT id="Rdviewer" type="application/x-java-applet" style="position: absolute; width:100%; height:100%;"> ');
					document.write('	<param name="code"     value="m2soft.javard.gui.RDApplet" > ');
					document.write('	<param name="codebase" value= '+path_multiViewer+'"/javard.jar" > ');
					document.write('	<param name="archive"  value="'+ jars + '" > ');
					document.write('	<param name="Java_archive" value="'+ jars + '" /> ');
					document.write('	<param name="separate_jvm" value="true" /> ');
					document.write('	<param name="mrd.charset" value="UTF-16LE" /> '); // UTF-16LE or MS949
					document.write('	<param name="txt.charset" value="UTF-16LE" /> '); // UTF-16LE or MS949
					document.write('	<param name="java_arguments" value="-Xmx1000m" /> ');
					document.write('	Your browser needs <a href="http://java.com/en/download/help/enable_browser.xml">Java enabled</a> to view projects.');
					document.write('</OBJECT>');



		} else {
			if (_os.indexOf("MSIE") != -1 || _os.indexOf("Trident") != -1)  
			//if (_app == "Microsoft Internet Explorer") 
				{
					//alert("32bit");
					document.write('<OBJECT id="Rdviewer" classid="clsid:DF793F07-89E0-4a63-A56B-D06A3C836127"');
					document.write('  codebase="' + path_ActiveX + '/cab/cxviewer60.cab#version=6,3,2,192"');
					document.write('  name="cxViewer" width=100% height=100%>  ');
					document.write('  <PARAM NAME="WinTrust_RevocationCheck" VALUE="FALSE"> ');
					document.write('</OBJECT>');					
				} else {

					navigator.plugins.refresh(false);
					
					if(navigator.mimeTypes["application/x-cxviewer60"]) {

						var _cxPlugin = navigator.mimeTypes["application/x-cxviewer60"];
						var cxPluginVersion_installed = _cxPlugin.description.substr(_cxPlugin.description.indexOf("version=")+8, 9);

						var cxPluginVersion_setup = "6,3,2,192";
						
						if(checkPluginVersion(cxPluginVersion_installed, cxPluginVersion_setup)) {
							document.write('<OBJECT id="Rdviewer" type="application/x-cxviewer60" width=100% height=100%></OBJECT>');
						} else {
							window.location = path_plugin+"/cxPluginInstall.htm";
						}
					} else {
						window.location = path_plugin+"/cxPluginInstall.htm";
					}
			}
		}

		function checkPluginVersion(versionInstalled, versionSetup) {

			var arr_versionInstalled = versionInstalled.split(",");
			var arr_versionSetup = versionSetup.split(",");
			
			for(i=0; i<=3; i++) {

				if(Number(arr_versionInstalled[i]) > Number(arr_versionSetup[i])) {  // do not install
					return 1;
					break;
				} else if(Number(arr_versionInstalled[i]) < Number(arr_versionSetup[i])) { // install
					return 0;
					break;
				}
			}
			return 1;
		}