<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%
String reviewbool = "";
if(request.getParameter("reviewbool") != null){
	reviewbool = request.getParameter("reviewbool");
}

%>
<c:if test="${empty sessionInfo.user}">
  <script>
  alert(getI8nMsg("alert.plzlogin"));//'로그인 후 이용가능 합니다.'
   location.href = '/api/login/view';
</script>
</c:if>
<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>
<link type="text/css" rel="stylesheet" href="/public/assets/css/modal.css"/>

<script>
  
  var requestPreviewModal;
  var reviewWritingModal;
  
  function fnRequestView() {
    var groupCd = arguments[0];
    fnPreview(groupCd);
    requestPreviewModal.show();
  }
  
  function fnReceive() {
    
    var isConfirm = window.confirm(getI8nMsg("alert.confirm.confirmFile"));//파일 수령확인 하시겠습니까?
    if(!isConfirm) return;
    
    $.ajax({
     url: '/' + API + '/mypage/receive_file/save03',
     type: 'POST',
     data: { WR_NO : '${DATA.WR_NO}' },
     cache: false,
     async: false,
     success: function(data) {
       if(data.cnt === 0) {
    	   alert(getI8nMsg("alert.updateFail"));//업데이트 실패하였습니다.
       }
       location.href = '/' + API + '/mypage/equipment_estimator_my_page_progress';
     }, complete: function() {
     }, error: function() {
     }
   });
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
            if(isNotEmpty(data)) {
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
                html += `<button class="receive_estimator_attatchment_download_button" onclick="fnFileDownload('\${rtnArray[0]['WR_FILE_CD']}', '1');">`;
                html += `<p class="receive_estimator_attatchment_download_button_typo">첨부파일 다운로드</p>`;
                html += `</button>`;
              }
              html += `</div>`;
              $('.receive_estimator_request_wrapper').append(html);
              fnSetNext(data);
            }
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
    reviewWritingModal = new bootstrap.Modal(document.getElementById('reviewWritingModal'));
    
    fnSetReqInfo();
  });
  
</script>

<div class="receive_estimator_header">
  <p class="receive_estimator_header_typo">파일 수령</p>
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
      <p class="receive_estimator_connection_location_typo_bold">파일 수령</p>
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
    
    <jsp:include page="/WEB-INF/views/dialog/review_writing_dialog.jsp" flush="true">
      <jsp:param name="WR_NO" value="${DATA.WR_NO}" />
      <jsp:param name="PROJECT_NO" value="${DATA.PROJECT_NO}" />
      <jsp:param name="PROJECT_NM" value="${DATA.PROJECT_NM}" />
    </jsp:include>
    
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
    <div class="receive_file_button_container">
      <c:if test="${DATA.FILE_RECEIVE_YN eq 'Y'}">
	      <c:if test="${DATA.REVIEW_CNT eq 0}">
		      <a href="javascript:reviewWritingModal.show();" id="receive_btn" class="receive_file_button_white">
		        <p class="receive_file_button_white_typo">후기쓰기</p>
		      </a>
	      </c:if>
	     <c:if test="${sessionInfo.user.USER_TYPE_CD eq 2}">
	      <a href="javascript:alert(getI8nMsg('alert.preparingServ'));" class="receive_file_button_white">
	        <p class="receive_file_button_white_typo">재제작 요청</p>
	      </a>
        </c:if>
      </c:if>
      <c:if test="${DATA.FILE_RECEIVE_YN eq 'N'}">
	      <a href="javascript:fnReceive();" class="receive_file_button_blue">
	        <p class="receive_file_button_blue_typo">파일 수령확인</p>
	      </a>
      </c:if>
      <%if(reviewbool.equals("1")){ %>
            <c:if test="${DATA.FILE_RECEIVE_YN eq 'Y'}">
            <c:choose>
            	<c:when test="${DATA.REVIEW_CNT eq 0}">
            	<script>
		      	$(document).ready(function(){
			      	$("#receive_btn").trigger("click");	
			      	console.log("gg");
			      	reviewWritingModal.show()
		      	});
	      		</script>
            	</c:when>
            	<c:otherwise>
            	<script>
            		alert(getI8nMsg("alert.wroteReview")); //리뷰를 작성하셨습니다.
            	</script>
            	</c:otherwise>
            </c:choose>
	      <c:if test="${DATA.REVIEW_CNT eq 0}">
	      
	      </c:if>
      	</c:if>
	<% } %>
    </div>
  </div>
</div>

<!-- 파일 첨부 modal end -->
<form:form id="fileDownloadForm" name="fileDownloadForm" action="/${api}/file/download" method="POST">
  <input type="hidden" id="FILE_CD" name="FILE_CD" value="">
  <input type="hidden" id="FILE_NO" name="FILE_NO" value="">
</form:form>
