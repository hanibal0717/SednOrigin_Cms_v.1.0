<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%
			/**
			* @JSP Name : list.jsp
			* @Description : 게시판 관리
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
List<Map<String , Object>> list = (List)request.getAttribute("list");
Map<String, Object> param = (Map<String, Object>)request.getAttribute("param");

String bbsMstIdx = "";
String bbsNm = "";
String dataCount = "";
String commentCount = "";  
String reg_dt = "";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script>
 
$(document).ready(function() { 
	 
	$('#search').click(function(){search()}) 
	$("#search_type").val("<%=StringUtil.nvl(param.get("SC_KEYWORD"))%>");
	$("#search_keyword").val("<%=StringUtil.nvl(param.get("search_keyword"))%>");
}); 
  

function search(){ 
	  
	var f = document.frm;	
	f.action = "/bbs/mst/list.do";
	f.submit();

} 
 
function fn_regit(bbs_mst_idx) {
	 
	var f = document.frm;
	$('#bbs_mst_idx').val(bbs_mst_idx);
	f.action = "/bbs/mst/write.do";
	f.submit();
} 
</script>
</head>
<body>
<ol class="breadcrumb hidden-xs">
	<li>NCS</li>
    <li>게시판 관리</li>
</ol>
<h4 class="page-title">게시판 관리</h4>

<form name="frm" id="frm" method="post" >
	<input type="hidden" name="guestSearch" id="guestSearch" value="" />
	<input type="hidden" name="bbs_mst_idx" id="bbs_mst_idx" value="" /> 
 
	<div class="row m-t-15">
	<div class="col-md-1 m-b-15">
		 <select id=search_type name="SC_KEYWORD" class="select">
			<option value="">선택</option>
			<option value="BBS_NM">게시판명</option>
			<option value="BBS_CONT">설명</option>
			<option value="BBS_ALL">게시판명+설명</option>
		</select>
	</div>
	<div class="col-md-2 m-b-15">
		<input type="text" id="search_keyword" name="search_keyword" class="form-control input-sm" />
	</div>
	<div class="col-md-2 m-b-15">			
		<button id="search" class="btn btn-sm" style="" >조회</button>
		<button class="btn btn-sm" onclick="fn_regit('')">신규</button>
	</div>
		
	<div class="clearfix"></div> 
	<div class="table-responsive overflow" style="overflow: hidden; outline: none;">
		<table class="table table-bordered table-hover tile" id="data_tableW" >
			<caption></caption>
			<colgroup>
				<col width="5%"/>
				<col width="*" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="12%" />
				<col width="25%" />  
			</colgroup>
			<thead>
			<tr>
				<th>번호 </th>
				<th>게시판명</th>
				<th>등록일</th>
				<th>게시물수</th>
				<th>댓글수</th>
				<th>게시물보기</th>
				<th>게시물URL</th>
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
			if( list != null){
				Map<String , Object> bbsDataInfo;
				
				for(int i=0; i<list.size(); i++){
					bbsDataInfo = list.get(i);
					bbsMstIdx   = String.valueOf(bbsDataInfo.get("bbsMstIdx"));
					bbsNm       = StringUtil.nvl(bbsDataInfo.get("bbsNm"),"");
					dataCount   = String.valueOf(bbsDataInfo.get("dataCount"));
					commentCount= String.valueOf(bbsDataInfo.get("commentCount"));
					
					if( bbsDataInfo.get("regDt") != null ){
						reg_dt = bbsDataInfo.get("regDt").toString().substring(0,10);
					}	 
%>
			<tr>
			 <td><%=(i+1) %></td> 
			 <td style="text-align: left;"><a href="#" onclick="javascript:fn_regit('<%=bbsMstIdx%>');"><%= bbsNm%></a></td>
			 <td><%=reg_dt%></td> 
			 <td><%=dataCount%></td> 
			 <td><%=commentCount %></td>
			 <td>[<a href="#" onclick="location.href='/ncs/bbs/list.do?bbs_mst_idx=<%=bbsMstIdx%>'" target="_blank">게시물보기</a>]</td>
			 <td>/bbs/list.do?bbs_mst_idx=<%=bbsMstIdx%></td>
			</tr>
<%						
				}
			}
			%>
			
			</tbody>
		</table>
	</div>
</form> 	
</body>
</html>