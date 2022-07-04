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
  
  var fileModal;
  var requestPreviewModal;
  
  function fnRequestView() {
    var groupCd = arguments[0];
    fnPreview(groupCd);
    requestPreviewModal.show();
  }
  
  function fnReceive() {
    
    var isConfirm = window.confirm('수령확인 하시겠습니까?');
    if(!isConfirm) return;
    
    $.ajax({
     url: '/' + API + '/mypage/receive_estimator/save01',
     type: 'POST',
     data: { PROJECT_NO : '${DATA.PROJECT_NO}' },
     cache: false,
     async: false,
     success: function(data) {
       if(data.cnt > 0) {
         alert('이미 수령 확인하였습니다.');
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
  
  function fnSetReqInfo() {
    var gsc = '${DATA.GCS}';
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
            html += `<button class="receive_estimator_attatchment_download_button" onclick="fnOpenFileModal('` + rtnArray[0]['FILE_CD'] + `');">`;
            html += `<p class="receive_estimator_attatchment_download_button_typo">첨부파일 다운로드</p>`;
            html += `</button>`;
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
    
    fileModal = new bootstrap.Modal(document.getElementById('fileModal'));
    var fileModalEl = document.getElementById('fileModal');
    fileModalEl.addEventListener('hidden.bs.modal', function(e) {
      $('.file_modal_item').each(function(index) {
        $('.file_modal_name').eq(index).text('');
        $('.file_modal_download').eq(index).addClass('hidden');
        $('.file_modal_download').eq(index).off('click');
      });
    });
    
    requestPreviewModal = new bootstrap.Modal(document.getElementById('requestModal'));
    
    fnSetReqInfo();
    
  });
  
</script>

<div class="receive_estimator_header">
  <p class="receive_estimator_header_typo">의뢰서 수령</p>
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
      <p class="receive_estimator_connection_location_typo_bold">의뢰서 수령</p>
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
    <button type="button" class="receive_estimator_confirm_button" onclick="fnReceive();">
      <p class="receive_estimator_confirm_button_typo">수령확인</p>
    </button>
  </div>
</div>

<!-- 파일 첨부 modal -->
<div class="modal fade" id="fileModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="width: fit-content;">
      <div class="dialog_tribute_request_container">
        <div class="dialog_tribute_request_header">
          <p class="dialog_tribute_request_header_typo">파일 첨부</p>
          <a href="javascript:void(0);" class="dialog_tribute_request_header_close_button_wrapper" data-bs-dismiss="modal">
            <img class="dialog_tribute_request_header_close_button" src="/public/assets/images/tribute_request_dialog_close_button.svg"/>
          </a>
        </div>
        <div class="dialog_tribute_request_body">
          <div class="dialog_tribute_request_table">
            <div class="dialog_tribute_request_table_data_type_container">
              <div class="dialog_tribute_request_table_data_type_order">
                  <p class="dialog_tribute_request_table_data_type_typo">NO.</p>
              </div>
              <div class="dialog_tribute_request_table_data_type_document">
                  <p class="dialog_tribute_request_table_data_type_typo">문서유형</p>
              </div>
              <div class="dialog_tribute_request_table_data_type_necessary">
                  <p class="dialog_tribute_request_table_data_type_typo">필수</p>
              </div>
              <div class="dialog_tribute_request_table_data_type_file_name">
                  <p class="dialog_tribute_request_table_data_type_typo">파일명</p>
              </div>
              <div class="dialog_tribute_request_table_data_type_download">
                  <p class="dialog_tribute_request_table_data_type_typo">다운로드</p>
              </div>
              <div class="dialog_tribute_request_table_data_type_note">
                  <p class="dialog_tribute_request_table_data_type_typo">비고</p>
              </div>
            </div>
            <div class="dialog_tribute_request_table_data_container file_modal_item">
              <div class="dialog_tribute_request_table_data_order">
                <p class="dialog_tribute_request_table_data_typo">1</p>
              </div>
              <div class="dialog_tribute_request_table_data_document">
                <p class="dialog_tribute_request_table_data_typo">스캔파일</p>
              </div>
              <div class="dialog_tribute_request_table_data_necessary">
                <p class="dialog_tribute_request_table_data_typo">Y</p>
              </div>
              <div class="dialog_tribute_request_table_data_file_name">
                <p class="dialog_tribute_request_table_data_typo file_modal_name"></p>
              </div>
              <div class="dialog_tribute_request_table_data_download">
                <div class="hidden file_modal_download" style="display: flex; cursor: pointer;">
                  <p class="dialog_tribute_request_table_data_typo">다운로드</p>
                  <img class="dialog_tribute_request_table_data_download_img" src="/public/assets/images/tribute_request_table_data_download_img.svg"/>
                </div> 
              </div>
              <div class="dialog_tribute_request_table_data_note">
                <p class="dialog_tribute_request_table_data_typo"></p>
              </div>
            </div>
            <div class="dialog_tribute_request_table_data_container file_modal_item">
              <div class="dialog_tribute_request_table_data_order">
                <p class="dialog_tribute_request_table_data_typo">2</p>
              </div>
              <div class="dialog_tribute_request_table_data_document">
                <p class="dialog_tribute_request_table_data_typo">기타</p>
              </div>
              <div class="dialog_tribute_request_table_data_necessary">
                <p class="dialog_tribute_request_table_data_typo">N</p>
              </div>
              <div class="dialog_tribute_request_table_data_file_name">
                <p class="dialog_tribute_request_table_data_typo file_modal_name"></p>
              </div>
              <div class="dialog_tribute_request_table_data_download">
                <div class="hidden file_modal_download" style="display: flex; cursor: pointer;">
                  <p class="dialog_tribute_request_table_data_typo">다운로드</p>
                  <img class="dialog_tribute_request_table_data_download_img" src="/public/assets/images/tribute_request_table_data_download_img.svg"/>
                </div> 
              </div>
              <div class="dialog_tribute_request_table_data_note">
                <p class="dialog_tribute_request_table_data_typo"></p>
              </div>
            </div>
            <div class="dialog_tribute_request_table_data_container file_modal_item">
              <div class="dialog_tribute_request_table_data_order">
                <p class="dialog_tribute_request_table_data_typo">3</p>
              </div>
              <div class="dialog_tribute_request_table_data_document">
                <p class="dialog_tribute_request_table_data_typo">기타</p>
              </div>
              <div class="dialog_tribute_request_table_data_necessary">
                <p class="dialog_tribute_request_table_data_typo">N</p>
              </div>
              <div class="dialog_tribute_request_table_data_file_name">
                <p class="dialog_tribute_request_table_data_typo file_modal_name"></p>
              </div>
              <div class="dialog_tribute_request_table_data_download">
                <div class="hidden file_modal_download" style="display: flex; cursor: pointer;">
                  <p class="dialog_tribute_request_table_data_typo">다운로드</p>
                  <img class="dialog_tribute_request_table_data_download_img" src="/public/assets/images/tribute_request_table_data_download_img.svg"/>
                </div> 
              </div>
              <div class="dialog_tribute_request_table_data_note">
                <p class="dialog_tribute_request_table_data_typo"></p>
              </div>
            </div>
            <div class="dialog_tribute_request_table_data_container file_modal_item">
              <div class="dialog_tribute_request_table_data_order">
                <p class="dialog_tribute_request_table_data_typo">4</p>
              </div>
              <div class="dialog_tribute_request_table_data_document">
                <p class="dialog_tribute_request_table_data_typo">기타</p>
              </div>
              <div class="dialog_tribute_request_table_data_necessary">
                <p class="dialog_tribute_request_table_data_typo">N</p>
              </div>
              <div class="dialog_tribute_request_table_data_file_name">
                <p class="dialog_tribute_request_table_data_typo file_modal_name"></p>
              </div>
              <div class="dialog_tribute_request_table_data_download">
                <div class="hidden file_modal_download" style="display: flex; cursor: pointer;">
                  <p class="dialog_tribute_request_table_data_typo">다운로드</p>
                  <img class="dialog_tribute_request_table_data_download_img" src="/public/assets/images/tribute_request_table_data_download_img.svg"/>
                </div> 
              </div>
              <div class="dialog_tribute_request_table_data_note">
                <p class="dialog_tribute_request_table_data_typo"></p>
              </div>
            </div>
            <div class="dialog_tribute_request_table_data_container file_modal_item">
              <div class="dialog_tribute_request_table_data_order">
                <p class="dialog_tribute_request_table_data_typo">5</p>
              </div>
              <div class="dialog_tribute_request_table_data_document">
                <p class="dialog_tribute_request_table_data_typo">기타</p>
              </div>
              <div class="dialog_tribute_request_table_data_necessary">
                <p class="dialog_tribute_request_table_data_typo">N</p>
              </div>
              <div class="dialog_tribute_request_table_data_file_name">
                <p class="dialog_tribute_request_table_data_typo file_modal_name"></p>
              </div>
              <div class="dialog_tribute_request_table_data_download">
                <div class="hidden file_modal_download" style="display: flex; cursor: pointer;">
                  <p class="dialog_tribute_request_table_data_typo">다운로드</p>
                  <img class="dialog_tribute_request_table_data_download_img" src="/public/assets/images/tribute_request_table_data_download_img.svg"/>
                </div> 
              </div>
              <div class="dialog_tribute_request_table_data_note">
                <p class="dialog_tribute_request_table_data_typo"></p>
              </div>
            </div>
          </div>
          <div class="dialog_tribute_request_button_wrapper">
            <button class="dialog_tribute_request_button" type="button" data-bs-dismiss="modal">
              <p class="dialog_tribute_request_button_typo">닫기</p>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 파일 첨부 modal end -->
<form:form id="fileDownloadForm" name="fileDownloadForm" action="/${api}/file/download" method="POST">
  <input type="hidden" id="FILE_CD" name="FILE_CD" value="">
  <input type="hidden" id="FILE_NO" name="FILE_NO" value="">
</form:form>
