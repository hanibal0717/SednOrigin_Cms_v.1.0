<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="vcms.common.file.util.UvFileUtil"%>
<%@page import="vcms.ncs.util.VodDataUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%@page import="vcms.common.egov.EgovUserInfoVO" %>
<%
			/**
			* @JSP Name : slidingBannerDetail.jsp
			* @Description : 슬라이딩 배너 뷰 페이지
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

String modeType = StringUtil.nvl(request.getParameter("modeType"),"");

List<Map<String , Object>> bbsDataFile  = (List)request.getAttribute("bbsDataFile");
Map<String , Object> bbsDataInfo = (Map)request.getAttribute("bbsDataInfo");
List<Map<String , Object>> bbsDataFile3 = (List)request.getAttribute("bbsDataFile3");

String fileGubun = "BN";
String attachUseYn = "Y";
int  attachCnt = 1;

String bnIdx = "";
String attachIdx = "";
String orgFileNm = "";
String actPage  = "";

String title = "";
String cont = "";
String regNm = "";
String privateYn = "";
String regDate = "";
String regId = "";
String regIp = "";
String modDate = "";
String modId = "";
String modIp = "";
String startDate = "";
String startHh = "";
String startMm = "";
String endDate = "";
String endHh = "";
String endMm = "";
String linkUrl = "";
String useYn = "";
String delYn = "";
String fileCnt  = "";
String atch_file_id = "";
String reg_nm = "";

String msg = "등록"; 

EgovUserInfoVO user_info = (EgovUserInfoVO)request.getAttribute("user"); 
if( user_info != null ){ 	 
	reg_nm = user_info.getUserNm();	 
}

if( bbsDataInfo == null ){
	modeType = "ins";
	msg = "등록";
} else {
	
	if( !"reply".equals(modeType) && !"replyM".equals(modeType) ){ 
		modeType = "mod";
		msg = "수정";
	}
	
	bnIdx       = String.valueOf(bbsDataInfo.get("bnIdx"));
	title     = StringUtil.nvl(bbsDataInfo.get("title"),"");
//	reg_nm        = StringUtil.nvl(bbsDataInfo.get("regNm"),"");
	
	if( bbsDataInfo.get("regDate") != null ){
		regDate = bbsDataInfo.get("regDate").toString();
	}
	if( bbsDataInfo.get("modDate") != null ){
		modDate = bbsDataInfo.get("modDate").toString();
	}
	cont     = StringUtil.nvl(bbsDataInfo.get("cont"),"");
	startDate  = StringUtil.nvl(bbsDataInfo.get("startDate"),"");
	startDate = startDate.substring(0, 4)+"-"+startDate.substring(4, 6)+"-"+startDate.substring(6, 8);
	startHh  = StringUtil.nvl(bbsDataInfo.get("startHh"),"");
	
	if (startHh.length() < 2 && !"0".equals(startHh)) {
		startHh = "0" + startHh;
	}
	
	startMm  = StringUtil.nvl(bbsDataInfo.get("startMm"),"");
	
	endDate  = StringUtil.nvl(bbsDataInfo.get("endDate"),"");
	endDate = endDate.substring(0, 4)+"-"+endDate.substring(4, 6)+"-"+endDate.substring(6, 8);
	endHh  = StringUtil.nvl(bbsDataInfo.get("endHh"),"");
	
	if (endHh.length() < 2 && !"0".equals(endHh)) {
		endHh = "0" + endHh;
	}
	
	endMm  = StringUtil.nvl(bbsDataInfo.get("endMm"),"");
	
	linkUrl = StringUtil.nvl(bbsDataInfo.get("linkUrl"),"");
	useYn = StringUtil.nvl(bbsDataInfo.get("useYn"),"");
	delYn = StringUtil.nvl(bbsDataInfo.get("delYn"),"");
}

String orgModeType = modeType; 

pageContext.setAttribute("LF", "\n");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script> 
$(document).ready(function() {
	
/* 	if ($('#authResult').val() == "N") {
		$('#modify').hide();
		$('#remove').hide();
	} */
	
	$('#search').click(function(){search()})
	$('#modify').click(function(){modify()})
	$('#remove').click(function(){remove()})
	
	$('#search2').click(function(){search()})
	$('#modify2').click(function(){modify()})
	$('#remove2').click(function(){remove()})
}); 
  
function search(){  
	var f = document.frm;
	$('#bnIdx').val('');
	f.action = "/banner/slidingBanner.do";
	f.submit();
}
function modify(){ 
	var f = document.frm; 
	$("#modeType").val("mod");
	f.action = "/banner/writeSlidingBanner.do";
	f.submit();
}
function remove(){
	if( $('#bnIdx').val() == '' ){
		alert("선택된 목록이 없습니다. 삭제하시려는 목록을 체크하세요.");
		return;
	}
	if( confirm("정말 삭제 하시겠습니까?")){
		$.ajax({
		    url:'/banner/deleteBanner.do',
		    type:'POST',
		    data: $('#frm').serialize(),
		    dataType: 'json',
		    success: function( data) {
		    	alert(data.msg);
		    	search(); 
		    }
		});
	}
}; 
 
var tempWidth = -1;
var imgWidth  = 0;
var imgHeight = 0;
var imgMaxWidth  = 0;    
var imgIndexNum  = 0;

function setImgFit(imgObj, maxWidth, imageIndex) {
    imgMaxWidth = maxWidth;
    imgIndexNum = imageIndex;
    imgFit(imgObj);
}
function imgFit(imgObj, maxWidth) {    
    imgWidth  = imgObj.width;
    imgHeight = imgObj.height;        
    imgWidth  = imgObj.width;        
    if ( imgWidth != 0 ) {            
        if ( tempWidth == imgWidth ) {
            if (imgObj.width > imgMaxWidth) {
                imgObj.width = imgMaxWidth;
            }
        } else {
            tempWidth = imgWidth;
            setTimeout("imgFit(document.displayImg"+imgIndexNum+");", 50);
        }            
    } else {
        tempWidth = imgWidth;
        setTimeout("imgFit(document.displayImg"+imgIndexNum+");", 50);
    }
}
function fn_modify(bn_idx){
	$("#modeType").val("mod");
	$("#bnIdx").val(bn_idx);
	$('#frm').attr('action' , '/banner/writeSlidingBanner.do');
	$('#frm').submit();
}

</script>
</head>
<body>
<ol class="breadcrumb hidden-xs">
	<li>배너 관리</li>
    <li>메인 상단 이미지</li>
</ol>
<h4 class="page-title">메인 상단 이미지</h4>

<form name="frm" id="frm" method="post" >
	<input type="hidden" name="file_gubun" id="file_gubun" value="<%=fileGubun %>" />
	<input type="hidden" name="bnIdx" id="bnIdx" value="<%=bnIdx %>" />
	<input type="hidden" name="modeType" id="modeType" value="" />
	<input type="hidden" name="regId" id="regId" value="<%=regId %>" />
	<input type="hidden" name="authResult" id="authResult" value="${authResult}" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	<input type="hidden" name="search_keyword" id="search_keyword" value="${search_keyword}" />
	<input type="hidden" name="search_type" id="search_type" value="${search_type}" />
	 
	<div class="row m-t-15 text-right m-b-10">
			<button id="search" class="btn-sm btn" style="">목 록</button>
			<c:set var="authResult" value="${authResult}"/>
			<c:choose>
				<c:when test="${authResult == 'Y'}">
					<button class="btn-sm btn" id="modify">수 정</button>
					<button class="btn-sm btn" id="remove">삭 제</button>
				</c:when>
				<c:when test="${authResult == 'N'}">
				</c:when>
			</c:choose> 
	</div>
	<div class="table-responsive overflow" style="overflow: hidden; outline: none;">
		<table class="table table-bordered tile">
			<caption></caption>
			<colgroup>
				<col width="20%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th> 제목 </th>
				<td>
					<%=title %>
				</td>
			<tr>
				<th> 작성자</th>
				<td>
					<%=reg_nm %>
				</td>
			</tr>
			<tr>
				<th> 서비스 시작 날짜/시간 </th>
				<td> <%=startDate %> <%=startHh %>:<%=startMm %></td>
			</tr>
			<tr>
				<th> 서비스 종료 날짜/시간 </th>
				<td> <%=endDate %> <%=endHh %>:<%=endMm %></td>
			</tr>
			<tr>
				<th>내용</th>
				<td> 
					<%=cont %>
				</td>
			</tr>
									
			<tr>
				<th scope="col">배너 (PC)</th>
				<td colspan="3" class="image_size">
				<% if( bbsDataFile != null && bbsDataFile.size() > 0 ) {%>
					<%
					Map<String , Object> bbsDataFileNode;
					for(int i=0; i<bbsDataFile.size(); i++){
						bbsDataFileNode = bbsDataFile.get(i);
					%>
					<img src="/UPLOAD/BN/<%=bbsDataFileNode.get("fileNm")%>">
					<%
					}
					%>
				<% }  %>			
				</td>
			</tr>
			
			<tr>
				<th scope="col">배너 (Background)</th>
				<td colspan="3" class="image_size">
				<% if( bbsDataFile3 != null && bbsDataFile3.size() > 0 ) {%>
					<%
					Map<String , Object> bbsDataFileNode3;
					for(int i=0; i<bbsDataFile3.size(); i++){
						bbsDataFileNode3 = bbsDataFile3.get(i);
					%>
					<img src="/UPLOAD/BN_B/<%=bbsDataFileNode3.get("fileNm")%>">
					<%
					}
					%>
				<% }  %>
				</td>
			</tr>
			<tr>
				<th scope="col">링크 URL </th>
				<td>
					<%=linkUrl %>
				</td> 
			</tr>
			<tr>
				<th>사용여부</th>
				<td><%=useYn %></td>
			</tr>				

		</table>
	</div> 
	
	<div class="row m-t-15 text-right m-b-10">
		<button id="search2" class="btn-sm btn" style="">목 록</button>
		<c:set var="authResult" value="${authResult}"/>
		<c:choose>
			<c:when test="${authResult == 'Y'}">
				<button class="btn-sm btn" id="modify2">수 정</button>
				<button class="btn-sm btn" id="remove2">삭 제</button>
			</c:when>
			<c:when test="${authResult == 'N'}">
			</c:when>
		</c:choose> 
	</div>
</form>
</body>
</html>