<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:if test="${empty sessionInfo.user}">
  <script>
   alert(getI8nMsg("alert.plzlogin"));
   location.href = '/api/login/view';
</script>
</c:if>
<%
String nm = "";
if(request.getParameter("nm") !=null){
	nm = request.getParameter("nm");
}
%>
<script>
  var cheesignerID = "${DATA.CHEESIGNER_ID}";
  var CREATEID = "${DATA.CLIENT}";
  
  console.log("cheesignerID :: " + cheesignerID);
  console.log("CREATEID :: " + CREATEID);
  
  var curid = "${sessionInfo.user.USER_ID}";
  
  console.log("curid :: " + curid);
  var realid = "";
  if(cheesignerID == curid){
	  realid = CREATEID;
	  console.log("1 :: ");
  }
  if(CREATEID == curid){
	  realid = cheesignerID;
	  console.log("2 :: ");
  }
  function message04_1() {
	  var result = '';
	  $.ajax({
	    url: '/' + API + '/common/message04_1',
	    type: 'POST',
	    data: { USER_NICK_NAME: "<%=nm%>"},
	    cache: false,
	    async: false,
	    success: function(data) {
	    }, complete: function() {
	      
	    }, error: function() {
	      
	    }
	  });
	  return result;
	}
  function message04_2() {
	  var result = '';
	  $.ajax({
	    url: '/' + API + '/common/message04_2',
	    type: 'POST',
	    data: { USER_ID: realid},
	    cache: false,
	    async: false,
	    success: function(data) {
	    }, complete: function() {
	      
	    }, error: function() {
	      
	    }
	  });
	  return result;
	}
  function message04() {
	  var result = '';
	  console.log("realid :: " + realid);
	  $.ajax({
	    url: '/' + API + '/common/message04',
	    type: 'POST',
	    data: { USER_ID: realid},
	    cache: false,
	    async: false,
	    success: function(data) {
	    }, complete: function() {
	      
	    }, error: function() {
	      
	    }
	  });
	  return result;
	}
  
  function fnAllView() {
    if('${MY_PAGE}' === 'Y') {
      location.href = '/' + API + '/mypage/equipment_estimator_my_page_progress';
	  } else {
      location.href = '/' + API + '/project/project_view_all';
	  }
  }
  var reqArr = new Array();
  var suppInfo = new Array();
  function fnViewEstimators() {
	  
		var cntArr = new Array();
		var rqstNoArr = new Array();
		var suppCdArr = new Array();
		var suppNmArr = new Array();
		var reqHtml = '';

	  reqArr.map((req, index) => {
			
			cntArr = req['CNT_STR'].split(',');
			rqstNoArr = req['RQST_NO_STR'].split(',');
			suppCdArr = req['SUPP_CD_STR'].split(',');
			suppNmArr = req['SUPP_NM_STR'].split(',');
			
			var suppStr = suppNmArr.map((nm, i) => {
				return nm + ' ' + cntArr[i] + getI8nMsg('unit');
			}).join(', ');
			
			reqHtml += '<div class="cad_estimator_dialog_request">';
			reqHtml += '  <p class="cad_estimator_dialog_request_title">의뢰서' + (index + 1) + '</p>';
			reqHtml += '	 <p class="cad_estimator_dialog_request_name">' + req.PANT_NM + '</p>';
			reqHtml += '	 <p class="cad_estimator_dialog_request_context">' + suppStr + '</p>';
			reqHtml += '</div>';
		});
		$('.cad_estimator_dialog_request_container').html(reqHtml);
		
		var suppHtml = '';
		suppInfo.map((m, i) => {
	  	suppHtml += '<div class="prosthetics_type_list_container">';
			suppHtml += '  <div class="prosthetics_type_list">';
			suppHtml += '	   <p class="prosthetics_type_list_typo">' + m.SUPP_NM_STR + '</p>';
			suppHtml += '	 </div>';
			suppHtml += '  <div class="prosthetics_type_list_divider"></div>';
			suppHtml += '  <div class="prosthetics_type_list">';
			suppHtml += '    <p class="prosthetics_type_list_typo">' + m.CNT + '</p>';
			suppHtml += '  </div>';
			suppHtml += '</div>';
	  });
		$('.view_prosthetics_type_list_container_wrapper').html(suppHtml);
	  
		fnGetEstimators();
}

var estimatorArr = new Array();

function fnGetEstimators() {
	  var ESTIMATORNO = '${ESTIMATOR_NO}';
	  
	  $.ajax({
		  url: '/' + API + '/project/getEstimatorInfo',
		  type: 'GET',
		  data: { ESTIMATOR_NO : ESTIMATORNO },
		  cache: false,
		  async: false,
		  success: function(data) {
				estimatorArr = data.estimatorList;
				if(isEmpty(estimatorArr)) {
					alert(getI8nMsg("alert.noQuo"));
					estimatorViewModal.hide();
				} else {
					fnSetEstimator(0);
					fnSetEstimatorPageInfo(0);
					estimatorViewModal.show();
				}
		  }, 
		  complete: function() {}, 
		  error: function() {}
		});
}

function fnSetEstimatorPageInfo() {
	  var pageIndex = arguments[0];
	  
	  var btnHtml = '';
		btnHtml += '<button class="pagination_page_button_prev ' + ((pageIndex > 0) ? '' : 'invisible') + '" type="button"';
		if(pageIndex > 0) {
			btnHtml += 'onclick="fnSetEstimator(' + (pageIndex - 1) + ');">';
		} else {
			btnHtml += '>';
		}
		btnHtml += '	<img src="/public/assets/images/dialog_page_next_button_arrow.svg" class="pagination_page_before_button_arrow"/>';
		btnHtml += '</button>';
		btnHtml += '<p class="pagination_current_page">' + (pageIndex + 1) + '&nbsp;</p>';
		btnHtml += '<p class="pagination_total_page">/ ' + estimatorArr.length + '</p>';
		btnHtml += '<button class="pagination_page_button ' + ((pageIndex == estimatorArr.length - 1) ? 'invisible' : '') + '" type="button"';
		if(pageIndex == estimatorArr.length - 1) {
			btnHtml += '>';
		} else {
			btnHtml += 'onclick="fnSetEstimator(' + (pageIndex + 1) + ');">';
		}
		btnHtml += '	<img src="/public/assets/images/dialog_page_next_button_arrow.svg" class="pagination_page_next_button_arrow"/>';
		btnHtml += '</button>';
		
		$('.cad_estimator_pagination').html(btnHtml);
}

var currEstimator;

function fnSetEstimator() {
	  var index = arguments[0];
	  currEstimator = estimatorArr[index];
	  
	  $('#viewDeliveryPosDateTypo').text(currEstimator['DELIVERY_POS_DATE']);
	  
	  var suppDtlHtml = '';
	  var totalPrice = 0;
	  currEstimator.dtlInfo.map((m, i) => {
		  suppDtlHtml += '<div class="cad_estimator_dialog_item_context">';
			suppDtlHtml += '	<div class="dialog_item_context_calculate_price_wrapper">';
			suppDtlHtml += '		<div class="dialog_item_context_calculate_price without_margin">';
			var suppNmStr = [m.SUPP_CD_1, m.SUPP_CD_2, m.SUPP_CD_3, m.SUPP_CD_4].filter(f => isNotEmpty(f)).map(m => fnFindSuppNm(m)).join(' - ');
			suppDtlHtml += '			<input class="cad_estimator_dialog_item_context_blank_prosthetics_type" readonly value="' + suppNmStr + '"/>';
			suppDtlHtml += '			<input class="cad_estimator_dialog_item_context_blank_price" readonly value="' + m.UNIT_PRICE + '"/>';
			suppDtlHtml += '			<p class="operator">X</p>';
			suppDtlHtml += '			<input class="cad_estimator_dialog_item_context_blank_count" readonly value=" '+ m.AMOUNT + '"/>';
			suppDtlHtml += '			<p class="operator">=</p>';
			suppDtlHtml += '			<div class="dialog_item_context_typo_container price_area">';
			suppDtlHtml += '				<p class="dialog_item_context_typo price_num">' + m.SUM_AMOUNT + '</p>';
			suppDtlHtml += '				<p class="dialog_item_context_typo"><spring:message code="won" text="원" /></p>';
			suppDtlHtml += '			</div>';
			suppDtlHtml += '		</div>';
			suppDtlHtml += '	</div>';
			suppDtlHtml += '</div>';
			
			totalPrice += (+m.SUM_AMOUNT);
	  });
	  $('.cad_estimator_dialog_item_context_wrapper').html(suppDtlHtml);
	  $('.cad_estimator_total_price_wrapper #totalPriceNum').text(totalPrice);
	  
	  var cadswInfo = new Array();
	  if(isNotEmpty(currEstimator.CADSW_CD_1)) cadswInfo.push(currEstimator.CADSW_NM_1);
	  if(isNotEmpty(currEstimator.CADSW_CD_2)) cadswInfo.push(currEstimator.CADSW_NM_2);
	  if(isNotEmpty(currEstimator.CADSW_CD_3)) cadswInfo.push(currEstimator.CADSW_NM_3);
	  
	  $('#viewCadswTypo').text(cadswInfo.join(', '));
	  
	  currEstimator.fileList.map((m, i) => {
		  m.FILE_DIRECTORY = m.FILE_DIRECTORY.replace(/\\/g, '\/');
		  if(i == 0) $('#viewMainPicImage').attr('src', '/upload/' + m.FILE_DIRECTORY);
		  const target = $('.cad_estimator_sub_pic_upload').eq(i);
			target.addClass('active');
			target.css('background-image', "url('/upload/" + m.FILE_DIRECTORY + "')");
	  });
	  
	  fnSetEstimatorPageInfo(index);
	  
	  // 치자이너 정보 변경
//	  console.log('currEstimator', currEstimator);
  $('#p_info_1').html(currEstimator.USER_NICK_NAME);
  
  if(currEstimator.TAX_BILL_YN === 'Y') {
    $('#p_info_2').html('세금 계산서 발행 가능');
  } else {
    $('#p_info_2').html('');
  }
  
  $('#p_info_3').html(currEstimator.COMPLETE_RATIO + ' %'); // 거래 성공률
  $('#p_info_4').html(currEstimator.SCORE_AVG + ' / 10'); // 만족도
  $('#p_info_5').html(addComma(currEstimator.COMPLETE_AMOUNT) + ' 원'); // 거래 총 금액
}
  function fnApproval() {
    var estimatorNo = '${ESTIMATOR_NO}';
    if(isEmpty(estimatorNo)) {
      alert(getI8nMsg("alert.notValidReq"));//올바른 요청이 아닙니다.
    } else {
      
      var agreementYn1 = $('#AGREEMENT_YN_1').val();
      var agreementYn2 = $('#AGREEMENT_YN_2').val();
      var agreementYn3 = $('#AGREEMENT_YN_3').val();
      var agreementYn4 = $('#AGREEMENT_YN_4').val();
      
      if(agreementYn1 !== 'Y' || agreementYn2 !== 'Y' || agreementYn3 !== 'Y') {
    	alert(getI8nMsg("alert.mustAgree"));//필수 동의 항목을 동의해야 승인이 가능합니다.
        return;
      }
      
      if($('#SP_CHANGE').val() === 'Y') {
    	alert(getI8nMsg("alert.changedPlzReq"));//특수계약 조건이 변경되었습니다. 수정요청 하시기 바랍니다.
        $('#SPECIAL_CONDITION').focus();
        return;
      }
      
      var isConfirm = window.confirm(getI8nMsg("alert.confirm.aprrove")); //승인하시겠습니까?
      if(!isConfirm) return;
      
      var saveObj = getSaveObj('saveForm');
      message04();
      $.ajax({
        url: '/' + API + '/contract/save02',
        type: 'POST',
        data: saveObj,
        cache: false,
        async: false,
        success: function(data) {
            setTimeout(function(){
                fnAllView();       	  
            },100);

        }, complete: function() {
        }, error: function() {
        }
      });
    }
  }
  
  function fnModifyRequest() {
    var estimatorNo = '${ESTIMATOR_NO}';
    if(isEmpty(estimatorNo)) {
    	alert(getI8nMsg("alert.notValidReq"));//올바른 요청이 아닙니다.
    } else {
      
      var agreementYn1 = $('#AGREEMENT_YN_1').val();
      var agreementYn2 = $('#AGREEMENT_YN_2').val();
      var agreementYn3 = $('#AGREEMENT_YN_3').val();
      var agreementYn4 = $('#AGREEMENT_YN_4').val();
      
      if(agreementYn1 !== 'Y' || agreementYn2 !== 'Y' || agreementYn3 !== 'Y') {
    	  alert(getI8nMsg("alert.mustAgree"));//alert('필수 동의 항목을 동의해야 수정요청이 가능합니다.');
        return;
      }
      
      var isConfirm = window.confirm(getI8nMsg("alert.confirm.correct"));//수정요청 하시겠습니까?
      if(!isConfirm) return;
      
      var saveObj = getSaveObj('saveForm');
      message04_2();
      $.ajax({
        url: '/' + API + '/contract/save03',
        type: 'POST',
        data: saveObj,
        cache: false,
        async: false,
        success: function(data) {
            setTimeout(function(){
                fnAllView();       	  
            },100);
        }, complete: function() {
        }, error: function() {
        }
      });
      
      
    }
  }
  
  function fnApprovalRequest() {
    var estimatorNo = '${ESTIMATOR_NO}';
    if(isEmpty(estimatorNo)) {
    	alert(getI8nMsg("alert.notValidReq"));//올바른 요청이 아닙니다.
    } else {
      
    	var contractNo = $('#CONTRACT_NO').val(); 
      var agreementYn1 = $('#AGREEMENT_YN_1').val();
      var agreementYn2 = $('#AGREEMENT_YN_2').val();
      var agreementYn3 = $('#AGREEMENT_YN_3').val();
      var agreementYn4 = $('#AGREEMENT_YN_4').val();
      
      if(agreementYn1 !== 'Y' || agreementYn2 !== 'Y' || agreementYn3 !== 'Y') {
    	  alert(getI8nMsg("alert.mustAgree"));//alert('필수 동의 항목을 동의해야 승인요청이 가능합니다.');
        return;
      }      
      
      if(isNotEmpty(contractNo) && $('#SP_CHANGE').val() === 'Y') {
    	  alert(getI8nMsg("alert.changedPlzReq"));//특수계약 조건이 변경되었습니다. 수정요청 하시기 바랍니다.
        $('#SPECIAL_CONDITION').focus();
        return;
      }
        
      var isConfirm = window.confirm(getI8nMsg("alert.confirm.aprroval"));//승인요청 하시겠습니까?
      if(!isConfirm) return;
      
      var saveObj = getSaveObj('saveForm');
      message04_1();
      $.ajax({
        url: '/' + API + '/contract/save01',
        type: 'POST',
        data: saveObj,
        cache: false,
        async: false,
        success: function(data) {
            setTimeout(function(){
                fnAllView();       	  
            },100);
        }, complete: function() {
        }, error: function() {
        }
      });
    }
  }
  
  function fnCancel() {
    var estimatorNo = '${ESTIMATOR_NO}';
    if(isEmpty(estimatorNo)) {
    	alert(getI8nMsg("alert.notValidReq"));//올바른 요청이 아닙니다.
    } else {
      var isConfirm = window.confirm(getI8nMsg("alert.confirm.cancelContr"));//계약취소 하시겠습니까?
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
      messageSend08_2(realid);
    }
  }
  function messageSend08_2(id) {
	  var result = '';

	  $.ajax({
	    url: '/' + API + '/common/message08_2',
	    type: 'POST',
	    data: { RECEIVE_ID: id},
	    cache: false,
	    async: false,
	    success: function(data) {
	    }, complete: function() {
	      
	    }, error: function() {
	      
	    }
	  });
	  return result;
	}
  function fnAllCheck() {
    var target = arguments[0];
    if($(target).is(':checked')) {
      $('#AGREEMENT_YN_1').prop('checked', true);
      $('#AGREEMENT_YN_2').prop('checked', true);
      $('#AGREEMENT_YN_3').prop('checked', true);
      //$('#AGREEMENT_YN_4').prop('checked', true);
      $('#CHOICE_AGREEMENT_YN_1').prop('checked', true);
      $('#AGREEMENT_YN_1').val('Y');
      $('#AGREEMENT_YN_2').val('Y');
      $('#AGREEMENT_YN_3').val('Y');
      //$('#AGREEMENT_YN_4').val('Y');
      $('#CHOICE_AGREEMENT_YN_1').val('Y');
    } else {
      $('#AGREEMENT_YN_1').prop('checked', false);
      $('#AGREEMENT_YN_2').prop('checked', false);
      $('#AGREEMENT_YN_3').prop('checked', false);
      //$('#AGREEMENT_YN_4').prop('checked', false);
      $('#CHOICE_AGREEMENT_YN_1').prop('checked', false);
      $('#AGREEMENT_YN_1').val('N');
      $('#AGREEMENT_YN_2').val('N');
      $('#AGREEMENT_YN_3').val('N');
      //$('#AGREEMENT_YN_4').val('N');
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
    var isConfirm = window.confirm(getI8nMsg("alert.confirm.init"));//특수 계약조건을 초기화 하시겠습니까?
    if(!isConfirm) return;
    var temp = $('#SPECIAL_CONDITION_TEMP').val();
    $('#SPECIAL_CONDITION').val(temp);
    $('#SP_CHANGE').val('N');
  }
  var profileModal;
  var estimatorModal;
  var estimatorViewModal;
  $(document).ready(function() {
    
    var agreementYn1 = '${DATA.AGREEMENT_YN_1}';
    var agreementYn2 = '${DATA.AGREEMENT_YN_2}';
    var agreementYn3 = '${DATA.AGREEMENT_YN_3}';

    var choiceAgreementYn_1 = '${DATA.CHOICE_AGREEMENT_YN_1}';
    
    if(agreementYn1 === 'Y') $('#AGREEMENT_YN_1').prop('checked', true);
    if(agreementYn2 === 'Y') $('#AGREEMENT_YN_2').prop('checked', true);
    if(agreementYn3 === 'Y') $('#AGREEMENT_YN_3').prop('checked', true);

    if(choiceAgreementYn_1 === 'Y') $('#CHOICE_AGREEMENT_YN_1').prop('checked', true);
    
    if(agreementYn1 === 'Y' && agreementYn2 === 'Y' && agreementYn3 === 'Y') {
      $('#ALL_CHECKBOX').prop('checked', true);
    }
	  
	  estimatorViewModal = new bootstrap.Modal(document.getElementById('estimatorViewModal'));
/* 	  var estimatorModalEl = document.getElementById('estimatorModal');
	  estimatorModalEl.addEventListener('hidden.bs.modal', function(e) {
		  fnCloseEstimatorModal();
		}); */
	  
  });
  
</script>
<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>
<link type="text/css" rel="stylesheet" href="/public/assets/css/modal.css"/>
<!-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script> -->
<form:form id="saveForm" name="saveForm">

  <input type="hidden" id="CONTRACT_NO" name="CONTRACT_NO" value="${DATA.CONTRACT_NO}">
  <input type="hidden" id="ESTIMATOR_NO" name="ESTIMATOR_NO" value="${ESTIMATOR_NO}">
  
  <input type="hidden" id="PROJECT_NO" name="PROJECT_NO" value="${DATA.PROJECT_NO}">
  <input type="hidden" id="PROGRESS_CD" name="PROGRESS_CD" value="${DATA.PROGRESS_CD}">
  <input type="hidden" id="COMPLETE_YN" name="COMPLETE_YN" value="${DATA.COMPLETE_YN}">
  <input type="hidden" id="CHEESIGNER_ID" name="CHEESIGNER_ID" value="${DATA.CHEESIGNER_ID}">
  
  <input type="hidden" id="SP_CHANGE" name="SP_CHANGE" value="N">

	<div class="project_header">
	  <p class="project_header_typo"><spring:message code="econtact" text="전자계약서" /></p>
	</div>
	
	<div class="project_body">
    <div class="side_menu">
      <div class="side_menu_title">
        <p class="side_menu_title_typo"><spring:message code="main.seeAll" text="전체보기" /></p>
      </div>
      <a href="/${api}/mypage/equipment_estimator_my_page_equipment" class="side_menu_list">
        <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
        <p class="side_menu_list_typo"><spring:message code="req.reqHis" text="견적·의뢰내역" /></p>
      </a>
      <a href="/${api}/tribute/request_basket" class="side_menu_list">
        <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
        <p class="side_menu_list_typo"><spring:message code="req.myReq" text="의뢰서 바구니" /></p>
      </a>
      <a href="/${api}/mypage/equipment_estimator_my_page_progress" class="side_menu_list">
        <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
        <p class="side_menu_list_typo_blue"><spring:message code="req.progD" text="진행내역" /></p>
      </a>
      <c:choose>
        <c:when test="${sessionInfo.user.USER_TYPE_CD eq 1 or sessionInfo.user.USER_TYPE_CD eq 2}">
          <a href="/${api}/mypage/profile_management" class="side_menu_list">
            <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
            <p class="side_menu_list_typo"><spring:message code="req.myProf" text="프로필 관리" /></p>
          </a>
        </c:when>
        <c:when test="${sessionInfo.user.USER_TYPE_CD eq 3}">
          <a href="/${api}/mypage/profile_management_cheesigner" class="side_menu_list">
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
	  <div class="electronic_contract_main_container">
	    <div class="project_connection_location_container">
	      <a href="/" class="project_connection_location_typo">
	        <img class="project_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
	      </a>
	      <img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="project_connection_location">
	        <p class="project_connection_location_typo"><spring:message code="req.myPage" text="마이페이지" /></p>
	      </div>
	      <img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="project_connection_location">
	        <p class="project_connection_location_typo"><spring:message code="req.progD" text="진행내역" /></p>
	      </div>
	      <img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="project_connection_location">
	        <p class="project_connection_location_typo_bold"><spring:message code="econtact" text="전자계약서" /></p>
	      </div>
	    </div>
	    <div class="connection_location_divider"></div>
	    <div class="electronic_contract_wrapper">
	      <div class="electronic_contract_container">
	          <div class="electronic_contract_condition">
	            <div class="electronic_contract_condition_typo_container">
	              <p class="electronic_contract_condition_typo"><spring:message code="proj.genSerCon" text="용역 일반 계약서 동의" /></p>
	              <!-- 수정필요 -->
	              <a href="javascript:window.open('https://www.dentner.co.kr/static/용역 계약서.pdf')" class="electronic_contract_condition_typo short_cut"><spring:message code="see" text="바로가기" /></a>
	            </div>
	            <label class="checkbox_large">
                <input type="checkbox" id="AGREEMENT_YN_1" name="AGREEMENT_YN_1" value="${DATA.AGREEMENT_YN_1}" onchange="fnChangeCheck(this);">
              </label>
	          </div>
	          <div class="electronic_contract_condition">
	            <div class="electronic_contract_condition_typo_container">
	              <p class="electronic_contract_condition_typo"><spring:message code="proj.remake" text="remake" /></p>
	            </div>
	            <label class="checkbox_large">
                <input type="checkbox" id="AGREEMENT_YN_2" name="AGREEMENT_YN_2" value="${DATA.AGREEMENT_YN_2}" onchange="fnChangeCheck(this);">
              </label>
	        </div>
	        <div class="electronic_contract_condition">
	          <div class="electronic_contract_condition_typo_container">
	          <!-- 수정필요 -->
	            <p class="electronic_contract_condition_typo"><spring:message code="proj.electQuot" text="전자견적서 이행" /></p>
	            <a href="javascript:fnViewEstimators();" class="electronic_contract_condition_typo short_cut"><spring:message code="see" text="바로가기" /></a>
	          </div>
	          <label class="checkbox_large">
              <input type="checkbox" id="AGREEMENT_YN_3" name="AGREEMENT_YN_3" value="${DATA.AGREEMENT_YN_3}" onchange="fnChangeCheck(this);">
            </label>
	        </div>
	        <%-- <div class="electronic_contract_condition">
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
	        </div> --%>
	        <input type="hidden" id="AGREEMENT_YN_4" name="AGREEMENT_YN_4" value="Y">
	        <input type="hidden" name="CHOICE_AGREEMENT_YN_1" value="Y">
	      </div>
	      <div class="main_container_divider divider_without_margin"></div>
	      <div class="accept_all">
	        <p class="accept_all_typo"><spring:message code="proj.allAgree" text="전체 동의하기" /></p>
	        <label class="checkbox_large">
            <input type="checkbox" id="ALL_CHECKBOX" onchange="fnAllCheck(this);">
          </label>
	      </div>
	    </div>
	    <div class="main_container_divider"></div>
	    <div class="special_contract">
	      <p class="special_contract_title" style="float:left"><spring:message code="proj.sepcCondit" text="특수 계약조건" /></p>
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
				<textarea class="special_contract_context" id="SPECIAL_CONDITION" name="SPECIAL_CONDITION" maxlength="1300" onchange="fnSpChange(this);" placeholder="<spring:message code="proj.writeOthReq" text="의뢰자와 치자이너 서로의 요청사항을 써주세요" />" disabled>${DATA.SPECIAL_CONDITION}</textarea>
            </c:when>
            <c:when test="${CNT01 gt 0 and (DATA.PROGRESS_CD eq 'PC001' or DATA.PROGRESS_CD eq 'PC003')}"> <!-- 치자이너 기준 의뢰자가 승인, 수정 요청 한 경우 -->
				<textarea class="special_contract_context" id="SPECIAL_CONDITION" name="SPECIAL_CONDITION" maxlength="1300" onchange="fnSpChange(this);" placeholder="<spring:message code="proj.writeOthReq" text="의뢰자와 치자이너 서로의 요청사항을 써주세요" />" disabled>${DATA.SPECIAL_CONDITION}</textarea>
            </c:when>
            <c:when test="${DATA.PROGRESS_CD eq 'PC005'}">
            	<textarea class="special_contract_context" id="SPECIAL_CONDITION" name="SPECIAL_CONDITION" maxlength="1300" onchange="fnSpChange(this);" placeholder="<spring:message code="proj.writeOthReq" text="의뢰자와 치자이너 서로의 요청사항을 써주세요" />" disabled>${DATA.SPECIAL_CONDITION}</textarea>
            </c:when>
            <c:otherwise>
            	<textarea class="special_contract_context" id="SPECIAL_CONDITION" name="SPECIAL_CONDITION" maxlength="1300" onchange="fnSpChange(this);" placeholder="<spring:message code="proj.writeOthReq" text="의뢰자와 치자이너 서로의 요청사항을 써주세요" />">${DATA.SPECIAL_CONDITION}</textarea>
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
        <p class="caution_typo">※ <spring:message code="proj.comment" text="덴트너는 통신판매중개자로 서로의 원활한 거래를 위해 전자계약서비스를 제공해드릴 뿐, 거래 내용에 대해 어떠한 의무와 책임도 부담하지 않습니다." /></p>
      </div>
	    <div class="electronic_contract_button_wrapper">
	      <div class="electronic_contract_button_container left">
	        <c:if test="${CNT01 gt 0 and (DATA.PROGRESS_CD eq 'PC002'or DATA.PROGRESS_CD eq 'PC004')}">
            <button type="button" class="electronic_contract_button white" onclick="fnModifyRequest();">
              <p class="electronic_contract_button_typo white_typo"><spring:message code="proj.modifyReq" text="수정요청" /></p>
            </button>
          </c:if>
	        <c:if test="${CNT02 gt 0 and (DATA.PROGRESS_CD eq 'PC001'or DATA.PROGRESS_CD eq 'PC003')}">
            <button type="button" class="electronic_contract_button white" onclick="fnModifyRequest();">
              <p class="electronic_contract_button_typo white_typo"><spring:message code="proj.modifyReq" text="수정요청" /></p>
            </button>
          </c:if>
        </div>
        <div class="electronic_contract_button_container right">
          <c:choose>
          <c:when test="${DATA.PROGRESS_CD eq 'PC005'}">
          </c:when>
            <c:when test="${empty DATA.CONTRACT_NO}"> <!-- 최초 -->
              <button type="button" class="electronic_contract_button white" onclick="fnCancel();">
                <p class="electronic_contract_button_typo white_typo"><spring:message code="proj.contCancel" text="계약취소" /></p>
              </button>
              <button type="button" class="electronic_contract_button dark_blue without_margin_right" onclick="fnApprovalRequest();">
                <p class="electronic_contract_button_typo dark_blue"><spring:message code="proj.approvalReq" text="승인요청" /></p>
              </button>
            </c:when>
            <c:when test="${CNT01 gt 0 and (DATA.PROGRESS_CD eq 'PC002' or DATA.PROGRESS_CD eq 'PC004')}"> <!-- 의뢰자 기준 치자이너가 승인, 수정 요청 한 경우 -->
              <button type="button" class="electronic_contract_button white" onclick="fnCancel();">
                <p class="electronic_contract_button_typo white_typo"><spring:message code="proj.contCancel" text="계약취소" /></p>
              </button>
              <button type="button" class="electronic_contract_button dark_blue without_margin_right" onclick="fnApproval();">
                <p class="electronic_contract_button_typo dark_blue"><spring:message code="proj.approval" text="승인" /></p>
              </button>
            </c:when>
            <c:when test="${CNT02 gt 0 and (DATA.PROGRESS_CD eq 'PC001' or DATA.PROGRESS_CD eq 'PC003')}"> <!-- 치자이너 기준 의뢰자가 승인, 수정 요청 한 경우 -->
              <button type="button" class="electronic_contract_button white" onclick="fnCancel();">
                <p class="electronic_contract_button_typo white_typo"><spring:message code="proj.contCancel" text="계약취소" /></p>
              </button>
              <button type="button" class="electronic_contract_button dark_blue without_margin_right" onclick="fnApproval();">
                <p class="electronic_contract_button_typo dark_blue"><spring:message code="proj.approval" text="승인" /></p>
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
				<!-- 받은 견적서 보기 modal -->
				<div class="modal fade" id="estimatorViewModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
				  <div class="modal-dialog modal-dialog-centered">
				    <div class="modal-content" style="width: fit-content;">
						  <div class="cad_container">
				        <div class="dialog_header">
				         	<p class="dialog_header_typo">
				          	<spring:message code="equ.viewCAD" text="CAD 견적서 보기" />
				          </p>
				          <a href="javascript:void(0)" data-bs-dismiss="modal" aria-label="Close">
				          	<img class="dialog_close_button" src="/public/assets/images/dialog_close_button.svg"/>
				          </a>
				        </div>
				        <div class="cad_estimator_dialog_item">
									<div class="dialog_item_title cad_title">
										<p class="dialog_item_title_typo">
											<spring:message code="proj.delivTm" text="납품가능시간" />
										</p>
									</div>
									<div class="dialog_item_context_container">
										<p id="viewDeliveryPosDateTypo" class="dialog_item_context_typo">
										</p>
									</div>
				        </div>
				        <div class="main_container_divider without_margin"></div>
				        <div class="cad_estimator_dialog_item_column">
									<div class="dialog_item_title cad_title">
										<p class="dialog_item_title_typo">
											<spring:message code="amount" text="금액" />
										</p>
									</div>
				          <div class="cad_estimaotor_dialog_item_context_container_price_area">
										<div class="cad_estimator_dialog_item_context">
											<div class="cad_estimator_dialog_request_container">
											</div>
										</div>
										<div class="dotted_divider_container">
											<img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
											<img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
										</div>
				            <div class="prosthetics_type_container">
											<div class="prosthetics_type_data_type_container">
												<div class="prosthetics_type_data_type">
													<p class="prosthetics_type_data_type_typo">
														<spring:message code="req.prosthT" text="보철종류" />
													</p>
												</div>
												<div class="prosthetics_type_data_type_divider"></div>
												<div class="prosthetics_type_data_type">
													<p class="prosthetics_type_data_type_typo">
														<spring:message code="req.quant" text="개수" />
													</p>
												</div>
											</div>
											<div class="view_prosthetics_type_list_container_wrapper"></div>
				            </div>
										<div class="dotted_divider_container">
											<img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
											<img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
										</div>
										<div class="cad_estimator_dialog_item_context_wrapper"></div>
										<div class="cad_estimator_total_price_wrapper">
											<div class="dialog_item_context_typo_container total_price_area">
												<p class="dialog_item_context_typo total_price"><spring:message code="equ.totA" text="총 금액" /></p>
												<p id="totalPriceNum" class="dialog_item_context_typo price_num">
													2,500,000
												</p>
												<p class="dialog_item_context_typo">
													원
												</p>
											</div>
										</div>
				        	</div>
				        </div>
				        <div class="main_container_divider without_margin"></div>
				        <div class="cad_estimator_dialog_item">
									<div class="dialog_item_title cad_title">
										<p class="dialog_item_title_typo">
											<spring:message code="proj.availaCADSW" text="구동가능한 CAD S/W" />
										</p>
									</div>
									<div class="dialog_item_context_container without_padding">
										<p id="viewCadswTypo" class="dialog_item_context_typo">
											<!-- 3Shape, EXOCAD, Dentalwing -->
										</p>
									</div>
				        </div>
				        <div class="main_container_divider without_margin"></div>
				        <div class="cad_estimator_dialog_item">
									<div class="cad_estimator_dialog_item_title cad_title">
										<p class="dialog_item_title_typo">
											<spring:message code="equ.upload" text="사진 업로드" />
										</p>
									</div>
									<div class="cad_estimator_pic_upload_wrapper">
										<div class="cad_estimator_pic_upload_container" style="margin-right: 110px;">
											<div class="cad_estimator_main_pic_upload_wrapper">
												<img id="viewMainPicImage" class="cad_estimator_main_pic_upload" src="/public/assets/images/profile_image.svg" style="width: 100%; height: 100%;"/>
											</div>
										</div>
									</div>
				        </div>
				        <div class="cad_estimator_sub_pic_upload_wrapper">
									<div class="cad_estimator_sub_pic_upload_container">
										<div class="cad_estimator_sub_pic_upload"></div>
										<div class="cad_estimator_sub_pic_upload"></div>
										<div class="cad_estimator_sub_pic_upload"></div>
										<div class="cad_estimator_sub_pic_upload"></div>
										<div class="cad_estimator_sub_pic_upload"></div>
									</div>
									<div class="cad_estimator_sub_pic_upload_container">
										<div class="cad_estimator_sub_pic_upload"></div>
										<div class="cad_estimator_sub_pic_upload"></div>
										<div class="cad_estimator_sub_pic_upload"></div>
										<div class="cad_estimator_sub_pic_upload"></div>
										<div class="cad_estimator_sub_pic_upload"></div>
									</div>
				        </div>
				        <div class="main_container_divider without_margin"></div>
				        <div class="cad_estimator_dialog_item">
									<div class="dialog_item_title cad_title">
										<p class="dialog_item_title_typo">치자이너 정보</p>
									</div>
									<div class="cad_estimator_dialog_item_context">
<!-- 										<div class="cad_estimator_profile_pic_upload"></div> -->
										<div class="cad_estimator_profile_typo_container">
											<div class="cad_estimator_profile_name">
												<p id="p_info_1" class="cad_estimator_profile_name_typo">중랑구 핫도그</p>
												<p id="p_info_2" class="cad_estimator_dialog_item_sub_title_typo">세금 계산서 발행 가능</p>
											</div>
											<div class="cad_estimator_profile_info_container">
												<div class="cad_estimator_profile_info">
													<p class="cad_estimator_profile_info_typo">거래 성공률</p>
													<p id="p_info_3" class="cad_estimator_profile_info_typo">100 %</p>
												</div>
												<div class="cad_estimator_profile_info">
													<p class="cad_estimator_profile_info_typo">만족도</p>
													<p id="p_info_4" class="cad_estimator_profile_info_typo">82 %</p>
												</div>
												<div class="cad_estimator_profile_info without_margin">
													<p class="cad_estimator_profile_info_typo">거래 총 금액</p>
													<p id="p_info_5" class="cad_estimator_profile_info_typo">1234,567 원</p>
												</div>
											</div>
										</div>
									</div>
				        </div>
				        <div class="main_container_divider without_margin"></div>
				        <div class="cad_estimator_pagination">
									<!-- <button type="button" class="pagination_page_button invisible">
										<img src="/public/assets/images/dialog_page_next_button_arrow.svg" class="pagination_page_before_button_arrow"/>
									</button>
									<p class="pagination_current_page">1&nbsp;</p>
									<p class="pagination_total_page">/ 3</p>
									<button type="button" class="pagination_page_button">
										<img src="/public/assets/images/dialog_page_next_button_arrow.svg" class="pagination_page_next_button_arrow"/>
									</button> -->
				        </div>
<!-- 				        <div class="button_container">
									<a href="javascript:void(0)" class="button_white" onclick="fnDeleteEstimator();">
										<p class="button_white_typo">견적서 삭제하기</p>
									</a>
									<a href="javascript:void(0)" class="button_blue" onclick="fnMatching();">
									  <p class="button_blue_typo">매칭하기</p>
									</a>
				        </div> -->
				    	</div>
				    </div>
				  </div>
				</div>
				<!-- 받은 견적서 보기 modal end -->
				<jsp:include page="/WEB-INF/views/dialog/profile_dialog.jsp" flush="true" />
				<jsp:include page="/WEB-INF/views/page/talk/common_send.jsp" flush="true"/>
	
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