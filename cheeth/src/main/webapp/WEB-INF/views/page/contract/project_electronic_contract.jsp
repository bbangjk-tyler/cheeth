<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if>
<script>
  
  function fnAllView() {
    if('${MY_PAGE}' === 'Y') {
      location.href = '/' + API + '/mypage/equipment_estimator_my_page_progress';
	  } else {
      location.href = '/' + API + '/project/project_view_all';
	  }
  }
  
  function fnApproval() {
    var estimatorNo = '${ESTIMATOR_NO}';
    if(isEmpty(estimatorNo)) {
      alert('올바른 요청이 아닙니다.');
    } else {
      
      var agreementYn1 = $('#AGREEMENT_YN_1').val();
      var agreementYn2 = $('#AGREEMENT_YN_2').val();
      var agreementYn3 = $('#AGREEMENT_YN_3').val();
      var agreementYn4 = $('#AGREEMENT_YN_4').val();
      
      if(agreementYn1 !== 'Y' || agreementYn2 !== 'Y' || agreementYn3 !== 'Y' || agreementYn4 !== 'Y') {
        alert('필수 동의 항목을 동의해야 승인이 가능합니다.');
        return;
      }
      
      if($('#SP_CHANGE').val() === 'Y') {
        alert('특수계약 조건이 변경되었습니다. 수정요청 하시기 바랍니다.');
        $('#SPECIAL_CONDITION').focus();
        return;
      }
      
      var isConfirm = window.confirm('승인 하시겠습니까?');
      if(!isConfirm) return;
      
      var saveObj = getSaveObj('saveForm');
      
      $.ajax({
        url: '/' + API + '/contract/save02',
        type: 'POST',
        data: saveObj,
        cache: false,
        async: false,
        success: function(data) {
          fnAllView();
        }, complete: function() {
        }, error: function() {
        }
      });
    }
  }
  
  function fnModifyRequest() {
    var estimatorNo = '${ESTIMATOR_NO}';
    if(isEmpty(estimatorNo)) {
    	alert('올바른 요청이 아닙니다.');
    } else {
      
      var agreementYn1 = $('#AGREEMENT_YN_1').val();
      var agreementYn2 = $('#AGREEMENT_YN_2').val();
      var agreementYn3 = $('#AGREEMENT_YN_3').val();
      var agreementYn4 = $('#AGREEMENT_YN_4').val();
      
      if(agreementYn1 !== 'Y' || agreementYn2 !== 'Y' || agreementYn3 !== 'Y' || agreementYn4 !== 'Y') {
        alert('필수 동의 항목을 동의해야 수정요청이 가능합니다.');
        return;
      }
        
      var isConfirm = window.confirm('수정요청 하시겠습니까?');
      if(!isConfirm) return;
      
      var saveObj = getSaveObj('saveForm');
      
      $.ajax({
        url: '/' + API + '/contract/save03',
        type: 'POST',
        data: saveObj,
        cache: false,
        async: false,
        success: function(data) {
          fnAllView();
        }, complete: function() {
        }, error: function() {
        }
      });
    }
  }
  
  function fnApprovalRequest() {
    var estimatorNo = '${ESTIMATOR_NO}';
    if(isEmpty(estimatorNo)) {
    	alert('올바른 요청이 아닙니다.');
    } else {
      
    	var contractNo = $('#CONTRACT_NO').val(); 
      var agreementYn1 = $('#AGREEMENT_YN_1').val();
      var agreementYn2 = $('#AGREEMENT_YN_2').val();
      var agreementYn3 = $('#AGREEMENT_YN_3').val();
      var agreementYn4 = $('#AGREEMENT_YN_4').val();
      
      if(agreementYn1 !== 'Y' || agreementYn2 !== 'Y' || agreementYn3 !== 'Y' || agreementYn4 !== 'Y') {
        alert('필수 동의 항목을 동의해야 승인요청이 가능합니다.');
        return;
      }      
      
      if(isNotEmpty(contractNo) && $('#SP_CHANGE').val() === 'Y') {
        alert('특수계약 조건이 변경되었습니다. 수정요청 하시기 바랍니다.');
        $('#SPECIAL_CONDITION').focus();
        return;
      }
        
      var isConfirm = window.confirm('승인요청 하시겠습니까?');
      if(!isConfirm) return;
      
      var saveObj = getSaveObj('saveForm');
      
      $.ajax({
        url: '/' + API + '/contract/save01',
        type: 'POST',
        data: saveObj,
        cache: false,
        async: false,
        success: function(data) {
          fnAllView();
        }, complete: function() {
        }, error: function() {
        }
      });
    }
  }
  
  function fnCancel() {
    var estimatorNo = '${ESTIMATOR_NO}';
    if(isEmpty(estimatorNo)) {
      alert('올바른 요청이 아닙니다.');
    } else {
      var isConfirm = window.confirm('계약취소 하시겠습니까?');
      if(!isConfirm) return;
      
      $.ajax({
        url: '/' + API + '/contract/delete01',
        type: 'POST',
        data: { CONTRACT_NO: '${DATA.CONTRACT_NO}', ESTIMATOR_NO: '${ESTIMATOR_NO}' },
        cache: false,
        async: false,
        success: function(data) {
          fnAllView();
        }, complete: function() {
        }, error: function() {
        }
      });
    }
  }
  
  function fnAllCheck() {
    var target = arguments[0];
    if($(target).is(':checked')) {
      $('#AGREEMENT_YN_1').prop('checked', true);
      $('#AGREEMENT_YN_2').prop('checked', true);
      $('#AGREEMENT_YN_3').prop('checked', true);
      $('#AGREEMENT_YN_4').prop('checked', true);
      $('#CHOICE_AGREEMENT_YN_1').prop('checked', true);
      $('#AGREEMENT_YN_1').val('Y');
      $('#AGREEMENT_YN_2').val('Y');
      $('#AGREEMENT_YN_3').val('Y');
      $('#AGREEMENT_YN_4').val('Y');
      $('#CHOICE_AGREEMENT_YN_1').val('Y');
    } else {
      $('#AGREEMENT_YN_1').prop('checked', false);
      $('#AGREEMENT_YN_2').prop('checked', false);
      $('#AGREEMENT_YN_3').prop('checked', false);
      $('#AGREEMENT_YN_4').prop('checked', false);
      $('#CHOICE_AGREEMENT_YN_1').prop('checked', false);
      $('#AGREEMENT_YN_1').val('N');
      $('#AGREEMENT_YN_2').val('N');
      $('#AGREEMENT_YN_3').val('N');
      $('#AGREEMENT_YN_4').val('N');
      $('#CHOICE_AGREEMENT_YN_1').val('N');
    }
  }
  
  function fnChangeCheck() {
    var target = arguments[0];
    if($(target).is(':checked')) {
      $(target).val('Y');
      var cnt = 0;
      $('.electronic_contract_wrapper').find('input[type="checkbox"]').each(function(k,v) {
        if(isNotEmpty(v.name)) {
          if($(v).is(':checked')) {
            cnt++;
          }
        }
      });
      if(cnt === 5) $('#ALL_CHECKBOX').prop('checked', true);
    } else {
      $(target).val('N');
      $('#ALL_CHECKBOX').prop('checked', false);
    }
  }
  
  function fnSpChange() {
    var target = arguments[0];
    if(isNotEmpty($(target).val())) {
      $('#SP_CHANGE').val('Y');
    }
  }
  
  function fnSpReset() {
    var isConfirm = window.confirm('특수 계약조건을 초기화 하시겠습니까?');
    if(!isConfirm) return;
    var temp = $('#SPECIAL_CONDITION_TEMP').val();
    $('#SPECIAL_CONDITION').val(temp);
    $('#SP_CHANGE').val('N');
  }
  
  $(document).ready(function() {
    
    var agreementYn1 = '${DATA.AGREEMENT_YN_1}';
    var agreementYn2 = '${DATA.AGREEMENT_YN_2}';
    var agreementYn3 = '${DATA.AGREEMENT_YN_3}';
    var agreementYn4 = '${DATA.AGREEMENT_YN_4}';
    var choiceAgreementYn_1 = '${DATA.CHOICE_AGREEMENT_YN_1}';
    
    if(agreementYn1 === 'Y') $('#AGREEMENT_YN_1').prop('checked', true);
    if(agreementYn2 === 'Y') $('#AGREEMENT_YN_2').prop('checked', true);
    if(agreementYn3 === 'Y') $('#AGREEMENT_YN_3').prop('checked', true);
    if(agreementYn4 === 'Y') $('#AGREEMENT_YN_4').prop('checked', true);
    if(choiceAgreementYn_1 === 'Y') $('#CHOICE_AGREEMENT_YN_1').prop('checked', true);
    
    if(agreementYn1 === 'Y' && agreementYn2 === 'Y' && agreementYn3 === 'Y' && agreementYn4 === 'Y' && choiceAgreementYn_1 === 'Y') {
      $('#ALL_CHECKBOX').prop('checked', true);
    }
    
  });
  
</script>

<form:form id="saveForm" name="saveForm">

  <input type="hidden" id="CONTRACT_NO" name="CONTRACT_NO" value="${DATA.CONTRACT_NO}">
  <input type="hidden" id="ESTIMATOR_NO" name="ESTIMATOR_NO" value="${ESTIMATOR_NO}">
  
  <input type="hidden" id="PROJECT_NO" name="PROJECT_NO" value="${DATA.PROJECT_NO}">
  <input type="hidden" id="PROGRESS_CD" name="PROGRESS_CD" value="${DATA.PROGRESS_CD}">
  <input type="hidden" id="COMPLETE_YN" name="COMPLETE_YN" value="${DATA.COMPLETE_YN}">
  <input type="hidden" id="CHEESIGNER_ID" name="CHEESIGNER_ID" value="${DATA.CHEESIGNER_ID}">
  
  <input type="hidden" id="SP_CHANGE" name="SP_CHANGE" value="N">

	<div class="project_header">
	  <p class="project_header_typo">전자계약서</p>
	</div>
	
	<div class="project_body">
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
	  <div class="electronic_contract_main_container">
	    <div class="project_connection_location_container">
	      <a href="/" class="project_connection_location_typo">
	        <img class="project_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
	      </a>
	      <img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="project_connection_location">
	        <p class="project_connection_location_typo">마이페이지</p>
	      </div>
	      <img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="project_connection_location">
	        <p class="project_connection_location_typo">진행내역</p>
	      </div>
	      <img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="project_connection_location">
	        <p class="project_connection_location_typo_bold">전자계약서</p>
	      </div>
	    </div>
	    <div class="connection_location_divider"></div>
	    <div class="electronic_contract_wrapper">
	      <div class="electronic_contract_container">
	          <div class="electronic_contract_condition">
	            <div class="electronic_contract_condition_typo_container">
	              <p class="electronic_contract_condition_typo">용역 일반 계약서 동의</p>
	              <!-- 수정필요 -->
	              <a href="javascript:window.open('https://www.dentner.co.kr/static/.pdf')" class="electronic_contract_condition_typo short_cut">바로가기</a>
	            </div>
	            <label class="checkbox_large">
                <input type="checkbox" id="AGREEMENT_YN_1" name="AGREEMENT_YN_1" value="${DATA.AGREEMENT_YN_1}" onchange="fnChangeCheck(this);">
              </label>
	          </div>
	          <div class="electronic_contract_condition">
	            <div class="electronic_contract_condition_typo_container">
	              <p class="electronic_contract_condition_typo">Remake는 7일 이내에 같은 스캔파일인 무료로 가능하며, 그 외의 내용은 상호협의 하에 해결한다.<br/>공급자의 태만과 불성실한 태도로 발생한 문제는 용역 일반계약서 제 7조 3항에 따른다.</p>
	            </div>
	            <label class="checkbox_large">
                <input type="checkbox" id="AGREEMENT_YN_2" name="AGREEMENT_YN_2" value="${DATA.AGREEMENT_YN_2}" onchange="fnChangeCheck(this);">
              </label>
	        </div>
	        <div class="electronic_contract_condition">
	          <div class="electronic_contract_condition_typo_container">
	          <!-- 수정필요 -->
	            <p class="electronic_contract_condition_typo">전자견적서 이행</p>
	            <a href="javascript:window.open('https://www.dentner.co.kr/static/.pdf');" class="electronic_contract_condition_typo short_cut">바로가기</a>
	          </div>
	          <label class="checkbox_large">
              <input type="checkbox" id="AGREEMENT_YN_3" name="AGREEMENT_YN_3" value="${DATA.AGREEMENT_YN_3}" onchange="fnChangeCheck(this);">
            </label>
	        </div>
	        <div class="electronic_contract_condition">
	          <div class="electronic_contract_condition_typo_container">
	            <p class="electronic_contract_condition_typo">사용 CAD (Computer Aided Design) S/W</p>
	            <div class="project_select_button_container">
                ${DATA.CADSW_NM_1}
                <c:if test="${not empty DATA.CADSW_NM_1 and not empty DATA.CADSW_NM_2}">,</c:if>
                ${DATA.CADSW_NM_2}
                <c:if test="${(not empty DATA.CADSW_NM_1 or not empty DATA.CADSW_NM_2) and not empty DATA.CADSW_NM_3}">,</c:if>
                ${DATA.CADSW_NM_3}
	            </div>
	          </div>
	          <label class="checkbox_large">
              <input type="checkbox" id="AGREEMENT_YN_4" name="AGREEMENT_YN_4" value="${DATA.AGREEMENT_YN_4}" onchange="fnChangeCheck(this);">
            </label>
	        </div>
	        <div class="electronic_contract_Rcondition">
	          <div class="electronic_contract_condition_typo_container">
	            <p class="electronic_contract_condition_typo sub_typo">(선택) </p>
	            <p class="electronic_contract_condition_typo">전자치과기공물의뢰서(바로가기)에 첨부된 파일, 최종결과물 수집이용 동의</p>
	          </div>
	          <label class="checkbox_large" style="float: right;margin-top: -30px;">
              <input type="checkbox" id="CHOICE_AGREEMENT_YN_1" name="CHOICE_AGREEMENT_YN_1" value="${DATA.CHOICE_AGREEMENT_YN_1}" onchange="fnChangeCheck(this);">
            </label>
	        </div>
	      </div>
	      <div class="main_container_divider divider_without_margin"></div>
	      <div class="accept_all">
	        <p class="accept_all_typo">전체 동의하기</p>
	        <label class="checkbox_large">
            <input type="checkbox" id="ALL_CHECKBOX" onchange="fnAllCheck(this);">
          </label>
	      </div>
	    </div>
	    <div class="main_container_divider"></div>
	    <div class="special_contract">
	      <p class="special_contract_title" style="float:left">특수 계약조건</p>
	      <div>
	      <img id="question" src="/public/assets/images/question.png" style="height:15px;width:15px;">
	      <img id="tooltip" src="/public/assets/images/tooltip.png" style="position:absolute;margin-left:110px;margin-top: -53px;display:none">
        	<!-- <img id="question" src="/public/assets/images/question.png" style="height:15px;width:15px;" data-bs-toggle="tooltip" data-bs-placement="right" title="예시)             제재작 횟수, 금액에 대한 조건은 OOO입니다. 작업진행 중 불가피하게 발생하는 추가 결제 건은 쪽지로 합의 후에 진행해주세요."> -->
        	<br style="clear:both">
          </div>
        	<script>
        	    $('#question').hover(function(){        
        			$("#tooltip").css('display','block');
        	    }, function() {
    			$("#tooltip").css('display','none');
        		    });
        	
         	var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        	var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        	  return new bootstrap.Tooltip(tooltipTriggerEl)
        	}) 
/*         	var tooltip = new bootstrap.Tooltip(element, {
		  popperConfig: function (defaultBsPopperConfig) {
			  title: '예시)\n제재작 횟수, 금액에 대한 조건은 OOO입니다. 작업진행 중 불가피하게 발생하는 추가 결제 건은 쪽지로 합의 후에 진행해주세요.'
		  }
		}) */
        	</script>
        <div class="tooltip bs-tooltip-top" role="tooltip">
		  <div class="tooltip-arrow"></div>
		  <div class="tooltip-inner">
		    Some tooltip text!
		  </div>
		</div>
        <c:choose>
            <c:when test="${CNT02 gt 0 and (DATA.PROGRESS_CD eq 'PC002' or DATA.PROGRESS_CD eq 'PC004')}"> <!-- 의뢰자 기준 치자이너가 승인, 수정 요청 한 경우 -->
				<textarea class="special_contract_context" id="SPECIAL_CONDITION" name="SPECIAL_CONDITION" maxlength="1300" onchange="fnSpChange(this);" placeholder="의뢰자와 치자이너 서로의 요청사항을 써주세요" disabled>${DATA.SPECIAL_CONDITION}</textarea>
            </c:when>
            <c:when test="${CNT01 gt 0 and (DATA.PROGRESS_CD eq 'PC001' or DATA.PROGRESS_CD eq 'PC003')}"> <!-- 치자이너 기준 의뢰자가 승인, 수정 요청 한 경우 -->
				<textarea class="special_contract_context" id="SPECIAL_CONDITION" name="SPECIAL_CONDITION" maxlength="1300" onchange="fnSpChange(this);" placeholder="의뢰자와 치자이너 서로의 요청사항을 써주세요" disabled>${DATA.SPECIAL_CONDITION}</textarea>
            </c:when>
            <c:when test="${DATA.PROGRESS_CD eq 'PC005'}">
            	<textarea class="special_contract_context" id="SPECIAL_CONDITION" name="SPECIAL_CONDITION" maxlength="1300" onchange="fnSpChange(this);" placeholder="의뢰자와 치자이너 서로의 요청사항을 써주세요" disabled>${DATA.SPECIAL_CONDITION}</textarea>
            </c:when>
            <c:otherwise>
            	<textarea class="special_contract_context" id="SPECIAL_CONDITION" name="SPECIAL_CONDITION" maxlength="1300" onchange="fnSpChange(this);" placeholder="의뢰자와 치자이너 서로의 요청사항을 써주세요">${DATA.SPECIAL_CONDITION}</textarea>
            </c:otherwise>
       </c:choose>
     
	      <textarea style="display: none;" id="SPECIAL_CONDITION_TEMP" name="SPECIAL_CONDITION_TEMP">${DATA.SPECIAL_CONDITION}</textarea>
	    </div>
	    <c:if test="${not empty DATA.SPECIAL_CONDITION}">
        <c:choose>
            <c:when test="${CNT01 gt 0 and (DATA.PROGRESS_CD eq 'PC002' or DATA.PROGRESS_CD eq 'PC004')}"> <!-- 의뢰자 기준 치자이너가 승인, 수정 요청 한 경우 -->
              <div class="electronic_contract_button_container left">
                <button type="button" onclick="fnSpReset();" class="refresh">
                  <img src="/public/assets/images/refresh.png" alt="refresh">
                  <span>특수계약조건 초기화</span>
                </button>
              </div>
            </c:when>
            <c:when test="${CNT02 gt 0 and (DATA.PROGRESS_CD eq 'PC001' or DATA.PROGRESS_CD eq 'PC003')}"> <!-- 치자이너 기준 의뢰자가 승인, 수정 요청 한 경우 -->
              <div class="electronic_contract_button_container left">
                <button type="button" onclick="fnSpReset();" class="refresh">
                  <img src="/public/assets/images/refresh.png" alt="refresh">
                  <span>특수계약조건 초기화</span>
                </button>
              </div>
            </c:when>
          </c:choose>
      </c:if>
	    <div class="caution">
        <p class="caution_typo">※ 덴트너는 통신판매중개자로 서로의 원활한 거래를 위해 전자계약서비스를 제공해드릴 뿐, 거래 내용에 대해 어떠한 의무와 책임도 부담하지 않습니다.</p>
      </div>
	    <div class="electronic_contract_button_wrapper">
	      <div class="electronic_contract_button_container left">
	        <c:if test="${CNT01 gt 0 and (DATA.PROGRESS_CD eq 'PC002'or DATA.PROGRESS_CD eq 'PC004')}">
            <button type="button" class="electronic_contract_button white" onclick="fnModifyRequest();">
              <p class="electronic_contract_button_typo white_typo">수정요청</p>
            </button>
          </c:if>
	        <c:if test="${CNT02 gt 0 and (DATA.PROGRESS_CD eq 'PC001'or DATA.PROGRESS_CD eq 'PC003')}">
            <button type="button" class="electronic_contract_button white" onclick="fnModifyRequest();">
              <p class="electronic_contract_button_typo white_typo">수정요청</p>
            </button>
          </c:if>
        </div>
        <div class="electronic_contract_button_container right">
          <c:choose>
          <c:when test="${DATA.PROGRESS_CD eq 'PC005'}">
          </c:when>
            <c:when test="${empty DATA.CONTRACT_NO}"> <!-- 최초 -->
              <button type="button" class="electronic_contract_button white" onclick="fnCancel();">
                <p class="electronic_contract_button_typo white_typo">계약취소</p>
              </button>
              <button type="button" class="electronic_contract_button dark_blue without_margin_right" onclick="fnApprovalRequest();">
                <p class="electronic_contract_button_typo dark_blue">승인요청</p>
              </button>
            </c:when>
            <c:when test="${CNT01 gt 0 and (DATA.PROGRESS_CD eq 'PC002' or DATA.PROGRESS_CD eq 'PC004')}"> <!-- 의뢰자 기준 치자이너가 승인, 수정 요청 한 경우 -->
              <button type="button" class="electronic_contract_button white" onclick="fnCancel();">
                <p class="electronic_contract_button_typo white_typo">계약취소</p>
              </button>
              <button type="button" class="electronic_contract_button dark_blue without_margin_right" onclick="fnApproval();">
                <p class="electronic_contract_button_typo dark_blue">승인</p>
              </button>
            </c:when>
            <c:when test="${CNT02 gt 0 and (DATA.PROGRESS_CD eq 'PC001' or DATA.PROGRESS_CD eq 'PC003')}"> <!-- 치자이너 기준 의뢰자가 승인, 수정 요청 한 경우 -->
              <button type="button" class="electronic_contract_button white" onclick="fnCancel();">
                <p class="electronic_contract_button_typo white_typo">계약취소</p>
              </button>
              <button type="button" class="electronic_contract_button dark_blue without_margin_right" onclick="fnApproval();">
                <p class="electronic_contract_button_typo dark_blue">승인</p>
              </button>
            </c:when>
          </c:choose>
<%--           <c:if test="${CNT01 gt 0 and (DATA.PROGRESS_CD eq 'PC002' or DATA.PROGRESS_CD eq 'PC004')}"> <!-- 의뢰자 승인요청인 경우 --> --%>
<!--             <button type="button" class="electronic_contract_button dark_blue without_margin_right" onclick="fnApproval();"> -->
<!--               <p class="electronic_contract_button_typo dark_blue">승인</p> -->
<!--             </button> -->
<%--           </c:if> --%>
<%--           <c:if test="${CNT02 gt 0 and (DATA.PROGRESS_CD eq 'PC001' or DATA.PROGRESS_CD eq 'PC003')}"> <!-- 치자이너가 승인요청인 경우 --> --%>
<!--             <button type="button" class="electronic_contract_button dark_blue without_margin_right" onclick="fnApproval();"> -->
<!--               <p class="electronic_contract_button_typo dark_blue">승인</p> -->
<!--             </button> -->
<%--           </c:if> --%>
        </div>
      </div>
    </div>
  </div>
</form:form>
<style>
#question{
	margin-top: 14px;
    margin-left: 5px;
}
#question:hover ~ #tooltip{
	display:block;
}

#question:hover > #discription{
	display:block;
}

/* .tooltip-arrow,
#question + .tooltip > .tooltip-inner {background-color:#0083e8;} */
</style>