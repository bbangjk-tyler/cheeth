<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<c:if test="${empty sessionInfo.user}">
  <script>
  alert(getI8nMsg("alert.plzlogin"));//'로그인 후 이용가능 합니다.'
   location.href = '/api/login/view';
</script>
</c:if>
<script>
  
  var profileFileArray = new Array();
  var imageFileArray = new Array();
  
  function fnSaveNickName() {
    
    var userNickName = $('#USER_NICK_NAME').val();
    if(isEmpty(userNickName)) {
    	alert(getI8nMsg("alert.enterUserNm"));//닉네임을 입력하세요.
      $('#USER_NICK_NAME').focus();
      return;
    }
    
    var isConfirm = window.confirm(getI8nMsg("alert.confirm.chgNickNm"));//닉네임을 변경 하시겠습니까?\n닉네임 변경 시 새로고침 됩니다.
    if(!isConfirm) return;
    
    $.ajax({
    	url: '/' + API + '/mypage/profile_management_cheesigner/save08',
      type: 'POST',
      data: { USER_NICK_NAME : $('#USER_NICK_NAME').val() },
      cache: false,
      async: false,
      success: function(data) {
        if(data.result === 'N' && isNotEmpty(data.message)) {
          alert(data.message);
        } else {
          location.href = '/' + API + '/mypage/profile_management_cheesigner';
        }
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  function fnSave() {
    
    var projectCd8 = $('#PROJECT_CD_8').is(':checked');
    var projectNm8 = $('#PROJECT_NM_8').val();
    
    if(projectCd8 && isEmpty(projectNm8)) {
    	alert(getI8nMsg("alert.enterOther"));//기타를 입력하세요.
      $('#PROJECT_NM_8').focus();
      return;
    }
    
    var isConfirm = window.confirm(getI8nMsg("alert.confirm.save")); //저장하시겠습니까?
    if(!isConfirm) return;
    
    var formData = new FormData(document.getElementById('saveForm'));
    for(var key of formData.keys()) {
      formData.set(key, JSON.stringify(formData.get(key)));
    }
    
    for(var i=0; i<profileFileArray.length; i++) {
      formData.append("profile_files", profileFileArray[i].FILE);
    }
    
    for(var i=0; i<imageFileArray.length; i++) {
      formData.append("image_files", imageFileArray[i].FILE);
    }
    
    $.ajax({
      url: '/' + API + '/mypage/profile_management_cheesigner/save09',
      type: 'POST',
      data: formData,
      cache: false,
      async: false,
      contentType: false,
      processData: false,
      success: function(data) {
        location.href = '/' + API + '/mypage/profile_management_cheesigner';
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  function fnPreviewImage() {
    var target = arguments[0];
    const defaultImgSrc = '/public/assets/images/profile_image.svg';
    const file = event.target.files[0];
    if(isNotEmpty(file)) {
      const type = file.type;
      const mimeTypeList = [ 'image/png', 'image/jpeg', 'image/gif', 'image/bmp' ];
      if(mimeTypeList.includes(type)) {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = (event) => {
          const imgSrc = event.target.result;
          if(target === 'profile') {
            $('#PROFILE_FILE').prop('src', imgSrc);
          } else if(target === 'image') {
            $('#IMAGE_FILE').prop('src', imgSrc);
          }
        }
        var obj = new Object();
        obj.FILE = file;
        if(target === 'profile') {
        	profileFileArray = new Array();
          profileFileArray.push(obj);
        } else if(target === 'image') {
        	imageFileArray = new Array();
          imageFileArray.push(obj);
        }
      } else {
    	  alert(getI8nMsg("alert.notImage"));//이미지 파일이 아닙니다.
        if(target === 'profile') {
          profileFileArray = new Array();
          $('#PROFILE_FILE').prop('src', defaultImgSrc);
        } else if(target === 'image') {
          imageFileArray = new Array();
          $('#IMAGE_FILE').prop('src', defaultImgSrc);
        }
      }
    }
  }
  
  function fnProject() {
    var projectCd = arguments[0];
    if(projectCd === 'P008') {
      var projectCd8 = $('#PROJECT_CD_8').is(':checked');
      var projectNm8 = $('#PROJECT_NM_8').val();
      if(projectCd8) {
        $('#PROJECT_NM_8').focus();
      } else {
        $('#PROJECT_NM_8').val('');
      }
    }
  }
  
  $(document).ready(function() {
    
   var projectCd1 = '${DATA.DATA_02.PROJECT_CD_1}';
   var projectCd2 = '${DATA.DATA_02.PROJECT_CD_2}';
   var projectCd3 = '${DATA.DATA_02.PROJECT_CD_3}';
   var projectCd4 = '${DATA.DATA_02.PROJECT_CD_4}';
   var projectCd5 = '${DATA.DATA_02.PROJECT_CD_5}';
   var projectCd6 = '${DATA.DATA_02.PROJECT_CD_6}';
   var projectCd7 = '${DATA.DATA_02.PROJECT_CD_7}';
   var projectCd8 = '${DATA.DATA_02.PROJECT_CD_8}';
   
   if(isNotEmpty(projectCd1)) $('#PROJECT_CD_1').prop('checked', true);
   if(isNotEmpty(projectCd2)) $('#PROJECT_CD_2').prop('checked', true);
   if(isNotEmpty(projectCd3)) $('#PROJECT_CD_3').prop('checked', true);
   if(isNotEmpty(projectCd4)) $('#PROJECT_CD_4').prop('checked', true);
   if(isNotEmpty(projectCd5)) $('#PROJECT_CD_5').prop('checked', true);
   if(isNotEmpty(projectCd6)) $('#PROJECT_CD_6').prop('checked', true);
   if(isNotEmpty(projectCd7)) $('#PROJECT_CD_7').prop('checked', true);
   if(isNotEmpty(projectCd8)) $('#PROJECT_CD_8').prop('checked', true);
   
  });
  
</script>

<div class="equipment_estimator_header">
  <p class="equipment_estimator_header_typo">프로필 관리</p>
</div>
<div class="equipment_estimator_body">
  <div class="side_menu">
    <div class="side_menu_title">
      <p class="side_menu_title_typo">전체보기</p>
    </div>
          <c:if test="${sessionInfo.user.USER_TYPE_CD eq 2}">
          <a href="/${api}/mypage/equipment_estimator_my_page_cad" class="side_menu_list">
		  </c:if>
		  <c:if test="${sessionInfo.user.USER_TYPE_CD eq 3}">
          <a href="/${api}/mypage/equipment_estimator_my_page_sent" class="side_menu_list">
		  </c:if>
		  <c:if test="${sessionInfo.user.USER_TYPE_CD eq 1}">
          <a href="/${api}/mypage/equipment_estimator_my_page_equipment" class="side_menu_list">
		  </c:if>
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo">견적·의뢰내역</p>
    </a>
    <a href="/${api}/tribute/request_basket" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo">의뢰서 바구니</p>
    </a>
    <a href="/${api}/mypage/equipment_estimator_my_page_progress" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo">진행내역</p>
    </a>
    <c:choose>
      <c:when test="${sessionInfo.user.USER_TYPE_CD eq 1 or sessionInfo.user.USER_TYPE_CD eq 2}">
        <a href="/${api}/mypage/profile_management" class="side_menu_list">
          <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
          <p class="side_menu_list_typo_blue">프로필 관리</p>
        </a>
      </c:when>
      <c:when test="${sessionInfo.user.USER_TYPE_CD eq 3}">
        <a href="/${api}/mypage/profile_management_cheesigner" class="side_menu_list">
          <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
          <p class="side_menu_list_typo_blue">프로필 관리</p>
        </a>
      </c:when>
    </c:choose>
    <a href="/${api}/review/client_review" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo">후기관리</p>
    </a>
    <a href="/${api}/mypage/my_page_edit_info" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo">내정보 수정</p>
    </a>
    <a href="javascript:fnLogOut();" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo">로그아웃</p>
    </a>
  </div>
	  <div class="profile_management_main_container">
	    <div class="profile_management_connection_location_container">
	      <a href="/" class="profile_management_connection_location_typo">
	        <img class="profile_management_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
	      </a>
	      <img class="profile_management_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="profile_management_connection_location">
	        <p class="profile_management_connection_location_typo">마이페이지</p>
	      </div>
	      <img class="profile_management_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="profile_management_connection_location">
	        <p class="profile_management_connection_location_typo">프로필관리</p>
	      </div>  
	      <img class="profile_management_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="profile_management_connection_location">
	        <p class="profile_management_connection_location_typo_bold">프로필 수정하기</p>
	      </div>
	    </div>
	    <div class="connection_location_divider"></div>
	    <div class="profile_management_profile_container">
	      <div class="profile_management_writing_profile_item basic_info">
	                       <div class="profile_management_profile_info_container">
	               <c:choose>
                  <c:when test="${empty DATA.DATA_02.PROFILE_FILE_CD}">
                   <div class="profile_management_profile_pic_upload"></div>
                  </c:when>
                  <c:otherwise>
                  <div class="profile_management_profile_pic_upload">
                  <img id="PROFILE_FILE" class="profile_management_writing_profile_pic_upload" src="/upload/${DATA.DATA_02.PROFILE_FILE_DIRECTORY}" alt="${DATA.DATA_02.PROFILE_FILE_ORIGIN_NM}">
                  </div>
                  </c:otherwise>
                </c:choose>
                            <div class="profile_management_profile_info_typo_container">
                                <p class="profile_management_profile_info_name">Lv.1 ${DATA.DATA_01.USER_NICK_NAME}</p>
                                <div class="profile_management_profile_info_sub_info_container">
                                    <p class="profile_management_profile_info_sub_info_title">회원구분</p>
                                    <p class="profile_management_profile_info_sub_info_context">${DATA.DATA_01.USER_TYPE_NM}</p>
                                    <p class="profile_management_profile_info_sub_info_divider">|</p>
                                    <p class="profile_management_profile_info_sub_info_title">세금계산서 발행가능 유뮤</p>
                                    <p class="profile_management_profile_info_sub_info_context">
                                    <c:choose>
                                    <c:when test="${empty DATA.DATA_02.TAX_BILL_YN}">
                                    	무
                                    </c:when>
                                    <c:when test="${DATA.DATA_02.TAX_BILL_YN eq 'Y'}">
                                    	유
                                    </c:when>
                                    <c:when test="${DATA.DATA_02.TAX_BILL_YN eq 'N'}">
                                    	무
                                    </c:when>
                                    </c:choose>
                                    	</p>
                                </div>
                            </div>
                        </div>
	                        <div class="profile_management_profile_button_container">
                            <a href="./project_request.html" class="profile_management_profile_button_blue">
                                <p class="profile_management_profile_button_typo_blue">견적요청하기</p>
                            </a>
                        </div>
                    </div>
                    <div class="profile_management_profile_item etc_info">
                        <div class="profile_management_profile_etc_info_success_rate">
                            <p class="profile_management_profile_etc_info_title">거래성공률</p>
                            <div class="profile_management_profile_etc_info_context_container">
                                <img class="profile_management_profile_satisfaction_img" src="../assets/images/satisfaction_very_good.svg"/>
                                <p class="profile_management_profile_etc_info_context">100</p>
                                <p class="profile_management_profile_etc_info_context_unit ">%</p>
                            </div>
                        </div>
                        <div class="profile_management_profile_etc_info_satisfaction">
                            <p class="profile_management_profile_etc_info_title">만족도</p>
                            <div class="profile_management_profile_etc_info_context_container">
                                <img class="profile_management_profile_satisfaction_img" src="../assets/images/satisfaction_good.svg"/>
                                <p class="profile_management_profile_etc_info_context">8</p>
                                <p class="profile_management_profile_etc_info_context_unit ">/10</p>
                            </div>
                        </div>
                        <div class="profile_management_profile_etc_info_total_project">
                            <p class="profile_management_profile_etc_info_title">거래 총 프로젝트 수</p>
                            <div class="profile_management_profile_etc_info_context_container">
                                <p class="profile_management_profile_etc_info_context">12</p>
                                <p class="profile_management_profile_etc_info_context_unit ">건</p>
                            </div>
                        </div>
                        <div class="profile_management_profile_etc_info_total_price">
                            <p class="profile_management_profile_etc_info_title">거래 총 금액</p>
                            <div class="profile_management_profile_etc_info_context_container">
                                <p class="profile_management_profile_etc_info_context">123,456</p>
                                <p class="profile_management_profile_etc_info_context_unit ">원</p>
                            </div>
                        </div>
                        <div class="profile_management_profile_etc_info_mean_response">
                            <p class="profile_management_profile_etc_info_title">평균응답시간</p>
                            <div class="profile_management_profile_etc_info_context_container">
                                <p class="profile_management_profile_etc_info_context">1</p>
                                <p class="profile_management_profile_etc_info_context_unit ">시간&nbsp;&nbsp;~&nbsp;&nbsp;</p>
                                <p class="profile_management_profile_etc_info_context">2</p>
                                <p class="profile_management_profile_etc_info_context_unit ">시간</p>
                            </div>
                        </div>
                    </div>
                    <div class="dotted_divider_container">
                        <img class="dotted_divider" src="../assets/images/dotted_divider.svg"/>
                        <img class="dotted_divider" src="../assets/images/dotted_divider.svg"/>
                    </div>
                    <div class="profile_management_profile_item self_intro">
                        <p class="profile_management_profile_item_title">자기소개</p>
                        <p class="profile_management_profile_self_intro_context">새로운 회계연도가 개시될 때까지 예산안이 의결되지 못한 때에는 정부는 국회에서 예산안이 의결될 때까지 다음의 목적을 위한 경비는 전년도 예산에 준하여 집행할 수 있다. 탄핵결정은
                            공직으로부터 파면함에 그친다. 그러나, 이에 의하여 민사상이나 형사상의 책임이 면제되지는 아니한다. 국가는 대외무역을 육성하며, 이를 규제·조정할 수 있다. 모든 국민은 신체의 자유
                            를 가진다. 누구든지 법률에 의하지 아니하고는 체포·구속·압수·수색 또는 심문을 받지 아니하며, 법률과 적법한 절차에 의하지 아니하고는 처벌·보안처분 또는 강제노역을 받지 아니한다.</p>
                    </div>
                    <div class="main_container_divider"></div>
                    <div class="profile_management_profile_item career">
                        <p class="profile_management_profile_item_title">경력</p>
                        <div class="profile_management_profile_career_container">
                            <div class="profile_management_profile_career">
                                <img class="profile_management_profile_career_img" src="../assets/images/career_year_under_three.svg"/>
                                <p class="profile_management_profile_career_typo">경력 3년이내</p>
                            </div>
                            <div class="profile_management_profile_career selected">
                                <img class="profile_management_profile_career_img" src="../assets/images/career_year_three_to_five.svg"/>
                                <p class="profile_management_profile_career_typo">3~5년</p>
                            </div>
                            <div class="profile_management_profile_career">
                                <img class="profile_management_profile_career_img" src="../assets/images/career_year_five_to_ten.svg"/>
                                <p class="profile_management_profile_career_typo">5~10년</p>
                            </div>
                            <div class="profile_management_profile_career">
                                <img class="profile_management_profile_career_img" src="../assets/images/career_year_over_ten.svg"/>
                                <p class="profile_management_profile_career_typo">10년 이상</p>
                            </div>
                        </div>
                    </div>
                    <div class="main_container_divider"></div>
                    <div class="profile_management_profile_item design_field">
                        <p class="profile_management_profile_item_title">디자인 활동 분야</p>
                        <div class="profile_management_profile_design_field_container">
                            <div class="profile_management_profile_design_field">
                                <p class="profile_management_profile_design_field_typo">크라운</p>
                            </div>
                            <div class="profile_management_profile_design_field">
                                <p class="profile_management_profile_design_field_typo">인레이</p>
                            </div>
                            <div class="profile_management_profile_design_field">
                                <p class="profile_management_profile_design_field_typo">프레임</p>
                            </div>
                            <div class="profile_management_profile_design_field">
                                <p class="profile_management_profile_design_field_typo">의치(배열)</p>
                            </div>
                            <div class="profile_management_profile_design_field">
                                <p class="profile_management_profile_design_field_typo">서지컬가이드</p>
                            </div>
                            <div class="profile_management_profile_design_field">
                                <p class="profile_management_profile_design_field_typo">스프린트</p>
                            </div>
                            <div class="profile_management_profile_design_field">
                                <p class="profile_management_profile_design_field_typo">어버트먼트</p>
                            </div>
                            <div class="profile_management_profile_design_field">
                                <p class="profile_management_profile_design_field_typo">교정</p>
                            </div>
                            <div class="profile_management_profile_design_field">
                                <p class="profile_management_profile_design_field_typo">기타(직접작성)</p>
                            </div>
                        </div>
                    </div>
                    <div class="main_container_divider"></div>
                    <div class="profile_management_profile_item pic">

							<div class="profile-swiper" id="profileSwiper1">

								<div class="profile-swiper-head">
									<p class="profile_management_profile_item_title">뽐내기 사진(10장 이내)</p>
									<div class="swiper-button-wrap">
										<div class="swiper-button"><div class="swiper-button-prev"></div></div>
										<div class="swiper-button"><div class="swiper-button-next"></div></div>
									</div>
								</div>

								<div class="swiper-container">
									<div class="swiper-wrapper">
										<div class="swiper-slide">
											<img src="../assets/images/swiper_sample.jpg" class="swiper-slide-img">
										</div>
										<div class="swiper-slide">
											<img src="../assets/images/swiper_sample.jpg" class="swiper-slide-img">
										</div>
										<div class="swiper-slide">
											<img src="../assets/images/swiper_sample.jpg" class="swiper-slide-img">
										</div>
										<div class="swiper-slide">
											<img src="../assets/images/swiper_sample.jpg" class="swiper-slide-img">
										</div>
										<div class="swiper-slide">
											<img src="../assets/images/swiper_sample.jpg" class="swiper-slide-img">
										</div>
										<div class="swiper-slide">
											<img src="../assets/images/swiper_sample.jpg" class="swiper-slide-img">
										</div>
									</div>
								</div>

								<div class="profile_management_profile_pic_background_wrapper"></div>

							</div>

                    </div>
                    <div class="profile_management_profile_item customer_review">

							<div class="profile-swiper" id="profileSwiper2">

								<div class="profile-swiper-head">
									<p class="profile_management_profile_item_title">고객리뷰</p>
									<div class="swiper-button-wrap">
										<div class="swiper-button"><div class="swiper-button-prev"></div></div>
										<div class="swiper-button"><div class="swiper-button-next"></div></div>
									</div>
									<a href="../dialog/customer_review_view_all.html" class="profile_management_profile_item_view_all">전체보기</a>
								</div>

								<div class="swiper-container">
									<div class="swiper-wrapper">
										<div class="swiper-slide">
											 <div class="profile_management_customer_review">
												  <p class="profile_management_customer_review_title">지르콘, 어버트먼트</p>
												  <div class="profile_management_customer_review_star_rating">
														<div class="profile_management_customer_review_star_rating_star_container">
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/blank_star.svg"/>
														</div>
														<p class="profile_management_customer_review_star_rating_numb">8</p>
														<p class="profile_management_customer_review_star_rating_unit">/</p>
														<p class="profile_management_customer_review_star_rating_unit">1</p>
														<p class="profile_management_customer_review_star_rating_unit">0</p>
												  </div>
												  <div class="profile_management_customer_review_divider"></div>
												  <p class="profile_management_customer_review_context">
														일반사면을 명하려면 국회의 동의를 얻어야 한다. 감사위원은 원장
														의 제청으로 대통령이 임명하고, 그 임기는 4년으로 하며, 1차에 한
														하여 중임할 수 있다.
												  </p>
												  <p class="profile_management_customer_review_date_wrote">2022년 02월 02일</p>
											 </div>
										</div>
										<div class="swiper-slide">

											 <div class="profile_management_customer_review">
												  <p class="profile_management_customer_review_title">지르콘, 어버트먼트</p>
												  <div class="profile_management_customer_review_star_rating">
														<div class="profile_management_customer_review_star_rating_star_container">
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/blank_star.svg"/>
														</div>
														<p class="profile_management_customer_review_star_rating_numb">8</p>
														<p class="profile_management_customer_review_star_rating_unit">/</p>
														<p class="profile_management_customer_review_star_rating_unit">1</p>
														<p class="profile_management_customer_review_star_rating_unit">0</p>
												  </div>
												  <div class="profile_management_customer_review_divider"></div>
												  <p class="profile_management_customer_review_context">
														일반사면을 명하려면 국회의 동의를 얻어야 한다. 감사위원은 원장
														의 제청으로 대통령이 임명하고, 그 임기는 4년으로 하며, 1차에 한
														하여 중임할 수 있다.
												  </p>
												  <p class="profile_management_customer_review_date_wrote">2022년 02월 02일</p>
											 </div>
										</div>
										<div class="swiper-slide">

											 <div class="profile_management_customer_review">
												  <p class="profile_management_customer_review_title">지르콘, 어버트먼트</p>
												  <div class="profile_management_customer_review_star_rating">
														<div class="profile_management_customer_review_star_rating_star_container">
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/blank_star.svg"/>
														</div>
														<p class="profile_management_customer_review_star_rating_numb">8</p>
														<p class="profile_management_customer_review_star_rating_unit">/</p>
														<p class="profile_management_customer_review_star_rating_unit">1</p>
														<p class="profile_management_customer_review_star_rating_unit">0</p>
												  </div>
												  <div class="profile_management_customer_review_divider"></div>
												  <p class="profile_management_customer_review_context">
														일반사면을 명하려면 국회의 동의를 얻어야 한다. 감사위원은 원장
														의 제청으로 대통령이 임명하고, 그 임기는 4년으로 하며, 1차에 한
														하여 중임할 수 있다.
												  </p>
												  <p class="profile_management_customer_review_date_wrote">2022년 02월 02일</p>
											 </div>
										</div>
										<div class="swiper-slide">
											 <div class="profile_management_customer_review">
												  <p class="profile_management_customer_review_title">지르콘, 어버트먼트</p>
												  <div class="profile_management_customer_review_star_rating">
														<div class="profile_management_customer_review_star_rating_star_container">
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/blank_star.svg"/>
														</div>
														<p class="profile_management_customer_review_star_rating_numb">8</p>
														<p class="profile_management_customer_review_star_rating_unit">/</p>
														<p class="profile_management_customer_review_star_rating_unit">1</p>
														<p class="profile_management_customer_review_star_rating_unit">0</p>
												  </div>
												  <div class="profile_management_customer_review_divider"></div>
												  <p class="profile_management_customer_review_context">
														일반사면을 명하려면 국회의 동의를 얻어야 한다. 감사위원은 원장
														의 제청으로 대통령이 임명하고, 그 임기는 4년으로 하며, 1차에 한
														하여 중임할 수 있다.
												  </p>
												  <p class="profile_management_customer_review_date_wrote">2022년 02월 02일</p>
											 </div>
										</div>
										<div class="swiper-slide">
											 <div class="profile_management_customer_review">
												  <p class="profile_management_customer_review_title">지르콘, 어버트먼트</p>
												  <div class="profile_management_customer_review_star_rating">
														<div class="profile_management_customer_review_star_rating_star_container">
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/blank_star.svg"/>
														</div>
														<p class="profile_management_customer_review_star_rating_numb">8</p>
														<p class="profile_management_customer_review_star_rating_unit">/</p>
														<p class="profile_management_customer_review_star_rating_unit">1</p>
														<p class="profile_management_customer_review_star_rating_unit">0</p>
												  </div>
												  <div class="profile_management_customer_review_divider"></div>
												  <p class="profile_management_customer_review_context">
														일반사면을 명하려면 국회의 동의를 얻어야 한다. 감사위원은 원장
														의 제청으로 대통령이 임명하고, 그 임기는 4년으로 하며, 1차에 한
														하여 중임할 수 있다.
												  </p>
												  <p class="profile_management_customer_review_date_wrote">2022년 02월 02일</p>
											 </div>
										</div>
										<div class="swiper-slide">
											 <div class="profile_management_customer_review">
												  <p class="profile_management_customer_review_title">지르콘, 어버트먼트</p>
												  <div class="profile_management_customer_review_star_rating">
														<div class="profile_management_customer_review_star_rating_star_container">
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/full_star.svg"/>
															 <img class="profile_management_customer_review_star_rating_star" src="../assets/images/blank_star.svg"/>
														</div>
														<p class="profile_management_customer_review_star_rating_numb">8</p>
														<p class="profile_management_customer_review_star_rating_unit">/</p>
														<p class="profile_management_customer_review_star_rating_unit">1</p>
														<p class="profile_management_customer_review_star_rating_unit">0</p>
												  </div>
												  <div class="profile_management_customer_review_divider"></div>
												  <p class="profile_management_customer_review_context">
														일반사면을 명하려면 국회의 동의를 얻어야 한다. 감사위원은 원장
														의 제청으로 대통령이 임명하고, 그 임기는 4년으로 하며, 1차에 한
														하여 중임할 수 있다.
												  </p>
												  <p class="profile_management_customer_review_date_wrote">2022년 02월 02일</p>
											 </div>
										</div>
									</div><!-- // swiper-wrapper -->
								</div><!-- // swiper-container -->

							</div><!-- // profile-swiper -->

							<script>

							jQuery(function($){
								var project_swiper1 = new Swiper('#profileSwiper1 .swiper-container', {
									slidesPerView: 4,
									spaceBetween: 24,
									speed:600,
									navigation: {
										nextEl: '#profileSwiper1 .swiper-button-next',
										prevEl: '#profileSwiper1 .swiper-button-prev',
									},
								});
								var project_swiper2 = new Swiper('#profileSwiper2 .swiper-container', {
									slidesPerView: 4,
									spaceBetween: 24,
									speed:600,
									navigation: {
										nextEl: '#profileSwiper2 .swiper-button-next',
										prevEl: '#profileSwiper2 .swiper-button-prev',
									},
								});
							});
							</script>

                    </div>
                </div>


            </div>
        </div>