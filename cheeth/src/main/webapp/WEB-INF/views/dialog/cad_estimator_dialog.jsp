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

  var reqArr = new Array();
  var suppInfo = new Array();
  
  const defaultImgSrc = '/public/assets/images/profile_image.svg';
  
  function fnSetReqInfo() {
		
		var projectNo = arguments[0];
		var rtnArray = new Array();
		
		$.ajax({
			url: '/' + API + '/project/getReqInfo',
			type: 'GET',
			data: { PROJECT_NO : projectNo },
			cache: false,
			async: false,
			success: function(data) {
				reqArr = data;
				
				var cntArr = new Array();
				var rqstNoArr = new Array();
				var suppCdArr = new Array();
				var suppNmArr = new Array();

			  reqArr.map((req, index) => {
					
					cntArr = req['CNT_STR'].split(',');
					rqstNoArr = req['RQST_NO_STR'].split(',');
					suppCdArr = req['SUPP_CD_STR'].split(',');
					suppNmArr = req['SUPP_NM_STR'].split(',');
					
				});
			},
			complete: function() {},
			error: function() {}
		});
		
		$.ajax({
		  url: '/' + API + '/tribute/getSuppInfo',
		  type: 'POST',
		  data: JSON.stringify({ GROUP_CD_LIST : Array.from(new Set(reqArr.map(m => m.GROUP_CD))) }),
		  contentType: 'application/json; charset=utf-8',
		  cache: false,
		  async: false,
		  success: function(data) {
				if(isNotEmpty(data)) {
					var suppList = new Array();
					var suppHtml = '';
					data.map(m => {
						var obj = { 'CNT' : m.CNT,
												'SUPP_NM_STR' : m.SUPP_NM_STR,
												'SUPP_CD_LIST' : m.SUPP_CD_STR.split('|'),
												'GROUP_CD_LIST' : m.GROUP_CD_STR.split('|'),
												'RQST_NO_LIST' : m.RQST_NO_STR.split('|') };
						suppList.push(obj);
					});
					suppInfo = [...suppList];
				}
		  }, 
		  complete: function() {}, 
		  error: function() {}
		});
		
  }
  
  function fnSetReqContent() {
	  
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
				return nm + ' ' + cntArr[i] + '개';
			}).join(', ');
			
			var PANT_NM_str = req.PANT_NM.substring(0, 1);
			var nmlngth = req.PANT_NM.length
			for(var i = 0; i < nmlngth - 1; i++){
				PANT_NM += "*";
			}
			
			reqHtml += '<div class="cad_estimator_dialog_request">';
			reqHtml += '  <p class="cad_estimator_dialog_request_title">의뢰서' + (index + 1) + '</p>';
			reqHtml += '	 <p class="cad_estimator_dialog_request_name">' + PANT_NM_str + '</p>';
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
  }
  
  var cadEstimatorArr = new Array();
  
  function fnGetCadEstimators() {
	  var projectNo = arguments[0];
	  var type = arguments[1];
	  
	  fnSetReqInfo(projectNo);
	  fnSetReqContent();
	  
	  $.ajax({
		  url: '/' + API + '/project/getMyEstimator',
		  type: 'GET',
		  data: { PROJECT_NO : projectNo, TYPE: type },
		  cache: false,
		  async: false,
		  success: function(data) {
				currEstimator = data.estimator;
				fnSetCadEstimator();
				cadEstimatorViewModal.show();
		  }, 
		  complete: function() {}, 
		  error: function() {}
		});
  }
  
  function fnSetCadEstimatorPageInfo() {
	  var pageIndex = arguments[0];
	  
	  var btnHtml = '';
		btnHtml += '<button class="pagination_page_button_prev ' + ((pageIndex > 0) ? '' : 'invisible') + '" type="button"';
		if(pageIndex > 0) {
			btnHtml += 'onclick="fnSetCadEstimator(' + (pageIndex - 1) + ');">';
		} else {
			btnHtml += '>';
		}
		btnHtml += '	<img src="/public/assets/images/dialog_page_next_button_arrow.svg" class="pagination_page_before_button_arrow"/>';
		btnHtml += '</button>';
		btnHtml += '<p class="pagination_current_page">' + (pageIndex + 1) + '&nbsp;</p>';
		btnHtml += '<p class="pagination_total_page">/ ' + cadEstimatorArr.length + '</p>';
		btnHtml += '<button class="pagination_page_button ' + ((pageIndex == cadEstimatorArr.length - 1) ? 'invisible' : '') + '" type="button"';
		if(pageIndex == cadEstimatorArr.length - 1) {
			btnHtml += '>';
		} else {
			btnHtml += 'onclick="fnSetCadEstimator(' + (pageIndex + 1) + ');">';
		}
		btnHtml += '	<img src="/public/assets/images/dialog_page_next_button_arrow.svg" class="pagination_page_next_button_arrow"/>';
		btnHtml += '</button>';
		
		$('.cad_estimator_pagination').html(btnHtml);
  }
  
  function fnSetCadEstimator() {
	  
	  $('#viewCadDeliveryPosDateTypo').text(currEstimator['DELIVERY_POS_DATE']);
	  
	  var suppDtlHtml = '';
	  var totalPrice = 0;
	  currEstimator.dtlInfo.map((m, i) => {
		  suppDtlHtml += '<div class="cad_estimator_dialog_item_context">';
			suppDtlHtml += '	<div class="dialog_item_context_calculate_price_wrapper">';
			suppDtlHtml += '		<div class="dialog_item_context_calculate_price without_margin">';
			var suppNmStr = [m.SUPP_CD_1, m.SUPP_CD_2, m.SUPP_CD_3, m.SUPP_CD_4].filter(f => isNotEmpty(f)).map(m => fnFindSuppNm(m)).join(' - ');
			suppDtlHtml += '			<input class="cad_estimator_dialog_item_context_blank_prosthetics_type" readonly value="' + suppNmStr + '" title="' + suppNmStr + '"/>';
			suppDtlHtml += '			<input class="cad_estimator_dialog_item_context_blank_price" readonly value="' + m.UNIT_PRICE + '"/>';
			suppDtlHtml += '			<p class="operator">X</p>';
			suppDtlHtml += '			<input class="cad_estimator_dialog_item_context_blank_count" readonly value=" '+ m.AMOUNT + '"/>';
			suppDtlHtml += '			<p class="operator">=</p>';
			suppDtlHtml += '			<div class="dialog_item_context_typo_container price_area">';
			suppDtlHtml += '				<p class="dialog_item_context_typo price_num">' + m.SUM_AMOUNT + '</p>';
			suppDtlHtml += '				<p class="dialog_item_context_typo">원</p>';
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
	  
		$('#viewMainPicImage').attr('src', defaultImgSrc);
	  $('.cad_estimator_sub_pic_upload').each(function(index, item) {
			$(item).removeClass('active');
			$(item).css('background-image', '');
		});
	  
	  currEstimator.fileList.map((m, i) => {
		  m.FILE_DIRECTORY = m.FILE_DIRECTORY.replace(/\\/g, '\/');
		  if(i == 0) $('#viewMainPicImage').attr('src', '/upload/' + m.FILE_DIRECTORY);
		  const target = $('.cad_estimator_sub_pic_upload').eq(i);
			target.addClass('active');
			target.css('background-image', "url('/upload/" + m.FILE_DIRECTORY + "')");
	  });
		$('.cad_estimator_sub_pic_upload:gt(' + (currEstimator.fileList.length - 1) + ')').css('background-image', '');
	  
	  // 치자이너 정보 변경
	  $('#nick_p_1').html(currEstimator.USER_NICK_NAME);
  }
  
  function fnDeleteCadEstimator() {
	  const projectNo = currEstimator['PROJECT_NO'];
	  if(confirm(getI8nMsg("alert.confirm.delete"))) { //삭제하시겠습니까?
		  $.ajax({
			  url: '/' + API + '/project/deleteEstimator',
			  type: 'POST',
			  data: { ESTIMATOR_NO : currEstimator['ESTIMATOR_NO'] },
			  cache: false,
			  async: false,
			  success: function(data) {
		    	if(data.result == 'Y') {
		    		alert(getI8nMsg("alert.delete"));//삭제되었습니다.
		    		location.reload();
		    	}
		    }, complete: function() {
		      
		    }, error: function() {
		      
		    }
		  });
	  }
  }
  
  function fnCadMatching() {
	  const estimatorNo = currEstimator['ESTIMATOR_NO'];
	  $.ajax({
		  url: '/' + API + '/project/matching',
		  type: 'POST',
		  data: { PROJECT_NO : '${PROJECT_NO}',
			  			ESTIMATOR_NO : estimatorNo },
		  cache: false,
		  async: false,
		  success: function(data) {
	    	if(data.result == 'Y') {
	    		location.href = '/' + API + '/contract/project_electronic_contract?ESTIMATOR_NO=' + estimatorNo;
	    	} else if(data.result == 'N') {
	    		if(isNotEmpty(data.msg)) {
	    			alert(data.msg);
		    		cadEstimatorViewModal.hide();
	    		}
	    	}
	    }, 
	    complete: function() {}, 
	    error: function() {}
	  });
  }
  
  $(function() {

    var cadEstimatorViewModalEl = document.getElementById('cadEstimatorViewModal');
    cadEstimatorViewModalEl.addEventListener('hidden.bs.modal', function(e) {
			
		});
    
    $('.cad_estimator_sub_pic_upload').on('click', function() {
		  if($(this).hasClass('active')) {
				var bg = $(this).css('background-image');
		    bg = bg.replace('url(','').replace(')','').replace(/\"/gi, '');
		    $('#viewMainPicImage').attr('src', bg);
			}
	  });
  });
  
</script>

                    	
<div class="modal fade" id="cadEstimatorViewModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
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
							납품가능시간
						</p>
					</div>
					<div class="dialog_item_context_container">
						<p id="viewCadDeliveryPosDateTypo" class="dialog_item_context_typo">
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
							<spring:message code="" text="구동가능한 CAD S/W" />
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
						<p class="dialog_item_title_typo"><spring:message code="equ.tesignInfo" text="치자이너 정보" /></p>
					</div>
					<div class="cad_estimator_dialog_item_context">
						<div class="cad_estimator_profile_pic_upload"></div>
						<div class="cad_estimator_profile_typo_container">
							<div class="cad_estimator_profile_name">
								<p class="cad_estimator_profile_name_typo" id="nick_p_1">중랑구 핫도그</p>
								<p class="cad_estimator_dialog_item_sub_title_typo">
								    세금 계산서 발행 가능
								</p>
							</div>
							<div class="cad_estimator_profile_info_container">
								<div class="cad_estimator_profile_info">
									<p class="cad_estimator_profile_info_typo">
									    <spring:message code="tesign.successR" text="거래성공률" />
									</p>
									<p class="cad_estimator_profile_info_typo">
									    100 %
									</p>
								</div>
								<div class="cad_estimator_profile_info">
									<p class="cad_estimator_profile_info_typo">
									    <spring:message code="tesign.satisf" text="만족도" />
									</p>
									<p class="cad_estimator_profile_info_typo">
									    82 %
									</p>
								</div>
								<div class="cad_estimator_profile_info without_margin">
									<p class="cad_estimator_profile_info_typo">
									    <spring:message code="tesign.totalA" text="현재까지 거래 총 금액" />
									</p>
									<p class="cad_estimator_profile_info_typo">
									    1234,567 원
									</p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="main_container_divider without_margin"></div>
			</div>
		</div>
	</div>
</div>
