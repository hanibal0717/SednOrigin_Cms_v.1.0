<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
    /**
			 * @JSP Name : menu.jsp
			 * @Description : 관리자 메뉴 등록 화면
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

 -->
<style>
</style>
<script type="text/javascript" src="<c:url value='/js/axisj/dist/AXJ.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/axisj/lib/AXGrid.js'/>"></script>
</head>
	
<body>
<h2>메뉴관리</h2>
<p class="location"> 시스템관리 > 메뉴관리</p>

<section>
				<div class="tbl_insert">
					<table class="data_tableH">
						<caption></caption>
						<colgroup>
							<col width="20%" />
							<col width="*" />
						</colgroup>
						<tbody>
						<tr>
							<th scope="row">시스템구분</th>
							<td>
								<select class="select_size04" style="width:180px" name='sysCode' id='sysCode'>
									<option value="" selected="">선택</option>
								</select>
							</td>
						</tr>
						</tbody>
					</table>
				</div>
			</section>
			
<form name="frm" id="frm" method="post" >

			<p class="btn_block">
				<span class="btn_type01 btn"><a href="#" id="add">신규</a></span>
				<span class="btn_type01 btn"><a href="#" id="save">저장</a></span>
				<span class="btn_type05 btn"><a href="#" id="remove">삭제</a></span>
			</p>
<div class="tbl_insert posi_re">
<div class="table_le ">
<h3>메뉴목록</h3>
<div id="AXTreeTarget" style="height:400px;"></div>

</div>
<div class="table_ri" >
<!-- style="display: block; float: left; width: 400px;" class="table_ri" -->
			<section >
				<h3>메뉴정보관리</h3>
				<div class="tbl_insert">
					<table class="data_tableW02">
						<caption></caption>
						<colgroup>
							<col width="28%" />
							<col width="*" />
						</colgroup>
						<tr>
							<th scope="col">상위메뉴</th>
							<td><span id="upMenu"></span> </td>
						</tr>
						<tr>
							<th scope="col">순서</th>
							<td><input type="text" name="no" id="no" pno="" class="only" readOnly /> 
							<input type="hidden" name="pno" id="pno"/>
							<input type="hidden" name="sysCode" id="psysCode"/>
							</td>
						</tr>
						<tr>
							<th scope="col">메뉴명</th>
							<td><input type="text" name="menuName" id="menuName"  class="textInput_size03" maxlength="50" onkeyup="inputLengthCheck(this);" /> </td>
						</tr>
						<tr>
							<th scope="col">메뉴url</th>
							<td><input type="text" name="menuPath" id="menuPath"  class="textInput_size03" maxlength="100" onkeyup="inputLengthCheck(this);" /> </td>
						</tr>
						<tr>
							<th scope="col">설명</th>
							<td><input type="text" name="menuTxt" id="menuTxt"  class="textInput_size03" maxlength="200" onkeyup="inputLengthCheck(this);" /> </td>
						</tr>
					</table>
					<table class="data_tableW02">
						<caption></caption>
						<colgroup>
							<col width="18%" />
							<col width="10.1%" />
							<col width="*" />
						</colgroup>
						<tr>
							<th scope="col" rowspan="2">서브메인가이드</th>
							<th scope="col">이미지</th>
							<td colspan="5">
								<input type="file" name="file_1" id="egovComFileUploader" class="input-file"  />
							</td>
						</tr>
						<tr>
							<th scope="col">텍스트</th>
							<td colspan="5">
								<textarea id="cont" name="cont" class="edt_base" class="textInput_size01" rows="5" cols="30"></textarea>
							</td>
						</tr>
						<tr>
							<th scope="col" colspan="2">타이틀1</th>
							<td><input type="text" id="" name="" /></td>
							<th scope="col">사용여부</th>
							<td>
								<select id="" name="">
							 		<option value="Y">Y</option>
							 		<option value="N">N</option>
							 	</select>
							</td>
							<th scope="col">영상갯수</th>
							<td>
								<select id="" name="">
							 		<c:forEach var="i" begin="0" end="15">
									<option value="${i}">${i}</option>
									</c:forEach>
							 	</select>
							</td>
						</tr>
						<tr>
							<th scope="col" colspan="2">타이틀2</th>
							<td><input type="text" id="" name="" /></td>
							<th scope="col">사용여부</th>
							<td>
								<select id="" name="">
							 		<option value="Y">Y</option>
							 		<option value="N">N</option>
							 	</select>
							</td>
							<th scope="col">영상갯수</th>
							<td>
								<select id="" name="">
							 		<c:forEach var="i" begin="0" end="15">
									<option value="${i}">${i}</option>
									</c:forEach>
							 	</select>
							</td>
						</tr>
						<tr>
							<th scope="col" colspan="2">타이틀3</th>
							<td><input type="text" id="" name="" /></td>
							<th scope="col">사용여부</th>
							<td>
								<select id="" name="">
							 		<option value="Y">Y</option>
							 		<option value="N">N</option>
							 	</select>
							</td>
							<th scope="col">영상갯수</th>
							<td>
								<select id="" name="">
							 		<c:forEach var="i" begin="0" end="15">
									<option value="${i}">${i}</option>
									</c:forEach>
							 	</select>
							</td>
						</tr>
					</table>
				</div>
			</section>
		</div>
</div>
</form>

	
</body>
</html>

