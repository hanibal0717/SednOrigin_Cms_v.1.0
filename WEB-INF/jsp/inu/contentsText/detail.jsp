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
			* @JSP Name : detail.jsp
			* @Description : Image & Text 뷰 페이지
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
List<Map<String , Object>> USER_MENU = (List)request.getAttribute("USER_MENU");
List<Map<String , Object>> bbsDataFile = (List)request.getAttribute("bbsDataFile");

List<Map<String , Object>> TAG_MENU = (List)request.getAttribute("TAG_MENU");

String modeType = StringUtil.nvl(request.getParameter("modeType"),"");

String text_idx     = "";
String title        = "";
String cont         = "";
String menu         = "";
String hits         = "";
String reg_dt       = "";
String reg_id       = "";
String reg_nm       = "";
String reg_ip       = "";
String mod_dt       = "";
String mod_id       = "";
String mod_ip       = "";
String del_yn       = "";
String msg = "등록"; 

EgovUserInfoVO user_info = (EgovUserInfoVO)request.getAttribute("user"); 
if( user_info != null ){ 	 
	reg_nm = user_info.getUserNm();	 
}
	
text_idx       = String.valueOf(bbsDataInfo.get("textIdx"));
title     = StringUtil.nvl(bbsDataInfo.get("title"),"");
reg_nm        = StringUtil.nvl(bbsDataInfo.get("regNm"),"");

if( bbsDataInfo.get("regDt") != null ){
	reg_dt = bbsDataInfo.get("regDt").toString();
}
if( bbsDataInfo.get("modDt") != null ){
	mod_dt = bbsDataInfo.get("modDt").toString();
}
cont     = StringUtil.nvl(bbsDataInfo.get("cont"),"");

String orgModeType = modeType; 

pageContext.setAttribute("LF", "\n");

%>
<meta name="decorator" content="defaultPage">
</head>
<body>
<ol class="breadcrumb hidden-xs">
    <li>Image & Text 컨텐츠 관리</li>
    <li>보기</li>
</ol>
<h4 class="page-title">Image & Text 컨텐츠 관리</h4>

<form name="frm" id="frm" method="post" >
	<input type="hidden" name="text_idx" id="text_idx" value="<%=text_idx %>" />
	<input type="hidden" name="modeType" id="modeType" value="" />
	<input type="hidden" name="regId" id="regId" value="<%=reg_id %>" />
	<input type="hidden" name="authResult" id="authResult" value="${authResult}" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	<input type="hidden" name="search_keyword" id="search_keyword" value="${search_keyword}" />
	<input type="hidden" name="best_select" id="best_select" value="${best_select}" />
	 
	<div class="row m-t-15 text-right m-b-10">
		<button id="search" class="btn btn-sm" style="">목 록</button>
		<c:set var="authResult" value="${authResult}"/>
		<c:choose>
			<c:when test="${authResult == 'Y'}">
				<button class="btn-sm btn" id="modify">수 정</button>
				<button class="btn-sm btn" id="remove">삭 제</button>
			</c:when>
			<c:when test="${authResult == 'N'}">
			</c:when>
		</c:choose> 
	</div>
	 	   
   <h4> <%=title %>  </h4>
   <div class="table-responsive overflow" style="overflow: hidden; outline: none;">
			<table class="table table-bordered tile">
				<caption></caption>
				<colgroup>
					<col width="20%" />
					<col width="*" />
				</colgroup>
				<tr>
					<th>TagMenu</th>
					<td>
						<div id="TAG_DIV">
						<%
						String[] ARR_TAG = StringUtil.nvl(bbsDataInfo.get("tag"),"").split(",");
						for (int j = 0, k = ARR_TAG.length; j < k; j++) {
							Map<String , Object> TAG_MENU_NODE;
							for(int i = 0; i < TAG_MENU.size(); i++){
								TAG_MENU_NODE = TAG_MENU.get(i);
								if (ARR_TAG[j].equals(TAG_MENU_NODE.get("tagIdx").toString())) {
						%>
								<p>ㆍ<%=TAG_MENU_NODE.get("tagName")%></p>
						<%
								}
							}
						}
						%>
						</div>
					</td>
				</tr>
				<tr>
					<th>Menu</th>
					<td>
						<div id="MENU_DIV">
						<%
						String[] ARR_MENU = StringUtil.nvl(bbsDataInfo.get("menu"),"").split(",");
						for (int j = 0, k = ARR_MENU.length; j < k; j++) {
							String MENU_NAME = "";
							
							String[] ARR_MENU_SUB = ARR_MENU[j].split("`");
							for(int i = 0; i < ARR_MENU_SUB.length; i++){
								for (Map<String , Object> USER_MENU_NODE : USER_MENU) {
									if (ARR_MENU_SUB[i].equals(USER_MENU_NODE.get("menuSeq").toString())) {
										MENU_NAME = MENU_NAME +  USER_MENU_NODE.get("menuName") + " > ";
										break;
									} 
								} 
							}
							
							if (MENU_NAME.length() > 0) {
							%>
							<p>ㆍ<%=MENU_NAME.substring(0, MENU_NAME.length() - 3)%></p>
							<%
							}
						}
						%>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="col">썸네일</th>
					<td colspan="3" class="image_size">
					<% if( bbsDataFile != null && bbsDataFile.size() > 0 ) {%>
						<%
						Map<String , Object> bbsDataFileNode;
						for(int i=0; i<bbsDataFile.size(); i++){
							bbsDataFileNode = bbsDataFile.get(i);
						%>
						<img src="/upload/CONTENTS_TEXT/<%=bbsDataFileNode.get("fileNm")%>">
						<%
						}
						%>
					<% }  %>  
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td> 
						<%= cont %>
					</td>
				</tr>				
			</table> 
	</div>
</form>
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script type="text/javascript" src="/common/jwplayer/jwplayer.js"></script>
<script>jwplayer.key="i4sty1oKVhqrdI0BQFRnsqtqOustH4AXbW/K0HOjHfU=";</script>
<script> 
$(document).ready(function() {
	$('#search').click(function(){search()});
	$('#modify').click(function(){modify()});
	$('#remove').click(function(){remove()});
}); 
  
function search(){  
	var f = document.frm;
	$('#text_idx').val('');
	f.action = "/contentsText/list.do";
	f.submit();
}
function modify(){ 
	var f = document.frm; 
	$("#modeType").val("mod");
	f.action = "/contentsText/write.do";
	f.submit();
}
function remove(){
	if( $('#text_idx').val() == '' ){
		alert("선택된 목록이 없습니다. 삭제하시려는 목록을 체크하세요.");
		return;
	}
	if( confirm("정말 삭제 하시겠습니까?")){
		$.ajax({
		    url:'/contentsText/delProc.do',
		    type:'POST',
		    data: $('#frm').serialize(),
		    dataType: 'json',
		    success: function( data) {
		    	alert(data.msg);
		    	search(); 
		    }
		});
	}
}; 
 
var tempWidth = -1;
var imgWidth  = 0;
var imgHeight = 0;
var imgMaxWidth  = 0;    
var imgIndexNum  = 0;

function setImgFit(imgObj, maxWidth, imageIndex) {
    imgMaxWidth = maxWidth;
    imgIndexNum = imageIndex;
    imgFit(imgObj);
}
function imgFit(imgObj, maxWidth) {
    imgWidth  = imgObj.width;
    imgHeight = imgObj.height;        
    imgWidth  = imgObj.width;        
    if ( imgWidth != 0 ) {            
        if ( tempWidth == imgWidth ) {
            if (imgObj.width > imgMaxWidth) {
                imgObj.width = imgMaxWidth;
            }
        } else {
            tempWidth = imgWidth;
            setTimeout("imgFit(document.displayImg"+imgIndexNum+");", 50);
        }            
    } else {
        tempWidth = imgWidth;
        setTimeout("imgFit(document.displayImg"+imgIndexNum+");", 50);
    }
}
</script>
</body>
</html>