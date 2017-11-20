<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
    /**
	 * @JSP Name : groupMember.jsp
	 * @Description : 그룹사용자 화면
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


<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXConfig.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXJ.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXCore.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXUtil.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXGrid.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXTree.js'/>"></script>

<script type="text/javascript" src="http://dev.axisj.com/dist/AXJ.min.js"></script>
 -->
<style>
</style>

<script type="text/javascript" src="<c:url value='/js/axisj/dist/AXJ.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXGrid.js'/>"></script>

<script>
/**
 * Require Files for AXISJ UI Component...
 * Based		: jQuery
 * Javascript 	: AXJ.js, AXGrid.js, AXInput.js, AXSelect.js
 * CSS			: AXJ.css, AXGrid.css, AXButton.css, AXInput.css, AXSelecto.css
 */	
	var pageID = "AXTree";
	var myGrid2 = new AXGrid();
	var myGrid = new AXGrid();
	var fnObj = {
		pageStart: function(){
			fnObj.grid1();fnObj.grid2();
		},
		
		grid1: function(){

	var getColGroup = function(){ return [

{key:"no", label:"선택", width:"50", align:"center", formatter:"radio"
	//, checked:function(){
    //return this.item.___checked && this.item.___checked["1"];}
//editor: { type: "checkbox",beforeUpdate: function(val){ return val; } } 
},
{key:"groupSeq", label:"", width:"40", align:"center", display : false },
{key:"groupNm", label:"그룹이름", width:"200", align:"", disable: true,  },
/*
{key:"test", label:" ", width:"40", align:"center", disable: true, 
	formatter: function(){ return '<span onclick="fnObj.searchGrid3('+this.index+','+this.item.groupSeq+')">선택</span>'; }  
},
*/
];
	};

	myGrid.setConfig({
		targetID : "AXGridTarget",
		sort: true, //정렬을 원하지 않을 경우 (tip
		colHeadTool: true, // column tool use
		//fitToWidth: true, // 너비에 자동 맞춤
		passiveMode:true,
		passiveRemoveHide:false,		   
		
		colGroup : getColGroup(),
		colHeadAlign: "center", // 헤드의 기본 정렬 값. colHeadAlign 을 지정하면 colGroup 에서 정의한 정렬이 무시되고 colHeadAlign : false 이거나 없으면 colGroup 에서 정의한 속성이 적용됩니다.
		body : {
			onclick:function(idx, item){
				fnObj.searchGrid3(this.item, idx);
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
	grid2 : function(){
		var getColGroup = function(){
                return [
					{key:"no", label:"선택", width:"53", align:"center"
						//, formatter:"checkbox" , checked:function(){ return this.item.___checked && this.item.___checked["0"];}
						,editor: { type: "checkbox" , beforeUpdate: function(val){ // 수정이 처리된 후
									this.item.noF = (val == true ? '1' : '0'); return val;
						}} 	
					},
                    {key:"memberId", label:"아이디", width:"120", align:"center"},
                    {key:"department", label:"부서", width:"210", align:"center"},
                    {key:"userNm", label:"이름", width:"150", align:"center"},
                    {key:"groupSeq", label:"groupSeq", width:"45", align:"right", display : false},
                    {key:"noF", label:"", width:"80", display : false },
                ];
            };

            myGrid2.setConfig({
                targetID : "AXGridTarget2",
                sort: true, //정렬을 원하지 않을 경우 (tip
                colHeadTool: false, // column tool use
                fitToWidth: false, // 너비에 자동 맞춤
                
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

                    }
                },
                page: {
                	paging:false,
					//pageNo:1,
					//pageSize:10,
					status:{formatter: null}
                }
            });
            
	},
	searchGrid: function(){
		var param = '&groupNm='+$('#groupNm').val();
        myGrid.setList({
	    	ajaxUrl:"/biz/gridData.do", ajaxPars:"sqlId=system.selectGroupMemberY"+param, onLoad:function(){
	        	//trace(this);
	    	}
		});            
	},
	searchGrid2: function(gb){
		var list = myGrid.getCheckedList(0);
		if(list.length == 0 ){
			alert('그룹을 선택하세요.'); return;
		}
		
		var sid = 'sqlId=system.selectMemberInGroup';
		var param = '&groupSeq='+list[0].groupSeq;
		param += '&searchTxt='+$('#searchTxt').val();
		
        myGrid2.setList({
	    	ajaxUrl:"/biz/gridData.do", ajaxPars:sid+param, onLoad:function(){
	        	//trace(this);
	        	myGrid2.setStatus(this.list.length);
	    	}
		});            
	},
	
	searchGrid3: function(obj, idx){
		myGrid.checkedColSeq(0, true, idx);
		fnObj.searchGrid2(obj.groupSeq)
	}
	
};


function saveMember(){
	
	var list = myGrid2.getList("C,U,D", true); var cnt = 0
	for(var i = 0; i < list.length ; i++){
		if(list[i].no == 1) {
			 cnt++
		}
	}

	if(list.length == 0 ){
		alert('변경건이 없습니다.'); return;
	}
	
	var checkedList = myGrid.getCheckedListWithIndex(0);// colSeq
	$.each(checkedList, function( index, value ) {
		$('#groupSeq').val(value.item.groupSeq);
	});
	
	
	$('#gridData').val(list.axtoJSON());

	$.ajax({
            url:'/system/saveGroupMember.do',
            type:'post',
            data:$('#frm').serialize(),
            success:function(data){
                alert(data.msg);
                 myGrid2.reloadList();
            }
	});
}

$(document).ready(function() {
    fnObj.pageStart();
	$('#searchGrid').click(function(){fnObj.searchGrid()})
	$('#searchGrid2').click(function(){fnObj.searchGrid2()})

	$('#saveMember').click(function(){saveMember()})

});
</script>

</head>
	
<body>
<h2>관리자 그룹 사용자</h2>
<p class="location"></p>

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
					<input type="text" name="groupNm" id="groupNm" /><button id='searchGrid' class="btn_searchPare10 Ml10 va_middle">조회</button>
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
				<th scope="row">아이디/이름</th>
				<td>
					<input type="text" name="searchTxt" id="searchTxt" /><button id='searchGrid2' class="btn_searchPare10 Ml10 va_middle">대상자 조회</button>
				</td>
			</tr>
			</tbody>
		</table>
	</div>
</div>
</section>
			
<div class="tbl_insert posi_re">
	<div class="table_le border2"  >
	<h3>
		그룹목록
	</h3>
		<div id="AXGridTarget" style="height:400px;"></div>
	</div>
	<div class="table_ri btn_size" >
	<h3 >
		사용자 목록
		<button id="saveMember" class="btn_searchPare Mt10" style="float:right;margin-right:10px">저장</button>
	</h3>
		<div id="AXGridTarget2" style="height:400px;"></div>
	</div>
</div>
<form id='frm' method="post">
	<input type="hidden" name="gridData" id="gridData"/>
	<input type="hidden" name="groupSeq" id="groupSeq"/>
</form>
</body>
</html>