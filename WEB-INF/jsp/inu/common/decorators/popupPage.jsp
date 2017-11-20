<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title><decorator:title /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="/common/css/style.css" />
<link href="/common/css/bootstrap.min.css" rel="stylesheet">
        <link href="/common/css/animate.min.css" rel="stylesheet">
        <link href="/common/css/font-awesome.min.css" rel="stylesheet">
        <link href="/common/css/form.css" rel="stylesheet">
        <link href="/common/css/calendar.css" rel="stylesheet">
        <link href="/common/css/style.css" rel="stylesheet">
        <link href="/common/css/icons.css" rel="stylesheet">
        <link href="/common/css/generics.css" rel="stylesheet">




<!-- common javascript -->
<script type="text/javaScript" src="<c:url value='/js/jquery/jquery-1.10.2.min.js'/>"></script>
<script type="text/javascript" src="/js/jquery-ui-1.10.3/jquery-ui-1.10.3.custom.min.js"></script>
<script type="text/javaScript" src="<c:url value='/js/jquery-ui-1.10.3/jquery-ui-i18n.js'/>"></script>
<script type="text/javaScript" src="<c:url value='/js/custom-func.js'/>"></script>

<script type="text/javaScript" src="<c:url value='/js/jquery/jquery-ui.js'/>"></script>
<script type="text/javaScript" src="<c:url value='/js/common.js'/>"></script>
<script type="text/javaScript" src="<c:url value='/js/jquery/jquery.popupWindow.js'/>"></script>
<script type="text/javaScript" src="<c:url value='/js/jquery/jquery.form.js'/>"></script>

<script type="text/javaScript" src="<c:url value=''/>"></script>
<script type="text/javaScript" src="<c:url value=''/>"></script>


<script type="text/javascript" src="/common/js/front_js.js"></script>

<script type="text/javascript">
$(document).ready(function() {

	$('a').bind('click', function(e) { e.preventDefault(); });
	$('button').bind('click', function(e) { e.preventDefault(); });
});
$(document).keydown(function( event ) {
	if ( event.which == 8 && $(":focus").attr('readonly') == 'readonly') {
		event.preventDefault();
	}
});
</script>
<decorator:head />
</head>
<body id="skin-blur-violate">
	<decorator:getProperty property="style" writeEntireProperty="true" />
	<decorator:getProperty property="body.onload" writeEntireProperty="true" />
	<decorator:body />
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