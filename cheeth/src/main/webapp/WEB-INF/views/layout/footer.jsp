<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="footer">
  <div class="footer_bar"></div>
  <div class="footer_menu_container container">
    <p class="footer_menu_typo" onclick="javascript:location.href='/${api}/introduction/service_introduction'">
      <spring:message code="header.about" text="서비스 소개" />
    </p>
    <p class="footer_menu_typo" onclick="javascript:window.open('https://www.dentner.co.kr/static/덴트너_이용가이드_회원가입편.pdf')">
      <spring:message code="footer.joinG" text="회원가입 이용가이드" />
    </p>
    <p class="footer_menu_typo" onclick="javascript:window.open('https://www.dentner.co.kr/static/덴트너_이용가이드_의뢰인편.pdf')">
      <spring:message code="footer.orderG" text="의뢰인 이용가이드" />
    </p>
    <p class="footer_menu_typo" onclick="javascript:window.open('https://www.dentner.co.kr/static/덴트너_이용가이드_치자이너편.pdf')">
      <spring:message code="footer.tesignerG" text="치자이너 이용가이드" />
    </p>
    <p class="footer_menu_typo" onclick="javascript:window.open('https://www.dentner.co.kr/static/덴트너_개인정보처리방침.pdf')">
      <spring:message code="footer.privacy" text="개인정보처리방침" />
    </p>
    <p class="footer_menu_typo" onclick="javascript:window.open('https://www.dentner.co.kr/static/덴트너_이용약관.pdf')">
      <spring:message code="footer.term" text="이용약관" />
    </p>
    <p class="footer_menu_typo">
      <spring:message code="footer.support" text="고객지원" />
    </p>
  </div>
  <div class="footer_bar"></div>
  <div class="footer_info_container container">
    <div class="footer_info_left_container">
      <p class="footer_info_left_typo">
        <spring:message code="footer.repres" text="치예랑 대표" /> : <spring:message code="footer.nww" text="남원욱" /> &nbsp;&nbsp; 
        <spring:message code="address" text="주소" /> : <spring:message code="footer.address" text="서울시 중구 퇴계로248, 207호" /> &nbsp;&nbsp; 
        E-mail : dentnerkorea@gmail.com &nbsp;&nbsp;
        <spring:message code="businum" text="사업자번호" /> : 243-14-01127
      </p>
      <p class="footer_info_left_typo">
        <spring:message code="footer.mail" text="통신판매 신고" /> : 제 2022-서울중구-0812호 &nbsp;&nbsp; 
        <spring:message code="footer.medical" text="의료기기판매업 신고" /> : 제3291호 &nbsp;&nbsp; 
        <spring:message code="footer.personal" text="개인정보 관리책임자" /> : <spring:message code="footer.nww" text="남원욱" />
      </p>
      <div class="footer_info_left_copyright_wrapper">
        <p class="footer_info_left_typo">
          COPYRIGHT © <spring:message code="footer.dentner" text="치예랑" /> ALL RIGHTS RESERVED.
        </p>
      </div>
    </div>
    <div class="footer_info_right_container">
      <p class="footer_info_right_typo">
        <spring:message code="footer.customer" text="고객센터" /> 02-2273-2822
      </p>
      <p class="footer_info_right_typo">
        <spring:message code="footer.opentime" text="평일 월~금(공휴일 휴무)" /> 10:00 ~ 18:00
      </p>
    </div>
  </div>
</div>