<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%@page import="egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo" %>

<%
			/**
			* @JSP Name : yearStatistics.jsp
			* @Description : 기간별 통계 - 년도별
			* @Modification Information
			* 
			*       수정일         수정자         수정내용
			*  ----------------------------------------------
			*     2015.11.05       박경택         최초생성
			*
			* author 개발팀 
			* Copyright (C) 2011 by MOPAS  All right reserved.
			*/
%>
<%
/* 
PaginationInfo paginationInfo = null;

paginationInfo = (PaginationInfo)request.getAttribute("paginationInfo");
String searchCondition = (String)request.getAttribute("searchCondition");

String modeType = "";
*/
List<Map<String , Object>> list = (List)request.getAttribute("yearStatList");

String vDay = "";
String sum01 = "";
String sum02 = "";
String sum03= "";
String sum04 = "";
String sum05 = "";
String sum06 = "";
String sum07 = "";
String sum08 = "";
String sum09 = "";
String sum10 = "";
String sum11 = "";
String sum12 = "";
String subSum = "";

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">
<script>
$(document).ready(function() {
   
	$('#search').click(function(){search()});
	$('#excelDownload').click(function(){excelDownload()});
	<%-- $('#searchCondition').val(<%=searchCondition%>); --%>
	
});
/* 
function goDetail(userIdx){
	
	var sKeyword = encodeURIComponent($('#searchTxt').val());
    $('#searchTxt').val(sKeyword);
	$('#userIdx').val(userIdx);
	
	var formData = document.frm1;
	formData.action = "/user/userMng/userDetail.do";
	formData.submit();
	
}

function mouseOver(tdId) {
	
	var div = document.getElementById(tdId);
	
	div.style.fontWeight = "bold";
	div.style.cursor = "pointer";

}

function mouseOut(tdId) {

	var div = document.getElementById(tdId);
	
	div.style.fontWeight = "normal";
	div.style.cursor = "default";

}

function fn_page(pageNo) {
	$("#frm1").attr("action","/user/userMng/userMng.do");
	$("#pageIndex").val(pageNo);
	$("#frm1").submit();
}
 */
 
 function search(){
		
	var f = document.frm1;	
	f.action = "/statistics/yearStatistics.do";
	f.submit();

}
 
 function excelDownload(){
		
	var f = document.frm1;	
	f.action = "/excel/yearStatExcelDownload.do";
	f.submit();

	}
</script>
</head>
	
<body>
<h2>기간별 통계 - 년도별<span class="text"></span></h2>
<p class="location"></p>
<p class="tar Mbo11">
</p>
<section>
<form name="frm1" id="frm1" method="post">
	<input type="hidden" name="userIdx" id="userIdx" value="" />
	<%-- <input type="hidden" name="pageIndex" id="pageIndex" value="${pageIndex}" /> --%>
	<p class="tar Mbo11">
		<!-- <select class="select_size013" name="searchCondition" id="searchCondition">
			<option>컨텐츠유형</option>
		</select> -->
		<button id="search" class="btn_searchTbl06 prevent" style="">조회</button>
		<button id="excelDownload" class="btn_searchTbl06 prevent" style="">EXCEL DOWNLOAD</button>
	</p>
	<h3>기간별 통계 - 년도별 목록</h3>
	<div style="height:476px; border-left:1px solid #cdcdcd; border-right:1px solid #cdcdcd; border-bottom:1px solid #cdcdcd; border-top:1px solid #cdcdcd;">
			<table class="data_tableW" id="data_tableW" summary="" >
				<caption></caption>
				<colgroup>
					<col width="9%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="9%" />
				</colgroup>
				<thead>
					<tr>
						<th>구분</th>
						<th>1월</th>
						<th>2월</th>
						<th>3월</th>
						<th>4월</th>
						<th>5월</th>
						<th>6월</th>
						<th>7월</th>
						<th>8월</th>
						<th>9월</th>
						<th>10월</th>
						<th>11월</th>
						<th>12월</th>
						<th>소계</th>
					</tr>
				</thead>
				<tbody>
				<%
				if(list != null) {
					Map<String, Object> contentDataInfo;
					//int totalRecordCnt = paginationInfo.getTotalRecordCount();
					//int firstRecordIndex = paginationInfo.getFirstRecordIndex();
					
					//int value = totalRecordCnt - firstRecordIndex;
					
					for(int i=0; i<list.size(); i++) {
						//int rownum = value - i;
						contentDataInfo = list.get(i);
						
						vDay = String.valueOf(contentDataInfo.get("vDay"));
						
						if ("9999".equals(vDay)) {
							vDay = "소계";
						} else {
							vDay = vDay + "년";
						}
						
						sum01 = String.valueOf(contentDataInfo.get("sum01"));
						sum02 = String.valueOf(contentDataInfo.get("sum02"));
						sum03 = String.valueOf(contentDataInfo.get("sum03"));
						sum04 = String.valueOf(contentDataInfo.get("sum04"));
						sum05 = String.valueOf(contentDataInfo.get("sum05"));
						sum06 = String.valueOf(contentDataInfo.get("sum06"));
						sum07 = String.valueOf(contentDataInfo.get("sum07"));
						sum08 = String.valueOf(contentDataInfo.get("sum08"));
						sum09 = String.valueOf(contentDataInfo.get("sum09"));
						sum10 = String.valueOf(contentDataInfo.get("sum10"));
						sum11 = String.valueOf(contentDataInfo.get("sum11"));
						sum12 = String.valueOf(contentDataInfo.get("sum12"));
						subSum = String.valueOf(contentDataInfo.get("subSum"));
				%>
					<tr>
						<td><%=vDay%></td>
						<td><%=sum01%></td>
						<td><%=sum02%></td>
						<td><%=sum03%></td>
						<td><%=sum04%></td>
						<td><%=sum05%></td>
						<td><%=sum06%></td>
						<td><%=sum07%></td>
						<td><%=sum08%></td>
						<td><%=sum09%></td>
						<td><%=sum10%></td>
						<td><%=sum11%></td>
						<td><%=sum12%></td>
						<td><%=subSum%></td>
					</tr>
				<%
					}
				}
				
			        if(list.size() < 1) {
				%>
					<tr>
						<td colspan=14>
							<strong>해당하는 컨텐츠가 존재하지 않습니다.</strong>
						</td>
					</tr>
			    <%
			        }
				%>
				</tbody>
			</table>
		</div>
	</form>
	</section>
<%-- 	<div class="paging">
		 <ui:pagination paginationInfo = "${paginationInfo}"  type="image" jsFunction="fn_page"  />
	</div> --%>
</body>
</html>

