<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%@page import="egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo" %>
<%
	List<Map<String , Object>> list = (List)request.getAttribute("mngUser");
	String searchCondition = (String)request.getAttribute("searchCondition");
	
	PaginationInfo paginationInfo = null;
	paginationInfo = (PaginationInfo)request.getAttribute("paginationInfo");
	
	String manageIdx = "";
	String manageId = "";
	String manageNm = "";
	String manageLevel = "";
	String department = "";
	String regDt = "";
	String groupNm = "";
%>
<%
			/**
			* @JSP Name : mngUserList.jsp
			* @Description : 관리자 계정 관리
			* @Modification Information
			* 
			*       수정일         수정자         수정내용
			*  ----------------------------------------------
			*     2015.08.28       박경택         최초생성
			*
			* author 개발팀 
			* Copyright (C) 2011 by MOPAS  All right reserved.
			*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">
<script>
$(document).ready(function() {
   
//    loadList();
				
	$('#add').click(function(){newUser()});
	$('#save').click(function(){save()});
	$('#search').click(function(){search()});
	
	$('#searchCondition').val(<%=searchCondition%>);
	
});

function search() {
	var formData = document.frm1;
	formData.action = "/system/mngUserList.do";
	formData.submit();
}

function goDetail(manageIdx){

	$('#manageIdx').val(manageIdx);
	
	var formData = document.frm1;
	formData.action = "/system/mngUserDetail.do";
	formData.submit();
	
}

function newUser(){
	location.href = "/system/writeMngUser.do";	 
}	

function fn_page(pageNo) {
	$("#frm1").attr("action","/system/mngUserList.do");
	$("#pageIndex").val(pageNo);
	$("#frm1").submit();
}

function mouseOver(tdId) {
	
	var div = document.getElementById(tdId);
	
	div.style.fontWeight = "bold";
	div.style.cursor = "pointer";

}

function mouseOut(tdId) {

	var div = document.getElementById(tdId);
	
	div.style.fontWeight = "normal";
	div.style.cursor = "default";

}
</script>
</head>
	
<body>
<h2>관리자 계정 관리<span class="text"></span></h2>
<p class="location"></p>
<form name="frm1" id="frm1" method="post">
<p class="tar Mbo11">
		<select class="select_size013" name="searchCondition" id="searchCondition">
			<option value="1">아이디</option>
			<option value="2">이름</option>
			<option value="">아이디+이름</option>
		</select>
		<input type="text" id="searchTxt" name="searchTxt" value="${searchTxt}" /> 
		<button id="search" class="btn_searchTbl06 prevent">조회</button>
		
		<span class="btn_type01 btn"><a href="#" id="add">신규</a></span>
</p>
<section>
	<input type="hidden" name="sqlId" id="sqlId" value=""/>
	<input type="hidden" name="manageIdx" id="manageIdx" value=""/>
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	<h3>관리자 목록</h3>
	<div style="height:476px; border-left:2px solid #cdcdcd; border-right:2px solid #cdcdcd; border-bottom:2px solid #cdcdcd; border-top:2px solid #cdcdcd;">
			<table class="data_tableW" id="data_tableW" summary="" >
				<caption></caption>
				<colgroup>
					<col width="5%"/>
					<col width="17%"/>
					<col width="17%"/>
					<col width="17%"/>
					<col width="17%"/>
					<col width="17%"/>
				</colgroup>
				<thead>
				<tr style="background-color: blue;">
					<th>번호</th>
					<th>아이디</th>
					<th>이름</th>
					<th>부서</th>
					<th>권한그룹명</th>
					<th>등록일</th>
				</tr>
				</thead>
				<tbody> 
				<%
				int list_count_1 = list.size();
				if (list == null || list_count_1 == 0) {
					
				%>
					<tr>
						<td colspan="7">해당 데이터가 존재하지 않습니다.</td>
					</tr>
				<%
				} 
				if( list != null) {
					Map<String, Object> userDataInfo;
					int totalRecordCnt = paginationInfo.getTotalRecordCount();
					int firstRecordIndex = paginationInfo.getFirstRecordIndex();
					
					int value = totalRecordCnt - firstRecordIndex;
					
					for(int i=0; i<list.size(); i++) {
						int rownum = value - i;
						userDataInfo = list.get(i);
						
						manageIdx = String.valueOf(userDataInfo.get("manageIdx"));
						manageId = StringUtil.nvl(userDataInfo.get("manageId"),"");
						manageNm = StringUtil.nvl(userDataInfo.get("manageNm"),"");
						manageLevel = StringUtil.nvl(userDataInfo.get("manageLevel"),"");
						department = StringUtil.nvl(userDataInfo.get("department"),"");
						groupNm = StringUtil.nvl(userDataInfo.get("groupNm"),"");
						regDt = userDataInfo.get("regDt").toString();
				%>
					<tr id="<%=manageIdx %>" style="cursor:pointer;" onclick="goDetail(<%=manageIdx %>)" onmouseover="mouseOver(this.id);" onmouseout="mouseOut(this.id);">
						<td><%=rownum %></td>
						<td><%=manageId %></td>
						<td><%=manageNm %></td>
						<td><%=department %></td>
						<td><%=groupNm %></td>
						<td><%=regDt %></td>
					</tr>
				<%
					}
				}
				%>
				</tbody>
			</table>
		</div>
	</form>
</section>
	<div class="paging">
		 <ui:pagination paginationInfo = "${paginationInfo}"  type="image" jsFunction="fn_page"  />
	</div>
</body>
</html>

