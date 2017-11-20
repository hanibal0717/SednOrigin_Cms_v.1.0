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
			* @JSP Name : mainBannerWrite.jsp
			* @Description : 메인 슬라이드 배너 등록/수정
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

List<Map<String , Object>> bbsDataFile  = (List)request.getAttribute("bbsDataFile");  // 썸네일
Map<String , Object> bbsDataInfo = (Map)request.getAttribute("bbsDataInfo");
List<Map<String , Object>> bbsDataFile2 = (List)request.getAttribute("bbsDataFile2"); //
String modeType = StringUtil.nvl(request.getParameter("modeType"),"");


String fileGubun = "BN";
String attachUseYn = "Y";
int  attachCnt = 1;


String bnIdx      	= "";
String title    	= "";
String cont     	= "";
String bnSeq 		= "";
String atch_file_id = "";
String startDate   	= "";
String startHh	   	= "";
String startMm		= "";
String endDate		= "";
String endHh		= "";
String endMm		= "";
String linkUrl		= "";
String regDate     	= "";
String regId       	= "";
String regNm       	= "";
String regIp       	= "";
String modDate     	= "";
String modId       	= "";
String modIp       	= "";
String delYn       	= "";

String msg = "등록"; 
String actPage = "";

EgovUserInfoVO user_info = (EgovUserInfoVO)request.getAttribute("user"); 
if( user_info != null ){ 	 
	regNm = user_info.getUserNm();	 
}

if( bbsDataInfo == null ){
	modeType = "ins";
	actPage = "/banner/insertMainBanner.do";
	msg = "등록";
} else {
	
	if( !"reply".equals(modeType) && !"replyM".equals(modeType) ){ 
		modeType = "mod";
		actPage = "/banner/modifyMainBanner.do";
		msg = "수정";
	}
	
	if(bbsDataInfo.get("bnIdx") != null)
	{
		bnIdx   = String.valueOf(bbsDataInfo.get("bnIdx"));	
	}
	title     = StringUtil.nvl(bbsDataInfo.get("title"),"");
	regNm     = StringUtil.nvl(bbsDataInfo.get("regNm"),"");

	if( bbsDataInfo.get("regDate") != null ){
		regDate = bbsDataInfo.get("regDate").toString();
	}
	if( bbsDataInfo.get("modDate") != null ){
		modDate = bbsDataInfo.get("modDate").toString();
	}
	cont     = StringUtil.nvl(bbsDataInfo.get("cont"),"");
	bnSeq = StringUtil.nvl(bbsDataInfo.get("bnSeq"),"");
	startDate  = StringUtil.nvl(bbsDataInfo.get("startDate"),"");
	startHh  = StringUtil.nvl(bbsDataInfo.get("startHh"),"");
	startMm  = StringUtil.nvl(bbsDataInfo.get("startMm"),"");
	
	endDate  = StringUtil.nvl(bbsDataInfo.get("endDate"),"");
	endHh  = StringUtil.nvl(bbsDataInfo.get("endHh"),"");
	endMm  = StringUtil.nvl(bbsDataInfo.get("endMm"),"");
	
	linkUrl = StringUtil.nvl(bbsDataInfo.get("linkUrl"),"");
	
}
String orgModeType = modeType;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script type="text/javascript" src="/js/jquery/jquery.ui.datepicker.js" charset="utf-8"></script>
<script type="text/javascript" src="<c:url value='/js/calendar_beans_v2.2.js'/>"></script>
<script language="JavaScript" src="/common/uploadify/uploadify.js"></script>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
<script> 
$(document).ready(function() { 
	   
	$('#search').click(function(){search()})
	$('#save').click(function(){save()})
	$('#remove').click(function(){remove()})
	$('#newGuest').click(function(){newGuest()})
	
	$('#search2').click(function(){search()})
	$('#save2').click(function(){save()})
	$('#remove2').click(function(){remove()})
	
}); 
  
function search(){  
	var f = document.frm;
	$('#bnIdx').val('');
	f.action = "/banner/mainBanner.do";
	f.submit();
}

function save(){
	if( $('#title').val() == '' || $('#title').val() == null ) {
		alert('제목을 입력해주세요.');
		$('#title').focus();
		return;
	}

	var startDt = $('#startDate').val();
	startDt = startDt.replace('/-/g', '');
	if(startDt == '' || startDt == null )
	{
		alert('서비스 시작 날짜를 입력해 주세요.');
		$('#startDate').focus();
		return;
	}else if(startDt.length != 8 || isNaN(startDt)){
		alert('서비스 시작 날짜를 형식에 맞게 입력해주세요.');
		return;
	}
	var endDt = $('#endDate').val();
	endDt = endDt.replace('/-/g', '');
	if(endDt == '' || endDt == null){
		alert('서비스 종료 날짜를 입력해 주세요.');
		$('#endDate').focus();
		return;
	}
	if(endDt.length != 8 || isNaN(endDt)){
		alert('서비스 종료 날짜를 형식에 맞게 입력해주세요.');
		return;
	}
	
	var f = document.frm; 
	f.action = "/banner/insertMainBanner.do";
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
$(function() {
    $( "#startDate" ).datepicker({
    	changeMonth: true, 
        changeYear: true,
        nextText: '다음 달',
        prevText: '이전 달', 
      	showButtonPanel: false, 
        currentText: '오늘 날짜', 
        closeText: '닫기', 
        dateFormat: "yymmdd",
        dayNames: ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
        dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
    });
});

$(function() {
    $( "#endDate" ).datepicker({
    	changeMonth: true, 
        changeYear: true,
        nextText: '다음 달',
        prevText: '이전 달', 
      	showButtonPanel: false, 
        currentText: '오늘 날짜', 
        closeText: '닫기', 
        dateFormat: "yymmdd",
        dayNames: ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
        dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
    });
});
</script>
</head>
<body>
<ol class="breadcrumb hidden-xs">
	<li>배너 관리</li>
    <li>메인 슬라이드 이미지</li>
</ol>
<h4 class="page-title">메인 슬라이드 이미지</h4>

<form name="frm" id="frm" method="post" enctype="multipart/form-data" >
	<input type="hidden" id="fileGubun" name="fileGubun" value="<%=fileGubun %>"/>
	<input type="hidden" id="bnIdx" name="bnIdx" value="<%=bnIdx%>"/>
	<input type="hidden" id="bnGubun" name="bnGubun" value="02" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	<input type="hidden" name="search_keyword" id="search_keyword" value="${search_keyword}" />
	<input type="hidden" name="search_type" id="search_type" value="${search_type}" />
	
	<% if( bbsDataFile == null || bbsDataFile.size() == 0 ) {%>	
		<input type="hidden" name="fileListCnt" value="0" />
	<% } %>
 
	<div class="row m-t-15 text-right m-b-10">
		<button id="search" class="btn-sm btn" style="" >목 록</button>
		<button class="btn-sm btn" id="save">저 장</button>
		<% if( "mod".equals(modeType)){ %>
		<button class="btn-sm btn" id="remove">삭 제</button>
		<% }  %>
	</div>
	 	  
	<div class="alert alert-danger">필수 입력 항목입니다.</div>
	<div class="table-responsive overflow" style="overflow: hidden; outline: none;">
		<table class="table table-bordered tile">
				<caption></caption>
				<colgroup>
					<col width="" />
					<col width="" />
				</colgroup>
				<tr>
					<!-- <th><span class="tx_red02">*배너구분</span></th>
					<td colspan="3">
						<select id=""><option></option></select>
					</td> -->
					<th><span class="text-danger">*</span>&nbsp;제목</th>
					<td colspan="3">
						<div class="col-md-12">
							<input type="text" name="title" id="title" maxlength="100" class="form-control input-sm" value="<%=title %>"/>
						</div>
					</td>
				</tr>
				<tr>
					<th>서비스 순서</th>
					<td>
						<div class="col-md-12">
							<select id="bnSeq" name="bnSeq" class="select">
								<c:forEach var="i" begin="1" end="10">
									<option value="${i }" <c:if test="${i == bbsDataInfo.bnSeq}">selected=selected</c:if> >${i }</option>
								</c:forEach>								
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th><span class="text-danger">*</span>서비스 시작 날짜/시간</th>
					<td colspan="3">
						<div class="col-md-2">
							<input type="text" readonly class="form-control input-sm" id="startDate" name="startDate" width="60px" value="<%=startDate%>"/>
						</div>
						<div class="col-md-1">
							<select id="startHh" name="startHh" class="select pull-left">
								<c:forEach var="i" begin="0" end="23">
									<option value="${i }" <c:if test="${i == bbsDataInfo.startHh}">selected=selected</c:if> >${i }</option>
								</c:forEach>								
							</select>
						</div>
						<label class="pull-left">시</label>
						<div class="col-md-1">
							<select id="startMm" name="startMm" class="select pull-left">
								<c:forEach var="i" begin="0" end="5">
									<option value="${i*10 }" <c:if test="${i*10 == bbsDataInfo.startMm}">selected=selected</c:if> >${i*10 }</option>
								</c:forEach>
							</select>
						</div>
						<label class="pull-left">분</label>
						<div class="col-md-2">날짜 예시) 20150101</div>
					</td>
				</tr>
				<tr>
					<th><span class="text-danger">*</span>서비스 종료 날짜/시간</th>
					<td colspan="3">
						<div class="col-md-2">
						<input type="text" readonly class="form-control input-sm" id="endDate" name="endDate" width="60px" value="<%=endDate%>"/>
						</div>
						<div class="col-md-1">
							<select id="endHh" name="endHh" class="select pull-left">
								<c:forEach var="i" begin="0" end="23">
									<option value="${i }" <c:if test="${i == bbsDataInfo.endHh}">selected=selected</c:if> >${i }</option>
								</c:forEach>								
							</select>
						</div>
						<label class="pull-left">시</label>
						<div class="col-md-1">
							<select id="endMm" name="endMm" class="select pull-left">
								<c:forEach var="i" begin="0" end="5">
									<option value="${i*10 }" <c:if test="${i*10 == bbsDataInfo.endMm}">selected=selected</c:if> >${i*10 }</option>
								</c:forEach>
							</select>
						</div>
						<label class="pull-left">분</label>
						<div class="col-md-2">날짜 예시) 20150101</div>
					</td>
					
				</tr>
				<tr>
					<th>내용</th>
					<td>
						<div class="col-md-12">
							<textarea id="cont" name="cont" class="form-control overflow" rows="5"><%=cont %></textarea>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="col">배너 이미지 (PC)<br />size : 1920*367</th>
					<td colspan="3">
						<div class="col-md-12">
						<%=UvFileUtil.drawSingleUpload("BN", "C", "*.jpg; *.png;", "10000MB")%>		
						<%
						if( bbsDataFile != null && bbsDataFile.size() > 0 ) {
							String rtn = "";
							String IMG_URL = "/UPLOAD/BN/";
							for (Map<String , Object> file : bbsDataFile) {
								if (StringUtil.nvl(file.get("fileType")).equals("IMG")) {
									rtn = rtn + "jsDrawImageFile('BN', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", " + file.get("dataIdx") + ", '" + IMG_URL + "', '" + file.get("mainImgFalg")+ "');\n";	
								} else {
									rtn = rtn + "jsDrawFile('BN', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", '" + file.get("fileType") + "', " + file.get("dataIdx") + ");\n";
								}
							}
						%>
						<script type="text/javascript">
						<%=rtn%>
						</script>
						<%
						}
						%>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="col">배너 이미지 (Mobile)<br />size : 720*494</th>
					<td colspan="3">
						<div class="col-md-12">
						<%=UvFileUtil.drawSingleUpload("BN_M", "M", "*.jpg; *.png;", "10000MB")%>		
						<%
						if( bbsDataFile2 != null && bbsDataFile2.size() > 0 ) {
							String rtn = "";
							String IMG_URL = "/UPLOAD/BN_M/";
							for (Map<String , Object> file : bbsDataFile2) {
								if (StringUtil.nvl(file.get("fileType")).equals("IMG")) {
									rtn = rtn + "jsDrawImageFile('BN_M', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", " + file.get("dataIdx") + ", '" + IMG_URL + "', '" + file.get("mainImgFalg")+ "');\n";	
								} else {
									rtn = rtn + "jsDrawFile('BN_M', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", '" + file.get("fileType") + "', " + file.get("dataIdx") + ");\n";
								}
							}
						%>
						<script type="text/javascript">
						<%=rtn%>
						</script>
						<%
						}
						%>
						</div>
					</td>
				</tr>
			<tr>
				<th>링크 Url</th>
				<td>
					<div class="col-md-12">
						<input type="text" name="linkUrl" id="linkUrl" maxlength="100" class="form-control input-sm" value="<%=linkUrl %>"/>
					</div>
				</td>
			</tr>
			<tr>
				<th>사용여부</th>
					<td colspan="3">
						<div class="col-md-12">
							<select id="useYn" name="useYn" class="select">
								<option value="Y" <c:if test="${bbsDataInfo.useYn =='Y'}">selected=selected</c:if> >Y</option>
								<option value="N" <c:if test="${bbsDataInfo.useYn =='N'}">selected=selected</c:if> >N</option>
							</select>
						</div>
					</td>
			</tr>	 
		</table>
	</div> 
	<div class="row m-t-15 text-right m-b-10">
		<button id="search2" class="btn-sm btn" style="">목 록</button>
		<button class="btn-sm btn" id="save2">저 장</button>
		<% if( "mod".equals(modeType)){ %>
		<button class="btn-sm btn" id="remove2">삭 제</button>
		<% }  %>
	</div>
</form>
</body>
</html>