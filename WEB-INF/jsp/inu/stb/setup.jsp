<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="vcms.common.file.util.UvFileUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>

<%
Map<String , Object> stbConfig = (Map)request.getAttribute("stbConfiguration");
String logoImgUrl = "";
String logoText = "";
if(stbConfig.get("logoImgYN").equals("Y")) {
	logoImgUrl = (String)stbConfig.get("logoImgUrl");
} else {
	logoText = (String)stbConfig.get("logoText");
}
String bgImgUrl = "";
String bgVideoUrl = "";
if(stbConfig.get("bgImgYN").equals("Y")) {
	bgImgUrl = (String)stbConfig.get("bgImgUrl");
} else {
	bgVideoUrl = (String)stbConfig.get("bgVideoUrl");
}

String syncTime = (String)stbConfig.get("autoSyncTime");
if(syncTime == null || syncTime.isEmpty()) {
	syncTime = "none";
}

String firmware_version = "미등록";
String firmware_modify_dt = "미등록";
if(stbConfig.get("firmwareVersion") != null) {
	firmware_version = (String)stbConfig.get("firmwareVersion");
	firmware_modify_dt = (String)stbConfig.get("firmwareModifyDT");
}

String banner1ImgUrl = (String)stbConfig.get("banner1ImgUrl");
String banner2ImgUrl = (String)stbConfig.get("banner2ImgUrl");

String USER_AGENT = StringUtil.nvl(request.getAttribute("USER_AGENT"),"");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="decorator" content="defaultPage">

<%if (!USER_AGENT.equals("Internet Explorer 8")) {%>
<link id='uploadify_css' rel='stylesheet' type='text/css' href='/common/uploadify/uploadify_step.css'>
<script src='/common/uploadify/jquery.uploadify.js'></script>
<script type="text/javascript" src="/common/jwplayer/jwplayer.js"></script>
<script>jwplayer.key="i4sty1oKVhqrdI0BQFRnsqtqOustH4AXbW/K0HOjHfU=";</script>
<%}%>

<script>
$(document).ready(function() {
	$('#logo_upload').uploadify({
		'swf' : '/common/uploadify/uploadify.swf',
		'uploader' : '/file/upload.do',
		'buttonImage' : '/common/uploadify/images/bt_addfile_s.jpg',
		'width' : 70,
		'height' : 20, 
		'multi': false,
		'fileTypeExts' : '*.png',
		'fileSizeLimit' : '100MB',
		'formData' : {'FILE_GUBUN': 'STB_LOGO'},
		'onUploadError' : function(file, errorCode, errorMsg, errorString) {
			alert(file.name + ' 업로드가 불가능 합니다. \n불가사유\n' + errorString);
		},
		'onUploadSuccess' : function(file, data, response) {
			//data = eval( "("+ data.replace(/^[ /\n/\r]/g,"") + ")" );
			data = eval( "("+ data + ")" );
			console.log(data);
			
			$.ajax({
				url: '/stb/updateConfiguration.do',
		        type: 'post',
		        data: {'logo_img_yn':'Y', 'logo_img_path':data.FILE_PATH},
		        success:function(result){	
		        	var file_url = data.FILE_PATH.substring(data.FILE_PATH.indexOf('/UPLOAD/'));
		        	console.log(file_url);
		        	$("#stbLogoImg").attr('src', file_url);
		        	$("#logoText").val("");
		        	$("#noLogo").show();
		        	alert("로고 이미지가 설정되었습니다.");
		        }
			});	
		}
	});
	
	$('#bg_video_upload').uploadify({
		'swf' : '/common/uploadify/uploadify.swf',
		'uploader' : '/file/upload.do',
		'buttonImage' : '/common/uploadify/images/bt_addfile_s.jpg',
		'width' : 70,
		'height' : 20, 
		'multi': false,
		'fileTypeExts' : '*.wmv; *.mp4; *.avi',
		'fileSizeLimit' : '10000MB',
		'formData' : {'FILE_GUBUN': 'STB_BG'},
		'onUploadError' : function(file, errorCode, errorMsg, errorString) {
			alert(file.name + ' 업로드가 불가능 합니다. \n불가사유\n' + errorString);
		},
		'onUploadSuccess' : function(file, data, response) {
			//data = eval( "("+ data.replace(/^[ /\n/\r]/g,"") + ")" );
			data = eval( "("+ data + ")" );
			console.log(data);
			
			$.ajax({
				url: '/stb/updateConfiguration.do',
		        type: 'post',
		        data: {'bg_img_yn':'N', 'bg_video_path':data.FILE_PATH},
		        success:function(result){	
			        	alert("배경 동영상이 설정되었습니다.");
			        	location.reload();
		        }
			});	
		}
	});
	
	$('#bg_image_upload').uploadify({
		'swf' : '/common/uploadify/uploadify.swf',
		'uploader' : '/file/upload.do',
		'buttonImage' : '/common/uploadify/images/bt_addfile_s.jpg',
		'width' : 70,
		'height' : 20, 
		'multi': false,
		'fileTypeExts' : '*.png; *.jpg',
		'fileSizeLimit' : '100MB',
		'formData' : {'FILE_GUBUN': 'STB_BG'},
		'onUploadError' : function(file, errorCode, errorMsg, errorString) {
			alert(file.name + ' 업로드가 불가능 합니다. \n불가사유\n' + errorString);
		},
		'onUploadSuccess' : function(file, data, response) {
			//data = eval( "("+ data.replace(/^[ /\n/\r]/g,"") + ")" );
			data = eval( "("+ data + ")" );
			console.log(data);
			
			$.ajax({
				url: '/stb/updateConfiguration.do',
		        type: 'post',
		        data: {'bg_img_yn':'Y', 'bg_img_path':data.FILE_PATH},
		        success:function(result){	
			        	var file_url = data.FILE_PATH.substring(data.FILE_PATH.indexOf('/UPLOAD/'));
			        	console.log(file_url);
			        	$("#stbBGImg").attr('src', file_url);
			        	alert("배경 이미지가 설정되었습니다.");
			        	location.reload();
		        }
			});	
		}
	});
	
	$('#bg_video_upload').uploadify({
		'swf' : '/common/uploadify/uploadify.swf',
		'uploader' : '/file/upload.do',
		'buttonImage' : '/common/uploadify/images/bt_addfile_s.jpg',
		'width' : 70,
		'height' : 20, 
		'multi': false,
		'fileTypeExts' : '*.wmv; *.mp4; *.avi',
		'fileSizeLimit' : '10000MB',
		'formData' : {'FILE_GUBUN': 'STB_BG'},
		'onUploadError' : function(file, errorCode, errorMsg, errorString) {
			alert(file.name + ' 업로드가 불가능 합니다. \n불가사유\n' + errorString);
		},
		'onUploadSuccess' : function(file, data, response) {
			//data = eval( "("+ data.replace(/^[ /\n/\r]/g,"") + ")" );
			data = eval( "("+ data + ")" );
			console.log(data);
			
			$.ajax({
				url: '/stb/updateConfiguration.do',
		        type: 'post',
		        data: {'bg_img_yn':'N', 'bg_video_path':data.FILE_PATH},
		        success:function(result){	
			        	alert("배경 동영상이 설정되었습니다.");
			        	location.reload();
		        }
			});	
		}
	});
	
	$('#firmware_upload').uploadify({
		'swf' : '/common/uploadify/uploadify.swf',
		'uploader' : '/file/upload.do',
		'buttonImage' : '/common/uploadify/images/bt_addfile_s.jpg',
		'width' : 70,
		'height' : 20, 
		'multi': false,
		'fileTypeExts' : '*.apk',
		'fileSizeLimit' : '1000MB',
		'formData' : {'FILE_GUBUN': 'STB_APK'},
		'onUploadError' : function(file, errorCode, errorMsg, errorString) {
			alert(file.name + ' 업로드가 불가능 합니다. \n불가사유\n' + errorString);
		},
		'onUploadSuccess' : function(file, data, response) {
			//data = eval( "("+ data.replace(/^[ /\n/\r]/g,"") + ")" );
			data = eval( "("+ data + ")" );
			console.log(data);
			
			var firmware_version = "";
			var build_time = "";
			$.ajax({
				url: '/stb/firmwareVersion.do',
		        type: 'post',
		        data: {'file_path':data.FILE_PATH},
		        async: false,
		        success:function(result){	
		        	firmware_version = result.version;
		        	build_time = result.build_time;
		        },
		        error: function() {
		            alert('펌웨어 버전 확인 실패!');
		        }
			});
			
			if(firmware_version == "") return;
			
			if(confirm("새로운 펌웨어를 등록하시겠습니까?\n\n펌웨어 버전 : " + firmware_version + "\n\n펌웨어 빌드 날짜: " + build_time)) {
				$.ajax({
					url: '/stb/updateConfiguration.do',
			        type: 'post',
			        data: {'firmware_version':firmware_version, 'firmware_path':data.FILE_PATH, 'firmware_modify_dt':build_time},
			        success:function(result){	
			        	alert("펌웨어가 업로드되었습니다.");
			        	location.reload();
			        }
				});	
				
			} else {
				$.ajax({
					url: '/stb/deleteTempFile.do',
			        type: 'post',
			        data: {'file_path':data.FILE_PATH},
			        success:function(result){	
			        	alert("펌웨어 업로드가 취소되었습니다.");
			        },
			        error: function() {
			            alert('펌웨어 업로드 취소 오류!(임시파일 삭제 실패)');
			        }
				});	
			}
		}
	});
	
	$("#logoText").on("focus", function() {
		//console.log("focused");
		//$(this).val("");
		$("#noLogo").hide();
	})
	.on("blur", function() {
		if($(this).val()=="") $("#noLogo").show();;
	});
	$("#noLogo").click(function () {
		$("#logoText").focus();	
	});
	
	$("#logoTextButton").click(function() {
		var logo_text = $("#logoText").val();
		if(logo_text == "") {
			alert("텍스트를 입력해 주세요.");
			$("#logoText").focus();
		} else if(logo_text.length > 15) {
			alert("15자 이하로 입력해 주세요.");
			$("#logoText").focus();
		} else {
			$.ajax({
				url: '/stb/updateConfiguration.do',
		        type: 'post',
		        data: {'logo_img_yn':'N', 'logo_text':logo_text},
		        success:function(result){
		        	$("#stbLogoImg").attr('src', '');
		        	alert("로고 텍스트가 설정되었습니다.");
		        }
			});	
		}
	});
	
	$("#streamingURLButton").click(function () {
		var streamingURL = $("#streamingURL").val();
		if(streamingURL != "") {
			$.ajax({
				url: '/stb/updateConfiguration.do',
		        type: 'post',
		        data: {'streaming_server_url':streamingURL},
		        success:function(result){
		        	alert("스트리밍 서버 IP가 설정되었습니다.");
		        }
			});	
		}	
	});

	$("#syncTime").val("<%=syncTime%>");
	$("#syncTimeButton").click(function () {
		var syncTime = $("#syncTime").val();
		console.log(syncTime);
		$.ajax({
			url: '/stb/updateConfiguration.do',
	        type: 'post',
	        data: {'auto_sync_time':syncTime},
	        success:function(result){
	        	alert("동기화 시작 시간이 설정되었습니다.");
	        }
		});	
	});
	
	$('#banner1_upload').uploadify({
		'swf' : '/common/uploadify/uploadify.swf',
		'uploader' : '/file/upload.do',
		'buttonImage' : '/common/uploadify/images/bt_addfile_s.jpg',
		'width' : 70,
		'height' : 20, 
		'multi': false,
		'fileTypeExts' : '*.png',
		'fileSizeLimit' : '100MB',
		'formData' : {'FILE_GUBUN': 'STB_BANNER'},
		'onUploadError' : function(file, errorCode, errorMsg, errorString) {
			alert(file.name + ' 업로드가 불가능 합니다. \n불가사유\n' + errorString);
		},
		'onUploadSuccess' : function(file, data, response) {
			//data = eval( "("+ data.replace(/^[ /\n/\r]/g,"") + ")" );
			data = eval( "("+ data + ")" );
			console.log(data);
			
			$.ajax({
				url: '/stb/updateConfiguration.do',
		        type: 'post',
		        data: {'banner1_img_path':data.FILE_PATH},
		        success:function(result){	
		        	var file_url = data.FILE_PATH.substring(data.FILE_PATH.indexOf('/UPLOAD/'));
		        	console.log(file_url);
		        	$("#stbBanner1Img").attr('src', file_url);
		        	alert("배너 이미지가 설정되었습니다.");
		        }
			});	
		}
	});
	$('#banner2_upload').uploadify({
		'swf' : '/common/uploadify/uploadify.swf',
		'uploader' : '/file/upload.do',
		'buttonImage' : '/common/uploadify/images/bt_addfile_s.jpg',
		'width' : 70,
		'height' : 20, 
		'multi': false,
		'fileTypeExts' : '*.png',
		'fileSizeLimit' : '100MB',
		'formData' : {'FILE_GUBUN': 'STB_BANNER'},
		'onUploadError' : function(file, errorCode, errorMsg, errorString) {
			alert(file.name + ' 업로드가 불가능 합니다. \n불가사유\n' + errorString);
		},
		'onUploadSuccess' : function(file, data, response) {
			//data = eval( "("+ data.replace(/^[ /\n/\r]/g,"") + ")" );
			data = eval( "("+ data + ")" );
			console.log(data);
			
			$.ajax({
				url: '/stb/updateConfiguration.do',
		        type: 'post',
		        data: {'banner2_img_path':data.FILE_PATH},
		        success:function(result){	
		        	var file_url = data.FILE_PATH.substring(data.FILE_PATH.indexOf('/UPLOAD/'));
		        	console.log(file_url);
		        	$("#stbBanner2Img").attr('src', file_url);
		        	alert("배너 이미지가 설정되었습니다.");
		        }
			});	
		}
	});
});

</script>
</head>
<body>

<ol class="breadcrumb hidden-xs">
    <li>STB 설정</li>
</ol>
<h4 class="page-title">STB 설정</h4>
<div class="block-area">
	<div class="col-md-6">
		<div class="tile">
			<h2 class="tile-title">로고 설정<span class="title_desc m-l-10">※ 로고 이미지와 텍스트를 동시에 사용할 수 없습니다.</span></h2>
			 <form role="form" class="p-15">
			 	<div class="form-group">
					<i class="fa fa-dot-circle-o"></i>
					<label class="">로고 이미지 설정</label>
				</div>
				<div class="form-group">
					<img id="stbLogoImg" src="<%=logoImgUrl%>" alt="이미지가 설정되어 있지 않습니다."/>
				</div>
				
				<div class="form-group">
					<p class="m-t-10">1)로고 사이즈는 높이 80픽셀을 권장합니다.</p>
					<p>2)파일 확장자는 png만 가능합니다. 예)logo.png</p>
				</div>
				<div class="form-group">
					<input type="file" class="form-control input-sm" name="logo_upload" id="logo_upload"/>
				</div>
				<div class="form-group m-t-15">
					<i class="fa fa-dot-circle-o"></i>
					<label class="">로고 텍스트 설정</label>
				</div>
				<div class="form-group m-b-20">
					<input class="form-control input-sm" name="logoText" id="logoText" value="<%=logoText%>" placeholder="텍스트가 설정되어 있지 않습니다."/>
				</div>
				<div class="form-group m-t-5">
					<div class="col-md-12 text-right">
						<button class="btn-sm btn" id="logoTextButton">확 인</button>
					</div>
				</div>
				<div class="form-group m-t-20">
					<p class="m-t-10">1)로고 이미지가 없을 경우, 텍스트로 직접 입력합니다.</p>
					<p>2)글자 수 '14자 이내'로 입력 가능합니다.</p>
				</div>
			</form>
		</div>
	</div>

	<div class="col-md-6">
		<div class="tile">
			<h2 class="tile-title">백그라운드 설정<span class="title_desc m-l-10">※ 영상과 이미지를 동시에 사용할 수 없습니다.</span></h2>
			 <div class="p-15">
			 	<div class="form-group">
					<i class="fa fa-dot-circle-o"></i>
					<label>영상 설정</label>
				</div>
				<div class="form-group">
					<% if( !bgVideoUrl.isEmpty() ) {%>
					<% if (!USER_AGENT.equals("Internet Explorer 8")) {%>
					<div name="VOD_ELEMENT" id="VOD_ELEMENT">Loading the player...</div>
					<script type="text/javascript">
					jwplayer("VOD_ELEMENT").setup({
						file: "<%=bgVideoUrl%>",
						width: 290,
                        height: 165
				    });
					</script>
					<% } else {%>
						"<%=USER_AGENT%>" 은 Player가 지원 되는 브라우저가 아닙니다.
					<% } %>
				<% } else { %>
					<p>영상이 설정되어 있지 않습니다.</p>
				<% } %>
				</div>
				<div class="form-group">
					<p>※영상사이즈 가로 1920px,세로 1080px를 권장합니다.</p>
				</div>
				<div class="form-group">
					<input class="form-control input-sm" type="file" name="bg_video_upload" id="bg_video_upload"/>
				</div>
				<div class="form-group m-t-15">
					<i class="fa fa-dot-circle-o"></i>
					<label>이미지 설정</label>
				</div>
				<img id="stbBGImg" src="<%=bgImgUrl%>" alt="이미지가 설정되어 있지 않습니다."/>
				<p>※이미지사이즈 가로 1920px,세로 1080px를 권장합니다.</p>
				<div class="form-group">
					<input class="form-control input-sm" type="file" name="bg_image_upload" id="bg_image_upload"/>
				</div>
			</div>
		</div>
	</div>
	<div class="clearfix"></div>
	<div class="col-md-6">
		<div class="tile">
			<h2 class="tile-title">동기화 시간 설정</h2>
			 <div class="p-15">
			 	<div class="form-group">
				 	<i class="fa fa-dot-circle-o"></i>
					<label>시작 시간</label>
			 	</div>
			 	<div class="form-group">
			 		<select class="select" id="syncTime">
						<option selected="selected" value="none">미설정</option>
						<% for(int i=0; i<24; i++) { 
						String hour = String.format("%02d", i);%>
						<option value="<%=hour%>:00"><%=hour%>:00</option>
						<option value="<%=hour%>:30"><%=hour%>:30</option>
						<% } %>
					</select>
			 	</div>
			 	<div class="form-group m-b-25">
			 		<div class="col-md-12 text-right">
			 			<button class="btn-sm btn" style="width:50px" id="syncTimeButton">설 정</button>
			 		</div>
			 	</div>
			 </div>
		</div>
	</div>
	
	<div class="col-md-6">
		<div class="tile">
			<h2 class="tile-title">스트리밍 서버 설정</h2>
			 <div class="p-15">
			 	<div class="form-group">
			 		<i class="fa fa-dot-circle-o"></i>
					<label>서버 IP</label>
			 	</div>
			 	<div class="form-group">
			 		<input class="form-control input-sm" name="streamingURL" id="streamingURL" value="<%=stbConfig.get("streamingServerUrl")%>">
			 	</div>
			 	<div class="form-group m-b-25">
			 		<div class="col-md-12 text-right">
			 			<button class="btn-sm btn" style="width:50px" id="streamingURLButton">설 정</button>
			 		</div>
			 	</div>
			 </div>
		</div>
	</div>
	
	<div class="col-md-6">
		<div class="tile">
			<h2 class="tile-title">펌웨어 업로드</h2>
			 <div class="p-15">
			 	<div class="form-group">
				 	<i class="fa fa-dot-circle-o"></i>
					<label>펌웨어 정보</label>
			 	</div>
			 	<div class="form-group">
			 		<p>펌웨어 버전: <%=firmware_version%></p>
					<p>최종 등록일: <%=firmware_modify_dt%></p>
			 	</div>
			 	<div class="form-group">
			 		<input type="file" class="form-control input-sm" name="firmware_upload" id="firmware_upload"/>
			 	</div>
			 </div>
		</div>
	</div>
	
	<div class="col-md-6">
		<div class="tile">
			<h2 class="tile-title">배너 이미지 설정</h2>
			 <div class="p-15">
			 	<div class="form-group">
				 	<i class="fa fa-dot-circle-o"></i>
					<label>상단 배너</label>
			 	</div>
			 	<div class="form-group">
			 		<img id="stbBanner1Img" src="<%=banner1ImgUrl%>" alt="이미지가 설정되어 있지 않습니다."/>
			 	</div>
			 	<div class="form-group">
					<p>1)배너 사이즈는 520 x 153로 자동으로 조정됩니다.</p>
					<p>2)파일 확장자는 png만 가능합니다. 예)logo.png</p>
				</div>
				<div class="form-group">
					<input class="form-control input-sm" type="file" name="logo_upload" id="banner1_upload"/>
			 	</div>
			 	<div class="form-group m-t-15">
				 	<i class="fa fa-dot-circle-o"></i>
					<label>하단 배너</label>
			 	</div>
			 	<div class="form-group">
			 		<img id="stbBanner2Img" src="<%=banner2ImgUrl%>" alt="이미지가 설정되어 있지 않습니다."/>
			 	</div>
			 	<div class="form-group">
					<p>1)배너 사이즈는 520 x 238로 자동으로 조정됩니다.</p>
					<p>2)파일 확장자는 png만 가능합니다. 예)logo.png</p>
				</div>
			 	<div class="form-group">
					<input class="form-control input-sm" type="file" name="logo_upload" id="banner2_upload"/>
			 	</div>
			 </div>
		</div>
	</div>
	
</div>
</body>
</html>