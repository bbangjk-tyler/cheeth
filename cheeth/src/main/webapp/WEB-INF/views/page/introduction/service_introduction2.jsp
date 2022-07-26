<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- <c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if> --%>
<div class="service_intro_header">
  <p class="service_intro_header_typo">서비스 소개</p>
  <div class="service_intro_connection_location_container">
    <a href="/" class="service_intro_connection_location_typo">
      <img class="service_intro_connection_location_home_button" src="/public/assets/images/connection_location_home_button_white.svg"/>
    </a>
    <img class="service_intro_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
    <div class="service_intro_connection_location">
      <p class="service_intro_connection_location_typo_bold">서비스 소개</p>
    </div>
  </div>
</div>

<div class="service_intro_header_bottom_container">
  <div class="service_intro_header_bottom_item"></div>
</div>

<div class="service_intro_body">
  <div class="service_intro_main_container">
    <div class="service_intro_item">
      <img class="service_intro_item_icon" src="/public/assets/images/service_intro_item_icon.svg"/>
      <p class="service_intro_item_typo">덴트너(Dentner)는 국내·외 치과보철물을 ‘전자치과기공물제작의뢰서’를 이용하여 회원간<br>스캔(Scan data)파일과 CAD(Computer Aided Design) 파일의 거래를 중개 하는 온라인 플랫폼입니다.</p>
    </div>
    <div class="service_intro_feature_container">
      <div class="service_intro_feature">
        <img class="service_intro_feature_order" src="/public/assets/images/service_intro_feature_order_1.svg"/>
        <div class="service_intro_feature_divider"></div>
        <div class="service_intro_feature_typo_container">
          <p class="service_intro_feature_title">'무료중개소'입니다.</p>
          <p class="service_intro_feature_context">국내 치과보철물 제작 중개를 통해<br>어떠한 이윤도 추구하지 않습니다.</p>
        </div>
      </div>
      <div class="service_intro_feature feature_with_background">
        <div class="service_intro_feature_typo_container">
          <p class="service_intro_feature_title">시간과 장소에<br>구애 받지 않습니다.</p>
          <p class="service_intro_feature_context">국내는 물론 해외의 고객을 만날 수 있는 기회!</p>
        </div>
         <div class="service_intro_feature_divider"></div>
         <img class="service_intro_feature_order" src="/public/assets/images/service_intro_feature_order_2.svg"/>
      </div>
      <div class="service_intro_feature">
        <img class="service_intro_feature_order" src="/public/assets/images/service_intro_feature_order_3.svg"/>
        <div class="service_intro_feature_divider"></div>
        <div class="service_intro_feature_typo_container">
          <p class="service_intro_feature_title">국내 최초<br>'전자치과기공물제작의뢰서' 도입</p>
          <p class="service_intro_feature_context">대한상공회의소 샌드박스 규제 혁신 선두주자로<br>입법 추진 중 입니다.</p>
        </div>
      </div>
    </div>
  </div>
  <div class="service_intro_sub_container">
    <div class="service_intro_how_to_use">
      <p class="service_intro_how_to_use_title">이용방법</p>
      <div class="service_intro_how_to_use_sub_typo_container">
        <p class="service_intro_how_to_use_sub_title">How to Use</p>
        <p class="service_intro_view_video_guide">동영상 가이드 보기</p>
      </div>
      <div class="service_intro_how_to_use_step_container">
        <div class="service_intro_how_to_use_step">
          <img class="service_intro_how_to_use_step_icon" src="/public/assets/images/how_to_use_step_1.svg"/>
          <p class="service_intro_how_to_use_step_title">전자치과기공물 의뢰서 작성</p>
          <p class="service_intro_how_to_use_step_context">의뢰서 작성 후 공개 견적 또는 원하는<br>치자이너 선택 견적 요청하기</p>
        </div>
        <div class="service_intro_how_to_use_step">
          <img class="service_intro_how_to_use_step_icon" src="/public/assets/images/how_to_use_step_2.svg"/>
          <p class="service_intro_how_to_use_step_title">견적서 받기</p>
          <p class="service_intro_how_to_use_step_context">실시간 업데이트 되는 무료 견적서 받기</p>
        </div>
        <div class="service_intro_how_to_use_step">
          <img class="service_intro_how_to_use_step_icon" src="/public/assets/images/how_to_use_step_3.svg"/>
          <p class="service_intro_how_to_use_step_title">전자계약 및 작업 진행</p>
          <p class="service_intro_how_to_use_step_context">치자이너가 완성파일을 플랫폼에 업로드<br>하면 결제요청 메시지를 보내드립니다.</p>
        </div>
        <div class="service_intro_how_to_use_step">
          <img class="service_intro_how_to_use_step_icon" src="/public/assets/images/how_to_use_step_4.svg"/>
          <p class="service_intro_how_to_use_step_title">결제 및 후기작성</p>
          <p class="service_intro_how_to_use_step_context">좋은 거래 이후 서로의 후기를<br>작성하여 주세요.</p>
        </div>
      </div>
      <a href="/${api}/tribute/tribute_request">
	      <button class="service_intro_button" style="cursor: pointer;">
	        <p class="service_intro_button_typo">무료 견적 요청하기</p>
	      </button>
	  </a>
      <p class="service_intro_additional_info">※ 견적서 요청시, 보철 종류x갯수 기준으로 견적 요청이 이루어지며 그 외 정보는 비공개 입니다. 추후 계약 체결자만 정보 열람이 가능합니다.</p>
      <div class="service_intro_how_to_use_background_wrapper"></div>
    </div>
  </div>
</div>
