<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil" %>
<%@page import="vcms.common.egov.EgovUserInfoVO" %>

<%@ include file="/WEB-INF/jsp/inu/ncs/bbs/bbs_master_info.jsp" %>
<%
	pageContext.setAttribute("LF", "\n");
%> 
 			
 			
 			<h3>덧글달기<span>총 ${fn:length(bbsCommentList) } 건</span></h3>
					<div class="tbl_insert">
						<table class="data_tableW02">
						<caption></caption>
						<colgroup>
							<col width="120px" />
        					<col width="*" />
        					<col width="120px" />
        					<col width="120px" />
						</colgroup>
						<tr class="write_rep">
							<th scope="col">덧글작성</th>
							<td colspan="3" style="height:80px;">
								<fieldset class="write">
									<legend>덧글달기</legend>
									<div>
										<label for="comm" class="invisible">덧글쓰기</label>
										<textarea id="comm" name="comm" style="width:83%">${commentInfo.comm }</textarea>
										<!-- <span class="limit">현재 0byte/최대 000byte</span> -->
										<c:choose>
											<c:when test="${ empty commentInfo.commentIdx }">
												<a href="#" onclick="fn_addComment();" class="btn_reple">덧글달기</a>	
											</c:when>
											<c:otherwise>
												<a href="#" onclick="fn_modifyProcComment('${commentInfo.commentIdx }');" class="btn_reple">덧글수정</a>
											</c:otherwise>
										</c:choose>
									</div>
								</fieldset>							
							</td>
						</tr>
						<tr>
							<td class="rep_tit" style="text-align:center;background:#e7e7e7;" colspan="4"><strong>덧글내용</strong></td>
						</tr>
						<c:forEach items="${bbsCommentList}" var="item" varStatus="i">
						<tr>
							<th>${item.regNm }</th>
							<td>${fn:replace(item.comm, LF, '<br />')} </td>
							<td>
								${fn:substring(item.regDt,0,10) }
							</td>
							<td style="padding:0; text-align:center;">
								<a href="#" onclick="fn_modifyComment('${item.commentIdx }');" class="btnS01">수정</a>
								<a href="#" onclick="fn_deleteComment('${item.commentIdx }');" class="btnS01">삭제</a>			
							</td>
						</tr>
						</c:forEach>
						</table>
					</div> 	

 