<%@page import="vcms.common.file.util.UvFileUtil"%>
<%@page import="vcms.ncs.util.VodDataUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="vcms.common.util.StringUtil"%>
<%@page import="vcms.common.egov.EgovUserInfoVO"%>
<%
	/**
	* @JSP Name : write.jsp
	* @Description : Image & Text 등록/수정
	* @Modification Information
	* 
	*       수정일         수정자         수정내용
	*  ----------------------------------------------
	*	2015.06.10	김승준	최초생성
	*
	* author 개발팀 
	* Copyright (C) 2011 by MOPAS  All right reserved.
	*/
%>
<%
	Map<String, Object> bbsDataInfo = (Map) request.getAttribute("bbsDataInfo");
	List<Map<String, Object>> bbsDataFile = (List) request.getAttribute("bbsDataFile"); // 썸네일

	List<Map<String, Object>> TAG_MENU = (List) request.getAttribute("TAG_MENU");

	List<Map<String, Object>> USER_MENU = (List) request.getAttribute("USER_MENU");
	List<Map<String, Object>> USER_MENU_MASTER = (List) request.getAttribute("USER_MENU_MASTER");

	String modeType = StringUtil.nvl(request.getParameter("modeType"), "");

	String text_idx = "";
	String title = "";
	String cont = "";
	String menu = "";
	String hits = "";
	String reg_dt = "";
	String reg_id = "";
	String reg_nm = "";
	String reg_ip = "";
	String mod_dt = "";
	String mod_id = "";
	String mod_ip = "";
	String del_yn = "";

	String msg = "등록";
	String actPage = "";

	EgovUserInfoVO user_info = (EgovUserInfoVO) request.getAttribute("user");
	if (user_info != null) {
		reg_nm = user_info.getUserNm();
	}

	if (bbsDataInfo == null) {
		modeType = "ins";
		actPage = "/contentsText/regist.do";
		msg = "등록";
	} else {

		modeType = "mod";
		actPage = "/contentsText/modify.do";
		msg = "수정";

		text_idx = String.valueOf(bbsDataInfo.get("textIdx"));
		title = StringUtil.nvl(bbsDataInfo.get("title"), "");
		reg_nm = StringUtil.nvl(bbsDataInfo.get("regNm"), "");

		if (bbsDataInfo.get("regDt") != null) {
			reg_dt = bbsDataInfo.get("regDt").toString();
		}
		if (bbsDataInfo.get("modDt") != null) {
			mod_dt = bbsDataInfo.get("modDt").toString();
		}
		cont = StringUtil.nvl(bbsDataInfo.get("cont"), "");

	}

	String orgModeType = modeType;
%>
<meta name="decorator" content="defaultPage">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
	<ol class="breadcrumb hidden-xs">
		<li>Image & Text 컨텐츠 관리</li>
		<li>등록 & 수정</li>
	</ol>
	<h4 class="page-title">Image & Text 컨텐츠 관리</h4>

	<form name="frm" id="frm" method="post">
		<input type="hidden" name="text_idx" id="text_idx"
			value="<%=text_idx%>" /> <input type="hidden" name="pageIndex"
			id="pageIndex" value="${pageIndex}" /> <input type="hidden"
			name="search_keyword" id="search_keyword" value="${search_keyword}" />
		<input type="hidden" name="best_select" id="best_select"
			value="${best_select}" />

		<div class="row m-t-15 text-right m-b-10">
			<button id="search" class="btn btn-sm" style="">목 록</button>
			<button class="btn btn-sm" id="save">저 장</button>
			<%
				if ("mod".equals(modeType)) {
			%>
			<button class="btn btn-sm" id="remove">삭 제</button>
			<%
				}
			%>
		</div>

		<div class="alert alert-danger">필수 입력 항목입니다.</div>

		<div class="table-responsive overflow" style="overflow: hidden; outline: none;">
			<table class="table table-bordered tile">
				<caption></caption>
				<colgroup>
					<col width="" />
					<col width="" />
				</colgroup>
				<tr>
					<th>TagMenu</th>
					<td colspan="3">
						<div class="col-md-1">
							<select id="tag_select" name="tag_select" class="select">
								<option value="">선택</option>
								<%
									if (TAG_MENU != null) {
										Map<String, Object> TAG_MENU_NODE;
										for (int i = 0; i < TAG_MENU.size(); i++) {
											TAG_MENU_NODE = TAG_MENU.get(i);
								%>
								<option value="<%=String.valueOf(TAG_MENU_NODE.get("tagIdx"))%>"><%=String.valueOf(TAG_MENU_NODE.get("tagName"))%></option>
								<%
									}
									}
								%>
							</select>
						</div>
						<button class="btn btn-sm" onclick="jsAddTag()">추 가</button>
						<div class="col-md-12 m-t-5" id="TAG_DIV">
							<%
								int row = 1;
								if (bbsDataInfo != null) {
									String[] ARR_TAG = StringUtil.nvl(bbsDataInfo.get("tag"), "").split(",");
									for (int j = 0, k = ARR_TAG.length; j < k; j++) {
										Map<String, Object> TAG_MENU_NODE;
										for (int i = 0; i < TAG_MENU.size(); i++) {
											TAG_MENU_NODE = TAG_MENU.get(i);
											if (ARR_TAG[j].equals(TAG_MENU_NODE.get("tagIdx").toString())) {
							%>
							<p id='TAG_DIV_<%=row%>' val='<%=TAG_MENU_NODE.get("tagIdx")%>'>
								ㆍ<%=TAG_MENU_NODE.get("tagName")%>&nbsp;<a href="javascript:;"
									onclick="jsDelTag('TAG_DIV_<%=row%>')">[삭제]</a>
							</p>
							<%
								row++;
											}
										}
									}
								}
							%>
						</div> <input type="hidden" name="tag" id="tag"> <script
							type="text/javascript">
							TAG_DIV_COUNT =
						<%=row%>
								;
							</script>
					</td>
				</tr>
				<tr>
					<th>Menu</th>
					<td colspan="3">
						<div class="col-md-2">
							<select id="menu_select" name="menu_select"
								onchange="jsChangeMenu();" class="select">
								<option value="">선택</option>
								<%
									if (USER_MENU != null) {
										for (Map<String, Object> USER_NEMU_NODE : USER_MENU) {
								%>
								<option
									value="<%=String.valueOf(USER_NEMU_NODE.get("menuSeq"))%>"><%=String.valueOf(USER_NEMU_NODE.get("menuName"))%></option>
								<%
									}
									}
								%>
							</select>
						</div>
						<div class="col-md-2">
							<select id="menu_select2" name="menu_select2"
								style="display: none;" class="select">
								<option value="">선택</option>
							</select>
						</div>

						<button class="btn btn-sm" onclick="jsAddMenu()">추 가</button>
						<div class="col-md-12 m-t-5" id="MENU_DIV">
							<%
								row = 1;

								if (bbsDataInfo != null) {
									String[] ARR_MENU = StringUtil.nvl(bbsDataInfo.get("menu"), "").split(",");
									for (int j = 0, k = ARR_MENU.length; j < k; j++) {
										String MENU_NAME = "";

										String[] ARR_MENU_SUB = ARR_MENU[j].split("`");
										for (int i = 0; i < ARR_MENU_SUB.length; i++) {
											for (Map<String, Object> USER_MENU_NODE : USER_MENU_MASTER) {
												if (ARR_MENU_SUB[i].equals(USER_MENU_NODE.get("menuSeq").toString())) {
													MENU_NAME = MENU_NAME + USER_MENU_NODE.get("menuName") + " > ";
													break;
												}
											}
										}

										if (MENU_NAME.length() > 0) {
							%>
							<p id='MENU_DIV_<%=row%>' val='<%=ARR_MENU[j]%>'>
								ㆍ<%=MENU_NAME.substring(0, MENU_NAME.length() - 3)%>&nbsp;<a
									href="javascript:;" onclick="jsDelTag('MENU_DIV_<%=row%>')">[삭제]</a>
							</p>
							<%
								row++;
										}
									}
								}
							%>
						</div> <input type="hidden" name="menu" id="menu"> <script
							type="text/javascript">
							MENU_DIV_COUNT =
						<%=row%>
								;
							</script>
					</td>
				<tr>
					<th><span class="text-danger">*</span>&nbsp;제목</th>
					<td colspan="3">
						<div class="col-md-12">
						<input type="text" name="title" id="title" maxlength="100" class="form-control input-sm m-b-10" value="<%=title%>" />
						</div>
					</td>
				</tr>
				</tr>
				<tr>
					<th scope="col">썸네일</th>
					<td colspan="3">
						<div class="col-md-12">
						<%=UvFileUtil.drawSingleUpload("CONTENTS_TEXT", "T", "*.png; *.jpg;", "10000MB")%>
						<%
							if (bbsDataFile != null && bbsDataFile.size() > 0) {
								String rtn = "";
								String IMG_URL = "/upload/CONTENTS_TEXT/";
								for (Map<String, Object> file : bbsDataFile) {
									if (StringUtil.nvl(file.get("fileType")).equals("IMG")) {
										rtn = rtn + "jsDrawImageFile('CONTENTS_TEXT', '" + file.get("orgFileNm") + "', '"
												+ file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", " + file.get("dataIdx")
												+ ", '" + IMG_URL + "', '" + file.get("mainImgFalg") + "');\n";
									} else {
										rtn = rtn + "jsDrawFile('CONTENTS_TEXT', '" + file.get("orgFileNm") + "', '"
												+ file.get("fileNm") + "', " + file.get("FILE_SIZE") + ", '" + file.get("fileType")
												+ "', " + file.get("dataIdx") + ");\n";
									}
								}
						%> <script type="text/javascript">
						$(document).ready(function() {
						<%=rtn%>
						});
						</script> <%
					 	}
					 %>
					 	</div>
					 </td>
				</tr>
				<tr>
					<th>내용</th>
					<td>
						<div class="col-md-12">
						<textarea name="cont" id="cont" rows="30"
							class="form-control overflow" cols="50" style="width: 100%;"><%=cont%></textarea>
						<script type="text/javascript">
						$(document).ready(function() {
							var oEditors = [];
							nhn.husky.EZCreator.createInIFrame({
								oAppRef : oEditors,
								elPlaceHolder : "cont",
								sSkinURI : "/SmartEditor/SmartEditor2Skin.jsp",
								fCreator : "createSEditor2"
							});
						});
						</script>
						</div>
					</td>
				</tr>
			</table>
			</section>
	</form>
	<script type="text/javascript" src="/common/uploadify/uploadify.js"></script>
	<script type="text/javascript" src="/common/jwplayer/jwplayer.js"></script>
	<script>
		jwplayer.key = "i4sty1oKVhqrdI0BQFRnsqtqOustH4AXbW/K0HOjHfU=";
	</script>
	<script type="text/javascript" src="/SmartEditor/js/HuskyEZCreator.js"
		charset="utf-8"></script>

	<script>
		$(document).ready(function() {

			$('#search').click(function() {
				search()
			})
			$('#save').click(function() {
				save()
			})
			$('#remove').click(function() {
				remove()
			})

			jsCalcTag();
			jsCalcMenu();
		});

		function search() {
			var f = document.frm;
			$('#text_idx').val('');
			f.action = "/contentsText/list.do";
			f.submit();
		}

		function save() {
			if ($('#title').val() == '' || $('#title').val() == null) {
				alert('제목을 입력해주세요.');
				$('#title').focus();
				return;
			}

			oEditors.getById["cont"].exec("UPDATE_CONTENTS_FIELD", []);

			var contents = document.getElementById("cont").value;

			try {
				//elClickedObj.form.submit();
				var f = document.frm;
				f.action = "/contentsText/writeProc.do";
				f.submit();
			} catch (e) {
			}

			/* var f = document.frm; 
			f.action = "/contentsText/writeProc.do";
			f.submit(); */
		}

		function remove() {
			if ($('#text_idx').val() == '') {
				alert("선택된 목록이 없습니다. 삭제하시려는 목록을 체크하세요.");
				return;
			}
			if (confirm("정말 삭제 하시겠습니까?")) {
				$.ajax({
					url : '/contentsText/delProc.do',
					type : 'POST',
					data : $('#frm').serialize(),
					dataType : 'json',
					success : function(data) {
						alert(data.msg);
						newGuest();
					}
				});
			}
		};

		function newGuest() {
			var f = document.frm;
			$('#text_idx').val('');
			f.action = "/contentsText/write.do";
			f.submit();
		}

		function jsChangeMenu() {
			$.ajax({
				url : '/ncs/vod/subMenuList.do',
				type : 'POST',
				data : {
					MENU_SEQ : $('#menu_select').val()
				},
				dataType : 'json',
				success : function(json) {
					$("#menu_select2 option").remove();
					$("#menu_select2").append("<option value=''>선택</option>");
					if (json.menuList.length > 0) {
						//$("#menu_select2").show();
						$.each(json.menuList, function(i, row) {
							$("#menu_select2").append(
									"<option value='" + row.menuSeq + "'>"
											+ row.menuName + "</option>");
						});
					}
					$('#menu_select2').selectpicker('refresh');
				}
			});
		}

		var MENU_DIV_COUNT = 1;
		function jsAddMenu() {
			if ($("#menu_select").val() == "") {
				alert("메뉴를 선택하세요");
				return;
			}

			var menu = $("#menu_select").val();
			var menu_text = $("#menu_select option:selected").text();

			if (!$('#menu_select2').is(':hidden')) {
				if ($("#menu_select2").val() == "") {
					alert("서브메뉴를 선택하세요");
					return;
				}
				menu = menu + "`" + $("#menu_select2").val();

				menu_text = menu_text + " > "
						+ $("#menu_select2 option:selected").text();
			}

			if ($("#menu").val().indexOf("," + menu + ",") > -1) {
				alert("이미 등록되어 있는 메뉴 입니다.");
				return false;
			}

			$("#MENU_DIV")
					.append(
							"<p id='MENU_DIV_" + MENU_DIV_COUNT + "' val='" + menu + "'>ㆍ"
									+ menu_text
									+ "&nbsp;<a href=javascript:; onclick=jsDelMenu('MENU_DIV_"
									+ MENU_DIV_COUNT + "')>[삭제]</a></p>");
			MENU_DIV_COUNT++;

			jsCalcMenu();
		}

		function jsDelMenu(objName) {
			$("#" + objName).remove();

			jsCalcMenu();
		}

		function jsCalcMenu() {
			var MENU = "";
			$("#MENU_DIV").each(function() {
				$(this).find("p").each(function() {
					MENU = MENU + $(this).attr("val") + ",";
				});
			});

			$("#menu").val("," + MENU);
		}

		var TAG_DIV_COUNT = 1;
		function jsAddTag() {
			if ($("#tag").val().indexOf("," + $("#tag_select").val() + ",") > -1) {
				alert("이미 등록되어 있는 TagMenu 입니다.");
				return false;
			}

			$("#TAG_DIV")
					.append(
							"<p id='TAG_DIV_"
									+ TAG_DIV_COUNT
									+ "' val='"
									+ $("#tag_select").val()
									+ "'>ㆍ"
									+ $("#tag_select option:selected").text()
									+ "&nbsp;<a href=javascript:; onclick=jsDelTag('TAG_DIV_"
									+ TAG_DIV_COUNT + "')>[삭제]</a></p>");
			TAG_DIV_COUNT++;

			jsCalcTag();
		}

		function jsDelTag(objName) {
			$("#" + objName).remove();

			jsCalcTag();
		}

		function jsCalcTag() {
			var TAG = "";
			$("#TAG_DIV").each(function() {
				$(this).find("p").each(function() {
					TAG = TAG + $(this).attr("val") + ",";
				});
			});

			$("#tag").val("," + TAG);
		}
	</script>
</body>
</html>