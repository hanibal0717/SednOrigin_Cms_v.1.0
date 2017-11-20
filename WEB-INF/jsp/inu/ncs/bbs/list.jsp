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
<%@ include file="/WEB-INF/jsp/inu/ncs/bbs/bbs_master_info.jsp" %>
<%
			/**
			* @JSP Name : list.jsp
			* @Description : 문의게시판
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
List<Map<String , Object>> notice_list = (List)request.getAttribute("notice_list");

String dataIdx = "";
String attachIdx = "";
String orgFileNm = "";
String actPage  = "";

String title = "";
String regNm = "";
String privateYn = "";
String regDt = "";
String modDt = "";
String cont = "";
String noticeYn = "";
String fileCnt  = "";
String refCnt = ""; 
String hits   = "";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>게시판관리</title>
<meta name="decorator" content="defaultPage">
<!-- 
<link type="text/css" rel="stylesheet" href="<c:url value='/js/axisj/ui/arongi/AXJ.min.css'/>">
<script type="text/javascript" src="<c:url value='/js/axisj/dist/AXJ.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXGrid.js'/>"></script> -->
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script> 
$(document).ready(function() { 
	//fnObj.pageStart(true);
		
	//search();
	
	$('#search').click(function(){search()})
	$('#save').click(function(){save()})
	$('#remove').click(function(){remove()})
	$('#newBBS').click(function(){fn_regit()})
	
}); 
  

function search(){ 
	 
	//var param = '&bbs_mst_idx='+$('#bbs_mst_idx').val();
	/*
    	myGrid.setList({
        	ajaxUrl:"/ncs/bbs/bbsListAjax.do", ajaxPars:param, onLoad:function(){
        	}
    	});
	*/
	//
	//var f = document.frm;	
	//f.action = "/ncs/bbs/list.do";
	//f.submit();
}
function save(){
	if( $('#title').val() == '' || $('#title').val() == null ) {
		alert('제목을 입력해주세요.')
		return;
	} else if( $('#reg_nm').val() == '' ) {
		alert('작성자명을 입력해주세요.')
		return;
	} 
	
	$.ajax({
	    url:'/ncs/bbs/writeProc.do',
	    type:'POST',
	    data: $('#frm').serialize(),
	    dataType: 'json',
	    success: function( data) {
	    	alert(data.msg);
	        myGrid.reloadList();
	    }
	});
}
function remove(){
	if( $('#data_idx').val() == '' ){
		alert("선택된 목록이 없습니다. 삭제하시려는 목록을 체크하세요.");
		return;
	}
	if( confirm("정말 삭제 하시겠습니까?")){
		$.ajax({
		    url:'/ncs/bbs/delProc.do',
		    type:'POST',
		    data: $('#frm').serialize(),
		    dataType: 'json',
		    success: function( data) {
		    	alert(data.msg);
		        myGrid.reloadList();
		    }
		});
	}
};
function fn_regit() {
	/*
	$('#title').val('');
	$('#reg_nm').val('');
	$('#cont').val('');  
	$('#data_idx').val('');
	$("input[name=notice_yn]:checkbox").attr("checked", false);
	*/
	
	var f = document.frm;
	$('#data_idx').val('');
	f.action = "/ncs/bbs/write.do";
	f.submit();
}

function fn_view(dataIdx) {
	/*
	$('#title').val('');
	$('#reg_nm').val('');
	$('#cont').val('');  
	$('#data_idx').val('');
	$("input[name=notice_yn]:checkbox").attr("checked", false);
	*/
	
	var f = document.frm;
	$('#data_idx').val(dataIdx);
	f.action = "/ncs/bbs/detail.do";
	f.submit();
}
function fn_page(pageNo) {
	//console.log("fn_page");
	//console.log(pageNo);
	$("#frm").attr("action","/ncs/bbs/list.do");
	$("#pageIndex").val(pageNo);
	$("#frm").submit();
}
</script>
</head>
<body>
<h2><%=bbsNm %></h2>
<p class="location"> 게시판관리 > <%=bbsNm %> 목록</p>

<form name="frm" id="frm" method="post" >
	<input type="hidden" name="bbs_mst_idx" id="bbs_mst_idx" value="<%=bbsMstIdx %>" />
	<input type="hidden" name="data_idx" id="data_idx" value="" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex }" />
	 
	<section> 
		<p class="tar Mbo11">
			<!-- <button id="search" class="btn_searchTbl06 prevent" style="" >조회</button> -->
			<span class="btn_type01 btn" id="newBBS"><a href="#">신규</a></span>
		</p>
		<div style="border-left:2px solid #cdcdcd; border-right:2px solid #cdcdcd; border-bottom:2px solid #cdcdcd; border-top:2px solid #cdcdcd;">
			<table class="data_tableW" id="data_tableW" summary="" >
				<caption></caption>
				<colgroup>
					<col width="5%"/>
					<col width="*" />
					<col width="7%" />
					<col width="12%" />
					<col width="14%" />
					<col width="10%" />
				</colgroup>
				<thead>
				<tr style="background-color: blue;">
					<th>번호</th>
					<th>제목</th>
					<th>파일</th>
					<th>작성자</th>
					<th>작성일</th>
					<th>조회수</th>
				</tr>
				</thead>
				<tbody> 
				<%
				if( notice_list != null){
					Map<String , Object> bbsDataInfo;
					for(int i=0; i<notice_list.size(); i++){
						bbsDataInfo = notice_list.get(i);
						dataIdx   = StringUtil.nvl(bbsDataInfo.get("dataIdx"),"");
						title     = StringUtil.nvl(bbsDataInfo.get("title"),"");
						regNm     = StringUtil.nvl(bbsDataInfo.get("regNm"),"");
						privateYn = StringUtil.nvl(bbsDataInfo.get("privateYn"),"");
						if( bbsDataInfo.get("regDt") != null ){
							regDt = bbsDataInfo.get("regDt").toString().substring(0,10);
						}
						if( bbsDataInfo.get("modDt") != null ){
							modDt = bbsDataInfo.get("modDt").toString().substring(0,10);
						}
						cont     = StringUtil.nvl(bbsDataInfo.get("cont"),"");
						noticeYn = StringUtil.nvl(bbsDataInfo.get("noticeYn"),"");
						
						fileCnt = String.valueOf(bbsDataInfo.get("fileCnt"));
						refCnt  = String.valueOf(bbsDataInfo.get("refCnt"));
						hits    = String.valueOf(bbsDataInfo.get("hits"));
						
%>
				<tr>
				 <td>공지</td>
				 <td style="text-align:left;"><a href="#" onclick="javascript:fn_view('<%=dataIdx%>');"><%= title%></a></td>
				 <td><%= Integer.parseInt(fileCnt) > 0 ? "Y": "N"%></td>
				 <td><%= regNm%></td>
				 <td><%= regDt%></td>
				 <td><%= hits%></td>
				</tr>
<%						
					}
				}
				%>
				<c:set var="descNo" value="${ paginationInfo.totalRecordCount - (paginationInfo.currentPageNo-1)*paginationInfo.recordCountPerPage }" />
				<%
				if( list != null){
					Map<String , Object> bbsDataInfo;
					for(int i=0; i<list.size(); i++){
						bbsDataInfo = list.get(i);
						dataIdx   = StringUtil.nvl(bbsDataInfo.get("dataIdx"),"");
						title     = StringUtil.nvl(bbsDataInfo.get("title"),"");
						regNm     = StringUtil.nvl(bbsDataInfo.get("regNm"),"");
						privateYn = StringUtil.nvl(bbsDataInfo.get("privateYn"),"");
						if( bbsDataInfo.get("regDt") != null ){
							regDt = bbsDataInfo.get("regDt").toString().substring(0,10);
						}
						if( bbsDataInfo.get("modDt") != null ){
							modDt = bbsDataInfo.get("modDt").toString().substring(0,10);
						}
						cont     = StringUtil.nvl(bbsDataInfo.get("cont"),"");
						noticeYn = StringUtil.nvl(bbsDataInfo.get("noticeYn"),"");
						
						fileCnt = String.valueOf(bbsDataInfo.get("fileCnt"));
						refCnt  = String.valueOf(bbsDataInfo.get("refCnt"));
						hits    = String.valueOf(bbsDataInfo.get("hits"));
						
%>
				<tr>
				 <td>${descNo }</td>
				 <td style="text-align:left;"><a href="#" onclick="javascript:fn_view('<%=dataIdx%>');"><%= title%></a> 
				 </td>
				 <td><%= Integer.parseInt(fileCnt) > 0 ? "Y": "N"%></td>
				 <td><%= regNm%></td>
				 <td><%= regDt%></td>
				 <td><%= hits%></td>
				</tr>
				<c:set var="descNo" value="${ descNo - 1 }" />
<%						
					}
				}
				%>
				
				</tbody>
			</table>
			</div>
			<div class="paging">
				 <ui:pagination paginationInfo = "${paginationInfo}"  type="image" jsFunction="fn_page"  />
			</div>
		 
 	</section>
</form> 	
</body>
</html>