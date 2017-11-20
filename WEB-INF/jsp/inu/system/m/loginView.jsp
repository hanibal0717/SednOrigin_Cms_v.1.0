<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta charset="utf-8">

<title>한림성심대학교 출결관리시스템 </title>
<meta name="decorator" content="mPage">

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
	}
	
   	//document.detailForm.action = "<c:url value='/j_spring_security_check'/>";
   	//document.detailForm.action = "<c:url value='/mng/login/process.do'/>";
   	//document.detailForm.submit();		
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
<body >
	<div id="container_main">
<form name="frm" id="frm" method="post" >
<input type=hidden id=login_error value="<c:out value='${param.login_error}'/>" />

		<h1 class="logoh1"><img src="/images/m/logo_h1_2.png" alt="한림성심대학교 출결시스템"></h1>
		<ul class="login_sel">
			<li><input type="radio" name="gbn" value="1" checked/> &nbsp;출결관리</li>
			<li>&nbsp;&nbsp;&nbsp;<input type="radio" name="gbn" value="0"/> &nbsp;NCS</li>
		</ul>
		<div class="login_box">
			<dl>
				<dd>아이디</dd>
				<dt><input type="text" name='id' id='id' /></dt>
				<dd>비밀번호</dd>
				<dt><input type="password" name='pwd' id='pwd' /></dt>
			</dl>
			<span class="btn_login" id='login'>
				<a href="" class="prevent" >로그인</a>
			</span>
		</div>
	</form>
	</div>	


</body>
</html>

