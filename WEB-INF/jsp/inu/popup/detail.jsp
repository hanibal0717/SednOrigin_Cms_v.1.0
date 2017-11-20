<%@page import="vcms.common.util.DateUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="vcms.common.file.util.UvFileUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="vcms.common.util.StringUtil" %>

<%
	Map<String, Object> popUp = (Map)request.getAttribute("popUp");

	List<Map<String , Object>> filePC = (List)request.getAttribute("filePC");
	List<Map<String , Object>> fileMobile = (List)request.getAttribute("fileMobile");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">

<script language="JavaScript" src="/common/uploadify/uploadify.js"></script>

<script> 
function jsList() {
	var f = document.frm; 
	f.action = "/popup/list.do";
	f.submit();
}

function jsModify() {
	var f = document.frm; 
	f.action = "/popup/modifyForm.do";
	f.submit();
}

function jsRemove(){
	if( $('#P_SEQ').val() == '' ){
		alert("삭제할수 없습니다.");
		return;
	}
	if( confirm("정말 삭제 하시겠습니까?")){
		$.ajax({
		    url:'/popup/remove.do',
		    type:'POST',
		    data: $('#frm').serialize(),
		    dataType: 'json',
		    success: function( data) {
		    	alert(data.msg);
		    	jsList();
		    }
		});
	}
};
</script>
</head>
<body>
<ol class="breadcrumb hidden-xs">
	<li>배너 관리</li>
    <li>팝업 관리</li>
</ol>
<h4 class="page-title">팝업 관리</h4>

<form name="frmSc" id="frmSc" method="get">
</form>

<form name="frm" id="frm" method="get">
	<input type="hidden" name="P_SEQ" id="P_SEQ" value="<%=popUp.get("pSeq")%>" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	<input type="hidden" name="search_keyword" id="search_keyword" value="${search_keyword}" />
	<input type="hidden" name="search_type" id="search_type" value="${search_type}" />
</form>


<div class="row m-t-15 text-right m-b-10">
	<button id="search" class="btn-sm btn" style="" onclick="jsList();">목 록</button>
	<button class="btn-sm btn" id="modify" onclick="jsModify();">수 정</button>
	<button class="btn-sm btn" id="remove" onclick="jsRemove();">삭 제</button>
</div>

	<h3><%=StringUtil.nvl(popUp.get("pTitle"))%></h3>
<div class="table-responsive" style="overflow: hidden; outline: none;">
	<table class="table table-bordered tile">
		<caption></caption>
		<colgroup>
			<col width="20%" />
			<col width="*" />
		</colgroup>
		<tr>
			<th>서비스 시작 날짜/시간</th>
			<td>
				<%
					String endHh = "";
					String startHh = "";
				
					if(popUp.get("pEndHh") != null)
					{
						endHh = popUp.get("pEndHh").toString();
						
						if (endHh.length() < 2 && !"0".equals(endHh)) {
							endHh = "0" + endHh;
						}
						
					}
					
					if(popUp.get("pStartHh") != null)
					{
						startHh = popUp.get("pStartHh").toString();
						
						if (startHh.length() < 2 && !"0".equals(startHh)) {
							startHh = "0" + startHh;
						}
						
					}
				%>
				<%=DateUtil.getDayFormat(StringUtil.nvl(popUp.get("pStartDate")), "-")%> <%=startHh%>:<%=StringUtil.nvl(popUp.get("pStartMm"), "00")%>
			</td>
		</tr>
		<tr>
			<th>서비스 종료 날짜/시간</th>
			<td>
				<%=DateUtil.getDayFormat(StringUtil.nvl(popUp.get("pEndDate")), "-")%> <%=endHh%>:<%=StringUtil.nvl(popUp.get("pEndMm"), "00")%>
			</td>
		</tr>
		<tr>
			<th>내용</th>
			<td>
				<%=StringUtil.nvl(popUp.get("pCont"))%>
			</td>
		</tr>
	<tr>
		<th>링크 Url</th>
		<td><%=StringUtil.nvl(popUp.get("pLinkUrl"))%>
	</tr>
	<tr>
		<th scope="col">팝업 이미지 (PC)<br /></th>
		<td colspan="3">	
			<%
			if( filePC != null && filePC.size() > 0 ) {
				String rtn = "";
				String IMG_URL = "/UPLOAD/POPUP/";
				for (Map<String , Object> file : filePC) {
					if (StringUtil.nvl(file.get("fileType")).equals("IMG")) {
						rtn = rtn + "jsDrawImageFileDownload('POPUP', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", " + file.get("dataIdx") + ", '" + IMG_URL + "', '" + file.get("mainImgFalg")+ "');\n";	
					} else {
						rtn = rtn + "jsDrawFileDownload('POPUP', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", '" + file.get("fileType") + "', " + file.get("dataIdx") + ");\n";
					}
				}
			%>
			<ul id='POPUP_IMAGE_LIST' class='uploadify_image_list' style='display:none'></ul>
			<ul id='POPUP_FILE_LIST' class='uploadify_image_list' style='display:none'></ul>
			<script type="text/javascript">
			<%=rtn%>
			</script>
			<%
			}
			%>
		</td>
	</tr>
	<tr>
		<th scope="col">팝업 이미지 (Mobile)</th>
		<td colspan="3">
			<%
			if( fileMobile != null && fileMobile.size() > 0 ) {
				String rtn = "";
				String IMG_URL = "/UPLOAD/POPUP_M/";
				for (Map<String , Object> file : fileMobile) {
					if (StringUtil.nvl(file.get("fileType")).equals("IMG")) {
						rtn = rtn + "jsDrawImageFileDownload('POPUP_M', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", " + file.get("dataIdx") + ", '" + IMG_URL + "', '" + file.get("mainImgFalg")+ "');\n";	
					} else {
						rtn = rtn + "jsDrawFileDownload('POPUP_M', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", '" + file.get("fileType") + "', " + file.get("dataIdx") + ");\n";
					}
				}
			%>
			<ul id='POPUP_M_IMAGE_LIST' class='uploadify_image_list' style='display:none'></ul>
			<ul id='POPUP_M_FILE_LIST' class='uploadify_image_list' style='display:none'></ul>
			<script type="text/javascript">
			<%=rtn%>
			</script>
			<%
			}
			%>
		</td>
	</tr>
	<tr>
		<th>X, Y 좌표</th>
		<td>
			X : <%=StringUtil.nvl(popUp.get("pX"))%><br>
			Y : <%=StringUtil.nvl(popUp.get("pY"))%>
		</td>
	</tr>
	<tr>
		<th>사용여부</th>
			<td>
				<%=StringUtil.nvl(popUp.get("pUseYn"), "Y")%>
			</td>
		</tr>	 
	</table> 
</div>
<div class="row m-t-15 text-right m-b-10">
	<button id="search2" class="btn-sm btn" style="" onclick="jsList();">목 록</button>
	<button class="btn-sm btn" id="modify2" onclick="jsModify();">수 정</button>
	<button class="btn-sm btn" id="remove2" onclick="jsRemove();">삭 제</button>
</div>
</body>
</html>