<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%
			/*
			* @JSP Name : list.jsp
			* @Description : 태그 정보 관리
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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script>

$(document).ready(function() { 
	loadList();
	
	$('#save').click(function(){save()})
	$('#appendTag').click(function(){tagNameCheck()})
	
});

function tagNameCheck() {
	
	var appendTagName = $("#appendTagName").val();
	var checkData = 0;
	
	$.ajax({
	    url:'/tagMenuMng/tagMenuList.do',
	    type:'POST',
	    data:"",
	    dataType: 'json',
	    success: function( json ) {
	    	
	    	$.each(json.list, function(i, row) {
	    		
		    	if (appendTagName == row.tagName) {
		    		checkData = 1;
		    	}
	    	});
	    	
		    if(checkData == 0) {
		    	appendTag();
		    } else if(checkData == 1) {
		    	alert("동일한 태그이름이 존재합니다.");
		    	return;
		    }
	    }
	    
	    });

}

function loadList(sortValue){
	
	$('#data_tableW').find('tbody').empty();
	var param = '&listSort='+sortValue;
	
	$.ajax({
    url:'/tagMenuMng/tagMenuList.do',
    type:'POST',
    data:param,
    dataType: 'json',
    success: function( json ) {
        
    	var selectServiceY = "";
		var selectServiceN = "";
		var selectService = "";
		var contentCount = "";
		
    	$.each(json.list, function(i, row) {
    		
    		var rownum = i + 1;
    		
    		if (row.tagServiceYn == "Y") {
	   			selectServiceY = "selected=selected";
    		} else if (row.tagServiceYn == "N") {
    			selectServiceN = "selected=selected";
    		} else if (row.tagServiceYn == "" || row.tagServiceYn == null) {
    			selectService = "";
    		}
    		
    		if (row.contentCnt == 0 ) {
    			contentCount = "";
    		} else {
    			contentCount = row.textCnt + row.vodCnt;
    		}
    		
    		var innerHtml = '';
    		
    		innerHtml += '<tr id="'+row.tagIdx+'">';
    		innerHtml += '<td><input type=hidden id=tagIdx name=tagIdx value='+row.tagIdx+'>'+rownum+'</td>';
    		innerHtml += '<td style="text-align:left;"><input type=text class=textInput_size14 id=tagName name=tagName value='+row.tagName+ '></td>';
    		innerHtml += '<td style="text-align:left;"><input type=text class=textInput_size14 id=tagDesc name=tagDesc value='+row.tagDescription+ '></td>';
    		innerHtml += '<td>';
    		innerHtml += '<input type=hidden id="tagIconUrl'+row.tagIdx+'" name=tagIconUrl value='+row.tagIconUrl+ '>';
    		innerHtml += '<img id="tagIconImg'+row.tagIdx+'" style="background-color:black; width:30px; height:29px;" src='+row.tagIconUrl.replace('upload','UPLOAD')+'> &nbsp;&nbsp; ';
    		innerHtml += '<button id="tagIconPop" class=btn_searchPare6 style="width:50px; height:30px; line-height:30px;" onclick="return openFullWindow('+row.tagIdx+');">선택</button>';
    		innerHtml += '</td>';
    		innerHtml += '<td><input type=text class="numberDotOnly" size="16" style="text-align:center;" id=tagSeq name=tagSeq maxlength=2 value='+row.tagSeq+ '></td>';
    		innerHtml += '<td>';
    		innerHtml += '<input type=hidden name="serviceYnTemp" id="serviceYnTemp" value='+row.tagServiceYn+'>';
    		innerHtml += '<select class=select_size06 name=serviceYn id=serviceYn>';
    		innerHtml += '<option ' + selectService + ' value="">선택</option>';
    		innerHtml += '<option ' + selectServiceY + ' value="Y">Y</option>';
    		innerHtml += '<option ' + selectServiceN + ' value="N">N</option>';
    		innerHtml += '</select>';
    		innerHtml += '</td>';
    		innerHtml += '<td>';
    		innerHtml += '' + contentCount + '';
    		innerHtml += '</td>';
    		innerHtml += '<td>';
    		innerHtml += '<button id="tagIconPop" class=btn_searchPare7 style="width:50px; height:23px;line-height:23px;" onclick="return tagMenuVodRelaPop('+row.tagIdx+');">VOD</button>';
    		innerHtml += '</td>';
    		innerHtml += '<td>'; 
    		innerHtml += '<button id="tagConPop" class=btn_searchPare8 style="width:70px; height:23px; line-height:23px;" onclick="return tagMenuConRelaPop('+row.tagIdx+');">TEXT</button>';
    		innerHtml += '</td>';
    		innerHtml += '<td>'; 
    		innerHtml += '<button id="tagConAllPop" class=btn_searchPare5 style="width:70px; height:23px;" onclick="return tagMenuVodConRelaPop('+row.tagIdx+');">VIEW</button>';
    		innerHtml += '</td>';
    		innerHtml += '<td>'; 
    		innerHtml += '<button class=btn_searchPare5 style="width:50px; height:23px;" onclick="deleteTag('+row.tagIdx+');">삭제</button>';
    		innerHtml += '</td>';
    		innerHtml += '</tr>'; 
    		
        	selectServiceY = "";
    		selectServiceN = "";
    		selectService = "";
    		
			$('#data_tableW').find('tbody').append(innerHtml);
        });
		
    	var listCnt = json.list.length;
    	var tagCount = json.tagCount;
    	
		$('#listCnt').val(listCnt);
		$('#totalListCnt').val(tagCount);
		
    }
});
}

function appendTag(){
	
 	var inputTagName = $("#appendTagName").val();
	if (inputTagName == "" || inputTagName == null) {
		alert("태그이름을 입력하세요.");
		return;
	}
	
	var tagIdxTemp = Number($('#totalListCnt').val()) + 1;
	var tagNumber = Number($('#listCnt').val()) + 1;
	var innerHtml = '';
	
	innerHtml += '<tr id="'+ tagIdxTemp +'">';
	innerHtml += '<td><input type=hidden id=tagIdx name=tagIdx value='+tagIdxTemp+'>'+tagNumber+'</td>';
	innerHtml += '<td style="text-align:left;"><input type=text class=textInput_size14 id=tagName name=tagName value="'+ $("#appendTagName").val() +'"></td>';
	innerHtml += '<td style="text-align:left;"><input type=text class=textInput_size14 id=tagDesc name=tagDesc value=""></td>';
	innerHtml += '<td>';
	innerHtml += '<input type=hidden id="tagIconUrl'+tagIdxTemp+'" name=tagIconUrl value="">';
	innerHtml += '<img id="tagIconImg'+tagIdxTemp+'" style="background-color:black; width:30px; height:29px;" src=""> &nbsp;&nbsp; ';
	innerHtml += '<button id="tagIconPop" class=btn_searchPare6 style="width:50px; height:30px;" onclick="return openFullWindow('+tagIdxTemp+');">선택</button>';
	innerHtml += '</td>';
	innerHtml += '<td><input type=text class="numberDotOnly" size="16" style="text-align:center;"id=tagSeq name=tagSeq maxlength=2 value="999"></td>';
	innerHtml += '<td>';
	innerHtml += '<input type=hidden name=serviceYnTemp id=serviceYnTemp value="">';
	innerHtml += '<select class=select_size06 name=serviceYn id=serviceYn>';
	innerHtml += '<option value=>선택</option>';
	innerHtml += '<option value=Y>Y</option>';
	innerHtml += '<option selected=selected value=N>N</option>';
	innerHtml += '</select>';
	innerHtml += '</td>';
	innerHtml += '<td>';
	innerHtml += '</td>';
	innerHtml += '<td>';
	innerHtml += '<button id="tagIconPop" class=btn_searchPare7 style="margin-top:5px; width:50px; height:23px;" onclick="return tagMenuVodRelaPop('+tagIdxTemp+');">VOD</button>';
	innerHtml += '</td>';
	innerHtml += '<td>'; 
	innerHtml += '<button id="tagConPop" class=btn_searchPare8 style="margin-top:5px; width:50px; height:23px;" onclick="return tagMenuConRelaPop('+tagIdxTemp+');">TEXT</button>';
	innerHtml += '</td>';
	innerHtml += '<td>'; 
	innerHtml += '<button id="tagConAllPop" class=btn_searchPare5 style="width:70px; height:23px;" onclick="return tagMenuVodConRelaPop('+tagIdxTemp+');">VIEW</button>';
	innerHtml += '</td>';
	innerHtml += '<td>'; 
	innerHtml += '<button class=btn_searchPare5 style="width:50px; height:23px;" onclick="deleteTag('+tagIdxTemp+');">삭제</button>';
	innerHtml += '</td>';
	innerHtml += '</tr>';
	
	$('#data_tableW').find('tbody').append(innerHtml);
	$('#listCnt').val(tagNumber);
	$('#totalListCnt').val(tagIdxTemp);
	
	var param = '&addTagIdx='+tagIdxTemp+'&addTagName='+$("#appendTagName").val();
	
	$.ajax({
        url:'/tagMenuMng/insertTagMenu.do',
        type:'post',
        data:param,
        success:function(data){
        	alert("추가되었습니다.");
        	$("#appendTagName").val("");
        }
	});
	
}

function save(){
		document.frm.action = "/tagMenuMng/updateTag.do";
		document.frm.submit(); 
		
		/*
  		$.ajax({
	        url:'/tagMenuMng/updateTag.do',
	        type:'post',
	        data:$("#frm").serialize(),
	        success:function(data){
	        	alert("저장되었습니다.");
	        }
		});
		*/
}

function openFullWindow(tagIdx, value) {
	
	var screenSizeWidth, screenSizeHeight;
	if (self.screen) { 
	  screenSizeWidth = 585;  
	  screenSizeHeight = 600;
	}  
	
	documentURL = "/tag/tagMenuMng/tagIconPop.do?tagNo="+tagIdx;
	windowName = "태그아이콘목록";
	intWidth = screenSizeWidth;
	intHeight = screenSizeHeight;
	intXOffset = 140;
	intYOffset = 140;
	
	objWindow = window.open(documentURL,windowName, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes,resizable=no");
	objWindow.resizeTo(intWidth, intHeight);
	objWindow.moveTo(intXOffset, intYOffset);
}

function tagMenuVodRelaPop(tagIdx, value) {
	
	var screenSizeWidth, screenSizeHeight;
	if (self.screen) { 
	  screenSizeWidth = 1180;  
	  screenSizeHeight = 830;
	}  
	
	documentURL = "/tag/tagMenuMng/tagMenuVodRelaPop.do?tagIdx="+tagIdx;
	windowName = "태그아이콘목록";
	intWidth = screenSizeWidth;
	intHeight = screenSizeHeight;
	intXOffset = 140;
	intYOffset = 70;
	
	objWindow = window.open(documentURL,windowName, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes,resizable=yes");
	objWindow.resizeTo(intWidth, intHeight);
	objWindow.moveTo(intXOffset, intYOffset);
}

function tagMenuVodConRelaPop(tagIdx, value) {
	
	var screenSizeWidth, screenSizeHeight;
	if (self.screen) { 
	  screenSizeWidth = 1180;  
	  screenSizeHeight = 830;
	}  
	
	documentURL = "/tag/tagMenuMng/tagMenuVodConRelaPop.do?tagIdx="+tagIdx;
	windowName = "태그아이콘목록";
	intWidth = screenSizeWidth;
	intHeight = screenSizeHeight;
	intXOffset = 140;
	intYOffset = 70;
	
	objWindow = window.open(documentURL,windowName, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes,resizable=yes");
	objWindow.resizeTo(intWidth, intHeight);
	objWindow.moveTo(intXOffset, intYOffset);
}

function tagMenuConRelaPop(tagIdx, value) {
	var screenSizeWidth, screenSizeHeight;
	if (self.screen) { 
	  screenSizeWidth = 1180;  
	  screenSizeHeight = 830;
	}  
	
	documentURL = "/tag/tagMenuMng/tagMenuConRelaPop.do?tagIdx="+tagIdx;
	windowName = "컨텐츠아이콘목록";
	intWidth = screenSizeWidth;
	intHeight = screenSizeHeight;
	intXOffset = 140;
	intYOffset = 70;
	
	objWindow = window.open(documentURL,windowName, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes,resizable=yes");
	objWindow.resizeTo(intWidth, intHeight);
	objWindow.moveTo(intXOffset, intYOffset);
}

function setTagIconUrl(iconUrl, tagIdx){
	
	$('#tagIconUrl'+tagIdx).val(iconUrl);
	document.getElementById('tagIconImg'+tagIdx).src = iconUrl;
	
}

function deleteTag(tagIdx) {
	var param = '&tagIdx='+tagIdx;
	
	if (confirm("정말 삭제 하시겠습니까?")) {
	
	$.ajax({
	    url:'/tagMenuMng/deleteTagMenu.do',
	    type:'POST',
	    data:param,
	    dataType: 'json',
	    success: function( json ) {
			alert("삭제하였습니다.");
			location.reload();
	    }
	    
	    });
	
	}
}
</script>
</head>
<body>
<h2>태그정보관리<span class="text"></span></h2>
<p class="location"> 시스템관리 > 태그정보관리</p>
	<p class="tar Mbo10">
		<span class="btn_type01 btn" id="save"><a href="#">저장</a></span>
	</p>
	
	<h3>
		<span style="text-aign:right;line-height:36px;"><input type="text" id="appendTagName" name="appendTagName" value="" placeholder="태그이름" />&nbsp;<button id="appendTag" class="btn_searchPare9" style="width:50px;height:23px;margin-top:7px;line-height:23px;">태그추가</button></span>
	</h3>
	<!-- <div style="height:500px; border-left:2px solid #cdcdcd; border-right:2px solid #cdcdcd; border-bottom:2px solid #cdcdcd; border-top:2px solid #cdcdcd;"> -->	
		<div style="overflow-y:scroll; height:555px; border-left:2px solid #cdcdcd; border-right:2px solid #cdcdcd; border-bottom:2px solid #cdcdcd; border-top:2px solid #cdcdcd;">
		<form name="frm" id="frm" method="post" onsubmit="return false">
			<input type="hidden" id="listCnt" name="listCnt" />
			<input type="hidden" id="totalListCnt" name="totalListCnt" />
			<input type="hidden" id="listSort" name="listSort" value="" />
			<table class="data_tableW" id="data_tableW" summary="">
				<caption></caption>
				<colgroup>
					<col width="5%"/>
					<col width="*" />
					<col width="*" />
					<col width="10%" />
					<col width="7%" />
					<col width="8%" />
					<col width="8%" />
					<col width="8%" />
					<col width="8%" />
					<col width="8%" />
					<col width="5%" />
				</colgroup>
				<thead>
				<tr style="background-color: blue;">
					<th>
						번호</br>
						<button onclick="loadList(1);" style="background-color:#f9f9f9;">▲</button>
						<button onclick="loadList(2);" style="background-color:#f9f9f9;">▼</button>
					</th>
					<th>
						태그 이름</br>
						<button onclick="loadList(3);" style="background-color:#f9f9f9;">▲</button>
						<button onclick="loadList(4);" style="background-color:#f9f9f9;">▼</button>
					</th>
					<th>태그 설명</th>
					<th>태그 아이콘</th>
					<th>
						노출 우선순위</br>
						<button onclick="loadList(5);" style="background-color:#f9f9f9;">▲</button>
						<button onclick="loadList(6);" style="background-color:#f9f9f9;">▼</button>
					</th>
					<th>
						노출 여부</br>
						<button onclick="loadList(7);" style="background-color:#f9f9f9;">▲</button>
						<button onclick="loadList(8);" style="background-color:#f9f9f9;">▼</button>
					</th>
					<th>
						컨텐츠 수</br>
						<button onclick="loadList(9);" style="background-color:#f9f9f9;">▲</button>
						<button onclick="loadList(10);" style="background-color:#f9f9f9;">▼</button>
					</th>
					<th colspan="2">CONTENTS 연결하기</th>
					<th>전체</br>CONTENTS</th>
					<th>삭제</th>
				</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</form>
	</div>	
</body>
</html>