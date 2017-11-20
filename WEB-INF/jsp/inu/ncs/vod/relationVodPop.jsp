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
	/* List<Map<String , Object>> tagList = (List)request.getAttribute("tagList");
	String _tagIdx = (String)request.getAttribute("tagIdx");
	String tagIdx = "";
	String tagName = ""; */
%>
<html>
<head>
<title></title>
<meta name="decorator" content="popupPage">
<script>
var vodListTemp = "";

$(document).ready(function() {
	
	//vodTagList();
	vodList();
	
	$('#search').click(function(){search()});
	$('#cancel').click(function(){cancel()});
});

function search(){
	$('#vodList').text("");
	vodList();
}
function vodList(){
	
	$.ajax({
	    url:'/tagMenuMng/vodList.do',
	    type:'POST',
	    data: {searchText : $('#searchText').val()},
	    dataType: 'json',
	    success: function( json ) {
	    	
	    	$.each(json.vodList, function(i, row) {
console.log(row);
	    		var innerHtml = '';
	    		
	    		innerHtml += '<div class="col-md-3" id="vodHtml'+row.vodIdx+'">';
	    		innerHtml += '<input type="checkbox" class="form-control input-sm" id="vodIdx'+row.vodIdx+'" name="vodIdx" value="'+row.vodIdx+'"';
	    		
	    		if (row.tagVodYn == "Y"){
	    			innerHtml += 'checked="checked" disabled="disabled" ';
	    		} 
	    		
	    		innerHtml += '/> <h6 style="display:inline;">[VOD] '+row.vodTitle+'</h6><br/>';
	    		innerHtml += '<img src="/vod/file/getImage.do?data_idx='+row.vodIdx+'&file_gubun=VOD_IMG" alt="'+row.vodTitle+'" />';
	    		innerHtml += '</div>'; 
	    		
				$('#vodList').append(innerHtml);
			});
	    	
	    	$('input:checkbox:not([data-toggle="buttons"] input, .make-switch input), input:radio:not([data-toggle="buttons"] input)').iCheck({
			    checkboxClass: 'icheckbox_minimal',
			    radioClass: 'iradio_minimal',
			    increaseArea: '20%' // optional
		});
	    
		//Checkbox listing
		var parentCheck = $('.list-parent-check');
		var listCheck = $('.list-check');
	    
		parentCheck.on('ifChecked', function(){
			$(this).closest('.list-container').find('.list-check').iCheck('check');
		});
	    
		parentCheck.on('ifClicked', function(){
			$(this).closest('.list-container').find('.list-check').iCheck('uncheck');
		});
	    
		listCheck.on('ifChecked', function(){
			    var parent = $(this).closest('.list-container').find('.list-parent-check');
			    var thisCheck = $(this).closest('.list-container').find('.list-check');
			    var thisChecked = $(this).closest('.list-container').find('.list-check:checked');
		    
			    if(thisCheck.length == thisChecked.length) {
				parent.iCheck('check');
			    }
		});
	    
		listCheck.on('ifUnchecked', function(){
			    var parent = $(this).closest('.list-container').find('.list-parent-check');
			    parent.iCheck('uncheck');
		});
	    
		listCheck.on('ifChanged', function(){
			    var thisChecked = $(this).closest('.list-container').find('.list-check:checked');
			    var showon = $(this).closest('.list-container').find('.show-on');
			    if(thisChecked.length > 0 ) {
				showon.show();
			    }
			    else {
				showon.hide();
			    }
		});
	    	
	    	vodListTemp = json.vodList;
    	}
	});
}

function addVodTag() {
	var chkbox = document.getElementsByName("vodIdx");
	var addResult = false;
	for(var i=0;i<chkbox.length; i++){
		if(chkbox[i].checked){
			if(!chkbox[i].disabled){
				addVodTagHtml(chkbox[i].value);
				addResult = true;
			}
		}
	}
	
	if(addResult) {
		alert("연관동영상이 추가 되었습니다.\n저장 버튼 클릭시 저장 됩니다.");
		cancel();
	}
}

function addVodTagHtml(vodIdx) {
	$.each(vodListTemp, function(i, row) {
		if (vodIdx == row.vodIdx) {
			var innerHtml = '';
			
			innerHtml += '<li id="vod_idx_'+row.vodIdx+'" class="m-r-10" style="list-style:none;float:left">';
			innerHtml += '<input type="hidden" id="rel_vod_idx" name="rel_vod_idx" class="rel_vod_idx" value="'+row.vodIdx+'" />';
			innerHtml += '<strong>[VOD] '+row.vodTitle+'</strong><br />';
			innerHtml += '<img src="/vod/file/getImage.do?data_idx='+row.vodIdx+'&file_gubun=VOD_IMG" alt="'+row.vodTitle+'" /><br />';
			innerHtml += '<img src="/common/uploadify/images/bt_del_s.gif" style="width:29px;height:16px" onclick=$("#vod_idx_'+row.vodIdx+'").remove();></li>';
			
			opener.jsAddVod(row.vodIdx, innerHtml);
		}
	});
}

function cancel() {
	self.close();
}
</script>
<style>
.tag_list li {
	list-style:none;
}
</style>
</head>
<body style="background:none;">
<ol class="breadcrumb hidden-xs">
    <li>연관 동영상 관리</li>
</ol>
<h4 class="page-title">연관 동영상</h4>
<div class="block-area">
	<form id="tagMenuVodRelaFrm" name="tagMenuVodRelaFrm" method="post">
		<input type="hidden" id="vodListTemp" name="vodListTemp" />
		
		<div class="col-md-12">
			<h3>전체영상</h3>
			<div class="col-md-2 col-md-offset-9">
				<input type="text" id="searchText" name="searchText" class="form-control input-sm" />
			</div>
			<div class="col-md-1">
				<button class="btn-sm btn" id="search">검색</button>
			</div>
			<div class="col-md-12" style="height:550px; overflow-x:hidden; overflow-y:auto;">
				<div class="p-5" id="vodList">
				</div>
			</div>
		</div>
		<div class="col-md-12 m-t-10">
			<button class="btn-sm btn pull-right m-l-10" id="cancel">취소</button>
			<button class="btn-sm btn pull-right" onclick="addVodTag();">확인</buttonn>
		</div>
	</form>
</div>
</body>
</html>