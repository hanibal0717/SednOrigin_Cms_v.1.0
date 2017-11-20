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
			/**
			* @JSP Name : userStatistics.jsp
			* @Description : 사용자별 통계
			* @Modification Information
			* 
			*       수정일         수정자         수정내용
			*  ----------------------------------------------
			*     2015.11.05       박경택         최초생성
			*
			* author 개발팀 
			* Copyright (C) 2011 by MOPAS  All right reserved.
			*/
%>
<%

PaginationInfo paginationInfo = null;

paginationInfo = (PaginationInfo)request.getAttribute("paginationInfo");
//String searchCondition = (String)request.getAttribute("searchCondition");

Map<String , Object> dateInfo = (Map)request.getAttribute("dateInfo");

String dateInfo0 = "";
String dateInfo1 = "";
String dateInfo2 = "";

if( dateInfo == null ){
	
} else {

	dateInfo0 = StringUtil.nvl(dateInfo.get("day0"), "");
	dateInfo1 = StringUtil.nvl(dateInfo.get("day1"), "");
	dateInfo2 = StringUtil.nvl(dateInfo.get("day2"), "");

}

List<Map<String , Object>> list = (List)request.getAttribute("userStatList");

String userId = "";
String userNm = "";
String pc01 = "";
String mobile01 = "";
String sum01 = "";
String pc02 = "";
String mobile02 = "";
String sum02 = "";
String day01 = "";
String day02 = "";
String day03 = "";

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">
<script>
$(document).ready(function() {
   
	/* $('#search').click(function(){search()}); */
	
	<%-- $('#searchCondition').val(<%=searchCondition%>); --%>
	
});
/* 
function goDetail(userIdx){
	
	var sKeyword = encodeURIComponent($('#searchTxt').val());
    $('#searchTxt').val(sKeyword);
	$('#userIdx').val(userIdx);
	
	var formData = document.frm1;
	formData.action = "/user/userMng/userDetail.do";
	formData.submit();
	
}

function search(){
	
	var f = document.frm1;	
	f.action = "/user/userMng/userMng.do";
	f.submit();

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
*/

function loadList(value) {
	$("#listSort").val(value);
	var frm = document.frm1;	
	frm.action = "/statistics/userStatistics.do";
	frm.submit();
}

function fn_page(pageNo) {
	$("#frm1").attr("action","/statistics/userStatistics.do");
	$("#pageIndex").val(pageNo);
	$("#frm1").submit();
}

</script>
</head>
	
<body>
<h2>사용자별 통계<span class="text"></span></h2>
<p class="location"></p>
<p class="tar Mbo11">
</p>
<section>
<form name="frm1" id="frm1" method="post">
	<input type="hidden" id="listSort" name="listSort" value="" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	<!-- 
	<p class="tar Mbo11">
		<select class="select_size013" name="searchCondition" id="searchCondition">
			<option value="1">아이디</option>
			<option value="2">이름</option>
			<option value="">아이디+이름</option>
		</select>
		<input type="text" id="searchTxt" name="searchTxt" value="${searchTxt}">
		<input type="text" id="searchTxt" name="searchTxt" value=""> 
		<button id="search" class="btn_searchTbl06 prevent" style="">조회</button>
		
	</p> -->
	<h3>사용자별 통계 목록</h3>
	<div style="height:476px; border-left:1px solid #cdcdcd; border-right:1px solid #cdcdcd; border-bottom:1px solid #cdcdcd; border-top:1px solid #cdcdcd;">
			<table class="data_tableW" id="data_tableW" summary="" >
				<caption></caption>
				<colgroup>
					<col width="5%"/>
					<col width="15%" />
					<col width="15%" />
					
					<col width="6%" />
					<col width="6%" />
					<col width="6%" />
					
					<col width="6%" />
					<col width="6%" />
					<col width="6%" />
					
					<col width="6%" />
					<col width="6%" />
					<col width="6%" />
				</colgroup>
				<thead>
				<tr style="background-color: blue;">
					<th rowspan="2">번호</th>
					<th rowspan="2">아이디</th>
					<th rowspan="2">이름</th>
					
					<th colspan="3">
						시청수
						<button onclick="loadList(1);" style="background-color:#f9f9f9;">▲</button>
						<button onclick="loadList(2);" style="background-color:#f9f9f9;">▼</button>
					</th>
					<th colspan="3">
						조회수
						<button onclick="loadList(3);" style="background-color:#f9f9f9;">▲</button>
						<button onclick="loadList(4);" style="background-color:#f9f9f9;">▼</button>
					</th>
					<th colspan="3">최근 3일간 시청수</th>
					
				</tr>
				<tr>
					<th>PC</th>
					<th>MOBILE</th>
					<th>소계</th>
					
					<th>PC</th>
					<th>MOBILE</th>
					<th>소계</th>
					
					<th><%=dateInfo0%></th>
					<th><%=dateInfo1%></th>
					<th><%=dateInfo2%></th>
				</tr>
				</thead>
				<tbody>
				<%
				if(list != null) {
					Map<String, Object> contentDataInfo;
					int totalRecordCnt = paginationInfo.getTotalRecordCount();
					int firstRecordIndex = paginationInfo.getFirstRecordIndex();
					
					int value = totalRecordCnt - firstRecordIndex;
					
					for(int i=0; i<list.size(); i++) {
						int rownum = value - i;
						contentDataInfo = list.get(i);
						
						userId = StringUtil.nvl(contentDataInfo.get("userId"),"");
						userNm = StringUtil.nvl(contentDataInfo.get("userNm"),"");
						pc01 = String.valueOf(contentDataInfo.get("pc01"));
						mobile01 = String.valueOf(contentDataInfo.get("mobil01"));
						sum01 = String.valueOf(contentDataInfo.get("sum01"));
						pc02 = String.valueOf(contentDataInfo.get("pc02"));
						mobile02 = String.valueOf(contentDataInfo.get("mobil02"));
						sum02 = String.valueOf(contentDataInfo.get("sum02"));
						day01 = String.valueOf(contentDataInfo.get("day01"));
						day02 = String.valueOf(contentDataInfo.get("day02"));
						day03 = String.valueOf(contentDataInfo.get("day03"));
				%>
					<tr>
						<td><%=rownum%></td>
						<td><%=userId%></td>
						<td><%=userNm%></td>
						
						<td><%=pc01%></td>
						<td><%=mobile01%></td>
						<td><%=sum01%></td>
						
						<td><%=pc02%></td>
						<td><%=mobile02%></td>
						<td><%=sum02%></td>
						
						<td><%=day01%></td>
						<td><%=day02%></td>
						<td><%=day03%></td>
					</tr>
				<%
					}
				}
				
			        if(list.size() < 1) {
				%>
					<tr>
						<td colspan="12">
							<strong>해당하는 컨텐츠가 존재하지 않습니다.</strong>
						</td>
					</tr>
			    <%
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

