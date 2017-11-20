<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @Class Name : EgovImgFileList.jsp
  * @Description : 이미지 파일 조회화면
  * @Modification Information
  * @
  * @  수정일      수정자            수정내용
  * @ -------        --------    ---------------------------
  * @ 2009.03.31  이삼섭          최초 생성
  *
  *  @author 공통서비스 개발팀 이삼섭
  *  @since 2009.03.31
  *  @version 1.0
  *  @see
  *
  */
%>
<%@page import="vcms.common.util.StringUtil" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%

String dataIdx     = (String)request.getAttribute("dataIdx");
List<Map<String , Object>> fileList = (List)request.getAttribute("fileList_"+ dataIdx);
String imgTypeList = (String)request.getAttribute("imgTypeList");
String groupIdx    = request.getParameter("groupIdx");
int imgIndex =0;
if( groupIdx == null ){
	imgIndex = 10;
}
else {
	imgIndex = Integer.parseInt(groupIdx);
}

String bbsMstIdx = ""; 
String attachIdx = "";
String fileNm    = "";
int    index     = 0;
String fileExt   = "";

//System.out.println("imgFileList.jsp.............dataIdx="+dataIdx);
//System.out.println("imgFileList.jsp.............dataIdx="+(String)request.getAttribute("dataIdx"));

if( fileList != null){
	for(int i=0; i<fileList.size(); i++){
		bbsMstIdx = StringUtil.nvl(fileList.get(i).get("bbsMstIdx"));
		dataIdx   = StringUtil.nvl(fileList.get(i).get("dataIdx"));
		attachIdx = StringUtil.nvl(fileList.get(i).get("attachIdx"));
		fileNm    = StringUtil.nvl(fileList.get(i).get("orgFileNm"));
		
		//System.out.println(i+".....dataIdx="+dataIdx);
		
		index   = fileNm.lastIndexOf(".");
		fileExt = fileNm.substring(index + 1).toLowerCase();
		
		if( imgTypeList.lastIndexOf(fileExt) > -1 ){ 
%>
	
	<p style="text-align:center;margin-bottom:35px;">
	<img src='/bbs/file/getImage.do?bbs_mst_idx=<%=bbsMstIdx %>&data_idx=<%=dataIdx %>&attach_idx=<%=attachIdx %>'  alt="해당파일이미지" name="displayImg<%=imgIndex+i %>" onload="javascript:setImgFit(this, 350, '<%=imgIndex+i%>');" />
	</p>
<%		
		}
	}
}
%>
