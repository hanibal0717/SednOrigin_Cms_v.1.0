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
			* @JSP Name : mainBanner.jsp
			* @Description : 메인 슬라이드 배너 List
			* @Modification Information
			* 
			*       수정일         수정자         수정내용
			*  ----------------------------------------------
			*	2015.08.28	김도현		최초생성
			*
			* author 개발팀 
			* Copyright (C) 2011 by MOPAS  All right reserved.
			*/
%>
<%
String bbsMstIdx = "BM0000000001";
String fileGubun = "BN";
String attachUseYn = "Y";
int  attachCnt = 1;
String modeType = "";
List<Map<String , Object>> list = (List)request.getAttribute("list");
String dataIdx = "";
String attachIdx = "";
String orgFileNm = "";
String actPage  = "";

String title = "";
String regNm = "";
String bnSeq = "";
String privateYn = "";
String regDate = "";
String startDate = "";
String startHh = "";
String startMm = "";
String endDate = "";
String endHh = "";
String endMm = "";
String useYn = "";
String fileCnt  = "";

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
<title>배너관리</title>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script>

$(document).ready(function() { 
	
	$('#search').click(function(){search()})
	$('#save').click(function(){save()})
	$('#remove').click(function(){remove()})
	$('#write').click(function(){fn_regit()})
	
	$('#search_type').val('<%=search_type%>');
	
}); 
  

function search(){ 
	var f = document.frm;	
	f.action = "/banner/mainBanner.do";
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
	
	$('#title').val('');
	$('#reg_nm').val('');
	$('#cont').val('');  
	$('#data_idx').val('');
	
	
	var f = document.frm;
	f.action = "/banner/writeMainBanner.do";
	f.submit();
}

function fn_view(dataIdx) {

	var f = document.frm;
	$('#bnIdx').val(dataIdx);
	f.action = "/banner/detailMainBanner.do";
	f.submit();
}

function fn_page(pageNo) {
	$("#frm").attr("action","/banner/mainBanner.do");
	$("#pageIndex").val(pageNo);
	$("#frm").submit();
}

function showImgPop(dataIdx, title) {
	
	documentURL = "/banner/showImgPop.do?dataIdx="+dataIdx+"&file_gubun=BN";
	windowName = "이미지보기";
	intXOffset = 140;
	intYOffset = 140;
	
	objWindow = window.open(documentURL,windowName, "toolbar=no");
	objWindow.moveTo(intXOffset, intYOffset);
	
}
</script>
</head>
<body>
<ol class="breadcrumb hidden-xs">
	<li>배너 관리</li>
    <li>메인 슬라이드 이미지</li>
</ol>
<h4 class="page-title">메인 슬라이드 이미지</h4>

<form name="frm" id="frm" method="post" >
	<input type="hidden" name="data_idx" id="data_idx" value="" />
	<input type="hidden" id="bnIdx" name="bnIdx" value=""/>
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
			<button class="btn-sm btn" id="write">신 규</button>
		</div>
	</div>
	<div class="clearfix"></div> 
	<div class="table-responsive overflow" style="overflow: hidden; outline: none;">
		<table class="table table-bordered table-hover tile" id="data_tableW" >
			<caption></caption>
			<colgroup>
				<col width="5%" />
				<col width="9%" />
				<col width="*" />
				<col width="14%" />
				<col width="14%" />
				<col width="5%" />
				<col width="8%" />
				<col width="12%" />
			</colgroup>
			<thead>
			<tr>
				<th>번호</th>
				<th>이미지</th>
				<th>제목</th>
				<th>시작일</th>
				<th>종료일</th>
				<th>순서</th>
				<th>서비스여부</th>
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

				if( list != null  && list.size() > 0){
					Map<String , Object> bbsDataInfo;
					
					int totalRecordCnt = paginationInfo.getTotalRecordCount();
					int firstRecordIndex = paginationInfo.getFirstRecordIndex();
									
					int value = totalRecordCnt - firstRecordIndex;
					
					for(int i=0; i<list.size(); i++){
						bbsDataInfo = list.get(i);
						int rownum = value - i;
						
						dataIdx   = String.valueOf(bbsDataInfo.get("bnIdx"));
						title     = StringUtil.nvl(bbsDataInfo.get("title"),"");
						if( bbsDataInfo.get("bnSeq") != null ){
							bnSeq = bbsDataInfo.get("bnSeq").toString();
						}
//						regNm     = StringUtil.nvl(bbsDataInfo.get("regNm"),"");
//						privateYn = StringUtil.nvl(bbsDataInfo.get("privateYn"),"");
						if(bbsDataInfo.get("startDate") !=null && bbsDataInfo.get("startHh") != null && bbsDataInfo.get("startMm") != null)
						{
							startDate = bbsDataInfo.get("startDate").toString();
							startDate = startDate.substring(0, 4)+"-"+startDate.substring(4, 6)+"-"+startDate.substring(6, 8);
							startHh = bbsDataInfo.get("startHh").toString();
							if (startHh.length() < 2 && !"0".equals(startHh)) {
								startHh = "0" + startHh;
							}
							startMm = bbsDataInfo.get("startMm").toString();
						}
						
						if(bbsDataInfo.get("endDate") !=null && bbsDataInfo.get("endHh") != null && bbsDataInfo.get("endMm") != null)
						{
							endDate = bbsDataInfo.get("endDate").toString();
							endDate = endDate.substring(0, 4)+"-"+endDate.substring(4, 6)+"-"+endDate.substring(6, 8);
							endHh = bbsDataInfo.get("endHh").toString();
							if (endHh.length() < 2 && !"0".equals(endHh)) {
								endHh = "0" + endHh;
							}
							endMm = bbsDataInfo.get("endMm").toString();
						}
						
						if( bbsDataInfo.get("regDate") != null ){
							regDate = bbsDataInfo.get("regDate").toString();
							regDate = regDate.substring(0, 10);
						}
						
						if( bbsDataInfo.get("useYn") != null ){
							useYn = bbsDataInfo.get("useYn").toString();
						}

						
%>
			<tr>
			 <td><%=rownum %></td>
			 <td>
				 <img src="/vod/file/getImage.do?data_idx=<%=dataIdx%>&file_gubun=BN" style="cursor:pointer; width:45px; height:35px; padding-top:4px;" onclick="showImgPop('<%=dataIdx%>');" />
			 </td>
			 <td style="text-align:left;"><a href="#" onclick="javascript:fn_view('<%=dataIdx%>');"><%= title%></a></td>
			 <td><%=startDate %> <%=startHh %>:<%=startMm %></td>
			 <td><%=endDate %> <%=endHh %>:<%=endMm %></td> 
			 <td><%=bnSeq %>
			 <td><%=useYn %></td>
			 <td><%=regDate %></td> 
			</tr>
<%						
				}
			} else {
%>				
			 <tr>
			 <td colspan="7"> 해당하는 데이터가 존재하지 않습니다.</td>
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