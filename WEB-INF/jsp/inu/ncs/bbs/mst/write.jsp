<%@page import="vcms.common.file.util.UvFileUtil"%>
<%@page import="vcms.ncs.util.VodDataUtil"%>
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
	* @JSP Name : write.jsp
	* @Description : 문의게시판 글 생성/수정
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
Map<String , Object> bbsMstInfo = (Map)request.getAttribute("bbsMstInfo");
String modeType = StringUtil.nvl(request.getParameter("modeType"),"");


String bbs_mst_idx      = "";
String templ_idx        = "";
String theme_idx        = "";
String bbs_nm           = "";
String bbs_cont         = "";
String manage_id        = "";
String private_use_yn   = "";
String comment_use_yn   = "";
String attach_use_yn    = "";
String attach_cnt       = "";
String paging_use_yn    = "";
String page_unit        = "";
String page_size        = "";
String auth_btn_yn      = "";
String hot_img_yn       = "";
String hot_img_cnt      = "";
String new_img_yn       = "";
String new_img_dt       = "";
String reg_dt           = "";
String reg_id           = "";
String reg_ip           = "";
String mod_dt           = "";
String mod_id           = "";
String mod_ip           = "";
String del_yn           = "";
String role_id          = "";
String notice_yn        = "";
String fixed_data_yn    = "";
String intro_top        = "";
String intro_footer     = "";
String user_write_yn    = "";
String bbs_mst_idx_list = "";
String community_yn     = "";
String con_auth_type    = "";
String con_auth_list    = "";
String con_auth_view    = "";
String con_auth_write   = "";
String cate_use_yn      = ""; 

String msg = "등록"; 
String actPage = "";
String reg_nm      = ""; 

EgovUserInfoVO user_info = (EgovUserInfoVO)request.getAttribute("user"); 
if( user_info != null ){ 	 
	reg_nm = user_info.getUserNm();	 
}

if( bbsMstInfo == null ){
	modeType = "ins";
	actPage = "/ncs/vod/regist.do";
	msg = "등록";
	
	user_write_yn = "N";
	private_use_yn = "N";
	comment_use_yn = "N";
	attach_use_yn = "N";
	attach_cnt = "0";
	
		
	paging_use_yn = "Y";
	page_unit = "10";
	page_size = "10";
	auth_btn_yn = "N";
	hot_img_yn = "N";
	hot_img_cnt = "0";
	new_img_yn = "N";
	new_img_dt = "0";
	notice_yn  = "N";	
	
} else {
	 
	
	bbs_mst_idx     = String.valueOf(bbsMstInfo.get("bbsMstIdx"));
	templ_idx       = String.valueOf(bbsMstInfo.get("templIdx"));
	bbs_nm     		= StringUtil.nvl(bbsMstInfo.get("bbsNm"),"");
	bbs_cont        = StringUtil.nvl(bbsMstInfo.get("bbsCont"),"");
	private_use_yn  = StringUtil.nvl(bbsMstInfo.get("privateUseYn"),"");
	comment_use_yn  = StringUtil.nvl(bbsMstInfo.get("commentUseYn"),"");	
	attach_use_yn   = StringUtil.nvl(bbsMstInfo.get("attachUseYn"),"");
	
	attach_cnt 		= String.valueOf(bbsMstInfo.get("attachCnt"));	
	paging_use_yn   = String.valueOf(bbsMstInfo.get("pagingUseYn"));
	page_unit 		= String.valueOf(bbsMstInfo.get("pageUnit"));
	page_size 		= String.valueOf(bbsMstInfo.get("pageSize"));
	
	auth_btn_yn 	= StringUtil.nvl(bbsMstInfo.get("authBtnYn"),"");
	hot_img_yn 		= StringUtil.nvl(bbsMstInfo.get("hotImgYn"),"");
	
	hot_img_cnt 	= String.valueOf(bbsMstInfo.get("hotImgCnt"));
	new_img_yn 		= StringUtil.nvl(bbsMstInfo.get("newImgYn"),"");
	
	user_write_yn 	= StringUtil.nvl(bbsMstInfo.get("userWriteYn"),"");
	notice_yn 		= StringUtil.nvl(bbsMstInfo.get("noticeYn"),"");
	
	if( bbsMstInfo.get("regDt") != null ){
		reg_dt = bbsMstInfo.get("regDt").toString();
	}
	
	modeType = "mod";
}

String orgModeType = modeType;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>문의게시판</title>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script language="JavaScript" src="/common/uploadify/uploadify.js"></script>
<script type="text/javascript" src="/common/jwplayer/jwplayer.js"></script>
<script>jwplayer.key="i4sty1oKVhqrdI0BQFRnsqtqOustH4AXbW/K0HOjHfU=";</script>

<script> 
$(document).ready(function() { 
	   
	$('#search').click(function(){search()})
	$('#save').click(function(){save()})
	$('#remove').click(function(){remove()})
	$('#newGuest').click(function(){newGuest()})
	
}); 
  

function search(){  
	var f = document.frm;
	$('#bbs_mst_idx').val('');
	f.action = "/bbs/mst/list.do";
	f.submit();
}

function save(){
	if( $('#bbs_nm').val() == '' || $('#bbs_nm').val() == null ) {
		alert('게시판명을 입력해주세요.');
		$('#bbs_nm').focus();
		return;
	}  
	var f = document.frm; 
	f.action = "/bbs/mst/writeProc.do";
	f.submit();
}

function remove(){
	 
	if( confirm("정말 삭제 하시겠습니까?")){
		$.ajax({
		    url:'/bbs/mst/delProc.do',
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

function newGuest() {
	var f = document.frm;
	$('#bbs_mst_idx').val('');
	f.action = "/bbs/mst/write.do";
	f.submit();
}
 
</script>
</head>
<body>
<ol class="breadcrumb hidden-xs">
    <li>NCS</li>
    <li>게시판 생성 관리</li>
</ol>
<h4 class="page-title">게시판 생성 관리</h4>

<form name="frm" id="frm" method="post"> 
	<input type="hidden" name="bbs_mst_idx" id="bbs_mst_idx" value="<%=bbs_mst_idx%>" />
	  
	<div class="row m-t-15 text-right m-b-10">
		<button id="search" class="btn btn-sm" style="" >목록</button>
		<button class="btn-sm btn" id="save">저장</button>
		<%
			if( "mod".equals(modeType)){
		%>
		<button class="btn-sm btn" id="remove">삭제</button>
		<%
			}
		%>
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
				<th><span class="text-danger">*</span>&nbsp;게시판명</th>
				<td>
					<input type="text" name="bbs_nm" id="bbs_nm" maxlength="100" class="form-control input-sm" value="<%=bbs_nm%>"/>
				</td>
			</tr>
			<tr>
				<th><span class="text-danger">*</span>&nbsp;게시판설명</th>
				<td>
					 <textarea name="bbs_cont" id="bbs_cont" class="form-control overflow" style="width:100%;" rows="2"><%=bbs_cont %></textarea>
				</td>
			</tr>
			
			<tr>
				<th scope="col">게시판 유형</th>
				<td>
					<div class="widget-body uniformjs">
						<select id="templ_idx" name="templ_idx" class="select">
							<option value="BBSTP000001" <%= "BBSTP000001".equals(templ_idx) ? "selected" : "" %>>일반게시판형</option>
							<option value="BBSTP000002" <%= "BBSTP000002".equals(templ_idx) ? "selected" : "" %>>이미지형</option>
							<option value="BBSTP000003" <%= "BBSTP000003".equals(templ_idx) ? "selected" : "" %>>답변형</option> 
						</select> 
					</div>
				</td>
			</tr>
			<tr>
				<th scope="col">사용자 글쓰기여부</th>
				<td>
					<div class="widget-body uniformjs">
						<div class="col-md-1">
							<input type="radio" class="radio" name="user_write_yn" id="user_write_yn" value="Y" <%= "Y".equals(user_write_yn) ? "checked" : "" %>>
							<label>사용</label>
						</div>
						<div class="col-md-1">
							<input type="radio" class="radio" name="user_write_yn" id="user_write_yn" value="N" <%= "N".equals(user_write_yn) ? "checked" : "" %>>
							<label>미사용</label>
						</div>
					</div>
				</td>
			</tr>
			<!-- 
			<tr>
				<th scope="col">비밀글사용여부</th>
				<td>
					<div class="widget-body uniformjs">
						<input type="radio" class="radio" name="private_use_yn" id="private_ues_y" value="Y" <%= "Y".equals(private_use_yn) ? "checked" : "" %>>사용&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" class="radio" name="private_use_yn" id="private_ues_n" value="N" <%= "N".equals(private_use_yn) ? "checked" : "" %>>미사용
					</div>
				</td>
			</tr> -->
			<tr>
				<th scope="col">덧글사용 여부</th>
				<td>
					<div class="widget-body uniformjs">
						<div class="col-md-1">
							<input type="radio" class="radio" name="comment_use_yn" id="comment_use_y" value="Y" <%= "Y".equals(comment_use_yn) ? "checked" : "" %>>
							<label>사용</label>
						</div>
						<div class="col-md-1">
							<input type="radio" class="radio" name="comment_use_yn" id="comment_use_n" value="N" <%= "N".equals(comment_use_yn) ? "checked" : "" %>>
							<label>미사용</label>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="col">첨부파일여부(제한추가)</th>
				<td>
					<div class="widget-body uniformjs">
						<div class="col-md-1">
							<input type="radio" class="radio_02" name="attach_use_yn" id="attach_use_y" value="Y" <%= "Y".equals(attach_use_yn) ? "checked" : "" %>>
							<label>사용</label>
						</div>
						<div class="col-md-1">
							<input type="radio" class="radio_02" name="attach_use_yn" id="attach_use_n" value="N" <%= "N".equals(attach_use_yn) ? "checked" : "" %>>
							<label>미사용</label>
						</div>
						<dic class="col-md-10"/>
							<label class="pull-left">( 첨부파일제한수 :</label>
							<input type="text" name="attach_cnt" id="attach_cnt" value="<%=attach_cnt %>" class="pull-left form-control input-sm m-l-5 m-r-5" style="width:50px;">
							<label class="pull-left">)</label>
						</div>
						
					</div>
				</td>
			</tr>
			<!-- 
			<tr>
				<th scope="col">페이징처리여부</th>
				<td>
					<div class="widget-body uniformjs">
						<input type="radio" class="radio_02" name="paging_use_yn" id="paging_use_y" value="Y" <%= "Y".equals(paging_use_yn) ? "checked" : "" %>>사용&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" class="radio_02" name="paging_use_yn" id="paging_use_n" value="N" <%= "N".equals(paging_use_yn) ? "checked" : "" %>>미사용
						( 한 페이지당 노출 데이터 수 :  <input type="text" name="page_unit" id="page_unit" value="<%=page_unit %>" class="span1">  )
					</div>
				</td>
			</tr>
			<tr>
			<th scope="col">페이징사이즈</th>
				<td>
					<div class="widget-body uniformjs">
						(  페이징부분의 페이지 숫자 :  <input type="text" name="page_size" id="page_size" value="<%=page_size %>" class="span1">  )
					</div>
				</td>
			</tr> -->
			<input type="hidden" name="paging_use_yn" id="paging_use_yn" value="N" />
			<input type="hidden" name="page_unit" id="page_unit" value="10" />
			<input type="hidden" name="page_size" id="page_size" value="10" />
			
			<!-- 
			<tr>
				<th scope="col">권한별버튼노출</th>
				<td>
					<div class="widget-body uniformjs">
						<input type="radio" class="radio" name="auth_btn_yn" id="auth_btn_y" value="Y" <%= "Y".equals(auth_btn_yn) ? "checked" : "" %>>사용&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" class="radio" name="auth_btn_yn" id="auth_btn_n" value="N" <%= "N".equals(auth_btn_yn) ? "checked" : "" %>>미사용
					</div>
				</td>
			</tr>
			 -->
			<tr>
				<th scope="col">HOT 아이콘 설정</th>
				<td>
					<div class="widget-body uniformjs">
						<div class="col-md-1">
							<input type="radio" class="radio_02" name="hot_img_yn" id="hot_img_y" value="Y" <%= "Y".equals(hot_img_yn) ? "checked" : "" %>>
							<label>사용</label>
						</div>
						<div class="col-md-1">
							<input type="radio" class="radio_02" name="hot_img_yn" id="hot_img_n" value="N" <%= "N".equals(hot_img_yn) ? "checked" : "" %>>
							<label>미사용</label>
						</div>
						<div class="col-md-10">
							<label class="pull-left">( 총 조회수 :</label>
							<input type="text" name="hot_img_cnt" id="hot_img_cnt" value="100" class="pull-left form-control input-sm m-l-5 m-r-5" style="width:50px;">
							<label class="pull-left">이상 )</label>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="col">NEW 아이콘 설정</th>
				<td>
					<div class="widget-body uniformjs">
						<div class="col-md-1">
							<input type="radio" class="radio_02" name="new_img_yn" id="new_img_y" value="Y" <%= "Y".equals(new_img_yn) ? "checked" : "" %>>
							<label>사용</label>
						</div>
						<div class="col-md-1">
							<input type="radio" class="radio_02" name="new_img_yn" id="new_img_n" value="N" <%= "N".equals(new_img_yn) ? "checked" : "" %>>
							<label>미사용</label>
						</div>
						<div class="col-md-10">
							<label class="pull-left">( 최근 :</label>
							<input type="text" name="new_img_dt" id="new_img_dt" value="100" class="pull-left form-control input-sm m-l-5 m-r-5" style="width:50px;">
							<label class="pull-left">일 이내 )</label>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="col">공지 기능여부</th>
				<td>
					<div class="widget-body uniformjs">
						<div class="col-md-1">
							<input type="radio" class="radio_02" name="notice_yn" id="notice_y" value="Y" <%= "Y".equals(notice_yn) ? "checked" : "" %>>
							<label>사용</label>
						</div>
						<div class="col-md-1">
							<input type="radio" class="radio_02" name="notice_yn" id="notice_n" value="N" <%= "N".equals(notice_yn) ? "checked" : "" %>>
							<label>미사용</label>
						</div>
					</div>
				</td>
			</tr>
			<!-- 
			<tr>
				<th scope="col">고정글여부</th>
				<td>
					<div class="widget-body uniformjs">
						<input type="radio" class="radio_02" name="fixed_data_yn" id="fixed_data_y" value="Y" checked="checked">사용&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" class="radio_02" name="fixed_data_yn" id="fixed_data_n" value="N">미사용
					</div>
				</td>
			</tr>
			<tr>
				<th scope="col">카테고리사용 여부</th>
				<td>
					<div class="widget-body uniformjs">
						<input type="radio" class="radio_02" name="cate_use_yn" id="cate_use_y" value="Y" checked="checked">사용&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" class="radio_02" name="cate_use_yn" id="cate_use_n" value="N">미사용
					</div>
				</td>
			</tr> 
			 -->
		</table> 
	</div>
	
</form>
</body>
</html>