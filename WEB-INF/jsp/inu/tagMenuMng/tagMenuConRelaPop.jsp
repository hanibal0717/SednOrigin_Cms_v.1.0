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
			* @JSP Name : tagMenuConReelaPop.jsp
			* @Description : 태그 아이콘 팝업
			* @Modification Information
			* 
			*       수정일         수정자         수정내용
			*  ----------------------------------------------
			*     2015.09.10       김승준         최초생성
			*
			* author 개발팀 
			* Copyright (C) 2011 by MOPAS  All right reserved.
			*/
%>
<%
	List<Map<String , Object>> tagList = (List)request.getAttribute("tagList");
	String _tagIdx = (String)request.getAttribute("tagIdx");
	String tagIdx = "";
	String tagName = "";
%>
<html>
<head>
<title></title>
<meta name="decorator" content="popupPage">
<script>
var conListTemp = "";

$(document).ready(function() {
	
	conTagList();
	conList();
	
	$('#addconTag').click(function(){addconTag()})
	$('#delconTag').click(function(){delconTag()})
	$('#search').click(function(){search()})
	$('#cancel').click(function(){cancel()})
	$('#save').click(function(){save()})
	
});

function changeTag(){
	$('#conList').text("");
	$('#conTagList').text("");
	
	conList();
	conTagList();
}

function search(){
	$('#conList').text("");
	conList();
}
function conList(){
	
	$.ajax({
	    url:'/tagMenuMng/conList.do',
	    type:'POST',
	    data: {tagIdx : $('#tagIdx').val() , searchText : $('#searchText').val()},
	    dataType: 'json',
	    success: function( json ) {
	    	
	    	$.each(json.conList, function(i, row) {
	    		var innerHtml = '';
	    		
	    		innerHtml += '<li id="conHtml'+row.textIdx+'">';
	    		innerHtml += '<input type="checkbox" id="textIdx'+row.textIdx+'" name="textIdx" value="'+row.textIdx+'"';
	    		
	    		if (row.tagconYn == "Y"){
	    			innerHtml += 'checked="checked" disabled="disabled" ';
	    		} 
	    		
	    		innerHtml += '/> <strong>[CON] '+row.title+'</strong><br />';
	    		innerHtml += '<img src="/vod/file/getImage.do?data_idx='+row.textIdx+'&file_gubun=CONTENTS_TEXT" alt="'+row.title+'" /><br />';
	    		innerHtml += '</li>'; 
	    		
				$('#conList').append(innerHtml);
			});
	    	
	    	conListTemp = json.conList;
	    	
	    	conTagCheck();
    	}
	});
}

function conTagList(){
	
	$.ajax({
	    url:'/tagMenuMng/conTagList.do',
	    type:'POST',
	    data: {tagIdx : $('#tagIdx').val()},
	    dataType: 'json',
	    success: function( json ) {
	        
	    	$.each(json.conTagList, function(i, row) {
    			
				var innerHtml = '';
	    		
	    		innerHtml += '<li id="conTagHtml'+row.textIdx+'">';
	    		innerHtml += '<input type="hidden" id="textIdxTemp'+row.textIdx+'" name="textIdxTemp" value="'+row.textIdx+'" />';
	    		innerHtml += '<input type="checkbox" id="textTagIdx'+row.textIdx+'" name="textTagIdx" value="'+row.textIdx+'" /> <strong>[CON] '+row.title+'</strong><br />';
	    		innerHtml += '<img src="/vod/file/getImage.do?data_idx='+row.textIdx+'&file_gubun=CONTENTS_TEXT" alt="'+row.title+'" /><br />';
	    		innerHtml += '</li>';
	    		
				$('#conTagList').append(innerHtml);
			});
    	}
	});
}

function addconTag() {
	var chkbox = document.getElementsByName("textIdx");
	for(var i=0;i<chkbox.length; i++){
		if(chkbox[i].checked){
			if(!chkbox[i].disabled){
				addconTagHtml(chkbox[i].value);
			}
		}
	}
}

function addconTagHtml(textIdx) {
	
	$.each(conListTemp, function(i, row) {
		
		if (textIdx == row.textIdx) {
			var innerHtml = '';
			
			innerHtml += '<li id="conTagHtml'+row.textIdx+'">';
			innerHtml += '<input type="hidden" id="textIdxTemp'+row.textIdx+'" name="textIdxTemp" value="'+row.textIdx+'" />';
			innerHtml += '<input type="checkbox" id="textTagIdx'+row.textIdx+'" name="textTagIdx" value="'+row.textIdx+'" /> <strong>[CON] '+row.title+'</strong><br />';
			innerHtml += '<img src="/vod/file/getImage.do?data_idx='+row.textIdx+'&file_gubun=CONTENTS_TEXT" alt="'+row.title+'" /><br />';
			innerHtml += '</li>'; 
			
			$('#conTagList').append(innerHtml);
		}
	});
	
	document.getElementById("textIdx"+textIdx).disabled = true;
}

function delconTag() {
	var chkbox = document.getElementsByName("textTagIdx");
	
	$('.c_wrap .tag_list li input[type=checkbox]:checked').each(function (){
		
		$(this).parent('li').remove();
		
		document.getElementById("textIdx"+$(this).val()).checked = false;
		document.getElementById("textIdx"+$(this).val()).disabled = false;
		
	});
}

function conTagCheck() {

	$('.a_wrap .tag_list li').each(function (){
		
		var textIdx = $(this).find('input').val();
		
		document.getElementById("textIdx"+textIdx).checked = false;
		document.getElementById("textIdx"+textIdx).disabled = false;
	});
	
	$('.c_wrap .tag_list li').each(function (){
		
		var textIdx = $(this).find('input').val();
		
		if (document.getElementById("textIdx"+textIdx) != null){
			document.getElementById("textIdx"+textIdx).checked = true;
			document.getElementById("textIdx"+textIdx).disabled = true;	
		}
	});
	
}

function cancel() {
	self.close();
}

function save() {
	if( confirm("저장 하시겠습니까?")){
		$.ajax({
		    url:'/tagMenuMng/saveconTagProc.do',
		    type:'POST',
		    data: $('#tagMenuconRelaFrm').serialize(),
		    dataType: 'json',
		    success: function( data) {
		    	alert(data.msg);
		    	
		    	$('#conList').text("");
		    	$('#conTagList').text("");
		        
		    	conList();
		    	conTagList();
		    }
		});
	}
}

</script>
</head>
<body style="background:none;">
<div class="contents_pop">
	<h2>태그관리 시스템 <span class="text">CONTENTS 연결</span></h2>
	<p class="location"></p>
	<section>
	<form id="tagMenuconRelaFrm" name="tagMenuconRelaFrm" method="post">
		<input type="hidden" id="conListTemp" name="conListTemp" />
		
		<div class="colA">
			<h3 class="h3_title">전체영상</h3>
			<div class="search_block">
				<input type="text" id="searchText" name="searchText" class="textInput_size07" /> <button class="btn_searchPare" id="search">검색</button>
			</div>
			<div class="a_wrap">
				<ul class="tag_list" id="conList">
				</ul>	
			</div>
		</div>
		<div class="colB">
			<ul>
				<li><a href="#" class="btn_arr" id="addconTag">▶</a></li>
				<li><a href="#" class="btn_arr" id="delconTag">◀</a></li>
			</ul>
		</div>
		<div class="colC">
			<!--<h3 class="h3_title"><strong>[주택/도시]</strong> 등록된 영상</h3>-->
			<select class="tag_sel" id="tagIdx" name="tagIdx" onChange="changeTag();">
				<option <%if("".equals(_tagIdx)){ %>selected="selected"<%}%>>태그를 선택해주세요.</option>
<%
				if( tagList != null){
					Map<String , Object> tagListMap;
					for (int i=0; i<tagList.size(); i++) {
						tagListMap = tagList.get(i);
						
						tagIdx  = String.valueOf(tagListMap.get("tagIdx"));
						tagName  = String.valueOf(tagListMap.get("tagName"));
%>
				<option value="<%=tagIdx%>" <%if(tagIdx.equals(_tagIdx)){ %>selected="selected"<%}%>><%=tagName%></option>
<%						
					}
				}
%>				
			</select>
			<div class="c_wrap">
				<ul class="tag_list" id="conTagList">
				</ul>
			</div>
		</div>
		<div class="clear"></div>	
		<p class="btn_block" style="text-align:center;margin-top:40px;">
			<span class="btn_type01 btn"><a href="#" id="save">저장하기</a></span>
			<span class="btn_type05 btn"><a href="#" id="cancel">취소하기</a></span>
		</p>
		</form>
	</section>
</div>
</body>
</html>