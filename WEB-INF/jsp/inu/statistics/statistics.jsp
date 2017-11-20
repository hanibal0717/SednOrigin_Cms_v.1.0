<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>

<%
String StartDate = (String)request.getAttribute("StartDate");
String EndDate = (String)request.getAttribute("EndDate");

List<Map<String , Object>> statisticsWeeklyTop5 = (List)request.getAttribute("statisticsWeeklyTop5");

List<Map<String , Object>> weeklyViewStatus = (List)request.getAttribute("weeklyViewStatus");
List<Map<String , Object>> weeklyViewContentsBest = (List)request.getAttribute("weeklyViewContentsBest");
List<Map<String , Object>> weeklyViewDeviceStatus = (List)request.getAttribute("weeklyViewDeviceStatus");

List<Map<String , Object>> statisticsList = (List)request.getAttribute("statisticsList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="decorator" content="defaultPage">
<script>
$(document).ready(function() { 

});

function search() { 
	var f = document.frm;	
	f.action = "/statistics/statistics.do";
	f.submit();
}
</script>
</head>
<body>
<h2>일반 통계<span class="text"></span></h2>
<p class="location"></p>
	<section>
			<h3>최근 7일간 시청 현황</h3>
			<table class="data_tableW04 statistics_table" style="table-layout:fixed;">
				<colgroup>
				</colgroup>
				<thead>
					<tr>
					<%
					if(weeklyViewStatus != null){
						int listCount = weeklyViewStatus.size();
						for(int i=0; i<weeklyViewStatus.size(); i++){
							Map<String , Object> info = weeklyViewStatus.get(i);
					%>
						<th><%=info.get("dateInfo")%></th>
				</tbody>
					<%
						}
					%>
					</tr>
				</thead>
				<tbody>
					<tr>
					<%
						for(int i=0; i<weeklyViewStatus.size(); i++){
							Map<String , Object> info = weeklyViewStatus.get(i);
					%>
						<td><%=info.get("cnt")%></td>
					<%
						}
					}
					%>
					</tr>
			</table>
			<br /><br /><br />
		<div class="clear"></div>
			<h3>최근 7일간 시청 컨텐츠 BEST</h3>
			<table class="data_tableW04 statistics_table" style="table-layout:fixed;">
				<colgroup>
					<col width="12%" />
					<col width="36%" />
					<col width="8%" />
					<col width="11%" />
					<col width="11%" />
					<col width="11%" />
					<col width="11%" />
				</colgroup>
				<thead>
					<tr>
						<th rowspan="2">구분</th>
						<th rowspan="2">제목</th>
						<th rowspan="2">시청수</th>
						<th colspan="2">디바이스별</th>
						<th colspan="2">회원유형별</th>
					</tr>
					<tr>
						<th>PC</th>
						<th>MOBILE</th>
						<th>회원</th>
						<th>비회원</th>
					</tr>
				</thead>
				<tbody>
					<%
					if(weeklyViewContentsBest != null){
						int listCount = weeklyViewContentsBest.size();
						for(int i=0; i<weeklyViewContentsBest.size(); i++){
							Map<String , Object> info = weeklyViewContentsBest.get(i);
					%>
					<tr>
						<td><%=info.get("vType")%></td>
						<td style="text-align:left;">&nbsp;<%=info.get("title")%></td>
						<td><%=info.get("totCount")%></td>
						<td><%=info.get("pcCount")%></td>
						<td><%=info.get("mobileCount")%></td>
						<td><%=info.get("memCount")%></td>
						<td><%=info.get("nonMemCount")%></td>
					</tr>
					<%
						}
					}
					%>
				</tbody>
			</table>
			<br /><br /><br />
			
			<div class="clear"></div>
			
			<h3 style="width:333px;">DEVICE 별 시청 현황</h3>
			<table class="data_tableW04 statistics_table" style="width:350px; table-layout:fixed;">
				<colgroup>
					<col width="50%" />
					<col width="50%" />
				</colgroup>
				<thead>
					<tr>
						<th>PC</th>
						<th>MOBILE</th>
					</tr>
				</thead>
				<tbody>
					<%
					if(weeklyViewDeviceStatus != null){
						int listCount = weeklyViewDeviceStatus.size();
						for(int i=0; i<weeklyViewDeviceStatus.size(); i++){
							Map<String , Object> info = weeklyViewDeviceStatus.get(i);
					%>
					<tr>
						<td><%=info.get("pcCount")%></td>
						<td><%=info.get("mobileCount")%></td>
					</tr>
					<%
						}
					}
					%>
				</tbody>
			</table>
			
			<div class="clear"></div>
	</section>
</body>
</html>