<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="vcms.common.util.StringUtil" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%
Map<String ,Object>  bbsMstInfo = (Map)request.getAttribute("bbsMstInfo");

String bbsMstIdx = "";
String attachUseYn = "";
String privateUseYn = "";
String bbsNm = "";
String mstNoticeYn = "";
String templIdx = "";
int attachCnt = 0;
String fixedDataYn = "";
String commentUseYn = "";
String authBtnYn = "";
String hotImgYn = "";
String newImgYn = "";
int hotImgCnt = 0;
int newImgDt = 0;
String locationNm = "";
String[] _tmpArr = null;
String cateUseYn = "";

//게시판 마스터 정보 
if( bbsMstInfo != null ){
	bbsMstIdx   = StringUtil.nvl(bbsMstInfo.get("bbsMstIdx"),"");
	attachUseYn = bbsMstInfo.get("attachUseYn").toString();	// 첨부파일여부
	attachCnt   = StringUtil.nvlForInt(bbsMstInfo.get("attachCnt").toString(),0);	// 첨부파일제한수
	privateUseYn= StringUtil.nvl(bbsMstInfo.get("privateUseYn"),"N");	// 비밀글사용여부
	bbsNm       = StringUtil.nvl(bbsMstInfo.get("bbsNm"),"");
	mstNoticeYn = StringUtil.nvl(bbsMstInfo.get("noticeYn"),""); 	// 공지 기능여부
	templIdx    = StringUtil.nvl(bbsMstInfo.get("templIdx"),"");	// 게시판유형
	fixedDataYn = StringUtil.nvl(bbsMstInfo.get("fixedDataYn"),""); 	// 고정글여부
	commentUseYn= StringUtil.nvl(bbsMstInfo.get("commentUseYn"),""); 	// 덧글사용여부
	authBtnYn   = StringUtil.nvl(bbsMstInfo.get("authBtnYn"),""); 	// 덧글사용여부
	hotImgYn    = StringUtil.nvl(bbsMstInfo.get("hotImgYn"),""); 	// HOT 아이콘 설정
	hotImgCnt   = StringUtil.nvlForInt(bbsMstInfo.get("hotImgCnt").toString(),0); 	// 덧글사용여부
	newImgYn    = StringUtil.nvl(bbsMstInfo.get("newImgYn"),""); 	// NEW 아이콘 설정
	newImgDt    = StringUtil.nvlForInt(bbsMstInfo.get("newImgDt").toString(),0);; 	//  최근 * 일 이내
	locationNm  = StringUtil.nvl(bbsMstInfo.get("locationNm"),"");
	cateUseYn   = StringUtil.nvl(bbsMstInfo.get("cateUseYn"),"");  
	 
	
}
%>