<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="vcms.common.util.StringUtil" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%

/**
  * @Class Name : EgovFileList.jsp
  * @Description : 파일 목록화면
  * @Modification Information
  * @
  * @  수정일   	수정자		수정내용
  * @ ----------	------		---------------------------
  * @ 2009.03.26	이삼섭		최초 생성
  * @ 2011.07.20	옥찬우		<Input> Tag id속성 추가( Line : 68 )
  *
  *  @author 공통서비스 개발팀 이삼섭
  *  @since 2009.03.26
  *  @version 1.0
  *  @see
  *
  */
%>
<%
String dataIdx     = (String)request.getAttribute("dataIdx");
List<Map<String , Object>> fileList = (List)request.getAttribute("fileList_"+ dataIdx);
String imgTypeList = (String)request.getAttribute("imgTypeList");
String updateFlag  = (String)request.getAttribute("updateFlag");
int    fileListCnt = (Integer)request.getAttribute("fileListCnt_"+dataIdx);


String fileGubun = ""; 
String attachIdx = "";
String orgFileNm    = "";
int    index     = 0;
String fileExt   = "";

%>
<!-- link href="<c:url value='/css/egovframework/com/com.css' />" rel="stylesheet" type="text/css"-->

<script type="text/javascript">

	function fn_egov_downFile(bbs_mst_idx, data_idx, attach_idx){
		window.open("<c:url value='/banner/fileDown.do?bbs_mst_idx="+bbs_mst_idx+"&data_idx="+data_idx+"&attach_idx="+attach_idx+"'/>");
	}

	function fn_egov_deleteFile(bbs_mst_idx, data_idx, attach_idx) {
		forms = document.getElementsByTagName("frm");

		for (var i = 0; i < forms.length; i++) {
			if (typeof(forms[i].bbs_mst_idx) != "undefined" &&
					typeof(forms[i].data_idx) != "undefined" &&
					typeof(forms[i].fileListCnt) != "undefined") {
				form = forms[i];
			}
		}

		//form = document.forms[0]; 
		form.attach_idx.value = attach_idx;
		form.action = "<c:url value='/banner/deleteFileInfs.do'/>";
		form.submit();
	}

	function fn_egov_check_file(flag) {
		if (flag=="Y") {
			document.getElementById('file_upload_posbl').style.display = "block";
			document.getElementById('file_upload_imposbl').style.display = "none";
		} else {
			document.getElementById('file_upload_posbl').style.display = "none";
			document.getElementById('file_upload_imposbl').style.display = "block";
		}
	}
</script>

<!-- <form name="fileForm" action="" method="post" > -->

<input type="hidden" name="attach_idx" >
<!--  <input type="hidden" name="fileListCnt" id="fileListCnt" value="<%=fileListCnt%>">-->
<!--</form>-->


<% 

if( fileList != null){
	for(int i=0; i<fileList.size(); i++){
		fileGubun = StringUtil.nvl(fileList.get(i).get("fileGubun"));
		dataIdx   = String.valueOf(fileList.get(i).get("dataIdx"));
		attachIdx = StringUtil.nvl(fileList.get(i).get("attachIdx"));
		orgFileNm = StringUtil.nvl(fileList.get(i).get("orgFileNm"));
		
%>
<a href="#" onclick="javascript:fn_egov_downFile('<%=fileGubun %>','<%=dataIdx %>','<%=attachIdx%>')"><%=orgFileNm %></a>
<%	 
		if( "Y".equals(updateFlag)){
%>		
			<img src="<c:url value='/images/icon/bu5_close.gif' />" 
				width="19" height="18" onClick="fn_egov_deleteFile('<%=fileGubun %>','<%=dataIdx %>','<%=attachIdx%>');" alt="파일삭제" />
<%		
		}
%>
<br />
<%
	}
}
%>		
 