<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="vcms.common.util.StringUtil" %>

<%
Integer numTotalContents = (Integer)request.getAttribute("numTotalContents");
Integer numTotalSTBs = (Integer)request.getAttribute("numTotalSTBs");

SimpleDateFormat sdf = new SimpleDateFormat("MM/dd");
String[] weekDateStr = new String[7];
Calendar today = Calendar.getInstance();
Date to_date = today.getTime();
for(int i = 0; i < 7; i++) {
	weekDateStr[i] = sdf.format(today.getTime().getTime());
	today.add(Calendar.DATE, -1);
}
today.add(Calendar.DATE, 1);
Date from_date = today.getTime();
String recent7DayStr = sdf.format(to_date.getTime()) +  " ~ " + sdf.format(from_date.getTime());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="<c:url value='/js/jquery/js.cookie.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/d3/d3.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/noterik/jquery.ntkPieChart.js'/>"></script>

<script type="text/javascript" src="<c:url value='/js/paginationjs/dist/pagination.js'/>"></script>

<script type="text/javascript" src="<c:url value='/js/jqueryrotate.js'/>"></script>

<link rel="stylesheet" type="text/css" href="<c:url value='/js/datetimepicker/jquery.datetimepicker.css'/>">
<script type="text/javascript" src="<c:url value='/js/datetimepicker/jquery.datetimepicker.full.min.js'/>"></script>

<link rel="stylesheet" type="text/css" href="/js/jqplot/dist/jquery.jqplot.css" />
<script language="javascript" type="text/javascript" src="/js/jqplot/dist/jquery.jqplot.min.js"></script>
<script type="text/javascript" src="/js/jqplot/dist/plugins/jqplot.barRenderer.js"></script>
<script type="text/javascript" src="/js/jqplot/dist/plugins/jqplot.categoryAxisRenderer.js"></script>
<script type="text/javascript" src="/js/jqplot/dist/plugins/jqplot.pointLabels.js"></script>
<script type="text/javascript" src="/js/jqplot/dist/plugins/jqplot.canvasTextRenderer.js"></script>
<script type="text/javascript" src="/js/jqplot/dist/plugins/jqplot.canvasAxisLabelRenderer.js"></script>
<script type="text/javascript" src="/js/jqplot/dist/plugins/jqplot.canvasAxisTickRenderer.js"></script>
<script type="text/javascript" src="/js/jqplot/dist/plugins/jqplot.enhancedLegendRenderer.js"></script>

<style>
svg {
	padding: 0 50px 0 10px;
}
.xdsoft_option {	
	width:50px;
}

.jqplot-point-label {
	font-size:1em;
}

.jqplot-title {
	margin-top:20px;
	margin-bottom:-50px;
	z-index:50;
}

#statYearChart .jqplot-point-label {
	color:white;
}

#statYearChart .jqplot-series-12 {
	color:black;
	margin-left:70px;
}
#statContentTable > thead > tr > th, #statSTBTable > thead > tr > th {
	vertical-align: middle;
}
.paginationjs-pages > ul {
	list-style-type: none;
    width: 20%;
    margin: auto;
}
.J-paginationjs-page > a, .J-paginationjs-next > a, .J-paginationjs-previous > a {
    background: transparent;
    border: 1px solid rgba(255,255,255,0.1);
    float: left;
    padding: 6px 12px;
}

.J-paginationjs-page {
	border-right-width : 0px;
}
.J-paginationjs-page > a, .J-paginationjs-next > a, .J-paginationjs-previous > a {
	background: transparent;
    border: 1px solid rgba(255,255,255,0.1);
}

.J-paginationjs-page > a:hover, .J-paginationjs-next > a:focus, .J-paginationjs-next > a:hover, .J-paginationjs-next > a:focus, .J-paginationjs-previous > a:hover, .J-paginationjs-previous > a:focus {
    background: rgba(255,255,255,0.15);
}
</style>
<script>
const numInitialRow = 10;
const pageSize = 50;
const numDays = 7;

var chartConnection, chartActivity, chartTV, chartStorage;
var tabContentLoaded = false;
var tabSTBLoaded = false;
var periodStatTerm = 1; // 1:Day, 2:Month, 3:Year
var autoRefresh = false;
var timer;
var dayChart = null;
var monthChart = null;
var yearChart = null;

$(document).ready(function() {
	chartConnection = $('#chartConnection').ntkPieChart({
		data: [],
		fontColor: '#FFFFFF'
	});
	chartActivity = $('#chartActivity').ntkPieChart({
		data: [],
		fontColor: '#FFFFFF'
	});
	chartTV = $('#chartTV').ntkPieChart({
		data: [],
		fontColor: '#FFFFFF'
	});
	chartStorage = $('#chartStorage').ntkPieChart({
		data: [],
		fontColor: '#FFFFFF'
	});
	
	$('#excelDown').click(function() {
		switch(Cookies.get('selected_tab')) {
		case '1':
			$('#excelSource').val($('#statContentTable').html());
			break;
		case '2':
			$('#excelSource').val($('#statSTBTable').html());
			break;
		case '3':
			$('#excelSource').val($('#statPeriodTable').html());
			break;
		}
		$('#excelForm').submit();
	});
	
	$('#statByContent').click(function() {
		if(Cookies.get('selected_tab') == '1') return;
		setTabToContent();
	});
	$('#statBySTB').click(function() {
		if(Cookies.get('selected_tab') == '2') return;
		setTabToSTB();
	});
	$('#statByPeriod').click(function() {
		if(Cookies.get('selected_tab') == '3') return;
		setTabToPeriod();
	});

	var contentPagination = $('#statContentTablePagination').pagination({
		dataSource: function(done) {
			var result = [];
			for(var i=1; i<<%=numTotalContents%>; i++)
				result.push(i);
			done(result);
		},
		pageSize: pageSize,
		autoHidePrevious: true,
		autoHideNext: true,
		triggerPagingOnInit: false,
		callback: function(data, pagination) {
			getStatByContent(pagination.pageNumber);
		}
	});
	var STBPagination = $('#statSTBTablePagination').pagination({
		dataSource: function(done) {
			var result = [];
			for(var i=1; i<<%=numTotalSTBs%>; i++)
				result.push(i);
			done(result);
		},
		pageSize: pageSize,
		autoHidePrevious: true,
		autoHideNext: true,
		triggerPagingOnInit: false,
		callback: function(data, pagination) {
			getStatBySTB(pagination.pageNumber);
		}
	});
	
	// refresh 버튼
	$('#autoRefresh').click(function() {
		if(autoRefresh) {
			clearInterval(timer);
			$('#refreshIcon').removeClass('fa-spin');
			$('#autoRefresh').text("자동 업데이트");
			$('#refreshInterval').prop("disabled", false);
			
			autoRefresh = false;
		}
		else {
			refreshCharts();
			timer = setInterval("refreshCharts();", $('#refreshInterval').val()*1000*60);
			
			$('#autoRefresh').text("업데이트 중지");
			$('#refreshInterval').prop("disabled", true);
			rotateIcon();

			autoRefresh = true;
		}
	});
	
	refreshCharts();
	
	$('#btnSearchStart').click(function() {
		$('#search_start').focus();			
	});
	$('#btnSearchEnd').click(function() {
		$('#search_end').focus();			
	});
	
	$.datetimepicker.setLocale('ko');
	$('#search_start').datetimepicker({
		timepicker:false,
		format:'Y-m-d'
	});
	$('#search_end').datetimepicker({
		timepicker:false,
		format:'Y-m-d'
	});
	
	$('#searchBtn').click(function() {
		var start = $('#search_start').val();
		var end = $('#search_end').val();
		console.log(start);
		console.log(end);
		if(start == "") {
			alert("시작일을 입력해 주세요.");
			return;
		}
		if(end == "") {
			alert("종료일을 입력해 주세요.");
			return;
		}
		if(start > end) {
			alert("시작일은 종료일보다 빨라야 합니다.");
			return;
		}
		
		switch(periodStatTerm) {
		case 1:
			getDayStat(start, end);
			break;
		case 2:
			getMonthStat(start.substring(0, 7), end.substring(0, 7));
			break;
		case 3:
			getYearStat(start.substring(0, 4), end.substring(0, 4));
			break;
		}
	});
	
	$('#expandContentTable').click(function() {
		$('#statContentTableExpander').hide();
		$('#statContentTable tbody tr').show();
		contentPagination.show();
	});
	$('#expandSTBTable').click(function() {
		$('#statSTBTableExpander').hide();
		$('#statSTBTable tbody tr').show();
		STBPagination.show();
	});
	
	$('#statPeriodByDay').click(function() {
		if(periodStatTerm == 1) return;
		setPeriodToDay();
	});
	$('#statPeriodByMonth').click(function() {
		if(periodStatTerm == 2) return;
		setPeriodToMonth();
	});
	$('#statPeriodByYear').click(function() {
		if(periodStatTerm == 3) return;
		setPeriodToYear();
	});
	
	function setTabToContent() {
		console.log('setTabToContent');
		//if(!tabContentLoaded) {
			tabContentLoaded = true;
			getStatByContent(1);
			$('#statContentTable tbody tr:gt('+(numInitialRow-1)+')').hide();
			contentPagination.hide();
			if(<%=numTotalContents%> <= numInitialRow) {
				$('#statContentTableExpander').hide();
			} else {
				$('#statContentTableExpander').show();
			}
		//}
		/*
		$('#statByContent').addClass('selected');
		$('#statBySTB').removeClass('selected');
		$('#statByPeriod').removeClass('selected');
		
		
		$('#statContentArea').show();
		$('#statSTBArea').hide();
		$('#statPeriodArea').hide();
		*/
		$('#searchContainer').hide();
		
		Cookies.set('selected_tab', 1);
	}
	function setTabToSTB() {
		console.log('setTabToSTB');
		//if(!tabSTBLoaded) {
			tabSTBLoaded = true;
			getStatBySTB(1);
			$('#statSTBTable tbody tr:gt('+(numInitialRow-1)+')').hide();
			STBPagination.hide();
			if(<%=numTotalSTBs%> <= numInitialRow) {
				$('#statSTBTableExpander').hide();
			} else {
				$('#statSTBTableExpander').show();
			}
		//}
		/*
		$('#statByContent').removeClass('selected');
		$('#statBySTB').addClass('selected');
		$('#statByPeriod').removeClass('selected');
		
		$('#statContentArea').hide();
		$('#statSTBArea').show();
		$('#statPeriodArea').hide();
		*/
		$('#searchContainer').hide();
		
		Cookies.set('selected_tab', 2);
	}
	function setTabToPeriod() {
		console.log('setTabToPeriod');
		/*
		$('#statByContent').removeClass('selected');
		$('#statBySTB').removeClass('selected');
		$('#statByPeriod').addClass('selected');
		
		$('#statContentArea').hide();
		$('#statSTBArea').hide();
		$('#statPeriodArea').show();
		*/
		$('#searchContainer').show();
		
		Cookies.set('selected_tab', 3);
		
		switch(periodStatTerm) {
		case 1:
			setPeriodToDay();
			break;
		case 2:
			setPeriodToMonth();
			break;
		case 3:
			setPeriodToYear();
			break;
		}
	}
	
	/*
	var last_tab = Cookies.get('selected_tab');
	console.log("last_tab " + last_tab);
	switch(last_tab){
		case '1':
			setTabToContent();
			break;
		case '2':
			setTabToSTB();
			break;
		case '3':
			setTabToPeriod();
			break;
		default:
			setTabToContent();
	}
	*/
	
	setTabToContent();
	
	// jqplot adding integersOnly option for an axis
	var oldCreateTicks = $.jqplot.LinearAxisRenderer.prototype.createTicks;
	$.jqplot.LinearAxisRenderer.prototype.createTicks = function (plot) {
	    //if (this.integersOnly == true) {
	    if(true) {
	        var db = this._dataBounds;
	        var min = ((this.min != null) ? this.min : db.min);
	        var max = ((this.max != null) ? this.max : db.max);
	        var range = max - min;
	        if (range < 3) {
	            if (this.min == null) {
	                this.min = 0;
	            }
	            this.tickInterval = 1;
	        }
	    }
	    return oldCreateTicks.apply(this, plot);
	}
	
	// auto resize
	$(window).resize(function() {
		if(dayChart) {
			console.log("redrawing dayChart");
			dayChart.replot({resetAxes:true});
		}
		if(monthChart) {
			console.log("redrawing monthChart");
			monthChart.replot({resetAxes:true});
		}
		if(yearChart) {
			console.log("redrawing yearChart");
			yearChart.replot({resetAxes:['xaxis']});
		}
	});
});

var rotateIcon = function (){
	$('#refreshIcon').addClass('fa-spin');
}

function refreshCharts() {
	$.ajax({
        url:'/stb/statStatus.do',
        type:'post',
        success:function(result){
        	console.log(result);  
        	var connectionData = [];
        	if(result.stat.disconnected > 0) {
        		connectionData.push({
        			label: '미연결'+result.stat.disconnected,
        			value: result.stat.disconnected,
        			color: 'rgb(111,111,111)'
        		});
        	}
        	if(result.stat.connected > 0) {
        		connectionData.push({
        			label: '연결'+result.stat.connected,
        			value: result.stat.connected,
        			color: 'rgb(244,184,28)'
        		});
        	}
        	
        	var activityData = [];
        	if("activity_off" in result.stat)
        		if(result.stat.activity_off > 0) {
        			activityData.push({
        				label: 'OFF '+result.stat.activity_off,
            			value: result.stat.activity_off,
            			color: 'rgb(111,111,111)'
        			});
        		}
        	if("activity_on" in result.stat)
        		if(result.stat.activity_on > 0) {
        			activityData.push({
        				label: 'ON '+result.stat.activity_on,
            			value: result.stat.activity_on,
            			color: 'rgb(244,184,28)'
        			});
        		}
        	if("activity_vod" in result.stat)
        		if(result.stat.activity_vod > 0) {
        			activityData.push({
        				label: 'VOD '+result.stat.activity_vod,
            			value: result.stat.activity_vod,
            			color: 'rgb(225,68,56)'
        			});
        		}
        	if("activity_broadcast" in result.stat)
        		if(result.stat.activity_broadcast > 0) {
        			activityData.push({
        				label: '방송중'+result.stat.activity_broadcast,
            			value: result.stat.activity_broadcast,
            			color: 'rgb(79,122,190)'
        			});
        		}
        	
        	var storageData = [];
        	if("storage_used" in result.stat && "storage_free" in result.stat) {
        		var used = result.stat.storage_used;
        		var free = result.stat.storage_free;

        		storageData.push({
					label: 'Used ' + (used/1024/1024/1024).toFixed(1) + "G",
					value: used,
        			color: 'rgb(111,111,111)'
        		});
        		storageData.push({
					label: 'Free ' + (free/1024/1024/1024).toFixed(1) + "G",
					value: free,
        			color: 'rgb(244,184,28)'
        		});
        	}
        	var data = [];
    		data.push({
    			label: 'test 25',
    			value: 25,
    			color: 'rgb(244,184,28)'
    		});
    		data.push({
    			label: 'test 65',
    			value: 25,
    			color: 'rgb(111,111,111)'
    		});
    		data.push({
    			label: 'test 65',
    			value: 45,
    			color: 'rgb(79,122,190)'
    		});
    		chartConnection.ntkPieChart('setData', connectionData);
    		chartConnection.ntkPieChart('redraw');
    		chartActivity.ntkPieChart('setData', activityData);
    		chartActivity.ntkPieChart('redraw');
    		chartTV.ntkPieChart('setData', data);
    		chartTV.ntkPieChart('redraw');
    		chartStorage.ntkPieChart('setData', storageData);
    		chartStorage.ntkPieChart('redraw');
    		
    		//d3.select('#chartConnection text').attr("transform", "translate(1.25)");
    		//console.log(d3.select('#chartConnection text').attr("transform"));
    		//var par = d3.select('#chartConnection text').parent();
    		//d3.select('#chartConnection text').text('1');
    		//par.append('text').text('hahaha');
    		
        }
	});
}

String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};
Date.prototype.format = function(f) {
    if (!this.valueOf()) return " ";
 
    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this;
     
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
};

function getStatByContent(pageNum) {
	var firstIndex = pageSize * (pageNum-1);
	$.ajax({
		url: '/stb/statByContent.do',
        type: 'post',
        data: {"firstIndex": firstIndex, "pageSize": pageSize, "numDays": numDays},
        async: false,
        success:function(result){
        	console.log(result.contentStat);
        	$("#statContentTable tbody").empty();
        	for(var i=0; i<result.contentStat.length; i++) {
        		var cur_stat = result.contentStat[i];
        		var html;
        		var dayCnt;
        		
       			html = "<tr>";
        		html += "<td>" + (i+firstIndex+1) + "</td>";
        		html += "<td>" + cur_stat.vodTitle + "</td>";
        		html += "<td>" + cur_stat.menu + "</td>";
        		html += "<td>" + cur_stat.totalCnt + "</td>";
        		if("day1" in cur_stat) dayCnt = cur_stat.day1; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		if("day2" in cur_stat) dayCnt = cur_stat.day2; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		if("day3" in cur_stat) dayCnt = cur_stat.day3; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		if("day4" in cur_stat) dayCnt = cur_stat.day4; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		if("day5" in cur_stat) dayCnt = cur_stat.day5; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		if("day6" in cur_stat) dayCnt = cur_stat.day6; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		if("day7" in cur_stat) dayCnt = cur_stat.day7; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		html += "<td>" + cur_stat.regDate + "</td>";
        		html += "</tr>";
        		$("#statContentTable tbody").append(html);
        	}
        },
        error: function() {
            alert('통계 자료를 가져올 수 없습니다.\nDB 연결 상태를 확인해 주세요.');
        }
	});
}

function getStatBySTB(pageNum) {
	var firstIndex = pageSize * (pageNum-1);
	$.ajax({
		url: '/stb/statBySTB.do',
        type: 'post',
        data: {"firstIndex": firstIndex, "pageSize": pageSize, "numDays": numDays},
        async: false,
        success:function(result){
        	console.log(result.STBStat);
        	$("#statSTBTable tbody").empty();
        	for(var i=0; i<result.STBStat.length; i++) {
        		var cur_stat = result.STBStat[i];
        		var html = "<tr>";
        		var dayCnt;
        		
        		html += "<td>" + (i+firstIndex+1) + "</td>";
        		html += "<td>" + cur_stat.name + "</td>";
        		html += "<td>" + cur_stat.totalCnt + "</td>";
        		if("day1" in cur_stat) dayCnt = cur_stat.day1; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		if("day2" in cur_stat) dayCnt = cur_stat.day2; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		if("day3" in cur_stat) dayCnt = cur_stat.day3; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		if("day4" in cur_stat) dayCnt = cur_stat.day4; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		if("day5" in cur_stat) dayCnt = cur_stat.day5; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		if("day6" in cur_stat) dayCnt = cur_stat.day6; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		if("day7" in cur_stat) dayCnt = cur_stat.day7; else dayCnt = 0;
        		html += "<td>" + dayCnt + "</td>";
        		html += "<td>" + cur_stat.regDate + "</td>";
        		html += "</tr>";
        		$("#statSTBTable tbody").append(html);
        	}
        },
        error: function() {
            alert('통계 자료를 가져올 수 없습니다.\nDB 연결 상태를 확인해 주세요.');
        }
	});
}

function setPeriodToDay() {
	console.log("setPeriodToDay");
	$('#statPeriodByDay').addClass('active');
	$('#statPeriodByMonth').removeClass('active');
	$('#statPeriodByYear').removeClass('active');
	
	//$('#stat_period_desc_str').text("D(DAY), H(HOUR)");
	periodStatTerm = 1;
	
	$('#search_start').datetimepicker('reset');
	//$('#search_start').datetimepicker('setOptions', {format: 'Y-m-d'});
	$('#search_end').datetimepicker('reset');
	//$('#search_end').datetimepicker('setOptions', {format: 'Y-m-d'});
	
	var curDate = new Date();
	var firstDate = new Date(curDate.setDate(1));
	var lastDate = new Date(curDate.getFullYear(), curDate.getMonth()+1, 0);
	//getDayStat(curDate.getFullYear(), curDate.getMonth()+1);
	getDayStat(firstDate.format("yyyy-MM-dd"), lastDate.format("yyyy-MM-dd"));
	
	$('#statDayChart').show();
	$('#statMonthChart').hide();
	$('#statYearChart').hide();
	if(monthChart) monthChart.destroy();
	monthChart = null;
	if(yearChart) yearChart.destroy();
	yearChart = null;
}
function setPeriodToMonth() {
	console.log("setPeriodToMonth");
	$('#statPeriodByDay').removeClass('active');
	$('#statPeriodByMonth').addClass('active');
	$('#statPeriodByYear').removeClass('active');
	
	//$('#stat_period_desc_str').text("D(DAY), M(MONTH)");
	periodStatTerm = 2;
	
	$('#search_start').datetimepicker('reset');
	//$('#search_start').datetimepicker('setOptions', {format: 'Y-m'});
	$('#search_end').datetimepicker('reset');
	//$('#search_end').datetimepicker('setOptions', {format: 'Y-m'});
	
	var curDate = new Date();
	getMonthStat(curDate.getFullYear() + '-01', curDate.getFullYear() + '-12');
	$('#statDayChart').hide();
	$('#statMonthChart').show();
	$('#statYearChart').hide();
	if(dayChart) dayChart.destroy();
	dayChart = null;
	if(yearChart) yearChart.destroy();
	yearChart = null;
}
function setPeriodToYear() {
	console.log("setPeriodToYear");
	$('#statPeriodByDay').removeClass('active');
	$('#statPeriodByMonth').removeClass('active');
	$('#statPeriodByYear').addClass('active');
	
	//$('#stat_period_desc_str').text("M(MONTH), Y(YEAR)");
	periodStatTerm = 3;
	
	$('#search_start').datetimepicker('reset');
	//$('#search_start').datetimepicker('setOptions', {format: 'Y'});
	$('#search_end').datetimepicker('reset');
	//$('#search_end').datetimepicker('setOptions', {format: 'Y'});
	
	getYearStat(null, null);
	$('#statDayChart').hide();
	$('#statMonthChart').hide();
	$('#statYearChart').show();
	if(dayChart) dayChart.destroy();
	dayChart = null;
	if(monthChart) monthChart.destroy();
	monthChart = null;
}

function getDayStat(start, end) {
	console.log(start + ", " + end);
	$.ajax({
		url: '/stb/statDay.do',
        type: 'post',
        data: {"start": start, "end":end},
        success:function(result){
        	//console.log(result.stat[0].cnt);
			$("#statPeriodTable colgroup").empty();
			$("#statPeriodTable thead").empty();
			$("#statPeriodTable tbody").empty();
			
			$("#stat_period_YYMM_str").text("※" + start + " ~ " + end);
			
			var chart_data = [];
			
			var colgroup, thead, tbody;
			colgroup = "<col width='3.8%'/>";
			thead = "<tr><th>D / H</th>";
			for(var hour = 1; hour <= 24; hour++) {
				colgroup += "<col width='3.8%'/>";
				thead += "<th>" + hour + "</th>";
			}
			colgroup += "<col width='5%'/>";
			thead += "<th class='total'>TOTAL</th></tr>";

			//var day = new Date(year, month-1, 1);
			var day = new Date(start);
			var endDate = new Date(end);
			var stat_pos = 0;
			var eod = false;	// end_of_data
			if(result.stat.length == stat_pos) eod = true;
			while(day <= endDate) {
				tbody += "<tr>";
				if(day.getDate() == 1)
					tbody += "<td class='edge'>" + (day.getMonth()+1) + " / " + day.getDate() + "</td>"
				else
					tbody += "<td class='edge'>" + day.getDate() + "</td>"
				for(var hour = 1; hour <= 24; hour++) {
					if(!eod && result.stat[stat_pos].day == day.format("yyyy-MM-dd") && result.stat[stat_pos].hour == hour) {
						tbody += "<td>" + result.stat[stat_pos].cnt + "</td>";
						stat_pos++;
						if(result.stat.length == stat_pos) eod = true;
					} else {
						tbody += "<td>" + "0" + "</td>";
					}
				}
				var total = 0;
				if(!eod && result.stat[stat_pos].day == day.format("yyyy-MM-dd") && result.stat[stat_pos].hour == 'TOTAL') {
					total = result.stat[stat_pos].cnt;
					stat_pos++;
					if(result.stat.length == stat_pos) eod = true;
				}
				tbody += "<td class='edge'>" + total + "</td>";
				tbody += "</tr>";
				
				chart_data.push([(day.getMonth()+1) + "월 " + day.getDate() + "일", total]);
				day.setDate(day.getDate() + 1);
			}
			
			var total = 0;
			tbody += "<tr><td class='total'>TOTAL</td>";
			for(var hour = 1; hour <= 24; hour++) {
				if(!eod && result.stat[stat_pos].day == 'TOTAL' && result.stat[stat_pos].hour == hour) {
					total += result.stat[stat_pos].cnt;
					
					tbody += "<td class='edge'>" + result.stat[stat_pos].cnt + "</td>";
					stat_pos++;
					if(result.stat.length == stat_pos) eod = true;
				} else {
					tbody += "<td class='edge'>" + "0" + "</td>";
				}
			}
			tbody += "<td class='total'>" + total + "</td></tr>";
			
			$("#statPeriodTable colgroup").append(colgroup);
			$("#statPeriodTable thead").append(thead);
			$("#statPeriodTable tbody").append(tbody);
			
			if(dayChart != null)
				dayChart.destroy();
			dayChart = $.jqplot('statDayChart', [chart_data], {
				title: 'TOTAL : ' + total,
				series: [
					{color: '#4F7ABE', lineWidth:4}
				],
				seriesDefaults: { 
					showMarker: false,
					pointLabels: { show:true } 
				},
				axes: {
					xaxis: {
						renderer: $.jqplot.CategoryAxisRenderer,
						drawMajorGridlines: false,
						tickRenderer: $.jqplot.CanvasAxisTickRenderer,
						tickOptions: {
							angle: -30
						}
					},
					yaxis: {
						min: 0,
						tickOptions: { 
				            formatString: '%d' 
				        }
					}
				}
			});
        },
        error: function() {
            alert('통계 자료를 가져올 수 없습니다.\nDB 연결 상태를 확인해 주세요.');
        }
	});	
}

function getMonthStat(start, end) {
	console.log(start + ", " + end);
	$.ajax({
		url: '/stb/statMonth.do',
        type: 'post',
        data: {"start": start, "end":end},
        success:function(result){
        	//console.log(result.stat[0].cnt);
			$("#statPeriodTable colgroup").empty();
			$("#statPeriodTable thead").empty();
			$("#statPeriodTable tbody").empty();
			
			$("#stat_period_YYMM_str").text("※" + start + " ~ " + end);
			
			var chart_data = [];
			
			var colgroup, thead, tbody;
			colgroup = "<col width='3.94%'/>";
			thead = "<tr><th>M / D</th>";
			for(var day = 1; day <= 31; day++) {
				colgroup += "<col width='2.86%'/>";
				thead += "<th>" + day + "</th>";
			}
			colgroup += "<col width='7.4%'/>";
			thead += "<th class='total'>TOTAL</th></tr>";
			
			var stat_pos = 0;
			var eod = false;	// end_of_data
			if(result.stat.length == stat_pos) eod = true;
			//for(var month = 1; month <= 12; month++) {
			var month = new Date(start + "-01");
			var endMonth = new Date(end + "-01");
			console.log(month);
			console.log(endMonth);
			while(month <= endMonth) {
				tbody += "<tr>";
				if(month.getMonth() == 0)
					tbody += "<td class='edge'>" + month.getFullYear() + " / " + (month.getMonth()+1) + "</td>";
				else
					tbody += "<td class='edge'>" + (month.getMonth()+1) + "</td>";
					
				for(var day = 1; day <= 31; day++) {
					var validDate = new Date(month.getFullYear(), month.getMonth(), day);
					if(validDate.getMonth() == month.getMonth()) {
						if(!eod && result.stat[stat_pos].day == day && result.stat[stat_pos].month == month.format("yyyy-MM")) {
							tbody += "<td>" + result.stat[stat_pos].cnt + "</td>";
							stat_pos++;
							if(result.stat.length == stat_pos) eod = true;
						} else {
							tbody += "<td>" + "0" + "</td>";
						}
					} else {
						tbody += "<td></td>";
					}
				}
				var total = 0;
				if(!eod && result.stat[stat_pos].day == 'TOTAL' && result.stat[stat_pos].month == month.format("yyyy-MM")) {
					total = result.stat[stat_pos].cnt;
					stat_pos++;
					if(result.stat.length == stat_pos) eod = true;
				}
				tbody += "<td class='edge'>" + total + "</td>";
				tbody += "</tr>";
				
				chart_data.push([month.getFullYear() + "년" + (month.getMonth()+1) + "월", total]);
				month.setMonth(month.getMonth() + 1);
			}
			
			var total = 0;
			tbody += "<tr><td class='total'>TOTAL</td>";
			for(var day = 1; day <= 31; day++) {
				if(!eod && result.stat[stat_pos].day == day && result.stat[stat_pos].month == 'TOTAL') {
					total += result.stat[stat_pos].cnt;
					
					tbody += "<td class='edge'>" + result.stat[stat_pos].cnt + "</td>";
					stat_pos++;
					if(result.stat.length == stat_pos) eod = true;
				} else {
					tbody += "<td class='edge'>" + "0" + "</td>";
				}
			}
			tbody += "<td class='total'>" + total + "</td></tr>";
			
			$("#statPeriodTable colgroup").append(colgroup);
			$("#statPeriodTable thead").append(thead);
			$("#statPeriodTable tbody").append(tbody);
						
			if(monthChart != null)
				monthChart.destroy();
			monthChart = $.jqplot('statMonthChart', [chart_data], {
				title: 'TOTAL : ' + total,
				series: [
						{color: '#E14438'}
				],
				seriesDefaults:{
					renderer:$.jqplot.BarRenderer,
					rendererOptions:{barMargin: 20},
					shadowAngle:135,
					pointLabels: { show:true }
				},
				axes: {
					xaxis: {
						renderer: $.jqplot.CategoryAxisRenderer,
						drawMajorGridlines: false
					},
					yaxis: {
					}
				}
			});
        },
        error: function() {
            alert('통계 자료를 가져올 수 없습니다.\nDB 연결 상태를 확인해 주세요.');
        }
	});	
}

function getYearStat(start, end) {
	$.ajax({
		url: '/stb/statYear.do',
        type: 'post',
        data: {"start": start, "end":end},
        success:function(result){
        	//console.log(result.stat[0].cnt);
			$("#statPeriodTable colgroup").empty();
			$("#statPeriodTable thead").empty();
			$("#statPeriodTable tbody").empty();
			
			$("#stat_period_YYMM_str").text("");
			
			var chart_data = [[],[],[],[],[],[],[],[],[],[],[],[],[]];
			var ticks = [];
			var totalLabel = [];
			
			var colgroup, thead, tbody;
			colgroup = "<col width='3.8%'/>";
			thead = "<tr><th>Y / M</th>";
			for(var month = 1; month <= 12; month++) {
				colgroup += "<col width='7.4%'/>";
				thead += "<th>" + month + "</th>";
			}
			colgroup += "<col width='7.4%'/>";
			thead += "<th class='total'>TOTAL</th></tr>";
			
			// 연도값의 최소/최대 찾기
			var start_year = 9999;
			var end_year = 0;
			for(var i=0; i<result.stat.length; i++) {
				if(result.stat[i].year == 'TOTAL') break;
				if(result.stat[i].year < start_year) start_year = result.stat[i].year;
				if(result.stat[i].year > end_year) end_year = result.stat[i].year;
			}
			console.log(typeof start_year);
			console.log(end_year);

			var stat_pos = 0;
			var eod = false;	// end_of_data
			if(result.stat.length == stat_pos) eod = true;
			for(var year = start_year; year <= end_year; year++) {
				tbody += "<tr>";
				tbody += "<td class='edge'>" + year + "</td>"
				for(var month = 1; month <= 12; month++) {
					var count = 0;
					if(!eod && result.stat[stat_pos].year == year && result.stat[stat_pos].month == month) {
						count = result.stat[stat_pos].cnt;
						stat_pos++;
						if(result.stat.length == stat_pos) eod = true;
					}
					tbody += "<td>" + count + "</td>";
					chart_data[month - 1].push([count, year - start_year + 1]);
				}
				chart_data[12].push([0, year - start_year + 1]);	// for total value
				var total = 0;
				if(!eod && result.stat[stat_pos].year == year && result.stat[stat_pos].month == 'TOTAL') {
					total = result.stat[stat_pos].cnt;
					stat_pos++;
					if(result.stat.length == stat_pos) eod = true;
				}
				tbody += "<td class='edge'>" + total + "</td>";
				tbody += "</tr>";
				
				ticks.push(year);
				totalLabel.push("Total:"+total);
			}
			
			var total = 0;
			tbody += "<tr><td class='total'>TOTAL</td>";
			for(var month = 1; month <= 12; month++) {
				if(!eod && result.stat[stat_pos].year == 'TOTAL' && result.stat[stat_pos].month == month) {
					total += result.stat[stat_pos].cnt;
					
					tbody += "<td class='edge'>" + result.stat[stat_pos].cnt + "</td>";
					stat_pos++;
					if(result.stat.length == stat_pos) eod = true;
				} else {
					tbody += "<td class='edge'>" + "0" + "</td>";
				}
			}
			tbody += "<td class='total'>" + total + "</td></tr>";
			
			$("#statPeriodTable colgroup").append(colgroup);
			$("#statPeriodTable thead").append(thead);
			$("#statPeriodTable tbody").append(tbody);
			
			if(yearChart != null)
				yearChart.destroy();
			yearChart = $.jqplot('statYearChart', chart_data, {
				stackSeries: true,
				seriesDefaults:{
					renderer:$.jqplot.BarRenderer,
					rendererOptions: {
						barDirection: 'horizontal',
						barMargin:75
					},
					shadowAngle: 135,
					pointLabels: { 
						show:true,
						hideZeros: true
					}
				},
				series:[
					{label:'1월'},
					{label:'2월'},
					{label:'3월'},
					{label:'4월'},
					{label:'5월'},
					{label:'6월'},
					{label:'7월'},
					{label:'8월'},
					{label:'9월'},
					{label:'10월'},
					{label:'11월'},
					{label:'12월'},
					{pointLabels:{
						show:true,
						labels:totalLabel
						}
					}
		        ],
				legend: {
					renderer: $.jqplot.EnhancedLegendRenderer, 
					show: true,
					location: 's',
					placement: 'outside',
					rendererOptions: {
						numberRows: 3,
						numberColumns: 4,
						seriesToggle: false
					}
				},
				axes: {
					xaxis: {
						tickOptions: {
							show: false
						}
					},
					yaxis: {
						renderer: $.jqplot.CategoryAxisRenderer,
						ticks: ticks
					}
				}
			});
        },
        error: function() {
            alert('통계 자료를 가져올 수 없습니다.\nDB 연결 상태를 확인해 주세요.');
        }
	});	
}

</script>
</head>
<body>
<ol class="breadcrumb hidden-xs">
    <li>STB 통계</li>
</ol>
<h4 class="page-title">STB 통계</h4>
<div class="block-area">
	<div class="panel panel-default tile">
		<div class="panel-body">
			<div class="col-md-2">
				<h4><a onClick="javascript:location.reload();" style="cursor:pointer;"><i id="refreshIcon" class="fa fa-refresh fa-lg m-r-10"></i>새로고침</h4></a>
			</div>
			<div class="col-md-1 col-md-offset-8">
				<select class="select pull-right" name="refreshInterval" id="refreshInterval">
					<option value="5">5분</option>
					<option value="10">10분</option>
					<option value="20">20분</option>
					<option value="30">30분</option>
				</select>
			</div>
			<div class="col-md-1 p-r-0">
				<button class="btn-sm btn pull-right" id="autoRefresh">자동 업데이트</button>
			</div>
		</div>
	</div>
	<div class="panel panel-default tile">
		<div class="panel-body">
			<div class="col-md-4 text-center">
				<label class="m-b-10">연결상태</label>
				<div id="chartConnection" style="width:125px;height:125px;margin:auto;"></div>
			</div>
			<div class="col-md-4 text-center">
				<label class="m-b-10">활동상태</label>
				<div id="chartActivity" style="width:125px;height:125px;margin:auto"></div>
			</div>
			<!-- <div class="col-md-3 text-center">
				<label class="m-b-10">TV상태</label>
				<div id="chartTV" style="width:125px;height:125px;margin:auto"></div>
			</div> -->
			<div class="col-md-4 text-center">
				<label class="m-b-10">스토리지상태</label>
				<div id="chartStorage" style="width:125px;height:125px;margin:auto"></div>
			</div>
         </div>
    </div>
	
	<div class="tab-container tile">
	    <ul class="nav tab nav-tabs">
	        <li class="active"><a href="#statContentArea" id="statByContent">컨텐츠별</a></li>
	        <li><a href="#statSTBArea" id="statBySTB">장비별</a></li>
	        <li><a href="#statPeriodArea" id="statByPeriod">기간별</a></li>
	        <li>
	        		<div id="searchContainer" class="pull-right m-l-10">
					<input class="form-control input-sm pull-left" style="width:90px;" id="search_start" type="text">
					<button class="btn-sm btn pull-left" id="btnSearchStart"><i class="fa fa-calendar"></i></button>
					<i class="fa fa-ellipsis-h pull-left m-l-5 m-r-5 p-t-10"></i>
					<input class="form-control input-sm pull-left" style="width:90px;" id="search_end" type="text">
					<button class="btn-sm btn pull-left" id="btnSearchEnd"><i class="fa fa-calendar"></i></button>
					<button class="btn-sm btn pull-left m-l-5" id="searchBtn">검색</button>
				</div>
	        </li>
	        <li class="pull-right">
	        		<button class="btn-sm btn" id="excelDown">Excel<i class="fa fa-download m-l-10"></i></button>
				
	        </li>
	    </ul>
	      
	    <div class="tab-content">
	        <div class="tab-pane active" id="statContentArea" style="overflow: hidden; outline: none;">
				<table class="table table-bordered table-hover tile" id="statContentTable" style="width:" >
					<caption></caption>
					<colgroup>
						<col width="4%"/>
						<col width="16%"/>
						<col width="13%"/>
						<col width="9%"/>
						<col width="7%"/>
						<col width="7%"/>
						<col width="7%"/>
						<col width="7%"/>
						<col width="7%"/>
						<col width="7%"/>
						<col width="7%"/>
						<col width="9%"/>
					</colgroup>
					<thead>
					<tr>
						<th rowspan="2">No</th>
						<th rowspan="2">컨텐츠명</th>
						<th rowspan="2">Menu</th>
						<th rowspan="2">시청통계</th>
						<th colspan="7">최근7일 시청수 (<%=recent7DayStr%>)</th>
						<th rowspan="2">등록일자</th>
					</tr>
					<tr>
<%
						for(int i = 0; i < 7; i++) {
%>
						<th><%=weekDateStr[i]%></th>
<%
						}
%>
					</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
				<div class="text-center" id="statContentTableExpander">
					<i id="expandContentTable" style="cursor:pointer;" class="fa fa-chevron-circle-down fa-2x"></i>
				</div>
				<div class="tableFooter" id="statContentTablePagination"></div>
	        </div>
	        <div class="tab-pane" id="statSTBArea" style="overflow: hidden; outline: none;">
				<table class="table table-bordered table-hover tile" id="statSTBTable" style="width:" >
					<caption></caption>
					<colgroup>
						<col width="4%"/>
						<col width="24%"/>
						<col width="14%"/>
						<col width="7%"/>
						<col width="7%"/>
						<col width="7%"/>
						<col width="7%"/>
						<col width="7%"/>
						<col width="7%"/>
						<col width="7%"/>
						<col width="9%"/>
					</colgroup>
					<thead>
					<tr>
						<th rowspan="2">No</th>
						<th rowspan="2">장비명</th>
						<th rowspan="2">시청통계</th>
						<th colspan="7">최근7일 시청수 (<%=recent7DayStr%>)</th>
						<th rowspan="2">등록일자</th>
					</tr>
					<tr>
<%
						for(int i = 0; i < 7; i++) {
%>
						<th><%=weekDateStr[i]%></th>
<%
						}
%>
					</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
				<div class="tableFooter" id="statSTBTableExpander">
					<i id="expandSTBTable" style="cursor:pointer;" class="fa fa-chevron-circle-down fa-2x"></i>
				</div>
				<div class="tableFooter text-center" id="statSTBTablePagination"></div>
	        </div>
	        <div class="tab-pane" id="statPeriodArea">
	            <div id="statPeriodArea">
					<div class="stat_period_header">
						<div class="stat_period_tab_buttongroup">
							<button class="btn-sm btn" id="statPeriodByDay">DAY</button>
							<button class="btn-sm btn" id="statPeriodByMonth">MONTH</button>
							<button class="btn-sm btn" id="statPeriodByYear">YEAR</button>
						</div>
						<div class="stat_period_YYMM">
							<span id="stat_period_YYMM_str"></span>
						</div>
					</div>
					<div id="statDayChart"></div>
					<div id="statMonthChart"></div>
					<div id="statYearChart"></div>
					<table id="statPeriodTable" class="statTable" style="display:none">
						<caption></caption>
						<colgroup>
						</colgroup>
						<thead>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
	        </div>
	    </div>
	</div>

	<form id="excelForm" name="excelForm" method="post" action="/stb/excelExport.do">
		<input type="hidden" id="excelSource" name="excelSource">
	</form>
	
</div>
</body>
</html>