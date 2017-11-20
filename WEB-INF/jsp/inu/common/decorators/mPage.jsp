<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"/>
<head>
<title><decorator:title /></title>

<link rel="stylesheet" type="text/css" href="/common/css/m/style.css" />

<script type="text/javaScript" src="<c:url value='/js/jquery/jquery-1.10.2.min.js'/>"></script>
<script type="text/javascript" src="/js/jquery-ui-1.10.3/jquery-ui-1.10.3.custom.min.js"></script>
<script type="text/javaScript" src="<c:url value='/js/jquery/jquery-ui.js'/>"></script>
<script type="text/javaScript" src="<c:url value='/js/jquery-ui-1.10.3/jquery-ui-i18n.js'/>"></script>
<script type="text/javaScript" src="<c:url value='/js/common.js'/>"></script>

<script type="text/javascript">
	
$(document).ready(function() {
	$('.prevent').bind('click', function(e) { e.preventDefault(); });;
});
</script>

<decorator:head />
</head>
<body>
<div id="wrap">
	<decorator:getProperty property="body.onload" writeEntireProperty="true" />
	<decorator:body />
	
	<!-- start :: footer -->
	<div id="footer">
		COPYRIGHT © 2015<br />BY INU POLYTECHNIC UNIVERSITY.<br />ALL RIGHTS RESERVED.
	</div>
	<!-- end :: footer -->
</div>	
</body>
</html>
