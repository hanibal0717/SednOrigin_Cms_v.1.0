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
			* @JSP Name : userDetail.jsp
			* @Description : 회원 관리 상세
			* @Modification Information
			* 
			*       수정일         수정자         수정내용
			*  ----------------------------------------------
			*     2015.08.28       박경택         최초생성
			*
			* author 개발팀 
			* Copyright (C) 2011 by MOPAS  All right reserved.
			*/
%>
<%

Map<String , Object> userDetail = (Map)request.getAttribute("userDetail");

String userId = "";
String userNm = "";
String position = "";
String department = "";
String userEmail = "";
String userTel = "";
String regDt = "";
String userStatus = "";
String acceptId = "";
String acceptDt = "";
String delYn = "";

if( userDetail == null ){
	
} else {

	userId = StringUtil.nvl(userDetail.get("userId"), "");
	userNm = StringUtil.nvl(userDetail.get("userNm"), "");
	department = StringUtil.nvl(userDetail.get("department"), "");
	position = StringUtil.nvl(userDetail.get("position"), "");
	userEmail = StringUtil.nvl(userDetail.get("userEmail"), "");
	userTel = StringUtil.nvl(userDetail.get("userTel"), "");
	regDt = StringUtil.nvl(userDetail.get("regDt"), "");
	userStatus = StringUtil.nvl(userDetail.get("userStatus"), "");
	acceptId = StringUtil.nvl(userDetail.get("acceptId"), "");
	acceptDt = StringUtil.nvl(userDetail.get("acceptDt"), "");
	delYn = StringUtil.nvl(userDetail.get("delYn"), "");
	
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">
<style>
.ui_calendar input[type=text]{width:105px !important;}
</style>
<script>
$(document).ready(function() {
	$('#modify').click(function(){modify()});
	$('#list').click(function(){list()});
});

function list(){

	var sKeyword = encodeURIComponent($('#searchTxt').val());
    $('#searchTxt').val(sKeyword);
    
	var formData = document.frm;
	formData.action = "/user/userMng/userMng.do";
	formData.submit();
	
}

function modify(){
	
	var formData = document.frm;
	formData.action = "/user/userMng/userDetailMod.do";
	formData.submit();
	
}

function onlyNumber(event) {

    var key = window.event ? event.keyCode : event.which;    

    if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
    || key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
    || key  == 8  || key  == 46 || key == 9) // del, back space
    ) {
        return true;
    }else {
        return false;
    }    
}

function onlyEngNumber(obj) {
	str = obj.value; 
	len = str.length; 
	ch = str.charAt(0);
	
	for(i = 0; i < len; i++) { 
		ch = str.charAt(i); 
		if( (ch >= '0' && ch <= '9') || (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') ) { 
		continue; 
		} else { 
	  		alert("영문과 숫자만 입력이 가능합니다.");
	  		obj.value="";
	  		obj.focus();
	 		return false; 
	 	} 
	}
	return true; 
}

</script>
</head>
	
<body>
<ol class="breadcrumb hidden-xs">
	<li>회원 관리</li>
</ol>
<h4 class="page-title">회원 관리</h4>

<form name="frm" id="frm" method="post" >
	<input type="hidden" name="userIdx" id="userIdx" value="${userDetail.userIdx}" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	<input type="hidden" name="searchTxt" id="searchTxt" value="${searchTxt}" />
	<input type="hidden" name="searchCondition" id="searchCondition" value="${searchCondition}" />
	
	<div class="row m-t-15 text-right m-b-10">
		<button id="list" class="btn-sm btn">목 록</button>
		<button class="btn-sm btn" id="modify">수 정</button>
	</div>
	<h3>회원 정보</h3>
	<div class="table-responsive" style="overflow: hidden; outline: none;">
		<table class="table table-bordered tile">
			<caption></caption>
			<colgroup>
				<col width="20%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>회원 아이디</th>
				<td>
					<%=userId %>
				</td>
			</tr>
			<tr>
				<th>회원 이름</th>
				<td> 
					<%=userNm %>
				</td>
			</tr>
			<tr>
				<th>회원 직책</th>
				<td> 
					<%=position %>
				</td>
			</tr>
			<tr>
				<th>회원 부서</th>
				<td> 
					<%=department %>
				</td>
			</tr>
			<tr>
				<th>회원 이메일</th>
				<td> 
					<%=userEmail %>
				</td>
			</tr>
			<tr>
				<th>회원 연락처</th>
				<td> 
					<%=userTel %>
				</td>
			</tr>
			<tr>
				<th>등록일자</th>
				<td> 
					<%=regDt %>
				</td>
			</tr>
			<tr>
				<th>승인여부</th>
				<td> 
					<%=userStatus %>
				</td>
			</tr>
			<tr>
				<th>승인자 아이디</th>
				<td> 
					<%=acceptId %>
				</td>
			</tr>
			<tr>
				<th>승인 일자</th>
				<td> 
					<%=acceptDt %>
				</td>
			</tr>
			<tr>
				<th>탈퇴 여부</th>
				<td> 
					<%=delYn %>
				</td>
			</tr>
		</table>
	</div>
</form>
</body>
</html>

