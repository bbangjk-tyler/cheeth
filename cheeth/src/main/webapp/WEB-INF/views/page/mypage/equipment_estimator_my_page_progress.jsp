<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
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
<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>
<link type="text/css" rel="stylesheet" href="/public/assets/css/modal.css"/>

<script>

  var cadEstimatorViewModal;
  
  function fnCancel() {
    
    var projectNo = arguments[0];
    
    var isConfirm = window.confirm('취소요청 하시겠습니까?\n모든 계약정보가 삭제 됩니다.');
    if(!isConfirm) return;
    
    $.ajax({
      url: '/' + API + '/mypage/equipment_estimator_my_page_progress/save04',
      type: 'POST',
      data: { PROJECT_NO : projectNo },
      cache: false,
      async: false,
      success: function(data) {
        if(data.result === 'Y') {
          location.reload();
        }
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  function fnPayment() {
    
    var wrNo = arguments[0];
    
    var isConfirm = window.confirm('입금확인 하시겠습니까?');
    if(!isConfirm) return;
    
    $.ajax({
      url: '/' + API + '/mypage/equipment_estimator_my_page_progress/save06',
      type: 'POST',
      data: { WR_NO : wrNo },
      cache: false,
      async: false,
      success: function(data) {
        if(data.result === 'Y') {
          location.reload();
        }
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  function fnListToggle() {
    var target = arguments[0];
    var img = $(target).find('img');
    if(img.hasClass('equipment_estimator_my_page_progress_list_arrow')) {
      img.removeClass('equipment_estimator_my_page_progress_list_arrow');
      $(target).parent().next().show('slow');
    } else {
      img.addClass('equipment_estimator_my_page_progress_list_arrow');
      $(target).parent().next().hide('slow');
    }
  }
  
  function fnSearch() {
    var page = arguments[0] ?? '1';
    $('#PAGE').val(page);
    $('#searchForm').submit();
   }
  
  $(document).ready(function() {
    
    cadEstimatorViewModal = new bootstrap.Modal(document.getElementById('cadEstimatorViewModal'));
    fnSetPageInfo('${PAGE}', '${DATA.TOTAL_CNT}', 10);

  });
  var reviewWritingModal;
  $(document).ready(function() {
    
    reviewWritingModal = new bootstrap.Modal(document.getElementById('reviewWritingModal'));
    
    
  });

</script>
<style>
.equipment_estimator_my_page_progress_step_arrow {
	position: relative;
    float: left;
   /*  border: 1px solid #000; */
    width: 15px;
    /* height: 100px; */
    margin-right: 5px;
}
.equipment_estimator_my_page_progress_step_arrow::after {
    position: absolute;
    left: -7px;
    top: 5px;
    content: '';
    width: 23px;
    height: 23px;
    border-top: 2px solid #005fa8;
    border-right: 2px solid #005fa8;
    transform: rotate(45deg);
}
</style>
<jsp:include page="/WEB-INF/views/page/talk/common_send.jsp" flush="true"/>

<form:form id="searchForm" name="searchForm" action="/${api}/mypage/equipment_estimator_my_page_progress" method="GET">
  <div class="equipment_estimator_header">
    <p class="equipment_estimator_header_typo">진행내역</p>
  </div>
  
  <div class="equipment_estimator_body">
    <div class="side_menu">
      <div class="side_menu_title">
        <p class="side_menu_title_typo">전체보기</p>
      </div>
      <a href="/${api}/mypage/equipment_estimator_my_page_equipment" class="side_menu_list">
        <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
        <p class="side_menu_list_typo">견적·의뢰내역</p>
      </a>
      <a href="/${api}/tribute/request_basket" class="side_menu_list">
        <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
        <p class="side_menu_list_typo">의뢰서 바구니</p>
      </a>
      <a href="/${api}/mypage/equipment_estimator_my_page_progress" class="side_menu_list">
        <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
        <p class="side_menu_list_typo_blue">진행내역</p>
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
    <div class="equipment_estimator_main_container">
      <div class="equipment_estimator_connection_location_container">
        <a href="/" class="equipment_estimator_connection_location_typo">
          <img class="equipment_estimator_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
        </a>
        <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
        <div class="equipment_estimator_connection_location">
          <p class="equipment_estimator_connection_location_typo">마이페이지</p>
        </div>
        <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
        <div class="equipment_estimator_connection_location">
          <p class="equipment_estimator_connection_location_typo_bold">진행내역</p>
        </div>
      </div>
      <div class="equipment_estimator_filter_container">
         <select id="SEARCH_OPTION" name="SEARCH_OPTION" class="boardtop_select" onchange="fnSearch('1');">
           <option value=""  <c:if test="${empty param.SEARCH_OPTION}">selected="selected"</c:if>>전체보기</option>
           <option value="ING" <c:if test="${param.SEARCH_OPTION eq 'ING'}">selected="selected"</c:if>>진행 중 프로젝트 보기</option>
           <option value="CLEAR" <c:if test="${param.SEARCH_OPTION eq 'CLEAR'}">selected="selected"</c:if>>완료 프로젝트 보기</option>
         </select>
      </div>
      <div class="equipment_estimator_my_page_progress_wrapper">
        <div class="equipment_estimator_my_page_progress_container">
          <div class="equipment_estimator_my_page_progress_datatype_container">
            <div class="equipment_estimator_my_page_progress_datatype equipment_estimator_my_page_progress_current_datatype">
              <p class="equipment_estimator_my_page_progress_datatype_typo"></p>
            </div>
            <div class="equipment_estimator_my_page_progress_datatype equipment_estimator_my_page_progress_category_datatype">
              <p class="equipment_estimator_my_page_progress_datatype_typo">카테고리</p>
            </div>
            <div class="equipment_estimator_my_page_progress_datatype equipment_estimator_my_page_progress_context_datatype">
              <p class="equipment_estimator_my_page_progress_datatype_typo">의뢰내용</p>
            </div>
            <div class="equipment_estimator_my_page_progress_datatype equipment_estimator_my_page_progress_date_matched_datatype">
              <p class="equipment_estimator_my_page_progress_datatype_typo">매칭일</p>
            </div>
            <div class="equipment_estimator_my_page_progress_datatype equipment_estimator_my_page_progress_date_expiry_datatype">
              <p class="equipment_estimator_my_page_progress_datatype_typo">납품만기일</p>
            </div>
            <div class="equipment_estimator_my_page_progress_datatype equipment_estimator_my_page_progress_client_datatype">
              <p class="equipment_estimator_my_page_progress_datatype_typo">의뢰인</p>
            </div>
            <div class="equipment_estimator_my_page_progress_datatype equipment_estimator_my_page_progress_cheesigner_datatype">
              <p class="equipment_estimator_my_page_progress_datatype_typo">치자이너</p>
            </div>
          </div>
          <div class="equipment_estimator_my_page_progress_list_container">
            <c:forEach var="item" items="${DATA.LIST}" varStatus="status">
            <jsp:include page="/WEB-INF/views/dialog/cad_estimator_dialog.jsp" flush="true"/>
    <jsp:include page="/WEB-INF/views/dialog/review_writing_dialog.jsp" flush="true">
      <jsp:param name="WR_NO" value="${item.WR_NO}" />
      <jsp:param name="PROJECT_NO" value="${item.PROJECT_NO}" />
      <jsp:param name="PROJECT_NM" value="${item.PROJECT_NM}" />
    </jsp:include>
    <script>
    console.log("${item.WR_NO}");
    console.log("${item.PROJECT_NO}");
    console.log("${item.PROJECT_NM}");
    function gotoreview(){
  	  location.href = ('api/mypage/receive_file?PROJECT_NO=${item.PROJECT_NO}');
    }
    </script>
              <div class="equipment_estimator_my_page_progress_list">
                <div class="equipment_estimator_my_page_progress_list_item equipment_estimator_my_page_progress_current">
                  <div class="equipment_estimator_my_page_progress_completed">
                    <p class="equipment_estimator_my_page_progress_completed_typo">${item.PROGRESS_NM}</p>
                  </div>
                </div>
                <div class="equipment_estimator_my_page_progress_list_item equipment_estimator_my_page_progress_category">
                  <p class="equipment_estimator_my_page_progress_list_item_typo">${item.PROJECT_NM}</p>
                </div>
                <c:choose>
                  <c:when test="${item.PROGRESS_CD eq 'PC005'}">
                    <div class="equipment_estimator_my_page_progress_list_item equipment_estimator_my_page_progress_context">
                      <p class="equipment_estimator_my_page_progress_list_item_typo">${item.TITLE}</p>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <div class="equipment_estimator_my_page_progress_list_item equipment_estimator_my_page_progress_context">
                      <p class="equipment_estimator_my_page_progress_list_item_typo">${item.TITLE}</p>
                    </div>
                  </c:otherwise>
                </c:choose>
                <div class="equipment_estimator_my_page_progress_list_item equipment_estimator_my_page_progress_date_matched">
                  <p class="equipment_estimator_my_page_progress_list_item_typo">${item.MATCHING_DATE}</p>
                </div>
                <div class="equipment_estimator_my_page_progress_list_item equipment_estimator_my_page_progress_date_expiry">
                  <p class="equipment_estimator_my_page_progress_list_item_typo">${item.DELIVERY_EXP_DATE}</p>
                </div>
                <div class="equipment_estimator_my_page_progress_list_item equipment_estimator_my_page_progress_client">
                  <p class="equipment_estimator_my_page_progress_list_item_typo">${item.USER_NICK_NAME}</p>
                </div>
                <div class="equipment_estimator_my_page_progress_list_item equipment_estimator_my_page_progress_cheesigner">
                  <p class="equipment_estimator_my_page_progress_list_item_typo">${item.CHEESIGNER_NICK_NAME}</p>
                </div>
                <div class="equipment_estimator_my_page_progress_list_arrow_wrapper" style="cursor: pointer;" onclick="javascript:fnListToggle(this);">
                  <img src="/public/assets/images/equipment_estimator_my_page_progress_list_arrow.svg"/> 
                </div>
              </div>
              <div class="equipment_estimator_my_page_progress_list_pop_up_info_wrapper">
                <div class="equipment_estimator_my_page_progress_step_wrapper">
                  <div class="equipment_estimator_my_page_progress_step_container">
                    <div class="equipment_estimator_my_page_progress_sub_wrapper on">
                      <div class="equipment_estimator_my_page_progress_step" onclick="javascript:fnGetCadEstimators('${item.PROJECT_NO}', 'MY_PAGE');" style="cursor: pointer;">
                        <p class="equipment_estimator_my_page_progress_step_typo_clicked">견적서</p>
                      </div>
                      <div class="equipment_estimator_my_page_progress_step_arrow">
                        <div class="equipment_estimator_my_page_progress_step_arrow_top" style="background-color:#005fa800;"></div>
                        <div class="equipment_estimator_my_page_progress_step_arrow_bottom" style="background-color:#005fa800;"></div>
                      </div>
                    </div>
                    <div class="equipment_estimator_my_page_progress_sub_wrapper on">
                      <div class="equipment_estimator_my_page_progress_step">
                        <p class="equipment_estimator_my_page_progress_step_typo_clicked">전자계약</p>
                      </div>
                      <div class="equipment_estimator_my_page_progress_step_arrow">
                        <div class="equipment_estimator_my_page_progress_step_arrow_top" style="background-color:#005fa800;"></div>
                        <div class="equipment_estimator_my_page_progress_step_arrow_bottom" style="background-color:#005fa800;"></div>
                      </div>
                    </div>
                    <c:choose>
                      <c:when test="${item.DVSN_CD eq 'A' and item.PROGRESS_CD eq 'PC005' and item.RECEIVE_YN eq 'Y'}">
                        <c:set var="item3_1" value="N"/> <!-- 링크 -->
                      </c:when>
                      <c:when test="${item.DVSN_CD eq 'B' and item.PROGRESS_CD eq 'PC005' and item.RECEIVE_YN eq 'N'}">
                        <c:set var="item3_1" value="Y"/>
                      </c:when>
                      <c:otherwise>
                        <c:set var="item3_1" value="N"/>
                      </c:otherwise>
                    </c:choose>
                    <c:choose>
                      <c:when test="${item.DVSN_CD eq 'A' and item.PROGRESS_CD eq 'PC005' and item.RECEIVE_YN eq 'Y'}">
                        <c:set var="item3_2" value="Y"/> <!-- 하이라이트 -->
                      </c:when>
                      <c:when test="${item.DVSN_CD eq 'B' and item.PROGRESS_CD eq 'PC005'}">
                        <c:set var="item3_2" value="Y"/>
                      </c:when>
                      <c:otherwise>
                        <c:set var="item3_2" value="N"/>
                      </c:otherwise>
                    </c:choose>
                    <div class="equipment_estimator_my_page_progress_sub_wrapper <c:if test="${item3_2 eq 'Y'}">on</c:if>">
                      <div class="equipment_estimator_my_page_progress_step" <c:if test="${item3_1 eq 'Y'}">onclick="javascript:location.href='/${api}/mypage/receive_estimator?PROJECT_NO=${item.PROJECT_NO}'" style="cursor: pointer;"</c:if>>
                        <p class="equipment_estimator_my_page_progress_step_typo_clicked">의뢰서 수령</p>
                      </div>
                      <div class="equipment_estimator_my_page_progress_step_arrow">
                        <div class="equipment_estimator_my_page_progress_step_arrow_top" style="background-color:#005fa800;"></div>
                        <div class="equipment_estimator_my_page_progress_step_arrow_bottom" style="background-color:#005fa800;"></div>
                      </div>
                    </div>
                    <c:choose>
                      <c:when test="${item.DVSN_CD eq 'A'}">
                        <c:set var="item4_1" value="N"/> <!-- 링크 -->
                      </c:when>
                      <c:when test="${item.DVSN_CD eq 'B' and item.PROGRESS_CD eq 'PC005' and item.RECEIVE_YN eq 'Y' and item.PAYMENT_CD eq 'PAY_001'}">
                        <c:set var="item4_1" value="Y"/>
                      </c:when>
                      <c:otherwise>
                        <c:set var="item4_1" value="N"/>
                      </c:otherwise>
                    </c:choose>
                    <c:choose>
                      <c:when test="${item.DVSN_CD eq 'A' and ( item.PAYMENT_CD eq 'PAY_002' or item.PAYMENT_CD eq 'PAY_003' or item.PAYMENT_CD eq 'PAY_004')}">
                        <c:set var="item4_2" value="Y"/> <!-- 하이라이트 -->
                      </c:when>
                      <c:when test="${item.DVSN_CD eq 'B' and item.RECEIVE_YN eq 'Y' and ( item.PAYMENT_CD eq 'PAY_001' or item.PAYMENT_CD eq 'PAY_002' or item.PAYMENT_CD eq 'PAY_003' or item.PAYMENT_CD eq 'PAY_004')}">
                        <c:set var="item4_2" value="Y"/>
                      </c:when>
                      <c:otherwise>
                        <c:set var="item4_2" value="N"/>
                      </c:otherwise>
                    </c:choose>
                    <div class="equipment_estimator_my_page_progress_sub_wrapper <c:if test="${item4_2 eq 'Y'}">on</c:if>">
                      <div class="equipment_estimator_my_page_progress_step" <c:if test="${item4_1 eq 'Y'}">onclick="javascript:location.href='/${api}/mypage/cad_completed?PROJECT_NO=${item.PROJECT_NO}'" style="cursor: pointer;"</c:if>>
                        <p class="equipment_estimator_my_page_progress_step_typo_clicked">CAD완성 및 결제요청</p>
                      </div>
                      <div class="equipment_estimator_my_page_progress_step_arrow">
                        <div class="equipment_estimator_my_page_progress_step_arrow_top"  style="background-color:#005fa800;"></div>
                        <div class="equipment_estimator_my_page_progress_step_arrow_bottom" style="background-color:#005fa800;"></div>
                      </div>
                    </div>
                    <c:choose>
                      <c:when test="${item.DVSN_CD eq 'A' and item.PAYMENT_CD eq 'PAY_002'}">
                        <c:set var="item5_1" value="Y"/> <!-- 링크 -->
                      </c:when>
                      <c:when test="${item.DVSN_CD eq 'B'}">
                        <c:set var="item5_1" value="N"/>
                      </c:when>
                      <c:otherwise>
                        <c:set var="item5_1" value="N"/>
                      </c:otherwise>
                    </c:choose>
                    <c:choose>
                      <c:when test="${item.DVSN_CD eq 'A' and (item.PAYMENT_CD eq 'PAY_002' or item.PAYMENT_CD eq 'PAY_003' or item.PAYMENT_CD eq 'PAY_004')}">
                        <c:set var="item5_2" value="Y"/> <!-- 하이라이트 -->
                      </c:when>
                      <c:when test="${item.DVSN_CD eq 'B' and (item.PAYMENT_CD eq 'PAY_003' or item.PAYMENT_CD eq 'PAY_004')}">
                        <c:set var="item5_2" value="Y"/>
                      </c:when>
                      <c:otherwise>
                        <c:set var="item5_2" value="N"/>
                      </c:otherwise>
                    </c:choose>
                    <div class="equipment_estimator_my_page_progress_sub_wrapper <c:if test="${item5_2 eq 'Y'}">on</c:if>">
                      <div class="equipment_estimator_my_page_progress_step" <c:if test="${item5_1 eq 'Y'}">onclick="javascript:location.href='/${api}/mypage/cad_completed_next?PROJECT_NO=${item.PROJECT_NO}'" style="cursor: pointer;"</c:if>>
                        <p class="equipment_estimator_my_page_progress_step_typo_clicked">결제</p>
                      </div>
                      <div class="equipment_estimator_my_page_progress_step_arrow">
                        <div class="equipment_estimator_my_page_progress_step_arrow_top" style="background-color:#005fa800;"></div>
                        <div class="equipment_estimator_my_page_progress_step_arrow_bottom" style="background-color:#005fa800;"></div>
                     </div>
                    </div>
                    <c:choose>
                      <c:when test="${item.DVSN_CD eq 'A' and item.PAYMENT_CD eq 'PAY_004'}">
                        <c:set var="item6_1" value="Y"/> <!-- 링크 -->
                      </c:when>
                      <c:when test="${item.DVSN_CD eq 'B'}">
                        <c:set var="item6_1" value="N"/>
                      </c:when>
                      <c:otherwise>
                        <c:set var="item6_1" value="N"/>
                      </c:otherwise>
                    </c:choose>
                    <c:choose>
                      <c:when test="${item.DVSN_CD eq 'A' and item.PAYMENT_CD eq 'PAY_004'}">
                        <c:set var="item6_2" value="Y"/> <!-- 하이라이트 -->
                      </c:when>
                      <c:when test="${item.DVSN_CD eq 'B' and item.FILE_RECEIVE_YN eq 'Y'}">
                        <c:set var="item6_2" value="Y"/>
                      </c:when>
                      <c:otherwise>
                        <c:set var="item6_2" value="N"/>
                      </c:otherwise>
                    </c:choose>
                    <div class="equipment_estimator_my_page_progress_sub_wrapper <c:if test="${item6_2 eq 'Y'}">on</c:if>">
                      <div class="equipment_estimator_my_page_progress_step" <c:if test="${item6_1 eq 'Y'}">onclick="javascript:location.href='/${api}/mypage/receive_file?PROJECT_NO=${item.PROJECT_NO}'" style="cursor: pointer;"</c:if>>
                        <p class="equipment_estimator_my_page_progress_step_typo_clicked">파일수령</p>
                      </div>
                    </div>
                    
                  </div>
                  <div class="dropbox_my_page_progress_pop_up_item_container">
                    <div class="dropbox_my_page_progress_pop_up_item invisible">
                      <div class="dropbox_my_page_progress_pop_up_top"></div>
                      <div class="dropbox_my_page_progress_pop_up_body">
                        <div class="dropbox_my_page_progress_pop_up_typo_container">
                          <p class="dropbox_my_page_progress_pop_up_typo">견적서 보기</p>
                        </div>
                      </div>
                    </div>
                    <c:choose>
                      <c:when test="${item.DVSN_CD eq 'A' and (item.PROGRESS_CD eq 'PC002' or item.PROGRESS_CD eq 'PC004')}">
                        <c:set var="item2_1" value="Y"/>
                      </c:when>
                      <c:when test="${item.DVSN_CD eq 'B' and (item.PROGRESS_CD eq 'PC001' or item.PROGRESS_CD eq 'PC003')}">
                        <c:set var="item2_1" value="Y"/>
                      </c:when>
                      <c:otherwise>
                        <c:set var="item2_1" value="N"/>
                      </c:otherwise>
                    </c:choose>
                    <c:choose>
                      <c:when test="${(item.PROGRESS_CD eq 'PC002' or item.PROGRESS_CD eq 'PC004') }">
                        <c:set var="item2_2" value="A"/>
                      </c:when>
                      <c:when test="${(item.PROGRESS_CD eq 'PC001' or item.PROGRESS_CD eq 'PC003') }">
                        <c:set var="item2_2" value="B"/>
                      </c:when>
                      <c:otherwise>
                        <c:set var="item2_2" value="C"/>
                      </c:otherwise>
                    </c:choose>
                    <div class="dropbox_my_page_progress_pop_up_item <c:if test="${item.PROGRESS_CD eq 'PC005'}">invisible</c:if>">
                      <div class="dropbox_my_page_progress_pop_up_top"></div>
                      <div class="dropbox_my_page_progress_pop_up_body" <c:if test="${item2_1 eq 'Y'}">onclick="javascript:location.href='/${api}/contract/project_electronic_contract?ESTIMATOR_NO=${item.ESTIMATOR_NO}&MY_PAGE=Y'" style="cursor: pointer;"</c:if>>
                        <div class="dropbox_my_page_progress_pop_up_typo_container">
                          <p class="dropbox_my_page_progress_pop_up_typo <c:if test="${item2_2 eq 'A'}">bold_type</c:if>">의뢰자</p>
                          <p class="dropbox_my_page_progress_pop_up_typo_divider">/</p>
                          <p class="dropbox_my_page_progress_pop_up_typo <c:if test="${item2_2 eq 'B'}">bold_type</c:if>">치자이너</p>
                        </div>
                      </div>
                    </div>
                    <div class="dropbox_my_page_progress_pop_up_item invisible">
                      <div class="dropbox_my_page_progress_pop_up_top"></div>
                      <div class="dropbox_my_page_progress_pop_up_body">
                        <div class="dropbox_my_page_progress_pop_up_typo_container">
                          <p class="dropbox_my_page_progress_pop_up_typo">의뢰서 수령</p>
                        </div>
                      </div>
                    </div>
                    <div class="dropbox_my_page_progress_pop_up_item invisible">
                      <div class="dropbox_my_page_progress_pop_up_top"></div>
                      <div class="dropbox_my_page_progress_pop_up_body">
                        <div class="dropbox_my_page_progress_pop_up_typo_container">
                          <p class="dropbox_my_page_progress_pop_up_typo">ddd</p>
                        </div>
                      </div>
                    </div>
                    <c:choose>
                      <c:when test="${item.DVSN_CD eq 'A'}">
                        <c:set var="item5_3" value="N"/>
                      </c:when>
                      <c:when test="${item.DVSN_CD eq 'B' and item.PAYMENT_CD eq 'PAY_003'}">
                        <c:set var="item5_3" value="Y"/>
                      </c:when>
                      <c:otherwise>
                        <c:set var="item5_3" value="N"/>
                      </c:otherwise>
                    </c:choose>
                    <div class="dropbox_my_page_progress_pop_up_item <c:if test="${item5_3 eq 'N'}">invisible</c:if>">
                      <div class="dropbox_my_page_progress_pop_up_top"></div>
                      <div class="dropbox_my_page_progress_pop_up_body" onclick="javascript:fnPayment(${item.WR_NO});" style="cursor: pointer;">
                        <div class="dropbox_my_page_progress_pop_up_typo_container">
                          <p class="dropbox_my_page_progress_pop_up_typo">입금확인</p>
                        </div>
                      </div>
                    </div>
                    <div class="dropbox_my_page_progress_pop_up_item <c:if test="${item.FILE_RECEIVE_YN eq 'N' and item.REVIEW_CNT eq 0}">invisible</c:if>" style="width: 150px;margin-left:250px;">
                      <div class="dropbox_my_page_progress_pop_up_top"></div>
                      <div class="dropbox_my_page_progress_pop_up_body" onclick="javascript:location.href=('receive_file?PROJECT_NO=${item.PROJECT_NO}&reviewbool=1')" style="cursor: pointer;border-radius:0 0 10px 10px">
                        <div class="dropbox_my_page_progress_pop_up_typo_container">
                          <p class="dropbox_my_page_progress_pop_up_typo">후기쓰기</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <c:choose>
                  <c:when test="${item.DVSN_CD eq 'A'}">
                    <c:set var="talk1_1" value="${item.CHEESIGNER_ID}"/> <!-- 아이디 -->
                    <c:set var="talk1_2" value="${item.CHEESIGNER_NICK_NAME}"/> <!-- 닉네임 -->
                  </c:when>
                  <c:when test="${item.DVSN_CD eq 'B'}">
                    <c:set var="talk1_1" value="${item.USER_ID}"/> <!-- 아이디 -->
                    <c:set var="talk1_2" value="${item.USER_NICK_NAME}"/> <!-- 닉네임 -->
                  </c:when>
                </c:choose>
                <div class="equipment_estimator_my_page_progress_list_pop_up_info_button_container">
                  <button type="button" class="equipment_estimator_my_page_progress_list_pop_up_info_button_white" onclick="javascript:fnOpenTalk('${talk1_1}', '${talk1_2}');">
                    <p class="equipment_estimator_my_page_progress_list_pop_up_info_button_white_typo">쪽지보내기</p>
                  </button>
                  <c:if test="${empty item.PAYMENT_CD or item.PAYMENT_CD eq 'PAY_001'}">
                    <button type="button" class="equipment_estimator_my_page_progress_list_pop_up_info_button_black" onclick="javascript:fnCancel(${item.PROJECT_NO});">
                      <p class="equipment_estimator_my_page_progress_list_pop_up_info_button_black_typo">취소요청</p>
                    </button>
                  </c:if>
                </div>
              </div>
              <div class="list_divider"></div>
            </c:forEach>
            <div class="project_sub_container">
              <div class="pagination"></div>
              <input type="hidden" id="PAGE" name="PAGE" value="${PAGE}">
              <div class="search">
                <select id="SEARCH_TYPE" name="SEARCH_TYPE" class="search_select">
                  <option value="ALL" <c:if test="${empty param.SEARCH_TYPE or param.SEARCH_TYPE eq 'ALL'}">selected="selected"</c:if>>전체</option>
                  <option value="TITLE" <c:if test="${param.SEARCH_TYPE eq 'TITLE'}">selected="selected"</c:if>>의뢰내용</option>
                  <option value="NICK" <c:if test="${param.SEARCH_TYPE eq 'NICK'}">selected="selected"</c:if>>닉네임</option>
                </select>
                <input type="text" class="search_bar" id="SEARCH_TXT" name="SEARCH_TXT" value="${SEARCH_TXT}">
                <button type="button" class="search_button" onclick="fnSearch();">
                  <img class="Search_button_icon" src="/public/assets/images/search_button_icon.svg"/>
                  <p class="search_button_typo">검색</p>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script>

  </script>
</form:form>
