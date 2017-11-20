<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
		frm.attach_idx.value = attach_idx;
		//console.warn("attach_idx :"+attach_idx);
		frm.action = "<c:url value='/banner/deleteFileInfs.do'/>";
		//frm.submit();
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

<!-- <form name="fileForm" action="" method="post" >  -->
<input type="hidden" name="attach_idx" >
<input type="hidden" name="bnIdx" value="${bnIdx }"/>
<input type="hidden" name="fileGubun" vaule="${fileGubun }"/>
<input type="hidden" name="returnUrl" value="${returnUrl }"/>

<!-- </form>  -->

<!--<title>파일목록</title> -->
 
	<table>
		<c:forEach var="fileVO" items="${fileList}" varStatus="status">
		<tr>
			<td>
			<c:choose>
				<c:when test="${updateFlag=='Y'}">
					<c:out value="${fileVO.orgFileNm}"/>
					<img src="<c:url value='/images/icon/bu5_close.gif' />" 
						width="19" height="18" onClick="fn_egov_deleteFile('<c:out value="${fileVO.bbsMstIdx}"/>','<c:out value="${fileVO.dataIdx}"/>','<c:out value="${fileVO.attachIdx}"/>');" alt="파일삭제">
				</c:when>
				<c:otherwise>
					<a href="#" onclick="javascript:fn_egov_downFile('<c:out value="${fileVO.bbsMstIdx}"/>','<c:out value="${fileVO.dataIdx}"/>','<c:out value="${fileVO.attachIdx}"/>')">
					<c:out value="${fileVO.orgFileNm}"/>
					</a>
				</c:otherwise>
			</c:choose> 
			</td>
		</tr>
		</c:forEach>
		<c:if test="${fn:length(fileList) == 0}">
			<tr>
				<td></td>
			</tr>
	    </c:if>
	</table>
