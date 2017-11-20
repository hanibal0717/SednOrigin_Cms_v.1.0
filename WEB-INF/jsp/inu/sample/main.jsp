<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%

response.setHeader("cache-control","no-store");

response.setHeader("expires","Mon 26 Jul 1997 05:00:00 GMT");

response.setHeader("pragma","no-cache");

%>
<%
    /**
			 * @JSP Name : EgovMain.jsp
			 * @Description : 메인 화면
			 * @Modification Information
			 * 
			 *   수정일         수정자                   수정내용
			 *  -------    --------    ---------------------------
			 *  2011.06.07  신혜연          최초 생성
			 *
			 * author 실행환경팀 
			 * Copyright (C) 2011 by MOPAS  All right reserved.
			 */
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">
<meta http-equiv="Cache-Control" content="no-cache"/> 
<meta http-equiv="Expires" content="0"/> 
<meta http-equiv="Pragma" content="no-cache"/> 

<script type="text/javaScript" language="javascript">
	$(document).ready(function() {
		//$('#tabs').tabs();
		ajaxCall('Restful');
		$("#tabs").bind('tabsselect', function(event, ui) {
			ajaxCall(ui.tab.innerHTML);
		});
		$('#test').click(function(){
			alert(1111);
		});

		var options = { 
			target: '#output',   // target element(s) to be updated with server response 
			beforeSubmit: beforeSubmit,  // pre-submit callback 
			success: afterSuccess,  // post-submit callback 
			resetForm: true        // reset the form after successful submit 
		}; 
		
	 $('#MyUploadForm').submit(function() { 
			$(this).ajaxSubmit(options);  			
			// always return false to prevent standard browser submit and page navigation 
			return false; 
		}); 
	
	});
	
	function ajaxCall(tabName) {
		$.ajax({
			url : '/com/ajax.do',
			data : "tabName=" + tabName,
			dataType : 'json',
			success : function(data) {
				$(data.divId).html(data.description);
			}
		});
	}
	
function afterSuccess()
{
	$('#submit-btn').show(); //hide submit button
	$('#loading-img').hide(); //hide submit button

}

//function to check file size before uploading.
function beforeSubmit(){
    //check whether browser fully supports all File API
   if (window.File && window.FileReader && window.FileList && window.Blob)
	{
		
		if( !$('#imageInput').val()) //check empty input filed
		{
			$("#output").html("Are you kidding me?");
			return false
		}
		
		var fsize = $('#imageInput')[0].files[0].size; //get file size
		var ftype = $('#imageInput')[0].files[0].type; // get file type
		

		//allow only valid image file types 
		switch(ftype)
        {
            case 'image/png': case 'image/gif': case 'image/jpeg': case 'image/pjpeg':
                break;
            default:
                $("#output").html("<b>"+ftype+"</b> Unsupported file type!");
				return false
        }
		
		//Allowed file size is less than 1 MB (1048576)
		if(fsize>1048576) 
		{
			$("#output").html("<b>"+bytesToSize(fsize) +"</b> Too big Image file! <br />Please reduce the size of your photo using an image editor.");
			return false
		}
				
		$('#submit-btn').hide(); //hide submit button
		$('#loading-img').show(); //hide submit button
		$("#output").html("");  
	}
	else
	{
		//Output error to older browsers that do not support HTML5 File API
		$("#output").html("Please upgrade your browser, because your current browser lacks some new features we need!");
		return false;
	}
}

//function to format bites bit.ly/19yoIPO
function bytesToSize(bytes) {
   var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
   if (bytes == 0) return '0 Bytes';
   var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
   return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
}
function PreviewImage(no) {
            var oFReader = new FileReader();
            oFReader.readAsDataURL(document.getElementById("uploadImage"+no).files[0]);
            oFReader.onload = function (oFREvent) {
                document.getElementById("uploadPreview"+no).src = oFREvent.target.result;
            };
        };
</script>
</head>
<body>
<form id='frm' method="post">
<!--  
<input type='text' name='test' value='<script>url="http://localhost:8080/js/test.js"</script>'/>
-->
<input type='text' name='test' value='<iframe src="http://localhost:8080/com/egovMain.do"</iframe>'/>
<input type='submit' value="send"/>
</form>
	<!-- content 시작 -->
	<div id="content_pop">
		<spring:message code="main.title" />
		<div id="tabs">
			<ul>
				<li><a href="#tabs-1">Restful</a></li>
				<li><a href="#tabs-2">ORM</a></li>
				<li><a href="#tabs-3">Excel</a></li>
				<li><a href="#tabs-4">OXM</a></li>
			</ul>
			<div id="tabs-1" class="Restful" style="height: 250px;"></div>
			<div id="tabs-2" class="ORM" style="height: 250px;"></div>
			<div id="tabs-3" class="Excel" style="height: 250px;"></div>
			<div id="tabs-4" class="OXM" style="height: 250px;"></div>
		</div>
	</div>
	<ul>
		<li><a href="javascript:alert(1);" id="test">Restful</a></li>
		<li><a href="#">ORM</a></li>
		<li><a href="#">Excel</a></li>
		<li><a href="#">OXM</a></li>
	</ul>
	<div id="postcodify"></div>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<script src="//cdn.poesis.kr/post/popup.min.js"></script>
<script type="text/javascript">
    $(function() { $("#postcodify_search_button").postcodifyPopUp(); });     
</script>
<!-- 주소와 우편번호를 입력할 <input>들을 생성하고 적당한 name과 class를 부여한다 -->
<input type="text" name="" class="postcodify_postcode6_1" value="" /> &ndash;
<input type="text" name="" class="postcodify_postcode6_2" value="" />
<button id="postcodify_search_button">검색</button><br />
<input type="text" name="" class="postcodify_address" value="" /><br />
<input type="text" name="" class="postcodify_details" value="" /><br />
<input type="text" name="" class="postcodify_extra_info" value="" /><br />
	<!-- //content 끝-->
	<c:out value="${param.test}"/>
	${fneparam}
	${param}

<div id="upload-wrapper">
<div align="center">
<h3>Ajax Image Uploader</h3>
<form action="processupload.php" method="post" enctype="multipart/form-data" id="MyUploadForm">
<input name="image_file" id="imageInput" type="file" />
<input type="submit"  id="submit-btn" value="Upload" />
<img src="images/ajax-loader.gif" id="loading-img" style="display:none;" alt="Please Wait"/>
</form>
<div id="output"></div>
<img id="uploadPreview1" src="http://i111.photobucket.com/albums/n153/terrapins_sky/plantonic/no_image_zpsa9af9c43.gif" width="100" /><br />
<input id="uploadImage1" type="file" name="p1" onchange="PreviewImage(1);" />
</div>
</div>
</body>
</html>

