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
<%@page import="vcms.common.util.StringUtil" %>

<%
List<Map<String , Object>> group = (List)request.getAttribute("group");
%>
<head>
<meta name="decorator" content="defaultPage">
<script type="text/javascript" src="<c:url value='/js/jquery/js.cookie.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/fullcalendar/lib/moment.min.js'/>"></script>
<link type="text/css" rel="stylesheet" href="<c:url value='/js/jstree/dist/themes/default/style.min.css'/>">
<script type="text/javascript" src="<c:url value='/js/jstree/dist/jstree.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/paginationjs/dist/pagination.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jqueryrotate.js'/>"></script>
<style>
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
.jstree-rename-input{color:red;}
.jstree-default .jstree-clicked {background: #250811;}
.jstree-default .jstree-hovered{color:red;}
</style>
<script>
var numSTBs = 0;
var searchWord = "";
var intervalID = undefined;
var curPageNum = 1;

$(document).ready(function() {
	// 그룹 트리 초기화
	$('#groupTreeHide').click(function(){hideTree(0, true)});
	$('#groupTreeShow').click(function(){showTree(0, true)});
	
	$('#createGroup').click(function(){createGroup()});
	$('#renameGroup').click(function(){renameGroup()});
	$('#deleteGroup').click(function(){deleteGroup()});
	
	$('#jstree').jstree({
		"core" : {
			"data" : [
			    <%
			    	if(group != null) {
			    		Cookie[] cookies = request.getCookies();
			    		String selected_node_id = "1";
			    		if(cookies!=null){
			    			for(int i=0; i<cookies.length; i++){
			    				if(cookies[i].getName().equals("selected_node")){
			    					selected_node_id = cookies[i].getValue();
				    			}
			    			}
		    			}

			    		Map<String, Object> GroupNode;
			    		
			    		for(int i=0; i<group.size(); i++) {
							GroupNode = group.get(i);	
							String groupID = String.valueOf(GroupNode.get("groupID"));
							String parentID = String.valueOf(GroupNode.get("parentID"));
							String position = String.valueOf(GroupNode.get("position"));
							String groupName = String.valueOf(GroupNode.get("groupName"));
							String numSTB = String.valueOf(GroupNode.get("numSTB"));
							if(parentID.equals("0")) parentID = "#";
				%>
				{"id" : "<%=groupID%>", "parent" : "<%=parentID%>", "text" : "<%=groupName+'('+numSTB+')'%>",
				 "name" : "<%=groupName%>", "numSTB" : "<%=numSTB%>",
				 "state" : {"opened" : true <% if(groupID.equals(selected_node_id)) {%>, "selected" : true<%}%> } },
				<%
			    		}
			    	}
				%>
			],
			"check_callback" : true,
			"themes" : { "dots" : true },
			"animation" : 150
		},
		"plugins" : [ "dnd" ]
	});
	$('#jstree').on("select_node.jstree", function (e, data) {
	      //console.log(data.selected[0]);
	      Cookies.set('selected_node', data.selected[0]);
	      //Cookies.set('group_id', data.selected[0]);
	      reloadTable();
	});
	$('#jstree').on("move_node.jstree", function (e, data) {
	      console.log(data);
	      $.ajax({
	            url:'/stb/moveGroup.do',
	            type:'post',
	            data:{"groupID": data.node.id, "old_parent": data.old_parent, "old_position": data.old_position, "parent": data.parent, "position": data.position},
	            success:function(result){
	            	//console.log(result);
	    			//console.log(data.node);
	            },
	            error:function() {
	            	alert("그룹 이동에 실패했습니다.\nDB 연결상태를 확인해주세요.");
	            }
			});
	});
	$('#jstree').on("rename_node.jstree", function (e, data) {
		console.log("rename");
		//console.log($('#jstree').jstree(true));
		//console.log(e);
	    	//console.log(data);
		if(data.old != data.text || data.old == "새 그룹") {
			$.ajax({
	            url:'/stb/renameGroup.do',
	            type:'post',
	            data:{"groupID": data.node.id, "name": data.text},
	            async:false,
	            success:function(result){
	            		//console.log("result : " + result);
	    			//console.log(data.node);
	    			data.node.original.name = data.text;
	    			new_name = data.text;
	            },
	            error:function() {
	            	alert("그룹 이름 변경에 실패했습니다.\nDB 연결상태를 확인해주세요.");
	            }
			});
			//console.log("redraw");
			data.node.text = data.node.original.name + '(' + data.node.original.numSTB + ')';
			//console.log(data.node);
			$('#jstree').jstree(true).redraw(true);
		}
	});
	//$('#jstree').on("create_node.jstree", function (e, data) {
	//	console.log("create callback : ");
	//	console.log(data);
	//});
	
	// refresh 버튼
	$('#refreshList').click(function() {
		if(intervalID != undefined) {
			clearInterval(intervalID);
			intervalID = undefined;
			$('#refreshList > i').removeClass('fa-spin');
		}
		else {
			intervalID = setInterval(function() {getSTBList(curPageNum, false);}, 2000);
			$('#refreshList > i').addClass('fa-spin');
		}
	});
	
	// 검색바 관련 초기화
	$("#pageUnit").change(function() {
		Cookies.set('pageUnit', $("#pageUnit").val());
		getSTBList(1, true);
	});	
	
	$("#searchButton").click(function(){
		doSearch();
	});
	$("#searchWord").keypress(function(e) {
		if(e.keyCode == 13) {
			e.preventDefault();
			doSearch();
		}
	});
	function doSearch() {
		var input = $("#searchWord").val();
		
		searchWord = input;
		getSTBList(1, true);		
	}
	// -------- table 관련 초기화
	// 전체 선택
	setTimeout(function() {
		//functions.js 가 늦게 실행되면서 이벤트 바인딩을 초기화 시켜서 일단 이렇게 수정해 놓음.
		$('#stbTable thead ins').click(function () {
			var is_checked = $('#stbTable thead :checkbox').is(":checked");
			if(is_checked) {
				$("#stbTable tbody :checkbox").iCheck('check');
			}
			else {
				$("#stbTable tbody :checkbox").iCheck('uncheck');
			}
			console.log("all checked");
		});
	}, 1000);
		
	// 검색박스 안내 가이드 문구
	$("#searchWord").on("focus", function() {
		//console.log("focused");
		//$(this).val("");
		$("#searchHelp").hide();
	})
	.on("blur", function() {
		if($(this).val()=="") $("#searchHelp").show();;
	});
	$("#searchHelp").click(function () {
		$("#searchWord").focus();	
	});
	
	// 이전 상태 복원
	if(Cookies.get('groupShown') == null) {
		Cookies.set('groupShown', "N");
	}
	//$("#groupShown").val(Cookies.get('groupShown'));
	
	if(Cookies.get('pageUnit') == null) {
		Cookies.set('pageUnit', 10);
	}
	$("#pageUnit").val(Cookies.get('pageUnit'));
	
	if(Cookies.get('selected_node') == null) {
		Cookies.set('selected_node', 1);	// default to ROOT
	}
	//$("#group_id").val(Cookies.get('group_id'));
	
	if(Cookies.get('groupShown') == "Y") {
		showTree(0, false);
	} else {
		hideTree(0, false);
	}

	// 장비등록 팝업
	/*
	var registerSTBDialog;
	registerSTBDialog = $("#registerSTBDialogForm").dialog({
		autoOpen: false,
		width: 400,
		height: 420,
		resizable: false,
		modal: true,

		buttons: {
			"1": {text: '저장', click: saveSTB, "class": "sednButton positive" },
			"2": {text: '취소', click: function() {registerSTBDialog.dialog("close");}, "class": "sednButton negative"}
		}
	});
	*/
	
	$('#btSaveSTB').click(function() {
		console.log($('#stbID').val());
		var stbID = $('#stbID').val();
		var stbName = $('#stbName').val();
		var stbGroup = $('#stbGroup').val();
		var stbMAC = $('#stbMAC').val();
		var stbIP = $('#stbIP').val();
		
		console.log("stbName : " + stbName);
		
		if(!stbName) {
			alert("장비명을 입력해 주세요");
			$('#stbName').focus();
			return;
		}
		
		if(!stbMAC) {
			alert("MAC 주소를 입력해 주세요");
			$('#stbMAC').focus();
			return;
		}

		var regexMAC = /^([0-9A-F]{2}[:]){5}([0-9A-F]{2})$/;
		if(!regexMAC.test(stbMAC)) {
			alert("올바른 MAC 주소를 입력해 주세요\n예) 12:34:56:AB:CD:EF (대문자 주의)");
			$('#stbMAC').focus();
			return;
		}

		if(!stbIP) {
			alert("IP 주소를 입력해 주세요");
			$('#stbIP').focus();
			return;
		}

		var regexIP = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
		if(!regexIP.test(stbIP)) {
			alert("올바른 IP 주소를 입력해 주세요");
			$('#stbIP').focus();
			return;
		}
		
		if(!stbID) {
			$('#lastOnTime').val(moment().format("YYYY/MM/DD HH:mm:ss"));
			$.ajax({
		        url:'/stb/registerSTB.do',
		        type:'post',
		        //data:{"parentID": data.parent, "name" : data.node.text},
		        data:$('#STBForm').serialize(),
		        success:function(result){
		        	console.log(result);        		
		        	$('#registerSTBDialogForm').modal('hide');
		    		alert("새로운 장비를 등록하였습니다.");
		    		Cookies.set('selected_node', stbGroup);
		    		$("#frm").submit();	// group tree 리스트 갱신
		        },
		        error:function() {
		        	alert("장비 등록에 실패했습니다.\nDB 연결상태를 확인해주세요.");
		        	reloadTable();
		        }
			});
		} else {
			$.ajax({
		        url:'/stb/modifySTB.do',
		        type:'post',
		        //data:{"parentID": data.parent, "name" : data.node.text},
		        data:$('#STBForm').serialize(),
		        success:function(result){
		        	console.log(result);        		
		        	$('#registerSTBDialogForm').modal('hide');
		    		Cookies.set('selected_node', stbGroup);
		    		$("#frm").submit();	// group tree 리스트 갱신
		        },
		        error:function() {
		        	alert("정보 수정에 실패했습니다.\nDB 연결상태를 확인해주세요.");
		        	reloadTable();
		        }
			});
		}
	});
	
	$("#registerSTB").click(function(){
		resetDialog();
		// 그룹이 선택되어 있다면 초기화
		if(Cookies.get('groupShown') == 'Y') {
			$('#stbGroup').selectpicker('val', Cookies.get('selected_node'));
		}
		$('#registerSTBFormTitle').html('셋탑 박스 등록');
		$("#registerSTBDialogForm").modal('show');
		//registerSTBDialog.dialog("option", "title", "셋탑박스 등록");
		//registerSTBDialog.dialog("open");
	});

	$("#modifySTB").click(function(){
		var first_selected = $("#stbTable tbody tr").filter(function(i) {return $(this).find("td:first input[name='check_stb']").is(":checked");})
													.first();
		if(first_selected.length == 1) {
			//registerSTBDialog.dialog("option", "title", "셋탑박스 수정");
			$('#registerSTBFormTitle').html('셋탑 박스 수정');
			$("#registerSTBDialogForm").modal('show');
			populateData(first_selected);
			//registerSTBDialog.dialog("open");
			
		} else {
			alert("수정할 장비를 선택하세요.");
		}
	});
	
	$("#deleteSTB").click(function(){
		var stb_list = [];
		// 선택된 장비들의 ID 목록
		//$("#stbTable tbody tr").filter(function(i) {return $(this).find("td:first input[name='check_stb']").is(":checked");})
		//						.find("td:nth-child(2)").each(function(i) {stb_list.push($(this).text())});
		$("#stbTable tbody tr").filter(function(i) {return $(this).find("td:first input[name='check_stb']").is(":checked");})
								.find("input[name='check_stb']").each(function(i) {stb_list.push($(this).val())});

		//console.log(stb_list.length);
		//console.log(stb_list);
		if(stb_list.length == 0) {
			alert("삭제할 장비들을 선택해 주세요.");
		} else {
			if(confirm("선택된 장비들을 정말로 삭제하시겠습니까?")) {
				jQuery.ajaxSettings.traditional = true;
				$.ajax({
			        url:'/stb/deleteSTB.do',
			        type:'post',
			        data:{"stbIDList":stb_list},
			        success:function(result){
			        	$("#frm").submit();        		
			        },
			        error:function() {
			        	alert("삭제에 실패했습니다.\nDB 연결상태를 확인해주세요.");
			        	reloadTable();
			        }
				});
			}
		}
	});
	
	// table load. 새로고침하면 1 페이지로 초기화.
	reloadTable();
});

function resetDialog() {
	$('#stbID').val("");
	$('#stbName').val("");
	$('#stbGroup').selectpicker('val', '1');
	$('#stbMAC').val("");
	$('#stbIP').val("");
	$('#stbNote').val("");
}
function populateData(selected_row) {
	var id = selected_row.find("input[name='check_stb']").val();
	var name = selected_row.find("td:nth-child(3)").text();
	var mac = selected_row.find("td:nth-child(5)").text();
	var ip = selected_row.find("td:nth-child(6)").text();
	var group_id = selected_row.find("td:nth-child(9)").text();
	var note = selected_row.find("td:nth-child(10)").text();
	
	$('#stbID').val(id);
	$('#stbName').val(name);
	$('#stbGroup').selectpicker('val', group_id);
	$('#stbMAC').val(mac);
	$('#stbIP').val(ip);
	$('#stbNote').val(note);
}

function setTableHandler() {
	// checkbox 제외한 row click 이벤트 핸들러
	$("#stbTable tbody tr").click(function (event) {
		console.log('$("#stbTable tbody tr").click');
		if(event.target.type == 'checkbox') return;
		
		var cur_checkbox = $(this).find("td:first input[name='check_stb']");
		var is_checked = cur_checkbox.is(":checked"); 
		//console.log(is_checked);

		//var stb_mac = $(this).find("td:nth-child(5)").text();	
		//console.log(stb_mac);

		if(event.target.tagName == "BUTTON" || event.target.tagName == "I") {
			// 무조건 체크함
			$(cur_checkbox).iCheck('check');
			
			var stb_list = [];
			// 선택된 장비들의 mac 목록
			$("#stbTable tbody tr").filter(function(i) {return $(this).find("td:first input[name='check_stb']").is(":checked");})
									.find("td:nth-child(5)").each(function(i) {stb_list.push($(this).text())});
			console.log(stb_list);
			
			var confirm_msg, success_msg, error_msg;
			switch($(event.target).attr('name')) {
				case "reboot":
					confirm_msg = "선택한 장비들을 재부팅하시겠습니까?";
					success_msg = "장비들이 재부팅되었습니다."
					error_msg = "재부팅에 실패했습니다.\nDB 연결상태를 확인해주세요.";
					break;
				case "tv_power_on":
					confirm_msg = "선택한 장비에 연결된 TV의 전원을 켜시겠습니까?";
					success_msg = "전원을 켰습니다."
					error_msg = "TV 제어에 실패했습니다.\nDB 연결상태를 확인해주세요.";
					break;
				case "tv_power_off":
					confirm_msg = "선택한 장비에 연결된 TV의 전원을 끄시겠습니까?";
					success_msg = "전원을 껐습니다."
					error_msg = "TV 제어에 실패했습니다.\nDB 연결상태를 확인해주세요.";
					break;
				case "firmware_update":
					confirm_msg = "선택한 장비들을의 펌웨어를 최신으로 업데이트하시겠습니까?";
					success_msg = "펌웨어 업데이트를 시작했습니다."
					error_msg = "장비 제어에 실패했습니다.\nDB 연결상태를 확인해주세요.";
					break;
				case "schedule_download":
					confirm_msg = "선택한 장비들로 방송 편성표를 다운로드하시겠습니까?";
					success_msg = "방송 편성표가 다운로드되었습니다."
					error_msg = "편성표 다운로드에 실패하였습니다.\nDB 연결상태를 확인해주세요.";
					break;
			}
			sendCommandToSTB(confirm_msg, success_msg, error_msg, $(event.target).attr('name'), stb_list);
		} else {
			// 체크박스 반대로 세팅함.
			$(cur_checkbox).iCheck('uncheck');
		}
		
		return false;
	});
}

function sendCommandToSTB(confirm_msg, success_msg, error_msg, cmd, stb_list) {
	if(confirm(confirm_msg)) {
		jQuery.ajaxSettings.traditional = true;
		$.ajax({
	        url:'/stb/sendSTBcommand.do',
	        type:'post',
	        data:{'command':cmd, "stbList":stb_list},
	        success:function(result){
	        	alert(success_msg);        		
	        },
	        error:function() {
	        	alert(error_msg);
	        	reloadTable();
	        }
		});
	}
}

function reloadTable() {
	searchWord = "";
	$('#searchWord').val("");
	getSTBList(1, true);
}
function getSTBList(pageNum, refreshPagination) {
	curPageNum = pageNum;	// auto refresh를 위해 최근 pagenum 저장
	
	var pageSize = Cookies.get('pageUnit');
	var firstIndex = pageSize * (pageNum-1);
	var data = {"firstIndex": firstIndex, "pageUnit": pageSize};
	if(Cookies.get('groupShown') == 'Y')
		data.group_id = Cookies.get('selected_node');
	if(searchWord != "") {
		data.search_word = '%'+searchWord+'%';
		if(!isNaN(Number(searchWord))) {
			data.search_number = searchWord;
		} else {
			data.search_number = 0;
		}
	}
	$.ajax({
		url: '/stb/listSTB.do',
        type: 'post',
        data: data,
        success:function(result){
        	console.log(result.list);
        	numSTBs = result.numSTBs;
        	
        	$("#stbTable tbody").empty();
        	for(var i=0; i<result.list.length; i++) {
        		var cur_stb = result.list[i];
        		var html;
        		
       			html = "<tr>";
        		html += "<td><input type='checkbox' name='check_stb' class='form-control input-sm' value=" + cur_stb.stbID + "></td>";
        		html += "<td>" + cur_stb.stbNo + "</td>";
        		html += "<td>" + cur_stb.stbName + "</td>";

        			html += "<td>" + cur_stb.stbStatus + "</td>";
        		html += "<td>" + cur_stb.stbMAC + "</td>";
        		html += "<td>" + cur_stb.stbIP + "</td>";
        		html += "<td class='toggleCol'>" + cur_stb.stbGroupName + "</td>";
        		html += "<td>";
			html += '<button name="reboot" class="btn btn-sm tooltips" data-placement="left" title="장비를 재부팅합니다."><i name="reboot" class="fa fa-bolt fa-lg"></i></button>';
			html += '<button name="tv_power_on" class="btn btn-sm tooltips m-l-5 m-r-5" data-placement="left" title="TV 전원을 켭니다."><i name="tv_power_on" class="fa fa-toggle-on fa-lg"></i></button>';
			html += '<button name="tv_power_off" class="btn btn-sm tooltips" data-placement="left" title="TV 전원을 끕니다."><i name="tv_power_off" class="fa fa-toggle-off fa-lg"></i></button>';
			html += '<button name="firmware_update" class="btn btn-sm tooltips m-l-5 m-r-5" data-placement="left" title="펌웨어를 업데이트합니다."><i name="firmware_update" class="fa fa-refresh fa-lg"></i></button>';
			html += '<button name="schedule_download" class="btn btn-sm tooltips" data-placement="left" title="스케줄을 내려보냅니다."><i name="schedule_download" class="fa fa-download fa-lg"></i></button>';
			html += "</td>";
			html += "<td style='display:none'>" + cur_stb.stbGroupID + "</td>"
			html += "<td style='display:none'>" + cur_stb.stbNote + "</td>"
        		html += "</tr>";
        		$("#stbTable tbody").append(html);
        	}
        	
        	$('#stbTable > tbody > tr > td > input:checkbox:not([data-toggle="buttons"])').iCheck({
    		    checkboxClass: 'icheckbox_minimal',
    		    radioClass: 'iradio_minimal',
    		    increaseArea: '20%' // optional
    		});
        	
        	$('#stbTable > tbody > tr > td > .tooltips').tooltip();
        	
        	setTableHandler();
        	
        	if(refreshPagination) {
	        	console.log(result.numSTBs);
	        	$('#STBTablePagination').pagination({
	        		dataSource: function(done) {
	        			var result = [];
	        			for(var i=0; i< numSTBs; i++)
	        				result.push(i);
	        			done(result);
	        		},
	        		pageSize: Cookies.get('pageUnit'),
	        		autoHidePrevious: true,
	        		autoHideNext: true,
	        		triggerPagingOnInit: false,
	        		callback: function(data, pagination) {
	        			getSTBList(pagination.pageNumber, false);
	        		}
	        	});
        	}
        },
        error: function() {
            alert('장비 목록을 가져올 수 없습니다.\nDB 연결 상태를 확인해 주세요.');
        }
	});
}

//function fn_page(pageNo) {
//	$("#pageIndex").val(pageNo);
//	$("#frm").submit();
//}

function hideTree(animTime, refresh) {
	$("#groupTreeContainer").hide();
	$("#groupTreeFoldedContainer").show();
	
	Cookies.set('groupShown', 'N');
	setTimeout("hideTreePost("+refresh+")", animTime);
	//hideTreePost();
}
function hideTreePost(refresh) {
	$('#groupTreeFoldedContainer').show();
	$('#stbTableContainer').removeClass('col-md-9').addClass('col-md-11');
	if(refresh) {reloadTable();};
}

function showTree(animTime, refresh) {
	$('#stbTableContainer').removeClass('col-md-11').addClass('col-md-9');
	$('#groupTreeContainer').show();
	$('#groupTreeFoldedContainer').hide();
	
	Cookies.set('groupShown', 'Y');
	
	if(refresh) {
		setTimeout("showTreePost()", animTime);
	}
}
function showTreePost() {
	reloadTable();
}

function getNewGroupID(parentID, text) {
	var newID = null;
	
	$.ajax({
        url:'/stb/createGroup.do',
        type:'post',
        //data:{"parentID": data.parent, "name" : data.node.text},
        data:{"parentID": parentID, "name" : text},
        async:false,
        success:function(result){
        	console.log(result);        		
    		//data.node.id = result.newNodeID;
    		newID = result.newNodeID;
    		//data.node.edit();
        },
        error:function() {
        	alert("그룹 생성에 실패했습니다.\nDB 연결상태를 확인해주세요.");
        	$("#frm").submit();
        }
	});
	
	return newID;
}
function createGroup() {
	var ref = $('#jstree').jstree(true);
	sel = ref.get_selected();
	if(!sel.length) { return false; }
	sel = sel[0];
	
	var new_id = getNewGroupID(sel, "새 그룹"); 
	var new_node = {"id":new_id, "text":"새 그룹", "numSTB": 0};	
	console.log("new id : " + new_id);
	
	ref.create_node(sel, new_node);
	ref.edit(new_id);
}

function renameGroup() {
	var ref = $('#jstree').jstree(true);
	sel = ref.get_selected('full');
	if(!sel.length) { return false; }
	sel = sel[0];
	console.log(sel.original.name);
	if(sel.id == '1') {
		alert("ROOT 그룹은 변경할 수 없습니다.");
		return false;
	}
	ref.edit(sel, sel.original.name);
}
/*
function get_all_children(tree, node) {
	var res = [node];
	var child_nodes = tree.get_children_dom(node);
 
	for(var i=0; i<child_nodes.length; i++) {
		res = res.concat(get_all_children(tree, child_nodes[i].id));
	}

	return res;
}
*/
function deleteGroup() {
	var ref = $('#jstree').jstree(true);
	sel = ref.get_selected('full');
	if(!sel.length) { return false; }
	sel = sel[0];

	if(sel.id == '1') {
		alert("ROOT 그룹은 삭제할 수 없습니다.");
		return false;
	}
	console.log(sel);
	
	var msg = sel.original.name + " 그룹 및 모든 하위 그룹이 삭제되며\n삭제된 그룹의 장비들은 ROOT로 옮겨집니다.\n\n정말 삭제하시겠습니까?";
	if(confirm(msg)) {
		var all_children = sel.children_d,
			parent_node = ref.get_node(sel.parent),
			position = $.inArray(sel.id, parent_node.children);

		all_children.push(sel.id);

		jQuery.ajaxSettings.traditional = true;
		$.ajax({
            url:'/stb/deleteGroup.do',
            type:'post',
            data:{"parentID": sel.parent, "position": position, "groupIDList": all_children},
            success:function(result){
            	console.log(result);
            	ref.delete_node(sel);
        	ref.select_node('1');
		$("#frm").submit();
            },
            error:function() {
            	alert("그룹 삭제에 실패했습니다.\nDB 연결상태를 확인해주세요.");
            }
		});
	}
}

</script>
</head>
<body>

<div class="modal fade" id="registerSTBDialogForm" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="registerSTBFormTitle">셋탑 박스 등록</h4>
            </div>
            <div class="modal-body">
            		<form id="STBForm">
					<input type="hidden" name="stbID" id="stbID">
					<input type="hidden" name="lastOnTime" id="lastOnTime">
					<div class="row">
		                <div class="col-md-3">장비명 (설치 장소)</div>
		                <div class="col-md-9">
		                		<input type="text" class="form-control input-sm" name="stbName" id="stbName">
		                	</div>
		            </div>
		            <div class="row m-t-5 m-b-5">
		                <div class="col-md-3">그룹명</div>
		                <div class="col-md-9">
		                		<select name="stbGroup" id="stbGroup" class="select">
						    	<%
						    		if(group != null) {
						    			Map<String, Object> GroupNode;
						    			for(int i=0; i<group.size(); i++) {
						    				GroupNode = group.get(i);
						    				String groupID = String.valueOf(GroupNode.get("groupID"));
						    				String groupName = String.valueOf(GroupNode.get("groupName"));
						    	%>
						       		<option value="<%=groupID%>"><%=groupName%></option>
						    	<%
						    			}
						    		}
						    	%>
						    	</select>
		                </div>
		              </div>
		            <div class="row">
		                <div class="col-md-3">MAC</div>
		                <div class="col-md-9">
		                		<input type="text" name="stbMAC" id="stbMAC" class="form-control input-sm" placeholder="셋탑박스 MAC 주소를 입력하세요.">
		                </div>
		            </div>
		            <div class="row m-b-5 m-t-5">
		                <div class="col-md-3">IP</div>
		                <div class="col-md-9">
		                		<input type="text" name="stbIP" id="stbIP" class="form-control input-sm" placeholder="셋탑박스 IP 주소를 입력하세요.">
		                </div>
		           </div>
		           <div class="row">
		                <div class="col-md-3">비 고</div>
		                <div class="col-md-9">
		                		<textarea class="form-control overflow" name="stbNote" id="stbNote"></textarea>
		                </div>
	                </div>
	              </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-sm" id="btSaveSTB">저 장</button>
                <button type="button" class="btn btn-sm" data-dismiss="modal">취 소</button>
            </div>
        </div>
    </div>
</div>

<ol class="breadcrumb hidden-xs">
    <li>STB 모니터링</li>
</ol>
<h4 class="page-title">STB 모니터링</h4>
<div class="block-area">
	<!-- div class="row text-right m-t-5 m-b-5 m-r-15">
		<a onclick="location.href='/overlayEditor/editorMain.do'" href="">Go to Overlay Editor</a>
	</div //-->
	<form name="frm" id="frm" method="post" action="/stb/list.do">
		<div class="container-fluid p-l-0">
			<div id="groupTreeFoldedContainer" class="col-md-1 tile p-0" style="display:none;">
				<div class="row tile-title">
					<h5>그룹<a href="#" id="groupTreeShow"><i class="fa fa-arrow-circle-right fa-lg m-l-5"></i></a></h5>
				</div>
			</div>
			<div class="col-md-3 tile p-0" id="groupTreeContainer">
				<div class="row m-b-10 tile-title">
					<h5>선택하면 해당 그룹만 표시합니다.<a href="#" id="groupTreeHide"><i class="fa fa-arrow-circle-left fa-lg m-l-5"></i></a></h5>
				</div>
				<div id="groupTree">
					<div id="jstree">
					</div>
				</div>
				<div class="m-t-5 tile-title text-right">
					<button id="createGroup" class="btn btn-sm btn-alt">그룹 생성</button>
					<button id="renameGroup" class="btn btn-sm btn-alt">그룹 변경</button>
					<button id="deleteGroup" class="btn btn-sm btn-alt">그룹 삭제</button>
				</div>
			</div>
			<div class="col-md-9" id="stbTableContainer">
				<div class="col-md-3 m-b-5">
					<h3><a href="javascript:void(0);" id="refreshList" onClick="location.reload();" style="cursor:pointer"><i class="fa fa-refresh fa-lg m-r-5"></i>새로고침 </a></h3>
				</div>
				<div class="col-md-2 col-md-offset-3 p-t-10">
					<select name="pageUnit" id="pageUnit" class="select">
						<option value="10">10개</option>
						<option value="25">25개</option>
						<option value="50">50개</option>
						<option value="100">100개</option>
					</select>
				</div>
				<div class="col-md-3 p-t-10">
					<input name="search_word" id="searchWord" title="테이블의 모든 항목을 검색합니다." class="form-control input-sm" placeholder="검색어를 입력하세요.">
				</div>
				<div class="col-md-1 p-t-10">
					<button id="searchButton" class="btn btn-sm">검색</button>
				</div>
				<div class="col-md-12 table-responsive overflow" style="overflow: hidden; outline: none;">
					<table class="table table-bordered table-hover tile" id="stbTable" style="width:" >
						<caption></caption>
						<colgroup>
							<col width="2%"/>
							<col width="5%"/>
							<col width="*"/>
							<col width="12%"/>
							<col width="12%"/>
							<col width="10%"/>
							<col width="13%" class="toggleCol"/>
							<col width="25%"/>
							<col width="0%"/>
						</colgroup>
						<thead>
						<tr>
							<th><input type="checkbox" name="check_all"></th>
							<th>No</th>
							<th>장비명</th>
							<th>활동상태</th>
							<th>MAC</th>
							<th>IP</th>
							<th class="toggleCol">그룹명</th>
							<th>장비제어</th>
						</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
				<div class="col-md-12">
					<div class="media text-center" id="STBTablePagination"></div>
				</div>
				<div class="col-md-3 pull-right text-right">
					<button class="btn btn-sm" id="registerSTB">장비 등록</button>
					<button class="btn btn-sm" id="deleteSTB">삭 제</button>
					<button class="btn btn-sm" id="modifySTB">수 정</button> 
				</div>
			</div>
		</div>
	</form>
</div> 
</body>
</html>