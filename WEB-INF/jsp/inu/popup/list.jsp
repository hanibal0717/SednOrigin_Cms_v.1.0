<%@page import="vcms.common.util.DateUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%@page import="egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo" %>

<%
	List<Map<String , Object>> popupList = (List)request.getAttribute("popupList");
	
	PaginationInfo paginationInfo = null;
	paginationInfo = (PaginationInfo)request.getAttribute("paginationInfo");
	
	String search_type = (String)request.getAttribute("search_type");
	if (search_type == null) {
		search_type = "";
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>팝업관리</title>

<meta name="decorator" content="defaultPage">

<script>
$(document).ready(function() {
	$('#search').click(function(){search()})
	
	$('#search_type').val('<%=search_type%>');
}); 
  

function search(){ 
	var f = document.frm;	
	f.action = "/popup/list.do";
	f.submit();
}

function jsRegister() {	
	var f = document.frm;
	f.action = "/popup/registerForm.do";
	f.submit();
}

function jsDetail(SEQ) {
	var f = document.frm;
	$('#P_SEQ').val(SEQ);
	f.action = "/popup/detail.do";
	f.submit();
}

function fn_page(pageNo) {
	$("#frm").attr("action","/popup/list.do");
	$("#pageIndex").val(pageNo);
	$("#frm").submit();
}
</script>

</head>

<body>
<ol class="breadcrumb hidden-xs">
	<li>배너 관리</li>
    <li>팝업 관리</li>
</ol>
<h4 class="page-title">팝업 관리</h4>

<form name="frm" id="frm" method="get">
	<input type="hidden" id="P_SEQ" name="P_SEQ" value="" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	
	
	<div class="row m-t-15">
		<div class="col-md-1 m-b-15">
			<select id="search_type" name="search_type" class="select">
				<option value="TITLE">제목</option>
				<option value="CONT">내용</option>
				<option value="">제목+내용</option>
			</select>
		</div>
		<div class="col-md-2 m-b-15">
			<input id="search_keyword" name="search_keyword" class="form-control input-sm" value="${search_keyword}" />
		</div>
		<div class="col-md-2 m-b-15">
			<button id="search" class="btn-sm btn" style="" >조 회</button>
			<button class="btn-sm btn" id="newBanner" onclick="jsRegister();">신 규</button>
		</div>
	</div>
</form>
<div class="clearfix"></div> 
<div class="table-responsive" style="overflow: hidden; outline: none;">
	<table class="table table-bordered table-hover tile" id="data_tableW" >
		<caption></caption>
		<colgroup>
			<col width="5%"/>
			<col width="*" />
			<col width="14%" />
			<col width="14%" />
			<col width="5%" />
			<col width="11%" />
		</colgroup>
		<thead>
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>시작일</th>
			<th>종료일</th>
			<th>서비스여부</th>
			<th>등록일</th>
		</tr>
		</thead>
		<tbody>
		<%
		int list_count_1 = popupList.size();
		if (popupList == null || list_count_1 == 0) {
			
		%>
			<tr>
				<td colspan="6">해당 데이터가 존재하지 않습니다.</td>
			</tr>
		<%
			}
		if(popupList != null  && popupList.size() > 0){
			String regDate = "";
			String endHh = "";
			String startHh = "";
			
			int totalRecordCnt = paginationInfo.getTotalRecordCount();
			int firstRecordIndex = paginationInfo.getFirstRecordIndex();
							
			int value = totalRecordCnt - firstRecordIndex;
			int i = 0;
			for (Map<String , Object> popup : popupList) {
				int rownum = value - i;
				i++;
				
				if(popup.get("pEndHh") != null)
				{
					endHh = popup.get("pEndHh").toString();
					
					if (endHh.length() < 2 && !"0".equals(endHh)) {
						endHh = "0" + endHh;
					}
					
				}
				
				if(popup.get("pStartHh") != null)
				{
					startHh = popup.get("pStartHh").toString();
					
					if (startHh.length() < 2 && !"0".equals(startHh)) {
						startHh = "0" + startHh;
					}
					
				}
				
				if( popup.get("pRegDate") != null ){
					
					regDate = popup.get("pRegDate").toString();
					regDate = regDate.substring(0, 10);
				}
		%>
		<tr>
		 <td><%=rownum%></td>
		 <td style="text-align: left;"><a href="#" onclick="javascript:jsDetail('<%=popup.get("pSeq")%>');"><%=popup.get("pTitle")%></a></td>
		 <td><%=DateUtil.getDayFormat((String)popup.get("pStartDate"), "-")%> <%=startHh%>:<%=popup.get("pStartMm")%></td>
		 <td><%=DateUtil.getDayFormat((String)popup.get("pEndDate"), "-")%> <%=endHh%>:<%=popup.get("pEndMm")%></td> 
		 <td><%=popup.get("pUseYn")%></td>
		 <td><%=regDate%></td> 
		</tr>
		<%					
			}
		}
		%>
		</tbody>
	</table>
</div>
<div class="media text-center">
	<div class="pagination">
		 <ui:pagination paginationInfo = "${paginationInfo}"  type="image" jsFunction="fn_page"  />
	</div>
</div>
</body>
</html>