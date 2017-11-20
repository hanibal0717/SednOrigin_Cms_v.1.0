<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
			/**
			* @JSP Name : userRegister.jsp
			* @Description : 회원 가입
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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
<style>
	#data_tableW td { text-align:left; }
</style>
<title></title>
<meta name="decorator" content="defaultPage">
<script type="text/javascript">
var chkPwd = "";

$(document).ready(function(){
    
	$('#idCheck').click(function(){idCheck()});
	$('#save').click(function(){save()});
	
	 $('#email3').change(function(){
		 if ($('#email3').val() == "직접입력") {
			 $('#email2').val("");

		 } else {
			 $('#email2').val($(this).val());
		 }
		 
	 });
	 
	var password1 = $("#password");
	var password2 = $("#passwordChk");
    var userId = $("#userId");
	
    
    password1.keyup( function() {
        var regExp1 = /[\d]{1,}/
        var regExp2 = /[a-z]{1,}/i
        var regExp3 = /^[a-zA-Z0-9]{8,12}$/
        var msg = "비밀번호는 문자, 숫자의 조합으로 8~12자리로 입력해주세요."; 

      　var s = $(this).next('strong');

        if(!regExp1.test(password1.val()) || !regExp2.test(password1.val())){ s.text('비밀번호는 문자, 숫자의 조합으로 8~12자리로 입력해주세요.').css("color","red"); return; }
        if(!regExp3.test(password1.val())){ s.text(msg).css("color","red"); return; }

         if(password1.val().length<8)
         {
               s.text(msg).css("color","red"); 
               return;
         }

         s.text('적합').css("color","blue"); // strong 요소에 문자 출력
         
    }); 
    
    password2.keyup( function() {
    	
    	var s2 = $(this).next('strong'); // strong 요소를 변수에 할당
    	
    	if(password1.val() != password2.val()){ s2.text('입력하신 비밀번호와 일치하지 않습니다').css("color","red"); chkPwd = "N"; return; }
        s2.text('적합').css("color","blue"); // strong 요소에 문자 출력
        chkPwd = "Y";
        
    });    

 });

function idCheck() {
		$.ajax({
	        url:'/user/userMng/userIdChk.do',
	        type:'post',
	        data:$("#frm").serialize(),
	        success:function(data){
	       		alert(data.result);
	        	if (data.result == "1") {
	        		alert("이미 사용중인 아이디입니다.");
	        	} else {
	        		alert("사용 가능한 아이디입니다.");
	        	}
	        }
		});
}

function save() {
	alert(chkPwd);
	if ($("#password").val() == $("#passwordChk").val() || chkPwd == "N") {
		alert("비밀번호가 일치하지 않습니다.");
		return;
	} else {
		
		
	}
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
<h2>회원 등록<span class="text"></span></h2>
<p class="location"></p>
<p class="tar Mbo11">
	<button id="search" class="btn_searchTbl06 prevent">조회</button>
	<span class="btn_type01 btn" id="save"><a href="#">저장</a></span>
</p>
<form name="frm" id="frm" method="post">
	<h3>회원목록</h3>
	<div style="overflow-y:scroll; height:500px; border-left:2px solid #cdcdcd; border-right:2px solid #cdcdcd; border-bottom:2px solid #cdcdcd; border-top:2px solid #cdcdcd;">
		<form name="frm" id="frm" method="post">
			<table class="data_tableW" id="data_tableW" summary="" >
				<caption></caption>
				<colgroup>
				</colgroup>
				<thead>
				<tr style="background-color: blue;">
				</tr>
				</thead>
				<tbody>
				<tr>
					<td>아이디</td>
					<td>
						<input type="text" id="userId" name="userId" maxlength="12" onkeyup="onlyEngNumber(this);" />
						<button id="idCheck" class=btn_searchPare5 style="margin-top:2px; width:70px; height:23px;">중복체크</button>
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<input type="password" maxlength="12" id="password" name="password" />
						<strong></strong>
					</td>
				</tr>
				<tr>
					<td>비밀번호 확인</td>
					<td>
						<input type="password" maxlength="12" id="passwordChk" name="passwordChk" />
						<Strong></Strong>
					</td>
				</tr>
				<tr>
					<td>직책</td>
					<td><input type="text" id="position" name="position" /></td>
				</tr>
				<tr>
					<td>부서</td>
					<td><input type="text" id="department" name="department" /></td>
				</tr>
				<tr>
					<td>이메일</td>
					<td>
						<input type="text" maxlength="20" id="email1" name="email1" onkeyup="onlyEngNumber(this);" />
						@
						<input type="text" maxlength="20" id="email2" name="email2" />
						<select class="select_size05" name='email3' id='email3'>
							<c:forEach var="emailList" items="${emailList}" varStatus="listCount">
								<option value="${emailList.cmNm}" >${emailList.cmNm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td>전화번호</td>
					<td>
						<input type="text" id="hp1" name="hp1" onKeyDown="javascript:return onlyNumber(event);" maxlength="3" class="" size="5" /> -
						<input type="text" id="hp2" name="hp2" onKeyDown="javascript:return onlyNumber(event);" maxlength="4" class="" size="7" /> -
						<input type="text" id="hp3" name="hp3" onKeyDown="javascript:return onlyNumber(event);" maxlength="4" class="" size="7" />
					</td>
				</tr>
				</tbody>
			</table>
		</div>
	</form>
</body>
</html>

