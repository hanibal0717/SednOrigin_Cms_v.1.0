<%@page import="java.io.Console"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="vcms.common.file.util.UvFileUtil"%>
<%@page import="vcms.ncs.util.VodDataUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%@page import="vcms.common.egov.EgovUserInfoVO" %>
<%
			/**
			* @JSP Name : layoutMng.jsp
			* @Description : 화면 구성 관리
			* @Modification Information
			* 
			*       수정일         수정자         수정내용
			*  ----------------------------------------------
			*     2015.09.18       박경택         최초생성
			*
			* author 개발팀 
			* Copyright (C) 2011 by MOPAS  All right reserved.
			*/
%>
<%
 
Map<String , Object> layoutDetail = (Map)request.getAttribute("layoutDetail");
List<Map<String , Object>> bbsDataFile  = (List)request.getAttribute("bbsDataFile");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script type="text/javascript" src="/js/jquery/jquery.ui.datepicker.js" charset="utf-8"></script>
<script type="text/javascript" src="<c:url value='/js/calendar_beans_v2.2.js'/>"></script>
<script language="JavaScript" src="/common/uploadify/uploadify.js"></script>
<script>
$(document).ready(function() {
    
	$('#save').click(function(){save()});
	
	var logodelYn = '${layoutDetail.delYn}';
	
	if (logodelYn == "Y") {
		$("#logoDelYn").attr('checked', true);
		$('#logoImageTr').hide();
	}
	
	$("#logoDelYn").change(function(){
		
		var delYn = "";
		
        if ($("#logoDelYn").is(":checked")) {
        	delYn = "Y";
        } else {
        	delYn = "N";
        }
        
        var param = 'logoDelYn='+delYn;
        
    	$.ajax({
    	    url:'/system/deleteLogo.do',
    	    type:'POST',
    	    data:param,
    	    dataType: 'json',
    	    success: function( json ) {
    			if (delYn == "Y") {
    				alert("로고 이미지가 해제되었습니다.");
    			} else {
    				alert("로고 이미지를 사용합니다.");
    			}
    			location.reload();
    	    }
    	});
    });
	
});

function save() {
/* 	$.ajax({
	    url:'/system/layoutSave.do',
	    type:'POST',
	    data: $('#frm').serialize(),
	    dataType: 'json',
	    success: function( data) {
	    	alert(data.msg);
	    }
	}); */
	
	var f = document.frm; 
	f.action = "/system/layoutSave.do";
	f.submit();
	
}
</script>
</head>
	
<body>
<h2>화면 구성 관리<span class="text"></span></h2>
<p class="location"></p>
<form name="frm" id="frm" method="post" >
	<input type="hidden" name="regId" id="regId" value="${userId}" />
	<section> 
		<p class="tar Mbo11">
			<!-- <button id="list" class="btn_searchTbl06 prevent">목록</button> -->
			<span class="btn_type01 btn" id="save"><a href="#">저장</a></span>
		</p>
			<h3>화면 구성 관리</h3>
			<table class="data_tableW02">
				<caption></caption>
				<colgroup>
					<col width="20%" />
					<col width="*" />
				</colgroup>
				<tr>
					<th>하단 문구(Copyright)</th>
					<td>
						<input type="text" id="copyright" name="copyright" class="textInput_size02" value="${layoutDetail.copyright}" /> 
					</td>
				</tr>
				<tr id="logoImageTr">
					<th>로고 이미지</th>
					<td>
					<%=UvFileUtil.drawSingleUpload("ADM_LOGO", "A", "*.png; *.jpg;", "10000MB")%>
					<%
						if( bbsDataFile != null && bbsDataFile.size() > 0 ) {
							String rtn = "";
							String IMG_URL = "/upload/ADM_LOGO/";
							for (Map<String , Object> file : bbsDataFile) {
								if (StringUtil.nvl(file.get("fileType")).equals("IMG")) {
									rtn = rtn + "jsDrawImageFile('ADM_LOGO', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", " + file.get("dataIdx") + ", '" + IMG_URL + "', '" + file.get("'Y'")+ "');\n";	
								} else {
									rtn = rtn + "jsDrawFile('ADM_LOGO', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", '" + file.get("fileType") + "', " + file.get("dataIdx") + ");\n";
								}
							}
						%>
						<script type="text/javascript">
						<%=rtn%>
						</script>
						<%
						}
						%>				
					</td>
				</tr>
				<tr>
					<th>로고 이미지 감추기</th>
					<td>
						<input type="checkbox" id="logoDelYn" name="logoDelYn" value="Y" />
						&nbsp; 체크 : 로고 감추기 / 체크해제 : 로고 보이기
					</td>
				</tr>
			</table> 
		</form>
	</section>
</body>
</html>

