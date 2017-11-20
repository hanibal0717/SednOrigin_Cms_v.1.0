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
	
});

function changeTag(){
	$('#vodTagList').text("");
	
	vodTagList();
}

function search(){
}

function vodTagList(){
	
	$.ajax({
	    url:'/tagMenuMng/vodConTagList.do',
	    type:'POST',
	    data: {tagIdx : $('#tagIdx').val()},
	    dataType: 'json',
	    success: function( json ) {
	        
	    	$.each(json.vodConTagList, function(i, row) {
    			
				var innerHtml = '';
	    		
	    		innerHtml += '<li id="vodTagHtml'+row.idx+'">';
	    		innerHtml += '<strong>['+row.conType+'] '+row.title+'</strong><br />';
	    		if (row.conType == 'TEXT') {
	    			innerHtml += '<img src="/vod/file/getImage.do?data_idx='+row.idx+'&file_gubun=CONTENTS_TEXT" alt="'+row.title+'" /><br />';
	    		} else {
	    			innerHtml += '<img src="/vod/file/getImage.do?data_idx='+row.idx+'&file_gubun=VOD_IMG" alt="'+row.title+'" /><br />';
	    		}
	    		
	    		innerHtml += '</li>';
	    		
				$('#vodTagList').append(innerHtml);
			});
    	}
	});
}

</script>
</head>
<body style="background:none;">
<div class="contents_pop">
	<h2>태그관리 시스템 <span class="text"></span></h2>
	<p class="location"></p>
	<section>
	<form id="tagMenuVodRelaFrm" name="tagMenuVodRelaFrm" method="post">
		<input type="hidden" id="vodListTemp" name="vodListTemp" />
		
		<div>
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
		</form>
	</section>
</div>
</body>
</html>