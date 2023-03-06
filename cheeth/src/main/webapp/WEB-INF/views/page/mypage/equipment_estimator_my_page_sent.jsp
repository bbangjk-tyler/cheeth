<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:if test="${empty sessionInfo.user}">
  <script>
  alert(getI8nMsg("alert.plzlogin"));
   location.href = '/api/login/view';
</script>
</c:if>
<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>

<script>

	var currEstimator;
	var currReqType;
	
	var eqEstimatorViewModal;
	var cadEstimatorViewModal;
	var matchingModal;
	var lang = localStorage.getItem('lang');

  function fnView() {
    var estimatorNo = arguments[0];
    var url = '/' + API + '/contract/project_electronic_contract';
    url += '?ESTIMATOR_NO=' + estimatorNo;
    location.href = url;
  }
  
  function fnSearch() {
    var page = arguments[0] ?? '1';
    $('#PAGE').val(page);
    $('#searchForm').submit();
   }
  
  function fnViewEstimators() {
	  currReqType = arguments[0];
	  const reqNo = arguments[1];
	  
	  if(currReqType == 'EQ') {
			fnGetEqEstimators(reqNo);
	  } else if(currReqType == 'PROJECT') {
		  fnGetCadEstimators(reqNo);
	  }
	}
  
  function fnMatching() {
	  if(currReqType == 'EQ') {
		  fnEqMatching();
	  } else if(currReqType == 'PROJECT') {
		  fnCadMatching();
	  }
  }
  
  function fnCancelMatching() {
	  matchingModal.hide();
	  if(currReqType == 'EQ') {
		  eqEstimatorViewModal.show();
	  } else if(currReqType == 'PROJECT') {
		  cadEstimatorViewModal.show();
	  }
  }
	  
  $(function() {
	  
    fnSetPageInfo('${PAGE}', '${TOTAL_CNT}', 10);

    eqEstimatorViewModal = new bootstrap.Modal(document.getElementById('eqEstimatorViewModal'));
    cadEstimatorViewModal = new bootstrap.Modal(document.getElementById('cadEstimatorViewModal'));
    matchingModal = new bootstrap.Modal(document.getElementById('matchingModal'));
    
  });
  
</script>

<form:form id="searchForm" name="searchForm" action="/${api}/mypage/equipment_estimator_my_page_equipment" method="GET">
  
	<div class="equipment_estimator_header">
  	<p class="equipment_estimator_header_typo">
    	<spring:message code="req.reqHis" text="견적·의뢰내역" />
    </p>
  </div>
	
	<div class="equipment_estimator_body">
        <div class="side_menu">
            <div class="side_menu_title">
                <p class="side_menu_title_typo">
                    <spring:message code="main.seeAll" text="전체보기" />
                </p>
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
				      <p class="side_menu_list_typo_blue"><spring:message code="req.reqHis" text="견적·의뢰내역" /></p>
				    </a>
				    <a href="/${api}/tribute/request_basket" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo"><spring:message code="req.myReq" text="의뢰서 바구니" /></p>
				    </a>
				    <a href="/${api}/mypage/equipment_estimator_my_page_progress" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo"><spring:message code="req.progD" text="진행내역" /></p>
				    </a>
				    <c:choose>
				      <c:when test="${sessionInfo.user.USER_TYPE_CD eq 1 or sessionInfo.user.USER_TYPE_CD eq 2}">
				        <a href="/${api}/mypage/profile_management" class="side_menu_list">
				          <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				          <p class="side_menu_list_typo"><spring:message code="req.myProf" text="프로필 관리" /></p>
				        </a>
				      </c:when>
				      <c:when test="${sessionInfo.user.USER_TYPE_CD eq 3}">
				        <a href="/${api}/mypage/profile_management_cheesigner_show" class="side_menu_list">
				          <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				          <p class="side_menu_list_typo"><spring:message code="req.myProf" text="프로필 관리" /></p>
				        </a>
				      </c:when>
				    </c:choose>
				    <a href="/${api}/review/client_review" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo"><spring:message code="req.myReview" text="후기관리" /></p>
				    </a>
				    <a href="/${api}/mypage/my_page_edit_info" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo"><spring:message code="req.manInfo" text="내정보 수정" /></p>
				    </a>
				    <a href="javascript:fnLogOut();" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo"><spring:message code="logout" text="로그아웃" /></p>
				    </a>
        </div>
        <div class="equipment_estimator_main_container">
            <div class="equipment_estimator_connection_location_container" style="margin-bottom: 44px;">
                <a href="./main.html" class="equipment_estimator_connection_location_typo">
                    <img class="equipment_estimator_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
                </a>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo"><spring:message code="req.myPage" text="마이페이지" /></p>
                </div>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo_bold"><spring:message code="equ.allReqH" text="견적·의뢰내역 전체보기" /></p>
                </div>
            </div>
            <div class="equipment_estimator_my_page_request_history_wrapper">
                <div class="equipment_estimator_my_page_request_history_chip_container">

                    <a href="/${api}/mypage/equipment_estimator_my_page_cad" class="equipment_estimator_my_page_request_history_chip">
                        <p class="equipment_estimator_my_page_request_history_chip_typo">
                            <spring:message code="equ.cadQuoB" text="CAD 견적함" />
                        </p>
                    </a>
                    <a href="/${api}/mypage/equipment_estimator_my_page_sent" class="equipment_estimator_my_page_request_history_chip">
                        <p class="equipment_estimator_my_page_request_history_chip_selected_typo">
                            <spring:message code="equ.sentQuo" text="내가 보낸 견적" />
                        </p>
                    </a>
                                        <a href="/${api}/mypage/equipment_estimator_my_page_equipment" class="equipment_estimator_my_page_request_history_chip">
                        <p class="equipment_estimator_my_page_request_history_chip_typo">
                            <spring:message code="equ.equQuoB" text="장비 견적함" />
                        </p>
                    </a>
                </div>
                <div class="equipment_estimator_my_page_request_history_container">
                    <div class="equipment_estimator_my_page_request_history_datatype_container">
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_category_datatype">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo"></p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_context">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                <spring:message code="equ.reqCont" text="의뢰내용" />
                            </p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_count">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                <spring:message code="equ.numQuo" text="견적수" />
                            </p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_date_requested">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                <spring:message code="equ.reqDate" text="의뢰일" />
                            </p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_date_expiry">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                <spring:message code="equ.expriDate" text="만료일" />
                            </p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_estimator_read">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                <spring:message code="equ.viewQuo" text="견적서보기" />
                            </p>
                        </div>
                    </div>
                    <div class="equipment_estimator_my_page_request_history_list_container">
                    	<c:forEach items="${LIST}" var="item" varStatus="status">
                        <div class="equipment_estimator_my_page_request_history_list">
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_category flex_start">
                            <p class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.REQ_CD_NM}
                            </p>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_context flex_start">
                          	<c:if test="${item.REQ_TYPE eq 'EQ'}">
                          		<c:set var="viewUrl" value="/${api}/equipment/equipment_estimator_view?EQ_NO=${item.REQ_NO}&SEARCH_EQ_CD=${item.REQ_CD}" />
                          	</c:if>
                          	<c:if test="${item.REQ_TYPE eq 'PROJECT'}">
                          		<c:set var="viewUrl" value="/${api}/project/project_request_view?PROJECT_NO=${item.REQ_NO}" />
                          	</c:if>
                            <a href="${viewUrl}" class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.TITLE}
                            </a>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_count">
                            <p class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.REQ_CNT}
                            </p>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_date_requested">
                            <p class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.CREATE_DATE}
                            </p>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_date_expiry">
                            <p class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.EXP_DATE}
                            </p>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_estimator_read">
                            <a href="javascript:fnViewEstimators('${item.REQ_TYPE}', '${item.REQ_NO}');" class="equipment_estimator_my_page_estimator_read_button">
                              <p class="equipment_estimator_my_page_estimator_read_button_typo">
                                <spring:message code="view" text="보기" />
                              </p>
                            </a>
                          </div>
                        </div>
                        <div class="list_divider"></div>
                    	</c:forEach>
                    	
                    	<jsp:include page="/WEB-INF/views/dialog/equipment_estimator_dialog.jsp" flush="true" />
                    	<jsp:include page="/WEB-INF/views/dialog/cad_estimator_dialog.jsp" flush="true" />
											
											<!-- 매칭하기 modal -->
											<div class="modal fade" id="matchingModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
											  <div class="modal-dialog modal-dialog-centered">
											    <div class="modal-content" style="width: fit-content;">
											    	<div class="matching_container">
												        <div class="matching_header">
												            <p class="matching_header_typo">
												                <spring:message code="match" text="매칭하기" />
												            </p>
												            <a href="#estimatorViewModal" class="dialog_close_button_wrapper" data-bs-toggle="modal">
												                <img class="dialog_close_button" src="/public/assets/images/dialog_close_button.svg"/>
												            </a>
												        </div>
												        <div class="matching_body">
												            <div class="matching_body_typo_wrapper">
												                <p class="matching_body_typo">
												                    <spring:message code="equ.msq.match" text="매칭하시겠습니까?" />
												                </p>
												            </div>
												            <div class="matching_button_container">
												                <a href="javascript:fnCancelMatching()" class="matching_button_white">
												                    <div class="matching_button_white_typo">
												                        <spring:message code="no" text="아니오" />
												                    </div>
												                </a>
												                <a href="javascript:fnMatching()" class="matching_button_blue">
												                    <div class="matching_button_blue_typo">
												                        <spring:message code="yes" text="네" />
												                    </div>
												                </a>
												            </div>
												        </div>
												    </div>
											    </div>
											  </div>
											</div>
											<!-- 매칭하기 modal end -->
								
                        <div class="pagination"></div>
                        <input type="hidden" id="PAGE" name="PAGE" value="${PAGE}">
                    </div>
                </div>
            </div>
        </div>
    </div>
</form:form>