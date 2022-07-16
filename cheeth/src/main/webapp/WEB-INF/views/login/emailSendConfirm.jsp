<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("locaton.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>I-DDLE</title>
	
	<!-- 부트스르랩 css 추가 -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 css 추가 -->
	<link rel="stylesheet" href="./css/custom.css">
    <!-- ///////////////////////////////////////////////// -->
  	    <!-- Google Web Font -->
    <link href='http://fonts.googleapis.com/css?family=Ubuntu:300,400,500,700' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Lekton:400,700,400italic' rel='stylesheet' type='text/css'>

    <!--  Bootstrap 3-->
    <link rel="stylesheet" href="css/bootstrap.min.css">

    <!-- OWL Carousel -->
    <link rel="stylesheet" href="css/owl.carousel.css">
    <link rel="stylesheet" href="css/owl.theme.css">

    <!--  Slider -->
    <link rel="stylesheet" href="css/jquery.kenburnsy.css">

    <!-- Animate -->
    <link rel="stylesheet" href="css/animate.css">

    <!-- Web Icons Font -->
    <link rel="stylesheet" href="css/pe-icon-7-stroke.css">
    <link rel="stylesheet" href="css/iconmoon.css">
    <link rel="stylesheet" href="css/et-line.css">
    <link rel="stylesheet" href="css/ionicons.css">

    <!-- Magnific PopUp -->
    <link rel="stylesheet" href="css/magnific-popup.css">

    <!-- Tabs -->
    <link rel="stylesheet" type="text/css" href="css/tabs.css" />
    <link rel="stylesheet" type="text/css" href="css/tabstyles.css" />

    <!-- Loader Style -->
    <link rel="stylesheet" href="css/loader-1.css">

    <!-- Costum Styles -->
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/responsive.css">

    <!-- Favicon -->
    <link rel="icon" type="image/ico" href="favicon.ico">

    <!-- Modernizer & Respond js -->
    <script src="js/vendor/modernizr-2.8.3-respond-1.4.2.min.js"></script>
  	
  	<!-- ///////////////////////////////////////////////// -->
</head>
<body>

   <!-- Preloader -->
    <div class="cover"></div>

    <div class="header">
        <div class="container">
            <div class="logo">
                <a href="index.jsp">
                    <img src="img/logo.png" alt="Logo">
                </a>
            </div>
            
            <!-- Menu Hamburger (Default) -->
            <button class="main-menu-indicator" id="open-button">
                <span class="line"></span>
            </button>
            
            <div class="menu-wrap" style="background-image: url(img/nav_bg.jpg);">
                <div class="menu-content">
                    <div class="navigation">
                        <span class="pe-7s-close close-menu" id="close-button"></span>
                        <div class="search-wrap js-ui-search">
                            <input class="js-ui-text" type="text" placeholder="Search Here...">
                            <span class="eks js-ui-close"></span>
                        </div>
                    </div>

                    <div class="Login">
                    <%
                    	if(userID == null){
                    %>
                    	
		                    <li class="dropdown">
		                    	<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">회원으로 접속하기<span class="caret"></span></a>
		                        <ul>
		                           <li><a href="userLogin.jsp">로그인</a></li>
		                           <li><a href="userJoin.jsp">회원가입</a></li>
		                        </ul>
		                    </li>
	                   
	                <% 
                    	}else{
	                %>
	               
		                <li class="dropdown">
		                	<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><%=userID%> <h5>님 반갑습니다.</h5><span class="caret"></span></a>
	                        <ul class="dropdown-menu">
	                           <li><a href="userLogout.jsp">Logout</a></li>
	                        </ul>
	                  </li>
	                
	                <% 
                    	}
	                %>
                    </div>
                    <nav class="menu" style="position:relative; z-index:10;">
                        <div class="menu-list">
                            <ul>
                                <li class="menu-item-has-children"><a href="index.jsp">Home</a>
                                </li>
                                <li><a href="about.html">이벤트</a></li>
                                <li class="menu-item-has-children"><a href="#">사이트 순위</a>
                                </li>
                                <% if(userID != null){ %>
                                <li class="menu-item-has-children"><a href="#">내 정보</a>
                                	<ul class="sub-menu">
                                        <li><a href="blog.html">내가 찜한 상품</a></li>
                                        <li><a href="blog-timeline.html">내 정보 수정</a></li>
                                    </ul>
                                </li>
                                <% } %>
                            </ul>
                        </div>
                    </nav>

                    <div class="hidden-xs">
                        <div class="menu-social-media">
                            <ul>
                               <li><a href="#"><i class="iconmoon-facebook"></i></a></li>
                               <li><a href="#"><i class="iconmoon-twitter"></i></a></li>
                               <li><a href="#"><i class="iconmoon-dribbble3"></i></a></li>
                               <li><a href="#"><i class="iconmoon-pinterest"></i></a></li>
                               <li><a href="#"><i class="iconmoon-linkedin2"></i></a></li>
                            </ul>
                        </div>
                        <div class="menu-information">
                            <ul>
                                <li><span>T:</span> 010 8936 7782</li>
                                <li><span>E:</span> dong7782@naver.com</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <!-- End of Menu Hamburger (Default) -->

        </div>
    </div>
	<!-- 구글에서 본거 추가 2-->

	<section class="container mt-3" style="max-width: 560px;">
		<div class="alert alert-warning mt-4" role="alert">
			이메일 주소 인증을 하셔야 이용 가능합니다. 인증 메일을 받지 못하셨나요?
		</div>
		<a href="emailSendAction.jsp" class="btn btn-primary">인증 메일 다시 받기</a>
	</section>

  		<footer style="background-color: #000000; color: #ffffff">
  			<div class="container">
  				<div class="row">
                 <div class="col-sm-3" style="text-align: left; color: #ffffff">
                    <br>
                    <p><font size=2>i-ddle</font></p>
                    <p><font size=2>(주) 나인업소프트</font></p>
                    <p><font size=2>대표이사: 신상민  | 사업자등록번호 : 634-81-01723</font></p>
                    <p><font size=2>개발총괄: 김동현  | 이메일: dong7782@naver.com</font></p>
                    <p><font size=2>문의전화: 02-558-0783</font></p>
                    <!-- <p><font size=2>찾아오시는 길: 서울특별시 금천구 디지털로9길 41, 14층 1413호</font></p> -->
                	<p><font size=2>찾아오시는 길: 서울특별시 강남구 테헤란로 625, 17층</font></p>
                	<p><font size=2>고객센터 : 02-558-0783(근무시간 10:00 ~ 18:00, 점심시간 12:30 ~ 13:30, 토/일/공휴일 휴무)</font></p>
                    <p><font size=2>제휴 및 광고 문의 : info@nineupsoft.com</font></p>
                    <p><font style="color:#a3a3a3">아동복 최저가 아동 유아복 유아 최신 신상 어린이 설날 추석 크리스마스 선물 유치원  키즈 베이비 아이옷 아기옷 ㅌ올가닉</font></p>
                    <br>
                 </div>

                 <div class="col-sm-5" style="text-align: center; color: #ffffff">
					<br>
                    <br>
                    <h5>판매하는 모든 상품에 대한 배송, 교환, 환불 등 모든 책임은 나인업소프트(주)에 있습니다.</h5>
                    <br>
                    <h5>담당자: 신상민 010-2846-0783</h5>
                    <br>
                    <br>
                  <h5>Copyright &copy; 2020 NineupSoft All Rights Reserved.</h5>
				  <br>

               </div>

               <!-- 검색 노출이 잘 되기 위한 꼼수 -->

               <div class="col-sm-2" style="text-align: right; color: #000000">
               </div>
            </div>
			</div>
		</footer>
		<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
		<!-- 파퍼 추가하기 -->
	<script src="./js/popper.js"></script>
		<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
	<!-- //////////////////////////////////////////////////////////// -->
	<script src="js/vendor/jquery-1.11.2.min.js"></script>
    <script data-pace-options='{ "ajax": false }' src="js/vendor/pace.min.js"></script>
    <script src="js/vendor/bootstrap.min.js"></script>
    <script src="js/vendor/classie.js"></script>
    <script src="js/vendor/isotope.pkgd.min.js"></script>
    <script src="js/vendor/jquery.velocity.min.js"></script>
    <script src="js/vendor/jquery.kenburnsy.min.js"></script>
    <script src="js/vendor/textslide.js"></script>
    <script src="js/vendor/imagesloaded.pkgd.min.js"></script>
    <script src="js/vendor/tabs.js"></script>
    <script src="js/ef-slider.js"></script>    
    <script src="js/vendor/owl.carousel.min.js"></script>
    <script src="js/vendor/jquery.magnific-popup.min.js"></script>
    <script src="js/vendor/jquery.social-buttons.min.js"></script>
    <script src="js/vendor/wow.min.js"></script>
    <script src="js/main.js"></script>
    <script src="js/ajax.js"></script>
	<!-- /////////////////////////////////////////////////////////// -->
	<%
		if(userID != null){
	%>
		<script>

			$(document).ready(function(){
				getUnread();
				getInfiniteUnread();
			});

		console.log("rrrrrrr");
		</script>
	<%
	}		
	%>
</body>
</html>