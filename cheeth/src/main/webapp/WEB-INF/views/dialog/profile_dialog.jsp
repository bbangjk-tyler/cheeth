<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript">
  	var locations = document.location.href;
  	locations += ""; 
  	if (locations.includes('http://www.')) {
          document.location.href = document.location.href.replace('http://www.', 'https://');
     }else if(locations.includes('http:')){
    	 document.location.href = document.location.href.replace('http:', 'https:');
     }else if(locations.includes('https://www.')){
    	 document.location.href = document.location.href.replace('https://www.', 'https://');
     }
</script>
<c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if>
<script>
  
  function fnGetProfile() {
    $.ajax({
      url: '/' + API + '/mypage/getProfile',
      type: 'GET',
      data: { TARGET_USER_ID : '${DATA.CREATE_ID}' },
      cache: false,
      async: false,
      success: function(data) {
        if(isNotEmpty(data.DATA_01)) {
          var data01 = data.DATA_01;
          $('#PROFILE_USER_NICK_NAME').html(data01.USER_NICK_NAME);
          $('#PROFILE_USER_TYPE_NM').html(data01.USER_TYPE_NM);
          
          if(data01.USER_TYPE_CD === 3 || data01.USER_TYPE_CD === '3') {
            // 치자이너
          } else {
            $('.etc_info').addClass('hidden');
            $('.career').prev().addClass('hidden');
            $('.career').addClass('hidden');
            $('.design_field').prev().addClass('hidden');
            $('.design_field').addClass('hidden');
          }
        }
        
        if(isNotEmpty(data.DATA_02)) {
          
          var data02 = data.DATA_02;
          if(isNotEmpty(data02.TAX_BILL_YN)) {
            $('#PROFILE_TAX_BILL_YN').prev().removeClass('hidden');
            $('#PROFILE_TAX_BILL_YN').removeClass('hidden');
            if(data02.TAX_BILL_YN === 'Y') {
              $('#PROFILE_TAX_BILL_YN').html('유');
            } else if(data02.TAX_BILL_YN === 'N') {
              $('#PROFILE_TAX_BILL_YN').html('무');
            }
          }
          
          $('#PROFILE_INTRO_CONTENT').html(data02.INTRO_CONTENT);
          $('#PROFILE_CAREER_NM').html(data02.CAREER_NM);
          
          var profileFileCd = data02.PROFILE_FILE_CD;
          if(isNotEmpty(profileFileCd)) {
            $('#PROFILE_FILE_CD').prop('src', '/upload/' + data02.PROFILE_FILE_DIRECTORY);
            $('#PROFILE_FILE_CD').prop('alt', data02.PROFILE_FILE_ORIGIN_NM);
          }
          
          var imageFileCd = data02.IMAGE_FILE_CD;
          if(isNotEmpty(imageFileCd)) {
            $('#IMAGE_FILE_CD').prop('src', '/upload/' + data02.IMAGE_FILE_DIRECTORY);
            $('#IMAGE_FILE_CD').prop('alt', data02.IMAGE_FILE_ORIGIN_NM);
          }
          
          var projectNm1 = data02.PROJECT_NM_1;
          if(isNotEmpty(projectNm1)) {
            var html = '<div class="profile_management_profile_design_field">';
            html += '<p class="profile_management_profile_design_field_typo">';
            html += projectNm1;
            html += '</p>';
            html += '</div>';
            $('.profile_management_profile_design_field_container').append(html);
          }
          
          var projectNm2 = data02.PROJECT_NM_2;
          if(isNotEmpty(projectNm2)) {
            var html = '<div class="profile_management_profile_design_field">';
            html += '<p class="profile_management_profile_design_field_typo">';
            html += projectNm2;
            html += '</p>';
            html += '</div>';
            $('.profile_management_profile_design_field_container').append(html);
          }
          
          var projectNm3 = data02.PROJECT_NM_3;
          if(isNotEmpty(projectNm3)) {
            var html = '<div class="profile_management_profile_design_field">';
            html += '<p class="profile_management_profile_design_field_typo">';
            html += projectNm3;
            html += '</p>';
            html += '</div>';
            $('.profile_management_profile_design_field_container').append(html);
          }
          
          var projectNm4 = data02.PROJECT_NM_4;
          if(isNotEmpty(projectNm4)) {
            var html = '<div class="profile_management_profile_design_field">';
            html += '<p class="profile_management_profile_design_field_typo">';
            html += projectNm4;
            html += '</p>';
            html += '</div>';
            $('.profile_management_profile_design_field_container').append(html);
          }
          
          var projectNm5 = data02.PROJECT_NM_5;
          if(isNotEmpty(projectNm5)) {
            var html = '<div class="profile_management_profile_design_field">';
            html += '<p class="profile_management_profile_design_field_typo">';
            html += projectNm5;
            html += '</p>';
            html += '</div>';
            $('.profile_management_profile_design_field_container').append(html);
          }
          
          var projectNm6 = data02.PROJECT_NM_6;
          if(isNotEmpty(projectNm6)) {
            var html = '<div class="profile_management_profile_design_field">';
            html += '<p class="profile_management_profile_design_field_typo">';
            html += projectNm6;
            html += '</p>';
            html += '</div>';
            $('.profile_management_profile_design_field_container').append(html);
          }
          
          var projectNm7 = data02.PROJECT_NM_7;
          if(isNotEmpty(projectNm7)) {
            var html = '<div class="profile_management_profile_design_field">';
            html += '<p class="profile_management_profile_design_field_typo">';
            html += projectNm7;
            html += '</p>';
            html += '</div>';
            $('.profile_management_profile_design_field_container').append(html);
          }
          
          var projectNm8 = data02.PROJECT_NM_8;
          if(isNotEmpty(projectNm8)) {
            var html = '<div class="profile_management_profile_design_field">';
            html += '<p class="profile_management_profile_design_field_typo">';
            html += projectNm8;
            html += '</p>';
            html += '</div>';
            $('.profile_management_profile_design_field_container').append(html);
          }
        }
        
        if(isNotEmpty(data.DATA_03)) {
          var data03 = data.DATA_03;
          
          var completeRatio = isEmpty(data03.COMPLETE_RATIO) ? 0 : data03.COMPLETE_RATIO;
          $('#PROFILE_COMPLETE_RATIO').html(completeRatio);
          
          var scoreAvg = isEmpty(data03.SCORE_AVG) ? 0 : data03.SCORE_AVG;
          $('#PROFILE_SCORE_AVG').html(scoreAvg);
          
          var completeCnt = isEmpty(data03.COMPLETE_CNT) ? 0 : addComma(data03.COMPLETE_CNT);
          $('#PROFILE_COMPLETE_CNT').html(completeCnt);
          
          var completeAmount = isEmpty(data03.COMPLETE_AMOUNT) ? 0 : addComma(data03.COMPLETE_AMOUNT);
          $('#PROFILE_COMPLETE_AMOUNT').html(completeAmount);
        }
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  $(document).ready(function() {
    fnGetProfile();
  });
  
</script>
  
<div class="modal fade" id="profileModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="width: fit-content;">
      <div class="cad_container">
        <div class="dialog_header">
          <p class="dialog_header_typo">프로필 보기</p>
          <a href="javascript:void(0);" data-bs-dismiss="modal" aria-label="Close">
            <img class="dialog_close_button" src="/public/assets/images/dialog_close_button.svg"/>
          </a>
        </div>
        <div class="profile_view_body">
          <div class="profile_management_profile_item basic_info">
            <div class="profile_management_profile_info_container">
              <div class="profile_management_profile_pic_upload">
                <img id="PROFILE_FILE_CD" class="profile_management_main_pic_upload" src="/public/assets/images/profile_image.svg" alt="no_image">
              </div>
              <div class="profile_management_profile_info_typo_container">
                <p id="PROFILE_USER_NICK_NAME" class="profile_management_profile_info_name">홍길동</p>
                <div class="profile_management_profile_info_sub_info_container">
                  <p class="profile_management_profile_info_sub_info_title">회원구분</p>
                  <p id="PROFILE_USER_TYPE_NM" class="profile_management_profile_info_sub_info_context">기업회원</p>
                  <p class="profile_management_profile_info_sub_info_title hidden">세금계산서 발행가능 유뮤</p>
                  <p id="PROFILE_TAX_BILL_YN" class="profile_management_profile_info_sub_info_context hidden"></p>
                </div>
              </div>
            </div>
          </div>
          <div class="profile_management_profile_item etc_info">
            <div class="profile_management_profile_etc_info_success_rate">
              <p class="profile_management_profile_etc_info_title">거래성공률</p>
              <div class="profile_management_profile_etc_info_context_container">
                <img class="profile_management_profile_satisfaction_img" src="/public/assets/images/satisfaction_very_good.svg"/>
                <p id="PROFILE_COMPLETE_RATIO" class="profile_management_profile_etc_info_context">0</p>
                <p class="profile_management_profile_etc_info_context_unit ">%</p>
              </div>
            </div>
            <div class="profile_management_profile_etc_info_satisfaction">
              <p class="profile_management_profile_etc_info_title">만족도</p>
              <div class="profile_management_profile_etc_info_context_container">
                <img class="profile_management_profile_satisfaction_img" src="/public/assets/images/satisfaction_good.svg"/>
                <p id="PROFILE_SCORE_AVG" class="profile_management_profile_etc_info_context">0</p>
                <p class="profile_management_profile_etc_info_context_unit ">/10</p>
              </div>
            </div>
            <div class="profile_management_profile_etc_info_total_project">
              <p class="profile_management_profile_etc_info_title">거래 총 프로젝트 수</p>
              <div class="profile_management_profile_etc_info_context_container">
                <p id="PROFILE_COMPLETE_CNT" class="profile_management_profile_etc_info_context">0</p>
                <p class="profile_management_profile_etc_info_context_unit ">건</p>
              </div>
            </div>
            <div class="profile_management_profile_etc_info_total_price">
              <p class="profile_management_profile_etc_info_title">거래 총 금액</p>
              <div class="profile_management_profile_etc_info_context_container">
                <p id="PROFILE_COMPLETE_AMOUNT" class="profile_management_profile_etc_info_context">0</p>
                <p class="profile_management_profile_etc_info_context_unit ">원</p>
              </div>
            </div>
          </div>
          <div class="dotted_divider_container">
            <img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
            <img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
          </div>
          <div class="profile_management_profile_item self_intro">
            <p class="profile_management_profile_item_title">자기소개</p>
            <p id="PROFILE_INTRO_CONTENT" class="profile_management_profile_self_intro_context">데이터가 존재하지 않습니다.</p>
          </div>
          <div class="main_container_divider"></div>
          <div class="profile_management_profile_item career">
            <p class="profile_management_profile_item_title">경력</p>
            <div class="profile_management_profile_career_container">
              <p id="PROFILE_CAREER_NM" class="profile_management_profile_career_typo">데이터가 존재하지 않습니다.</p>
            </div>
          </div>
          <div class="main_container_divider"></div>
          <div class="profile_management_profile_item design_field">
            <p class="profile_management_profile_item_title">디자인 활동 분야</p>
            <div class="profile_management_profile_design_field_container"></div>
          </div>
          <div class="main_container_divider"></div>
          <div class="profile_management_profile_item pic">
            <p class="profile_management_profile_item_title">뽐내기 사진</p>
            <div class="profile_management_profile_pic_container">
              <div class="profile_management_profile_pic_main">
                <img id="IMAGE_FILE_CD" class="profile_management_main_pic_upload" src="/public/assets/images/profile_image.svg" alt="no_image">
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
