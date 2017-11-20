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
	* @Description : VOD 컨텐츠 등록/수정
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
List<Map<String , Object>> bbsDataFile  = (List)request.getAttribute("bbsDataFile");  // 썸네일
List<Map<String , Object>> bbsDataFile2 = (List)request.getAttribute("bbsDataFile2"); // 동영상
Map<String , Object> bbsDataInfo = (Map)request.getAttribute("bbsDataInfo");

List<Map<String , Object>> TAG_MENU = (List)request.getAttribute("TAG_MENU");
List<Map<String , Object>> TAG_SELECT_MENU = (List)request.getAttribute("TAG_SELECT_MENU");

List<Map<String , Object>> HS_CM_CD = (List)request.getAttribute("HS_CM_CD");

List<Map<String , Object>> relVodList = (List)request.getAttribute("relVodList");

List<Map<String , Object>> USER_MENU = (List)request.getAttribute("USER_MENU");
List<Map<String , Object>> USER_MENU_MASTER = (List)request.getAttribute("USER_MENU_MASTER");

System.out.println("커맨드맵(태그메뉴) : " + TAG_MENU);
System.out.println("커맨드맵(태그셀렉트메뉴) : " + TAG_SELECT_MENU);
System.out.println("커맨드맵(HS_CM_CD) : " + HS_CM_CD);
System.out.println("커맨드맵(USER_MENU) : " + USER_MENU);
System.out.println("커맨드맵(USER_MENU_MASTER) : " + USER_MENU_MASTER);

String modeType = StringUtil.nvl(request.getParameter("modeType"),"");
String trans = "";

String fileGubun = "VOD";
String attachUseYn = "Y";
int  attachCnt = 1; 

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
String startDate = "";

String msg = "등록"; 
String actPage = "";

EgovUserInfoVO user_info = (EgovUserInfoVO)request.getAttribute("user"); 
if( user_info != null ){ 	 
	reg_nm = user_info.getUserNm();	 
}

if( bbsDataInfo == null ){
	modeType = "ins";
	actPage = "/ncs/vod/regist.do";
	msg = "등록";
} else {
	
	if( !"reply".equals(modeType) && !"replyM".equals(modeType) ){ 
		modeType = "mod";
		actPage = "/ncs/vod/modify.do";
		msg = "수정";
	}
	
	vod_idx       = String.valueOf(bbsDataInfo.get("vodIdx"));
	vod_title     = StringUtil.nvl(bbsDataInfo.get("vodTitle"),"");
	reg_nm        = StringUtil.nvl(bbsDataInfo.get("regNm"),"");
	vod_keyword   = StringUtil.nvl(bbsDataInfo.get("vodKeyword"),"");
	vod_play_time = StringUtil.nvl(bbsDataInfo.get("vodPlayTime"),"");
	
	if( bbsDataInfo.get("regDt") != null ){
		reg_dt = bbsDataInfo.get("regDt").toString();
		startDate = bbsDataInfo.get("regDt").toString();
	}
	if( bbsDataInfo.get("modDt") != null ){
		mod_dt = bbsDataInfo.get("modDt").toString();
	}
	vod_cont     = StringUtil.nvl(bbsDataInfo.get("vodCont"),"");
}

String orgModeType = modeType;

String USER_AGENT = StringUtil.nvl(request.getAttribute("USER_AGENT"),"");
%>

<meta name="decorator" content="defaultPage">
<body>
<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js"></script>
<script type="text/javascript" src="/common/uploadify/uploadify.js"></script>
<style>
	.ui-datepicker-month {
		background-color:#87b6d9;
	}
	.ui-datepicker-year {
		background-color:#87b6d9;
	}
</style>
<ol class="breadcrumb hidden-xs">
    <li>VOD 컨텐츠 관리</li>
    <li>등록 & 수정</li>
</ol>
<h4 class="page-title">VOD 컨텐츠관리</h4>
<div class="block-area">
<form name="frm" id="frm" method="post">
	<input type="hidden" name="file_gubun" id="file_gubun" value="<%=fileGubun%>" />
	<input type="hidden" name="vod_idx" id="vod_idx" value="<%=vod_idx%>" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
	<input type="hidden" name="search_keyword" id="search_keyword" value="${search_keyword}" />
	<input type="hidden" name="search_type" id="search_type" value="${search_type}" />
	<input type="hidden" name="tag_select_value" id="tag_select_value" value="${tag_select_value}" />
	<input type="hidden" name="hot_select" id="hot_select" value="${hot_select}" />
	<input type="hidden" name="best_select" id="best_select" value="${best_select}" />
	
	<%
	if( bbsDataFile == null || bbsDataFile.size() == 0 ) {
	%>	
	<input type="hidden" name="fileListCnt" value="0" />
	<%
	}
	%>
 
	<div class="row m-t-15 text-right m-b-10">
		<button id="list" class="btn btn-sm m-r-5">목 록</button>
		<button class="btn btn-sm m-r-5" id="save">저 장</button>
		<%
			if( "mod".equals(modeType)){
		%>
		<button class="btn btn-sm m-r-5" id="remove">삭 제</button>
		<%
			}
		%>
	</div>
	<div class="alert alert-danger">
        * 필수입력 항목입니다.
    </div>		
	<div class="table-responsive" style="overflow: hidden; outline: none;">
		<table class="table table-bordered tile" >
			<caption></caption>
			<colgroup>
				<col width="15%" />
				<col width="*" />
				<col width="318px" />
			</colgroup>
			<tr>
				<th><span class="text-danger">*</span>&nbsp;제목</th>
				<td colspan="2">
					<div class="col-md-12">
						<input type="text" name="vod_title" id="vod_title" maxlength="100" class="form-control input-sm" value="<%=vod_title%>"/>
					<div class="col-md-12">
				</td>
				<!-- <td rowspan="5">
					<img src="/images/common/thum_01_n.png">
				</td> -->
			</tr>
			<tr>
				<th><span class="text-danger">*</span>&nbsp;작성자</th>
				<td colspan="2">
					<div class="col-md-12">
						<input type="text" name="reg_nm" id="reg_nm" maxlength="100" class="form-control input-sm" value="<%=reg_nm%>" />
					</div>
				</td>
			</tr>
			<!--<tr>
				<th>TAG</th>
				<td colspan="2">
					<div class="col-md-2">
						<select id="tag_select" name="tag_select" class="select">
							<option value="">선택</option>
						<%
							if(TAG_MENU != null){
								Map<String , Object> TAG_MENU_NODE;
								for(int i = 0; i < TAG_MENU.size(); i++){
									TAG_MENU_NODE = TAG_MENU.get(i);
						%>
							<option value="<%=String.valueOf(TAG_MENU_NODE.get("tagIdx"))%>"><%=String.valueOf(TAG_MENU_NODE.get("tagName"))%></option>
							<%
								}
							}
							%> 
						</select>
					</div>
					<div class="col-md-1">
						<buton class="btn btn-sm m-r-5" onclick="jsAddTag();">추가</button>
					</div>
					<div class="col-md-12 m-t-5" id="TAG_DIV">
					<%
						int row = 1;
						if (bbsDataInfo != null) {
							String[] ARR_TAG = StringUtil.nvl(bbsDataInfo.get("tag"),"").split(",");
							for (int j = 0, k = ARR_TAG.length; j < k; j++) {
								Map<String , Object> TAG_MENU_NODE;
								for(int i = 0; i < TAG_MENU.size(); i++){
									TAG_MENU_NODE = TAG_MENU.get(i);
									if (ARR_TAG[j].equals(TAG_MENU_NODE.get("tagIdx").toString())) {
					%>
							<p id='TAG_DIV_<%=row%>' val='<%=TAG_MENU_NODE.get("tagIdx")%>'>ㆍ<%=TAG_MENU_NODE.get("tagName")%>&nbsp;<a href="javascript:;" onclick="jsDelTag('TAG_DIV_<%=row%>')">[삭제]</a></p>
					<%
										row++;
									}
								}
							}
						}
					%>
					</div>
					<input type="hidden" name="tag" id="tag">
					<script type="text/javascript">
						TAG_DIV_COUNT = <%=row%>;
					</script>
				</td>
			</tr>-->
			<input type="hidden" name="tag" id="tag" value="6">
			<tr>
				<th><span class="text-danger">*</span> Menu</th>
				<td colspan="2">
					<div class="col-md-2">
						<select id="menu_select" name="menu_select" onchange="jsChangeMenu();" class="select">
							<option value="">선택</option>
						<%
							if(USER_MENU != null){
								for (Map<String , Object> USER_NEMU_NODE : USER_MENU) {
						%>
							<option value="<%=String.valueOf(USER_NEMU_NODE.get("menuSeq"))%>"><%=String.valueOf(USER_NEMU_NODE.get("menuName"))%></option>
							<%
								}
							}
							%> 
						</select>
					</div>
					<div class="col-md-2">
						<select id="menu_select2" name="menu_select2" class="select" style="display: none;">
							<option value="">선택</option>
						</select>
					</div>
					<div class="col-md-1">
						<button class="btn btn-sm" onclick="jsAddMenu()">추가</button>
					</div>
					<div class="col-md-12 m-t-5" id="MENU_DIV">
					<%
					row = 1;
					
					if (bbsDataInfo != null) {
						String[] ARR_MENU = StringUtil.nvl(bbsDataInfo.get("menu"),"").split(",");
						for (int j = 0, k = ARR_MENU.length; j < k; j++) {
							String MENU_NAME = "";
							
							String[] ARR_MENU_SUB = ARR_MENU[j].split("`");
							for(int i = 0; i < ARR_MENU_SUB.length; i++){
								for (Map<String , Object> USER_MENU_NODE : USER_MENU_MASTER) {
									if (ARR_MENU_SUB[i].equals(USER_MENU_NODE.get("menuSeq").toString())) {
										MENU_NAME = MENU_NAME +  USER_MENU_NODE.get("menuName") + " > ";
										break;
									} 
								}
							}
							
							if (MENU_NAME.length() > 0) {
							%>
							<p id='MENU_DIV_<%=row%>' val='<%=ARR_MENU[j]%>'>ㆍ<%=MENU_NAME.substring(0, MENU_NAME.length() - 3)%>&nbsp;<a href="javascript:;" onclick="jsDelMenu('MENU_DIV_<%=row%>')">[삭제]</a></p>
							<%
								row++;
							}
						}
					}
					%>
					</div>
					<input type="hidden" name="menu" id="menu">
					<script type="text/javascript">
						MENU_DIV_COUNT = <%=row%>;
					</script>
				</td>
			</tr>
			<tr>
				<th>재생 시간</th>
				<td colspan="2">
					<div class="col-md-12">
						<input type="text" name="vod_play_time" id="vod_play_time" maxlength="100" class="form-control input-sm m-b-10" value="<%=vod_play_time%>"/>
					</div>
				</td>
			</tr>
			<tr>
				<th><span class="text-danger">*</span>&nbsp;등록일</th>
				<td colspan="2">
					<div class="col-md-2">
						<input type="text" id="startDate" name="startDate" maxlength="10" class="form-control input-sm m-b-10" size="12"  value="<%=reg_dt%>" />
					</div>
				</td>
			</tr>
			<tr>
				<th>내용</th>
				<td colspan="2">
					<div class="col-md-12">
						<textarea id="vod_cont" name="vod_cont" class="form-control overflow" rows="5" cols="30"><%=vod_cont%></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="col"><span class="text-danger">*</span> 썸네일</th>
				<td colspan="2">
					<div class="col-md-12">
				<%=UvFileUtil.drawMultiUpload("VOD_IMG", "T", "*.png; *.jpg;", "10000MB")%>
				<%
					if( bbsDataFile != null && bbsDataFile.size() > 0 ) {
						String rtn = "";
						for (Map<String , Object> file : bbsDataFile) {
							if (StringUtil.nvl(file.get("fileType")).equals("IMG")) {
								rtn = rtn + "jsDrawImageFile('VOD_IMG', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", " + file.get("dataIdx") + ", '" + file.get("fileUrl") + "', '" + file.get("mainImgFalg")+ "');\n";	
							} else {
								rtn = rtn + "jsDrawFile('VOD_IMG', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", '" + file.get("fileType") + "', " + file.get("dataIdx") + ");\n";
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
				<th scope="col"><span class="text-danger">*</span> 동영상</th>
				<td colspan="2">
				<div class="col-md-12">
				<%
					if( bbsDataFile2 != null && bbsDataFile2.size() > 0 ) {
						Map<String, Object> bbsData;
				%>
					<%if (!USER_AGENT.equals("Internet Explorer 8")) {%>
					<div name="VOD_ELEMENT" id="VOD_ELEMENT">Loading the player...</div>
					<%} else {%>
						"<%=USER_AGENT%>" 은 Player가 지원 되는 브라우저가 아닙니다.<br>
					<%}%>
				<%
					}
				%>
					<%=UvFileUtil.drawSingleUpload("VOD", "M", "*.mp4; *.avi; *.mov; *.wmv;", "10000MB")%>		
					<%
					if( bbsDataFile2 != null && bbsDataFile2.size() > 0 ) {
						String rtn = "";
						for (Map<String , Object> file : bbsDataFile2) {
							if (StringUtil.nvl(file.get("fileType")).equals("IMG")) {
								rtn = rtn + "jsDrawImageFile('VOD', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", " + file.get("dataIdx") + ", '" + file.get("fileUrl") + "', '" + file.get("mainImgFalg") + "');\n";	
							} else {
								if (StringUtil.nvl(file.get("trans")).equals("04")) {
									rtn = rtn + "jsDrawFile('VOD', '" + file.get("orgFileNm") + "', '" + file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", '" + file.get("fileType") + "', " + file.get("dataIdx") + ");\n";
								}
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
				<th scope="col">Transcoding</th>
				<td colspan="2">
				<div class="col-md-12">
				<%
				if(HS_CM_CD != null){
					Map<String , Object> HS_CM_CD_NODE;
					for(int i = 0; i < HS_CM_CD.size(); i++){
						HS_CM_CD_NODE = HS_CM_CD.get(i);
				%> 
				<input type="checkbox" name="transcoding" id="transcoding_<%=HS_CM_CD_NODE.get("cmCd")%>" value='<%=HS_CM_CD_NODE.get("cmCd")%>'/> <%=HS_CM_CD_NODE.get("cmNm")%><br>
				<%
					} 
				}
				%>
				<script>
				<%if (bbsDataInfo != null) {%>					
				<%
				String[] ARR_TRANSCODING = StringUtil.nvl(bbsDataInfo.get("transcoding"),"").split(",");
				for (int j = 0, k = ARR_TRANSCODING.length; j < k; j++) {
				%>
				setValue(document.all.transcoding, "<%=ARR_TRANSCODING[j]%>");
				$("#transcoding_<%=ARR_TRANSCODING[j]%>").attr("onclick", "return false;");
				<%
				}
				%>
				<%} else {%>
				setValue(document.all.transcoding, "01");
				setValue(document.all.transcoding, "03");
				<%}%>
				</script>
				<span class="label label-danger">* Transcoding 이 완료 후 사용자 페이지에서 서비스 됩니다.</span>
				</div>
				</td>
			</tr>
			<tr>
				<th scope="col">연관 동영상</th>
				<td colspan="2">
					<div class="col-md-12">
					<button class="btn btn-sm" onclick="jsVodRelaPop();">연관동영상 추가</button>
					<ul class="tag_list" id="REL_VOD_LIST">
					<%
				if (relVodList != null) {
					for (Map<String , Object> relVod : relVodList) {
				%>
						<li id="vod_idx_<%=relVod.get("vodIdx")%>">
						<input type="hidden" id="rel_vod_idx" name="rel_vod_idx" class="rel_vod_idx" value="<%=relVod.get("vodIdx")%>" />
						<strong>[VOD] <%=relVod.get("vodTitle")%></strong><br />
						<img src="/vod/file/getImage.do?data_idx=<%=relVod.get("vodIdx")%>&file_gubun=VOD_IMG"/><br />
						<img src="/common/uploadify/images/bt_del_s.gif" style="width:29px;height:16px" onclick="$('#vod_idx_<%=relVod.get("vodIdx")%>').remove();"></li>
				<%
					}
				}
				%>
					</ul>
					</div>
				</td>
			</tr>
				<!--<tr>
				<th scope="col">구분</th>
				<td colspan="2">
					<div class="col-md-2 m-b-15">
					 BEST : 
					<select id="best" name="best" class="select">
						<option value="N">N</option>
						<option value="Y">Y</option>							
					</select>
					</div>
					<%if (bbsDataInfo != null) { %>
					<script>
						$("#best").val("<%=StringUtil.nvl(bbsDataInfo.get("best"),"")%>");
					</script>
					<%}%>
					&nbsp;&nbsp;&nbsp;
					<div class="col-md-2 m-b-15">
					NEW : 
					<select id="new" name="new" class="select">
						<option value="N">N</option>
						<option value="Y">Y</option>							
					</select>
					</div>
					<%if (bbsDataInfo != null) { %>
					<script>
						$("#new").val("<%=StringUtil.nvl(bbsDataInfo.get("new"),"")%>");
					</script>
					<%}%>
					&nbsp;&nbsp;&nbsp;
					<div class="col-md-2 m-b-15">
					HOT :
					<select id="hot" name="hot" class="select">
						<option value="N">N</option>
						<option value="Y">Y</option>							
					</select>
					</div>
					<%if (bbsDataInfo != null) { %>
					<script>
						$("#hot").val("<%=StringUtil.nvl(bbsDataInfo.get("hot"),"")%>");
					</script>
					<%}%>
					
				</td>
			</tr>-->
			<input type="hidden" name="best" value="N"/>
					<input type="hidden" name="new" value="N"/>
					<input type="hidden" name="hot" value="N"/>
			<!--<tr>
				<th scope="col">Template</th>
				<td colspan="2">
					<ul class="lists">
						<li class="pull-left">
							<div class="title_rd">
							<input type="radio" value="A" id="template" name="template" class="form-control input-sm" checked> 템플릿 A
							<%if (bbsDataInfo != null) { %>
							<script>
								setValue(document.all.template, "<%=StringUtil.nvl(bbsDataInfo.get("template"),"A")%>");
							</script>
							<%}%>
							</div>
							<img class="m-t-5 m-b-10" width="300px;" src="/images/A.png">
						</li>
						<li class="pull-left m-l-5 m-r-5">
							<div class="title_rd">
							<input type="radio" value="B" id="template" name="template"> 템플릿 B
							<%if (bbsDataInfo != null) { %>
							<script>
								setValue(document.all.template, "<%=StringUtil.nvl(bbsDataInfo.get("template"),"B")%>");
							</script>
							<%}%>
							</div>
							<img class="m-t-5 m-b-10" width="300px;" src="/images/B.png">
						</li>
						<li class="pull-left">
							<div class="title_rd">
							<input type="radio" value="C" id="template" name="template"> 템플릿 C
							<%if (bbsDataInfo != null) { %>
							<script>
								setValue(document.all.template, "<%=StringUtil.nvl(bbsDataInfo.get("template"),"C")%>");
							</script>
							<%}%>
							</div>
							<img class="m-t-5" width="300px;" src="/images/C.png">
						</li>
					</ul>
				</td>
			</tr>-->
			<input type="hidden" value="A"/>
		</table>
	</div>	
	<div class="row m-t-15 text-right m-b-10">
		<button id="list2" class="btn btn-sm m-r-5">목 록</button>
		<button class="btn btn-sm m-r-5" id="save2">저 장</button>
		<%
			if( "mod".equals(modeType)){
		%>
		<button class="btn btn-sm m-r-5" id="remove2">삭 제</button>
		<%
			}
		%>
	</div>
</form>
</div>
<%if (!USER_AGENT.equals("Internet Explorer 8")) {%>
<script type="text/javascript" src="/common/jwplayer/jwplayer.js"></script>
<script>jwplayer.key="i4sty1oKVhqrdI0BQFRnsqtqOustH4AXbW/K0HOjHfU=";</script>
<%}%>
<script> 
$(document).ready(function() { 
	   
	$('#list').click(function(){list()})
	$('#save').click(function(){save()})
	$('#remove').click(function(){remove()})
	//$('#newGuest').click(function(){newGuest()})
	
	$('#list2').click(function(){list()})
	$('#save2').click(function(){save()})
	$('#remove2').click(function(){remove()})
	//$('#newGuest2').click(function(){newGuest()})
	$('#menu_select2').selectpicker('hide');
	
	jsCalcTag();
	jsCalcMenu();
	<%if((bbsDataFile != null && bbsDataFile.size() > 0) || (bbsDataFile2 != null && bbsDataFile2.size() > 0)){%>
	jwplayer("VOD_ELEMENT").setup({
		<%
			if( bbsDataFile != null && bbsDataFile.size() > 0 ) {
				for(Map<String , Object> fileInfo : bbsDataFile2) {
					if ((StringUtil.nvl(fileInfo.get("trans")).equals("03")) || "".equals(StringUtil.nvl(fileInfo.get("trans"))) ) {
						%>
						image: "<%=StringUtil.nvl(bbsDataFile.get(0).get("fileUrl"),"")%>",
						file: "<%=StringUtil.nvl(fileInfo.get("fileUrl"),"")%>"
		<%
					}
				}
			} else {
				
				for(Map<String , Object> fileInfo2 : bbsDataFile2) {
					if ((StringUtil.nvl(fileInfo2.get("trans")).equals("03")) || "".equals(StringUtil.nvl(fileInfo2.get("trans"))) ) {
		%>
		
						file: "<%=StringUtil.nvl(fileInfo2.get("fileUrl"),"")%>"
		
		<% 
					}
				}}
		%>
    });
	<%}%>
}); 
  

function list(){  
	var f = document.frm;
	$('#vod_idx').val('');
	f.action = "/ncs/vod/list.do";
	f.submit();
}

function save(){
	if( $('#vod_title').val() == '' || $('#vod_title').val() == null ) {
		alert('제목을 입력해 주세요.');
		$('#vod_title').focus();
		return;
	} else if( $('#reg_nm').val() == '' ) {
		alert('관리자 명을 입력해 주세요.')
		return;
	}else if($("#tag_select").val() == "") {
		alert("태그를 선택하세요");
		return;
	} else if ($("#menu").val() == ",") {
		alert("메뉴를 한 개 이상 추가하세요");
		return;
	} else if($('#startDate').val() == '') {
		alert('등록일을 입력해 주세요.');
		return;
	} else if($('#VOD_IMG_IMAGE_LIST').children().length == 0) {
		alert('썸네일을 등록해 주세요.');
		return;
	} else if($('#VOD_FILE_LIST').children().length == 0) {
		alert('동영상을 등록해 주세요.');
		return;
	}
	
	var f = document.frm; 
	f.action = "/ncs/vod/writeProc.do";
	f.submit();
}

function remove(){
	if( $('#vod_idx').val() == '' ){
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
		        newGuest();
		    }
		});
	}
}; 

function newGuest() {
	var f = document.frm;
	$('#vod_idx').val('');
	f.action = "/ncs/vod/write.do";
	f.submit();
}

var TAG_DIV_COUNT = 1;
function jsAddTag() {
	if ($("#tag").val().indexOf("," + $("#tag_select").val() + ",") > -1) {
		alert("이미 등록되어 있는 TagMenu 입니다.");
		return false;
	}
	
	$("#TAG_DIV").append( "<p id='TAG_DIV_" + TAG_DIV_COUNT + "' val='" + $("#tag_select").val() + "'>ㆍ" + $("#tag_select option:selected").text() + "&nbsp;<a href=javascript:; onclick=jsDelTag('TAG_DIV_" + TAG_DIV_COUNT + "')>[삭제]</a></p>" );
	TAG_DIV_COUNT++;
	
	jsCalcTag();
}

function jsDelTag(objName) {
	$("#" + objName).remove();

	jsCalcTag();
}

function jsCalcTag() {
	var TAG = "";
	$("#TAG_DIV").each(function() {
		$(this).find("p").each(function() {
			TAG = TAG + $(this).attr("val") + ",";
		});
	});
	
	$("#tag").val("," + TAG);
}

function jsVodRelaPop() {
	var screenSizeWidth, screenSizeHeight;
	
	if (self.screen) { 
		screenSizeWidth = 1180;  
		screenSizeHeight = 830;
	}  
	
	documentURL = "/ncs/vod/relationVodPop.do";
	windowName = "연관동영상";
	intWidth = screenSizeWidth;
	intHeight = screenSizeHeight;
	intXOffset = 140;
	intYOffset = 70;
	
	objWindow = window.open(documentURL,windowName, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes,resizable=yes");
	objWindow.resizeTo(intWidth, intHeight);
	objWindow.moveTo(intXOffset, intYOffset);
}

function jsAddVod(vod_idx, strHTML) {	
	var contain = false;
	
	if ($(".rel_vod_idx").length > 0) {
		$(".rel_vod_idx").each( function() {
			if ($(this).val() == vod_idx) {
				contain = true;
				return false;
			}
		});
	}
	
	if (contain == false) {
		$("#REL_VOD_LIST").append(strHTML);
	}
}

function jsChangeMenu() {
	$('#menu_select2').selectpicker('hide');
	$.ajax({
	    url:'/ncs/vod/subMenuList.do',
	    type:'POST',
	    data: {MENU_SEQ : $('#menu_select').val()},
	    dataType: 'json',
	    success: function( json ) {
		    	$("#menu_select2 option").remove();
		    	$("#menu_select2").append("<option value=''>선택</option>");
			if (json.menuList.length > 0) {
		    		$.each(json.menuList, function(i, row) {
		    			$("#menu_select2").append("<option value='" + row.menuSeq + "'>" + row.menuName + "</option>");
				});
		    		$('#menu_select2').selectpicker('show');
			}
			$('#menu_select2').selectpicker('refresh');
	    	}
	});
}

var MENU_DIV_COUNT = 1;
function jsAddMenu() {
	if ($("#menu_select").val() == "") {
		alert("메뉴를 선택하세요");
		return;
	} 
	
	var menu = $("#menu_select").val();
	var menu_text = $("#menu_select option:selected").text();
	
	if (!$('#menu_select2').next().is(':hidden')) {
		if ($("#menu_select2").val() == "") {
			alert("서브메뉴를 선택하세요");
			return;
		}
		menu = menu + "`" + $("#menu_select2").val();
		
		menu_text = menu_text + " > " + $("#menu_select2 option:selected").text();
	}
	
	if ($("#menu").val().indexOf("," + menu + ",") > -1) {
		alert("이미 등록되어 있는 메뉴 입니다.");
		return false;
	}
	
	$("#MENU_DIV").append( "<p id='MENU_DIV_" + MENU_DIV_COUNT + "' val='" + menu + "'>ㆍ" + menu_text + "&nbsp;<a href=javascript:; onclick=jsDelMenu('MENU_DIV_" + MENU_DIV_COUNT + "')>[삭제]</a></p>" );
	MENU_DIV_COUNT++;
	
	jsCalcMenu();
}

function jsDelMenu(objName) {
	$("#" + objName).remove();
	
	jsCalcMenu();
}

function jsCalcMenu() {
	var MENU = "";
	$("#MENU_DIV").each(function() {
		$(this).find("p").each(function() {
			MENU = MENU + $(this).attr("val") + ",";
		});
	});
	
	$("#menu").val("," + MENU);
}

function jsChangeSrc() {
	$("#template_img").attr("src", "/images/" + $("#template").val() + ".png");
}

$(function() {
    $( "#startDate" ).datepicker({
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
</script>
</body>
</html>