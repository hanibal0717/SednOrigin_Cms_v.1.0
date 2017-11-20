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
			* @JSP Name : dayStatistics.jsp
			* @Description : 기간별 통계 - 일자별
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

/* PaginationInfo paginationInfo = null;

paginationInfo = (PaginationInfo)request.getAttribute("paginationInfo");
String searchCondition = (String)request.getAttribute("searchCondition");

String modeType = ""; */
 
List<Map<String , Object>> list = (List)request.getAttribute("dayStatList");
String currentMonth = (String)request.getAttribute("currentMonth");
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
String sum13= "";
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
	$('#searchMonth').val(<%=currentMonth%>);
	$('#searchYear').val(<%=currentYear%>);
	$('#excelDownload').click(function(){excelDownload()});
	
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
	f.action = "/statistics/dayStatistics.do";
	f.submit();

}
 
function excelDownload(){
		
	$('#frm1').prop("action", "/excel/dayStatExcelDownload.do");
	$('#frm1').submit();

}
</script>
</head>
	
<body>
<h2>기간별 통계 - 일자별<span class="text"></span></h2>
<p class="location"></p>
<p class="tar Mbo11">
</p>
<section>
<form name="frm1" id="frm1" method="post">
	<p class="tar Mbo11">
		<select class="select_size013" name="searchYear" id="searchYear">
			<option value="">선택</option>
			<option value="2015">2015년</option>
			<option value="2014">2014년</option>
		</select>
		<select class="select_size013" name="searchMonth" id="searchMonth">
			<option value="">선택</option>
			 <c:forEach var="i" begin="1" end="12">
			<c:choose>
				<c:when test="${i < 13 }">
					<c:set var="startHH">${i}</c:set>
					<c:set var="showStartHH">${i}</c:set>
				</c:when>
			</c:choose>
			<option value="${startHH}">${startHH}월</option>
			</c:forEach>
		</select>
		<button id="search" class="btn_searchTbl06 prevent" style="">조회</button>
		<button id="excelDownload" class="btn_searchTbl06 prevent" style="">EXCEL DOWNLOAD</button>
	</p>
	<h3>기간별 통계 - 일자별 목록</h3>
	<div style="overflow:auto; height:525px; border-left:2px solid #cdcdcd; border-right:2px solid #cdcdcd; border-bottom:2px solid #cdcdcd; border-top:2px solid #cdcdcd;">
			<table class="data_tableW" id="data_tableW" summary="" >
				<caption></caption>
				<colgroup>
					<col width="*" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="3.7%" />
					<col width="5%" />
				</colgroup>
				<thead>
					<tr>
						<th>구분</th>
						<th>0시</th>
						<th>1시</th>
						<th>2시</th>
						<th>3시</th>
						<th>4시</th>
						<th>5시</th>
						<th>6시</th>
						<th>7시</th>
						<th>8시</th>
						<th>9시</th>
						<th>10시</th>
						<th>11시</th>
						<th>12시</th>
						<th>13시</th>
						<th>14시</th>
						<th>15시</th>
						<th>16시</th>
						<th>17시</th>
						<th>18시</th>
						<th>19시</th>
						<th>20시</th>
						<th>21시</th>
						<th>22시</th>
						<th>23시</th>
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
							vDay = vDay + "일";
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
						<td><%=subSum%></td>
					</tr>
				<%
					}
				}
				
			        if(list.size() < 1) {
				%>
					<tr>
						<td colspan="26">
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

