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
var vodListTemp = "";

$(document).ready(function() {
	
	vodTagList();
	vodList();
	
	$('#addVodTag').click(function(){addVodTag()})
	$('#delVodTag').click(function(){delVodTag()})
	$('#search').click(function(){search()})
	$('#cancel').click(function(){cancel()})
	$('#save').click(function(){save()})
	
});

function changeTag(){
	$('#vodList').text("");
	$('#vodTagList').text("");
	
	vodList();
	vodTagList();
}

function search(){
	$('#vodList').text("");
	vodList();
}
function vodList(){
	
	$.ajax({
	    url:'/tagMenuMng/vodList.do',
	    type:'POST',
	    data: {tagIdx : $('#tagIdx').val() , searchText : $('#searchText').val()},
	    dataType: 'json',
	    success: function( json ) {
	    	
	    	$.each(json.vodList, function(i, row) {
	    		var innerHtml = '';
	    		
	    		innerHtml += '<li id="vodHtml'+row.vodIdx+'">';
	    		innerHtml += '<input type="checkbox" id="vodIdx'+row.vodIdx+'" name="vodIdx" value="'+row.vodIdx+'"';
	    		
	    		if (row.tagVodYn == "Y"){
	    			innerHtml += 'checked="checked" disabled="disabled" ';
	    		} 
	    		
	    		innerHtml += '/> <strong>[VOD] '+row.vodTitle+'</strong><br />';
	    		innerHtml += '<img src="/vod/file/getImage.do?data_idx='+row.vodIdx+'" alt="'+row.vodTitle+'" /><br />';
	    		innerHtml += '</li>'; 
	    		
				$('#vodList').append(innerHtml);
			});
	    	
	    	vodListTemp = json.vodList;
	    	
	    	vodTagCheck();
    	}
	});
}

function vodTagList(){
	
	$.ajax({
	    url:'/tagMenuMng/vodTagList.do',
	    type:'POST',
	    data: {tagIdx : $('#tagIdx').val()},
	    dataType: 'json',
	    success: function( json ) {
	        
	    	$.each(json.vodTagList, function(i, row) {
    			
				var innerHtml = '';
	    		
	    		innerHtml += '<li id="vodTagHtml'+row.vodIdx+'">';
	    		innerHtml += '<input type="hidden" id="vodIdxTemp'+row.vodIdx+'" name="vodIdxTemp" value="'+row.vodIdx+'" />';
	    		innerHtml += '<input type="checkbox" id="vodTagIdx'+row.vodIdx+'" name="vodTagIdx" value="'+row.vodIdx+'" /> <strong>[VOD] '+row.vodTitle+'</strong><br />';
	    		innerHtml += '<img src="/vod/file/getImage.do?data_idx='+row.vodIdx+'" alt="'+row.vodTitle+'" /><br />';
	    		innerHtml += '</li>';
	    		
				$('#vodTagList').append(innerHtml);
			});
    	}
	});
}

function addVodTag() {
	var chkbox = document.getElementsByName("vodIdx");
	for(var i=0;i<chkbox.length; i++){
		if(chkbox[i].checked){
			if(!chkbox[i].disabled){
				addVodTagHtml(chkbox[i].value);
			}
		}
	}
}

function addVodTagHtml(vodIdx) {
	
	$.each(vodListTemp, function(i, row) {
		
		if (vodIdx == row.vodIdx) {
			var innerHtml = '';
			
			innerHtml += '<li id="vodTagHtml'+row.vodIdx+'">';
			innerHtml += '<input type="hidden" id="vodIdxTemp'+row.vodIdx+'" name="vodIdxTemp" value="'+row.vodIdx+'" />';
			innerHtml += '<input type="checkbox" id="vodTagIdx'+row.vodIdx+'" name="vodTagIdx" value="'+row.vodIdx+'" /> <strong>[VOD] '+row.vodTitle+'</strong><br />';
			innerHtml += '<img src="/vod/file/getImage.do?data_idx='+row.vodIdx+'" alt="'+row.vodTitle+'" /><br />';
			innerHtml += '</li>';
			
			$('#vodTagList').append(innerHtml);
		}
	});
	
	document.getElementById("vodIdx"+vodIdx).disabled = true;
}

function delVodTag() {
	var chkbox = document.getElementsByName("vodTagIdx");
	
	$('.c_wrap .tag_list li input[type=checkbox]:checked').each(function (){
		
		$(this).parent('li').remove();
		
		document.getElementById("vodIdx"+$(this).val()).checked = false;
		document.getElementById("vodIdx"+$(this).val()).disabled = false;
		
	});
}

function vodTagCheck() {

	$('.a_wrap .tag_list li').each(function (){
		
		var vodIdx = $(this).find('input').val();
		
		document.getElementById("vodIdx"+vodIdx).checked = false;
		document.getElementById("vodIdx"+vodIdx).disabled = false;
	});
	
	$('.c_wrap .tag_list li').each(function (){
		
		var vodIdx = $(this).find('input').val();
		
		if (document.getElementById("vodIdx"+vodIdx) != null){
			document.getElementById("vodIdx"+vodIdx).checked = true;
			document.getElementById("vodIdx"+vodIdx).disabled = true;	
		}
	});
	
}

function cancel() {
	self.close();
}

function save() {
	if( confirm("저장 하시겠습니까?")){
		$.ajax({
		    url:'/tagMenuMng/saveVodTagProc.do',
		    type:'POST',
		    data: $('#tagMenuVodRelaFrm').serialize(),
		    dataType: 'json',
		    success: function( data) {
		    	alert(data.msg);
		    	
		    	$('#vodList').text("");
		    	$('#vodTagList').text("");
		        
		    	vodList();
		    	vodTagList();
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
	<form id="tagMenuVodRelaFrm" name="tagMenuVodRelaFrm" method="post">
		<input type="hidden" id="vodListTemp" name="vodListTemp" />
		
		<div class="colA">
			<h3 class="h3_title">전체영상</h3>
			<div class="search_block">
				<input type="text" id="searchText" name="searchText" class="textInput_size07" /> <button class="btn_searchPare" id="search">검색</button>
			</div>
			<div class="a_wrap">
				<ul class="tag_list" id="vodList">
				</ul>	
			</div>
		</div>
		<div class="colB">
			<ul>
				<li><a href="#" class="btn_arr" id="addVodTag">▶</a></li>
				<li><a href="#" class="btn_arr" id="delVodTag">◀</a></li>
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
				<ul class="tag_list" id="vodTagList">
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