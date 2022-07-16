<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if>
<%
  String wrNo = request.getParameter("WR_NO");
  String projectNo = request.getParameter("PROJECT_NO");
  String projectNm = request.getParameter("PROJECT_NM");
%>

<script>
  
  var reviewFileArray = new Array();
  var totalScore = 0;
  
  function fnScore() {
    var score = arguments[0];
    totalScore = score;
    
    var score_02 = $('#score_02');
    var score_04 = $('#score_04');
    var score_06 = $('#score_06');
    var score_08 = $('#score_08');
    var score_10 = $('#score_10');
    
    score_02.removeClass('active');
    score_04.removeClass('active');
    score_06.removeClass('active');
    score_08.removeClass('active');
    score_10.removeClass('active');
    
    if(score === 2) {
      score_02.addClass('active');
    } else if(score === 4) {
      score_02.addClass('active');
      score_04.addClass('active');
    } else if(score === 6) {
      score_02.addClass('active');
      score_04.addClass('active');
      score_06.addClass('active');
    } else if(score === 8) {
      score_02.addClass('active');
      score_04.addClass('active');
      score_06.addClass('active');
      score_08.addClass('active');
    } else if(score === 10) {
      score_02.addClass('active');
      score_04.addClass('active');
      score_06.addClass('active');
      score_08.addClass('active');
      score_10.addClass('active');
    }
    
    $('.equipment_estimator_my_page_progress_writing_review_star_numb').html(totalScore);
  }
  
  function fnPreviewImage() {
    const defaultImgSrc = '/public/assets/images/profile_image.svg';
    const file = event.target.files[0];
    if(isNotEmpty(file)) {
      const type = file.type;
      const mimeTypeList = [ 'image/png', 'image/jpeg', 'image/gif', 'image/bmp' ];
      if(mimeTypeList.includes(type)) {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = (event) => {
          const imgSrc = event.target.result;
          $('#reviewImg').prop('src', imgSrc);
        }
        var obj = new Object();
        obj.FILE = file;
        reviewFileArray = new Array();
        reviewFileArray.push(obj);
        
      } else {
        alert('이미지 파일이 아닙니다.');
        reviewFileArray = new Array();
        $('#reviewImg').prop('src', defaultImgSrc);
      }
    }
  }
  
  function fnSaveReview() {
   
   var reviewContent = $('#REVIEW_CONTENT').val();
   if(isEmpty(reviewContent)) {
     alert('후기를 입력하세요.');
     $('#REVIEW_CONTENT').focus();
     return;
   }
   
   var isConfirm = window.confirm('저장 하시겠습니까?');
   if(!isConfirm) return;
   
   var wrNo = '<%= wrNo %>';
   var projectNo = '<%= projectNo %>';
   
   $('#WR_NO').val(wrNo);
   $('#PROJECT_NO').val(projectNo);
   $('#SCORE').val(totalScore);
   
   var formData = new FormData(document.getElementById('reviewSaveForm'));
   for(var key of formData.keys()) {
     formData.set(key, JSON.stringify(formData.get(key)));
   }
   
   for(var i=0; i<reviewFileArray.length; i++) {
     formData.append("files", reviewFileArray[i].FILE);
   }
   
   $.ajax({
     url: '/' + API + '/review/save01',
     type: 'POST',
     data: formData,
     cache: false,
     async: false,
     contentType: false,
     processData: false,
     success: function(data) {
       location.href = '/' + API + '/mypage/receive_file?PROJECT_NO=' + projectNo;
     }, complete: function() {
     }, error: function() {
     }
   });
  }
  
  $(document).ready(function() {
    
    totalScore = 10;
    
    var projectNm = '<%= projectNm %>';
    $('.equipment_estimator_my_page_progress_writing_review_category').html(projectNm);
    
  });
  
</script>

<form:form id="reviewSaveForm" name="reviewSaveForm">
  
  <input type="hidden" id="WR_NO" name="WR_NO">
  <input type="hidden" id="PROJECT_NO" name="PROJECT_NO">
  <input type="hidden" id="SCORE" name="SCORE">
  
	<div class="modal fade" id="reviewWritingModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
	  <div class="modal-dialog modal-dialog-centered">
	    <div class="modal-content" style="width: fit-content;">
	      <div class="cad_container">
	        <div class="dialog_header">
	          <p class="dialog_header_typo">후기 작성</p>
	          <a href="javascript:void(0);" data-bs-dismiss="modal" aria-label="Close">
	            <img class="dialog_close_button" src="/public/assets/images/dialog_close_button.svg"/>
	          </a>
	        </div>
	        <div class="equipment_estimator_my_page_progress_writing_review">
	          <div class="equipment_estimator_my_page_progress_writing_review_main_container">
	            <p class="equipment_estimator_my_page_progress_writing_review_category"></p>
	            <div class="equipment_estimator_my_page_progress_writing_review_satisfaction">
	              <p class="equipment_estimator_my_page_progress_writing_review_satisfaction_typo">만족도</p>
	              <div class="equipment_estimator_my_page_progress_writing_review_star_container">
	                <button id="score_02" type="button" class="star active" onclick="fnScore(2);">
	                  <span class="sr-only">2점</span>
	                </button>
	                <button id="score_04" type="button" class="star active" onclick="fnScore(4);">
	                  <span class="sr-only">4점</span>
	                </button>
	                <button id="score_06" type="button" class="star active" onclick="fnScore(6);">
	                  <span class="sr-only">6점</span>
	                </button>
	                <button id="score_08" type="button" class="star active" onclick="fnScore(8);">
	                  <span class="sr-only">8점</span>
	                </button>
	                <button id="score_10" type="button" class="star active" onclick="fnScore(10);">
	                  <span class="sr-only">10점</span>
	                </button>
	              </div>
	              <p class="equipment_estimator_my_page_progress_writing_review_star_numb">10</p>
	              <p class="equipment_estimator_my_page_progress_writing_review_star_unit">/10</p>
	            </div>
	            <textarea id="REVIEW_CONTENT" name="REVIEW_CONTENT" class="equipment_estimator_my_page_progress_writing_review_context" rows="10" maxlength="1300" placeholder="후기를 입력해주세요."></textarea>
	          </div>
	      </div>
	      <div class="qna_pic_attatchment_pic_upload_container">
	        <div class="qna_pic_attatchment_main_pic_upload_wrapper">
	          <img id="reviewImg" class="qna_pic_attatchment_main_pic_upload" src="/public/assets/images/profile_image.svg">
	        </div>
	        <div style="display: flex;">
	          <button class="qna_pic_attachment_pic_upload_button">
	            <p class="qna_pic_attachment_pic_upload_button_typo">이미지 업로드</p>
	          </button>
	          <input type="file" id="IMG_FILE" name="IMG_FILE" onchange="fnPreviewImage();">
	        </div>
	      </div>
	        <div class="qna_pic_attatchment_button_container">
	          <a href="javascript:void(0);" class="qna_pic_attatchment_button_blue" onclick="fnSaveReview();">
	            <p class="qna_pic_attatchment_button_blue_typo">저장</p>
	          </a>
	          <a href="javascript:reviewWritingModal.hide();" class="qna_pic_attatchment_button_white">
	            <p class="qna_pic_attatchment_button_white_typo">취소</p>
	          </a>
	        </div>
	      </div>
	    </div>
	  </div>
	</div>
</form:form>
