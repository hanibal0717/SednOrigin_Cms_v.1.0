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
			* @JSP Name : writeBottomBanner.jsp
			* @Description : 하단 배너 등록/수정
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
Map<String , Object> bbsDataInfo = (Map)request.getAttribute("bbsDataInfo");
String modeType = StringUtil.nvl(request.getParameter("modeType"),"");

String bbsMstIdx = "BM0000000001";
String attachUseYn = "Y";
int  attachCnt = 3;

String dataIdx = "";
String attachIdx = "";
String orgFileNm = "";
String actPage  = "";

String title = "";
String regNm = "";
String privateYn = "";
String regDt = "";
String modDt = "";
String cont = "";
String noticeYn = "";
String msg = "등록"; 

EgovUserInfoVO user_info = (EgovUserInfoVO)request.getAttribute("user"); 
if( user_info != null ){ 	 
	regNm = user_info.getUserNm();	 
}

if( bbsDataInfo == null ){
	modeType = "ins";
	actPage = "/bbs/data/regist.do";
	msg = "등록";
} else {
	
	if( !"reply".equals(modeType) && !"replyM".equals(modeType) ){ 
		modeType = "mod";
		actPage = "/bbs/data/modify.do";
		msg = "수정";
	}
	
	dataIdx   = StringUtil.nvl(bbsDataInfo.get("dataIdx"),"");
	title     = StringUtil.nvl(bbsDataInfo.get("title"),"");
	regNm     = StringUtil.nvl(bbsDataInfo.get("regNm"),"");
	privateYn = StringUtil.nvl(bbsDataInfo.get("privateYn"),"");
	if( bbsDataInfo.get("regDt") != null ){
		regDt = bbsDataInfo.get("regDt").toString();
	}
	if( bbsDataInfo.get("modDt") != null ){
		modDt = bbsDataInfo.get("modDt").toString();
	}
	cont     = StringUtil.nvl(bbsDataInfo.get("cont"),"");
	noticeYn = StringUtil.nvl(bbsDataInfo.get("noticeYn"),"");
}

String orgModeType = modeType;
if( "reply".equals(modeType)){ 
	title = "답변입니다.";
	privateYn = "";
	regDt = "";
	modDt = "";
	cont = "";
	dataIdx = "";
	regNm  = user_info.getUserNm();	
	modeType = "ins";
	actPage = "/bbs/data/regist.do";
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script> 
$(document).ready(function() { 
	   
	$('#search').click(function(){search()})
	$('#save').click(function(){save()})
	$('#remove').click(function(){remove()})
	$('#newGuest').click(function(){newGuest()})
	
}); 
  

function search(){  
	var f = document.frm;
	$('#data_idx').val('');
	f.action = "/ncs/bbs/list.do";
	f.submit();
}
function save(){
	if( $('#title').val() == '' || $('#title').val() == null ) {
		alert('제목을 입력해주세요.')
		return;
	} else if( $('#reg_nm').val() == '' ) {
		alert('작성자명을 입력해주세요.')
		return;
	} 
	/*
	$.ajax({
	    url:'/ncs/bbs/writeProc.do',
	    type:'POST',
	    data: $('#frm').serialize(),
	    dataType: 'json',
	    success: function( data) {
	    	alert(data.msg);
	        myGrid.reloadList();
	        newGuest();
	    }
	});
	*/
	
	var f = document.frm; 
	f.action = "/ncs/bbs/writeProc.do";
	f.submit();
}
function remove(){
	if( $('#data_idx').val() == '' ){
		alert("선택된 목록이 없습니다. 삭제하시려는 목록을 체크하세요.");
		return;
	}
	if( confirm("정말 삭제 하시겠습니까?")){
		$.ajax({
		    url:'/ncs/bbs/delProc.do',
		    type:'POST',
		    data: $('#frm').serialize(),
		    dataType: 'json',
		    success: function( data) {
		    	alert(data.msg);
		        myGrid.reloadList();
		        newGuest();
		    }
		});
	}
};
function newGuest() {
	var f = document.frm;
	$('#data_idx').val('');
	f.action = "/ncs/bbs/write.do";
	f.submit();
}
</script>
</head>
<body>
<h2></h2>
<p class="location"></p>

<form name="frm" id="frm" method="post" enctype="multipart/form-data" >
	<input type="hidden" name="bbs_mst_idx" id="bbs_mst_idx" value="<%=bbsMstIdx %>" />
	<input type="hidden" name="data_idx" id="data_idx" value="<%=dataIdx %>" />
	<input type="hidden" name="bbs_ref" value="${fn:trim( bbsDataInfo.bbsRef) }"/>
	<input type="hidden" name="bbs_level" value="${fn:trim( bbsDataInfo.bbsLevel) }"/>
	<input type="hidden" name="bbs_step" value="${fn:trim( bbsDataInfo.bbsStep) }"/>
	
	<% if( bbsDataFile == null || bbsDataFile.size() == 0 ) {%>	
		<input type="hidden" name="fileListCnt" value="0" />
	<% } %>
 
	<section> 
		<p class="tar Mbo11">
			<button id="search" class="btn_searchTbl06 prevent" style="" >목록</button>
			<span class="btn_type01 btn" id="save"><a href="#">저장</a></span>
			<% if( "mod".equals(modeType)){ %>
			<span class="btn_type05 btn" id="remove"><a href="#">삭제</a></span>
			<% }  %>
		</p>
	 	  
			<h3><span class="tx_red03">*</span>&nbsp;&nbsp;&nbsp;필수입력 항목입니다.</h3>
		
			<table class="data_tableW02">
				<caption></caption>
				<colgroup>
					<col width="" />
					<col width="" />
				</colgroup>
				<tr>
					<th><span class="tx_red02">*</span>&nbsp;제목</th>
					<td colspan="3">
						<input type="text" name="title" id="title" maxlength="100" class="textInput_size04" value="<%=title %>"/>
					</td>
				</tr>
				<tr>
					<th>서비스 시작일/시간</th>
					<td colspan="3">
						<input type="text" value="달력"/>
						<select id="startDate">
							<option> 1</option>
							<option> 2</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td>
						<textarea id="cont" name="cont" class="edt_base" class="textInput_size01" rows="5" cols="30"><%=cont %></textarea>
					</td>
				</tr>

				<% if( "Y".equals(attachUseYn) && attachCnt > 0 ){ %> 
				<tr>
					<th scope="col">첨부파일</th>
				<% if( "mod".equals(modeType) && (bbsDataFile != null && bbsDataFile.size() > 0 ) ){%>
					<td colspan="3">		
					 	<span id="file_upload_posbl"  style="display:none;" >	
							<input type="hidden" name="posblAtchFileNumber" value="<%=attachCnt %>" />	<!-- 첨부 가능한 파일 개수 -->
							<input type="file" name="file_0" id="egovComFileUploader" class="input-file" /><br>
							<div id="egovComFileList"></div>
						</span>
						<span id="file_upload_imposbl"  style="display:none;" >
							더 이상 파일을 첨부할 수 없습니다.
						</span>
					</td>
				<% } else { %>
					<td colspan="3"> 									
						<input type="hidden" name="posblAtchFileNumber" value="<%=attachCnt %>" />	<!-- 첨부 가능한 파일 개수 -->
						<input type="file" name="file_1" id="egovComFileUploader" class="input-file"  />
						<div id="egovComFileList"></div>
						
					</td>
				<% }  %>									
				</tr>
							
							
<% if( "mod".equals(modeType) && bbsDataFile != null && bbsDataFile.size() > 0 ) {%>						
							<tr>
								<th scope="col">기등록파일</th>
								<td colspan="3">
									<input type="hidden" name="returnUrl" value="/ncs/bbs/write.do?bbs_mst_idx=<%=bbsMstIdx %>&data_idx=${bbsDataInfo.dataIdx}"/>
									<c:import url="/bbs/file/selectFileInfsForUpdate.do" charEncoding="utf-8">
										<c:param name="bbsMstIdx" value="<%=bbsMstIdx %>" />
										<c:param name="dataIdx" value="${bbsDataInfo.dataIdx}" />
									</c:import> 
								</td>
							</tr>
							 
<% }  %> 						
<%  
if( "ins".equals(modeType) || ( bbsDataFile == null || bbsDataFile.size() == 0) ) {%>	
				<script type="text/javaScript">
					var maxFileNum = document.frm.posblAtchFileNumber.value;
					
					if(maxFileNum == null || maxFileNum == ""){ maxFileNum = document.frm.fileListCnt.value; }
					var multi_selector = new MultiSelector( document.getElementById( 'egovComFileList' ), maxFileNum, 60 );
					multi_selector.addElement( document.getElementById( 'egovComFileUploader' ) );
				</script> 
					
<% 
} else { %>
			<script type="text/javascript">
				var existFileNum	= document.frm.fileListCnt.value;
				var maxFileNum		= document.frm.posblAtchFileNumber.value;

				if (existFileNum=="undefined" || existFileNum ==null)
				{
					existFileNum = 0;
				}

				if (maxFileNum=="undefined" || maxFileNum ==null)
				{
					maxFileNum = 0;
				}

				var uploadableFileNum = maxFileNum - existFileNum;				

				if (uploadableFileNum<0)
				{
					uploadableFileNum = 0;
				}

				if (uploadableFileNum != 0)
				{
					fn_egov_check_file('Y');
					var multi_selector = new MultiSelector( document.getElementById( 'egovComFileList' ), uploadableFileNum, 71);
					multi_selector.addElement( document.getElementById( 'egovComFileUploader' ) );
				}
				else
				{
					fn_egov_check_file('N');
				}
			</script>
<%} 
}
%>			
			</table> 
	</section>
	
</form>
</body>
</html>