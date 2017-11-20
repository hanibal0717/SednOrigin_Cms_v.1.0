<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%@page import="egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo" %>
<%
	/**
	* @JSP Name : list.jsp
	* @Description : VOD 컨텐츠관리
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
String bbsMstIdx = "BM0000000001";
String attachUseYn = "Y";
int  attachCnt = 3;
String modeType = "";

List<Map<String , Object>> list = (List)request.getAttribute("list");
List<Map<String , Object>> TAG_MENU = (List)request.getAttribute("TAG_MENU");
Map<String, Object> param = (Map<String, Object>)request.getAttribute("param");

PaginationInfo paginationInfo = null;
paginationInfo = (PaginationInfo)request.getAttribute("paginationInfo");

String vodIdx = "";
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
%>
<meta name="decorator" content="defaultPage">
<body>
<ol class="breadcrumb hidden-xs">
    <li>VOD 컨텐츠 관리</li>
    <li>목록</li>
</ol>
<h4 class="page-title">VOD 컨텐츠관리</h4>
<div class="block-area">
	<form name="frm" id="frm" method="post" >
		<input type="hidden" name="bbs_mst_idx" id="bbs_mst_idx" value="<%=bbsMstIdx %>" />
		<input type="hidden" name="vod_idx" id="vod_idx" value="" />
		<input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" />
		<div class="row m-t-15">
	        <!--<div class="col-md-2 m-b-15">
	            <select class="select" id="tag_select_value" name="tag_select_value">
	                <option value="">TAG</option>
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
			</div>-->
			<div class="col-md-1 m-b-15">
		        	<select class="select" id="hot_select" name="hot_select">
					<option value="">HOT</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
			</div>
			<div class="col-md-1 m-b-15">
	        		<select class="select" id="best_select" name="best_select">
					<option value="">BEST</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
			</div>
			<div class="col-md-1 m-b-15">
	        		<select class="select" id=search_type name="search_type">
					<option value="TITLE">제목</option>
					<option value="CONT">내용</option>
					<option value="">제목+내용</option>
				</select>
			</div>
			<div class="col-md-2 m-b-15">
				<input class="form-control input-sm m-b-10" id="search_keyword" name="search_keyword" placeholder="검색어">
			</div>
			<div class="col-md-2 m-b-15">
				<button id="search" class="btn btn-sm m-r-5">검 색</button>
				<button id="newBBS" class="btn btn-sm m-r-5">신규 등록</button>
				<!-- span class="btn_type01 btn" id="newBBS"><a href="#">신규</a></span //-->
			</div>
	    </div>
	    <div class="clearfix"></div> 
		
		<div class="table-responsive" style="overflow: hidden; outline: none;">
			<table class="table table-bordered table-hover tile" id="data_tableW" >
				<caption></caption>
				<colgroup>
					<col width="5%"/>
					<col width="*" />
					<col width="5%" />
					<col width="5%" />
					<col width="14%" />
					<col width="9%" />
					<col width="10%" /> 
					<col width="5%" />
					<col width="10%" /> 
				</colgroup>
				<thead>
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>BEST</th>
					<th>HOT</th>
					<!--<th>TAG</th>-->
					<th>재생시간</th>
					<th>등록일</th>
					<th>조회수</th>
					<th>등록자</th>
				</tr>
				</thead>
				<tbody>
				<%
				int list_count_1 = list.size();
				if (list == null || list_count_1 == 0) {
					
				%>
					<tr>
						<td colspan="9">해당 VOD가 존재하지 않습니다.</td>
					</tr>
				<%
				}
				if( list != null){
					Map<String , Object> bbsDataInfo;
					
					int totalRecordCnt = paginationInfo.getTotalRecordCount();
					int firstRecordIndex = paginationInfo.getFirstRecordIndex();
									
					int value = totalRecordCnt - firstRecordIndex;
					
					for(int i=0; i<list.size(); i++){
						bbsDataInfo = list.get(i);
						int rownum = value - i;
						
						vod_idx = String.valueOf(bbsDataInfo.get("vodIdx"));
						vod_title = StringUtil.nvl(bbsDataInfo.get("vodTitle"),"");
						vod_keyword = StringUtil.nvl(bbsDataInfo.get("vodKeyword"),"");
						vod_play_time = StringUtil.nvl(bbsDataInfo.get("vodPlayTime"),"");
						
						if( bbsDataInfo.get("regDt") != null ){
							reg_dt = bbsDataInfo.get("regDt").toString();
						}	
						hits = String.valueOf(bbsDataInfo.get("hits"));
	%>
				<tr>
				 <td><%=rownum%></td> 
				 <td style="text-align: left;"><a href="#" onclick="javascript:fn_view('<%=vod_idx%>');"><%= vod_title%></a></td>
				 <td><%=StringUtil.nvl(bbsDataInfo.get("best"),"")%></td>
				 <td><%=StringUtil.nvl(bbsDataInfo.get("hot"),"")%></td>
				<!-- <td>
				 	<%
					String tag = "";
					String[] ARR_TAG = StringUtil.nvl(bbsDataInfo.get("tag"),"").split(",");
					for (int j = 0, k = ARR_TAG.length; j < k; j++) {
						for (Map<String , Object> TAG_MENU_NODE : TAG_MENU) {
							if (ARR_TAG[j].equals(TAG_MENU_NODE.get("tagIdx").toString())) {
								tag = tag + TAG_MENU_NODE.get("tagName") + ",";
							}
						}
					} 
					
					if (tag.length() > 1) {
						tag = tag.substring(0, tag.length()-1);
					}
					%>
					<%=tag%>
				 </td>-->
				 <td><%=vod_play_time%></td>
				 <td><%=reg_dt%></td>
				 <td><%=hits%></td>
				 <td><%=StringUtil.nvl(bbsDataInfo.get("regNm"),"")%></td>
				</tr>
	<%					
					}
				}
				%>
				
				</tbody>
			</table>
		</div>
		<div class="media text-center">
		<div class="pagination">
			 <ui:pagination paginationInfo = "${paginationInfo}"  type="image" jsFunction="fn_page"  />
		</div>
		</div>
	</form>
</div>
<script>

$(document).ready(function() { 
	
	$('#search').click(function(){search()})
	$('#save').click(function(){save()})
	$('#remove').click(function(){remove()})
	$('#newBBS').click(function(){fn_regit()})
	
	$("#tag_select_value").val("<%=StringUtil.nvl(param.get("tag_select_value"))%>");
	$("#hot_select").val("<%=StringUtil.nvl(param.get("hot_select"))%>");
	$("#best_select").val("<%=StringUtil.nvl(param.get("best_select"))%>");
	$("#search_type").val("<%=StringUtil.nvl(param.get("search_type"))%>");
	$("#search_keyword").val("<%=StringUtil.nvl(param.get("search_keyword"))%>");
}); 
  

function search(){ 
	 
	var param = '&bbs_mst_idx='+$('#bbs_mst_idx').val();
	
	var f = document.frm;	
	f.action = "/ncs/vod/list.do";
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
	    url:'/ncs/vod/writeProc.do',
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
		        myGrid.reloadList();
		    }
		});
	}
};
function fn_regit() {
	
	var f = document.frm;
	$('#vod_idx').val('');
	f.action = "/ncs/vod/write.do";
	f.submit();
}

function fn_view(vodIdx) {
	
	var f = document.frm;
	$('#vod_idx').val(vodIdx);
	f.action = "/ncs/vod/detail.do";
	f.submit();
}

function fn_page(pageNo) {
	$("#frm").attr("action","/ncs/vod/list.do");
	$("#pageIndex").val(pageNo);
	$("#frm").submit();
}
</script>
</body>
</html>