<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%@page import="egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo" %>
<%
			/**
			* @JSP Name : list.jsp
			* @Description : Image & Text 게시판
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
String modeType = "";

List<Map<String , Object>> list = (List)request.getAttribute("list");
Map<String, Object> param = (Map<String, Object>)request.getAttribute("param");

PaginationInfo paginationInfo = null;
paginationInfo = (PaginationInfo)request.getAttribute("paginationInfo");

String text_idx = "";
String title    = "";
String hits     = "";
String reg_dt   = "";
%>
<meta name="decorator" content="defaultPage">
</head>
<body>
<ol class="breadcrumb hidden-xs">
    <li>Image & Text 컨텐츠 관리</li>
    <li>목록</li>
</ol>
<h4 class="page-title">Image & Text 컨텐츠 관리</h4>

<form name="frm" id="frm" method="post" >
	<input type="hidden" name="text_idx" id="text_idx" value="" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	 
	<div class="row m-t-15">
		<div class="col-md-1 m-b-15">
			<select id=search_type name="best_select" class="select">
				<option value="TITLE">제목</option>
				<option value="CONT">내용</option>
				<option value="">제목+내용</option>
			</select>
		</div>
		<div class="col-md-2 m-b-15">	
			<input id="search_keyword" name="search_keyword" class="form-control input-sm m-b-10">
		</div>
		<div class="col-md-2 m-b-15">
			<button id="search" class="btn btn-sm" style="" >조 회</button>
			<button class="btn btn-sm" id="newBBS">신 규</button>
		</div>
	</div>
	<div class="clearfix"></div> 
	<div class="table-responsive" style="overflow: hidden; outline: none;">
		<table class="table table-bordered table-hover tile" id="data_tableW" >
			<caption></caption>
			<colgroup>
				<col width="8%"/>
				<col width="15%" />
				<col width="*" />
				<col width="15%" /> 
				<col width="15%" /> 
			</colgroup>
			<thead>
			<tr>
				<th>번호</th>
				<th>썸네일</th>
				<th>제목</th>
				<th>등록일</th>
				<th>조회수</th>
			</tr>
			</thead>
			<tbody>
				<%
				int list_count_1 = list.size();
				if (list == null || list_count_1 == 0) {
				
				%>
			<tr>
				<td colspan="5">해당 데이터가 존재하지 않습니다.</td>
			</tr>
				<%
				}
				if( list != null){
					Map<String , Object> bbsDataInfo;
					
					int totalRecordCnt = paginationInfo.getTotalRecordCount();
					int firstRecordIndex = paginationInfo.getFirstRecordIndex();
									
					int value = totalRecordCnt - firstRecordIndex;
					
					for(int i=0; i<list.size(); i++){
						bbsDataInfo = list.get(i);
						int rownum = value - i;
						
						text_idx = String.valueOf(bbsDataInfo.get("textIdx"));
						title    = StringUtil.nvl(bbsDataInfo.get("title"),"");
						
						if( bbsDataInfo.get("regDt") != null ){
							reg_dt = bbsDataInfo.get("regDt").toString();
						}	
						hits = String.valueOf(bbsDataInfo.get("hits"));
%>
				<tr style="height:67px;">
				 <td><%=rownum %></td>
				 <td>
				 	<img src="/vod/file/getImage.do?data_idx=<%=bbsDataInfo.get("textIdx")%>&file_gubun=CONTENTS_TEXT" style="border:1px solid #cecece;width:55px; height:50px; padding-top:3.5px;" />
				 </td>
				 <td style="text-align: left;"><a href="#" onclick="javascript:fn_view('<%=text_idx%>');"><%=title%></a></td>
				 <td><%=reg_dt%></td>
				 <td><%=hits%></td>
				</tr>
<%						
					}
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
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script>
$(document).ready(function() { 
	$('#search').click(function(){search()})
	$('#newBBS').click(function(){fn_regit()})
	
	$("#search_type").val("<%=StringUtil.nvl(param.get("best_select"))%>");
	$("#search_keyword").val("<%=StringUtil.nvl(param.get("search_keyword"))%>");
}); 
  

function search(){ 
	var f = document.frm;	
	f.action = "/contentsText/list.do";
	f.submit();
}
function fn_regit() {
	var f = document.frm;
	$('#text_idx').val('');
	f.action = "/contentsText/write.do";
	f.submit();
}

function fn_view(textIdx) {
	var f = document.frm;
	$('#text_idx').val(textIdx);
	f.action = "/contentsText/detail.do";
	f.submit();
}

function fn_page(pageNo) {
	$("#frm").attr("action","/contentsText/list.do");
	$("#pageIndex").val(pageNo);
	$("#frm").submit();
}
</script>
</body>
</html>