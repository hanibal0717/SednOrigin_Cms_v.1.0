<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<%@page import="java.util.List"%>

<%
List<String> imageObjectList = (List)request.getAttribute("imageObjects");
List<String> videoList = (List)request.getAttribute("videoList");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta charset="utf-8">

<script type="text/javaScript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javaScript" src="/js/jquery-ui-1.12.1/jquery-ui.min.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-ui-1.12.1/jquery-ui.min.css"/>

<script>
const ID_PREFIX = "overlay";
const MAX_SLIDER_VALUE = 100000;
 
var latest_id = 0;		// ID부여를 위해 오버레이 영역에 추가될 때마다 증가
var overlay_item = [];	// 오베레이 객체 목록. 추후 성능을 위해 hashmap등으로 수정 필요 

var fileOpenDialog;
var fileSaveDialog;
var savingAnim;

$(document).ready(function() {
	var video = document.querySelector("#video");

	//video.src="C:\\Users\\Jskim\\Documents\\DevWorks\\Inucreative\\OverlayEditor\\output.mp4";
	
	video.addEventListener("timeupdate", function(){
		var cut_end = $("#video-cut-control").slider("values")[1];
		if(cut_end < toScreenTime(video.currentTime))
			video.pause();
		else {
			$("#current-time").text(toTimeStr(video.currentTime));
			$("#video-play-control").slider("value", toScreenTime(video.currentTime));
			updateOverlay();
		}
	});
	
	video.addEventListener("canplay", function() {
		video.currentTime = 0;
		$("#cut-end").text(toTimeStr(video.duration));
		$("#duration").text(toTimeStr(video.duration));
	});
	
	video.addEventListener("error", function() {
		alert("영상을 로드할 수 없습니다.");
	});
	
	// 이미지를 video 영역으로 끌어오기 위한 draggable 설정
	$(".image-object").draggable({
		helper: 'clone',
		opacity: 0.40,
		// drag 이벤트
		drag: function(event, ui) {
			// 이미지가 video 영역 내부인지 테스트
			if(isInside($("#video"), ui.helper)) {
				ui.helper.css("opacity", 1);
			} else {
				ui.helper.css("opacity", 0.40);
			}
		},
		// drop 이벤트
		stop: function(event, ui) {
			if(isInside($("#video"), ui.helper)) {
				// 새로운 이미지 오브젝트 추가
				var container = $("#video-container");
				var newID = createNewOverlay("image", ui.position.left - container.offset().left, ui.position.top - container.offset().top, ui.helper.width(), ui.helper.height(), ui.helper.attr("src"));
				
				var image_html = "<div id='" + newID + "-wrapper'" + " class='overlay-container image-wrapper'>"
							+ "<img id='" + newID + "' src='" + ui.helper.attr("src") + "'></div>";
				container.append(image_html);
				
				var new_object = $("#"+newID);
				new_object.width(ui.helper.width());
				new_object.resizable({
					handles: "all",
					classes: {
						"ui-resizable-n": "ui-icon ui-icon-stop",
						"ui-resizable-e": "ui-icon ui-icon-stop",
						"ui-resizable-w": "ui-icon ui-icon-stop",
						"ui-resizable-s": "ui-icon ui-icon-stop",
						"ui-resizable-se": "ui-icon ui-icon-stop",
						"ui-resizable-sw": "ui-icon ui-icon-stop",
						"ui-resizable-ne": "ui-icon ui-icon-stop",
						"ui-resizable-nw": "ui-icon ui-icon-stop",
					},
					create: function(event, ui) {
						$(this).hover(
								function() {
									$(this).find(".ui-resizable-handle").show();
								}, function() {
									$(this).find(".ui-resizable-handle").hide();
							});
						alignHandle($(this));
					},
					resize: function(event, ui) {
						alignHandle($(this));
					},
					stop: function(event, ui) {
						// 크기조절 종료시 데이터 업데이트
						var item = getOverlayItemByID(getOverlayID($(this).find("img")));
						item.width = ui.size.width;
						item.height = ui.size.height;
					}
				});
				new_object.parent().draggable({
					containment: $("#video-container"),
					create: function(event, ui) {
						$(this).hover(
							function() {
								$(this).addClass("hovered");									
							}, function() {
								$(this).removeClass("hovered");
						});
						$(this).addClass("hovered");
					},
					stop: function(event, ui) {
						// 위치 이동 종료시 데이터 업데이트
						var item = getOverlayItemByID(getOverlayID($(this).find("img")));
						item.left = ui.position.left;
						item.top = ui.position.top;
					}
				});
				new_object.parent().offset({left:ui.position.left, top:ui.position.top});
				
				
				// 편집 영역 추가
				var edit_html = "" +
					"<div id='" + newID + "-editbox'" + " class='overlay-editbox'>" +
						"<div class='left-col'>" +
							"<img class='item-image' src='" + ui.helper.attr("src") + "'>" +
						"</div>" +
						"<div class='center-col' id='" + newID + "-showtime'></div>" +
						"<div class='right-col edit-button-container'>" +
							"<button id='" + newID + "-up' type='button'><span class='ui-icon ui-icon-arrowthick-1-n'></span></button>" +
							"<button id='" + newID + "-down' type='button'><span class='ui-icon ui-icon-arrowthick-1-s'></span></button>" +
							"<button id='" + newID + "-del' type='button'><span class='ui-icon ui-icon-close'></span></button>" +
						"</div>" +
					"</div>";
				$("#edit-item-container").append(edit_html);
				$("#" + newID + "-showtime").slider({
					classes: {
						"ui-slider": "edit-item-slider",
						"ui-slider-range": "edit-item-slider-range",
						"ui-slider-handle": "edit-item-slider-handle"
					},
					range:true,
					min: 0,
					max: MAX_SLIDER_VALUE,
					values: [0, MAX_SLIDER_VALUE],
					slide: function(event, ui) {
						// 개체 디스플레이 시간 변경시 실시간 화면 업데이트
						updateOverlay();
					},
					stop: function(event, ui) {
						// 개체 디스플레이 시간 변경시 데이터 업데이트
						var item = getOverlayItemByID(getOverlayID($(this)));
						if(ui.handleIndex == 0)
							item.start = toVideoTime(ui.value);
						else
							item.end = toVideoTime(ui.value);

					}
				});
				// up, down, 삭제 버튼 처리
				$("#" + newID + "-up").click(function() {
					var id = getOverlayID($(this));
					var index = getOverlayItemIndex(id);
					if(index > 0) {
						var thisObject = $("#" + id + "-wrapper");
						var upObject = thisObject.prev();
						if(upObject != {}) upObject.before(thisObject);
						
						var thisEditBox = $("#" + id + "-editbox");
						var upEditBox = thisEditBox.prev();
						if(upEditBox != {}) upEditBox.before(thisEditBox);
						
						moveUpOverlayItem(id);
					}
				});
				$("#" + newID + "-down").click(function() {
					var id = getOverlayID($(this));
					var index = getOverlayItemIndex(id);
					if(index < overlay_item.length - 1) {
						var thisObject = $("#" + id + "-wrapper");
						var downObject = thisObject.next();
						if(downObject != {}) downObject.after(thisObject);
						
						var thisEditBox = $("#" + id + "-editbox");
						var downEditBox = thisEditBox.next();
						if(downEditBox != {}) downEditBox.after(thisEditBox);
						
						moveDownOverlayItem(id);
					}
				});
				$("#" + newID + "-del").click(function() {
					var id = getOverlayID($(this));
					$("#" + id + "-wrapper").remove();
					$("#" + id + "-editbox").remove();
					removeOverlayItem(id);
				});
			}
		}
	});
	
	$("#play-video").click(function() {
		var cut_range = $("#video-cut-control").slider("values");
		if(cut_range[1] < toScreenTime(video.currentTime))
			video.currentTime = toVideoTime(cut_range[0]);

		video.play();		
	});
	$("#pause-video").click(function() {
		video.pause();		
	});
	
	$("#video-cut-control").slider({
		classes: {
			"ui-slider-handle": "cut-slider-handle"
		},
		range: true,
		min: 0,
		max: MAX_SLIDER_VALUE,
		values: [0, MAX_SLIDER_VALUE],
		slide: function(event, ui) {
			var start = ui.values[0];
			var end = ui.values[1];
			var current = toScreenTime(video.currentTime);
			
			$("#cut-start").text(toTimeStr(toVideoTime(start)));
			$("#cut-end").text(toTimeStr(toVideoTime(end)));
			
			if(start > current)
				video.currentTime = toVideoTime(start);
			if(end < current)
				video.currentTime = toVideoTime(end);
			
			$("#left-dimming").width(start / MAX_SLIDER_VALUE * 500);
			$("#right-dimming").width((MAX_SLIDER_VALUE - end) / MAX_SLIDER_VALUE * 500);
			$("#right-dimming").offset({left: 800 - ((MAX_SLIDER_VALUE - end) / MAX_SLIDER_VALUE * 500)});
			
		},
		create: function(event, ui) {
			// slider 좌우 handle 위치 개별 조정
			var left_handle = $(this).find(".ui-slider-handle:first-of-type");
			var right_handle = $(this).find(".ui-slider-handle:last-of-type");
			left_handle.addClass("cut-slider-handle-left");
			right_handle.addClass("cut-slider-handle-right");
		}
	});
	$("#video-play-control").slider({
		classes: {
			"ui-slider-handle": "play-slider-handle"
		},
		min: 0,
		max: MAX_SLIDER_VALUE,
		slide: function(event, ui) {
			//console.log("adjust video time");
			var cut_range = $("#video-cut-control").slider("values");
			if(ui.value >= cut_range[0] && ui.value <= cut_range[1])
				video.currentTime = toVideoTime(ui.value);
			else {
				// 스크롤 막음
				if(ui.value < cut_range[0])
					$("#video-play-control").slider("value", cut_range[0]);
				else
					$("#video-play-control").slider("value", cut_range[1]);
				return false;
			}
		}
	});
	
	$("#left-dimming").offset({left:300});
	$("#right-dimming").offset({left:800});
	
	// 파일 오픈 핸들러
	fileOpenDialog = $("#fileOpenDialogForm").dialog({
		autoOpen: false,
		width: 400,
		height: 420,
		resizable: false,
		modal: true,
		buttons: {
			"1": {text: '열기', click: loadVideo, "class": "" },
			"2": {text: '취소', click: function() {fileOpenDialog.dialog("close");}, "class": ""}
		}
	});
	$("#openFile").click(function() {
		if($("#video").attr("src") != null) {
			if(confirm("새로운 파일을 불러오시겠습니까?\n편집하던 내용은 초기화됩니다.")) {
				// 오버레이 객제 초기화
				overlay_item = [];
				$(".overlay-container").remove();
				$(".overlay-editbox").remove();
			} else
				return;
		}
		
		$("#fileOpenDialogForm tr").removeClass("selected");
		fileOpenDialog.dialog("open");
	});
	$("#fileOpenDialogForm tr").click(function() {
		$("#fileOpenDialogForm tr").removeClass("selected");
		$(this).addClass("selected");
	});
	
	// 파일 저장 핸들러
	fileSaveDialog = $("#fileSaveDialogForm").dialog({
		autoOpen: false,
		width: 600,
		height: 180,
		resizable: false,
		modal: true,
		buttons: {
			"1": {text: '저장', click: saveVideo, "class": "" },
			"2": {text: '취소', click: function() {fileSaveDialog.dialog("close");}, "class": ""}
		}
	});
	$("#saveToFile").click(function() {
		var fileName = $("video").attr("src");
		var dotIndex = fileName.lastIndexOf(".");
		if(dotIndex != -1) {
			fileName = fileName.substr(0, dotIndex) + "_overlay" + fileName.substr(dotIndex);
		}
		$("#saveFileName").val(fileName);
		fileSaveDialog.dialog("open");
	});
	
	// saving 애니메이션
	savingAnim = $("#savingAnimForm").dialog({
		width: 300,
		height: 140,
		dialogClass: "savingAnim",
		autoOpen: false,
		resizable: false,
		modal: true
	});
});
//---------- 파일 open / save ----------------------
function loadVideo() {
	var selectedVideo = $("#fileOpenDialogForm tr.selected td.fullPath").text();
	
	if(selectedVideo != "") {
		video.pause();
		video.src = selectedVideo;
		video.load();
		fileOpenDialog.dialog("close");
	} else {
		alert("영상을 선택해 주세요.");
	}
}
function saveVideo() {
	var source_file = $("#video").attr("src");;
	var target_file = $("#saveFileName").val();
	
	var cut_range = $("#video-cut-control").slider("values");
	var cut_start = toVideoTime(cut_range[0]);
	var cut_end = toVideoTime(cut_range[1]);
	
	var num_item = $("#video-container").children().length;
	num_item--; // video 객체
	
	savingAnim.dialog("open");
	$(".ui-widget-overlay").addClass("savingAnim");
	
	$.ajax({
        url:'/overlayEditor/saveToFile.do',
        type:'post',
        data: {'source': source_file,
        		'target': target_file,
        		'ratio' : video.videoWidth / $("video").width(), 
        		'cut_start': cut_start,
        		'cut_end': cut_end,
        		'num_item': num_item,
        		'overlay_item': overlay_item},
        success:function(result){
        	savingAnim.dialog("close");
        	$(".ui-widget-overlay").removeClass("savingAnim");
        	fileSaveDialog.dialog("close");
        	alert(target_file + "로 저장되었습니다.");
        },
        error:function() {
        	savingAnim.dialog("close");
        	$(".ui-widget-overlay").removeClass("savingAnim");
        	alert("파일 저장에 실패했습니다.");
        }
	});
}


//---------- overlay_item 전역변수 관리 함수 --------------
// 추후 성능을 위해 hashmap 등으로 수정 필요
function getOverlayItemIndex(itemID) {
	for(var i = 0; i < overlay_item.length; i++) {
		if(overlay_item[i].id == itemID)
			return i;
	}
	return -1;
}
function getOverlayItemByID(itemID) {
	for(var i = 0; i < overlay_item.length; i++) {
		if(overlay_item[i].id == itemID)
			return overlay_item[i];
	}
	return null;
}
function removeOverlayItem(itemID) {
	for(var i = 0; i < overlay_item.length; i++) {
		if(overlay_item[i].id == itemID)
			overlay_item.splice(i, 1);
	}
}
function moveUpOverlayItem(itemID) {
	for(var i = 1; i < overlay_item.length; i++) {
		if(overlay_item[i].id == itemID) {
			var tmp = overlay_item[i];
			overlay_item[i] = overlay_item[i-1];
			overlay_item[i-1] = tmp;
			break;
		}
	}
}
function moveDownOverlayItem(itemID) {
	for(var i = 0; i < overlay_item.length - 1; i++) {
		if(overlay_item[i].id == itemID) {
			var tmp = overlay_item[i];
			overlay_item[i] = overlay_item[i+1];
			overlay_item[i+1] = tmp;
			break;
		}
	}
}


//-------------- 유틸리티 함수 -------------------
function toTimeStr(sec_num) {
	sec_num = Math.ceil(sec_num);
    var hours   = Math.floor(sec_num / 3600);
    var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
    var seconds = sec_num - (hours * 3600) - (minutes * 60);

    if (hours   < 10) {hours   = "0"+hours;}
    if (minutes < 10) {minutes = "0"+minutes;}
    if (seconds < 10) {seconds = "0"+seconds;}
    return hours+':'+minutes+':'+seconds;
}
function toScreenTime(time) {
	return MAX_SLIDER_VALUE / video.duration * time;
}

function toVideoTime(time) {
	return video.duration / MAX_SLIDER_VALUE * time;
}
//화면상의 각 컨트롤 ID에서 오버레이 객체 자체 ID를 추출 (ex: 'overlay1-showtime' 에서 'overlay1' 추출)
function getOverlayID(item) {
	return item.attr("id").split("-")[0];
}


//----------------- 화면 오버레이 객체 관련 함수 -----------------
// resize 상하좌우 4개 핸들 중앙 정렬
function alignHandle(image_object) {
	image_object.find(".ui-resizable-n").css("left", image_object.width() / 2 - 8);
	image_object.find(".ui-resizable-s").css("left", image_object.width() / 2 - 8);
	image_object.find(".ui-resizable-e").css("top", image_object.height() / 2 - 8);
	image_object.find(".ui-resizable-w").css("top", image_object.height() / 2 - 8);
}
//object가 container 영역 내에 있는지 검사
function isInside(container, object) {
	var result = false;
	
	var video_left = container.offset().left;
	var video_top = container.offset().top;
	var video_width = container.width();
	var video_height = container.height();
	var image_left = object.offset().left;
	var image_top = object.offset().top;
	var image_width = object.width();
	var image_height = object.height();
	
	//console.log(image_width + ", " + image_height);
	//console.log(video_width + ", " + video_height);
	
	if(image_left >= video_left && (image_left + image_width) <= (video_left + video_width) &&
			image_top >= video_top && (image_top + image_height) <= (video_top + video_height)) {
		result = true;
	}
	
	return result;
}
// 현재 비디오 시간에 따라 오버레이 객체 표시
function updateOverlay() {
	var curtime = toScreenTime(video.currentTime);

	$("#edit-item-container").children().each(function(index) {
		var itemID = getOverlayID($(this));
		//console.log(item_id);
		
		var showtime = $("#" + itemID + "-showtime").slider("values");
		if(curtime >= showtime[0] && curtime <= showtime[1])
			$("#" + itemID + "-wrapper").show();
		else
			$("#" + itemID + "-wrapper").hide();
	});
}
function createNewOverlay(type, left, top, width, height, param1) {
	latest_id++;
	
	var item = new Object();
	
	item.id = ID_PREFIX + latest_id;
	item.type = type;
	if(type == "image") {
		item.src = param1;
	}
	
	item.left = left;
	item.top = top;
	item.width = width;
	item.height = height;
	
	item.start = 0;
	item.end = video.duration;
	
	item.filter = [];
	
	overlay_item.push(item);
	
	return item.id;
}


</script>

<style>
.ui-icon
{
	background-image: url("/js/jquery-ui-1.12.1/images/ui-icons_ffffff_256x240.png");
}

.ui-resizable-se {
	right: -5px;
	bottom: -5px;
}

.edit-item-slider {
	height: 5px !important;
	margin-top: 12px;
	background: #696969 !important;
	border: none !important;
}
.edit-item-slider-range {
	height: 15px !important;
	margin-top: -5px;
	background: #333333 !important;
}
.edit-item-slider-handle {
	width: 5px !important;
	height: 8px !important;
	margin-left: -4px !important;
	margin-top: 2px;
	cursor: pointer !important;
}

.cut-slider-handle-left {
	margin-left: -11px !important;
	background: none !important;
	cursor: pointer !important;
	width: 0px !important;
	height: 0px !important;
	border-top: none !important;
	border-right: none !important;
	border-bottom: 22px solid black !important;
	border-left: 10px solid transparent !important;
}

.cut-slider-handle-right {
	margin-left: 2px !important;
	background: none !important;
	cursor: pointer !important;
	width: 0px !important;
	height: 0px !important;
	border-top: none !important;
	border-left: none !important;
	border-bottom: 22px solid black !important;
	border-right: 10px solid transparent !important;
}

.play-slider-handle {
	width: 0 !important;
	height: 0 !important;
	border-left: 5px solid transparent !important;
	border-right: 5px solid transparent !important;
	border-top: 25px solid gray !important;
	border-bottom: none !important;
	background: none !important;
	cursor: pointer !important;
	margin-left: -5px !important;
}

.container-all {
	height: 720px;
}

.container-left, .container-main, .container-right {
	float: left;
	height: 100%;
	background: rgb(75, 75, 75);
	border: 1px solid rgb(33, 33, 33);
}
.container-left {
	width: 200px;
}
.container-main {
	width: 720px;
}
.container-right {
	width: 350px;
}

.image-object-container {
	max-height: 200px;
	overflow: auto;
}

span {
	color: white;
}

button {
	line-height: 20px;
	color: white;
	background: rgb(90, 90, 90);
	border: 1px solid rgb(57, 57, 57);
}
button:hover {
	background: rgb(75, 75, 75);
}
button:active {
	background: rgb(57, 57, 57);
}

.edit-button-container button {
	margin-top: 3px;
	margin-bottom: 3px;
	margin-left: 1px;
	margin-right: 1px;
}

.title, .content {
	border-bottom: 1px solid rgb(33, 33, 33);	
}

.title {
	line-height: 25px;
	padding-left: 10px;
	font-size: 12px;
	background: rgb(57, 57, 57);
}

.content {
	
}

.video-container {
	width: 100%;
	border-bottom: 1px solid rgb(57, 57, 57);
	position: relative;
}

.video-container img {
	position: absolute;
}

#video {
	width: 100%;
}

.image-wrapper {
}

.video-container .ui-wrapper.ui-draggable.hovered {
	-ms-transform: translate(-1px, -1px);
	transform: translate(-1px, -1px);
	border: 1px dashed white;
}

#video-play-control {
}

#video-cut-control {
}

.control-container {
	width: 100%;
	height: 25px;
	padding-top:10px;
	border-bottom: 1px solid rgb(57, 57, 57);
}

.added-item-container {
	background: rgb(110, 110, 110);
}

.left-col, .center-col, .right-col {
	float: left;
}

.left-col {
	margin-left: 10px;
	width: 11%;
}

.center-col {
	width: 69%;
}

.right-col {
	width: 16%;
	margin-left: 15px;
	font-size: 12px;
}

.item-image {
	height: 30px;
	margin: auto;
	display: block;
}

.image-object {
	width: 64px;
	height: 64px;
}

.overlay-editbox {
	clear: both;
	height: 30px;
	margin-top: 10px;
}

.edit-control-container {
	width: 100%;
	position: relative;
}

.edit-item-container {
	height: 239px;
	overflow: auto;
	background: #aaaaaa;
}

.cut-dimming-area {
	position: absolute;
	height: 314px;
	top: 0px;
	background: black;
	opacity: 0.5;
}

.edit-area-divider {
	position: absolute;
	width: 2px;
	height: 314px;
	top: 0px;
	background: #353535;
}
.edit-area-divider.left {
	left: 88px;
}
.edit-area-divider.right {
	left: 588px;
}

.file-menu span {
	font-size: 13px;
	padding: 5px;
	cursor: pointer;
	line-height: 22px;
	color: white;
	background: rgb(90, 90, 90);
	border: 1px solid rgb(57, 57, 57);
}

.file-menu span:hover {
	background: rgb(75, 75, 75);
}
.file-menu span:active {
	background: rgb(57, 57, 57);
}

.file-menu input[type='file'] {
	display: none;
}

.ui-dialog-titlebar span {
	color: gray;
}

#fileOpenDialogForm td {
	padding: 3px;
}
#fileOpenDialogForm tr:hover {
	background: rgb(190,190,190);
}
#fileOpenDialogForm tr.selected {
	background: #707070; 
}

#fileSaveDialogForm input {
	width: 100%;
	margin-top: 10px;
	font-size: 14px;
}

#savingAnimForm {
	padding-top: 30px;
	text-align:center;
}
.savingAnim .ui-dialog-titlebar {
	display: none;
}
.savingAnim.ui-widget-overlay {
   opacity: .50;
}

</style>
</head>
<body>
	<div id="fileOpenDialogForm" title = "편집할 영상을 선택하세요">
		<table>
		<%
			for(int i = 0; i < videoList.size(); i++) {
				String fullPath = videoList.get(i);
				String[] splitPath = fullPath.split("/|\\\\");
				String fileName = splitPath[splitPath.length-1];
		%>
			<tr>
				<td><%=fileName%></td>
				<td class="fullPath" style="display: none"><%=fullPath%></td>
			</tr>
		<%
			}
		%>
		</table>
	</div>

	<div id="fileSaveDialogForm" title = "저장할 파일명을 입력하세요">
		<input id="saveFileName" type="text">
	</div>
	
	<div id="savingAnimForm">
		<img src='http://i.stack.imgur.com/FhHRx.gif'>
		<p>Saving....</p>
	</div>
	
	<div class="container-all">
		<div class="container-left">
			<div class="title">
				<span>파일</span>
			</div>
			<div class="content file-menu" style="height:40px; padding-top: 14px; padding-left: 20px;">
				<span id="openFile">불러오기</span>
				<span id="saveToFile">저장하기</span>
			</div>
			<div class="title">
				<span>효과</span>
			</div>
		</div>
		<div class="container-main">
			<div class="video-container" id="video-container">
				<video id="video">
				</video>
			</div>
			<div class="edit-control-container">
				<div class="control-container">
					<div class="left-col">
						<span>Cut</span>
					</div>
					<div class="center-col" id="video-cut-control"></div>
					<div class="right-col">
						<span id="cut-start">00:00:00</span>
						<span> ~ </span>
						<span id="cut-end">00:00:00</span>
					</div>
				</div>
				<div class="control-container">
					<div class="left-col">
						<button id="play-video" type="button"><span class="ui-icon ui-icon-play"></span></button>
						<button id="pause-video" type="button"><span class="ui-icon ui-icon-pause"></span></button>
					</div>
					<div class="center-col" id="video-play-control"></div>
					<div class="right-col">
						<span id="current-time">00:00:00</span>
						<span> / </span>
						<span id="duration">00:00:00</span>
					</div>
				</div>
				<div class="edit-item-container" id="edit-item-container">
				</div>
				<div class="edit-area-divider left"></div>
				<div class="edit-area-divider right"></div>
				<div class="cut-dimming-area" id="left-dimming"></div>
				<div class="cut-dimming-area" id="right-dimming"></div>
			</div>
		</div>
		<div class="container-right">
			<div class="title">
				<span>이미지</span>
			</div>
			<div class="image-object-container" id="image-object-container">
			<% for(String image : imageObjectList) { %>
				<div style="padding: 8px; display:inline;">
					<img class="image-object" src="<%=image%>">
				</div>
			<% } %>
			</div>
			<div class="title">
				<span>텍스트</span>
			</div>
			
		</div>
	</div>
</body>
</html>