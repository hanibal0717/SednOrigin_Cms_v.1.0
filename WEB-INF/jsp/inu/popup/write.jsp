<%@page import="vcms.common.util.DateUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="vcms.common.file.util.UvFileUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="vcms.common.util.StringUtil" %>

<%
	Map<String, Object> popUp = (Map)request.getAttribute("popUp");
	if (popUp == null) {
		popUp = new HashMap<String, Object>();
	}
	
	List<Map<String , Object>> filePC = (List)request.getAttribute("filePC");
	List<Map<String , Object>> fileMobile = (List)request.getAttribute("fileMobile");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>문의게시판</title>
<meta name="decorator" content="defaultPage">

<script language="JavaScript" src="/common/uploadify/uploadify.js"></script>

<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>

<script> 
/* $(document).ready(function() { 
	$(function() {
        $(".datepicker").datepicker();
    }); 
});  */

$(function() {
    $( "#P_START_DATE" ).datepicker({
    	changeMonth: true, 
        changeYear: true,
        nextText: '다음 달',
        prevText: '이전 달', 
      	showButtonPanel: false, 
        currentText: '오늘 날짜', 
        closeText: '닫기', 
        dateFormat: "yy-mm-dd",
        dayNames: ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
        dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
    });
});

$(function() {
    $( "#P_END_DATE" ).datepicker({
    	changeMonth: true, 
        changeYear: true,
        nextText: '다음 달',
        prevText: '이전 달', 
      	showButtonPanel: false, 
        currentText: '오늘 날짜', 
        closeText: '닫기', 
        dateFormat: "yy-mm-dd",
        dayNames: ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
        dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
    });
});

function jsSave(){
	if( $('#P_TITLE').val() == '' || $('#P_TITLE').val() == null ) {
		alert('제목을 입력해주세요.');
		$('#P_TITLE').focus();
		return;
	}

	var startDt = $('#P_START_DATE').val();
	startDt = startDt.replace(/-/g, '');
	if(startDt == '' || startDt == null ) {
		alert('서비스 시작 날짜를 입력해 주세요.');
		$('#P_START_DATE').focus();
		return;
	}else if(startDt.length != 8 || isNaN(startDt)){
		alert('서비스 시작 날짜를 형식에 맞게 입력해주세요.');
		return;
	}
	
	var endDt = $('#P_END_DATE').val();
	endDt = endDt.replace(/-/g, '');
	if(endDt == '' || endDt == null){
		alert('서비스 종료 날짜를 입력해 주세요.');
		$('#P_END_DATE').focus();
		return;
	} else if(endDt.length != 8 || isNaN(endDt)){
		alert('서비스 종료 날짜를 형식에 맞게 입력해주세요.');
		return;
	}
	
	$('#P_START_DATE').val(startDt);
	$('#P_END_DATE').val(endDt);
	
	$.ajax({
		<%if ("".equals(StringUtil.nvl(String.valueOf(popUp.get("pSeq"))))) {%>
	    url:'/popup/register.do',
	    <%} else {%>
	    url:'/popup/modify.do',
	    <%}%>
	    type:'POST',
	    data: $('#frm').serialize(),
	    dataType: 'json',
	    success: function( data) {
	    	alert(data.msg);
	    	jsList();
	    }
	});
}

function jsList() {
	var f = document.frm; 
	f.action = "/popup/list.do";
	f.submit();
}
</script>
</head>
<body>
<ol class="breadcrumb hidden-xs">
	<li>배너 관리</li>
    <li>팝업 관리</li>
</ol>
<h4 class="page-title">팝업 관리</h4>

<form name="frmSc" id="frmSc" method="get">
</form>

<form name="frm" id="frm" method="post">
	<input type="hidden" name="P_SEQ" id="P_SEQ" value="<%=StringUtil.nvl(String.valueOf(popUp.get("pSeq")))%>">
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	<input type="hidden" name="search_keyword" id="search_keyword" value="${search_keyword}" />
	<input type="hidden" name="search_type" id="search_type" value="${search_type}" />
	
	<div class="row m-t-15 text-right m-b-10">
		<button id="search" class="btn-sm btn" style="" onclick="jsList();">목록</button>
		<button class="btn-sm btn" id="save" onclick="jsSave();">저장</button>
	</div>
	<div class="alert alert-danger">필수 입력 항목입니다.</div>
	<div class="table-responsive overflow" style="overflow: hidden; outline: none;">
		<table class="table table-bordered tile">
			<caption></caption>
			<colgroup>
				<col width="" />
				<col width="" />
			</colgroup>
			<tr>
				<th><span class="text-danger">*</span>&nbsp;제목</th>
				<td colspan="3">
					<div class="col-md-12">
						<input type="text" name="P_TITLE" id="P_TITLE" maxlength="200" class="form-control input-sm" value="<%=StringUtil.nvl(popUp.get("pTitle"))%>"/>
					</div>
				</td>
			</tr>
			<tr>
				<th><span class="text-danger">*</span>서비스 시작 날짜/시간</th>
				<td colspan="3">
					<div class="col-md-2">
						<input type="text" class="form-control input-sm" id="P_START_DATE" name="P_START_DATE" value="<%=DateUtil.getDayFormat(StringUtil.nvl(popUp.get("pStartDate")), "-")%>"/>
					</div>
					<div class="col-md-1">
						<select id="P_START_HH" name="P_START_HH" class="select pull-left">
							<%for(int i=0; i<24; i++){%>
							<option value="<%=StringUtil.rpad(String.valueOf(i), 2, "")%>"><%=StringUtil.rpad(String.valueOf(i), 2, "")%></option>
							<%}%>						
						</select>
					</div>
					<label class="pull-left">시</label>
					<div class="col-md-1">
						<select id="P_START_MM" name="P_START_MM" class="select pull-left">
							<%for(int i=0; i<6; i++){%>
							<option value="<%=StringUtil.rpad(String.valueOf(i * 10), 2, "")%>"><%=StringUtil.rpad(String.valueOf(i * 10), 2, "")%></option>
							<%}%>	
						</select>
					</div>
					<label class="pull-left">분</label>
					<div class="col-md-2">날짜 예시) 2015-01-01</div>
					<script>
						$("#P_START_HH").val("<%=StringUtil.nvl(popUp.get("pStartHh"), "0")%>");
						$("#P_START_MM").val("<%=StringUtil.nvl(popUp.get("pStartMm"), "0")%>");
					</script>
				</td>
			</tr>
			<tr>
				<th><span class="text-danger">*</span>서비스 종료 날짜/시간</th>
				<td colspan="3">
					<div class="col-md-2">
						<input type="text" id="P_END_DATE" name="P_END_DATE" class="form-control input-sm" value="<%=DateUtil.getDayFormat(StringUtil.nvl(popUp.get("pEndDate")), "-")%>"/>
					</div>
					<div class="col-md-1">
						<select id="P_END_HH" name="P_END_HH" class="select pull-left">
							<%for(int i=0; i<24; i++){%>
							<option value="<%=StringUtil.rpad(String.valueOf(i), 2, "")%>"><%=StringUtil.rpad(String.valueOf(i), 2, "")%></option>
							<%}%>						
						</select>
					</div>
					<label class="pull-left">시</label>
					<div class="col-md-1">
						<select id="P_END_MM" name="P_END_MM" class="select pull-left">
							<%for(int i=0; i<6; i++){%>
							<option value="<%=StringUtil.rpad(String.valueOf(i * 10), 2, "")%>"><%=StringUtil.rpad(String.valueOf(i * 10), 2, "")%></option>
							<%}%>	
						</select>
					</div>
					<label class="pull-left">분</label>
					<div class="col-md-2">날짜 예시) 2015-01-01</div>
					<script>
						$("#P_END_HH").val("<%=StringUtil.nvl(popUp.get("pEndHh"), "0")%>");
						$("#P_END_MM").val("<%=StringUtil.nvl(popUp.get("pEndMm"), "0")%>");
					</script>
				</td>
				
			</tr>
			<tr>
				<th>내용</th>
				<td>
					<div class="col-md-12">
						<textarea id="P_CONT" name="P_CONT" class="form-control overflow" rows="5"><%=StringUtil.nvl(popUp.get("pCont"))%></textarea>
					</div>
				</td>
			</tr>
		<tr>
			<th>링크 URL</th>
			<td>
				<div class="col-md-12">
					<input type="text" name="P_LINK_URL" id="P_LINK_URL" maxlength="500" class="form-control input-sm" value="<%=StringUtil.nvl(popUp.get("pLinkUrl"))%>"/>
				</div>
			</td>
		</tr>
		<tr>
			<th scope="col">팝업 이미지 (PC)<br /></th>
			<td colspan="3">
				<div class="col-md-12">
				<%=UvFileUtil.drawSingleUpload("POPUP", "P", "*.jpg; *.png;", "10000MB")%>		
				<%
				if( filePC != null && filePC.size() > 0 ) {
					String rtn = "";
					String IMG_URL = "/UPLOAD/POPUP/";
					for (Map<String , Object> file : filePC) {
						if (StringUtil.nvl(file.get("fileType")).equals("IMG")) {
							rtn = rtn + "jsDrawImageFile('POPUP', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", " + file.get("dataIdx") + ", '" + IMG_URL + "', '" + file.get("mainImgFalg")+ "');\n";	
						} else {
							rtn = rtn + "jsDrawFile('POPUP', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", '" + file.get("fileType") + "', " + file.get("dataIdx") + ");\n";
						}
					}
				%>
				<script type="text/javascript">
				<%=rtn%>
				</script>
				<%
				}
				%>
				</div>
			</td>
		</tr>
		<tr>
			<th scope="col">팝업 이미지 (Mobile)</th>
			<td colspan="3">
				<div class="col-md-12">
				<%=UvFileUtil.drawSingleUpload("POPUP_M", "M", "*.jpg; *.png;", "10000MB")%>		
				<%
				if( fileMobile != null && fileMobile.size() > 0 ) {
					String rtn = "";
					String IMG_URL = "/UPLOAD/POPUP_M/";
					for (Map<String , Object> file : fileMobile) {
						if (StringUtil.nvl(file.get("fileType")).equals("IMG")) {
							rtn = rtn + "jsDrawImageFile('POPUP_M', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", " + file.get("dataIdx") + ", '" + IMG_URL + "', '" + file.get("mainImgFalg")+ "');\n";	
						} else {
							rtn = rtn + "jsDrawFile('POPUP_M', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", '" + file.get("fileType") + "', " + file.get("dataIdx") + ");\n";
						}
					}
				%>
				<script type="text/javascript">
				<%=rtn%>
				</script>
				<%
				}
				%>
				</div>
			</td>
		</tr>
		<tr>
			<th>X, Y 좌표</th>
			<td>
				<div class="col-md-12">
					<label class="pull-left">X :</label>
					<input type="text" name="P_X" id="P_X" maxlength="50" class="form-control input-sm pull-left m-r-10" style="width:50px;" value="<%=StringUtil.nvl(popUp.get("pX"))%>"/>
					
					<label class="pull-left">Y :</label>
					<input type="text" name="P_Y" id="P_Y" maxlength="50" class="form-control input-sm pull-left" style="width:50px;" value="<%=StringUtil.nvl(popUp.get("pY"))%>"/>
				</div>
			</td>
		</tr>
		<tr>
			<th>사용여부</th>
				<td colspan="3">
					<div class="col-md-12">
						<select id="P_USE_YN" name="P_USE_YN" class="select">
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
						<script>
							setValue(document.all.P_USE_YN, "<%=StringUtil.nvl(popUp.get("pUseYn"), "Y")%>");
						</script>
					</div>
				</td>
			</tr>	 
		</table> 
	</div>
</form>
<div class="row m-t-15 text-right m-b-10">
	<button id="search2" class="btn-sm btn" style="" onclick="jsList();">목록</button>
	<button class="btn-sm btn" id="save2" onclick="jsSave();">저장</button>
</div>
</body>
</html>