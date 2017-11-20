<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
    /**
	 * @JSP Name : groupAuth.jsp
	 * @Description : 그룹권한 화면
	 * @Modification Information
	 * 
	 *   수정일         수정자                   수정내용
	 *  -------    --------    ---------------------------
	 *  2015.04.07  채지운          최초 생성
	 *
	 * author 개발팀 
	 * Copyright (C) 2011 by MOPAS  All right reserved.
	 */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
<title></title>
<meta name="decorator" content="defaultPage">

<link type="text/css" rel="stylesheet" href="<c:url value='/js/axisj/ui/arongi/AXJ.min.css'/>">
<!--
 
<script type="text/javascript" src="http://dev.axisj.com/jquery/jquery.min.js"></script>
<script type="text/javascript" src="http://dev.axisj.com/dist/AXJ.min.js"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/dist/AXJ.min.js'/>"></script>

<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXConfig.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXJ.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXCore.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXUtil.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXGrid.js'/>"></script>

 -->
<style>
</style>
<script type="text/javascript" src="<c:url value='/js/axisj/dist/AXJ.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXGrid.js'/>"></script>


<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXTree.js'/>"></script>

<script>
/**
 * Require Files for AXISJ UI Component...
 * Based		: jQuery
 * Javascript 	: AXJ.js, AXGrid.js, AXInput.js, AXSelect.js
 * CSS			: AXJ.css, AXGrid.css, AXButton.css, AXInput.css, AXSelecto.css
 */	
	var pageID = "AXTree";
	var myTree = new AXTree();
	var myGrid = new AXGrid();
	var fnObj = {
		pageStart: function(){
			fnObj.tree1();
			fnObj.grid1();
		},
		tree1: function(){

			myTree.setConfig({
				targetID : "AXTreeTarget",
				theme: "AXTree",
				emptyListMSG : 'empty of list',
				//height:"auto",
                //width:"auto",
				//xscroll:true,
				indentRatio:0.7,
				reserveKeys:{
					parentHashKey:"pHash", // 부모 트리 포지션
					hashKey:"hash", // 트리 포지션
					openKey:"open", // 확장여부
					subTree:"subTree", // 자식개체키
					displayKey:"display" // 표시여부
				},
				colGroup: [
					{key:"checkYn", label:"유형", width:"50", align:"center"
						,formatter:function(){
							//console.log(this.item.groupSeq)
							var checked = this.item.groupSeq ? 'checked' : '';
							return "<input type='checkbox' class='pcheck'"+checked+" name='checkYn'></input>";
						}},
					{
						key:"nodeName",
						label:"제목",
						width:"100%", align:"left",
						indent:true,
						getIconClass: function(){
							//folder, AXfolder, movie, img, zip, file, fileTxt, fileTag
							var iconNames = "folder, AXfolder, movie, img, zip, file, fileTxt, fileTag".split(/, /g);
							var iconName = "file";
							//if(this.item.type) iconName = iconNames[this.item.type];
							return iconName;
						},
						formatter:function(){
							if(this.item.no){
								//return "<b>"+this.item.no.setDigit(2) + "</b> : " + this.item.nodeName;
								return  this.item.menuName;
							}else{ //treeSplit 을 사용한 경우
								return "";
							}
						}
					}
				],colHead: {
					//display:true
				},
				body: {
					onclick:function(idx, item){
					},
					addClass: function(){
						// red, green, blue, yellow
						// 중간에 구분선으로 나오는 AXTreeSplit 도 this.index 가 있습니다. 색 지정 클래스를 추가하는 식을 넣으실때 고려해 주세요.
						/*
						if(this.index % 2 == 0){
							return "yellow"+this.index;
						}else{
							return "blue"+this.index;
						}
						*/
					}
				}
			});
		},
		
		grid1: function(){

	var getColGroup = function(){ return [

{key:"no", label:"번호", width:"53", align:"center", formatter:"radio"
//editor: { type: "checkbox",beforeUpdate: function(val){ return val; } } 
},
{key:"groupSeq", label:"", width:"50", align:"center", display : false },
{key:"_CUD", label:"상태", width:"52", align:"center"},
{key:"groupNm", label:"그룹이름", width:"200", align:"", disable: true, editor: { type: "String", updateWith: ["_CUD"]} },

];
	};

	myGrid.setConfig({
		targetID : "AXGridTarget",
		sort: false, //정렬을 원하지 않을 경우 (tip
		colHeadTool: true, // column tool use
		//fitToWidth: true, // 너비에 자동 맞춤
		passiveMode:true,
		passiveRemoveHide:false,		   
		
		colGroup : getColGroup(),
		colHeadAlign: "center", // 헤드의 기본 정렬 값. colHeadAlign 을 지정하면 colGroup 에서 정의한 정렬이 무시되고 colHeadAlign : false 이거나 없으면 colGroup 에서 정의한 속성이 적용됩니다.
		body : {
		    addClass: function(){
		        // red, green, blue, yellow, white, gray
		        if(this.index % 2 == 0){
		            return "gray";
		        }else{
		            return "white";
		        }
		    },
		    
		page: {
			paging:false,
			status:{formatter: null}
	    },
	}
	});
	
		this.searchGrid();

	},
	searchGrid: function(){
		var param = '&groupNm='+$('#groupNm').val();
        myGrid.setList({
	    	ajaxUrl:"/biz/gridData.do", ajaxPars:"sqlId=system.selectSYS_GROUP"+param, onLoad:function(){
	        	//trace(this);
	    	}
		});            
	},
	append: function(){
		myGrid.pushList({groupSeq:myGrid.list.length+1});
		myGrid.setFocus(myGrid.list.length-1);
	},
	remove: function(){
		var checkedList = myGrid.getCheckedListWithIndex(0);// colSeq
		if(checkedList.length == 0){
			alert("선택된 목록이 없습니다. 삭제하시려는 목록을 체크하세요");
			return;
		}
		myGrid.removeListIndex(checkedList);
		// 전달한 개체와 비교하여 일치하는 대상을 제거 합니다. 이때 고유한 값이 아닌 항목을 전달 할 때에는 에러가 발생 할 수 있습니다.
	},
	searchTree: function(){
		var checkedList = myGrid.getCheckedListWithIndex(0);// colSeq
		if(checkedList.length != 1){
			alert("조회할 그룹 1개를 선택하세요");
			return;
		}
		var param = '&sysCode='+$('#sysCode').val();
		    param += '&groupSeq='+checkedList[0].item.groupSeq;
        
		    myTree.setTree({
	    	ajaxUrl:"/system/selectGroupMenu.do", ajaxPars:param, onLoad:function(){
	        	//trace(this);
	        	//myTree.listNoneDisplay();
	        	if(myTree.list && myTree.list.length>0)
	        		myTree.expandAll();
	        	else{
                     var po = [];
		po.push("<tr class=\"noListTr\">");
		po.push("<td colspan=\"2\">");
		po.push("<div class=\"tdRelBlock\">");
		po.push("<div class=\"bodyNode bodyTdText\" align=\"center\">");
		po.push("empty of list");
		po.push("</div>");
		po.push("</div>");
		po.push("</td>");
		po.push("<td class=\"bodyNullTd\"><div class=\"tdRelBlock\">&nbsp;</div></td>");
		po.push("</tr>");
		axdom("#AXTreeTarget_AX_tbody").html(po.join(''));
	        	}
	    	}
		});  
       
	}
};


function saveGrid(){

	var list = myGrid.getList("C,U,D", true);
	if(list.length == 0 ){
		alert('변경건수가 없습니다.'); return;
	}
	for(var i = 0; i < list.length ; i++){
		if(list[i].groupNm == "" || typeof list[i].groupNm == 'undefined') {
			 alert('그룹이름은 필수입력항목 입니다.'); return;
		}
	}
	$('#gridData').val(list.axtoJSON());

	$.ajax({
            url:'/system/saveSysMenu.do',
            type:'post',
            data:$('#frm').serialize(),
            success:function(data){
                alert(data.msg);
                 myGrid.reloadList();
            }
	});
}

function saveGroup(){
	var treeData = [];
	$('.pcheck').each(function(i){
		if($(this).is(":checked")){
			console.log(i)
			myTree.list[i].isChk = '1'
		}else myTree.list[i].isChk = '0'
		treeData.push(myTree.list[i]);
	});
	console.log(treeData);
	//return;
	$('#treeData').val(treeData.axtoJSON());

	if(treeData.length == 0){
		alert("선택된 그룹이 없습니다");
		return;
	}
	var checkedList = myGrid.getCheckedListWithIndex(0);// colSeq
	var gridData = [];
	$.each(checkedList, function( index, value ) {
		console.log(value.item);
		gridData.push(value.item);
	});
	console.log(gridData);
	console.log(gridData.axtoJSON());
	if(gridData.length == 0){
		alert("선택된 메뉴가 없습니다");
		return;
	}
	$('#gridData').val(gridData.axtoJSON());


	$.ajax({
            url:'/system/saveSysGroupMenu.do',
            type:'post',
            data:$('#frm').serialize(),
            success:function(data){
                alert(data.msg);
                 //myGrid.reloadList();
            }
	}); 
}


$(document).ready(function() {
    fnObj.pageStart();
	$('#searchGrid').click(function(){fnObj.searchGrid()})
	$('#searchTree').click(function(){fnObj.searchTree()})
	
	$('#saveGrid').click(function(){saveGrid()})
	$('#saveGroup').click(function(){saveGroup()})
	
	$('#remove').click(function(){fnObj.remove()})
	$('#append').click(function(){fnObj.append()})

});
</script>

</head>
	
<body>
<h2>관리자 그룹 권한 관리<!--<span class="text">한림성심대학교 학사생정지원시스템 그룹권한 관리 입니다.</span>--></h2>
<p class="location"> C > 지원자 관리 > 지원자 관리</p>

<section >
<div class="tbl_insert posi_re">
	<div class="table_le border2" >
		<table class="data_tableH">
			<caption></caption>
			<colgroup>
				<col width="25%" />
				<col width="*" />
			</colgroup>
			<tbody>
			<tr>
				<th scope="row">그룹명</th>
				<td>
					<input type="text" name="groupNm" id="groupNm" />
					<button id='searchGrid' class="btn_searchPare10 va_middle">조회</button> 
				</td>
			</tr>
			</tbody>
		</table>
	</div>
	<div class="table_ri" >
		<table class="data_tableH">
			<caption></caption>
			<colgroup>
				<col width="25%" />
				<col width="*" />
			</colgroup>
			<tbody>
			<tr>
				<th scope="row">시스템구분</th>
				<td>
					<select class="select_size04" style="width:180px" name='sysCode' id='sysCode'>
						<option value="" selected="">선택</option>
						<c:forEach var="list" items="${sys}" varStatus="listCount">
							<option value="${list.cmCd}" >${list.cmNm}</option>
						</c:forEach>
					</select>
					<button id='searchTree' class="btn_searchPare10 va_middle">조회</button> 
				</td>
			</tr>
			</tbody>
		</table>
	</div>
</div>
			</section>
			
<div class="tbl_insert posi_re">
	<div class="table_le border2 btn_size"  >
	<h3>
		그룹목록
		<button id="append" class="btn_searchPare10 Mt10 " style="float:right;margin-right:10px">추가</button>
		<button id="remove" class="btn_searchPare10 Mt10 " style="float:right;margin-right:10px">삭제</button>
		<button id="saveGrid" class="btn_searchPare Mt10" style="float:right;margin-right:10px">저장</button>
	</h3>
		<div id="AXGridTarget" style="height:400px;"></div>
	</div>
	<div class="table_ri btn_size" >
	<h3 >
		권한목록
		<button id="saveGroup" class="btn_searchPare Mt10" style="float:right;margin-right:10px">저장</button>
	</h3>

		<div id="AXTreeTarget" style="height:400px;"></div>
	</div>
</div>
<form id='frm' method="post">
	<input type="hidden" name="gridData" id="gridData"/>
	<input type="hidden" name="treeData" id="treeData"/>
</form>
</body>
</html>

