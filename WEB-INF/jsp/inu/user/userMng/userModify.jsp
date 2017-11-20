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
			* @JSP Name : userModify.jsp
			* @Description : 회원 관리 수정
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
String department = "";
String position = "";
String userEmail = "";
String userTel = "";
String regDt = "";
String acceptDt = "";
String userStatus = "";
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
	acceptDt = StringUtil.nvl(userDetail.get("acceptDt"), "");
	userStatus = StringUtil.nvl(userDetail.get("userStatus"), "");
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
	$('#save').click(function(){save()});
	$('#list').click(function(){list()});
	$('#passwordReset').click(function(){passwordReset()});
	
	var status = $("#status").val();
	var delYn = $("#delYnStatus").val();
	
	if(status == "" || status == null) {
		status = "";
	} else if (delYn == "" || delYn == null) {
		delYn = "";
	}
	
	$("#userStatus").val(status);
	$("#delYn").val(delYn);
	
	 $('#email3').change(function(){
		 if ($('#email3').val() == "직접입력") {
			 $('#email2').val("");

		 } else {
			 $('#email2').val($(this).val());
		 }
		 
	 });
	
});

function list(){

	var formData = document.frm;
	formData.action = "/user/userMng/userMng.do";
	formData.submit();
	
}

function save(){
	
	if ($('#userNm').val() == null || $('#userNm').val() == "") {
		alert("회원 이름을 입력하세요.");
		$('#userNm').focus();
		return;
	} else if ($('#email1').val() == null || $('#email1').val() == "" || $('#email2').val() == null || $('#email2').val() == "") {
		alert("회원 이메일을 입력하세요.");
		$('#email1').focus();
		return;
	} else if ($('#hp1').val() == null || $('#hp1').val() == "" || $('#hp2').val() == null || $('#hp2').val() == "" || $('#hp3').val() == null || $('#hp3').val() == "") {
		alert("회원 연락처를 입력하세요.");
		$('#hp1').focus();
		return;
	}
	
	var formData = document.frm;
	formData.action = "/user/userMng/saveUser.do";
	formData.submit();
	
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

function passwordReset(){
	
	if ($('#password').val() == "") {
		alert("초기화할 패스워드를 입력하세요.");
		$('#password').focus();
		return;
	}
	
	$.ajax({
	    url:'/user/userMng/userPasswordReset.do',
	    type:'POST',
	    data: $('#frm').serialize(),
	    dataType: 'json',
	    success: function( json ) {
			alert("초기화되었습니다.");
	    }
	});
	
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
		<button class="btn-sm btn" id="save">저 장</button>
	</div>
	<h3>회원 정보</h3>
	<div class="table-responsive overflow" style="overflow: hidden; outline: none;">
		<table class="table table-bordered tile">
			<caption></caption>
			<colgroup>
				<col width="20%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>회원 아이디</th>
				<td>
					<div class="col-md-12">
						<input type="text" id="userId" name="userId" class="form-control input-sm" maxlength="14" value="${userDetail.userId}" onkeyup="onlyEngNumber(this);" readonly />
					</div>
				</td>
			</tr>
			<tr>
				<th>회원 이름</th>
				<td>
					<div class="col-md-12"> 
						<input type="text" name="userNm" class="form-control input-sm" id="userNm" maxlength="30" value="${userDetail.userNm}" />
					</div>
				</td>
			</tr>
				<tr>
				<th>비밀번호 초기화</th>
				<td>
					<div class="col-md-4">
						<input type="password" class="form-control input-sm" name="password" id="password" maxlength="12" value="" class="password" />
					</div>
					<div class="col-md-2">
						<button id="passwordReset" class="btn-sm btn" style="">초기화</button>
					</div>
				</td>
			</tr>
			<tr>
				<th>회원 직책</th>
				<td> 
					<div class="col-md-12">
						<input type="text" class="form-control input-sm" name="position" id="position" maxlength="50" value="${userDetail.position}" />
					</div>
				</td>
			</tr>
			<tr>
				<th>회원 부서</th>
				<td> 
					<div class="col-md-12">
						<input type="text" class="form-control input-sm" name="department" id="department" maxlength="50" value="${userDetail.department}" />
					</div>
				</td>
			</tr>
			<tr>
				<th>회원 이메일</th>
				<td>
					<div class="col-md-2"> 
						<input type="text" class="form-control input-sm" maxlength="20" id="email1" name="email1" maxlength="20" onkeyup="onlyEngNumber(this);" value="${userDetail.addEmail1}" />
					</div>
					<label class="pull-left">@</label>
					<div class="col-md-2">
						<input type="text" class="form-control input-sm" maxlength="20" id="email2" name="email2" value="${userDetail.addEmail2}" />
					</div>
					<div class="col-md-2">
						<select class="select" name='email3' id='email3'>
							<c:forEach var="emailList" items="${emailList}" varStatus="listCount">
								<option value="${emailList.cmNm}" >${emailList.cmNm}</option>
							</c:forEach>
						</select>
					</div>
				</td>
			</tr>
			<tr>
				<th>회원 연락처</th>
				<td>
					<div class="col-md-2">
						<input type="text" id="hp1" name="hp1" onKeyDown="javascript:return onlyNumber(event);" value="${userDetail.addTel1}" maxlength="3" class="form-control input-sm" size="5" />
					</div>
					<label class="pull-left">-</label>
					<div class="col-md-2">
						<input type="text" id="hp2" name="hp2" onKeyDown="javascript:return onlyNumber(event);" value="${userDetail.addTel2}" maxlength="4" class="form-control input-sm" size="7" />
					</div>
					<label class="pull-left">-</label>
					<div class="col-md-2">
						<input type="text" id="hp3" name="hp3" onKeyDown="javascript:return onlyNumber(event);" value="${userDetail.addTel3}" maxlength="4" class="form-control input-sm" size="7" />
					</div>
				</td>
			</tr>
			<tr>
				<th>등록일자</th>
				<td> 
					<div class="col-md-12">
						<input type="hidden" name="regDt" id="regDt" value="${userDetail.regDt}" disabled />
						<%=regDt %>
					</div>
				</td>
			</tr>
			<tr>
				<th>승인여부</th>
				<td> 
					<div class="col-md-12">
						<input type="hidden" name="status" id="status" value="${userDetail.userStatus}" />
						<select class="select" name="userStatus" id="userStatus">
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
					</div>
				</td>
			</tr>
			<tr>
				<th>승인일자</th>
				<td>
					<div class="col-md-12">
						<input type="hidden" name="acceptDt" id=""acceptDt"" value="${userDetail.acceptDt}" disabled />
						<%=acceptDt %>
					</div>
				</td>
			</tr>
			<tr>
			<tr>
				<th>탈퇴여부</th>
				<td> 
					<div class="col-md-12">
						<input type="hidden" name="delYnStatus" id="delYnStatus" value="${userDetail.delYn}" />
						<select class="select" name="delYn" id="delYn">
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
					</div>
				</td>
			</tr>
		</table>
	</div> 
</form>

</body>
</html>