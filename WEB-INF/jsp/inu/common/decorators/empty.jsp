<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<!DOCTYPE html>
<html>
<head>
<title><decorator:title /></title>
<decorator:head />
</head>
<body id="skin-blur-violate">
	<decorator:getProperty property="body.onload" writeEntireProperty="true" />
	<decorator:body />
</body>
</html>
