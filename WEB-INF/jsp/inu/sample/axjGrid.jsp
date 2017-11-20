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
<script type="text/javascript" src="<c:url value='/js/axisj/dist/AXJ.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXGrid.js'/>"></script>
<script type="text/javaScript" language="javascript">
/**
 * Require Files for AXISJ UI Component...
 * Based		: jQuery
 * Javascript 	: AXJ.js, AXGrid.js, AXInput.js, AXSelect.js
 * CSS			: AXJ.css, AXGrid.css, AXButton.css, AXInput.css, AXSelecto.css
 */	
var pageID = "AXGrid";
var fnObj = {
	pageStart: function(){
//        axf.readyMobileConsole();

        fnObj.grid.bind();
	},
	grid: {
        target: new AXGrid(),
        bind: function(){
            window.myGrid = fnObj.grid.target;

            var getColGroup = function(){
                return [
					{key:"rn", label:"번호", width:"50", align:"right"},
                    {key:"grpCd", label:"grpCd", width:"50", align:"center"},
                    {key:"cmCd", label:"cmCd", width:"50", align:"right"},
                    {key:"grpNm", label:"능력단위", width:"50", align:"right"},
                    {key:"cmNm", label:"NCS선정기준", width:"50", align:"right"},
                    {key:"cdSeq", label:"cdSeq", width:"50", align:"right"},
                    {key:"isUse", label:"isUse", width:"50", align:"right"},
                    {key:"isDel", label:"isDel", width:"50", align:"right"},
                    {key:"inDate", label:"등록일", width:"50", align:"right"}
                ];
            };

            myGrid.setConfig({
                targetID : "AXGridTarget",
                sort: true, //정렬을 원하지 않을 경우 (tip
                colHeadTool: true, // column tool use
                fitToWidth: true, // 너비에 자동 맞춤
                colGroup : getColGroup(),
                colHeadAlign: "center", // 헤드의 기본 정렬 값. colHeadAlign 을 지정하면 colGroup 에서 정의한 정렬이 무시되고 colHeadAlign : false 이거나 없으면 colGroup 에서 정의한 속성이 적용됩니다.
                body : {
                    onclick: function(){
                        //trace(myGrid.config.colGroup[this.c]);
                        toast.push(Object.toJSON({index:this.index, r:this.r, c:this.c, item:this.item}));
                        //alert(this.list);
                        //alert(this.page);
                    },
                    /* ondblclick 선언하면 onclick 이벤트가 0.25 초 지연 발생 됩니다. 주의 하시기 바람니다. */
                    ondblclick: function(){
                        toast.push("더블클릭");
                        //toast.push(Object.toJSON({index:this.index, r:this.r, c:this.c, item:this.item}));
                        //alert(this.list);
                        //alert(this.page);
                    },
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
                	paging:true,
					pageNo:1,
					pageSize:10,
					status:{formatter: null}
                }
            });

            //myGrid.setList(list);
            myGrid.setList({
                //ajaxUrl:"gridData.json", ajaxPars:"param1=1&param2=2", onLoad:function(){
                ajaxUrl:"/biz/gridDataPage.do", ajaxPars:"sqlId=common.selectShcmcd", onLoad:function(){
                    //trace(this);
                }
            });            
            //trace(myGrid.getSortParam());

        },
        getExcel: function(type){
        },
        getSelectedItem: function(){
        }
    }
};
$(document).ready(function() {
//jQuery(document.body).ready(function() {
    fnObj.pageStart();

});
</script>
</head>
<body>
	<!-- content 시작 -->
	<div id="content_pop">
		<div class="title">
			<h1>AXGrid</h1>
		</div>
		<h2>그리드 기본 예제입니다.</h2>

		<div id="AXGridTarget" style="height: 300px;"></div>
	</div>
	<!-- //content 끝-->
</body>
</html>

