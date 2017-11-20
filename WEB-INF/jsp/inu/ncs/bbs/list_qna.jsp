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
String hits = "";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>게시판관리</title>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script>
<% 
/* 그리드
var pageID = "AXGrid";
var myGrid = new AXGrid();

var fnObj = {
	pageStart: function(){

	var getColGroup = function(){ return [
 
{key:"rnum", label:"No", width:"45", align:"center"},
{key:"title", label:"제목", width:"*", align:"left"},
{key:"fileCnt", label:"파일", width:"45", align:"center"},
{key:"refCnt", label:"답변", width:"45", align:"center"},
{key:"regNm", label:"작성자", width:"120", align:"center"},
{key:"regDt", label:"작성일", width:"100", align:"center"},
{key:"hits", label:"조회수", width:"100", align:"center"}];	
	};
	myGrid.setConfig({
		targetID : "AXGridTarget",
		sort: false, //정렬을 원하지 않을 경우 (tip
		colHeadTool: true, // column tool use
		//fitToWidth: true, // 너비에 자동 맞춤
		passiveMode:true,
		passiveRemoveHide:false,		   
		colGroup : getColGroup(),
		colHeadAlign: "center", // 헤드의 기본 정렬 값. colHeadAlign 을 지정하면 colGroup 에서 정의한 정렬이 무시되고 colHeadAlign : false 이거나 없으면 colGroup 에서 정의한 속성이 적용됩니다.
		body : {
			onclick:function(idx, item){
				//setItem(this.item);
				
				//$('#title').val(this.item.title);
				//$('#reg_nm').val(this.item.regNm);
				//$('#notice_yn').val(this.item.noticeYn);
				//$('#cont').val(this.item.cont);
				//$('#data_idx').val(this.item.dataIdx);
				
				fn_view(this.item.dataIdx);
			},
		    addClass: function(){
		        // red, green, blue, yellow, white, gray
		        if(this.index % 2 == 0){
		            return "gray";
		        }else{
		            return "white";
		        }
		    },
		    page: {
				paging:false,
				status:{formatter: null}
		    },
		   
		}
	});
	
	}
};

*/
%>

$(document).ready(function() { 
	
	$('#search').click(function(){search()})
	$('#save').click(function(){save()})
	$('#remove').click(function(){remove()})
	$('#newBBS').click(function(){fn_regit()})
	
}); 
  

function search(){ 
	 
	var param = '&bbs_mst_idx='+$('#bbs_mst_idx').val();
	
	var f = document.frm;	
	f.action = "/ncs/bbs/list.do";
	f.submit();
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
	var f = document.frm;
	$('#data_idx').val('');
	f.action = "/ncs/bbs/write.do";
	f.submit();
}

function fn_view(dataIdx) {
	var f = document.frm;
	$('#data_idx').val(dataIdx);
	f.action = "/ncs/bbs/detail.do";
	f.submit();
}
function fn_page(pageNo) {
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
	<input type="hidden" name="sqlId" id="sqlId" value=""/>
	<input type="hidden" name="gridData" id="gridData" value="" />
	<input type="hidden" name="guestSearch" id="guestSearch" value="" />
	<input type="hidden" name="bbs_mst_idx" id="bbs_mst_idx" value="<%=bbsMstIdx %>" />
	<input type="hidden" name="data_idx" id="data_idx" value="" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex }" />
	 
	<section> 
		<p class="tar Mbo11">
			<button id="search" class="btn_searchTbl06 prevent" style="" >조회</button>
			<span class="btn_type01 btn" id="newBBS"><a href="#">신규</a></span>
		</p>
		
		<div style="border-left:2px solid #cdcdcd; border-right:2px solid #cdcdcd; border-bottom:2px solid #cdcdcd; border-top:2px solid #cdcdcd;">
			<table class="data_tableW" id="data_tableW" summary="" >
				<caption></caption>
				<colgroup>
					<col width="5%"/>
					<col width="*" />
					<col width="7%" />
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
					<th>답변</th>
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
				 <td></td>
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
				 <td style="text-align:left;"><a href="#" onclick="javascript:fn_view('<%=dataIdx%>');"><%= title%></a></td>
				 <td><%= Integer.parseInt(fileCnt) > 0 ? "Y": "N"%></td>
				 <td><%= Integer.parseInt(refCnt) > 0 ? "Y": "N"%></td>
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