<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<!--[if IE 9 ]><html class="ie9"><![endif]-->
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
        <meta name="format-detection" content="telephone=no">
        <meta charset="UTF-8">
        <title>SEDN ORGIN v1.0</title>
        <!-- CSS -->
        <link href="/common/css/bootstrap.min.css" rel="stylesheet">
        <link href="/common/css/animate.min.css" rel="stylesheet">
        <link href="/common/css/font-awesome.min.css" rel="stylesheet">
        <link href="/common/css/form.css" rel="stylesheet">
        <link href="/common/css/calendar.css" rel="stylesheet">
        <link href="/common/css/style.css" rel="stylesheet">
        <link href="/common/css/icons.css" rel="stylesheet">
        <link href="/common/css/generics.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="/css/jquery-ui-1.10.3/jquery-ui-1.10.3.custom.css"/>
        
        <script type="text/javaScript" src="<c:url value='/js/jquery/jquery-1.10.2.min.js'/>"></script>
		<script type="text/javascript" src="/js/jquery-ui-1.10.3/jquery-ui-1.10.3.custom.min.js"></script>
		<script type="text/javaScript" src="<c:url value='/js/jquery/jquery-ui.js'/>"></script>
		<script type="text/javaScript" src="<c:url value='/js/jquery-ui-1.10.3/jquery-ui-i18n.js'/>"></script>
		<script type="text/javaScript" src="<c:url value='/js/common.js'/>"></script>
		<script type="text/javaScript" src="<c:url value='/js/jquery/jquery.popupWindow.js'/>"></script>
		<script type="text/javaScript" src="<c:url value='/js/jquery/jquery.form.js'/>"></script>
		<script type="text/javaScript" src="/common/js/calendar.min.js"></script> <!-- Calendar -->
		<script type="text/javascript" src="/common/js/front_js.js"></script>
		
		<decorator:head />
         
    </head>
    <body id="skin-blur-violate">

	<decorator:getProperty property="body.onload" writeEntireProperty="true" />
	<%@ include file="/WEB-INF/jsp/inu/common/header.jsp"%>
	
	
	<%@ include file="/WEB-INF/jsp/inu/common/leftmenu.jsp"%>
	<!-- //좌측메뉴 끝 -->
	<!-- Content -->
	<section id="content" class="container">
		<decorator:body />
	</section>

	</section>
	<!-- //container 끝-->
	<!-- footer 시작 -->
	<%@ include file="/WEB-INF/jsp/inu/common/footer.jsp"%>
	<!-- //footer 끝 -->
	<!--// 전체 레이어 끝 -->
	
	<script type="text/javascript">
	var gObj = [];
		
	$(document).ready(function() {
		$('a').bind('click', function(e) { e.preventDefault(); });

		$('button').bind('click', function(e) { 
			e.preventDefault();
		});
		
		$('.prevent').bind('click', function(e) { e.preventDefault(); });;
		
	});
	$(document).keydown(function( event ) {
		if ( event.which == 8 && $(":focus").attr('readonly') == 'readonly') {
			event.preventDefault();
		}
	});
	</script>
	<!-- Javascript Libraries -->
    <!-- jQuery -->
    <script src="/common/js/jquery.easing.1.3.js"></script> <!-- jQuery Easing - Requirred for Lightbox + Pie Charts-->

    <!-- Bootstrap -->
    <script src="/common/js/bootstrap.min.js"></script>
    
    <!--  Form Related -->
    <script src="/common/js/icheck.js"></script> <!-- Custom Checkbox + Radio -->

    <!-- UX -->
    <script src="/common/js/scroll.min.js"></script> <!-- Custom Scrollbar -->
    <script src="/common/js/select.min.js"></script> <!-- Custom Select -->

    <!-- All JS functions -->
    <script src="/common/js/functions.js"></script>
    </body>
</html>