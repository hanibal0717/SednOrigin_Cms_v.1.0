<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
    /**
			 * @JSP Name : EgovMain.jsp
			 * @Description : 메인 화면
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
<script type="text/javascript" src="http://dev.axisj.com/lib/AXGrid.js"></script>
 -->
<script type="text/javascript" src="<c:url value='/js/axisj/dist/AXJ.min.js'/>"></script>
	<script>
	/**
	 * Require Files for AXISJ UI Component...
	 * Based		: jQuery
	 * Javascript 	: AXJ.js, AXGrid.js, AXInput.js, AXSelect.js
	 * CSS			: AXJ.css, AXGrid.css, AXButton.css, AXInput.css, AXSelector.css
	 */	
	var pageID = "passive";

    var myGrid = new AXGrid();
    var fnObj = {
        pageStart: function(){

            myGrid.setConfig({
                targetID : "AXGridTarget",
                theme : "AXGrid",
                //fixedColSeq : 4,
                fitToWidth:true,
                passiveMode:true,
                passiveRemoveHide:false,
                colHeadAlign: "center",
                colGroup : [
                    {
                        key:"no", label:"NO", width:"30", align:"center", formatter:"checkbox",
                        //displayLabel:true, 헤드란에 체크박스를 표시 할지 여부
                        checked:function(){
                            //사용 가능한 변수
                            //this.index
                            //this.item
                            //this.list
                            //return (this.index % 2 == 0);
                            return false;
                        }
                    },
                    {
                        key:"status", label:"상태", width:"40", align:"center", formatter:function(){
                        if(this.item._CUD == "C"){
                            return "신규";
                        }else if(this.item._CUD == "D"){
                            return "삭제";
                        }else if(this.item._CUD == "U"){
                            return "수정";
                        }
                    }
                    },
                    {key:"code", label:"code", width:"80", editor: {type: "text"} },
                    {key:"codeVal", label:"code값", width:"80", align:"left", editor: {type: "text"} 
                    , formatter:function(){
                    	var pp = (this.item.codeVal == null) ? '' : this.item.codeVal;
                    	console.log(pp)
                    	return pp;
                    }
                    },
                    {key:"codeValNm", label:"code값명", width:"120", align:"left" , editor: {type: "text"} },
                    {key:"codeSort", label:"순서", width:"40", align:"center", editor: {type: "text"} },
                    {key:"delYn", label:"삭제", width:"40", align:"center", editor: {type: "text"} },

                ],
                body : {
                    addClass: function(){
                        if(this.item._CUD == "C"){
                            return "blue";
                        }else if(this.item._CUD == "D"){
                            return "red";
                        }else if(this.item._CUD == "U"){
                            return "green";
                        }else{
                            return "";
                        }
                    },
                    onclick: function(){
                        //toast.push(Object.toJSON({index:this.index, r:this.r, c:this.c, item:this.item}));
                        //myGrid.setEditor(this.item, this.index);
                    },
                    ondblclick: function(){
                        //toast.push(Object.toJSON({index:this.index, r:this.r, c:this.c, item:this.item}));
                    },
                    oncheck: function(){
                        //사용 가능한 변수
                        //this.itemIndex
                        //this.target
                        //this.checked
                        //this.r
                        //this.c
                        //this.list
                        //this.item
                        trace(this.checked);
                    }
                },
                page:{
                    paging:false,
                    status:{formatter: null}
                },
                
            });
	    	
            
            myGrid.setList({
                ajaxUrl:"/biz/gridData.do", ajaxPars:"sqlId=common.selectTB_CODE", onLoad:function(){
                }
            });
            

        },
        appendGrid: function(index){
            var item = {};
            if(index){
                myGrid.appendList(item, index);
            }else{
                myGrid.pushList(item);
            }
            myGrid.setFocus(myGrid.list.length-1);
        },
        removeList: function(){
            var checkedList = myGrid.getCheckedListWithIndex(0);// colSeq
            if(checkedList.length == 0){
                alert("선택된 목록이 없습니다. 삭제하시려는 목록을 체크하세요");
                return;
            }
            /// something do for server
            trace(checkedList);

            myGrid.removeListIndex(checkedList); // 전달한 개체와 비교하여 일치하는 대상을 제거 합니다. 이때 고유한 값이 아닌 항목을 전달 할 때에는 에러가 발생 할 수 있습니다.
        },
        restoreList: function(){
            var checkedList = myGrid.getCheckedList(0);// colSeq
            if(checkedList.length == 0){
                alert("선택된 목록이 없습니다. ");
                return;
            }
            /// something do for server

            var removeList = [];
            $.each(checkedList, function(){
                removeList.push({no:this.no});
            });
            trace(removeList);
            myGrid.restoreList(removeList); // 전달한 개체와 비교하여 일치하는 대상을 제거 합니다. 이때 고유한 값이 아닌 항목을 전달 할 때에는 에러가 발생 할 수 있습니다.
        },
        save: function(){
	        $.ajax({
	            url: "/biz/saveGrid.do",
	            type: "POST",
	            cache:false,
	            timeout : 30000, 
	            dataType:"json",
	            data: 'TB_CODEGrid='+myGrid.getList("C,U,D", true).axtoJSON(),
	            success: function(data) {
	                alert('success');
	                //저장처리후 필요한 로직 
	            },
        	})
        },
    };

    jQuery(document.body).ready(function() {
        fnObj.pageStart();
    });
	</script>

	<style type="text/css">
	
	</style>
</head>
	
<body>

<div id="content_pop">

	<div id="AXPageBody" class="SampleAXSelect">
        <div id="demoPageTabTarget" class="AXdemoPageTabTarget"></div>
		<div class="AXdemoPageContent">
			<div class="title"><h1>AXGrid passive option true</h1></div>

            <h3>grid의 추가/수정/삭제 내역을 그리드에 유지 하고 변경 내역을 수동으로 취할 수 있는 방식 입니다.</h3>
            <div id="AXGridTarget" style="height:400px;"></div>

            <div class="H20"></div>

            <div style="padding:10px 0px;">
                <input type="button" value="추가하기" class="AXButton Red" onclick="fnObj.appendGrid();" />
                <input type="button" value="삭제하기" class="AXButton Red" onclick="fnObj.removeList();" />
                <input type="button" value="삭제취소" class="AXButton Red" onclick="fnObj.restoreList();" />
                <input type="button" value="새로고침" class="AXButton Red" onclick="myGrid.reloadList();" />
                <input type="button" value="save" class="AXButton Red" onclick="fnObj.save();" />
            </div>

            <div class="H20"></div>

            <div>
                <b>passiveMode:true </b> 사용시 <br/>
                _CUD : C(신규 등록된 item),
                _CUD : D(삭제된 item),
                _CUD : U(수정된 item)
                <br/>
                <b>passiveRemoveHide:true</b> 변경 하면 삭제될 때 리스트가 제거 됩니다. 또한 삭제된 데이터가 myGrid.removedList 에 쌓이게 됩니다.
                <br/>
                <br/>
                AXUtil.gridPassiveMode = true; 로 그리드 기본값을 설정 하실 수도 있습니다.<br/>
                AXUtil.gridPassiveRemoveHide = true; 로 그리드 기본값을 설정 하실 수도 있습니다.
            </div>

            <div style="padding:10px 0px;">
                <input type="button" value="list 추출" class="AXButton Green" onclick="AXUtil.alert(myGrid.list);" />
                <input type="button" value="removedList 추출" class="AXButton Green" onclick="AXUtil.alert(myGrid.removedList);" />
            </div>

		</div>
	</div>

</div>
	
</body>
</html>

