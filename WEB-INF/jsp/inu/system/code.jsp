<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
    /**
			 * @JSP Name : code.jsp
			 * @Description : 코드 관리
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
	var myGrid = new AXGrid();
	var fnObj = {
		pageStart: function(){
			fnObj.grid();
		},
		grid: function(){

	var getColGroup = function(){ return [


{key:"cmCd", label:"코드", width:"50", align:"center",  },
{key:"cmNm", label:"코드명", width:"150", align:"left",  },
{key:"cdSeq", label:"순서", width:"50", align:"center",  },
{key:"isUse", label:"사용여부", width:"80", align:"center",  },

{key:"grpCd", label:"grpCd", width:"80", align:"center", display:false },
{key:"grpNm", label:"grpNm", width:"80", align:"center", display:false },
{key:"val1", label:"val1", width:"80", align:"center", display:false },
{key:"val2", label:"val2", width:"80", align:"center", display:false },
{key:"val3", label:"val3", width:"80", align:"center", display:false },
{key:"etc1", label:"etc1", width:"80", align:"center", display:false },
{key:"etc2", label:"etc2", width:"80", align:"center", display:false },
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
			onclick:function(idx, item){
				setItem(this.item);
			},
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
		 param += '&grpCd='+$('#pGrpCd').val();
        myGrid.setList({
	    	ajaxUrl:"/biz/gridData.do", ajaxPars:"sqlId=system.selectListCodeGroupDetail"+param, onLoad:function(){
	        	//trace(this);
	    	}
		});            
	},
};

function setItem(obj){
	$('#grpCd').val(obj.grpCd);
	$('#cmCd').val(obj.cmCd);
	$('#grpNm').val(obj.grpNm);
	$('#cmNm').val(obj.cmNm);
	$('#cdSeq').val(obj.cdSeq);
	/* $('#val1').val(obj.val1);
	$('#val2').val(obj.val2);
	$('#val3').val(obj.val3);
	$('#etc1').val(obj.etc1);
	$('#etc2').val(obj.etc2); */
	$('#isUse').val(obj.isUse);
	
	$('#isUse').each(function() {
		if( $(this).val() == obj.isUse )
		{
			$(this).attr("checked", "checked");	
		}
	});
	$("#newType").val('0');
	$("#selColumn").val(obj.cmCd);
}

function newForm() {
	if($('#pGrpCd option:selected').val() == '') {
		alert("코드그룹을 선택해 주세요");
		return;
	}
	$("#selColumn").val(''); 
	clearForm();
	//"grpCd" grpNm
	$('#grpCd').val( $('#pGrpCd option:selected').val() );
	$('#grpNm').val( $('#pGrpCd option:selected').text() );
	
	$("#newType").val('1');
}
function clearForm(){
	if( $('#selColumn').val() != '' )
	{
		var list = myGrid.getList();
 		var clearFlag = false;
		for(i=0; i < list.length ; i++)
		{
			console.log("### selColumn : "+$('#selColumn').val() + "### list.cmCd : "+list[i].cmCd );
			if( $('#selColumn').val() == list[i].cmCd )
			{
				$('#frm').resetForm();
				$('#frm').find('input[type=hidden]').each(function(){this.value = '';});
				
				$('#grpCd').val(list[i].grpCd);
				$('#cmCd').val(list[i].cmCd);
				$('#grpNm').val(list[i].grpNm);
				$('#cmNm').val(list[i].cmNm);
				$('#cdSeq').val(list[i].cdSeq);
/* 				$('#val1').val(list[i].val1);
				$('#val2').val(list[i].val2);
				$('#val3').val(list[i].val3);
				$('#etc1').val(list[i].etc1);
				$('#etc2').val(list[i].etc2); */
				$('#isUse').val(list[i].isUse);
				
				$('#isUse').each(function() {
					if( $(this).val() == list[i].isUse )
					{
						$(this).attr("checked", "checked");	
					}
				});
				$("#newType").val('0');
				$("#selColumn").val(list[i].cmCd);
				clearFlag = true;
			} 			
		}
		if(!clearFlag)
		{
			$('#frm').resetForm();
			$('#frm').find('input[type=hidden]').each(function(){this.value = '';});
			
			$("#newType").val('0');
			$("#selColumn").val('');
		}
	} else {
		$('#frm').resetForm();
		$('#frm').find('input[type=hidden]').each(function(){this.value = '';});
		
		$("#newType").val('0');
		$("#selColumn").val('');
	}
}

function save(){
	
	if($('#grpCd').val() == ''){
		alert('그룹코드는 필수 값 입니다.'); return;
	}
	if($('#cmCd').val() == ''){
		alert('코드는 필수 값 입니다.'); return;
	}
	
	if($('#newType').val() == '1') {
		var list = myGrid.getList();

		for(i=0; i < list.length ; i++)
		{
			if( $('#cmCd').val() == list[i].cmCd )
			{
				alert('코드 값이 중복되었습니다.'); 
				$('#cmCd').focus(); return;
			} else if( $('#cdSeq').val() == list[i].cdSeq ) {
				alert('표시순서 값이 중복되었습니다.');
				$('#cdSeq').focus(); return;
			} 
		}
		if($('#isUse').val() == '')
		{
			alert('사용여부를 선택해 주세요.');
			return;
		}
	}
	
	$.ajax({
            url:'/system/saveCode.do',
            type:'post',
            data:$('#frm').serialize(),
            success:function(data){
                alert(data.msg);
                $("#selColumn").val('');
                clearForm();
				myGrid.reloadList();
            }
	}); 
}
function remove(){

	if($('#grpCd').val() == ''){
		alert('그룹코드는 필수 값 입니다.'); return;
	}
	if($('#cmCd').val() == ''){
		alert('코드는 필수 값 입니다.'); return;
	}

	$.ajax({
            url:'/system/removeCode.do',
            type:'post',
            data:$('#frm').serialize(),
            success:function(data){
                alert(data.msg);
                $("#selColumn").val('');
                clearForm();
				myGrid.reloadList();
            }
	}); 
	$("#newType").val('0');
}

$(document).ready(function() {
    fnObj.pageStart();
	$('#searchGrid').click(function(){fnObj.searchGrid()})

	$('#save').click(function(){save()})
	$('#remove').click(function(){remove()})
	$('#initial').click(function(){clearForm()})
	$('#newCode').click(function(){newForm()})
	

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
<h2>코드관리<!--<span class="text">한림성심대학교 학사생정지원시스템 코드 관리 입니다.</span>--></h2>
<p class="location"> C > 지원자 관리 > 지원자 관리</p>

<section >
<div class="tbl_insert ">
		<table class="data_tableH">
			<caption></caption>
			<colgroup>
				<col width="20%" />
				<col width="*" />
			</colgroup>
			<tbody>
			<tr>
				<th scope="row">코드그룹</th>
				<td>
					<select class="select_size04" style="width:180px;margin-bottom:2px;" name='pGrpCd' id='pGrpCd'>
						<option value="" selected="">선택</option>
						<c:forEach var="list" items="${codeGroup}" varStatus="listCount">
							<option value="${list.grpCd}" >${list.grpNm}</option>
						</c:forEach>
					</select>
					<button id='searchGrid' class="btn_searchPare10 Ml10 va_middle">조회</button>
				</td>
			</tr>
			</tbody>
		</table>
</div>
			</section>
<form id='frm' method="post">
<input type="hidden" id="newType" name="newType" value="0" />
<input type="hidden" id="selColumn" name="selColumn" value="" />

<div class="tbl_insert posi_re">
	<div class="table_le border2">
		<h3>
			코드목록
		</h3>
			<div id="AXGridTarget" style="height:400px;"></div>
		</div>
		<div class="table_ri btn_size" >
		<h3 >
			코드 관리 정보
			<button id="initial" class="btn_searchPare10 Mt10" style="float:right; margin-right:10px">초기화</button>
			<button id="save" class="btn_searchPare Mt10" style="float:right; margin-right:10px">저장</button>
			<button id="remove" class="btn_searchPare10  Mt10" style="float:right; margin-right:10px">삭제</button>
			<button id="newCode" class="btn_searchPare Mt10 " style="float:right; margin-right:10px">신규</button>
		</h3>
	
		<!-- <table class="data_tableW02" style="height:400px;"> -->
		<table class="data_tableW02">
			<caption></caption>
			<colgroup>
				<col width="20%" />
				<col width="" />
				<col width="20%" />
				<col width="" />
			</colgroup>
			<tr>
				<th scope="col">그룹코드</th>
				<td><input type="text" name="grpCd" id="grpCd" class="only" readonly="readonly" /> </td>
				<th scope="col">그룹명</th>
				<td><input type="text" name="grpNm" id="grpNm" class="only" readonly="readonly"/> </td>
			</tr>
			<tr>
				<th scope="col">코드</th>
				<td><input type="text" name="cmCd" id="cmCd" class="select_size01" maxlength="10" onkeyup="inputLengthCheck(this);" /> </td>
				<th scope="col">표시순서</th>
				<td><input type="text" name="cdSeq" id="cdSeq"  /> </td>
			</tr>
			<tr>
				<th scope="col">코드명</th>
				<td colspan='3'><input type="text" name="cmNm" id="cmNm" class="select_size01" maxlength="50" onkeyup="inputLengthCheck(this);" /> </td>
			</tr>
			<tr>
				<th scope="col">사용여부</th>
				<td colspan='3'>
					<select class="select_size06" name='isUse' id='isUse'>
						<option value="" >선택</option>
						<option value="Y" >Y</option>
						<option value="N" >N</option>
					</select>
				</td>
			</tr>
			<!-- <tr>
				<th scope="col">숫자항목1</th>
				<td><input type="text" name=val1 id="val1" class="select_size01" maxlength="50" onkeyup="inputLengthCheck(this);" /> </td>
				<th scope="col">숫자항목2</th>
				<td><input type="text" name="val2" id="val2" maxlength="50" /> </td>
			</tr>
			<tr>
				<th scope="col">숫자항목3</th>
				<td><input type="text" name="val3" id="val3" class="select_size01" maxlength="50" onkeyup="inputLengthCheck(this);" /> </td>
				<th scope="col">사용여부</th>
				<td>
					<select class="select_size06" name='isUse' id='isUse'>
						<option value="" >선택</option>
						<option value="Y" >Y</option>
						<option value="N" >N</option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="col">기타1</th>
				<td colspan='3'><input type="text" name="etc1" id="etc1" class="select_size01" maxlength="500" onkeyup="inputLengthCheck(this);" /> </td>
			</tr>
			<tr>
				<th scope="col">기타2</th>
				<td colspan='3'><input type="text" name="etc2" id="etc2" class="select_size01" maxlength="500" onkeyup="inputLengthCheck(this);" /> </td>
			</tr> -->
		</table>
	</div>
</div>
</form>
</body>
</html>

