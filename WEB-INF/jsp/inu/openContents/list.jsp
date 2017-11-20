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
			/**
			* @JSP Name : list.jsp
			* @Description : 노출 컨텐츠 관리
			* @Modification Information
			* 
			*       수정일         수정자         수정내용
			*  ----------------------------------------------
			*	2015.08.28	김승준	최초생성
			*
			* author 개발팀 
			* Copyright (C) 2011 by MOPAS  All right reserved.
			*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>문의게시판</title>
<meta name="decorator" content="defaultPage">
<!-- 
<link type="text/css" rel="stylesheet" href="<c:url value='/js/axisj/ui/arongi/AXJ.min.css'/>">
<script type="text/javascript" src="<c:url value='/js/axisj/dist/AXJ.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXGrid.js'/>"></script> -->
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script>
$(document).ready(function() { 
	//$('#search').click(function(){search()})
	//$('#save').click(function(){save()})
	//$('#remove').click(function(){remove()})
	$('#newBBS').click(function(){fn_regit()})
});
  

/* function search(){ 
	 
	var param = '&bbs_mst_idx='+$('#bbs_mst_idx').val();
	
	var f = document.frm;	
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
	
	$.ajax({
	    url:'/ncs/bbs/writeProc.do',
	    type:'POST',
	    data: $('#frm').serialize(),
	    dataType: 'json',
	    success: function( data) {
	    	alert(data.msg);
	        myGrid.reloadList();
	    }
	});
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
		    }
		});
	}
};*/ 
function fn_regit() {
	
	var f = document.frm;
	f.action = "/openContents/write.do";
	f.submit();
}

/* function fn_view(dataIdx) {
	
	var f = document.frm;
	$('#data_idx').val(dataIdx);
	f.action = "/ncs/bbs/detail.do";
	f.submit();
} */
</script>
</head>
<body>
<h2>노출 컨텐츠 관리</h2>
<p class="location"> 노출 컨텐츠 관리 > 목록</p>

<form name="frm" id="frm" method="post" >
	<input type="hidden" name="sqlId" id="sqlId" value=""/>
	<input type="hidden" name="gridData" id="gridData" value="" />
	<input type="hidden" name="guestSearch" id="guestSearch" value="" />
	<input type="hidden" name="bbs_mst_idx" id="bbs_mst_idx" value="" />
	<input type="hidden" name="data_idx" id="data_idx" value="" />
	 
	<section> 
		<p class="tar Mbo11">
			<button id="search" class="btn_searchTbl06 prevent" style="" >조회</button>
			<span class="btn_type01 btn" id="newBBS"><a href="#">신규</a></span>
		</p>
		
		<div style="overflow-y:scroll; height:500px; border-left:2px solid #cdcdcd; border-right:2px solid #cdcdcd; border-bottom:2px solid #cdcdcd; border-top:2px solid #cdcdcd;">
			<table class="data_tableW" id="data_tableW" summary="" >
				<caption></caption>
				<colgroup>
					<col width="5%"/>
					<col width="10%" />
					<col width="5%" />
					<col width="*" />
					<col width="12%" />
					<col width="12%" />
					<col width="12%" />
					<col width="10%" />
				</colgroup>
				<thead>
				<tr style="background-color: blue;">
					<th>번호</th>
					<th>메뉴</th>
					<th>순서</th>
					<th>제목</th>
					<th>이미지</th>
					<th>서비스시작일자</th>
					<th>서비스종료일자</th>
					<th>등록일</th>
				</tr>
				</thead>
				<tbody>
				<tr>
				 <td>1</td>
				 <td>메뉴1</td>
				 <td>1</td>
				 <td><a href="#" onclick="javascript:fn_view('1');">1박2일</a></td>
				 <td>&nbsp;</td>
				 <td>2015-08-29 19:00</td>
				 <td>2015-08-29 20:10</td>
				 <td>2015-08-22</td>
				</tr>
				<tr>
				 <td>2</td>
				 <td>메뉴2</td>
				 <td>2</td>
				 <td><a href="#" onclick="javascript:fn_view('2');">런닝맨</a></td>
				 <td>&nbsp;</td>
				 <td>2015-08-29 19:00</td>
				 <td>2015-08-29 20:10</td>
				 <td>2015-08-22</td>
				</tr>
				</tbody>
			</table>
		</div>
 	</section>
</form> 	
</body>
</html>