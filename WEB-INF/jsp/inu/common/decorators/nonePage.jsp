<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator"
	prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%-- <%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%> --%>
<!DOCTYPE html>
<html>
<head>
<title><decorator:title /></title>
<decorator:head />
</head>
<body>
	<decorator:getProperty property="body.onload" writeEntireProperty="true" />>
	<decorator:body />
</body>
</html>
