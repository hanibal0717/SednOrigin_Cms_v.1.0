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
			* @Description : VOD게시판 뷰 페이지
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

List<Map<String , Object>> bbsDataFile = (List)request.getAttribute("bbsDataFile");
List<Map<String , Object>> bbsDataFile2 = (List)request.getAttribute("bbsDataFile2");
Map<String , Object> bbsDataInfo = (Map)request.getAttribute("bbsDataInfo");
List<Map<String , Object>> TAG_MENU = (List)request.getAttribute("TAG_MENU");
List<Map<String , Object>> HS_CM_CD = (List)request.getAttribute("HS_CM_CD");

List<Map<String , Object>> relVodList = (List)request.getAttribute("relVodList");
List<Map<String , Object>> USER_MENU = (List)request.getAttribute("USER_MENU");

String modeType = StringUtil.nvl(request.getParameter("modeType"),"");

String fileGubun = "VOD";
String attachUseYn = "Y";
int  attachCnt = 1;

String dataIdx = "";
String attachIdx = "";
String orgFileNm = "";
String actPage  = "";

String vod_idx      = "";
String vod_title    = "";
String vod_cont     = "";
String vod_keyword  = "";
String vod_play_time= "";
String hits         = "";
String atch_file_id = "";
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

if( bbsDataInfo == null ){
	modeType = "ins";

	msg = "등록";
} else {
	
	if( !"reply".equals(modeType) && !"replyM".equals(modeType) ){ 
		modeType = "mod";
		msg = "수정";
	}
	
	vod_idx       = String.valueOf(bbsDataInfo.get("vodIdx"));
	vod_title     = StringUtil.nvl(bbsDataInfo.get("vodTitle"),"");
	reg_nm        = StringUtil.nvl(bbsDataInfo.get("regNm"),"");
	vod_keyword   = StringUtil.nvl(bbsDataInfo.get("vodKeyword"),"");
	vod_play_time = StringUtil.nvl(bbsDataInfo.get("vodPlayTime"),"");
	
	if( bbsDataInfo.get("regDt") != null ){
		reg_dt = bbsDataInfo.get("regDt").toString();
	}
	if( bbsDataInfo.get("modDt") != null ){
		mod_dt = bbsDataInfo.get("modDt").toString();
	}
	vod_cont     = StringUtil.nvl(bbsDataInfo.get("vodCont"),"");
}

String orgModeType = modeType; 

pageContext.setAttribute("LF", "\n");

String USER_AGENT = StringUtil.nvl(request.getAttribute("USER_AGENT"),"");
%>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
</head>
<body>
<style>
.image_size img{max-height:200px;max-width:200px;}
</style>
<ol class="breadcrumb hidden-xs">
    <li>VOD 컨텐츠 관리</li>
    <li>보기</li>
</ol>
<h4 class="page-title">VOD 컨텐츠관리</h4>
<div class="block-area">
<form name="frm" id="frm" method="post" >
	<input type="hidden" name="file_gubun" id="file_gubun" value="<%=fileGubun %>" />
	<input type="hidden" name="vod_idx" id="vod_idx" value="<%=vod_idx %>" />
	<input type="hidden" name="modeType" id="modeType" value="" />
	<input type="hidden" name="regId" id="regId" value="<%=reg_id %>" />
	<input type="hidden" name="authResult" id="authResult" value="${authResult}" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	<input type="hidden" name="search_keyword" id="search_keyword" value="${search_keyword}" />
	<input type="hidden" name="search_type" id="search_type" value="${search_type}" />
	<input type="hidden" name="tag_select_value" id="tag_select_value" value="${tag_select_value}" />
	<input type="hidden" name="hot_select" id="hot_select" value="${hot_select}" />
	<input type="hidden" name="best_select" id="best_select" value="${best_select}" />
	
	<div class="row m-t-15 text-right m-b-10">
		<button id="search" class="btn btn-sm m-r-5" style="">목 록</button>
		<c:set var="authResult" value="${authResult}"/>
		<c:choose>
			<c:when test="${authResult == 'Y'}">
				<button class="btn btn-sm m-r-5" id="modify">수 정</button>
				<button class="btn btn-sm m-r-5" id="remove">삭 제</button>
			</c:when>
			<c:when test="${authResult == 'N'}">
			</c:when>
		</c:choose> 
	</div>

	<div class="table-responsive" style="overflow: hidden; outline: none;">
		<table class="table table-bordered tile">
			<colgroup>
				<col width="12%" />
				<col width="*" />
				<col width="318px" />
			</colgroup>
			<tr>
				<th colspan="3">
					<%=vod_title %>
				</th>
			</tr>
			 <tr>
				<th> 작성자</th>
				<td colspan="2">
					<%=reg_nm %>
				</td>
				<!-- <td rowspan="5">
					<img src="/images/common/thum_01_n.png">
				</td> -->
			</tr>
			<!--<tr>
				<th>TAG</th>
				<td colspan="2">
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
			</tr>-->
			<tr>
				<th>Menu</th>
				<td colspan="2">
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
				<th >재생시간</th>
				<td colspan="2"><%=vod_play_time %></td>
			</tr>
			<!--<tr>
				<th>tag</th>
				<td colspan="2"><%=vod_keyword %></td>
			</tr>-->
			<tr>
				<th>내용</th>
				<td colspan="2"> 
					<%=vod_cont %>
				</td>
			</tr>			
			<tr>
				<th scope="col">썸네일</th>
				<td colspan="2" class="image_size">
				<% if( bbsDataFile != null && bbsDataFile.size() > 0 ) {%>
					<%
					Map<String , Object> bbsDataFileNode;
					for(int i=0; i<bbsDataFile.size(); i++){
						bbsDataFileNode = bbsDataFile.get(i);
					%>
					<img src="<%=bbsDataFileNode.get("fileUrl")%>">
					<%
					}
					%>
				<% }  %>	  
				</td>
			</tr>				
			<tr>
				<th scope="col">동영상</th>
				<td colspan="2">
				<% if( bbsDataFile2 != null && bbsDataFile2.size() > 0 ) {%>
				<%if (!USER_AGENT.equals("Internet Explorer 8")) {%>
				<div name="VOD_ELEMENT" id="VOD_ELEMENT">Loading the player...</div>
				<%} else {%>
					"<%=USER_AGENT%>" 은 Player가 지원 되는 브라우저가 아닙니다.
				<%}%>
				<% }  %>						 
				</td>
			</tr>	 
			
			<tr>
				<th scope="col">Transcoding</th>
				<td colspan="2">
				<%
				if(HS_CM_CD != null){
					Map<String , Object> HS_CM_CD_NODE;
					for(int i = 0; i < HS_CM_CD.size(); i++){
						HS_CM_CD_NODE = HS_CM_CD.get(i);
						%> 
					<input type="checkbox" disabled name="transcoding" onclick="return false;" value='<%=HS_CM_CD_NODE.get("cmCd")%>'/> <%=HS_CM_CD_NODE.get("cmNm")%><br>
						<%
					}
				}
				%>
				<script>
				<%
				String TRANSCODING = "";
				String[] ARR_TRANSCODING = StringUtil.nvl(bbsDataInfo.get("transcoding"),"").split(",");
				for (int j = 0, k = ARR_TRANSCODING.length; j < k; j++) {
				%>
				setValue(document.all.transcoding, "<%=ARR_TRANSCODING[j]%>");
				<%
				}
				%>
				</script>
				</td>
			</tr>
			<tr>
				<th scope="col">연관 동영상</th>
				<td colspan="2">
					<ul class="tag_list" id="REL_VOD_LIST">	
				<%
				if (relVodList != null) {
					for (Map<String , Object> relVod : relVodList) {
				%>
						<li>
						<strong>[VOD] <%=relVod.get("vodTitle")%></strong><br />
						<img src="/vod/file/getImage.do?data_idx=<%=relVod.get("vodIdx")%>&file_gubun=VOD_IMG"/><br />
						</li>
				<%
					}
				}
				%>		
					</ul>
				</td>
			</tr>		
			<!--<tr>
				<th scope="col">구분</th>
				<td colspan="2">
					BEST : <%=StringUtil.nvl(bbsDataInfo.get("best"),"")%>&nbsp;&nbsp;&nbsp;
					NEW : <%=StringUtil.nvl(bbsDataInfo.get("new"),"")%>&nbsp;&nbsp;&nbsp;
					HOT : <%=StringUtil.nvl(bbsDataInfo.get("hot"),"")%>
				</td>
			</tr>-->
			<!--<tr>
				<th scope="col">Template</th>
				<td colspan="2">
					<%=StringUtil.nvl(bbsDataInfo.get("template"),"")%><br><br>
					<img width="300px;" src="/images/<%=StringUtil.nvl(bbsDataInfo.get("template"),"")%>.png">
				</td>
			</tr>-->
		</table>
	</div>
</form>
<div class="row m-t-15 text-right m-b-10">
	<button id="search2" class="btn btn-sm m-r-5" style="">목 록</button>
	<c:set var="authResult" value="${authResult}"/>
	<c:choose>
		<c:when test="${authResult == 'Y'}">
			<button class="btn btn-sm m-r-5" id="modify2">수 정</button>
			<button class="btn btn-sm m-r-5" id="remove2">삭 제</button>
		</c:when>
		<c:when test="${authResult == 'N'}">
		</c:when>
	</c:choose> 
</div>
</div>
<%if (!USER_AGENT.equals("Internet Explorer 8")) {%>
<script type="text/javascript" src="/common/jwplayer/jwplayer.js"></script>
<script>jwplayer.key="i4sty1oKVhqrdI0BQFRnsqtqOustH4AXbW/K0HOjHfU=";</script>
<%}%>
<script> 
$(document).ready(function() {
	
	$('#search').click(function(){search()});
	$('#modify').click(function(){modify()});
	$('#remove').click(function(){remove()});
	
	$('#search2').click(function(){search()});
	$('#modify2').click(function(){modify()});
	$('#remove2').click(function(){remove()});
	
	try{
		jwplayer("VOD_ELEMENT").setup({
			<%--
			[{fileGubun=VOD, dataIdx=4274, attachIdx=BF0000000001, gubun=M, orgFileNm=5538744.mp4, fileNm=4274_vod_Filedata_10324425003345.mp4, filePath=D:/J2EE/workspace/INUC/UPLOAD/VOD/4274_vod_Filedata_10324425003345.mp4, downloadCnt=0, regDt=2016-02-22, delDt=null, delYn=N, fileType=FILE, mainImgFalg=N, trans=null, fileUrl=/UPLOAD/VOD/4274_vod_Filedata_10324425003345.mp4}]
			--%>
			<% 
				if( bbsDataFile2 != null && bbsDataFile2.size() > 0 ) {
					int intImgLoop = 0;
					int intFileLoop = 0;
					for(Map<String , Object> fileInfo : bbsDataFile2) {
						if ((StringUtil.nvl(fileInfo.get("trans")).equals("03")) || "".equals(StringUtil.nvl(fileInfo.get("trans"))) ) {
			%>
						<%if ( bbsDataFile != null && bbsDataFile.size() > 0 && intImgLoop == 0 ){%>
							image: "<%=StringUtil.nvl(bbsDataFile.get(0).get("fileUrl"),"")%>",
						<%intImgLoop = intImgLoop +1;}%>
						<%if ( intFileLoop == 0 ){%>
							file: "<%=StringUtil.nvl(bbsDataFile2.get(0).get("fileUrl"),"")%>"
						<%intFileLoop = intFileLoop +1;}%>
			<%
							}
					}
				}
			%>
		});
	}
	catch(e) {}
}); 
  
function search(){  
	var f = document.frm;
	$('#vod_idx').val('');
	f.action = "/ncs/vod/list.do";
	f.submit();
}
function modify(){ 
	var f = document.frm; 
	$("#modeType").val("mod");
	f.action = "/ncs/vod/write.do";
	f.submit();
}
function remove(){
	if( $('#data_idx').val() == '' ){
		alert("선택된 목록이 없습니다. 삭제하시려는 목록을 체크하세요.");
		return;
	}
	if( confirm("정말 삭제 하시겠습니까?")){
		$.ajax({
		    url:'/ncs/vod/delProc.do',
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
function fn_modify(vod_idx){
	$("#modeType").val("mod");
	$("#vod_idx").val(vod_idx);
	$('#frm').attr('action' , '/ncs/vod/write.do');
	$('#frm').submit();
}
function deleteSite(vod_idx){
	$('#vod_idx').val(vod_idx);
	if( confirm("정말 답변을 삭제 하시겠습니까?")){
		$.ajax({
		    url:'/ncs/vod/delProc.do',
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

</script>
</body>
</html>