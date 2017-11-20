<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%@page import="vcms.common.egov.EgovUserInfoVO" %>
<%
			/**
			* @JSP Name : detail.jsp
			* @Description : LIVE 방송관리 뷰 페이지
			* @Modification Information
			* 
			*       수정일         수정자         수정내용
			*  ----------------------------------------------
			*	2015.06.10	김승준	최초생성
			*
			* author 개발팀 
			* Copyright (C) 2011 by MOPAS  All right reserved.
			*/
%>
<%

Map<String , Object> liveDataInfo = (Map)request.getAttribute("liveDataInfo");

String live_idx  = "";
String broad_nm  = "";
String startDate = "";
String startDateRslt = "";
String startHH = "";
String startMM = "";
String endDate = "";
String endDateRslt = "";
String endHH = "";
String endMM = "";
String member_yn = "";
String screen_gubun = "";
String reg_dt = "";
String ch_nm = "";
String liveUrl = "";

if( liveDataInfo == null ) {
	
} else {

	live_idx  = String.valueOf(liveDataInfo.get("liveIdx"));
	broad_nm = StringUtil.nvl(liveDataInfo.get("broadNm"), "");
	startDate = StringUtil.nvl(liveDataInfo.get("startDate"), "");
	startDateRslt = StringUtil.nvl(liveDataInfo.get("startDateRslt"), "");
	startHH = StringUtil.nvl(liveDataInfo.get("startHh"), "");
	startMM = StringUtil.nvl(liveDataInfo.get("startMm"), "");
	endDate = StringUtil.nvl(liveDataInfo.get("endDate"), "");
	endDateRslt = StringUtil.nvl(liveDataInfo.get("endDateRslt"), "");
	endHH = StringUtil.nvl(liveDataInfo.get("endHh"), "");
	endMM = StringUtil.nvl(liveDataInfo.get("endMm"), "");
	member_yn = StringUtil.nvl(liveDataInfo.get("memberYnStr"), "");
	screen_gubun = StringUtil.nvl(liveDataInfo.get("screenGubun"), "");
	ch_nm = StringUtil.nvl(liveDataInfo.get("chNm"), "");
	liveUrl = StringUtil.nvl(liveDataInfo.get("liveUrl"), "");
}
%>
<head>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script> 
$(document).ready(function() {
	$('#goList').click(function(){goList()})
	$('#modify').click(function(){modify()})
	$('#remove').click(function(){remove()})
}); 
  
function goList(){  

	var f = document.frm;
	f.action = "/liveBroadMng/list.do";
	f.submit();
	
}

function modify(){ 
	var f = document.frm; 
	f.action = "/liveBroadMng/modify.do";
	f.submit();
}

function remove(){
	if( confirm("정말 삭제 하시겠습니까?")){
		var f = document.frm; 
		f.action = "/liveBroadMng/removeLiveBoard.do";
		f.submit();
	}
}

</script>
</head>
<body>
<ol class="breadcrumb hidden-xs">
    <li>LIVE 방송관리</li>
    <li>보기</li>
</ol>
<h4 class="page-title">LIVE 방송관리</h4>

<form name="frm" id="frm" method="post" enctype="multipart/form-data">
	<input type="hidden" name="live_idx" id="live_idx" value="<%= live_idx %>" />
	<input type="hidden" name="liveIdx" id="liveIdx" value="<%= live_idx %>" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	<input type="hidden" name="search_keyword" id="search_keyword" value="${search_keyword}" />
	<input type="hidden" name="search_type" id="search_type" value="${search_type}" />
 
	<div class="row m-t-15 text-right m-b-10">
		<button id="goList" class="btn btn-sm" style="">목 록</button>
		<button class="btn-sm btn" id="modify">수 정</button>
		<button class="btn-sm btn" id="remove">삭 제</button>
	</div>
			
	<h4><%= broad_nm %></h4>
	<div class="table-responsive overflow" style="overflow: hidden; outline: none;">
		<table class="table table-bordered tile" style="width:">
				<caption></caption>
				<colgroup>
					<col width="20%" />
					<col width="*" />
				</colgroup>
				 
				<tr>
					<th>채널명</th>
					<td>
						<%= ch_nm %>
					</td>
				</tr>
				<tr>
					<th>방송 제목</th>
					<td> 
						<%= broad_nm %>
					</td>
				</tr>
				<tr>
					<th>시작시간</th>
					<td><%= startDateRslt %></td>
				</tr>
				<tr>
					<th>종료시간</th>
						<td><%= endDateRslt %></td>
				</tr>
				<tr>
					<th>URL</th>
					<td> 
						<%= liveUrl %>
					</td>
				</tr>
				<tr>
					<th>시청 허용 여부</th>
					<td> 
						<%= member_yn %>
					</td>
				</tr>
				<tr>
					<th>SD/HD 표시</th>
					<td> 
						<%= screen_gubun %>
					</td>
				</tr>
			</table> 
	</section>
</form>
</body>
</html>