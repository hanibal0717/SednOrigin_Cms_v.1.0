<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%
			/*
			* @JSP Name : showImgPop.jsp
			* @Description : 이미지 팝업
			* @Modification Information
			* 
			*       수정일         수정자         수정내용
			*  ----------------------------------------------
			*     2015.09.07       박경택         최초생성
			*
			* author 개발팀 
			* Copyright (C) 2011 by MOPAS  All right reserved.
			*/
%>
<%
String dataIdx = StringUtil.nvl((String)request.getParameter("dataIdx"), "");
String fileGubun = StringUtil.nvl((String)request.getParameter("file_gubun"), "");
%>
<html>
<head>
<title></title>
<script>
	function noImage() {
		alert("이미지가 존재하지 않습니다.");
		self.close();
	}
</script>
</head>
	
<body topmargin="0" leftmargin="0">
	<table align="center" height="100%" width="100%">
		<tr>
			<td align="center" valign="middle">
				<img id="img" src="/vod/file/getImage.do?data_idx=<%=dataIdx%>&file_gubun=<%=fileGubun%>" onload='resizeTo(this.width+60, this.height+94);' onerror="noImage();" />
			</td>
		</tr>
	</table>
</body>
</html>