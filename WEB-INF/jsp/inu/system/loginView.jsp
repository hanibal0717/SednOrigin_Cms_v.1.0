<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<!--[if IE 9 ]><html class="ie9"><![endif]-->
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
        <meta name="format-detection" content="telephone=no">
        <meta charset="UTF-8">
        <title>SEDN ORGIN v1.0</title>
            
        <!-- CSS -->
        <link href="/common/css/bootstrap.min.css" rel="stylesheet">
        <link href="/common/css/form.css" rel="stylesheet">
        <link href="/common/css/style.css" rel="stylesheet">
        <link href="/common/css/animate.css" rel="stylesheet">
        <link href="/common/css/generics.css" rel="stylesheet"> 
    </head>
    <body id="skin-blur-violate">
        <section id="login">
            <header>
                <h1><b>SEDN ORGIN v1.0</b></h1>
                <p></p>
            </header>
        
            <div class="clearfix"></div>
            
            <!-- Login -->
            <form name="frm" id="frm" method="post" class="box tile animated active">
            
				<input type=hidden id=login_error value="<c:out value='${param.login_error}'/>" />
                <h2 class="m-t-0 m-b-15">Login</h2>
                <input type="text" name="id" id="id" class="login-control m-b-10" placeholder="관리자 아이디">
                <input type="password" name="pwd" id="pwd" class="login-control" placeholder="비밀번호">
                
                <button class="btn btn-sm m-r-5 m-t-10" id="btLogin">확인</button>
                
            </form>
        </section>                      
        
        <!-- Javascript Libraries -->
        <!-- jQuery -->
        <script src="/common/js/jquery.min.js"></script> <!-- jQuery Library -->
        
        <!-- Bootstrap -->
        <script src="/common/js/bootstrap.min.js"></script>
        
        <!--  Form Related -->
        <script src="/common/js/icheck.js"></script> <!-- Custom Checkbox + Radio -->
        
        <!-- All JS functions -->
        <script src="/common/js/functions.js"></script>
		<script>
		
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
			$('#id').focus();
			
			$('#btLogin').click(function(){fn_egov_login()}) ;
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
    </body>
</html>