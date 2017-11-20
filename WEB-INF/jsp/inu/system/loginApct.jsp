<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta charset="utf-8">

<title>NCS기반 학사행정지원시스템 </title>
<link rel="stylesheet" type="text/css" href="/common/css/style.css" />

<link rel="stylesheet" type="text/css" href="/css/jquery-ui-1.10.3/jquery-ui-1.10.3.custom.css"/>

<script type="text/javaScript" src="<c:url value='/js/jquery/jquery-1.10.2.min.js'/>"></script>
<script type="text/javascript" src="/js/jquery-ui-1.10.3/jquery-ui-1.10.3.custom.min.js"></script>
<script type="text/javaScript" src="<c:url value='/js/jquery-ui-1.10.3/jquery-ui-i18n.js'/>"></script>
<script type="text/javaScript" src="<c:url value='/js/common.js'/>"></script>
<script type="text/javaScript" src="<c:url value='/js/jquery/jquery.popupWindow.js'/>"></script>
<script type="text/javaScript" src="<c:url value='/js/jquery/jquery.form.js'/>"></script>

<style>
	.login_wrap h1 {margin:0 0 20px 0px;}
	.login_box02 {
	  position:relative;
	  border:1px solid #ddd;
	  background:#fff;
	  padding:30px 0 25px 30px;
	  box-shadow: 0 3px 0 0 #dbdbdb;
	  -moz-box-shadow: 0 3px 0 0 #dbdbdb;
	  -webkit-box-shadow: 0 3px 0 0 #dbdbdb;
	  -webkit-border-radius: 5px 5px 5px 5px;
	  -moz-border-radius: 5px 5px 5px 5px;
	  border-radius: 5px 5px 5px 5px;
	}
	.login_box02 li{list-style:none;margin-bottom:10px;}
	.login_box02 li label{display:inline-block; width:70px;}
	.login_box02 input{height:23px;width:232px;padding-left:10px;}
	.login_box02 input.btn_login{border-radius:3px;border:1px solid #326795;background:#4d86b7;color:#fff;font-weight:bold;width:100px; height:60px;padding-left:0;}
	.login_box02 .login_btn02 {position:absolute; top:30px; left:360px;}

	.text_page{padding-top:15px;text-align:center;font-size:12px;line-height:18px;}
</style>

<script type="text/javaScript" language="javascript" defer="defer">

/* 로그인 function */
function fn_egov_login() {
	mberId = $('#id').val();
	password = $('#pwd').val();
	if(mberId == "" && password == ""){
		alert("<spring:message code="mbr.blankBoth" />");
		return;
	}else if(mberId != "" && password == ""){
		$('#pwd').focus()
		alert("<spring:message code="mbr.blankPass" />");
		return;
	}else if(password != "" && mberId == ""){
		$('#id').focus()
		alert("<spring:message code="mbr.blankId" />");
		return;
	}else if(mberId.indexOf('@')<0){
		alert('이메일 형식의 id를 입력하세요')
	}
	return;
   	$("#frm").attr("action", "/mng/login/process.do");
	$("#frm").submit();

}

$(document).ready(function() {
	$('#login').click(function(){fn_egov_login()}) ;
	if($('#login_error').val() == 1){
		alert("<spring:message code="mbr.loginFail" />");
	}else if($('#login_error').val() == 2){
		alert("<spring:message code="system.msg.deny" />");
	}
})
$(document).keydown(function( event ) {
	//console.log(event);
	if (event.keyCode == 13 && $('#id').val() != '' && $('#pwd').val() != '') {
		fn_egov_login()
	} 
});
</script>
</head>
<body style="background:none;background:#fafafa;">
<form name="frm" id="frm" method="post" >
<input type=hidden id=login_error value="<c:out value='${param.login_error}'/>" />
	<div id="dBody">
		<div class="login_wrap">
			<h1><img src="/images/login02_tit.png" /></h1>
			<div class="login_box02">
				<ul>
					<li><label>이메일</label><input type="text" name='id' id='id' class="span04" /></li>
					<li><label>비밀번호</label><input type="password" name='pwd' id='pwd' class="span04" /></li>
				</ul>
				<span class="login_btn02">
					<input type="button" id='login'class="btn_login" value="로그인" /> 
				</span>
				<div class="text_page">이메일과 비밀번호는 입력한 자료의 수정이 필요한 경우<br />사용되므로 반드시 기억해 주시기 바랍니다.</div>
			</div>

		</div>
	</div>
	
	</form>
</body>
</html>

