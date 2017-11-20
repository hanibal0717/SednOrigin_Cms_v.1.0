<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<header id="header" class="media">
	<a href="" id="menu-toggle"></a> 
	<a class="logo pull-left" onclick="location.href='/inuMain.do'"><b>SEDN ORGIN</b> <span style="font-size:0.8em">v1.0</span></a>
      
	<div class="media-body">
		<div class="media" id="top-menu">

			<div id="time" class="pull-right">
                <span id="hours"></span>
                :
                <span id="min"></span>
                :
                <span id="sec"></span>
            </div>
            <div class="pull-right" style="margin-top:15px;margin-right:50px;">
            	<a onClick="location.href='https://drive.google.com/drive/folders/16zFz1t7s8s1B0ePILPYlnUMZxqbXQdrN?usp=sharing'" style="cursor:pointer;">도움말 다운로드</a>
            </div>
        </div>
    </div>
</header>

<div class="clearfix"></div>

<section id="main" class="p-relative" role="main">
            
	<!-- Sidebar -->
	<aside id="sidebar">
		<div class="side-widgets overflow" tabindex="5000" style="overflow: hidden; outline: none;">
            <!-- Profile Menu -->
            <div class="text-center s-widget m-b-25 dropdown" id="profile-menu">
                <a href="" data-toggle="dropdown">
                    <img class="profile-pic animated" src="/common/img/profile-pic.jpg" alt="">
                </a>
                <h4><c:if test="${not empty userLoginInfo}">${userLoginInfo.userNm}</c:if>
                <c:if test="${empty userLoginInfo}">
					<button class="btn-sm btn" onclick="location.href='/system/loginView.do'" >login</button>
				</c:if>
				<c:if test="${not empty userLoginInfo}">
					<button  class="btn-sm btn" onclick="location.href='/system/logOut.do'" >로그 아웃</buttonn>
				</c:if>
				</h4>
            </div>
            
            <!-- Calendar -->
            <div class="s-widget m-b-25">
                <div id="sidebar-calendar"></div>
            </div>
        </div>
	<!-- Side Menu -->
	
    <ul class="list-unstyled side-menu" id="gnbMenu"">
    </ul>

	</aside>

	