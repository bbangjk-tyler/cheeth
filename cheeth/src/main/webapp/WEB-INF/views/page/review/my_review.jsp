<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if>
<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>
<link type="text/css" rel="stylesheet" href="/public/assets/css/modal.css"/>

<script>
  
  var reviewUpdateModal;
  
  function fnDelete() {
    
    var reviewNo = arguments[0];
    
    var isConfirm = window.confirm('삭제 하시겠습니까?');
    if(!isConfirm) return;
    
    $.ajax({
      url: '/' + API + '/review/delete02',
      type: 'POST',
      data: { REVIEW_NO: reviewNo },
      cache: false,
      async: false,
      success: function(data) {
        fnSearch();
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  function fnViewReply() {
    
    var target = arguments[0];
    var reviewNo = arguments[1];
    
    var div = $('#' + 'reply_' + reviewNo);
    var html = '<p class="review_management_customer_review_view_reply_button_typo">답변보기</p>';
    if(div.is(':visible')) {
      div.hide('slow');
      html += '<img class="review_management_customer_review_view_reply_button_arrow" src="/public/assets/images/review_management_customer_review_view_reply_button_arrow.svg"/>';
    } else {
      div.show('slow');
      html += '<img class="review_management_customer_review_view_reply_button_arrow_selected" src="/public/assets/images/review_management_customer_review_view_reply_button_arrow.svg"/>';
    }
    $(target).html(html);
  }
  
  function fnSearch() {
	  var page = arguments[0] ?? '${PAGE}';
    var url = '/' + API + '/review/my_review';
    url += '?PAGE=' + page;
    location.href = url;
  }
  
  function fnUpdate() {
    var reviewNo = arguments[0];
    fnGetReviewData(reviewNo);
    reviewUpdateModal.show();
  }
  
  $(document).ready(function() {
    
    reviewUpdateModal = new bootstrap.Modal(document.getElementById('reviewUpdateModal'));
    fnSetPageInfo('${PAGE}', '${DATA.TOTAL_CNT}', 10);
    
  });
  
</script>

<div class="review_management_header">
  <p class="review_management_header_typo">후기관리</p>
</div>
<div class="review_management_body">
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
    <a href="/${api}/mypage/profile_management" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo">프로필 관리</p>
    </a>
    <a href="/${api}/review/client_review" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo_blue">후기관리</p>
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
  
  <div class="review_management_main_container">
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
        <p class="profile_management_connection_location_typo_bold">후기관리</p>
      </div>
    </div>
    <div class="review_management_review_container">
      <div class="review_management_card_chip_container">
        <button type="button" class="review_management_card_chip" onclick="location.href='/${api}/review/client_review'">
          <p class="review_management_card_chip_typo">고객후기</p>
        </button>
        <button type="button" class="review_management_card_chip seleted" onclick="location.href='/${api}/review/my_review'">
          <p class="review_management_card_chip_typo">내가 쓴 후기</p>
        </button>
      </div>
      <c:if test="${empty DATA.LIST}">
        <div class="review_management_no_review">
          <p class="review_management_no_review_typo">아직 등록된 후기가 없습니다</p>
        </div>
      </c:if>
      <c:forEach var="item" items="${DATA.LIST}" varStatus="status">
        <!-- 반복 시작 -->
        <div class="review_management_customer_review">
          <div class="review_management_customer_review_pic_upload_no_image">
            <c:choose>
              <c:when test="${empty item.FILE_CD}">
                <img class="no_image" src="/public/assets/images/customer_review_no_image.svg" alt="no_image">
                <p class="no_image_typo">NO IMAGE</p>
              </c:when>
              <c:otherwise>
                <img src="/upload/${item.FILE_DIRECTORY}" alt="${item.FILE_ORIGIN_NM}">
              </c:otherwise>
            </c:choose>
          </div>
          <div class="review_management_customer_review_info_container">
            <div class="review_management_customer_review_info_top_container">
              <c:if test="${not empty item.FILE_CD}">
                <p class="review_management_customer_review_photo_review">포토리뷰</p>
              </c:if>
              <div class="review_management_customer_review_star_rating">
                <div class="review_management_customer_review_star_rating_star">
                  <button type="button" class="star <c:if test="${item.SCORE ge 2}">active</c:if>" disabled="disabled">
                    <span class="sr-only">2점</span>
                  </button>
                  <button type="button" class="star <c:if test="${item.SCORE ge 4}">active</c:if>" disabled="disabled">
                    <span class="sr-only">4점</span>
                  </button>
                  <button type="button" class="star <c:if test="${item.SCORE ge 6}">active</c:if>" disabled="disabled">
                    <span class="sr-only">6점</span>
                  </button>
                  <button type="button" class="star <c:if test="${item.SCORE ge 8}">active</c:if>" disabled="disabled">
                    <span class="sr-only">8점</span>
                  </button>
                  <button type="button" class="star <c:if test="${item.SCORE eq 10}">active</c:if>" disabled="disabled">
                    <span class="sr-only">10점</span>
                  </button>
                </div>
                <p class="review_management_customer_review_star_rating_numb">${item.SCORE}</p>
                <p class="review_management_customer_review_star_rating_unit">/</p>
                <p class="review_management_customer_review_star_rating_unit">1</p>
                <p class="review_management_customer_review_star_rating_unit">0</p>
              </div>
              <p class="review_management_customer_review_context">${item.REVIEW_CONTENT}</p>
            </div>
            <div class="review_management_customer_review_info_bottom_container">
              <div class="review_management_customer_review_writer_info_container">
                <p class="review_management_customer_review_prosthetics_type">${item.TITLE}</p>
                <div class="review_management_customer_review_writer_info_divider"></div>
                <p class="review_management_customer_review_prosthetics_type">${item.PROJECT_CD_NM}</p>
                <div class="review_management_customer_review_writer_info_divider"></div>
                <p class="review_management_customer_review_writer_name">${item.CREATE_NICK_NAME}</p>
                <div class="review_management_customer_review_writer_info_divider"></div>
                <p class="review_management_customer_review_date_wrote">작성일 ${item.CREATE_DATE}</p>
                <c:if test="${item.CREATE_DATE ne item.UPDATE_DATE}">
                  <div class="review_management_customer_review_writer_info_divider"></div>
                  <p class="review_management_customer_review_date_wrote">수정일 ${item.UPDATE_DATE}</p>
                </c:if>
              </div>
              <div class="review_management_customer_review_button_container">
                <c:if test="${not empty item.REPLY_NO}">
                  <button type="button" class="review_management_customer_review_view_reply_button" onclick="fnViewReply(this, ${item.REVIEW_NO});">
                    <p class="review_management_customer_review_view_reply_button_typo">답변보기</p>
<!--                     <img class="review_management_customer_review_view_reply_button_arrow_selected" src="/public/assets/images/review_management_customer_review_view_reply_button_arrow.svg"/> -->
                    <img class="review_management_customer_review_view_reply_button_arrow" src="/public/assets/images/review_management_customer_review_view_reply_button_arrow.svg"/>
                  </button>
                </c:if>
                <button type="button" class="review_management_customer_review_button_white" onclick="fnDelete(${item.REVIEW_NO});">
                  <p class="review_management_customer_review_button_white_typo">삭제하기</p>
                </button>
                <c:if test="${empty item.REPLY_NO}">
                  <button type="button" class="review_management_customer_review_button_black" onclick="fnUpdate(${item.REVIEW_NO});">
                    <p class="review_management_customer_review_button_black_typo">수정하기</p>
                  </button>
                </c:if>
              </div>
            </div>
          </div>
        </div>
        <div class="main_container_divider without_margin"></div>
        <c:if test="${not empty item.REPLY_NO}">
          <div id="reply_${item.REVIEW_NO}" class="review_management_customer_review_view_reply" style="display: none;">
            <div class="review_management_customer_review_view_reply_top_container">
              <div class="review_management_customer_review_view_reply_writer_info">
                <p class="review_management_customer_review_view_reply_name">${item.REPLY_NICK_NAME}</p>
                <p class="review_management_customer_review_date_wrote">작성일 ${item.REPLY_CREATE_DATE}</p>
                <c:if test="${item.REPLY_CREATE_DATE ne item.REPLY_UPDATE_DATE}">
                  <div class="review_management_customer_review_writer_info_divider"></div>
                  <p class="review_management_customer_review_date_wrote">수정일 ${item.REPLY_UPDATE_DATE}</p>
                </c:if>
              </div>
            </div>
            <p class="review_management_customer_review_context">${item.REPLY_CONTENT}</p>
          </div>
        </c:if>
        <!-- 반복 끝 -->
      </c:forEach>
    </div>
    <c:if test="${not empty DATA.LIST}">
      <div class="pagination"></div>
    </c:if>
  </div>
</div>

<jsp:include page="/WEB-INF/views/dialog/review_update_dialog.jsp" flush="true" />
