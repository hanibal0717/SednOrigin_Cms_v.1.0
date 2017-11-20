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
			* @JSP Name : list.jsp
			* @Description : LIVE 방송관리
			* @Modification Information
			* 
			*       수정일         수정자         수정내용
			*  ----------------------------------------------
			*	2015.08.28	김승준	최초생성
			*
			* author 개발팀 
			* Copyright (C) 2011 by MOPAS  All right reserved.
			*/
%>
<%
List<Map<String , Object>> list = (List)request.getAttribute("list");
List<Map<String , Object>> channelList = (List)request.getAttribute("channelList");

PaginationInfo paginationInfo = null;
paginationInfo = (PaginationInfo)request.getAttribute("paginationInfo");

String search_type = (String)request.getAttribute("search_type");
String search_keyword = (String)request.getAttribute("search_keyword");

if (search_keyword == null) {
	search_keyword = "";
}

String live_idx  = "";
String broad_nm  = "";
String startDate = "";
String startDateRslt = "";
String startHH = "";
String startMM = "";
String endDate = "";
String endDataRslt = "";
String endHH = "";
String endMM = "";
String member_yn = "";
String screen_gubun = "";
String reg_dt = "";
String ch_nm = "";
%>
<meta name="decorator" content="defaultPage">
</head>
<body>
<ol class="breadcrumb hidden-xs">
    <li>LIVE 방송관리</li>
    <li>목록</li>
</ol>
<h4 class="page-title">LIVE 방송관리</h4>

<form name="frm" id="frm" method="post" >
	<input type="hidden" name="live_idx" id="live_idx" value="" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	 
	<div class="row m-t-15">
		<div class="col-md-1 m-b-15">
			<select id="search_type" name="search_type" class="select">
				<option value="">전체</option>
				<%
				if(channelList != null){
					Map<String , Object> channelListInfo;
					for(int i = 0; i < channelList.size(); i++){
						channelListInfo = channelList.get(i);
					%>
					<option value="<%=String.valueOf(channelListInfo.get("chIdx"))%>"><%=String.valueOf(channelListInfo.get("chNm"))%></option>
					<%
					}
				}
				%>
			</select>
		</div>
		<div class="col-md-2 m-b-15">
			<input id="search_keyword" name="search_keyword" class="form-control input-sm" placeholder="방송 제목" value="<%=search_keyword%>" />
		</div>
		<div class="col-md-2 m-b-15">
			<button id="search" class="btn btn-sm" style="" >조 회</button>
			<button class="btn-sm btn" id="wrtie">신규</button>
		</div>
	</div>
	<div class="clearfix"></div> 
	<div class="table-responsive" style="overflow: hidden; outline: none;">
		<table class="table table-bordered table-hover tile" id="data_tableW" >
				<caption></caption>
				<colgroup>
					<col width="5%"/>
					<col width="10%" />
					<col width="*" />
					<col width="14%" />
					<col width="14%" />
					<col width="8%" />
					<col width="8%" />
					<col width="10%" />
				</colgroup>
				<thead>
				<tr>
					<th>번호</th>
					<th>채널명</th>
					<th>방송제목</th>
					<th>시작시간</th>
					<th>종료시간</th>
					<th>시청 허용 여부</th>
					<th>SD/HD</th>
					<th>등록일</th>
				</tr>
				</thead>
				<tbody>
				<%
				int list_count_1 = list.size();
				if (list == null || list_count_1 == 0) {
					
				%>
					<tr>
						<td colspan="8">해당 데이터가 존재하지 않습니다.</td>
					</tr>
				<%
				}
				if( list != null){
					Map<String , Object> liveBroadList;
					int totalRecordCnt = paginationInfo.getTotalRecordCount();
					int firstRecordIndex = paginationInfo.getFirstRecordIndex();
									
					int value = totalRecordCnt - firstRecordIndex;
					
					for (int i=0; i<list.size(); i++) {
						liveBroadList = list.get(i);
						int rownum = value - i;
						
						live_idx  = String.valueOf(liveBroadList.get("liveIdx"));
						broad_nm  = StringUtil.nvl(liveBroadList.get("broadNm"), "");
						startDate = StringUtil.nvl(liveBroadList.get("startDate"), "");
						startDateRslt = StringUtil.nvl(liveBroadList.get("startDateRslt"), "");
						startHH = StringUtil.nvl(liveBroadList.get("startHh"), "");
						startMM = StringUtil.nvl(liveBroadList.get("startMm"), "");
						endDate = StringUtil.nvl(liveBroadList.get("endDate"), "");
						endDataRslt = StringUtil.nvl(liveBroadList.get("endDateRslt"), "");
						endHH = StringUtil.nvl(liveBroadList.get("endHh"), "");
						endMM = StringUtil.nvl(liveBroadList.get("endMm"), "");
						member_yn = StringUtil.nvl(liveBroadList.get("memberYn"), "");
						screen_gubun = StringUtil.nvl(liveBroadList.get("screenGubun"), "");
						ch_nm = StringUtil.nvl(liveBroadList.get("chNm"), "");
						reg_dt = String.valueOf(liveBroadList.get("regDt"));
%>
				<tr>
					<td><%= rownum %></td>
					<td><%= ch_nm %></td>
					<td style="text-align:left;"><a href="#" onclick="javascript:fn_view('<%= live_idx %>');"><%= broad_nm %></a></td>
					<td><%= startDateRslt %></td>
					<td><%= endDataRslt %></td>
					<td><%= member_yn %></td>
					<td><%= screen_gubun %></td>
					<td><%= reg_dt %></td>
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
	$('#wrtie').click(function(){wrtie()});
	$('#search').click(function(){search()});
	
	$('#search_type').val(<%=search_type%>);
});
function wrtie() {
	var f = document.frm;
	f.action = "/liveBroadMng/write.do";
	f.submit();
}

function fn_view(liveIdx) {
	var f = document.frm;
	$('#live_idx').val(liveIdx);
	f.action = "/liveBroadMng/detail.do";
	f.submit();
}

function fn_page(pageNo) {
	$("#frm").attr("action","/liveBroadMng/list.do");
	$("#pageIndex").val(pageNo);
	$("#frm").submit();
}

function search(){
	var f = document.frm;	
	f.action = "/liveBroadMng/list.do";
	f.submit();
}
</script>
</body>
</html>