<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%
			/*
			* @JSP Name : tagIconPop.jsp
			* @Description : 태그 아이콘 팝업
			* @Modification Information
			* 
			*       수정일         수정자         수정내용
			*  ----------------------------------------------
			*     2015.09.07       박경택         최초생성
			*
			* author 개발팀 
			* Copyright (C) 2011 by MOPAS  All right reserved.
			*/
%>
<%
List<Map<String , Object>> list = (List)request.getAttribute("list");
String rnum = "";
String tag_icon_idx  = "";
String tag_icon_name = "";
String tag_icon_url  = "";
String tag_skin_type = "";
%>
<html>
<head>
<title></title>
<meta name="decorator" content="popupPage">
<style>
	#data_tableW td {cellpadding:10px; padding:10px; height:50px; width:35px; background-color:white;}
</style>
<script>
$(document).ready(function() {
	$('#close').click(function(){exit()})
	$('#save').click(function(){save()})
	$('#register').click(function(){register()})
	$('#remove').click(function(){remove()})
	//$('#edit').click(function(){edit()}) //수정 대기
});

function save() {
	
	var chkValue = $('input:radio[name="chkYn"]:checked').val();
	var chkId = $('#tagIdx').val();
	
	if (chkValue == null || chkValue == "") {
		alert("선택된 이미지가 존재하지 않습니다.");
		return;
	}
	
	opener.setTagIconUrl(chkValue, chkId);
	
	close();
}

function edit() {
	var chkValue = $('input:radio[name="chkYn"]:checked').val();
	
	if (chkValue == null || chkValue == "") {
		alert("선택된 이미지가 존재하지 않습니다.");
		return;
	}
	
	var chkId = $('#tagIdx').val();
	var iconIdx = $('#tagIconIdx').val();
	
	location.href = "/tagMenuMng/tagIconRegister.do?iconIdx="+iconIdx+"&type=U";
	
}

function register() {
	
	location.href = "/tagMenuMng/tagIconRegister.do?type=C&tagIdx="+$('#tagIdx').val();
}

function exit() {
	self.close();
}

function mouseOver(tdId) {
	
	var div = document.getElementById(tdId);
	
	div.style.fontWeight = "bold";
	div.style.cursor = "pointer";

}

function mouseOut(tdId) {

	var div = document.getElementById(tdId);
	
	div.style.fontWeight = "normal";
	div.style.cursor = "default";

}

function selectedImage(imageId) {
	
	var div = document.getElementById(imageId);
	
	var parentDiv = div.parentNode;
	var parentDiv2 = parentDiv.parentNode;
	
	var imageIdxValue = imageId.substring(10); 
	
	if (parentDiv2.style.length == 0) {
		$(".selectIconClass").css("backgroundColor", "white");
		parentDiv2.style.backgroundColor = "#FAECC5";
		$("#tagIconIdx").val(imageIdxValue);
	} else if (parentDiv2.style.length != 0) {
		$(".selectIconClass").css("backgroundColor", "white");
		parentDiv2.style.backgroundColor = "#FAECC5";
		$("#tagIconIdx").val(imageIdxValue);
	}
	
}

function remove() {
	var chkValue = $('input:radio[name="chkYn"]:checked').val();
	
	if (chkValue == null || chkValue == "") {
		alert("선택된 이미지가 존재하지 않습니다.");
		return;
	}
	
	var iconIdx = $('#tagIconIdx').val(); // 태그 아이콘 IDX
	var chkId = $('#tagIdx').val(); //태그 IDX
	
	location.href = "/tagMenuMng/tagIconRemove.do?iconIdx="+chkId+"&tagIconIdx="+iconIdx;
	
}
</script>

</head>
	
<body class="popbg" style="width:500px">
<div id="popup">
	<div class="popHeader">
		<h1>태그 아이콘 목록</h1>
	</div>
	
	<p class="btn_type04 close_btn01">
		<a href="#" class="btn02" id="save">저장</a>
		<!-- <a href="#" class="btn02" id="edit">수정</a> -->
		<a href="#" class="btn02" id="register">추가</a>
		<a href="#" class="btn03 btn_c01" id="remove">삭제</a>
		<a href="#" class="btn03 btn_c01" id="close">닫기</a>
	</p>
	<div class="popContents">
	<form name='frm' id='frm' action="">
	<input type="hidden" id="tagIdx" name="tagIdx" value="${param.tagNo}" />
	<input type="hidden" id="tagIconIdx" id="tagIconIdx" name="tagIconIdx" value="" />
		<!-- <h3 class="h3_title">전체 아이콘</h3> -->
		<!-- <h3></h3> -->
		<table class="data_tableW" id="data_tableW" summary="" style="">
				<caption></caption>
				<colgroup>
				<%-- 	
					<col width="18%" />
					<col width="18%" /> 
				--%>
				</colgroup>
				<thead>
<!-- 				<tr style="background-color: blue;">
					<th>번호</th>
					<th>아이콘 이미지</th>
					<th>선택</th>
				</tr> -->
				</thead>
				<tbody>
				<tr>
<%
				if( list != null){
					Map<String , Object> iconDataInfo;
					
					for (int i=0; i<list.size(); i++) {
						iconDataInfo = list.get(i);
						
						rnum  = String.valueOf(iconDataInfo.get("rnum"));
						tag_icon_idx  = String.valueOf(iconDataInfo.get("tagIconIdx"));
						tag_icon_url  = StringUtil.nvl(iconDataInfo.get("tagIconUrl"), "");
						tag_skin_type = StringUtil.nvl(iconDataInfo.get("tagSkinType"), "");
					
					if (i % 5 == 0) { 
%>
						<tr>
							<td id="selectIcon<%= tag_icon_idx %>" class="selectIconClass">
								<label for='chkYn<%= tag_icon_idx %>'>
									<img onclick="selectedImage(this.id);" onclick="edit(this.id);" onmouseover="mouseOver(this.id);" onmouseout="mouseOut(this.id);" style="background-color:black; width:38px; height:32px;" src="<%= tag_icon_url %>" id="tagIconImg<%= tag_icon_idx %>" name="tagIconImg" alt="이미지" />
									<input type="radio" id="chkYn<%= tag_icon_idx %>" name="chkYn" value="<%= tag_icon_url %>" style="display:none;" />
									<input type="hidden" id="iconIdx<%= tag_icon_idx %>" name="" value="<%= tag_icon_idx %>" />
								</label>
							</td>
						
<% 		 			} else {
%>
				
					<td id="selectIcon<%= tag_icon_idx %>" class="selectIconClass">
						<label for='chkYn<%= tag_icon_idx %>'>
							<img onclick="selectedImage(this.id);" onmouseover="mouseOver(this.id);" onmouseout="mouseOut(this.id);" style="background-color:black; width:38px; height:32px;" src="<%= tag_icon_url %>" id="tagIconImg<%= tag_icon_idx %>" name="tagIconImg" alt="이미지" />
							<input type="radio" id="chkYn<%= tag_icon_idx %>" name="chkYn" value="<%= tag_icon_url %>" style="display:none;" />
							<input type="hidden" id="iconIdx<%= tag_icon_idx %>" name="" value="<%= tag_icon_idx %>" />
						</label>
					</td>
				
<%						
					}
					}
				}
%>
				</tr>
				</tbody>
		</table>
	</form>
</div>

</div>
</body>
</html>