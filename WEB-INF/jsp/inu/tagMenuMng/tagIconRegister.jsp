<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="vcms.common.file.util.UvFileUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%@page import="vcms.common.egov.EgovUserInfoVO" %>
<%
			/*
			* @JSP Name : tagIconRegister.jsp
			* @Description : 태그 아이콘 등록
			* @Modification Information
			* 
			*       수정일         수정자         수정내용
			*  ----------------------------------------------
			*     2015.09.23       박경택         최초생성
			*
			* author 개발팀 
			* Copyright (C) 2011 by MOPAS  All right reserved.
			*/
%>
<%
List<Map<String , Object>> bbsDataFile  = (List)request.getAttribute("bbsDataFile");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="popupPage">
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script language="JavaScript" src="/common/uploadify/uploadify.js"></script>
<style>
</style>
<script>
$(document).ready(function() {
	$('#close').click(function(){exit()})
	$('#save').click(function(){save()})
	$('#cancel').click(function(){cancel()})
});

function save() {
	document.frm.action = "/tagMenuMng/insertIcon.do";
	document.frm.submit(); 
}

function exit(){
	self.close();
}

function cancel() {
	history.back();
}
</script>

</head>
	
<body style="width:500px">
<div id="popup">
	<div class="popHeader">
		<h1>태그 아이콘 등록</h1>
	</div>
	
	<p class="btn_type04 close_btn01">
		<a href="#" class="btn02" id="save">저장</a>
		<a href="#" class="btn03 btn_c01" id="cancel">취소</a>
		<a href="#" class="btn03 btn_c01" id="close">닫기</a>
	</p>
	<div class="popContents">
	<form name='frm' id='frm' method="post">
	<input type="hidden" id="iconIdx" name="iconIdx" value="${param.iconIdx}" />
	<input type="hidden" id="tagIdx" name="tagIdx" value="${param.tagIdx}" />
	<input type="hidden" id="type" name="type" value="${param.type}" />
		<table class="data_tableW02" id="data_tableW" summary="" style="">
				<caption></caption>
				<colgroup>
					<col width="25%" />
					<col width="75%" /> 
				</colgroup>
				<thead>
				</thead>
				<tbody>
				<tr>
					<th>아이콘 이름</th>
					<td style="text-align:left;">
						<input type="text" name="iconName" id="iconName" class="textInput_size02" value="${iconDetail.tagIconName}" />
					</td>
				</tr>
				<tr>
					<th>아이콘 첨부</th>
					<td>
 					<%=UvFileUtil.drawSingleUpload("TAG_ICON", "C", "*.png; *.jpg;", "10000MB")%>
					<%
						if( bbsDataFile != null && bbsDataFile.size() > 0 ) {
							String rtn = "";
							String IMG_URL = "/upload/TAG_ICON/";
							for (Map<String , Object> file : bbsDataFile) {
								if (StringUtil.nvl(file.get("fileType")).equals("IMG")) {
									rtn = rtn + "jsDrawImageFile('TAG_ICON', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", " + file.get("dataIdx") + ", '" + IMG_URL + "', '" + file.get("'Y'")+ "');\n";	
								} else {
									rtn = rtn + "jsDrawFile('TAG_ICON', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", '" + file.get("fileType") + "', " + file.get("dataIdx") + ");\n";
								}
							}
						%>
						<script type="text/javascript">
						<%=rtn%>
						</script>
						<%
						}
						%>		
					</td>
				</tr>
				</tbody>
		</table>
	</form>
	</div>

</div>
</body>
</html>