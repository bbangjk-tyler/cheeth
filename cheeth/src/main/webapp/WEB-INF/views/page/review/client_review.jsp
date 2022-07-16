<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if>
<script>
  
  function fnDelete() {
    
    var reviewNo = arguments[0];
    var projectNo = arguments[1];
	  
    var isConfirm = window.confirm('삭제 하시겠습니까?');
    if(!isConfirm) return;
    
    $.ajax({
      url: '/' + API + '/review/delete01',
      type: 'POST',
      data: { REVIEW_NO: reviewNo, PROJECT_NO: projectNo },
      cache: false,
      async: false,
      success: function(data) {
        fnSearch();
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  function fnReplySave() {
    
    var reviewNo = arguments[0];
    var replyContent = $('#' + 'REPLY_CONTENT_' + reviewNo).val();
    
    if(isEmpty(replyContent)) {
      alert('답변을 입력하세요.');
      $('#' + 'REPLY_CONTENT_' + reviewNo).focus();
      return;
    }
    
    var isConfirm = window.confirm('등록 하시겠습니까?');
    if(!isConfirm) return;
    
    $.ajax({
      url: '/' + API + '/review/save02',
      type: 'POST',
      data: { REVIEW_NO: reviewNo, REPLY_CONTENT: replyContent },
      cache: false,
      async: false,
      success: function(data) {
        if(data.result === 'Y') {
          alert('답변이 등록되었습니다.');
        }
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  function fnSearch() {
    var page = arguments[0] ?? '${PAGE}';
    var url = '/' + API + '/review/client_review';
    url += '?PAGE=' + page;
    location.href = url;
  }
  
  function fnReplyOpen() {
    var reviewNo = arguments[0];
    var id = 'reply_' + reviewNo;
    $('#' + id).show('slow');
    $('#' + id).find('textarea').focus();
  }
  
  function fnReplyClose() {
    var reviewNo = arguments[0];
    var id = 'reply_' + reviewNo;
    $('#' + id).hide('slow');
  }
  
  $(document).ready(function() {
    
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
    <c:choose>
      <c:when test="${sessionInfo.user.USER_TYPE_CD eq 1 or sessionInfo.user.USER_TYPE_CD eq 2}">
        <a href="/${api}/mypage/profile_management" class="side_menu_list">
          <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
          <p class="side_menu_list_typo">프로필 관리</p>
        </a>
      </c:when>
      <c:when test="${sessionInfo.user.USER_TYPE_CD eq 3}">
        <a href="/${api}/mypage/profile_management_cheesigner" class="side_menu_list">
          <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
          <p class="side_menu_list_typo">프로필 관리</p>
        </a>
      </c:when>
    </c:choose>
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
        <button type="button" class="review_management_card_chip seleted" onclick="location.href='/${api}/review/client_review'">
          <p class="review_management_card_chip_typo">고객후기</p>
        </button>
        <button type="button" class="review_management_card_chip" onclick="location.href='/${api}/review/my_review'">
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
               <button type="button" class="review_management_customer_review_button_white" onclick="fnDelete(${item.REVIEW_NO}, ${item.PROJECT_NO});">
                 <p class="review_management_customer_review_button_white_typo">삭제하기</p>
               </button>
               <button type="button" class="review_management_customer_review_button_black" onclick="fnReplyOpen(${item.REVIEW_NO});">
                 <p class="review_management_customer_review_button_black_typo">답장하기</p>
               </button>
             </div>
           </div>
         </div>
       </div>
       <div class="main_container_divider without_margin"></div>
       <div id="reply_${item.REVIEW_NO}" class="review_management_customer_review_reply">
         <textarea id="REPLY_CONTENT_${item.REVIEW_NO}" class="review_management_customer_review_reply_blank" maxlength="1300" placeholder="답장하기">${item.REPLY_CONTENT}</textarea>
         <div class="review_management_customer_review_button_container">
           <button type="button" class="review_management_customer_review_button_white" onclick="fnReplyClose(${item.REVIEW_NO});">
             <p class="review_management_customer_review_button_white_typo">닫기</p>
           </button>
           <button type="button" class="review_management_customer_review_button_black" style="background: #444;" onclick="fnReplySave(${item.REVIEW_NO});">
             <p class="review_management_customer_review_button_black_typo">등록하기</p>
           </button>
         </div>
       </div>
       <!-- 반복 끝 -->
      </c:forEach>
    </div>
    <c:if test="${not empty DATA.LIST}">
      <div class="pagination"></div>
    </c:if>
  </div>
</div>
