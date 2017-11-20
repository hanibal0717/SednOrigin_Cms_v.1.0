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
			* @JSP Name : userMng.jsp
			* @Description : 회원 관리 목록
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
<%
PaginationInfo paginationInfo = null;

paginationInfo = (PaginationInfo)request.getAttribute("paginationInfo");
String searchCondition = (String)request.getAttribute("searchCondition");

String modeType = "";
List<Map<String , Object>> list = (List)request.getAttribute("list");

String userIdx = "";
String userId = "";
String userNm = "";
String userEmail = "";
String userTel = "";
String regDt = "";
String userStatus = "";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">
<script>
$(document).ready(function() {
   
	$('#search').click(function(){search()});
	
	$('#searchCondition').val(<%=searchCondition%>);
	
});

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

function fn_page(pageNo) {
	$("#frm1").attr("action","/user/userMng/userMng.do");
	$("#pageIndex").val(pageNo);
	$("#frm1").submit();
}

</script>
</head>
	
<body>
<ol class="breadcrumb hidden-xs">
	<li>회원 관리</li>
</ol>
<h4 class="page-title">회원 관리</h4>

<form name="frm1" id="frm1" method="post">
	<input type="hidden" name="userIdx" id="userIdx" value="" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	<div class="row m-t-15">
		<div class="col-md-1 m-b-15">
			<select class="select" name="searchCondition" id="searchCondition">
				<option value="1">아이디</option>
				<option value="2">이름</option>
				<option value="">아이디+이름</option>
			</select>
		</div>
		<div class="col-md-2 m-b-15">
			<input type="text" id="searchTxt" class="form-control input-sm" name="searchTxt" value="${searchTxt}">
		</div>
		<div class="col-md-2 m-b-15"> 
			<button id="search" class="btn-sm btn" style="">조 회</button>
		</div>
	</div>
	<div class="clearfix"></div> 
	<div class="table-responsive" style="overflow: hidden; outline: none;">
		<table class="table table-bordered table-hover tile" id="data_tableW" >
			<caption></caption>
			<colgroup>
				<col width="5%"/>
				<col width="16%" />
				<col width="12%" />
				<col width="20%" />
				<col width="15%" />
				<col width="15%" />
				<col width="9%" />
			</colgroup>
			<thead>
			<tr>
				<th>번호</th>
				<th>아이디</th>
				<th>이름</th>
				<th>이메일</th>
				<th>연락처</th>
				<th>등록일</th>
				<th>승인여부</th>
			</tr>
			</thead>
			<tbody>
			<%
			if(list != null) {
				Map<String, Object> userDataInfo;
				int totalRecordCnt = paginationInfo.getTotalRecordCount();
				int firstRecordIndex = paginationInfo.getFirstRecordIndex();
				
				int value = totalRecordCnt - firstRecordIndex;
				
				for(int i=0; i<list.size(); i++) {
					int rownum = value - i;
					userDataInfo = list.get(i);
					
					userIdx = String.valueOf(userDataInfo.get("userIdx"));
					userId = StringUtil.nvl(userDataInfo.get("userId"),"");
					userNm = StringUtil.nvl(userDataInfo.get("userNm"),"");
					userEmail = StringUtil.nvl(userDataInfo.get("userEmail"),"");
					userTel = StringUtil.nvl(userDataInfo.get("userTel"),"");
					regDt = userDataInfo.get("regDt").toString();
					userStatus = StringUtil.nvl(userDataInfo.get("userStatus"),"");
			%>
				<tr id="<%=userIdx%>" onclick="goDetail(<%=userIdx%>)"
					onmouseover="mouseOver(this.id);" onmouseout="mouseOut(this.id);">
					<td><%=rownum %></td>
					<td><%=userId %></td>
					<td><%=userNm %></td> 
					<td><%=userEmail %></td>
					<td><%=userTel %></td>
					<td><%=regDt %></td>
					<td><%=userStatus %></td>
				</tr>
			<%
				}
			}
			
		        if(list.size() < 1) {
			%>
				<tr>
					<td colspan="7">
						<strong>해당하는 회원이 존재하지 않습니다.</strong>
					</td>
				</tr>
		    <%
		        }
			%>
			</tbody>
		</table>
	</div>
</form>

<div class="media text-center">
	<div class="pagination">
		 <ui:pagination paginationInfo = "${paginationInfo}"  type="image" jsFunction="fn_page"  />
	</div>
</div>
</body>
</html>

