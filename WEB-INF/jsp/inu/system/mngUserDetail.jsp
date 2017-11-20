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
			* @JSP Name : mngUserDetail.jsp
			* @Description : 관리자 계정 등록
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

Map<String , Object> bbsDataInfo = (Map)request.getAttribute("bbsDataInfo");
String modeType = StringUtil.nvl(request.getParameter("modeType"),"");

String manageIdx   	= "";
String manageId 	= "";
String manageNm		= "";
String managePwd 	= "";
String manageLevel  = "";
String groupNm		= "";
String department 	= "";
String regDt     	= "";
String regAdminId  	= "";
String regNm       	= "";
String regIp       	= "";
String modDt     	= "";
String modAdminId  	= "";
String modIp       	= "";
String useYn       	= "";
String delYn       	= "";

String msg = "등록"; 
String actPage = "";

EgovUserInfoVO user_info = (EgovUserInfoVO)request.getAttribute("user"); 
if( user_info != null ){ 	 
	regNm = user_info.getUserNm();	 
}

if( bbsDataInfo == null ){
	modeType = "ins";
	actPage = "/system/insertmngUser.do";
	msg = "등록";
} else {
	
	if( !"reply".equals(modeType) && !"replyM".equals(modeType) ){ 
		modeType = "mod";
		actPage = "/system/modifymngUser.do";
		msg = "수정";
	}
	
	if(bbsDataInfo.get("manageIdx") != null)
	{
		manageIdx   = String.valueOf(bbsDataInfo.get("manageIdx"));	
	}
	
	if(bbsDataInfo.get("manageId") != null)
	{
		manageId   = String.valueOf(bbsDataInfo.get("manageId"));	
	}
	
	if(bbsDataInfo.get("manageNm") != null)
	{
		manageNm   = String.valueOf(bbsDataInfo.get("manageNm"));	
	}

	if(bbsDataInfo.get("groupNm") != null)
	{
		groupNm   = String.valueOf(bbsDataInfo.get("groupNm"));	
	}
	
	if(bbsDataInfo.get("department") != null)
	{
		department   = String.valueOf(bbsDataInfo.get("department"));	
	}
	if(bbsDataInfo.get("manageLevel") != null)
	{
		manageLevel   = String.valueOf(bbsDataInfo.get("manageLevel"));	
	}
	
	if( bbsDataInfo.get("regDt") != null ){
		regDt = bbsDataInfo.get("regDt").toString();
	}
	if( bbsDataInfo.get("modDt") != null ){
		modDt = bbsDataInfo.get("modDt").toString();
	}
	
	if(bbsDataInfo.get("useYn") != null)
	{
		useYn   = String.valueOf(bbsDataInfo.get("useYn"));	
	}
	
	if(bbsDataInfo.get("delYn") != null)
	{
		delYn   = String.valueOf(bbsDataInfo.get("delYn"));	
	}


}
String orgModeType = modeType;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">

<script> 
$(document).ready(function() { 
	  
	$('#list').click(function(){list()})
	$('#save').click(function(){save()})
	$('#remove').click(function(){remove()})
	
}); 

function list(){  
	var f = document.frm;
	$('#manageIdx').val('');
	f.action = "/system/mngUserList.do";
	f.submit();
}

function save(){

	var f = document.frm; 
	f.action = "/system/writeMngUser.do";
	f.submit();
	
}
function remove(){
	if( $('#manageIdx').val() == '' ){
		alert("선택된 목록이 없습니다. 삭제하시려는 목록을 체크하세요.");
		return;
	}
	if( confirm("정말 삭제 하시겠습니까?")){
		$.ajax({
		    url:'/system/deleteMngUser.do',
		    type:'POST',
		    data: $('#frm').serialize(),
		    dataType: 'json',
		    success: function( data) {
		    	alert(data.msg);
		    	list();
		    }
		});
	}
};

</script>
</head>
<body>
<h2>사용자 등록(관리자)<!-- <span class="text">한림성심대학교 NCS시스템 외부인사 활용 관리 입니다.</span> --></h2>
<p class="location"> 관리자 > 사용자 등록(관리자)</p>

<form name="frm" id="frm" method="post" enctype="multipart/form-data" >
	<input type="hidden" id="manageIdx" name="manageIdx" value="<%=manageIdx%>" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	<input type="hidden" name="searchTxt" id="searchTxt" value="${searchTxt}" />
	<input type="hidden" name="searchCondition" id="searchCondition" value="${searchCondition}" />
	<section> 
		<p class="tar Mbo11">
			<button id="list" class="btn_searchTbl06 prevent" style="" >목록</button>
			<span class="btn_type01 btn" id="save"><a href="#">수정</a></span>
			<% if( "mod".equals(modeType)){ %>
			<span class="btn_type05 btn" id="remove"><a href="#">삭제</a></span>
			<% }  %>
		</p>
			<h3><span class="tx_red03">*</span>&nbsp;&nbsp;&nbsp;필수입력 항목입니다.</h3>
			<table class="data_tableW02">
				<caption></caption>
				<colgroup>
					<col width="" />
					<col width="" />
				</colgroup>
				<tr>
					<th><span class="tx_red02">*</span>&nbsp;아이디</th>
					<td colspan="3">
						<%=manageId %>
					</td>
				</tr>
				<tr>
					<th><span class="tx_red02">*</span>이름</th>
					<td>
						<%=manageNm %>
					</td>
				</tr>
					<th>부서</th>
					<td colspan="3">
						<%=department %>
					</td>
				<tr>
					<th>권한그룹</th>
					<td colspan="3">
						<%=groupNm %>
					</td>
				</tr>
				<tr>
					<th>사용 유무</th>
					<td colspan="3">
						<%=useYn %>
		
					</td>
				</tr>
				<tr>
					<th>삭제 여부</th>
					<td colspan="3">
						<%=useYn %>
					</td>
				</tr>
			</table> 
	</section>
</form>
</body>
</html>