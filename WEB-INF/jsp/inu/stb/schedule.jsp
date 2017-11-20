<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="vcms.common.file.util.UvFileUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil"%>

<%
	List<Map<String, Object>> groupList = (List) request.getAttribute("group");
	List<Map<String, Object>> vodList = (List) request.getAttribute("vod");
	List<Map<String, Object>> categoryList = (List) request.getAttribute("category");
	List<Map<String, Object>> liveChannelList = (List) request.getAttribute("liveChannel");
	List<Map<String, Object>> liveProgramList = (List) request.getAttribute("liveProgram");
	List<String> recentCaptionList = (List) request.getAttribute("caption");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="decorator" content="defaultPage">

<link rel="stylesheet" type="text/css" href="<c:url value='/js/datetimepicker/jquery.datetimepicker.css'/>">
<script type="text/javascript" src="<c:url value='/js/datetimepicker/jquery.datetimepicker.full.min.js'/>"></script>

<script type="text/javascript" src="<c:url value='/common/js/moment.min.js'/>"></script>

<link type="text/css" rel="stylesheet" href="<c:url value='/js/jstree/dist/themes/default/style.min.css'/>">
<script type="text/javascript" src="<c:url value='/js/jstree/dist/jstree.min.js'/>"></script>

<link id='uploadify_css' rel='stylesheet' type='text/css' oadify_step.css'>
<script src='/common/uploadify/jquery.uploadify.js'></script>

<script src="/js/colorpicker/js/jquery.colorPicker.js" type="text/javascript"></script>
<link rel="stylesheet" href="/js/colorpicker/css/colorPicker.css" type="text/css" />

<style>
#selectedVODs tbody tr.selected td {
	background: none repeat scroll 0 0 #FFCF8B;
}
.modal-open {
    overflow: scroll;
}
.depth1 {
	margin-left:15px; !important
}
.depth2 {
	margin-left:25px; !important
}
.fc-agenda-slots td {
	border-width: 0 0 1px
}
.fc-agenda-slots tr.fc-minor td {
	border-bottom-style: dotted;
}

html,
body {
  height: 100% !important;
}

body {
  overflow-x: hidden !important;
}

#calendar {
  margin: 0 auto;
}

.colorPicker-picker {
	color:#000;
}
.fc-agenda-slots td {
   border-width: 1px 0 1px;
}

</style>
<script>
$(document).ready(function() {
	// 방송 시작, 종료시간 팝업
	$.datetimepicker.setLocale('ko');
	$('#datetimepicker_start').datetimepicker({
		step:30
	});
	$('#datetimepicker_end').datetimepicker({
		step:30
	});
	
	$('input:radio[name=displayType][value=weekday]').on('ifChecked', function(event){
		//$('#calendar').fullCalendar('changeView', 'agendaWeekdays');
		$('#calendar').fullCalendar('destroy');
		initCalendar(false);
	});
	
	$('input:radio[name=displayType][value=all]').on('ifChecked', function(event){
		//$('#calendar').fullCalendar('changeView', 'agendaWeek');
		$('#calendar').fullCalendar('destroy');
		initCalendar(true);
	});
	
	
	$('#scheduleDialogForm').on('hidden.bs.modal', function (e) {
		$('#calendar').fullCalendar('unselect');
		$('#schedule_image_upload').uploadify("destroy");
	});
	
	
	initCalendar(false);
	
	
	$('input[name=schedule_color]').on('ifChecked', function(event){
		//$(this).parent().css({'background-color':$(this).val()});
		$(this).parent().css({'border-width':'4px', 'border-color':$(this).val()});
	});
	$('input[name=schedule_color]').on('ifUnchecked', function(event){
		//$(this).parent().css({'background-color':$(this).val()});
		$(this).parent().css({'border-width':'1px', 'border-color':'white'});
	});
	
	
	$("#newSchedule").click(function(){
		resetDialog();
		//scheduleDialog.dialog("option", "title", "신규방송등록");
		$('.sednButton.negative').show();
		$('.sednButton.delete').hide();
		$('#scheduleID').val("");
		//scheduleDialog.dialog("open");
		initImageUpload();
		$('#btDeleteSchedule').hide();
		$('#scheduleTitle').html('신규 방송 편성')
		$('#scheduleDialogForm').modal('show');
	});
	
	$('#targetAll').click(function() {
		setTargetToAll();
	});
	$('#targetGroup').click(function() {
		setTargetToGroup();
	});
	$('#sourceLive').click(function() {
		setSourceToLive();
	});
	$('#sourceVOD').click(function() {
		setSourceToVOD();
	});
	$('#captionRecent').click(function() {
		//recentCaptionDialog.dialog("open");
		$("#recentCaptionDialogForm :radio").prop('checked', false).iCheck('update');
		
		$('#recentCaptionDialogForm').modal('show');
	});
	
	$('#liveChannel').change(function() {
		//console.log("select change " + $('#liveChannel option:selected').val());
		$('#channelName').val($('#liveChannel option:selected').text());
	});
	/*
	$('input:radio[name=liveInput][value=fromDB]').click(function() {
		$("#livePrograms tbody :checkbox").prop('checked', false);
		selectLiveDialog.dialog("open");
	});
	*/
	$('input:radio[name=liveInput][value=fromDB]').on('ifChecked', function() {
		$("#livePrograms tbody :checkbox").prop('checked', false).iCheck('update');
		//selectLiveDialog.dialog("open");
		$('#selectLiveDialog').modal({'backdrop':'static'});
	});
	
	// 스케줄 색상 초기화
	/*
	$('input:radio[name=schedule_color]').each(function (index, element) {
		var radio = $(element);
		//var color = hexc(radio.next().css('backgroundColor'));
		//radio.val(color);
	});
	*/

	
	$('#groupTree').jstree({
		"core" : {
			"data" : [
			    <%if (groupList != null) {

				Map<String, Object> GroupNode;

				for (int i = 0; i < groupList.size(); i++) {
					GroupNode = groupList.get(i);
					String groupID = String.valueOf(GroupNode.get("groupID"));
					String parentID = String.valueOf(GroupNode.get("parentID"));
					String position = String.valueOf(GroupNode.get("position"));
					String groupName = String.valueOf(GroupNode.get("groupName"));
					if (parentID.equals("0"))
						parentID = "#";%>
				{"id" : "<%=groupID%>", "parent" : "<%=parentID%>", "text" : "<%=groupName%>",
				 "name" : "<%=groupName%>",
				 "state" : {"opened" : true } },
				<%}
			}%>
			]
		},
		"checkbox" : {
			"three_state" : false,
			"cascade" : "down"
		},
		"plugins" : [ "checkbox" ]
	});
	
	// VOD 추가  팝업
	/*
	var addVODDialog;
	addVODDialog = $("#addVODDialogForm").dialog({
		title: "VOD를 선택하세요",
		autoOpen: false,
		width: 430,
		height: 300,
		resizable: false,
		modal: true,
		buttons: {
			"1": {text: '추가', click: addSelectedVODs, "class": "sednButtonSmall positive" },
			"2": {text: '취소', click: function() {addVODDialog.dialog("close");}, "class": "sednButtonSmall negative"},
		},
	});
	*/

	$('#addVOD').click(function() {
		// 생성 전 다이얼로그 초기화
		$("#registeredVODs tbody :checkbox").prop('checked', false);
		$("#vodCategory .category").removeClass("selected");
		$("#vodCategory .category.all").addClass("selected");
		$("#registeredVODs tbody tr").show();
		
		//addVODDialog.dialog("open");
		$('#addVODDialogForm input[name=check_vod]').iCheck('uncheck').iCheck('update');
		$('#addVODDialogForm').modal('show');
	});
	$('#deleteVOD').click(function() {
		$("#selectedVODs tbody .selected").remove();
		adjustEndTime();
	});
	$('#moveUpVOD').click(function() {
		var selected = $("#selectedVODs tbody .selected");
		var prev = selected.prev();
		if(prev.length == 1) {
			selected.insertBefore(prev);
		}
	});
	$('#moveDownVOD').click(function() {
		var selected = $("#selectedVODs tbody .selected");
		var next = selected.next();
		if(next.length == 1) {
			selected.insertAfter(next);
		}
	});
	
	// vod popup checkbox 제외한 row click 이벤트 핸들러
	$("#registeredVODs tbody tr").click(function (event) {
		if(event.target.type == 'checkbox') return;
		
		var cur_checkbox = $(this).find("td:first input[name='check_vod']");
		var is_checked = cur_checkbox.is(":checked"); 
		//console.log(is_checked);
		
		// 체크박스 반대로 세팅함.
		cur_checkbox.prop('checked', !is_checked);
		cur_checkbox.change();
	});
	// checkbox only 핸들러
	$("#registeredVODs tbody :checkbox").change(function () {
		console.log("checkbox changed");
		var is_checked = $(this).is(":checked");
		console.log(is_checked);	// 바뀐 상태에 따라 세팅
		var cur_row = $(this).parent().parent();
		if(is_checked) {
			cur_row.addClass("selected");
		} else {
			cur_row.removeClass("selected");
			$("#registeredVODs thead :checkbox").prop('checked', false);
		}
	});
	
	// 카테고리 클릭 핸들러
	$("#vodCategory .category").click(function (event) {
		$("#vodCategory .category").removeClass("active");
		$(this).addClass("active");
		
		// 해당 카테고리의 VOD만 보여줌
		var cate_id = $(this).find("input[name='category_id']").val();
		console.log("category clicked - " + cate_id);
		$("#registeredVODs tbody tr").each(function(index) {
			var curMenuStr = $(this).find("td:first input[name='vod_menu']").val();
			var curMenuList = curMenuStr.split(/,|`/);
			var result = $.inArray(cate_id, curMenuList);
			//console.log(curMenuStr);
			//console.log(curMenuList);
			//console.log(result);
			
			if(result != -1 || cate_id == 1)
				$(this).show();
			else
				$(this).hide();
		});
	});
	
	// LIVE 불러오기 팝업
	/*
	var selectLiveDialog;
	selectLiveDialog = $("#selectLiveDialog").dialog({
		title: "LIVE 방송을 선택하세요",
		autoOpen: false,
		width: 300,
		height: 350,
		resizable: false,
		modal: true,
		buttons: {
			"1": {text: '선택', click: selectLiveProgram, "class": "sednButtonSmall positive" },
			"2": {text: '취소', click: function() {selectLiveDialog.dialog("close");}, "class": "sednButtonSmall negative"},
		},
	});
	*/
	
	// live popup checkbox 제외한 row click 이벤트 핸들러
	$("#livePrograms tbody tr").click(function (event) {
		if(event.target.type == 'checkbox') return;
		
		var cur_checkbox = $(this).find("td:first input[name='check_program']");
		var is_checked = cur_checkbox.is(":checked"); 
		//console.log(is_checked);
		
		// 체크박스 반대로 세팅함.
		cur_checkbox.prop('checked', !is_checked);
		cur_checkbox.change();
	});
	// checkbox only 핸들러
	$("#livePrograms tbody :checkbox").change(function () {
		console.log("checkbox changed");
		var is_checked = $(this).is(":checked");
		console.log(is_checked);	// 바뀐 상태에 따라 세팅
		if(is_checked)
			$("#livePrograms tbody :checkbox").not(this).prop('checked', false);
		//var cur_row = $(this).parent().parent();
		//if(is_checked) {
		//	cur_row.addClass("selected");
		//} else {
		//	cur_row.removeClass("selected");
		//	$("#livePrograms thead :checkbox").prop('checked', false);
		//}
	});

		
	// 자막색상 팝업
	$("#captionTextColor").colorPicker({showHexField: false});
	$("#captionBGColor").colorPicker({
		showHexField: false, 
		transparency: true, 
		onColorChange: function(id, newValue) { 
			console.log("ID: " + id + " has been changed to " + newValue);
			setCaptionBG(true);
		} 
	});
	$('#clearCaptionBGColor').click(function (event) {
		setCaptionBG(false);
	});
	
	// 자막 텍스트 길이 제어
	$("#caption").on("change input paste keyup", function() {
		//console.log("text change");
		var caption = $(this).val();
		var len = caption.length;
		if(len > 255) {
			alert("자막은 255자 이내로 작성할 수 있습니다.");
			$(this).val(caption.substring(0, 255));
		}
		
		caption = $(this).val();
		len = caption.length;
		$("#captionLength").text(len);
	});
	
	// 자막 안내 가이드 문구
	$("#caption").on("focus", function() {
		$("#captionHelp").hide();
	})
	.on("blur", function() {
		if($(this).val()=="") $("#captionHelp").show();;
	});
	$("#captionHelp").click(function () {
		$("#caption").focus();	
	});
	
});

function getVODListArray(list) {
	var res = new Array();
	
	list.each(function(index, item) {
		var title = $(item).find("td:first").text();
		var id = $(item).find("[name=vod_id]").val();
		var duration = $(item).find("[name=vod_duration]").val();
		res.push({'id':id, 'title':title, 'duration':duration});
	});
	
	return res;
}
function addRecentCaption(caption) {
	if(caption != null && caption.length > 0) {
		$.ajax({
	        url:'/stb/addRecentCaption.do',
	        type:'post',
	        data: {'caption':caption},
	        success:function(result){
	        	console.log(result);        		
	        }
		});
	}
}

function initCalendar(weekendsMode) {
	$('#calendar').fullCalendar({
        header: {
             center: 'prev title next',
             left: '',
             right: ''
        },
        monthNamesShort:['1월', '2월', '3월', '4월', '5월', '6월','7월', '8월', '9월', '10월', '11월', '12월'],
        monthNames:['1월', '2월', '3월', '4월', '5월', '6월','7월', '8월', '9월', '10월', '11월', '12월'],
       	dayNames:['일요일','월요일','화요일','수요일','목요일','금요일','토요일'],
       	dayNamesShort:['일','월','화','수','목','금','토'],
       	titleFormat:{
       	    month: 'yyyy MMMM',
       	    week: "yyyy MMM",//"yyyy MMM d[ yyyy]{ '&#8212;'[ MMM] d}",
       	    day: 'yyyy/MMM/d/dddd'
       	},
       	contentHeight : 1036,
       	axisFormat : 'HH:mm',
       	agenda: 'HH:mm{ - HH:mm}',
       	timeFormat: 'HH:mm{ - HH:mm}',
        selectable: true,
        selectHelper: true,
        editable: true,
        allDaySlot: false,
        defaultView: 'agendaWeek',
		unselectAuto: false,
		eventStartEditable: true,
		eventDurationEditable: false,
		slotEventOverlap: false,
		eventTextColor: '#6b6b6b',
		eventBackgroundColor: 'rgba(200,200,200, 0.7)',
		eventBorderColor: 'rgba(255,255,255,0.15)',
		
		weekends: weekendsMode,
		
		events: function(start, end, callback){
	    	$.ajax({
	    		url: '/stb/listSchedule.do',
		        type: 'post',
		        data: {"start": moment(start).format('YYYY-MM-DD'), "end": moment(end).format('YYYY-MM-DD')},
		        success:function(result){
		        	//console.log(result);
		        	var events = [];
		        	for(var i=0; i<result.scheduleList.length; i++) {
		        		var sch = result.scheduleList[i];
		        		console.log(sch);
		        		//console.log("listSchedule");
		        		console.log(sch.vodList);
		        		console.log(sch.groupList);
		            	events.push({
		            		id: sch.scheduleID,
		            		title: sch.scheduleName,
		            		start: parseInt(moment(sch.start).format('X'), 10),
		            		end: parseInt(moment(sch.end).format('X'), 10),
		            		allDay: false,
		            		start_actual: moment.utc(sch.start),
		            		end_actual: moment.utc(sch.end),
		    				targetType: getTargetTypeStr(sch.targetType),
		    				targetColor: getTargetTypeColor(sch.targetType),
		    				sourceType: getSourceTypeStr(sch.sourceType),
		    				sourceColor: getSourceTypeColor(sch.sourceType),
		    				captionType: getCaptionTypeStr(sch.caption),
		    				captionColor: getCaptionTypeColor(sch.caption),
		    				groupList:sch.groupList,
		    				vodList: sch.vodList,
		    				liveChannel: sch.liveChannel,
		    				liveStreamURL: sch.liveStreamURL,
		    				caption: sch.caption,
		    				captionSize: sch.captionSize,
		    				captionSpeed: sch.captionSpeed,
		    				captionTextColor: sch.captionTextColor,
		    				captionBGColor: sch.captionBGColor,
		    				scheduleColor: sch.color,
		    				imgPath: sch.imgPath,
		    				desc: sch.desc
		            	});
		        	}

	            	callback(events);
	            },
		        error: function() {
		            alert('방송 스케줄을 가져올 수 없습니다.\nDB 연결 상태를 확인해 주세요.');
		        }
	    	});
	    },
	    viewRender: function(view, element) {
			console.log("viewRender");
			//console.log(view);
			//console.log(element);
		},
		select: function(start, end, allDay, jsEvent, view) {
			//console.log(view);
			/*
			var top = $('.fc-agenda-days').offset().top + $('.fc-agenda-axis').height();
			console.log(start + ', clientY:' + jsEvent.clientY  + ', pageY:' + jsEvent.pageY
					+ ', screenY:' + jsEvent.screenY + ', screenYCal:' + (jsEvent.screenY + window.scrollY));
			console.log('screenY:' + (jsEvent.screenY + window.scrollY - 312) / 20);
			*/
			resetDialog();
			$('#datetimepicker_start').val(moment(start).format("YYYY/MM/DD HH:mm"));
			$('#datetimepicker_end').val(moment(end).format("YYYY/MM/DD HH:mm"));
			//scheduleDialog.dialog("option", "title", "신규방송편성");
			$('.sednButton.negative').show();
			$('.sednButton.delete').hide();
			$('#scheduleID').val("");
			//scheduleDialog.dialog("open");
			initImageUpload();
			$('input[name=schedule_color]').each(function() {
				$(this).parent().css({'background-color':$(this).val()});
				$(this).parent().css({'border-width':'1px', 'border-color':'white'});
				if($(this).prop('checked')) {
					$(this).parent().css({'border-width':'4px', 'border-color':$(this).val()});	
				}
			});
			$('#btDeleteSchedule').hide();
			$('#scheduleTitle').html('신규 방송 편성')
			$('#scheduleDialogForm').modal('show');
			console.log("start " + moment(start).format("YYYY/MM/DD HH:mm"));
		},
		eventAfterAllRender: function(view) {
			adjustCalendarAxis();
		},
		eventRender: function(event, element) {
			//console.log(event);
			if(!event.title) return;
			
			var content = element.children('.fc-content');
			var time = content.children('.fc-time');
			var title = content.children('.fc-title');
			
			// end_actual 적용
			var time_text = time.children().text();
			time_text = time_text.substring(0, time_text.length - 5);
			time_text += event.end_actual.format("HH:mm");
			time.children().text(time_text);
			
			title.insertBefore(time);
			time.addClass('scheduleItemTime');
			time.prepend("<span class='ui-icon ui-icon-bullet'></span>");
			title.addClass('scheduleItemTitle');
			title.prepend("<span class='ui-icon ui-icon-bullet'></span>");
			var htmlTarget = "<span class='scheduleItemDetail' style='background:" + event.targetColor + "'>" + event.targetType + "</span>";
			var htmlSource = "<span class='scheduleItemDetail' style='background:" + event.sourceColor + "'>" + event.sourceType + "</span>";
			var htmlText = "<span class='scheduleItemDetail' style='background:" + event.captionColor + "'>" + event.captionType + "</span>";
			var htmlContainer = "<div class='scheduleItemContainer'>" + htmlTarget + htmlSource + htmlText + "</div>";
			content.append(htmlContainer);
			
			element.mouseenter(function() {
				console.log("jquery mouse enter");
				$(this).css('min-width', 200);
				$(this).css('min-height', 75);
				$(this).css('z-index', 9999);
				$(this).parent().parent().css('z-index', 99999);
			});
			element.mouseleave(function() {
				console.log("jquery mouse leave");
				$(this).css('min-width', '');
				$(this).css('min-height', '');
				$(this).css('z-index', '');
				$(this).parent().parent().css('z-index', '');
			});
		},
		eventClick: function(calEvent, jsEvent, view) {
			//scheduleDialog.dialog("option", "title", "편성방송수정");
			$('.sednButton.negative').hide();
			$('.sednButton.delete').show();
			$('input[name=schedule_color]').each(function() {
				$(this).parent().css({'background-color':$(this).val()});
			});
			populateEvent(calEvent);
			//scheduleDialog.dialog("open");
			$('#btDeleteSchedule').show();
			$('#scheduleTitle').html('편성 방송 수정')
			$('#scheduleDialogForm').modal('show');
		},
		eventDrop: function(event,dayDelta,minuteDelta) {
			console.log("eventDrop");
			event.start_actual = moment(event.start_actual).add(dayDelta, 'day');
			event.start_actual = moment(event.start_actual).add(minuteDelta, 'minute');
			event.end_actual = moment(event.end_actual).add(dayDelta, 'day');
			event.end_actual = moment(event.end_actual).add(minuteDelta, 'minute');
			
			updateScheduleTime(event.id, moment(event.start_actual).format("YYYY/MM/DD HH:mm"), moment(event.end_actual).format("YYYY/MM/DD HH:mm"));
		},
		eventResize: function(event) {
			console.log("eventResize");
			event.start_actual = event.start;
			event.end_actual = event.end;
			updateScheduleTime(event.id, moment(event.start_actual).format("YYYY/MM/DD HH:mm"), moment(event.end_actual).format("YYYY/MM/DD HH:mm"));
		},
		eventMouseover: function(event, jsEvent, view) {
			console.log("mouseover");
			console.log(typeof view);
			console.log(view);
		},
		eventMouseout: function(event, jsEvent, view) {
			console.log("mouseout");
		}
    });
	
	$('#calendar .fc-toolbar .fc-center button').addClass('btn btn-sm');
	$('#calendar .fc-toolbar .fc-center h2').css('font-size', '22px');
	$('#calendar .fc-header-title h2').css({'font-size':'22px','display':'inline','margin-left':'5px', 'margin-right':'5px'});
	//$('#calendar .fc-button-prev').css({'float':'left'});
	//$('#calendar .fc-button-next').css({'float':'left'});
}
// 이미지 업로더
function initImageUpload() {
	$('#schedule_image_upload').uploadify({
		'swf' : '/common/uploadify/uploadify.swf',
		'uploader' : '/file/upload.do',
		'buttonImage' : '/common/uploadify/images/bt_addfile_s.jpg',
		'width' : 70,
		'height' : 20, 
		'multi': false,
		'fileTypeExts' : '*.jpg; *.png',
		'fileSizeLimit' : '100MB',
		'formData' : {'FILE_GUBUN': 'STB_SCHEDULE_IMG'},
		'onUploadError' : function(file, errorCode, errorMsg, errorString) {
			alert(file.name + ' 업로드가 불가능 합니다. \n불가사유\n' + errorString);
		},
		'onUploadSuccess' : function(file, data, response) {
			data = eval( "("+ data + ")" );
			var file_url = data.FILE_PATH.substring(data.FILE_PATH.indexOf('/UPLOAD/'));
			$('#schedule_image').attr('src', file_url);
		}
	});
}

function hexc(colorval) {
    var parts = colorval.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
    delete(parts[0]);
    for (var i = 1; i <= 3; ++i) {
        parts[i] = parseInt(parts[i]).toString(16);
        if (parts[i].length == 1) parts[i] = '0' + parts[i];
    }
    
    var hexcolor = '#' + parts.join('');
    return hexcolor;
}

function minGap(str_start, str_end) {
	var start = moment.utc(str_start);
	var end = moment.utc(str_end);
	console.log("minGap");
	console.log(start);
	console.log(end);
	if(moment(start).add(30, 'minutes') > end) {
		console.log("short!!");
		end = start;
	}
	return end.format("YYYY/MM/DD HH:mm");
}

function clearVODList() {
	$("#selectedVODs tbody").children().remove();
}

function addVODtoList(id, title, duration) {
	$("#selectedVODs tbody").append("<tr><td>"+title+"</td><td style='width:0px'><input type='hidden' name='vod_id' value='"+id+"'/><input type='hidden' name='vod_duration' value='"+duration+"'/></td></tr>");
	$("#selectedVODs tbody").children().last().click(vodClick);
}

function getAndshowTotalDuation() {
	var total_duration = 0;
	
	$('#selectedVODs tbody tr').each(function(index, item) {
		var duration = $(item).find("[name=vod_duration]").val();
		var arr = duration.split(':');

		console.log(duration);
		dur_msec = arr[0]*60;
		dur_msec = (dur_msec + Number(arr[1]))*60;
		dur_msec = (dur_msec + Number(arr[2]))*1000;
		console.log(dur_msec);
		total_duration += dur_msec;
//		res.push({'id':id, 'title':title, 'duration':duration});
	});
	
	var dur_moment = moment.duration(total_duration); 
	$("#total_time").text(Math.floor(dur_moment.asHours()) + moment.utc(dur_moment.asMilliseconds()).format(":mm:ss"));
	
	return total_duration;
}
function adjustEndTime() {
	var start = new Date($("#datetimepicker_start").val());
	console.log(start);
	var total_duration = getAndshowTotalDuation();
		
	// 분단위 올림
	total_duration = Math.ceil(total_duration/1000/60)*1000*60;
	
	start.setTime(start.getTime() + total_duration);
	$("#datetimepicker_end").val(moment(start).format("YYYY/MM/DD HH:mm"));
}
// vod list click handler
var vodClick = function (event) {
	console.log("vod selected");
	$(this).parent().children().removeClass("selected");
	$(this).addClass("selected");
};

function getTargetTypeStr(type) {
	var res;
	if(type == 'ALL')
		res = '전체';
	else
		res = '그룹';
	return res;
}
function getTargetTypeColor(type) {
	var res;
	if(type == 'ALL')
		res = 'rgb(225,68,56)';
	else
		res = 'rgb(54,161,83)';
	return res;
}
function getSourceTypeStr(type) {
	var res = type;
	if(type == 'VOD')
		res = 'VOD';
	return res;
}
function getSourceTypeColor(type) {
	var res;
	if(type == 'VOD')
		res = 'rgb(225,68,56)';
	else
		res = 'rgb(244,184,28)';
	return res;
}
function getCaptionTypeStr(caption) {
	var res = '자막없음';
	console.log("caption");
	console.log(caption);
	if(caption != null && caption.length > 0)
		res = '자막';
	return res;
}
function getCaptionTypeColor(caption) {
	var res;
	if(caption != null && caption.length > 0)
		res = 'rgb(79,122,190)';
	else
		res = 'rgb(111,111,111)';
	return res;
}

function createSchedule(title, start_time, end_time, target_type, source_type, group_list, vod_list, live_ch_idx, live_stream_url, caption, captionSize, captionSpeed, captionTextColor, captionBGColor, color, img_path, desc) {
	var newID = null;
	var vod_id_list = [];
	for(var idx in vod_list) {
		vod_id_list.push(vod_list[idx].id);
	}
	
	jQuery.ajaxSettings.traditional = true;
	$.ajax({
        url:'/stb/createSchedule.do',
        type:'post',
        data: {'scheduleName':title,
        		'start':start_time,
        		'end':end_time,
        		'targetType':target_type,
        		'sourceType':source_type,
        		'groupIDList':group_list,
        		'vodIDList':vod_id_list,
        		'liveChannel':live_ch_idx,
        		'liveStream':live_stream_url,
        		'caption':caption,
        		'captionSize':captionSize,
        		'captionSpeed':captionSpeed,
        		'captionTextColor':captionTextColor,
        		'captionBGColor':captionBGColor,
        		'color':color,
        		'imgPath':img_path,
        		'desc':desc
        		},
        async: false,
        success:function(result){
        	console.log(result);        		
        	newID = result.newScheduleID;
        	refreshSTB(target_type, group_list);
        },
        error:function() {
        	alert("스케줄 편성에 실패했습니다.\nDB 연결상태를 확인해주세요.");
        }
	});
	
	return newID;
}

function updateSchedule(id, title, start_time, end_time, target_type, source_type, group_list, vod_list, live_ch_idx, live_stream_url, caption, captionSize, captionSpeed, captionTextColor, captionBGColor, color, img_path, desc) {
	var vod_id_list = [];
	for(var idx in vod_list) {
		vod_id_list.push(vod_list[idx].id);
	}
	console.log(live_ch_idx);
	jQuery.ajaxSettings.traditional = true;
	$.ajax({
        url:'/stb/updateSchedule.do',
        type:'post',
        data: {'scheduleID':id,
        	'scheduleName':title,
    		'start':start_time,
    		'end':end_time,
    		'targetType':target_type,
    		'sourceType':source_type,
    		'groupIDList':group_list,
    		'vodIDList':vod_id_list,
    		'liveChannel':live_ch_idx,
    		'liveStream':live_stream_url,
    		'caption':caption,
    		'captionSize':captionSize,
    		'captionSpeed':captionSpeed,
    		'captionTextColor':captionTextColor,
    		'captionBGColor':captionBGColor,
    		'color':color,
    		'imgPath':img_path,
    		'desc':desc
    		},
        success:function(result){
        	refreshSTB(target_type, group_list);
        	console.log(result);        		
        	alert("변경된 스케줄이 저장되었습니다.");
        },
        error:function() {
        	alert("스케줄 저장에 실패했습니다.\nDB 연결상태를 확인해주세요.");
        }
	});
}

function updateScheduleTime(id, start, end) {
	var data = new Object();
	
	data.scheduleID = id;
	data.start = start;
	data.end = end;
	
	$.ajax({
        url:'/stb/updateScheduleTime.do',
        type:'post',
        data: data,
        success:function(result){
        	refreshSTB("ALL", "1");	// 스케줄 변경은 모든 장비 업데이트
        	console.log(result);        		
        },
        error:function() {
        }
	});
}

function populateEvent(event) {
	console.log("populate");
	console.log(event.id);
	var ref = $('#groupTree').jstree(true);
	
	$('#scheduleID').val(event.id);
	$('#scheduleName').val(event.title);
	$('#datetimepicker_start').val(moment(event.start).format("YYYY/MM/DD HH:mm"));
	$('#datetimepicker_end').val(moment(event.end_actual).format("YYYY/MM/DD HH:mm"));

	ref.deselect_all(true);
	if(event.targetType == '전체')
		setTargetToAll();
	else {
		setTargetToGroup();
		ref.settings.checkbox.cascade = "";
		console.log(event.groupList);
		ref.check_node(event.groupList);
		ref.settings.checkbox.cascade = "down";
	}
	
	clearVODList();
	$('#total_time').text("00:00:00");
	if(event.liveChannel != 0) {
		$('#liveChannel').val(event.liveChannel);
		$('#liveChannel').change();
	}
	$('#liveURL').val("");
	if(event.sourceType == 'LIVE') {
		setSourceToLive();
		$('#liveURL').val(event.liveStreamURL);
	}
	else {
		setSourceToVOD();
		for(var i in event.vodList) {
			addVODtoList(event.vodList[i].id, event.vodList[i].title, event.vodList[i].duration);	
		}
		getAndshowTotalDuation();
	}
	
	if(event.caption.length > 0)
		$('#captionHelp').hide();
	$('#caption').val(event.caption);
	if(event.captionSize < 1 || event.captionSize > 3)
		$('#captionSize').val(1);
	else
		$('#captionSize').val(event.captionSize);
	if(event.captionSpeed < 1 || event.captionSpeed > 4)
		$('#captionSpeed').val(1);
	else
		$('#captionSpeed').val(event.captionSpeed);
	if(event.captionTextColor == null || event.captionTextColor == "")
		$('#captionTextColor').val("#ffffff");
	else
		$('#captionTextColor').val(event.captionTextColor);
	$('#captionTextColor').change();
	if(event.captionBGColor == null || event.captionBGColor == "") {
		setCaptionBG(false);
	} else {
		setCaptionBG(true);
		$('#captionBGColor').val(event.captionBGColor);
		$('#captionBGColor').change();
	}
	
	$('input:radio[name=schedule_color][value="'+event.scheduleColor+'"]').iCheck("check");
	$("#schedule_image").attr('src', event.imgPath);
	$("#schedule_desc").val(event.desc);
	
}

function adjustCalendarAxis() {
	$("#calendar .fc-slats .fc-axis:has('span')").attr("rowspan", "2");//css("background", "green");
	$("#calendar .fc-slats .fc-minor .fc-axis").remove();//css("background", "blue");
	//$('#calendar .fc-slats .fc-axis span').each(function(i, k) {
		//console.log(k.innerHTML);
		//k.innerHTML = k.innerHTML.replace("시 0분", ":00");
	//});
}

function setTargetToAll() {
	$('#targetAll').addClass('active');
	$('#targetGroup').removeClass('active');
	$('#targetType').val("ALL");
	$('#groupTree').hide();
//	$('#groupTree').prop("disabled", true);
//	$('#groupTree').find("*").prop("disabled", true);
}
function setTargetToGroup() {
	$('#targetAll').removeClass('active');
	$('#targetGroup').addClass('active');
	$('#targetType').val("GROUP");
	$('#groupTree').show();
	$('#groupTree').jstree('deselect_all');
//	$('#groupTree').prop("disabled", false);
//	$('#groupTree').find("*").prop("disabled", false);
}
function setSourceToLive() {
	$('#sourceLive').addClass('active');
	$('#sourceVOD').removeClass('active');
	$('#sourceType').val("LIVE");
	$('#liveURLdiv').show();
	$('#listVODdiv').hide();
}
function setSourceToVOD() {
	$('#sourceLive').removeClass('active');
	$('#sourceVOD').addClass('active');
	$('#sourceType').val("VOD");
	$('#liveURLdiv').hide();
	$('#listVODdiv').show();
} 

function resetDialog() {
	$('#scheduleName').val("");
	$('#datetimepicker_start').val("");
	$('#datetimepicker_end').val("");
	setTargetToAll();
	setSourceToLive();
	//$('input:radio[name=liveInput][value=fromDB]').prop("checked", false);
	$('input:radio[name=liveInput][value=fromDB]').iCheck('uncheck');
	$('input:radio[name=liveInput][value=directInput]').iCheck('check');
	$("#liveChannel").val("");
	$("#channelName").val("");
	$("#liveURL").val("");
	clearVODList();
	$('#total_time').text("00:00:00");
	$('#caption').val("");
	$('#captionSize').val("1");
	$('#captionSpeed').val("1");
	$('#captionTextColor').val("#ffffff");
	$("#captionTextColor").change();
	setCaptionBG(false);
	$('input:radio[name=schedule_color]').prop('checked', false).first().prop("checked", true);
	$("#schedule_image").attr('src', "");
	$("#schedule_desc").val("");
	$('#liveChannel, #captionSize, #captionSpeed').selectpicker('refresh');
	
	$('input[name=schedule_color]').each(function() {
		$(this).parent().css({'background-color':$(this).val()});
		$(this).parent().css({'border-width':'1px', 'border-color':'white'});
		if($(this).prop('checked')) {
			$(this).parent().css({'border-width':'4px', 'border-color':$(this).val()});
			//$(this).iCheck("check");
		}
		$(this).iCheck('update');
	});
}

function setCaptionBG(set) {
	if(set) {
		$('#clearCaptionBGColor').show();
		$("#captionBGColor").next().text('');
	} else {
		$('#clearCaptionBGColor').hide();
		$("#captionBGColor").val('#ececec');
		$("#captionBGColor").next().text('없음');
		$("#captionBGColor").change();
	}
}

function refreshSTB(target_type, group_list) {
	if(group_list.length == 0)
		group_list.push(0);	// group_list가 empty면 controller에서 error 발생
	//console.log("refreshSTB " + target_type);
	//console.log(group_list);
	
	// 스케줄 변경은 모든 장비 업데이트 (추가수정사항) 파라미터 의미 없음.
	jQuery.ajaxSettings.traditional = true;
	$.ajax({
        url:'/stb/sendGroupCommand.do',
        type:'post',
        data:{'command':'schedule_download', "groupList":group_list, "targetType" : target_type}
	});
}

liveInputReset = function() {
	$('input:radio[name=liveInput][value=fromDB]').iCheck('uncheck');
	$('input:radio[name=liveInput][value=directInput]').iCheck('check');	
};

selectLiveProgram = function() {
	console.log($("#selectLiveDialog tbody :checked"));
	var sel = $("#selectLiveDialog tbody :checked");
	
	if(sel.length == 0) {
		alert("방송을 선택해 주십시오.");
	} else {
		var sel_tr = sel.parent().parent();
		console.log($("input[name='channelIndex']").val());
		console.log($("input[name='programName']").val());
		$('#liveChannel').val($("input[name='channelIndex']").val());
		$('#channelName').val($("input[name='channelName']").val());
		$('#liveURL').val($("input[name='liveURL']").val());
		$('#scheduleName').val($("input[name='programName']").val());
		//selectLiveDialog.dialog("close");
		$('#selectLiveDialog').modal('hide');
	}
};

addSelectedVODs = function() {
	console.log($("#registeredVODs tbody :checked"));
	var sel = $("#registeredVODs tbody :checked");
	
	sel.each(function (index, element) {
		var id = $(element).val();
		var title = $(element).parent().next().val();
		var duration = $(element).parent().next().next().val();
		addVODtoList(id, title, duration);
	});
	
	//addVODDialog.dialog("close");
	$('#addVODDialogForm').modal('hide');
	adjustEndTime();
};

setCaption = function() {
	var selected_text = $(":radio[name=recentCaption]:checked").parent().next().text();
	$("#caption").val(selected_text);
	//recentCaptionDialog.dialog("close");
	$('#recentCaptionDialogForm').modal('hide');
};

function saveSchedule() {
	console.log($('#scheduleID'));
	var id = $('#scheduleID').val();
	var title = $('#scheduleName').val();
	var start_time = $('#datetimepicker_start').val();
	var end_time = $('#datetimepicker_end').val();
	var target_type = $('#targetType').val();
	var group_list = $("#groupTree").jstree("get_selected");
	var source_type = $('#sourceType').val();
	var vod_list = getVODListArray($('#selectedVODs tbody tr'));
	var live_ch_idx = $('#liveChannel').val(); 
	var live_stream_url = $('#liveURL').val();
	var caption = $('#caption').val();
	var captionSize = $('#captionSize').val();
	var captionSpeed = $('#captionSpeed').val();
	var captionTextColor = $('#captionTextColor').val();
	var captionBGColor = $('#captionBGColor').val();
	if($('#clearCaptionBGColor').is(":hidden"))
		captionBGColor = "";
	var color = $("input[name=schedule_color]:checked").val();
	var img_path = $('#schedule_image').attr('src');
	if(img_path != null && img_path != "")
		img_path = "/home/sedn" + img_path;
	var desc = $('#schedule_desc').val();
	
	// validation
	if(!title) {
		alert("방송명을 입력해 주세요");
		$('#scheduleName').focus();
		return;
	}
	if(!start_time) {
		alert("시작 시간을 입력해 주세요");
		$('#datetimepicker_start').focus();
		return;
	}
	if(!end_time) {
		alert("종료 시간을 입력해 주세요");
		$('#datetimepicker_end').focus();
		return;
	}
	if(start_time >= end_time) {
		alert("종료 시간은 시작시간 이후로 설정되어야 합니다.");
		$('#datetimepicker_end').focus();
		return;
	}
	if(live_ch_idx == null || live_ch_idx == '') {
		if(source_type == 'LIVE') {
			alert("방송채널을 선택해 주세요");
			return;
		} else
			live_ch_idx = '0';
	}
	
	var caption_line = caption.split('\n');
	console.log(caption_line);
	if(caption_line.length > 3) {
		alert("자막은 3줄 이내로 작성할 수 있습니다.");
		$('#caption').focus();
		return;
	}
	var max_line_char = 0;
	for(var i = 1; i < caption_line.length; i++) {
		if(max_line_char < caption_line[i].length)
			max_line_char = caption_line[i].length;
	}
	console.log(max_line_char);
	var max_line_limit = [0, 66, 45, 33];
	if(max_line_char > max_line_limit[captionSize]) {
		alert("설정된 글자 크기에서 한줄에 출력가능한 자막은 최대 " + max_line_limit[captionSize] + "자 까지입니다.");
		$('#caption').focus();
		return;
	}
	
	console.log("save");
	console.log(start_time);
	console.log(end_time);
	console.log(typeof end_time);
	if(!id) {	
		var new_id = createSchedule(title, start_time, end_time, target_type, source_type, group_list, vod_list, live_ch_idx, live_stream_url, caption, captionSize, captionSpeed, captionTextColor, captionBGColor, color, img_path, desc);
		var eventData;
		eventData = {
			//id: new_id,
			id: new_id,
			title: title,
			start: parseInt(moment(start_time).format('X'), 10),
			end: parseInt(moment(end_time).format('X'), 10),
			allDay: false,
			start_actual: moment.utc(start_time),
			end_actual: moment.utc(end_time),
			targetType: getTargetTypeStr(target_type),
			targetColor: getTargetTypeColor(target_type),
			sourceType: getSourceTypeStr(source_type),
			sourceColor: getSourceTypeColor(source_type),
			captionType: getCaptionTypeStr(caption),
			captionColor: getCaptionTypeColor(caption),
			groupList: group_list,
			vodList: vod_list,
			liveChannel: live_ch_idx,
			liveStreamURL: live_stream_url,
			caption: caption,
			captionSize: captionSize,
			captionSpeed: captionSpeed,
			captionTextColor: captionTextColor,
			captionBGColor: captionBGColor,
			scheduleColor: color,
			imgPath: img_path,
			desc: desc
		};
		//console.log("new event");
		//console.log(eventData);
		$('#calendar').fullCalendar('renderEvent', eventData);
	} else {
		updateSchedule(id, title, start_time, end_time, target_type, source_type, group_list, vod_list, live_ch_idx, live_stream_url, caption, captionSize, captionSpeed, captionTextColor, captionBGColor, color, img_path, desc);
		var e = ($('#calendar').fullCalendar('clientEvents', id))[0];
		e.title = title;
		e.start = parseInt(moment(start_time).format('X'), 10);
		e.end = parseInt(moment(end_time).format('X'), 10);
		e.allDay = false,
		e.start_actual = moment.utc(start_time);
		e.end_actual = moment.utc(end_time);
		e.targetType = getTargetTypeStr(target_type);
		e.targetColor = getTargetTypeColor(target_type);
		e.sourceType = getSourceTypeStr(source_type);
		e.sourceColor = getSourceTypeColor(source_type);
		e.captionType = getCaptionTypeStr(caption),
		e.captionColor = getCaptionTypeColor(caption),
		e.groupList = group_list,
		e.vodList = vod_list;
		e.liveChannel = live_ch_idx;
		e.liveStreamURL = live_stream_url;
		e.caption = caption;
		e.captionSize = captionSize;
		e.captionSpeed = captionSpeed;
		e.captionTextColor = captionTextColor;
		e.captionBGColor = captionBGColor;
		e.scheduleColor = color;
		e.imgPath = img_path;
		e.desc = desc;
		//$('#calendar').fullCalendar('rerenderEvents');
		$('#calendar').fullCalendar('updateEvent', e);
		//alert("기존 방송 수정" + id);
	}
	addRecentCaption(caption);
	//scheduleDialog.dialog("close");
	$('#scheduleDialogForm').modal('hide');

	//alert("새로운 장비가 추가되었습니다." + title);
}
function deleteSchedule() {
	var msg = "선택한 방송을 삭제하시겠습니까?";
	if(confirm(msg)) {
		var id = $('#scheduleID').val();
		var target_type = $('#targetType').val();
		var group_list = $("#groupTree").jstree("get_selected");
		
		var data = new Object();
		data.scheduleID = id;
		$.ajax({
	        url:'/stb/deleteSchedule.do',
	        type:'post',
	        data: data,
	        async: false,
	        success:function(result){
	        	console.log(result);
	        	$('#calendar').fullCalendar('removeEvents', id);
	        	refreshSTB(target_type, group_list);
	        },
	        error:function() {
	        	alert("스케줄 삭제에 실패했습니다.\nDB 연결상태를 확인해주세요.");
	        }
		});
		
		$('#calendar').fullCalendar('rerenderEvents');
		//scheduleDialog.dialog("close");
		$('#scheduleDialogForm').modal('hide');
	}
}
</script>
</head>
<body>

	<div class="modal fade" id="scheduleDialogForm" tabindex="-1"
		role="dialog" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="scheduleTitle">신규 방송 편성</h4>
				</div>
				<div class="modal-body">
					<form id="scheduleForm">
						<div class="row">
							<div class="col-md-2 col-sm-2">방송명</div>
							<div class="col-md-10 col-sm-10">
								<input type="text" name="scheduleName" id="scheduleName"
									class="form-control input-sm">
							</div>
						</div>
						<div class="row m-t-5 m-b-5">
							<div class="col-md-2 col-sm-2">방송 일자</div>
							<div class="col-md-1  col-sm-1 h5">
								<span class="label label-default">시작</span>
							</div>
							<div class="col-md-4 col-sm-4">
								<input id="datetimepicker_start" type="text"
									class="form-control input-sm">
							</div>
							<div class="col-md-1 h5 col-sm-1">
								<span class="label label-default">종료</span>
							</div>
							<div class="col-md-4 col-sm-4">
								<input id="datetimepicker_end" type="text"
									class="form-control input-sm">
							</div>
						</div>
						<div class="row">
							<div class="col-md-2 col-sm-2">대상</div>
							<div class="col-md-10 col-sm-10">
								<input type="hidden" name="targetType" id="targetType"
									value="ALL" class="form-control input-sm">
								<button id="targetAll" class="btn btn-sm">전체</button>
								<button id="targetGroup" class="btn btn-sm">그룹</button>
								<div class="tile m-t-5">
									<div id="groupTree"></div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-2 col-sm-2">소스</div>
							<div class="col-md-10 col-sm-10">
								<input type="hidden" name="sourceType" id="sourceType"
									value="LIVE">
								<button id="sourceLive" class="btn btn-sm">LIVE</button>
								<button id="sourceVOD" class="btn btn-sm">VOD</button>

								<div class="tile" style="height: 50px; padding: 15px 10px;"
									id="liveURLdiv">
									<div class="row m-b-5">
										<input type="radio" name="liveInput" value="fromDB" class="form-control input-sm pull-left">
										<label class="pull-left m-r-5">스케줄불러오기</label>
										<input type="radio" name="liveInput" value="directInput" checked class="form-control input-sm">
										<label class="pull-left">직접입력</label>
									</div>
									<div class="col-md-3 col-sm-3">
										<select class="select" id="liveChannel" style="width:150px;">
											<option value="">방송채널 선택</option>
											<%
												if (liveChannelList != null) {
													Map<String, Object> channelItem;
													for (int i = 0; i < liveChannelList.size(); i++) {
														channelItem = liveChannelList.get(i);
														String channelIndex = String.valueOf(channelItem.get("channelIndex"));
														String channelName = String.valueOf(channelItem.get("channelName"));
											%>
											<option value="<%=channelIndex%>"><%=channelName%></option>
											<%
												}
												}
											%>
										</select>
									</div>
									<div class="col-md-3 col-sm-3">
										<input class="form-control input-sm" id="channelName"
											type="text">
									</div>
									<div class="col-md-3 col-sm-3">
										<input class="form-control input-sm" id="liveURL" type="text">
									</div>
								</div>
								<div class="auxInput" id="listVODdiv">
									<div class="row">
										<div class="col-md-3 col-sm-3">
											<div style="float: left">
												<h5>
													<span class="label label-default">VOD 방송 목록</span>
												</h5>
												<label class="label label-default">전체 재생 시간</label>
												<label id="total_time" class="label label-default">00:00:00</label>
											</div>
										</div>
										<div class="col-md-7 col-sm-7 p-l-0 p-r-0"
											style="height: 120px; background: #fff">
											<div class="table-responsive overflow"
												style="height: 120px; overflow: hidden; outline: none;">
												<table id="selectedVODs" class="table table-bordered tile">
													<tbody></tbody>
												</table>
											</div>
										</div>
										<div class="col-md-1 col-sm-1">
											<button class="btn btn-sm" id="addVOD" style="width:58px;">추 가</button>
											<button class="btn btn-sm" id="deleteVOD" style="width:58px;">삭 제</button>
											<button class="btn btn-sm" id="moveUpVOD" style="width:58px;">U P</button>
											<button class="btn btn-sm" id="moveDownVOD" style="width:58px;">DOWN</button>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-2 col-sm-2">자막</div>
							<div class="col-md-10 col-sm-10">
								<button id="captionRecent" class="btn btn-sm">불러오기</button>
							</div>
							<div class="col-md-10 col-sm-10 col-md-offset-2  col-sm-offset-2">
								<div class="row m-t-5 m-b-5">
									<div class="col-md-2 col-sm-2 text-right p-r-0">
										<span class="label label-default">글자크기</span>
									</div>
									<div class="col-md-2 col-sm-2">
										<select class="select pull-left" id="captionSize">
											<option value="1">작게</option>
											<option value="2">보통</option>
											<option value="3">크게</option>
										</select>
									</div>
									<div class="col-md-1 col-sm-1">
										<span class="label label-default">글자색</span>
									</div>
									<div class="col-md-1 col-sm-1">
										<div style="margin-left: 5px; margin-top: 1px">
											<input id="captionTextColor" type="text"
												name="captionTextColor" value="#ffffff" />
										</div>
									</div>
									<div class="col-md-1 col-sm-1">
										<span class="label label-default">배경색</span>
									</div>
									<div class="col-md-1 col-sm-1">
										<div style="margin-left: 5px; margin-top: 1px">
											<input id="captionBGColor" type="text" name="captionBGColor"
												value="#ececec" />
										</div>
										<div id="clearCaptionBGColor"></div>
									</div>
									<div class="col-md-1 col-sm-1">
										<span class="label label-default">흐름</span>
									</div>
									<div class="col-md-2 col-sm-2">
										<select class="select" id="captionSpeed">
											<option value="1">고정</option>
											<option value="2">보통</option>
											<option value="3">빠르게</option>
											<option value="4">천천히</option>
										</select>
									</div>
								</div>
								<div class="row">
									<textarea class="form-control overflow" name="caption"
										id="caption"></textarea>
									<h6 id="captionHelp">
										자막설정은 최대 255자, 3줄까지만 가능합니다.
									</h6>
									<h6 class="text-right">
										<span id="captionLength">0</span>/255
									</h6>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-2 col-sm-2">편성 색상</div>
							<div class="col-md-10 col-sm-10">
								<input type="radio" name="schedule_color" checked value="#e90000">
								<input type="radio" name="schedule_color" value="#e96d00">
								<input type="radio" name="schedule_color" value="#e9b500">
								<input type="radio" name="schedule_color" value="#36a153">
								<input type="radio" name="schedule_color" value="#4f7abe">
								<input type="radio" name="schedule_color" value="#0d2271">
								<input type="radio" name="schedule_color" value="#6438bf">
								<input type="radio" name="schedule_color" value="#b2177d">
								<input type="radio" name="schedule_color" value="#595959">
								<input type="radio" name="schedule_color" value="#000000">
								</span>
							</div>
						</div>
						<div class="row m-t-5 m-b-5">
							<div class="col-md-2 col-sm-2">이미지 등록</div>
							<div class="col-md-10 col-sm-10">
								<img id="schedule_image"
									style="max-width: 220px; border: 1px gray solid;"
									alt="이미지를 등록해 주세요" />
								<p style="display: inline-block; margin-top: -5px">
									<input type="file" name="schedule_image_upload"
										id="schedule_image_upload" />
								</p>
							</div>
						</div>
						<div class="row">
							<div class="col-md-2 col-sm-2">내 용</div>
							<div class="col-md-10 col-sm-10">
								<textarea class="form-control overflow" name="schedule_desc"
									id="schedule_desc"></textarea>
							</div>
						</div>
						<div class="row">
							<div class="col-md-2 col-sm-2"></div>
							<div class="col-md-10 col-sm-10"></div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<div class="row text-right">
						<input type="hidden" id="scheduleID" name="scheduleID"/>
						<button type="button" class="btn btn-sm" onclick="saveSchedule();">저 장</button>
						<button type="button" class="btn btn-sm" id="btDeleteSchedule" onclick="deleteSchedule();">삭 제</button>
						<button type="button" class="btn btn-sm" data-dismiss="modal">취 소</button>
						
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="addVODDialogForm" tabindex="-1"
		role="dialog" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<!--  button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button //-->
					<h4 class="modal-title">VOD를 선택하세요.</h4>
				</div>
				<div class="modal-body">
					<div class="col-md-4" id="vodCategory">
						<p class="categoryHeader">CATEGORY</p>
						<p class="category all" style="cursor:pointer;">
							전체(<%=vodList.size()%>) <input type="hidden" name="category_id"
								value="1">
						</p>
						<%
							if (categoryList != null) {
								Map<String, Object> cateItem;
								for (int i = 0; i < categoryList.size(); i++) {
									cateItem = categoryList.get(i);
									String cateName = String.valueOf(cateItem.get("name"));
									String cateDepth = "depth" + String.valueOf(cateItem.get("depth"));
									String cateNumVOD = String.valueOf(cateItem.get("numVOD"));
									String cateID = String.valueOf(cateItem.get("id"));
						%>
						<p class="category <%=cateDepth%>" style="cursor:pointer;">
							<%=cateName%>(<%=cateNumVOD%>) <input type="hidden"
								name="category_id" value="<%=cateID%>">
						</p>
						<%
							}
							}
						%>
					</div>
					<div class="col-md-8" style="height:300px; overflow-x:hidden; overflow-y:auto;">
						<table id="registeredVODs" class="registeredVODs">
							<%
								if (vodList != null) {
									Map<String, Object> vodItem;
									for (int i = 0; i < vodList.size(); i++) {
										vodItem = vodList.get(i);
										String vodID = String.valueOf(vodItem.get("id"));
										String vodTitle = String.valueOf(vodItem.get("title"));
										String vodDuration = String.valueOf(vodItem.get("duration"));
										String vodMenu = String.valueOf(vodItem.get("menu"));
							%>
							<tr>
								<td><input type="checkbox" name="check_vod" value=<%=vodID%>>
									<input type="hidden" name="vod_title" value="<%=vodTitle%>">
									<input type="hidden" name="vod_duration"
									value="<%=vodDuration%>"> <input type="hidden"
									name="vod_menu" value="<%=vodMenu%>"></td>
								<td><%=vodTitle%></td>
								<td><%=vodDuration%></td>
							</tr>
							<%
								}
								}
							%>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<div class="row text-right">
						<button type="button" class="btn btn-sm"
							onclick="addSelectedVODs();">저 장</button>
						<button type="button" class="btn btn-sm" data-dismiss="modal">취
							소</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="selectLiveDialog" tabindex="-1"
		role="dialog" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<!--  button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button //-->
					<h4 class="modal-title">LIVE 방송을 선택하세요.</h4>
				</div>
				<div class="modal-body">
					<div class="table-responsive overflow"
						style="overflow: hidden; outline: none;">
						<table id="livePrograms" class="table table-bordered tile">
							<%
								if (liveProgramList != null) {
									Map<String, Object> programItem;
									for (int i = 0; i < liveProgramList.size(); i++) {
										programItem = liveProgramList.get(i);
										String channelIndex = String.valueOf(programItem.get("channelIndex"));
										String channelName = String.valueOf(programItem.get("channelName"));
										String programName = String.valueOf(programItem.get("programName"));
										String start = String.valueOf(programItem.get("start"));
										String end = String.valueOf(programItem.get("end"));
										String liveURL = String.valueOf(programItem.get("liveURL"));
							%>
							<tr>
								<td style="width: 25px"><input type="checkbox"
									name="check_program" value=<%=channelIndex%>></td>
								<td style="width: 250px"><%=channelName%>&nbsp;-&nbsp;<%=programName%>
								</td>
								<td><%=start%>~<%=end%> <input type="hidden"
									name="channelIndex" value="<%=channelIndex%>"> <input
									type="hidden" name="channelName" value="<%=channelName%>">
									<input type="hidden" name="programName"
									value="<%=programName%>"> <input type="hidden"
									name="liveURL" value="<%=liveURL%>"></td>
							</tr>
							<%
								}
								}
							%>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<div class="row text-right">
						<button type="button" class="btn btn-sm"
							onclick="selectLiveProgram();">저 장</button>
						<button type="button" class="btn btn-sm" data-dismiss="modal"
							onclick="liveInputReset();">취 소</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="recentCaptionDialogForm" tabindex="-1"
		role="dialog" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<!--  button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button //-->
					<h4 class="modal-title">LIVE 방송을 선택하세요.</h4>
				</div>
				<div class="modal-body">
					<%
						if (recentCaptionList != null) {
							for (int i = 0; i < recentCaptionList.size(); i++) {
								//captionItem = captionList.get(i);	
								//String captionText = String.valueOf(captionItem.get("text"));
								System.out.println("captionList");

								System.out.println(recentCaptionList.get(i));
								String caption = recentCaptionList.get(i);
					%>
					<div
						style="margin-top: 15px; margin-left: 20px; text-indent: -20px">
						<input type="radio" name="recentCaption"> <span
							class="m-l-20" style="line-height: 15px"><%=caption%></span>
					</div>
					<%
						}
						}
					%>
				</div>
				<div class="modal-footer">
					<div class="row text-right">
						<button type="button" class="btn btn-sm" onclick="setCaption();">저
							장</button>
						<button type="button" class="btn btn-sm" data-dismiss="modal">취
							소</button>
					</div>
				</div>
			</div>
		</div>
	</div>


	<ol class="breadcrumb hidden-xs">
		<li>STB 방송 관리</li>
	</ol>
	<h4 class="page-title">STB 방송 관리</h4>
	<div class="block-area">
		<div class="row m-t-5 m-b-5">
			<div class="col-md-1 pull-left">
				<button id="newSchedule" class="btn btn-sm pull-left">신규 등록</button>
			</div>
			<div class="col-md-1 pull-right m-t-5"> 
				<input type="radio" name="displayType" value="all" class="form-control input-sm">
				<label>전체</label>
			</div>
			<div class="col-md-1 pull-right m-t-5">
				<input type="radio" name="displayType" value="weekday" checked class="form-control input-sm">
				<label>평일</label>
			</div>
		</div>
	
		<div class="row col-md-12">
			<div id='calendar'></div>
		</div>
	</div>
</body>
</html>