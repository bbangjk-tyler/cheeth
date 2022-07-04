<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- <script type="text/javascript">
  	var locations = document.location.href;
  	locations += ""; 
  	if (locations.includes('http://www.')) {
          document.location.href = document.location.href.replace('http://www.', 'https://');
     }else if(locations.includes('http:')){
    	 document.location.href = document.location.href.replace('http:', 'https:');
     }else if(locations.includes('https://www.')){
    	 document.location.href = document.location.href.replace('https://www.', 'https://');
     }
</script> -->

<script>
$(document).ready(function() {
	  
});
</script>

<div class="sign_up_sign_up_container">
  <div class="sign_up_sign_up_typo_container">
    <p class="sign_up_sign_up_typo">회원가입</p>
  </div>
  <div class="sign_up_sign_up_step_container">
    <div class="sign_up_sign_up_step">
      <p class="sign_up_sign_up_step_number">STEP 1</p>
      <p class="sign_up_sign_up_step_title">회원유형 선택</p>
    </div>
    <img class="sign_up_sign_up_step_arrow" src="/public/assets/images/sign_up_steps_right_arrow.svg">
    <div class="sign_up_sign_up_step">
      <p class="sign_up_sign_up_step_number">STEP 2</p>
      <p class="sign_up_sign_up_step_title">약관동의</p>
    </div>
    <img class="sign_up_sign_up_step_arrow" src="/public/assets/images/sign_up_steps_right_arrow.svg">
    <div class="sign_up_sign_up_step" style="color: #2093EB;">
      <p class="sign_up_sign_up_step_number">STEP 3</p>
      <p class="sign_up_sign_up_step_title">정보입력</p>
    </div>
  </div>
</div>
    
<div class="sign_up_info_wrapper">
  <div class="sign_up_top_divider"></div>
  <div class="sign_up_info_container">
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_title">회원유형 선택</p>
    </div>
    <div class="sign_up_info_membership_type_select_button_wrapper">
      <div class="sign_up_info_membership_type_select_button_container">
        <button class="sign_up_info_membership_type_select_button">
          <p class="sign_up_info_membership_type_select_button_typo">일반 회원가입</p>
        </button>
        <div class="dropbox_sign_up_membership_type_select_container invisible">
          <div class="dropbox_sign_up_membership_type_select_top hidden">
            <div class="dropbox_line_border"></div>
            <div class="dropbox_left_inclined_border"></div>
            <div class="dropbox_right_inclined_border"></div>
            <div class="dropbox_line_border"></div>
          </div>
          <div class="dropbox_sign_up_membership_type_select_body hidden">
            <div class="dropbox_sign_up_membership_type_select_item">
              <p class="dropbox_sign_up_membership_type_select_item_typo">의뢰인</p>
            </div>
            <div class="dropbox_sign_up_membership_type_select_item">
              <p class="dropbox_sign_up_membership_type_select_item_selected_typo">치자이너</p>
            </div>
          </div>
        </div>
      </div>
      <div class="sign_up_info_membership_type_select_button_container">
        <button class="sign_up_info_membership_type_select_button">
          <p class="sign_up_info_membership_type_select_button_typo">전문가 회원가입</p>
        </button>
        <!-- invisible class 추가: dropdown menu 안보임 (공간 그대로) -->
        <div class="dropbox_sign_up_membership_type_select_container invisible">
          <div class="dropbox_sign_up_membership_type_select_top">
            <div class="dropbox_line_border"></div>
            <div class="dropbox_left_inclined_border"></div>
            <div class="dropbox_right_inclined_border"></div>
            <div class="dropbox_line_border"></div>
          </div>
          <div class="dropbox_sign_up_membership_type_select_body">
            <div class="dropbox_sign_up_membership_type_select_item">
              <p class="dropbox_sign_up_membership_type_select_item_typo">의뢰인</p>
            </div>
            <div class="dropbox_sign_up_membership_type_select_item">
              <p class="dropbox_sign_up_membership_type_select_item_selected_typo">치자이너</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="sign_up_info_container_divider"></div>
  <div class="sign_up_info_container">
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">닉네임(중복조회)</p>
      <input class="sign_up_info_item_blank_with_button" style="width: 177px;"/>
      <button class="sign_up_info_item_button">
        <p class="sign_up_info_item_button_typo">중복 확인</p>
      </button>
    </div>
  </div>
  <div class="sign_up_info_container_divider"></div>
  <div class="sign_up_info_container">
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">직업선택</p>
      <div class="dropbox_sign_up_expert_job">
        <div class="dropbox_select_button">
          <div class="dropbox_select_button_typo_container">
            <p class="dropbox_select_button_typo">선택</p>
            <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
          </div>
        </div>
        <div class="dropbox_select_button_item_container hidden">
          <div class="dropbox_select_button_item">
            <p class="dropbox_select_button_item_typo">치과의사</p>
          </div>
          <div class="dropbox_select_button_item">
            <p class="dropbox_select_button_item_typo">치과기공사</p>
          </div>
        </div>
      </div>
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">면허증 첨부</p>
      <input class="sign_up_info_item_blank_with_button required" style="width: 341px;" data-field="면허증"/>
      <button class="sign_up_info_item_button">
        <p class="sign_up_info_item_button_typo">파일첨부</p>
      </button>
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">면허증 번호</p>
      <input class="sign_up_info_item_blank"/>
    </div>
  </div>
  <div class="sign_up_center_divider"></div>
  <div class="sign_up_info_container">
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_title">추가정보</p>
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">은행</p>
      <div class="dropbox_sign_up_expert_bank">
        <div class="dropbox_select_button">
          <div class="dropbox_select_button_typo_container">
            <p class="dropbox_select_button_typo">선택</p>
            <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
          </div>
        </div>
        <div class="dropbox_select_button_item_container hidden">
          <div class="dropbox_select_button_item">
            <p class="dropbox_select_button_item_typo"></p>
          </div>
        </div>
      </div>
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">예금주</p>
      <input class="sign_up_info_item_blank_with_button" style="width: 142px;"/>
      <button class="sign_up_info_item_button">
        <p class="sign_up_info_item_button_typo">본인인증</p>
      </button>
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">계좌번호</p>
      <input class="sign_up_info_item_blank" placeholder='"-"를 제외하고 입력하시기 바랍니다.'/>
    </div>
  </div>
  <div class="sign_up_info_container_divider"></div>
  <div class="sign_up_info_container">
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">업종선택</p>
      <div class="dropbox_sign_up_expert_sectors">
        <div class="dropbox_select_button">
          <div class="dropbox_select_button_typo_container">
            <p class="dropbox_select_button_typo">선택</p>
            <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
          </div>
        </div>
        <div class="dropbox_select_button_item_container hidden">
          <div class="dropbox_select_button_item">
            <p class="dropbox_select_button_item_typo">치과</p>
          </div>
          <div class="dropbox_select_button_item">
            <p class="dropbox_select_button_item_typo">치과기공소</p>
          </div>
        </div>
      </div>
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">사업자등록번호</p>
      <input class="sign_up_info_item_blank"/>
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">상호</p>
      <input class="sign_up_info_item_blank" style="width: 253px;"/>
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">사업장 주소</p>
      <input class="sign_up_info_item_blank"/>
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">사업자등록증 첨부</p>
      <input class="sign_up_info_item_blank_with_button" style="width: 341px;"/>
      <button class="sign_up_info_item_button">
        <p class="sign_up_info_item_button_typo">파일첨부</p>
      </button>
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo"></p>
      <p class="sign_up_info_item_blank_comment">※ 소속된 사업장의 정보를 입력해주세요. 미입력 시 서비스에 제한이 있을 수 있습니다.</p>
    </div>
  </div>
</div>
  
<div class="sign_up_page_button_container">
  <a href="./accept_conditions.html" class="sign_up_page_button">
    <p class="sign_up_page_button_typo">이전 페이지</p>
  </a>
  <a class="sign_up_confirm_button">
    <p class="sign_up_confirm_button_typo">확인</p>
  </a>
</div>