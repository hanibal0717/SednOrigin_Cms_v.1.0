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
<%@ include file="/WEB-INF/jsp/inu/ncs/bbs/bbs_master_info.jsp" %>
<%
			/**
			* @JSP Name : detail.jsp
			* @Description : 문의게시판 뷰 페이지
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
	regNm  = user_info.getUserNm();	
	modeType = "ins";
	actPage = "/bbs/data/regist.do";
}

pageContext.setAttribute("LF", "\n");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>게시판관리</title>
<meta name="decorator" content="defaultPage">
<link type="text/css" rel="stylesheet" href="<c:url value='/js/axisj/ui/arongi/AXJ.min.css'/>">
<script type="text/javascript" src="<c:url value='/js/axisj/dist/AXJ.min.js'/>"></script>
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script> 
$(document).ready(function() {
	$('#search').click(function(){search()})
	$('#modify').click(function(){modify()})
	$('#remove').click(function(){remove()})
	$('#reply').click(function(){fn_reply('${bbsDataInfo.dataIdx}')})
}); 
  
function search(){  
	var f = document.bbs_data_frm;
	$('#data_idx').val('');
	f.action = "/ncs/bbs/list.do";
	f.submit();
}
function modify(){ 
	var f = document.bbs_data_frm; 
	$("#modeType").val("mod");
	f.action = "/ncs/bbs/write.do";
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
		    data: $('#bbs_data_frm').serialize(),
		    dataType: 'json',
		    success: function( data) {
		    	alert(data.msg);
		    	search(); 
		    }
		});
	}
}; 

function fn_reply(data_idx){ 
	$("#modeType").val("reply");
	$("#data_idx").val(data_idx);
	$('#bbs_data_frm').attr('action' , '/ncs/bbs/write.do');
	$('#bbs_data_frm').submit();
}

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
function fn_modify(data_idx){
	$("#modeType").val("mod");
	$("#data_idx").val(data_idx);
	$('#bbs_data_frm').attr('action' , '/ncs/bbs/write.do');
	$('#bbs_data_frm').submit();
}
function deleteSite(data_idx){
	$('#data_idx').val(data_idx);
	if( confirm("정말 답변을 삭제 하시겠습니까?")){
		$.ajax({
		    url:'/ncs/bbs/delProc.do',
		    type:'POST',
		    data: $('#bbs_data_frm').serialize(),
		    dataType: 'json',
		    success: function( data) {
		    	alert(data.msg);
		    	search(); 
		    }
		});
	}
}; 
//덧글 등록
function fn_addComment(){
	if( $("#comm").val() == "" ){
		alert("내용을 입력해 주세요.");
		$("#comm").focus();
		return;
	}
	else {
		if( confirm("덧글을 등록하시겠습니까?")){
			
			 var url = "/bbs/comment/regist.do";
	            
	            $.ajax({
	                type: "post",
	                url: url,
	                data: $('#bbs_data_frm').serialize(),
	                success: function (data) {
	                	if( data != null ){
	                		alert("등록되었습니다.");	
	                	}
	                    
	                    $('#reple_write').html(data);
	                    
	                },error:function(x,e){
	                    alert(x.status);
	                    alert(e);                
	                    if(x.status==0){                
	                        alert('You are offline!!\n Please Check Your Network.');                
	                    }else if(x.status==404){                
	                        alert('Requested URL not found.');                
	                    }else if(x.status==500){                
	                        alert('Internel Server Error.');                
	                    }else if(e=='parsererror'){                
	                        alert('Error.nParsing JSON Request failed.');                
	                    }else if(e=='timeout'){                
	                        alert('Request Time out.');                
	                    }else {                
	                        alert('Unknow Error.n'+x.responseText);                
	                    }
	                }
	            }); 
		}
	}
}
//덧글 삭제
function fn_deleteComment(comment_idx){
	var url = "/bbs/comment/del_proc_ajax.do";
	if( confirm("삭제 하시겠습니까?")){
		$("#comment_idx").val(comment_idx);    
	    $.ajax({
	        type: "post",
	        url: url,
	        data: $('#bbs_data_frm').serialize(),
	        success: function (data) {
	        	if( data != null ){
	        		alert("삭제되었습니다.");	
	        	}
	            $('#reple_write').html(data);
	            
	        },error:function(x,e){
	            alert(x.status);
	            alert(e);                
	            if(x.status==0){                
	                alert('You are offline!!\n Please Check Your Network.');                
	            }else if(x.status==404){                
	                alert('Requested URL not found.');                
	            }else if(x.status==500){                
	                alert('Internel Server Error.');                
	            }else if(e=='parsererror'){                
	                alert('Error.nParsing JSON Request failed.');                
	            }else if(e=='timeout'){                
	                alert('Request Time out.');                
	            }else {                
	                alert('Unknow Error.n'+x.responseText);                
	            }
	        }
	    });
	}
}
// 덧글 수정
function fn_modifyComment(comment_idx){
	var url = "/bbs/comment/modify_ajax.do";
    
	$("#comment_idx").val(comment_idx);    
    $.ajax({
        type: "post",
        url: url,
        data: $('#bbs_data_frm').serialize(),
        success: function (data) {        	
            $('#reple_write').html(data);
            
        },error:function(x,e){
            alert(x.status);
            alert(e);                
            if(x.status==0){                
                alert('You are offline!!\n Please Check Your Network.');                
            }else if(x.status==404){                
                alert('Requested URL not found.');                
            }else if(x.status==500){                
                alert('Internel Server Error.');                
            }else if(e=='parsererror'){                
                alert('Error.nParsing JSON Request failed.');                
            }else if(e=='timeout'){                
                alert('Request Time out.');                
            }else {                
                alert('Unknow Error.n'+x.responseText);                
            }
        }
    }); 
}
// 덧글 수정 처리
function fn_modifyProcComment(comment_idx){
	var url = "/bbs/comment/modify_proc_ajax.do";
	
	if( confirm("수정하시겠습니까?")){
    
		$("#comment_idx").val(comment_idx);    
	    $.ajax({
	        type: "post",
	        url: url,
	        data: $('#bbs_data_frm').serialize(),
	        success: function (data) { 
	        	if( data != null ){
	        		alert("수정되었습니다.");	
	        	}
	            $('#reple_write').html(data);
	            
	        },error:function(x,e){
	            alert(x.status);
	            alert(e);                
	            if(x.status==0){                
	                alert('You are offline!!\n Please Check Your Network.');                
	            }else if(x.status==404){                
	                alert('Requested URL not found.');                
	            }else if(x.status==500){                
	                alert('Internel Server Error.');                
	            }else if(e=='parsererror'){                
	                alert('Error.nParsing JSON Request failed.');                
	            }else if(e=='timeout'){                
	                alert('Request Time out.');                
	            }else {                
	                alert('Unknow Error.n'+x.responseText);                
	            }
	        }
	    });
	}
}
</script>
</head>
<body>
<h2><%=bbsNm %></h2>
<p class="location"> 게시판관리 > 보기</p>

<form name="bbs_data_frm" id="bbs_data_frm" method="post">
	<input type="hidden" name="bbs_mst_idx" id="bbs_mst_idx" value="<%=bbsMstIdx %>" />
	<input type="hidden" name="data_idx" id="data_idx" value="<%=dataIdx %>" />
	<input type="hidden" name="modeType" id="modeType" value="" />
	<input type="hidden" name="regId" id="regId" value="${bbsDataInfo.regId}" />
	<input type="hidden" name="authResult" id="authResult" value="${authResult}" />
	<input type="hidden" name="comment_idx" id="comment_idx" value="" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	 
	
	<% if( bbsDataFile == null || bbsDataFile.size() == 0 ) {%>	
		<input type="hidden" name="fileListCnt" value="0" />
	<% } %>
 
	<section> 
		<p class="tar Mbo11">
			<button id="search" class="btn_searchTbl06 prevent" style="">목록</button>
			<c:set var="authResult" value="${authResult}"/>
			<c:choose>
				<c:when test="${authResult == 'Y'}">
					<span class="btn_type01 btn" id="modify"><a href="#">수정</a></span>
					<span class="btn_type05 btn" id="remove"><a href="#">삭제</a></span>
				</c:when>
				<c:when test="${authResult == 'N'}">
				</c:when>
			</c:choose> 
			<% if( "BBSTP000003".equals(bbsMstInfo.get("templIdx")) ){ %>
			<span class="btn_type01 btn" id="reply"><a href="#">답변</a></span>
			<% }  %>
			
		</p>
	 	   
			
			<h3> <%=title %>  </h3>
			<table class="data_tableW02">
				<caption></caption>
				<colgroup>
					<col width="20%" />
					<col width="*" />
				</colgroup>
				 
				<tr>
					<th> 작성자</th>
					<td>
						<%=regNm %>
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td> 
								<c:import url="/bbs/file/selectImageFileInfs.do" charEncoding="utf-8">
									<c:param name="bbsMstIdx" value="${bbsDataInfo.bbsMstIdx }" />
									<c:param name="dataIdx" value="${bbsDataInfo.dataIdx}" /> 
									<c:param name="groupIdx" value="10" />
								 </c:import>
								 <br />
						${fn:replace(bbsDataInfo.cont, LF, '<br />')}
					</td>
				</tr>
 		
						<% if( bbsDataFile != null && bbsDataFile.size() > 0 ) {%>						
							<tr>
								<th scope="col">첨부파일</th>
								<td colspan="3">
									<input type="hidden" name="returnUrl" value="/ncs/bbs/detail.do?bbs_mst_idx=<%=bbsMstIdx %>&data_idx=${bbsDataInfo.dataIdx}"/>
									<c:import url="/bbs/file/selectFileInfsForUpdate.do" charEncoding="utf-8">
										<c:param name="bbsMstIdx" value="<%=bbsMstIdx %>" />
										<c:param name="dataIdx" value="${bbsDataInfo.dataIdx}" />
									</c:import> 
								</td>
							</tr>
							 
						<% }  %>					
			</table> 
	</section>
	
	
	
			
<c:if test="${bbsDataInfo.refCnt > 0 }">
    <c:forEach items="${bbsQnaAnswerList}" var="item" varStatus="i">
    	<c:set var="title" value="${item.title}" />
		<c:set var="title" value="${fn:replace(title, '<', '&lt;')}"/>
		<c:set var="title" value="${fn:replace(title, '>', '&gt;')}"/>
			<h3>답변 : ${title }  
			<!-- 임시삭제 : start -->
			<c:if test="${not empty item.delYn && item.delYn eq 'Y' }"><span style="color:red;">[임시삭제]</span></c:if>
			<!-- 임시삭제 : end -->
			</h3> 
			<br />
			<div class="tbl_insert">
				<table class="data_tableW02">
					<caption></caption>
					<colgroup>
						<col width="120px" />
       					<col width="*" />
       					<col width="120px" />
       					<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col">내용</th>
							<td colspan="3">
								<c:import url="/bbs/file/selectImageFileInfs.do" charEncoding="utf-8">
									<c:param name="bbsMstIdx" value="${item.bbsMstIdx }" />
									<c:param name="dataIdx" value="${item.dataIdx}" /> 
									<c:param name="groupIdx" value="20" />
								 </c:import>
								 <br />
								 ${fn:replace(item.cont, LF, '<br />')}						
							</td>
						</tr>
<% if( "Y".equals(attachUseYn) && attachCnt > 0 ){ %> 
						<tr>
							<th scope="col">첨부파일</th>
							<td colspan="3"> 
							
								<input type="hidden" name="returnUrl" value="/bbs/data/form.do?bbs_mst_idx=${item.bbsMstIdx }&data_idx=${item.dataIdx}"/>
								<c:import url="/bbs/file/selectFileInfsForUpdate.do" charEncoding="utf-8">
									<c:param name="bbsMstIdx" value="${item.bbsMstIdx }" />
									<c:param name="dataIdx" value="${item.dataIdx}" />
								</c:import> 
				
							</td>
						</tr>
<% } %>						
					</tbody>
				</table>
				
				</div>
			</section>
			
			<p class="btn_block"> 
					<span class="btn_type01 btn"><a href="#답변수정" onclick="javascript:fn_modify('${item.dataIdx}');">답변수정</a></span>
					<span class="btn_type05 btn"><a href="#답변삭제" onclick="javascript:deleteSite('${item.dataIdx}');">답변삭제</a></span>
			</p>
				</c:forEach>
</c:if>				


<% if( "Y".equals(commentUseYn)){ %>
<div class="reple_write" id="reple_write">
<!-- 덧글 시작 -->
<c:import url="/WEB-INF/jsp/inu/ncs/bbs/comment_list.jsp" />
<!-- 덧글 마지막 -->
</div>
<% }  %>
			
</form>

</body>
</html>