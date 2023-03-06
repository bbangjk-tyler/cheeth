<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%-- <c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if> --%>
		<div class="sub_header sub_header_service">
			<div class="sub_header_service_inner">
				<p class="sub_header_typo"><spring:message code="header.about" text="서비스 소개" /></p>
				<div class="sub_location_container">
					<a href="/" class="sub_location_typo"><img class="sub_location_home_button" src="/public/assets/images/connection_location_home_button_white.svg"></a>
					<img class="sub_location_arrow" src="/public/assets/images/connection_location_arrow.svg">
					<div><p class="sub_location_typo_bold"><spring:message code="header.about" text="서비스 소개" /></p></div>
				</div>
			</div>
		</div>
	<div class="sub_service_wrap">

		<div class="sub_service_head">Welcome to <b>DENTNER!</b></div>

		<div class="sub_service_text">
			<spring:message code="about.main" text="덴트너(Dentner)는 “의뢰인 회원”과 “치자이너(CAD 디자이너) 회원” 간의<br>국내"/>
			<spring:message code="about.main1" text="·외 디지털 치과보철물 스캔(Scan data)파일과 CAD(Computer Aided Design) 파일의<br><b>거래를 중개 하는 온라인 플랫폼</b>입니다."/>			
		</div>

		<ul class="sub_service_list">
			<li>
				<em>01</em>
				<strong><spring:message code="about.sub1" text="sub1" /></strong>
				<span><spring:message code="about.sub11" text="sub11" /></span>
			</li>
			<li>
				<em>02</em>
				<strong><spring:message code="about.sub2" text="sub2" /></strong>
				<span><spring:message code="about.sub22" text="sub22" /></span>
			</li>
			<li>
				<em>03</em>
				<strong><spring:message code="about.sub3" text="sub3" /></strong>
				<span><spring:message code="about.sub33" text="sub33" /></span>
			</li>
		</ul>

		<div class="sub_service_process_title">Process Flow</div>
		<div class="sub_service_process_head">
			<div class="inner_text"><p><spring:message code="about.client" text="의뢰인 회원" /></p></div>
			<div class="inner_image"></div>
			<div class="inner_text"><p><spring:message code="about.tesigner" text="치자이너 회원" /><br><span>(<spring:message code="about.caddesigner" text="CAD 디자이너" />)</span></p></div>
		</div>
		<div class="sub_service_process_list">

			<div class="sub_service_process_item">
				<div class="inner_image"><img src="/public/assets/images/sub_service_process_ico1.png" alt=""></div>
				<div class="inner_title"><spring:message code="about.proct1" text="전자치과기공물 의뢰서 작성" /></div>
				<div class="inner_text"><spring:message code="about.procd1" text="processD1" /></div>
			</div><!-- // sub_service_process_item -->
			<div class="sub_service_process_item">
				<div class="inner_image"><img src="/public/assets/images/sub_service_process_ico2.png" alt=""></div>
				<div class="inner_title"><spring:message code="about.proct2" text="견적서 받기" /></div>
				<div class="inner_text"><spring:message code="about.procd1" text="processD2" /></div>
			</div><!-- // sub_service_process_item -->
			<div class="sub_service_process_item">
				<div class="inner_image"><img src="/public/assets/images/sub_service_process_ico3.png" alt=""></div>
				<div class="inner_title"><spring:message code="about.proct2" text="견적서 확인 후 치자이너 매칭" /></div>
				<div class="inner_text"><spring:message code="about.procd1" text="processD3" /></div>
			</div><!-- // sub_service_process_item -->
			<div class="sub_service_process_item">
				<div class="inner_image"><img src="/public/assets/images/sub_service_process_ico4.png" alt=""></div>
				<div class="inner_title"><spring:message code="about.proct2" text="전자계약 및 작업 진행" /></div>
				<div class="inner_text"><spring:message code="about.procd1" text="processD4" /></div>
			</div><!-- // sub_service_process_item -->
			<div class="sub_service_process_item">
				<div class="inner_image"><img src="/public/assets/images/sub_service_process_ico5.png" alt=""></div>
				<div class="inner_title"><spring:message code="about.proct2" text="전자치과기공물 의뢰서 작성" /></div>
				<div class="inner_text"><spring:message code="about.procd1" text="processD5" /></div>
			</div><!-- // sub_service_process_item -->
			<div class="sub_service_process_item">
				<div class="inner_image"><img src="/public/assets/images/sub_service_process_ico6.png" alt=""></div>
				<div class="inner_title"><spring:message code="about.proct2" text="후기작성" /></div>
				<div class="inner_text"><spring:message code="about.procd1" text="processD6" /></div>
			</div><!-- // sub_service_process_item -->
		</div>

		<div class="sub_service_button">
			 <a href="javascript:window.open('https://www.dentner.co.kr/static/덴트너_이용가이드_의뢰인편.pdf')" class="sub_service_button_blue"><span><spring:message code="about.seeC" text="의뢰인 이용가이드 보기" /></span></a>
			 <a href="javascript:window.open('https://www.dentner.co.kr/static/덴트너_이용가이드_치자이너편.pdf')" class="sub_service_button_white"><span><spring:message code="about.seeT" text="치자이너 이용가이드 보기" /></span></a>
		</div>

		<div class="sub_service_process_tip">※ <spring:message code="about.tip" text="tip" /></div>

	</div><!-- // sub_service_wrap -->