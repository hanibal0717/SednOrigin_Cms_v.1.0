<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator"
	prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%-- <%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%> --%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title><decorator:title /></title>

<link rel="stylesheet" type="text/css" href="/css/style.css" />

	<!-- JQuery -->
	<script type="text/javascript" src="/js/jquery/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery.ui.core.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery.ui.datepicker.js"
		charset="utf-8"></script>
	<script type="text/javascript" src="/js/jquery/jquery.sound.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery.form.js"></script>

	<decorator:head />
</head>
<body>
	<decorator:getProperty property="body.onload" writeEntireProperty="true" />
	<decorator:body />
</body>
</html>