<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if>
<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>

<script>

	var eqEstimatorArr = new Array();
	  
	function fnGetEqEstimators() {
	  var eqNo = arguments[0];
	  
	  $.ajax({
	    url: '/' + API + '/equipment/getMyEstimator',
	    type: 'GET',
	    data: { EQ_NO : eqNo },
	    cache: false,
	    async: false,
	    success: function(data) {
		 	 	currEstimator = data.estimator;
		 	 	if(currEstimator.MATCHING_YN == 'Y') {
	 	 			$('#clientInfoWrapper').show();
	 	 			$('#clientNm').text(currEstimator.CLIENT_NM);
	 	 			$('#clientPhone').text(currEstimator.CLIENT_PHONE);
		 	 	} else {
	 	 			$('#clientInfoWrapper').hide();
		 	 	}
		 	 	fnSetEqEstimator();
	 	 		eqEstimatorViewModal.show();
	    }, 
	    complete: function() {}, 
	    error: function() {}
		});
	}
	  
	function fnSetEqEstimatorPageInfo() {
	 	var pageIndex = arguments[0];
	 
		var btnHtml = '';
		btnHtml += '<button class="pagination_page_button_prev ' + ((pageIndex > 0) ? '' : 'invisible') + '" type="button"';
		if(pageIndex > 0) {
			btnHtml += 'onclick="fnSetEqEstimator(' + (pageIndex - 1) + ');">';
		} else {
			btnHtml += '>';
		}
		btnHtml += '	<img src="/public/assets/images/dialog_page_next_button_arrow.svg" class="pagination_page_before_button_arrow"/>';
		btnHtml += '</button>';
		btnHtml += '<p class="pagination_current_page">' + (pageIndex + 1) + '&nbsp;</p>';
		btnHtml += '<p class="pagination_total_page">/ ' + eqEstimatorArr.length + '</p>';
		btnHtml += '<button class="pagination_page_button ' + ((pageIndex == eqEstimatorArr.length - 1) ? 'invisible' : '') + '" type="button"';
		if(pageIndex == eqEstimatorArr.length - 1) {
			btnHtml += '>';
		} else {
			btnHtml += 'onclick="fnSetEqEstimator(' + (pageIndex + 1) + ');">';
		}
		btnHtml += '	<img src="/public/assets/images/dialog_page_next_button_arrow.svg" class="pagination_page_next_button_arrow"/>';
		btnHtml += '</button>';
	
		$('.equipment_estimator_pagination').html(btnHtml);
	}
	  
	function fnSetEqEstimator() {
		//var index = arguments[0];
		//currEstimator = eqEstimatorArr[index];
		
		$('#viewEqDeliveryPosDateTypo').text(currEstimator['DELIVERY_POS_DATE']);
		
		var suppDtlHtml = '';
		var totalPrice = 0;
		currEstimator.dtlInfo.map((m, i) => {
			suppDtlHtml += '<div class="dialog_item_context">';
	    suppDtlHtml += '  <p class="dialog_item_context_typo_prosthetics_type">' + m.ARTICLE_NM + '</p>';
	    suppDtlHtml += '  <p class="dialog_item_context_typo_price_num">' + m.UNIT_PRICE + '</p>';
	    suppDtlHtml += '  <p class="operator">X</p>';
	    suppDtlHtml += '  <p class="dialog_item_context_typo_price_num">' + m.AMOUNT + '</p>';
	    suppDtlHtml += '  <p class="operator">=</p>';
	    suppDtlHtml += '  <div class="dialog_item_context_typo_container price_area">';
	    suppDtlHtml += '    <p class="dialog_item_context_typo price_num">' + m.SUM_AMOUNT + '</p>';
	    suppDtlHtml += '    <p class="dialog_item_context_typo">원</p>';
	    suppDtlHtml += '  </div>';
	    suppDtlHtml += '</div>';
		});
		$('.view_dtl_container').html(suppDtlHtml);
		
		$('#viewAsInfoTypo').text(currEstimator.AS_INFO);
		$('#viewDtlContentTypo').text(currEstimator.DTL_CONTENT);
		
		var imgHtml = '';
		var imgWrapper = document.querySelector('.dialog_item_context_pic_upload_wrapper');
		imgWrapper.innerHTML = '';
		
		currEstimator.fileList.map((m, i) => {
			m.FILE_DIRECTORY = m.FILE_DIRECTORY.replace(/\\/g, '\/');
			var imgDiv = document.createElement('div');
			imgDiv.className = 'dialog_item_context_pic_upload';
			imgDiv.style.backgroundImage = "url('/upload/" + m.FILE_DIRECTORY + "')";
			imgWrapper.appendChild(imgDiv);
		});
		
		//fnSetEqEstimatorPageInfo(index);
	}
	
	function fnDeleteEqEstimator() {
		const eqNo = currEstimator['EQ_NO'];
		if(confirm('삭제하시겠습니까?')) {
		  $.ajax({
			  url: '/' + API + '/equipment/deleteEstimator',
			  type: 'POST',
			  data: { MATCHING_NO : currEstimator['MATCHING_NO'] },
			  cache: false,
			  async: false,
			  success: function(data) {
		    	if(data.result == 'Y') {
		    		alert('삭제되었습니다.');
		    		//fnGetEqEstimators(eqNo);
		    		location.reload();
		    	}
		    }, complete: function() {
		      
		    }, error: function() {
		      
		    }
		  });
		}
	}
	
	function fnEqMatching() {
		const eqNo = currEstimator['EQ_NO'];
	  const matchingNo = currEstimator['MATCHING_NO'];
	  $.ajax({
		  url: '/' + API + '/equipment/matching',
		  type: 'POST',
		  data: { EQ_NO : eqNo, MATCHING_NO : matchingNo },
		  cache: false,
		  async: false,
		  success: function(data) {
	    	if(data.result == 'Y') {
	    		alert('매칭되었습니다.');
	    		matchingModal.hide();
	    		fnGetEqEstimators(eqNo);
	    	} else if(data.result == 'N') {
	    		if(isNotEmpty(data.msg)) {
	    			alert(data.msg);
		    		eqEstimatorViewModal.hide();
	    		}
	    	}
	    }, 
	    complete: function() {}, 
	    error: function() {}
	  });
	}
  
  $(function() {

  });
  
</script>
                    	
<div class="modal fade" id="eqEstimatorViewModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content" style="width: fit-content;">
			<div class="dialog_container">
				<div class="dialog_header">
				    <p class="dialog_header_typo">
				        장비 견적서 보기
				    </p>
				    <a href="javascript:void(0)" class="dialog_close_button_wrapper" data-bs-dismiss="modal" aria-label="Close">
				        <img class="dialog_close_button" src="/public/assets/images/dialog_close_button.svg"/>
				    </a>
				</div>
				<div class="dialog_item">
				    <div class="dialog_item_title">
				        <p class="dialog_item_title_typo">
				            납품가능시간
				        </p>
				    </div>
				    <div class="dialog_item_context_container">
				        <p id="viewEqDeliveryPosDateTypo" class="dialog_item_context_typo"></p>
				    </div>
				</div>
				<div class="dialog_item">
				    <div class="dialog_item_title">
				        <p class="dialog_item_title_typo">
				            금액
				        </p>
				    </div>
				    <div class="dialog_item_context_container view_dtl_container">
				    </div>
				</div>
				<div class="dialog_item">
				    <div class="dialog_item_title">
				        <p class="dialog_item_title_typo">
				            A/S 정보
				        </p>
				    </div>
				    <div class="dialog_item_context_container">
				        <p id="viewAsInfoTypo" class="dialog_item_context_typo">
				            훈장등의 영전은 이를 받은 자에게만 효력이 있고, 어떠한 특권도 이에 따르지 아니한다.
				        </p>
				    </div>
				</div>
				<div class="dialog_item">
					<div class="dialog_item_title">
					    <p class="dialog_item_title_typo">
					        상세설명
					    </p>
					</div>
					<div class="dialog_item_context_container">
					    <p id="viewDtlContentTypo" class="dialog_item_context_typo">
					        국무총리는 국회의 동의를 얻어 대통령이 임명한다. 헌법재판소는 법관의 자
									격을 가진 9인의 재판관으로 구성하며, 재판관은 대통령이 임명한다. 국회는
									국무총리 또는 국무위원의 해임을 대통령에게 건의할 수 있다.
					    </p>
					</div>
				</div>
				<div class="dialog_item">
				    <div class="dialog_item_title">
				        <p class="dialog_item_title_typo">
				            사진 업로드
				        </p>
				    </div>
				    <div class="dialog_item_context_container">
				        <!-- hidden, invisible로 조절 -->
				        <div class="dialog_item_context_pic_upload_wrapper">
									<!-- <div class="dialog_item_context_pic_upload"></div> -->
				        </div>
				    </div>
				</div>
				<div id="clientInfoWrapper" class="dialog_item" style="display: none;">
					<div class="dialog_item_title">
					    <p class="dialog_item_title_typo">
					        의뢰자 정보
					    </p>
					</div>
					<div class="dialog_item_context_container">
					    <div class="dialog_item_context_typo_container info">
					        <p class="dialog_item_context_typo info_title">
					            이름
					        </p>
					        <p id="clientNm" class="dialog_item_context_typo info_context">
					            김동동
					        </p>
					    </div>
					    <div class="dialog_item_context_typo_container info">
					        <p class="dialog_item_context_typo info_title">
					            전화번호
					        </p>
					        <p id="clientPhone" class="dialog_item_context_typo info_context">
					            010-1234-5678
					        </p>
					    </div>
					</div>
				</div>
				<div class="bottom_info">
				    <p class="bottom_info_typo">
				        ※ 견적서 제출은 무료이며, 의뢰자 정보는 매칭 완료 후 열람 가능합니다.
				    </p>
				</div>
			</div>
		</div>
	</div>
</div>
