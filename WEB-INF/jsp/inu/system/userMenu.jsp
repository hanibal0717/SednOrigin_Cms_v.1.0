<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@page import="vcms.common.file.util.UvFileUtil"%>

<%
    /**
			 * @JSP Name : userMenu.jsp
			 * @Description : 사용자 메뉴 등록 화면
			 * @Modification Information
			 * 
			 *   수정일         수정자                   수정내용
			 *  -------    --------    ---------------------------
			 *  2011.06.07  신혜연          최초 생성
			 *
			 * author 실행환경팀 
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

 -->
<style>
.bodyTdText {
    text-shadow:0px 0px 3px rgba(255, 255, 255, 0.4) !important;
}
</style>
<script type="text/javascript" src="<c:url value='/js/axisj/dist/AXJ.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXGrid.js'/>"></script>

<script language="JavaScript" src="/common/uploadify/uploadify.js"></script>

<script>
/**
 * Require Files for AXISJ UI Component...
 * Based		: jQuery
 * Javascript 	: AXJ.js, AXGrid.js, AXInput.js, AXSelect.js
 * CSS			: AXJ.css, AXGrid.css, AXButton.css, AXInput.css, AXSelecto.css
 */	
	var pageID = "AXTree";
	var myTree = new AXTree();

	var fnObj = {
		pageStart: function(){

			fnObj.tree1();

		},
		tree1: function(){

			myTree.setConfig({
				targetID : "AXTreeTarget",
				theme: "AXTree_none",
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
								var menuNm = this.item.menuName;
								return menuNm;
								//return  this.item.menuName;
							}else{ //treeSplit 을 사용한 경우
								return "";
							}
						}
					}
				],
				body: {
					onclick:function(idx, item){
						//console.log(this.item)
						//console.log(myTree)
						//alert(this.item.menuLevel);
						if(this.item.menuLevel==2){
							alert(this.item.menuName+"의 하위메뉴는 만들 수 없습니다.");
							return false;
						}else{
							setItem(this.item);
						}
						
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
		
	
	};

function setItem(obj){
	clearForm();
	
	$('#no').val(obj.no);
	$('#pno').val(obj.pno);
	$('#menuName').val(obj.menuName);
	$('#menuPath').val(obj.menuPath);
	$('#menuTxt').val(obj.menuTxt);
	$('#childCnt').val(obj.childCnt);
	
	var p = myTree.getSelectedListParent();
	$('#upMenu').text( p.item == null ? '' : p.item.menuName);
	
	if ($('#upMenu').text() == "") {
		$('#FILE_VISUAL').hide();
	} else {
		$('#FILE_VISUAL').hide(); 
	}
	
	if (obj.fileNm != "") {
		jsDrawImageFile('VISUAL_IMG', obj.orgFileNm, obj.fileNm, null, obj.no, '/upload/VISUAL_IMG/', 'Y');
	}
}
function save(){
	if($('#menuName').val() == ''){
		alert('메뉴명을 입력하세요'); return;
	}
	var obj = myTree.getSelectedList();
	if(obj.error) {
	alert(obj.description);
		return;
	}

	var pNo = $('#no').prop("pno");
	var no = '';
	$('#psysCode').val($('#sysCode').val());
	
	$.ajax({
            url:'/system/saveUserMenu.do',
            type:'post',
            data:$('#frm').serialize(),
            success:function(data){
                alert(data.msg);
                no = data.no;
				if(pNo){
					myTree.appendTree(obj.index, obj.item, [{ type:"file", 'no': no , pno : $('#pno').val(), menuName:$('#menuName').val() 
						, menuPath:$('#menuPath').val() , menuTxt:$('#menuTxt').val() }]);	
				} else {
					myTree.updateTree(obj.index, obj.item, { menuName:$('#menuName').val(), menuPath:$('#menuPath').val() , menuTxt:$('#menuTxt').val()});
				} 
				myTree.clearFocus();
				clearForm();
				$('#upMenu').text('');
				document.location.reload();
            }
	});
}

function add(){
	clearForm();
	
	var obj = myTree.getSelectedList();
	if(obj.error) {
		alert("상위 메뉴를 선택하세요.");
		//alert(obj.description);
		return;
	}
	$('#upMenu').text(obj.item.menuName);
	$('#pno').val(obj.item.no);
	$('#no').prop("pno", obj.item.no);

}
function clearForm(){
	$('#frm').resetForm();
	$('#frm').find('input[type=hidden]').each(function(){this.value = '';});
	$('#no').prop("pno", '');
	

	var element = document.getElementById("FILE_UPLOAD");
	while (element.firstChild) {
  		element.removeChild(element.firstChild);
	}
	$("#FILE_UPLOAD").html($('#temp').val());
	$('#FILE_VISUAL').hide();
}
function remove(){
	var obj = myTree.getSelectedList();
	if(obj.error) {
		alert("상위 메뉴를 선택하세요.");
		//alert(obj.description);
		return;
	}
	if(obj.item.childCnt != 0) {
		alert("삭제할 메뉴의 하위메뉴가 존재합니다.");
		return;
	}
	var bool = confirm("선택한 메뉴가 삭제 됩니다. \n주의하십시오.");
	if (!bool){
		return;
	}

	$.ajax({
            url:'/system/removeUserMenu.do',
            type:'post',
            data:$('#frm').serialize(),
            success:function(data){
                alert(data.msg);
				myTree.removeTree(obj.index, obj.item);
				clearForm();
				$('#upMenu').text('');
				
				document.location.reload();
            }
	});
	
}

$(document).ready(function() {
    fnObj.pageStart();
	$('#add').click(function(){add()})
	$('#save').click(function(){save()})
	$('#remove').click(function(){remove()})
	
   	$( "#sysCode" ).change(function() {
   		if($(this).val() == '') return;
		//var List = [ {no:1, menuName:$(this).find('option:selected').text(),  pno:''}, ];
		var List = [];
		$.ajax({
            url:'/system/selectUserMenu.do',
            type:'post',
            data: {sysCode : $(this).val()},
            success:function(data){
            	$.each(data.list, function( i, row ) {
  					List.push(row);
				});
            	myTree.setList(List);
            	myTree.expandAll();
            }
		});		
	});

});

function inputLengthCheck(eventInput){
	var inputText = $(eventInput).val();
	var inputMaxLength = $(eventInput).prop("maxlength");
	var j = 0;
	var count = 0;
	for(var i = 0;i < inputText.length;i++) { 
		val = escape(inputText.charAt(i)).length; 
		if(val == 6) {
			j++;
		}
		j++;
		if(j <= inputMaxLength){
			count++;
		}
	}
	if(j > inputMaxLength){
		$(eventInput).val(inputText.substr(0, count));
		alert("허용 가능한 글자수를 초과하였습니다.");
	}
}
</script>

</head>
<body>
<ol class="breadcrumb hidden-xs">
    <li>사용자 메뉴 관리</li>
</ol>
<h4 class="page-title">사용자 메뉴 관리</h4>

<div class="block-area">
	<div class="row m-t-15">
		<label class="pull-left m-l-10">상위 메뉴 </label>
		<div class="col-md-2 m-b-15">
			<select class="select pull-left" name='sysCode' id='sysCode'>
				<option value="" selected="">선택</option>
				<c:forEach var="list" items="${sys}" varStatus="listCount">
					<option value="${list.cmCd}" >${list.cmNm}</option>
				</c:forEach>
			</select>
		</div>
	</div>
			
	<form name="frm" id="frm" method="post" >
		<textarea id="temp" style="display: none;"><%=UvFileUtil.drawSingleUpload("VISUAL_IMG", "T", "*.jpg;", "10000MB")%></textarea>
		<div class="row">
			<div class="col-md-6">
				<div id="AXTreeTarget" style="height:400px;"></div>
			</div>
			<div class="col-md-6">
				<div class="table-responsive overflow" style="overflow: hidden; outline: none;">
					<table class="table table-bordered tile">
						<caption></caption>
						<colgroup>
							<col width="28%" />
							<col width="*" />
						</colgroup>
						<tr>
							<th scope="col">상위메뉴</th>
							<td><span id="upMenu"></span> </td>
						</tr>
						<tr>
							<th scope="col">순서</th>
							<td><input type="text" name="no" id="no" pno="" class="form-control input-sm" readOnly/> 
							<input type="hidden" name="pno" id="pno"/>
							<input type="hidden" name="sysCode" id="psysCode"/>
							<input type="hidden" id="childCnt" name="childCnt" value=""/>
							</td>
						</tr>
						<tr>
							<th scope="col">메뉴명</th>
							<td><input type="text" name="menuName" id="menuName"  class="form-control input-sm" maxlength="50" onkeyup="inputLengthCheck(this);" /> </td>
						</tr>
						<!--<tr>
							<th scope="col">메뉴url</th>
							<td>
								<input type="text" name="menuPath" id="menuPath"  class="form-control input-sm" maxlength="100" onkeyup="inputLengthCheck(this);" /><br>
								
								<div class="alert alert-danger">
							        * URL에 http 문자열 포함시 새창으로 열립니다.
							    </div>
							</td>
						</tr>-->
						<!-- <tr>
							<th scope="col">설명</th>
							<td><input type="text" name="menuTxt" id="menuTxt"  class="textInput_size03" maxlength="200" onkeyup="inputLengthCheck(this);" /> </td>
						</tr> -->
						<tr id="FILE_VISUAL" style="display: none">
							<th scope="col">Visual Image<br>사이즈 : 2976 x 142</th>
							<td id="FILE_UPLOAD">
								<%=UvFileUtil.drawSingleUpload("VISUAL_IMG", "T", "*.jpg;", "10000MB")%>
							</td>
						</tr>
					</table>
				</div>
				<div class="row text-right m-b-10 m-r-5">
					<button class="btn-sm btn" id="add">신규 등록</button>
					<button class="btn-sm btn" id="save">저장</button>
					<button class="btn-sm btn" id="remove">삭제</button>
				</div>
			</div>
		</div>
	</form>
</div>
</body>
</html>

