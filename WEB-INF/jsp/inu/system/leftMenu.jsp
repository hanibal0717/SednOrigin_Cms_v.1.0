<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>

<script> 
var arrayMenu =[];
var topMenu =[];

var url = '${param.url}';
var pno = '110';

var auth = '${userLoginInfo.roleNm}'; 
var path = '${path.pathName}';

$(document).ready(function() {
	<c:forEach var="list" items="${leftmenu}" varStatus="listCount">
		arrayMenu.push({no : '${list.no}', pno : '${list.pno}', menuSeq : '${list.menuSeq}',sysCode : '${list.sysCode}' ,isAuth : '${list.isAuth}', menuLevel : '${list.menuLevel}', menuName : '${list.menuName}', menuPath : '${list.menuPath}', menuIcon : '${list.menuIcon}'} )
	</c:forEach>

	
	<c:forEach var="list" items="${topmenu}" varStatus="listCount">
		topMenu.push({no : '${list.no}', pno : '${list.pno}', isAuth : '${list.isAuth}',sysCode : '${list.sysCode}', menuLevel : '${list.menuLevel}', menuName : '${list.menuName}', menuPath : '${list.menuPath}', menuIcon : '${list.menuIcon}'} )
	</c:forEach>

	if (url == '/hjcy/ma/manageApplication.do') {
		url = '/hjcy/ma/manageApplicationList.do';
	}

	var cNo = '';
	var sysCode = '';
	var txt =  null;
	$(document).ready(function() {

	var logoName  = '${layoutInfo.fileNm}';
	var logoDelYn = '${layoutInfo.delYn}';

	if (logoName != null && logoName != "" && logoDelYn != null && logoDelYn != "" && logoDelYn == "N") {
		$("#admLogo").attr("src", "/UPLOAD/ADM_LOGO/"+logoName);
	}

	$('#gnbMenu').html('');
	
	$.each(topMenu, function(i, row) {
		if(1 == row.menuLevel) {
			var menuItem = [];
			
			$.each(topMenu, function(j, secondRow) {
				if(row.no == secondRow.pno) {
					menuItem.push(secondRow);
				}
			});
			
			//하위 메뉴가 없을 때
			if(0 == menuItem.length && (row.isAuth > 0|| auth == 'ROLE_SADMIN')) {
				$('#gnbMenu').append('<li class="'
						+ (row.menuPath == url ? 'active':'')
						+ '"><a class="fa ' + row.menuIcon + '" style="cursor:pointer;padding-top:14px;font-size:20px;" onclick="javascript:goTopMenuUrl(\''
						+ row.menuPath + '\', ' + row.no
						+ ');"><span class="menu-item" style="cursor:pointer;font-size:12px;">'
						+ row.menuName + '</span></a></li>');
			}
			//하위 메뉴가 있을 때
			else if(0 < menuItem.length) {
				var menuHtml = '<li class="dropdown"><a class="sa-side-home" onclick="javascript:goTopMenuUrl(\''
					+ row.menuPath + '\', ' + row.no
					+ ');"><span class="menu-item" style="cursor:pointer;">'
					+ row.menuName + '</span></a><ul class="list-unstyled menu-item">';
				
				$.each(menuItem, function(k, menu) {
					if(menu.isAuth > 0 || auth == 'ROLE_SADMIN') {
						menuHtml += '<li><a class="'
							+ (menu.menuPath == url ? 'active':'')
							+ '" style="cursor:pointer;" onclick="javascript:goTopMenuUrl(\''
							+ menu.menuPath + '\', ' + menu.no
							+ ');">'
							+ menu.menuName + '</a></li>';
					}
				});
				
				menuHtml += '</ul></li>';
				
				$('#gnbMenu').append(menuHtml);
			}
			
		}
		
	});
	
	var copyright = '${layoutInfo.copyright}';
	var filePath  = '${ fn:replace(layoutInfo.filePath,'/home/inucreative/sedn_c/appadm/ROOT/upload','D:\\J2EE\\workspace\\INUC\\UPLOAD') }';
	var orgFileNm = '${layoutInfo.orgFileNm}';

	$('.footer').find('span').html(copyright);

	setTimeout(function(){$('a').bind('click', function(e) { e.preventDefault(); })}, 500);
	});
});

function goTopMenuUrl(url, no){
	location.href = url+"?pno="+no;
}
</script>
