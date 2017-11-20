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
			* @JSP Name : write.jsp
			* @Description : 노출 컨텐츠 관리 생성/수정
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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>문의게시판</title>
<meta name="decorator" content="defaultPage">
<link type="text/css" rel="stylesheet" href="<c:url value='/js/axisj/ui/arongi/AXJ.min.css'/>">
<script type="text/javascript" src="<c:url value='/js/axisj/dist/AXJ.min.js'/>"></script>
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script> 
$(document).ready(function() { 
	   
	$('#search').click(function(){search()})
	//$('#save').click(function(){save()})
	//$('#remove').click(function(){remove()})
	//$('#newGuest').click(function(){newGuest()})
	
}); 
  

function search(){  
	var f = document.frm;
	$('#data_idx').val('');
	f.action = "/openContents/list.do";
	f.submit();
}
/*
function save(){
	if( $('#title').val() == '' || $('#title').val() == null ) {
		alert('제목을 입력해주세요.')
		return;
	} else if( $('#reg_nm').val() == '' ) {
		alert('작성자명을 입력해주세요.')
		return;
	}
	var f = document.frm; 
	f.action = "/ncs/bbs/writeProc.do";
	f.submit();
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
		        newGuest();
		    }
		});
	}
};
function newGuest() {
	var f = document.frm;
	$('#data_idx').val('');
	f.action = "/ncs/bbs/write.do";
	f.submit();
} */
</script>
</head>
<body>
<h2>노출 컨텐츠 관리</h2>
<p class="location"> 노출 컨텐츠 관리 > 등록</p>

<form name="frm" id="frm" method="post" enctype="multipart/form-data" >
	<input type="hidden" name="bbs_mst_idx" id="bbs_mst_idx" value="" />
	<input type="hidden" name="data_idx" id="data_idx" value="" />
	<input type="hidden" name="bbs_ref" value=""/>
	<input type="hidden" name="bbs_level" value=""/>
	<input type="hidden" name="bbs_step" value=""/>
	
	<section> 
		<p class="tar Mbo11">
			<button id="search" class="btn_searchTbl06 prevent" style="" >목록</button>
			<span class="btn_type01 btn" id="newGuest"><a href="#">신규</a></span>
			<span class="btn_type01 btn" id="save"><a href="#">저장</a></span>
			<% if( "mod".equals(modeType)){ %>
			<span class="btn_type02 btn" id="remove"><a href="#">삭제</a></span>
			<% }  %>
		</p>
	 	  
			<h3><span class="tx_red03">*</span>&nbsp;&nbsp;&nbsp;필수입력 항목입니다.</h3>
		
			<table class="data_tableW02">
				<caption></caption>
				<colgroup>
					<col width="15%" />
					<col width="*" />
				</colgroup>
				<tr>
					<th><span class="tx_red02">*</span>&nbsp;메뉴</th>
					<td>
						<select>
							<option value="">선택</option>
						</select>
					</td>
				</tr>
				<tr>
					<th><span class="tx_red02">*</span>&nbsp;제목</th>
					<td>
						<input type="text" name="title" id="title" maxlength="100" class="textInput_size04" value=""/>
					</td>
				</tr>
				<tr>
					<th><span class="tx_red02">*</span>&nbsp;내용</th>
					<td>
						<textarea id="cont" name="cont" class="edt_base" class="textInput_size01" rows="5" cols="30"></textarea>
					</td>
				</tr>
				<tr>
					<th><span class="tx_red02">*</span>&nbsp;서비스시작일자</th>
					<td>
						<input type="text" name="reg_nm" id="reg_nm" maxlength="100" class="textInput_size08" value="" />
						<select id="startHH">
							<option value="">시</option>
							<c:forEach var="i" begin="1" end="23">
							<c:choose>
								<c:when test="${i < 10 }">
									<c:set var="startHH">0${i}</c:set>
								</c:when>
								<c:otherwise>
									<c:set var="startHH">${i}</c:set>
								</c:otherwise>
							</c:choose>
							<option value="${startHH}">${startHH}</option>
							</c:forEach>
						</select> :
						<select id="startMM">						
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
							<option value="${startMM}">${startMM}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th><span class="tx_red02">*</span>&nbsp;서비스종료일자</th>
					<td>
						<input type="text" name="reg_nm" id="reg_nm" maxlength="100" class="textInput_size08" value="" />
						<select id="endHH">
							<option value="">시</option>
							<c:forEach var="i" begin="1" end="23">
							<c:choose>
								<c:when test="${i < 10 }">
									<c:set var="endHH">0${i}</c:set>
								</c:when>
								<c:otherwise>
									<c:set var="endHH">${i}</c:set>
								</c:otherwise>
							</c:choose>
							<option value="${endHH}">${endHH}</option>
							</c:forEach>
						</select> :
						<select id="endMM">						
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
							<option value="${endMM}">${endMM}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>우선순위</th>
					<td>
						<input type="text" name="title" id="title" maxlength="100" class="textInput_size04" value=""/>
					</td>
				</tr>
				<tr>
					<th>썸네일 이미지</th>
					<td>
						<input type="file" name="file_1" id="egovComFileUploader" class="input-file"  />
					</td>
				</tr>
			</table> 
	</section>
	
</form>
</body>
</html>