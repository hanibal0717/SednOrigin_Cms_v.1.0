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
			* @JSP Name : modify.jsp
			* @Description : LIVE 방송관리 수정
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
	List<Map<String , Object>> channelList = (List)request.getAttribute("channelList");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>문의게시판</title>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
<script> 
$(document).ready(function() { 
	   
	$('#save').click(function(){save()})
	$('#remove').click(function(){remove()})
	$('#goList').click(function(){goList()})

	$('#chIdx').val(${liveDataInfo.chIdx});
	$('#screenGubun').val("${liveDataInfo.screenGubun}");
	$('#memberYn').val("${liveDataInfo.memberYn}");
	
}); 
  
function save(){
	if( $('#chIdx').val() == '' || $('#chIdx').val() == null ) {
		alert('채널명을 선택해주세요.');
		return;
	} else if( $('#broadNm').val() == '' || $('#broadNm').val() == null ) {
		alert('방송제목을 입력해주세요.');
		return;
	} else if( $('#startDate').val() == '' ) {
		alert('시작일을 선택해주세요.');
		return;
	} else if( $('#startHh').val() == '' ) {
		alert('시작 시간을 입력해주세요.');
		return;
	} else if( $('#startMm').val() == '' ) {
		alert('시작 분을 입력해주세요.');
		return;
	} else if( $('#endDate').val() == '' ) {
		alert('종료일을 선택해주세요.');
		return;
	} else if( $('#endHh').val() == '' ) {
		alert('종료 시간을 입력해주세요.');
		return;
	} else if( $('#endMm').val() == '' ) {
		alert('종료 분을 입력해주세요.');
		return;
	} else if ( $('#liveUrl').val() == '') {
		alert('URL을 입력해주세요.');
		return;
	}
	
	var f = document.frm; 
	f.action = "/liveBroadMng/writeProc.do";
	f.submit();
}

function remove(){
	if( confirm("정말 삭제 하시겠습니까?")){
		var f = document.frm; 
		f.action = "/liveBroadMng/removeLiveBoard.do";
		f.submit();
	}
}

function goList(){  

	var f = document.frm;
	f.action = "/liveBroadMng/list.do";
	f.submit();
	
}

$(function() {
    $( "#startDate" ).datepicker({
    	changeMonth: true, 
        changeYear: true,
        nextText: '다음 달',
        prevText: '이전 달', 
      	showButtonPanel: false, 
        currentText: '오늘 날짜', 
        closeText: '닫기', 
        dateFormat: "yy-mm-dd",
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
        dateFormat: "yy-mm-dd",
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
    <li>LIVE 방송관리</li>
    <li>등록 & 수정</li>
</ol>
<h4 class="page-title">LIVE 방송관리</h4>

<form name="frm" id="frm" method="post" enctype="multipart/form-data" >
	<input type="hidden" id="liveIdx" name="liveIdx" value="${liveDataInfo.liveIdx}" />
	<input type="hidden" name="search_keyword" id="search_keyword" value="${search_keyword}" />
	<input type="hidden" name="search_type" id="search_type" value="${search_type}" />
	
	<div class="row m-t-15 text-right m-b-10">
		<button id="goList" class="btn btn-sm" style="" >목 록</button>
		<button class="btn-sm btn" id="save">저 장</button>
		<button class="btn-sm btn" id="remove">삭 제</button>
	</div>
	<div class="alert alert-danger">필수 입력 항목입니다.</div>
	<div class="table-responsive overflow" style="overflow: hidden; outline: none;">
		<table class="table table-bordered tile" style="width:">
				<caption></caption>
				<colgroup>
					<col width="15%" />
					<col width="*" />
				</colgroup>
				<tr>
					<th><span class="text-danger">*</span>&nbsp;채널명</th>
					<td>
						<div class="col-md-2">
						<select id="chIdx" name="chIdx" class="select">
							<option value="">선택</option>
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
					</td>
				</tr>
				<tr>
					<th><span class="text-danger">*</span>&nbsp;방송 제목</th>
					<td>
						<div class="col-md-12">
						<input type="text" id="broadNm" name="broadNm" maxlength="100" class="form-control input-sm" value="${liveDataInfo.broadNm}"" />
						</div>
					</td>
				</tr>
				<tr>
					<th><span class="text-danger">*</span>&nbsp;시작 시간</th>
					<td>
						<div class="col-md-2">
							<input type="text" id="startDate" name="startDate" maxlength="10" class="form-control input-sm" size="12" readonly value="${liveDataInfo.startDate}" />
						</div>
						<div class="col-md-1">
 						<select id="startHh" name="startHh" class="select">
							<option value="">시</option>
							<c:forEach var="i" begin="0" end="23">
							<c:choose>
								<c:when test="${i < 10 }">
									<c:set var="startHH">0${i}</c:set>
								</c:when>
								<c:otherwise>
									<c:set var="startHH">${i}</c:set>
								</c:otherwise>
							</c:choose>
							<option value="${startHH}" <c:if test="${liveDataInfo.startHh == startHH}">selected</c:if>>${startHH}</option>
							</c:forEach>
						</select>
						</div>
						<div class="col-md-1">
							<select id="startMm" name="startMm" class="select">
								<option value="">분</option>
								<c:forEach var="i" begin="0" end="59">
								<c:choose>	
									<c:when test="${i < 10 }">
										<c:set var="startMM">0${i}</c:set>
									</c:when>
									<c:otherwise>
										<c:set var="startMM">${i}</c:set>
									</c:otherwise>
								</c:choose>
								<option value="${startMM}" <c:if test="${liveDataInfo.startMm == startMM}">selected</c:if>>${startMM}</option>
								</c:forEach>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th><span class="text-danger">*</span>&nbsp;종료 시간</th>
					<td>
						<div class="col-md-2">
							<input type="text" id="endDate" name="endDate" maxlength="10" class="form-control input-sm" size="12" readonly value="${liveDataInfo.endDate}" />
						</div>
						<div class="col-md-1">
							<select id="endHh" name="endHh" class="select">
								<option value="">시</option>
								<c:forEach var="i" begin="0" end="23">
								<c:choose>
									<c:when test="${i < 10 }">
										<c:set var="endHH">0${i}</c:set>
									</c:when>
									<c:otherwise>
										<c:set var="endHH">${i}</c:set>
									</c:otherwise>
								</c:choose>
								<option value="${endHH}" <c:if test="${liveDataInfo.endHh == endHH}">selected</c:if>>${endHH}</option>
								</c:forEach>
							</select>
						</div>
						<div class="col-md-1">
							<select id="endMm" name="endMm" class="select">
								<option value="">분</option>
								<c:forEach var="i" begin="0" end="59">
								<c:choose>	
									<c:when test="${i < 10 }">
										<c:set var="endMM">0${i}</c:set>
									</c:when>
									<c:otherwise>
										<c:set var="endMM">${i}</c:set>
									</c:otherwise>
								</c:choose>
								<%-- <option value="${endMM}">${endMM}</option> --%>
							<option value="${endMM}" <c:if test="${liveDataInfo.endMm == endMM}">selected</c:if>>${endMM}</option>
								</c:forEach>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th>URL</th>
					<td>
						<div class="col-md-12">
							<input type="text" id="liveUrl" name="liveUrl" maxlength="500" class="form-control input-sm" value="${liveDataInfo.liveUrl}" />
						</div>
					</td>
				</tr>
				<tr>
					<th>시청 허용 여부</th>
					<td>
						<div class="col-md-1">
							<select id="memberYn" name="memberYn" class="select">
								<option value="N">전체</option>
								<option value="Y">회원</option>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th>SD/HD 표시</th>
					<td>
						<div class="col-md-1">
							<select id="screenGubun" name="screenGubun" class="select">
								<option value="SD">SD</option>
								<option value="HD">HD</option>
							</select>
						</div>
					</td>
				</tr>
			</table> 
	</section>
</form>
</body>
</html>