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
			* @JSP Name : monthStatistics.jsp
			* @Description : 기간별 통계 - 월별
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
List<Map<String , Object>> list = (List)request.getAttribute("monthStatList");
String currentYear = (String)request.getAttribute("currentYear");

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
String sum13 = "";
String sum14 = "";
String sum15 = "";
String sum16 = "";
String sum17 = "";
String sum18 = "";
String sum19 = "";
String sum20 = "";
String sum21 = "";
String sum22 = "";
String sum23 = "";
String sum24 = "";
String sum25 = "";
String sum26 = "";
String sum27 = "";
String sum28 = "";
String sum29 = "";
String sum30 = "";
String sum31 = "";
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
	$('#searchYear').val(<%=currentYear%>);
	
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

function search(){
	
	var f = document.frm1;	
	f.action = "/user/userMng/userMng.do";
	f.submit();

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
	f.action = "/statistics/monthStatistics.do";
	f.submit();

}
 
 function excelDownload(){
		
	var f = document.frm1;	
	f.action = "/excel/monthStatExcelDownload.do";
	f.submit();

}
</script>
</head>
	
<body>
<h2>기간별 통계 - 월별<span class="text"></span></h2>
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
		<select class="select_size013" name="searchYear" id="searchYear">
			<option value="">선택</option>
			<option value="2015">2015년</option>
			<option value="2014">2014년</option>
		</select>
		<button id="search" class="btn_searchTbl06 prevent" style="">조회</button>
		<button id="excelDownload" class="btn_searchTbl06 prevent" style="">EXCEL DOWNLOAD</button>
	</p>
	<h3>기간별 통계 - 월별 목록</h3>
	<div style="overflow:auto; height:525px; border-left:2px solid #cdcdcd; border-right:2px solid #cdcdcd; border-bottom:2px solid #cdcdcd; border-top:2px solid #cdcdcd;">
			<table class="data_tableW" id="data_tableW" summary="" >
				<caption></caption>
				<colgroup>
					<col width="3.5%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3%" />
					<col width="3.5%" />
				</colgroup>
				<thead>
					<tr>
						<th>구분</th>
						<th>1일</th>
						<th>2일</th>
						<th>3일</th>
						<th>4일</th>
						<th>5일</th>
						<th>6일</th>
						<th>7일</th>
						<th>8일</th>
						<th>9일</th>
						<th>10일</th>
						<th>11일</th>
						<th>12일</th>
						<th>13일</th>
						<th>14일</th>
						<th>15일</th>
						<th>16일</th>
						<th>17일</th>
						<th>18일</th>
						<th>19일</th>
						<th>20일</th>
						<th>21일</th>
						<th>22일</th>
						<th>23일</th>
						<th>24일</th>
						<th>25일</th>
						<th>26일</th>
						<th>27일</th>
						<th>28일</th>
						<th>29일</th>
						<th>30일</th>
						<th>31일</th>
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
						
						if ("99".equals(vDay)) {
							vDay = "소계";
						} else {
							vDay = vDay + "월";
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
						sum13 = String.valueOf(contentDataInfo.get("sum13"));
						sum14 = String.valueOf(contentDataInfo.get("sum14"));
						sum15 = String.valueOf(contentDataInfo.get("sum15"));
						sum16 = String.valueOf(contentDataInfo.get("sum16"));
						sum17 = String.valueOf(contentDataInfo.get("sum17"));
						sum18 = String.valueOf(contentDataInfo.get("sum18"));
						sum19 = String.valueOf(contentDataInfo.get("sum19"));
						sum20 = String.valueOf(contentDataInfo.get("sum20"));
						sum21 = String.valueOf(contentDataInfo.get("sum21"));
						sum22 = String.valueOf(contentDataInfo.get("sum22"));
						sum23 = String.valueOf(contentDataInfo.get("sum23"));
						sum24 = String.valueOf(contentDataInfo.get("sum24"));
						sum25 = String.valueOf(contentDataInfo.get("sum25"));
						sum26 = String.valueOf(contentDataInfo.get("sum26"));
						sum27 = String.valueOf(contentDataInfo.get("sum27"));
						sum28 = String.valueOf(contentDataInfo.get("sum28"));
						sum29 = String.valueOf(contentDataInfo.get("sum29"));
						sum30 = String.valueOf(contentDataInfo.get("sum30"));
						sum31 = String.valueOf(contentDataInfo.get("sum31"));
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
						<td><%=sum13%></td>
						<td><%=sum14%></td>
						<td><%=sum15%></td>
						<td><%=sum16%></td>
						<td><%=sum17%></td>
						<td><%=sum18%></td>
						<td><%=sum19%></td>
						<td><%=sum20%></td>
						<td><%=sum21%></td>
						<td><%=sum22%></td>
						<td><%=sum23%></td>
						<td><%=sum24%></td>
						<td><%=sum25%></td>
						<td><%=sum26%></td>
						<td><%=sum27%></td>
						<td><%=sum28%></td>
						<td><%=sum29%></td>
						<td><%=sum30%></td>
						<td><%=sum31%></td>
						<td><%=subSum%></td>
					</tr>
				<%
					}
				}
				
			        if(list.size() < 1) {
				%>
					<tr>
						<td colspan=33>
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
<%-- 	
	<div class="paging">
		 <ui:pagination paginationInfo = "${paginationInfo}"  type="image" jsFunction="fn_page"  />
	</div>
--%>
</body>
</html>

