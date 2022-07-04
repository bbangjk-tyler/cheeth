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
  
  var fileArray = new Array();
  var requestPreviewModal;
  
  function fnRequestView() {
    var groupCd = arguments[0];
    fnPreview(groupCd);
    requestPreviewModal.show();
  }
  
  function fnSend() {
    
    var lastAmount = $('#LAST_AMOUNT').val();
    var isNum = /^[0-9]+$/;
    if(!isNum.test(lastAmount)) {
      alert('숫자만 입력 가능합니다.');
      $('#LAST_AMOUNT').focus();
      return;
    }
    
    var changeCause = $('#CHANGE_CAUSE').val();
    if(lastAmount !== '${DATA_02.ESTIMATE_AMOUNT}' && isEmpty(changeCause)) {
      alert('금액변동시 사유발생원인을 입력하세요.');
      $('#CHANGE_CAUSE').focus();
      return;
    }
    
    var cnt1 = $('.receive_estimator_request_container').length;
    var cnt2 = fileArray.length;
    
    if(cnt1 !== cnt2) {
      alert('의뢰서 첨부파일이 누락되었습니다.');
      return;
    }
    
    var isConfirm = window.confirm('결제를 요청하시겠습니까?');
    if(!isConfirm) return;
    
    var formData = new FormData(document.getElementById('saveForm'));
    for(var key of formData.keys()) {
      formData.set(key, JSON.stringify(formData.get(key)));
    }
    
    for(var i=0; i<fileArray.length; i++) {
      formData.append("files", fileArray[i].FILE);
    }
    
    var fileList = new Array(); 
    fileArray.map(m => {
      var obj = new Object();
      obj.RQST_NO = m.RQST_NO
      fileList.push(obj);
    });
    formData.append("fileList", JSON.stringify(fileList));
    
    $.ajax({
     url: '/' + API + '/mypage/cad_completed/save02',
     type: 'POST',
     data: formData,
     cache: false,
     async: false,
     contentType: false,
     processData: false,
     success: function(data) {
       if(data.cnt === 0) {
         alert('업데이트 실패하였습니다.');
       }
       location.href = '/' + API + '/mypage/equipment_estimator_my_page_progress';
     }, complete: function() {
     }, error: function() {
     }
   });
  }
  
  function fnOpenFileModal() {
    const fileCd = arguments[0];
    $.ajax({
      url: '/' + API + '/common/getFiles',
      type: 'GET',
      data: { FILE_CD : fileCd },
      cache: false,
      async: false,
      success: function(data) {
        if(isNotEmpty(data)) {
          data.map((m, i) => {
            var elIndex = (+m.FILE_NO - 1);
            $('.file_modal_name').eq(elIndex).text(m.FILE_ORIGIN_NM);
            $('.file_modal_download').eq(elIndex).removeClass('hidden');
            $('.file_modal_download').eq(elIndex).on('click', function() {
              fnFileDownload(m.FILE_CD, m.FILE_NO);
            });
          });
        }
      }, 
      complete: function() {}, 
      error: function() {}
    });
    
    fileModal.show();
  }
  
  function fnFileChange() {
    var target = arguments[0];
    var rqstNo = arguments[1];
    if(isNotEmpty(target.files[0])) {
      var obj = new Object();
      obj.IDX = fnGetMaxIdx(fileArray);
      obj.RQST_NO = rqstNo;
      obj.FILE = target.files[0];
      var index = fileArray.findIndex(f => f.RQST_NO === rqstNo);
      if(index > -1) fileArray.splice(index, 1); // 중복파일 삭제
      fileArray.push(obj);
    }
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
            html += `<input type="file" onchange="fnFileChange(this, ` + rtnArray[0]['RQST_NO'] + `);" title="의뢰서 첨부">`;
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
    
    $('.cad_completed_price_num').html(addComma('${DATA_02.ESTIMATE_AMOUNT}')); // 견적금액
    
  });
  
</script>

<form:form id="saveForm" name="saveForm">
  <input type="hidden" id="WR_NO" name="WR_NO" value="${DATA_02.WR_NO}">
  <input type="hidden" id="PROJECT_NO" name="PROJECT_NO" value="${DATA_01.PROJECT_NO}">
	<div class="receive_estimator_header">
	  <p class="receive_estimator_header_typo">CAD 완성 및 결제 요청</p>
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
	      <p class="receive_estimator_connection_location_typo_bold">CAD 완성 및 결제 요청</p>
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
	            <p class="cad_completed_price_num"></p>
	            <p class="cad_completed_price_unit">원</p>
	          </div>
	        </div>
	        <div class="cad_completed_price">
	          <p class="cad_completed_price_title">최종금액</p>
	          <div class="cad_completed_price_context">
	            <input type="text" id="LAST_AMOUNT" name="LAST_AMOUNT" maxlength="10" value="${DATA_02.LAST_AMOUNT}">
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
	      <textarea class="cad_completed_info_textarea" id="CHANGE_CAUSE" name="CHANGE_CAUSE" maxlength="1300" placeholder="사전에 협의되지 않은 금액은 상세하게 사유를 작성해주세요">${DATA_02.CHANGE_CAUSE}</textarea>
	    </div>
	    <button type="button" class="cad_completed_send_button" onclick="fnSend();">
	      <p class="receive_estimator_confirm_button_typo">결제요청</p>
	    </button>
	  </div>
	</div>
</form:form>
