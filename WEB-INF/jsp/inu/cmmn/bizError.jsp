<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @JSP Name : bizError.jsp
  * @Description : 일반 에러화면
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="content-language" content="ko">
<title>error:<spring:message code="error.error" /></title>
<link type="text/css" rel="stylesheet"
	href="<c:url value='/css/egovframework/egov.css'/>">
</head>
<body>
	<%-- <!-- 전체 레이어 시작 -->
	<div id="wrap">
		<!-- header 시작 -->
		<div id="header"><%@ include
				file="/WEB-INF/jsp/inu/com/header.jsp"%></div>
		<!-- //header 끝 -->
		<!-- container 시작 -->
		<div id="container">
			<!-- 좌측메뉴 시작 -->
			<div id="leftmenu"><%@ include
					file="/WEB-INF/jsp/inu/com/leftmenu.jsp"%></div>
			<!-- //좌측메뉴 끝 -->



			<!-- content 시작 -->
			<div id="content_pop">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td align="center" valign="top">
							<table width="600" border="0" cellpadding="0" cellspacing="0"
								background="<c:url value='/images/egovframework/error/blue_bg.jpg'/>">
								<tr>
									<td align="center"><table width="100%" border="0"
											cellspacing="9" cellpadding="0">
											<tr>
												<td bgcolor="#FFFFFF"><table width="100%" border="0"
														cellspacing="0" cellpadding="0">
														<tr>
															<td align="left"><img
																src="<c:url value='/images/egovframework/error/er_logo.jpg'/>"
																width="379" height="57"
																alt="<spring:message code="alt.error.viewImg" />" /></td>
														</tr>
														<tr>
															<td><br /> <br /></td>
														</tr>

														<tr>
															<td align="center"><table width="520" border="0"
																	cellspacing="2" cellpadding="2">
																	<tr>
																		<td width="74" rowspan="2" align="center"><img
																			src="<c:url value='/images/egovframework/error/danger.jpg'/>"
																			width="74" height="74"
																			alt="<spring:message code="alt.image" />" /></td>
																		<td width="399" align="left" class="board_title"><spring:message
																				code="error.msg.unknown" /></td>
																	</tr>
																</table></td>
														</tr>
													</table> <br /></td>
											</tr>
										</table></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>

			</div>
			<!-- //content 끝-->
		</div>
		<!-- //container 끝-->
		<!-- footer 시작 -->
		<div id="footer"><%@ include
				file="/WEB-INF/jsp/inu/com/footer.jsp"%></div>
		<!-- //footer 끝 -->
	</div>
	<!--// 전체 레이어 끝 --> --%>
	<!-- 150708 스타일 추가 S-->
	<style>
		a:link {color:#fff;}
		.error_pg{text-align:center;padding:10px 0;}
		.btn_block08{padding:50px 25px 0;text-align:center;font-weight:bold;color:#fff;}
		.btn_block08 a:hover{color:#3A5870;}
		.btn12{background:#0166b3;border:1px solid #015ca1;padding:15px 30px;margin:0 5px;}
		.btn13{background:#00aaad;border:1px solid #019598;padding:15px 40px;margin:0 5px;}
	</style>
	<!-- 150708 스타일 추가 E-->

	<!-- //좌측메뉴 끝 -->
	<!-- 150708 S -->
	<div class="contents">
		<div class="error_pg">
			<img src="/images/error_page.png" alt="오류페이지" />
		</div>
		<div style="text-align:center;font-weight:bold;font-size:15px;">오류사유&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="error.msg.unknown" /></div>
		<div class="btn_block08">
			<a href="javascript:history.back();" class="btn12">&lt;&nbsp;&nbsp;&nbsp;이전페이지</a>
			<a href="/system/loginView.do" class="btn13">홈으로&nbsp;&nbsp;&nbsp;&gt;</a>
		</div>
	</div>
	<!-- 150708 E-->
</body>
</html>
