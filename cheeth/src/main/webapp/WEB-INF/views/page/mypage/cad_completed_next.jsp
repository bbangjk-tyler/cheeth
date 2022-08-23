<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%
	String alreadychk = "0";
	if(request.getParameter("alreadychk") != null){
		alreadychk = request.getParameter("alreadychk");
	}
%>

<c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if>
<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>
<link type="text/css" rel="stylesheet" href="/public/assets/css/modal.css"/>

<script>

  var requestPreviewModal;
  
  function fnRequestView() {
    var groupCd = arguments[0];
    fnPreview(groupCd);
    requestPreviewModal.show();
  }
  var alreaychk = <%=alreadychk %>;
  $(document).ready(function(){
	  if(alreaychk == 1){
		  $(".cad_completed_send_button").css("display", "none");
	  }
  });
  function fnSend() {
    
    var isConfirm = window.confirm('결제를 완료하셨습니까?');
    if(!isConfirm) return;
    
    $.ajax({
     url: '/' + API + '/mypage/cad_completed_next/save05',
     type: 'POST',
     data: { WR_NO : '${DATA_01.WR_NO}' },
     cache: false,
     async: false,
     success: function(data) {
    	 alert("결제를 완료하셨습니까? \n 치자이너 회원님의 입금확인 후에 완성된 캐드파일을 다운로드 하실 수 있습니다.");
    	 message07();
       if(data.cnt === 0) {
    	   alert('업데이트 실패하였습니다.');
       }
       location.href = '/' + API + '/mypage/equipment_estimator_my_page_progress';
     }, complete: function() {
     }, error: function() {
     }
   });
  }
  console.log("${DATA_02.CHEESIGNER_ID}");
  function message07() {
	  var result = '';
	  var p_info_1 = "${DATA_02.CHEESIGNER_ID}";
	  $.ajax({
	    url: '/' + API + '/common/message07',
	    type: 'POST',
	    data: { USER_ID: p_info_1},
	    cache: false,
	    async: false,
	    success: function(data) {
	    }, complete: function() {
	      
	    }, error: function() {
	      
	    }
	  });
	  return result;
	}
  
  function fnSetReqInfo() {
    var gsc = '${DATA_01.GCS}';
    if(isNotEmpty(gsc)) {
      gsc.split('l').map((groupCd, index) => {
        var pantNm = '';
        var totalCnt = 0;
        var rtnArray = new Array();
        $.ajax({
          url: '/' + API + '/mypage/getSuppInfo',
          type: 'GET',
          data: { GROUP_CD : groupCd },
          cache: false,
          async: false,
          success: function(data) {
            rtnArray = data;
            var html = ``;
            html += `<div class="receive_estimator_request_container">`;
            html += `<div class="receive_estimator_request">`;
            html += `<p class="receive_estimator_request_name">` + rtnArray[0]['PANT_NM'] + `</p>`;
            html += `<a href="javascript:fnRequestView('\${groupCd}');" class="receive_estimator_request_view_request_button">의뢰서 보기</a>`;
            html += `<p class="receive_estimator_request_context">`;
            rtnArray.map(m => {
             html += m.SUPP_NM + ' ' + m.CNT + '개, ';
            });
            html = html.substring(0, html.lastIndexOf(','));
            html += `</p>`;
            html += `<p class="receive_estimator_request_count">` + rtnArray[0]['TOTAL_CNT'] + `개</p>`;
            html += `</div>`;
            if(isNotEmpty(rtnArray[0]['WR_FILE_CD'])) {
                html += `<button type="button" class="receive_estimator_attatchment_download_button" onclick="javascript:alert('결제완료와 입금확인 후에 파일 다운로드가 가능합니다.');">`;
                html += `<p class="receive_estimator_attatchment_download_button_typo">첨부파일 다운로드</p>`;
                html += `</button>`;
              }
            html += `</div>`;
            $('.receive_estimator_request_wrapper').append(html);
            fnSetNext(data);
          }, complete: function() {
          }, error: function() {
          }
        });
      });
    }
  }
  
  function fnSetNext() {
    var reqArr = arguments[0];
    $.ajax({
      url: '/' + API + '/tribute/getSuppInfo',
      type: 'POST',
      data: JSON.stringify({ GROUP_CD_LIST : Array.from(new Set(reqArr.map(m => m.GROUP_CD))) }),
      contentType: 'application/json; charset=utf-8',
      cache: false,
      async: false,
      success: function(data) {
        data.map((m, i) => {
          var suppHtml = ``;
          suppHtml += `<div class="receive_estimator_total_prosthetics_info_container">`;
          suppHtml += `<p class="receive_estimator_total_prosthetics_info">` + m.SUPP_NM_STR + `</p>`;
          suppHtml += `<p class="receive_estimator_total_prosthetics_info">` + m.CNT + `</p>`;
          suppHtml += `</div>`;
          $('.receive_estimator_total_prosthetics').append(suppHtml);
        });
      }, 
      complete: function() {}, 
      error: function() {}
    });
  }
  
  $(document).ready(function() {
   
    requestPreviewModal = new bootstrap.Modal(document.getElementById('requestModal'));
    
    fnSetReqInfo();
    
    $('.c1').html(addComma('${DATA_02.ESTIMATE_AMOUNT}')); // 견적금액
    $('.c2').html(addComma('${DATA_02.LAST_AMOUNT}')); // 최종금액
    
  });
  
</script>

<form:form id="saveForm" name="saveForm">
  <input type="hidden" id="WR_NO" name="WR_NO" value="${DATA_02.WR_NO}">
  <input type="hidden" id="PROJECT_NO" name="PROJECT_NO" value="${DATA_01.PROJECT_NO}">
	<div class="receive_estimator_header">
	  <p class="receive_estimator_header_typo">결제</p>
	  <div class="receive_estimator_connection_location_container">
	    <a href="/" class="receive_estimator_connection_location_typo">
	      <img class="receive_estimator_connection_location_home_button" src="/public/assets/images/connection_location_home_button_white.svg"/>
	    </a>
	    <img class="receive_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	    <div class="receive_estimator_connection_location">
	      <p class="receive_estimator_connection_location_typo">견적·의뢰내역</p>
	    </div>
	    <img class="receive_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	    <div class="receive_estimator_connection_location">
	      <p class="receive_estimator_connection_location_typo">진행내역</p>
	    </div>
	    <img class="receive_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	    <div class="receive_estimator_connection_location">
	      <p class="receive_estimator_connection_location_typo_bold">결제</p>
	    </div>
	  </div>
	</div>
	<div class="receive_estimator_body">
	  <div class="receive_estimator_main_container">
	    <div class="receive_estimator_item">
	      <p class="receive_estimator_title">의뢰서</p>
	      <div class="receive_estimator_context">
	        <div class="receive_estimator_request_wrapper"></div>
	      </div>
	    </div>
	    
	    <jsp:include page="/WEB-INF/views/dialog/request_preview_dialog.jsp" flush="true" />
	    
	    <div class="dotted_divider_container">
	      <img class="dotted_divider without_margin" src="/public/assets/images/dotted_divider.svg"/>
	      <img class="dotted_divider without_margin" src="/public/assets/images/dotted_divider.svg"/>
	    </div>
	    <div class="receive_estimator_item">
	      <p class="receive_estimator_title">총 개수</p>
	      <div class="receive_estimator_total_prosthetics">
	        <div class="receive_estimator_total_prosthetics_data_type_container">
	          <p class="receive_estimator_total_prosthetics_data_type">보철종류</p>
	          <p class="receive_estimator_total_prosthetics_data_type">개수</p>
	        </div>
	        <div class="receive_estimator_total_prosthetics_divider"></div>
	      </div>
	    </div>
	    <div class="dotted_divider_container">
	      <img class="dotted_divider without_margin" src="/public/assets/images/dotted_divider.svg"/>
	      <img class="dotted_divider without_margin" src="/public/assets/images/dotted_divider.svg"/>
	    </div>
	    <div class="cad_completed_item">
	      <p class="cad_completed_title">무통장 입금 계좌</p>
	      <div class="cad_completed_top_divider"></div>
	      <div class="cad_completed_info_item_container">
	        <div class="cad_completed_info_item">
	          <p class="cad_completed_info_item_typo">은행</p>
	          <p class="cad_completed_info_item_typo">${DATA_02.BANK_NM}</p>
	        </div>
	        <div class="cad_completed_info_item">
	          <p class="cad_completed_info_item_typo">계좌번호</p>
	          <p class="cad_completed_info_item_typo">${DATA_02.ACCOUNT_NO}</p>
	        </div>
	        <div class="cad_completed_info_item without_margin">
	          <p class="cad_completed_info_item_typo">예금주</p>
	          <p class="cad_completed_info_item_typo">${DATA_02.ACCOUNT_NM}</p>
	        </div>
	      </div>
	    </div>
	    <div class="main_container_divider without_margin"></div>
	    <div class="cad_completed_item">
	      <div class="cad_completed_price_container">
	        <div class="cad_completed_price">
	          <p class="cad_completed_price_title">견적금액</p>
	          <div class="cad_completed_price_context">
	            <p class="cad_completed_price_num c1"></p>
	            <p class="cad_completed_price_unit">원</p>
	          </div>
	        </div>
	        <div class="cad_completed_price">
	          <p class="cad_completed_price_title">최종금액</p>
	          <div class="cad_completed_price_context">
              <p class="cad_completed_price_num c2"></p>
              <p class="cad_completed_price_unit">원</p>
            </div>
	        </div>
	      </div>
	    </div>
	    <div class="dotted_divider_container">
	      <img class="dotted_divider without_margin" src="/public/assets/images/dotted_divider.svg"/>
	      <img class="dotted_divider without_margin" src="/public/assets/images/dotted_divider.svg"/>
	    </div>
	    <div class="cad_completed_info_item_container">
	      <p class="cad_completed_info_item_typo">금액변동시 사유발생원인</p>
	      <textarea class="cad_completed_info_textarea" id="CHANGE_CAUSE" name="CHANGE_CAUSE" maxlength="1300" placeholder="사전에 협의되지 않은 금액은 상세하게 사유를 작성해주세요" disabled="disabled">${DATA_02.CHANGE_CAUSE}</textarea>
	    </div>
	    <button type="button" class="cad_completed_send_button" onclick="fnSend();">
	      <p class="receive_estimator_confirm_button_typo">결제완료</p>
	    </button>
	  </div>
	</div>
</form:form>

