<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!-- <script type="text/javascript">
  	var locations = document.location.href;
  	locations += ""; 
  	if (locations.includes('http://www.')) {
          document.location.href = document.location.href.replace('http://www.', 'https://');
     }else if(locations.includes('http:')){
    	 document.location.href = document.location.href.replace('http:', 'https:');
     }else if(locations.includes('https://www.')){
    	 document.location.href = document.location.href.replace('https://www.', 'https://');
     }
</script> -->
<c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if>
<c:if test="${sessionInfo.user.USER_TYPE_CD eq 1}">
<script>
   alert('접근 권한이 없습니다.');
   history.back();
</script>
</c:if>
<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>
<link type="text/css" rel="stylesheet" href="/public/assets/css/modal.css"/>

<script>

  var profileModal;
  
  function fnAllView() {
    location.href = '/' + API + '/project/project_view_all';
  }
  
  function fnCancel() {
    fnAllView();
  }
  
  function fnDateDialogOpen() {
	  var div1 = $('#dateDialogDiv');
	  if(div1.hasClass('hidden')) {
	    div1.removeClass('hidden');
	  }
	}
	  
	function fnDateDialogClose() {
	  var div1 = $('#dateDialogDiv');
	  if(!div1.hasClass('hidden')) {
	    div1.addClass('hidden');
	  }
	}
	  
	function fnDateDialogSelect_1() {
	  var code = arguments[0];
	  var codeNm = arguments[1];
	  var target = $('#YYYY_DIV_2');
	  if(target.hasClass('hidden')) {
	    target.removeClass('hidden');
	  } else {
	    target.addClass('hidden');
	  }
	  
	  if(isNotEmpty(code)) {
	    $('#YYYY_DIV_1').find('p').html(codeNm);
	    $('#DIALOG_YYYY').val(code);
	  }
	}
	  
	function fnDateDialogSelect_2() {
	  var code = arguments[0];
	  var codeNm = arguments[1];
	  var target = $('#MM_DIV_2');
	  if(target.hasClass('hidden')) {
	    target.removeClass('hidden');
	  } else {
	    target.addClass('hidden');
	  }
	  
	  if(isNotEmpty(code)) {
	    $('#MM_DIV_1').find('p').html(codeNm);
	    $('#DIALOG_MM').val(code);
	    
	    // 일자
	    var yaer = $('#DIALOG_YYYY').val();
	    if(isNotEmpty(yaer)) {
	      var cnt = 30;
	      if(code === '01' || code === '03' || code === '05' || code === '07' || code === '08' || code === '10' || code === '12') {
	        cnt = 31
	      } else if(code === '02') {
	        cnt = 28;
	        if( (yaer%4 === 0 && yaer%100 !== 0) || yaer%400 === 0 ) {
	          cnt = 29;
	        }
	      }
	      var html = ``;
	      for(var i=0; i<cnt; i++) {
	        if(i < 9) {
	          var code = ('0' + (i+1));
	          var codeNm = ('0' + (i+1)) + '일';
	          html += `<div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_3('` + code +`', '` + codeNm + `')">`;
	          html += `<p class="dropbox_select_button_item_typo">` + ('0' + (i+1)) + '일' + `</p>`;
	        } else {
	          var code = (i+1);
	          var codeNm = (i+1) + '일';
	      	  html += `<div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_3('` + code +`', '` + codeNm + `')">`;
	          html += `<p class="dropbox_select_button_item_typo">` + (i+1) + '일' + `</p>`;
	        }
	        html += `</div>`;
	      }
	      $('#DD_DIV_2').html(html);
	    }
	  }
	}
	  
	function fnDateDialogSelect_3() {
	  var code = arguments[0];
	  var codeNm = arguments[1];
	  var target = $('#DD_DIV_2');
	  if(target.hasClass('hidden')) {
	    target.removeClass('hidden');
	  } else {
	    target.addClass('hidden');
	  } 
	  
	  if(isNotEmpty(code)) {
	    $('#DD_DIV_1').find('p').html(codeNm);
	    $('#DIALOG_DD').val(code);
	  }
	}
	  
	function fnDateDialogSelect_4() {
	  var code = arguments[0];
	  var codeNm = arguments[1];
	  var target = $('#TTMM_DIV_2');
	  if(target.hasClass('hidden')) {
	    target.removeClass('hidden');
	  } else {
	    target.addClass('hidden');
	  }
	  
	  if(isNotEmpty(code)) {
	    $('#TTMM_DIV_1').find('p').html(codeNm);
	    $('#DIALOG_TTMM').val(code);
	  }
	}
	
	function fnDateDialogSet() {
		var args = arguments[0];
		var date;
		if(args == 'today') {
			date = new Date();
		} else if(args == 'tomorrow') {
			date = new Date(new Date().setDate(new Date().getDate() + 1));
		}
		
		var year = date.getFullYear();
		var month = ('0' + (date.getMonth() + 1)).slice(-2);
		var day = ('0' + date.getDate()).slice(-2);
		var hours = ('0' + date.getHours()).slice(-2); 
		var minutes = ('0' + date.getMinutes()).slice(-2);
		
		$('#YYYY_DIV_1').find('p').html(year + '년');
	  $('#DIALOG_YYYY').val(year);
	  
	  $('#MM_DIV_1').find('p').html(month + '월');
	  $('#DIALOG_MM').val(month);
	  
	  $('#DD_DIV_1').find('p').html(day + '일');
	  $('#DIALOG_DD').val(day);
	  
	  $('#TTMM_DIV_1').find('p').html(hours + ':' + minutes);
	  $('#DIALOG_TTMM').val(hours + minutes);
	}
  
  function fnDateDialogSearch() {
	  $.ajax({
	    url: '/' + API + '/common/getCode',
	    type: 'GET',
	    data: { GROUP_CD: 'YYYY_CD' },
	    cache: false,
	    async: false,
	    success: function(data) {
	      var html = ``;
	      for(var i=0; i<data.length; i++) {
	        html += `<div class="dropbox_select_button_item_large" onclick="fnDateDialogSelect_1('` + data[i].CODE_CD +`', '` + data[i].CODE_NM + `')">`;
	        html += `<p class="dropbox_select_button_item_typo">` + data[i].CODE_NM + `</p>`;
	        html += `</div>`;
	      }
	      $('#YYYY_DIV_2').html(html);
	    }
	  });
	}
  
  var reqArr = new Array();
  var suppInfo = new Array();
  
  function fnSetReqInfo() {
		
		var projectNo = '${PROJECT_NO}';
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
					
					/* suppCdArr.map((cd, i) => {
						if(suppInfo.some(s => s.SUPP_CD == cd)) {
							suppInfo.map(m => {
						  	if(m.SUPP_CD == cd) { m.CNT = (+m.CNT) + (+(cntArr[i])); }
						  });
						} else {
							var obj = { 'SUPP_CD' : cd, 
													'SUPP_NM' : suppNmArr[i], 
													'CNT' 		: cntArr[i] };
							suppInfo.push(obj);
						}
					}); */
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
  
  function fnCalculate() {
	  var priceInput = event.target;
	  var price = $(priceInput).val();
	  var amount = $(priceInput).siblings('.electronic_estimator_dialog_item_context_blank_count').val();
	  var sumAmount;
	  var totalSumAmount = 0;
	  
	  var regCheck = /^[0-9]*$/g;
	  if(!regCheck.test(price)) {
		  alert('숫자만 입력 가능합니다.');
		  priceInput.value = '';
	  } else {
		  sumAmount = price * amount;
		  $(priceInput).siblings('.price_area').find('.price_num').text(sumAmount);
	  }
	  
		$('#suppInfoContextWrapper .price_num').each(function() {
			totalSumAmount += (+$(this).text());
		});
		
		$('.electronic_estimator_total_price_wrapper .price_num').text(totalSumAmount);
  }
  
  function fnSelect_4() {
	  var index = arguments[0];
	  var code = arguments[1];
	  var codeNm = arguments[2];
	  var target = $('#' + 'CADSW_CD_DIV_' + index + '_2');
	  if(target.hasClass('hidden')) {
	    target.removeClass('hidden');
	  } else {
	    target.addClass('hidden');
	  }
	  
	  if(isNotEmpty(code)) {
	  	$('#' + 'CADSW_CD_DIV_' + index + '_1').find('p').html(codeNm);
	    $('#CADSW_CD_' + index).val(code);
	    $('#CADSW_NM_' + index).val(codeNm);
	  }
	}
  
  const MAX_UPLOAD_CNT = 10;
	const defaultImgSrc = '/public/assets/images/profile_image.svg';
	
	var uploadImgArr = new Array();
  
  function previewImage() {
		if(uploadImgArr.length >= MAX_UPLOAD_CNT) {
			alert('최대 ' + MAX_UPLOAD_CNT + '장까지 업로드 가능합니다.');
			return;
		}
		
		const file = event.target.files[0];
		if(isNotEmpty(file)) {
			const type = file.type;
			const mimeTypeList = [ 'image/png', 'image/jpeg', 'image/gif', 'image/bmp' ];
			if(mimeTypeList.includes(type)) {
				const reader = new FileReader();
				reader.readAsDataURL(file);
				reader.onload = (event) => {
					const imageSrc = event.target.result;
					$('#mainPicImage').attr('src', imageSrc);
					
					uploadImgArr.push({ 'FILE' : file, 'IMG_SRC' : imageSrc });
					const target = $('.electronic_estimator_sub_pic_upload').eq(uploadImgArr.length-1);
					target.addClass('active');
					target.css('background-image', 'url(' + imageSrc + ')')
					target.append('<img class="electronic_estimator_pic_attatchment_remove_button" src="/public/assets/images/dialog_close_button.svg" onclick="removeImage(this);"/>');
				};
			} else {
				alert('이미지 파일만 업로드 가능 합니다.');
			}
		}
	}
  
  function removeImage(elm) {
		const imageDiv = $(elm).parent();
		
		var bg = imageDiv.css('background-image');
	  bg = bg.replace('url(','').replace(')','').replace(/\"/gi, '');
	  if(bg == $('#mainPicImage').attr('src')) {
		  $('#mainPicImage').attr('src', defaultImgSrc);
	  }
		
		uploadImgArr = uploadImgArr.filter((v, i) => {
			if(i == imageDiv.index()) return false;
			else return true;
		});
		
		$('.electronic_estimator_sub_pic_upload').each(function(index, item) {
			if(uploadImgArr[index]) {
				$(item).css('background-image', 'url(' + uploadImgArr[index]['IMG_SRC'] + ')');
			} else {
				$(item).removeClass('active');
				$(item).css('background-image', '');
				$(item).find('.electronic_estimator_pic_attatchment_remove_button').remove();
			}
		});
		event.stopPropagation();
	}
  
  function fnSave() {
	  
	  var formData = new FormData(document.getElementById('saveForm'));
	 	for(var key of formData.keys()) {
	 		formData.set(key, JSON.stringify(formData.get(key)));
	 	}

	 	var year = $('#DIALOG_YYYY').val();
	  var month = $('#DIALOG_MM').val();
	  var day = $('#DIALOG_DD').val();
	  var hhmm = isEmpty($('#DIALOG_TTMM').val()) ? '0000' : $('#DIALOG_TTMM').val();
	  var hh = hhmm.substring(0, 2);
	  var mm = hhmm.substring(2);
	  
	  var is = fnIsValidDate(year + month + day);
	  if(is) {
		  var dateStr = year + '-' + month + '-' + day + ' ' + hh + ':' + mm + ':00';
		  formData.append('DELIVERY_POS_DATE', JSON.stringify(dateStr));
	  } else {
	    alert('선택한 일자가 올바르지 않습니다.');
	    return;
	  }
	  
	  if([...document.querySelectorAll('input[id^=UNIT_PRICE]')].some(s => isEmpty(s.value))) {
		  alert('단가를 입력해주세요.');
		  return;
	  }
	  
	  var ing = true;
	  $('#estimatorModal .price_num').each(function(index, item) {
		  var targetVal = toNumber($(item).html());
		  if(targetVal === 0) ing = false;
		  return false;
	  });
	  
	  if(!ing) {
		  alert('단가 및 합계를 확인해 주세요.');
      return;
	  }
	  
	  var cadswCdArr = new Array();
	  $('input[id^=CADSW_CD_]').each(function() {
		  if(isNotEmpty($(this).val())) cadswCdArr.push($(this).val());
	  });
	  if(new Set(cadswCdArr).size !== cadswCdArr.length) {
		  alert('구동 가능한 CAD S/W가 중복되었습니다.');
		  return;
	  }
	  
	  uploadImgArr.map(m => { formData.append('files', m.FILE); });
	  formData.append('fileDiv', JSON.stringify('ESTIMATOR'));
	  
	  suppInfo.map((m, i) => {
		  m['AMOUNT'] = m['CNT'];
		  m['UNIT_PRICE'] = $('input[id=UNIT_PRICE_' + i + ']').val();
		  m['SUM_AMOUNT'] = $('#suppInfoContextWrapper .price_num').eq(i).text();
		  m['SUPP_CD_LIST'].map((suppCd, suppCdIdx) => {
			  m['SUPP_CD_' + (suppCdIdx + 1)] = suppCd;
		  });
	  });
		formData.append('suppInfo', JSON.stringify(suppInfo));
	  
		if(confirm('저장하시겠습니까?')) {
		  $.ajax({
			  url: '/' + API + '/project/save02',
			  type: 'POST',
			  data: formData,
			  cache: false,
			  async: false,
			  contentType: false,
			  processData: false,
			  success: function(data) {
				  if(data.result == 'Y') {
					  alert('발송되었습니다.');
					  estimatorModal.hide();
				  } else if(data.result == 'N') {
						if(isNotEmpty(data.msg)) {
							alert(data.msg);
						}
				  }
			  }, complete: function() {
			  
			  }, error: function() {
			    
			  }
			});
		}
  }
  
  function fnWriteEstimator() {
	  
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
			
			reqHtml += '<div class="electronic_estimator_dialog_request">';
			reqHtml += '  <p class="electronic_estimator_dialog_request_title">의뢰서' + (index + 1) + '</p>';
			reqHtml += '	<p class="electronic_estimator_dialog_request_name">' + req.PANT_NM + '</p>';
			reqHtml += '	<p class="electronic_estimator_dialog_request_context">' + suppStr + '</p>';
			reqHtml += '</div>';
		});
		$('.electronic_estimator_dialog_request_container').html(reqHtml);
	  
	  var suppHtml = '';
	  var suppDtlHtml = '';
	  
	  suppInfo.map((m, i) => {
			suppHtml += '<div class="prosthetics_type_list_container">';
			suppHtml += '  <div class="prosthetics_type_list">';
			suppHtml += '    <p class="prosthetics_type_list_typo">' + m.SUPP_NM_STR + '</p>';
			suppHtml += '  </div>';
			suppHtml += '  <div class="prosthetics_type_list_divider"></div>';
			suppHtml += '  <div class="prosthetics_type_list">';
			suppHtml += '    <p class="prosthetics_type_list_typo">' + m.CNT + '</p>';
			suppHtml += '  </div>';
			suppHtml += '</div>';
			 
			suppDtlHtml += '<div class="electronic_estimator_dialog_item_context">';
	    suppDtlHtml += '  <div class="dialog_item_context_calculate_price_wrapper">';
	    suppDtlHtml += '    <div class="dialog_item_context_calculate_price without_margin">';
	    suppDtlHtml += '      <input maxlength="10" class="electronic_estimator_dialog_item_context_blank_prosthetics_type" value="' + m.SUPP_NM_STR + '" readonly="readonly"/>';
	    suppDtlHtml += '      <input maxlength="10" class="electronic_estimator_dialog_item_context_blank_price" placeholder="단가" id="UNIT_PRICE_' + i + '" onkeyup="fnCalculate();"/>';
	    suppDtlHtml += '      <p class="operator">X</p>';
	    suppDtlHtml += '      <input class="electronic_estimator_dialog_item_context_blank_count" value="' + m.CNT + '" readonly="readonly"/>';
	    suppDtlHtml += '      <p class="operator">=</p>';
	    suppDtlHtml += '      <div class="dialog_item_context_typo_container price_area">';
	    suppDtlHtml += '        <p class="dialog_item_context_typo price_num"></p>';
	    suppDtlHtml += '        <p class="dialog_item_context_typo">원</p>';
	    suppDtlHtml += '      </div>';
	    suppDtlHtml += '    </div>';
	    suppDtlHtml += '  </div>';
	    suppDtlHtml += '</div>';
	  });
	  
	  $('.prosthetics_type_list_container_wrapper').html(suppHtml);
		$('#suppInfoContextWrapper').html(suppDtlHtml);
  }
  
  function fnCloseEstimatorModal() {
	  
	  // 납품가능시간 초기화
	  $('#YYYY_DIV_2, #MM_DIV_2, #DD_DIV_2, #TTMM_DIV_2').addClass('hidden');
	  
	  $('#YYYY_DIV_1').find('p').html('YYYY');
	  $('#MM_DIV_1').find('p').html('MM');
	  $('#DD_DIV_1').find('p').html('DD');
	  $('#TTMM_DIV_1').find('p').html('TT:MM');
	  
	  $('input[id^=DIALOG_]').val('');
	  
	  // 총 금액 초기화
	  $('.electronic_estimator_total_price_wrapper .price_num').text('');
	  
	  // CAD S/W 초기화
	  $('#CADSW_CD_DIV_1_1, #CADSW_CD_DIV_2_1, #CADSW_CD_DIV_3_1').find('p').html('선택');
	  $('#CADSW_CD_DIV_1_2, #CADSW_CD_DIV_2_2, #CADSW_CD_DIV_3_2').addClass('hidden');
	  $('input[id^=CADSW_CD_]').val('');
	  $('input[id^=CADSW_NM_]').val('');
	  
	  // 이미지 초기화
	  uploadImgArr = [];
	  $('#mainPicImage').attr('src', defaultImgSrc);
	  $('.electronic_estimator_sub_pic_upload').each(function(index, item) {
			$(item).removeClass('active');
			$(item).css('background-image', '');
			$(item).find('.electronic_estimator_pic_attatchment_remove_button').remove();
		});
  }
  
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
				return nm + ' ' + cntArr[i] + '개';
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
	  var projectNo = '${PROJECT_NO}';
	  
	  $.ajax({
		  url: '/' + API + '/project/getEstimators',
		  type: 'GET',
		  data: { PROJECT_NO : projectNo },
		  cache: false,
		  async: false,
		  success: function(data) {
				estimatorArr = data.estimatorList;
				if(isEmpty(estimatorArr)) {
					alert('받은 견적서가 존재하지 않습니다.');
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
	  
	  currEstimator.fileList.map((m, i) => {
		  m.FILE_DIRECTORY = m.FILE_DIRECTORY.replace(/\\/g, '\/');
		  if(i == 0) $('#viewMainPicImage').attr('src', '/upload/' + m.FILE_DIRECTORY);
		  const target = $('.cad_estimator_sub_pic_upload').eq(i);
			target.addClass('active');
			target.css('background-image', "url('/upload/" + m.FILE_DIRECTORY + "')");
	  });
	  
	  fnSetEstimatorPageInfo(index);
	  
	  // 치자이너 정보 변경
// 	  console.log('currEstimator', currEstimator);
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
  
  function fnDeleteEstimator() {
	  $.ajax({
		  url: '/' + API + '/project/deleteEstimator',
		  type: 'POST',
		  data: { ESTIMATOR_NO : currEstimator['ESTIMATOR_NO'] },
		  cache: false,
		  async: false,
		  success: function(data) {
	    	if(data.result == 'Y') {
	    		alert('삭제되었습니다.');
	    		fnGetEstimators();
	    	}
	    }, complete: function() {
	      
	    }, error: function() {
	      
	    }
	  });
  }
  
  function fnMatching() {
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
		    		estimatorViewModal.hide();
	    		}
	    	}
	    }, 
	    complete: function() {}, 
	    error: function() {}
	  });
  }
  
  function fnProjectDelete() {
   
	  var isConfirm = window.confirm('삭제 하시겠습니까?');
    if(!isConfirm) return;
    
    $.ajax({
      url: '/' + API + '/project/delete01',
      type: 'POST',
      data: { PROJECT_NO : '${PROJECT_NO}' },
      cache: false,
      async: false,
      success: function(data) {
    	  fnAllView();
      }, complete: function() {
        
      }, error: function() {
        
      }
    });
  }
  
  function fnModify() {
    var url = '/' + API + '/project/project_request';
    url += '?PROJECT_NO=${DATA.PROJECT_NO}';
    url += '&GCS=${DATA.GCS}';
    url += '&REQS=${DATA.REQS}';
    location.href = url;
  }
  
  function fnSupplementModal() {
    
    var reqHtml = '';
    var cntArr;
    var rqstNoArr;
    var suppCdArr;
    var suppNmArr;
    
    reqArr.map((req, index) => {
      cntArr = req['CNT_STR'].split(',');
      rqstNoArr = req['RQST_NO_STR'].split(',');
      suppCdArr = req['SUPP_CD_STR'].split(',');
      suppNmArr = req['SUPP_NM_STR'].split(',');
      
      var suppStr = suppNmArr.map((nm, i) => {
        return nm + ' ' + cntArr[i] + '개';
      }).join(', ');
      
      reqHtml += '<div class="project_request_request">';
      reqHtml += '  <p class="project_request_request_title">의뢰서' + (index + 1) + '</p>';
      reqHtml += '  <p class="project_request_request_context">' + suppStr + '</p>';
      reqHtml += '</div>';
    });
    
    $('.project_request_request_container').html(reqHtml);
    
    $('#supplementListDiv').html('');
    
    $.ajax({
      url: '/' + API + '/tribute/getSuppInfo',
      type: 'POST',
      data: JSON.stringify({ GROUP_CD_LIST : Array.from(new Set(reqArr.map(m => m.GROUP_CD))) }),
      contentType: 'application/json; charset=utf-8',
      cache: false,
      async: false,
      success: function(data) {
        data.map((m, i) => {
          var suppHtml = '';
          var counts = m.CNT;
          if(m.SUPP_NM_STR.includes('Frame') || m.SUPP_NM_STR.includes('Splint') || m.SUPP_NM_STR.includes('의치') || m.SUPP_NM_STR.includes('교정') || m.SUPP_NM_STR.includes('트레이')){
        	  counts = 1;
          }//Frame, Splint, 의치, 교정, 트레이
          suppHtml += '<div class="prosthetics_type_list_container">';
          suppHtml += '<div class="prosthetics_type_list">';
          suppHtml += '  <p class="prosthetics_type_list_typo">' + m.SUPP_NM_STR + '</p>';
          suppHtml += '</div>';
          suppHtml += '<div class="prosthetics_type_list_divider"></div>';
          suppHtml += '<div class="prosthetics_type_list">';
          suppHtml += '  <p class="prosthetics_type_list_typo">' + counts + '</p>';
          suppHtml += '</div>';
          suppHtml += '</div>';
          $('#supplementListDiv').append(suppHtml);
        });
      }, 
      complete: function() {}, 
      error: function() {}
    });
    
  }
  
  function fnSelectReset() {
    $('#CADSW_CD_DIV_1_1, #CADSW_CD_DIV_2_1, #CADSW_CD_DIV_3_1').find('p').html('선택');
    $('#CADSW_CD_DIV_1_2, #CADSW_CD_DIV_2_2, #CADSW_CD_DIV_3_2').addClass('hidden');
    $('input[id^=CADSW_CD_]').val('');
    $('input[id^=CADSW_NM_]').val('');
  }
  
  var estimatorModal;
  var estimatorViewModal;
  
  $(function() {
	  
	  fnDateDialogSearch();
	  fnSetReqInfo();
	  
	  $('#imaageUploadTypo').click(function() {
		  $('input[id=IMG_FILE]').trigger('click');
	  });
	  
	  $('.electronic_estimator_sub_pic_upload').on('click', function() {
			if($(this).hasClass('active')) {
				const elIndex = $('.electronic_estimator_sub_pic_upload').index($(this));
				$('#mainPicImage').attr('src', uploadImgArr[elIndex]['IMG_SRC']);
			}
		});
	  
	  $('.cad_estimator_sub_pic_upload').on('click', function() {
		  if($(this).hasClass('active')) {
				var bg = $(this).css('background-image');
		    bg = bg.replace('url(','').replace(')','').replace(/\"/gi, '');
		    $('#viewMainPicImage').attr('src', bg);
			}
	  });
	  
	  estimatorModal = new bootstrap.Modal(document.getElementById('estimatorModal'));
	  estimatorViewModal = new bootstrap.Modal(document.getElementById('estimatorViewModal'));
	  
	  var estimatorModalEl = document.getElementById('estimatorModal');
	  estimatorModalEl.addEventListener('hidden.bs.modal', function(e) {
		  fnCloseEstimatorModal();
		});
	  
    profileModal = new bootstrap.Modal(document.getElementById('profileModal')); // 프로필
    var profileModalEl = document.getElementById('profileModal');
    profileModalEl.addEventListener('show.bs.modal', function(e) {
//       alert(1);
    });
	  
  });
  
</script>

<div class="project_header">
  <p class="project_header_typo">프로젝트 보기</p>
</div>

<jsp:include page="/WEB-INF/views/dialog/profile_dialog.jsp" flush="true" />
<jsp:include page="/WEB-INF/views/page/talk/common_send.jsp" flush="true"/>

<div class="project_body">
  <div class="side_menu">
    <div class="side_menu_title" style="cursor: pointer;" onclick="fnAllView();">
      <p class="side_menu_title_typo">전체보기</p>
    </div>
    <c:forEach var="item" items="${PROJECT_CD_LIST}" varStatus="status">
      <a href="/${api}/project/project_view_all?SEARCH_PROJECT_CD=${item.CODE_CD}" class="side_menu_list">
        <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
        <p class="side_menu_list_typo">${item.CODE_NM}</p>
      </a>
    </c:forEach>
  </div>
	<form:form id="saveForm" name="saveForm">
		<input type="hidden" id="PROJECT_NO" name="PROJECT_NO" value="${PROJECT_NO}" />
		
		<input type="hidden" id="CADSW_CD_1" name="CADSW_CD_1" value="" />
    <input type="hidden" id="CADSW_CD_2" name="CADSW_CD_2" value="" />
    <input type="hidden" id="CADSW_CD_3" name="CADSW_CD_3" value="" />
    
    <input type="hidden" id="CADSW_NM_1" name="CADSW_NM_1" value="" />
    <input type="hidden" id="CADSW_NM_2" name="CADSW_NM_2" value="" />
    <input type="hidden" id="CADSW_NM_3" name="CADSW_NM_3" value="" />
		
	<div class="project_request_main_container">
		<div class="project_connection_location_container">
			<a href="./main.html" class="project_connection_location_typo">
			  <img class="project_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
			</a>
			<img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
			<div class="project_connection_location">
			  <p class="project_connection_location_typo">프로젝트 보기</p>
			</div>
			<img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
			<div class="project_connection_location">
			  <p class="project_connection_location_typo">프로젝트 전체보기</p>
			</div>
			<img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
			<div class="project_connection_location">
			  <p class="project_connection_location_typo_bold">의뢰서</p>
			</div>
		</div>
		<div class="connection_location_divider"></div>
		<div class="project_request_reading_info_wrapper">
			<div class="project_request_reading_info_sub_container">
				<div class="project_request_reading_info_title">
				  <p class="project_request_reading_info_title_typo">${DATA.TITLE}</p>
				</div>
				<div class="project_request_profile_wrapper">
<!-- 				  <div class="project_request_profile_pic_upload"></div> -->
				  <div class="project_request_profile_info_container">
				    <div class="project_request_profile_button_container">
				      <c:if test="${sessionInfo.user.USER_ID ne DATA.CREATE_ID}">
					      <button type="button" class="project_request_profile_button" onclick="javascript:fnOpenTalk('${DATA.CREATE_ID}', '${DATA.CREATE_NICK_NAME}');">
					        <p class="project_request_profile_button_typo">문의하기</p>
					      </button>
				      </c:if>
				      <button type="button" class="project_request_profile_button" onclick="javascript:profileModal.show();">
				        <p class="project_request_profile_button_typo">프로필보기</p>
				      </button>
				    </div>
				    <div class="project_request_reading_info_etc_container">
				      <div class="project_request_reading_info_etc">
				        <p class="project_request_reading_info_etc_typo">
				          게시판: ${DATA.PROJECT_NM}
				        </p>
				      </div>
				      <div class="project_request_reading_info_etc">
				        <p class="project_request_reading_info_etc_typo">
				          작성일 : ${DATA.CREATE_DATE}
				        </p>
				      </div>
				      <div class="project_request_reading_info_etc">
				        <p class="project_request_reading_info_etc_typo">
				          조회수 : ${DATA.HITS_COUNT}
				        </p>
				      </div>
				    </div>
				  </div>
				</div>
			</div>
      <div class="main_container_divider divider_without_margin"></div>
        <div class="project_request_reading_info_main_container">
          <div class="project_request_reading_info_item_container">
            <div class="project_request_reading_info_item">
              <div class="project_request_reading_info_item_title">
                <p class="project_request_reading_info_item_title_typo">
                  견적요청 만료시간
                </p>
              </div>
              <div class="project_request_reading_info_item_context">
                <p class="project_request_reading_info_item_context_typo">
                  ${DATA.PROJECT_EXP_DATE2}
                </p>
              </div>
            </div>
            <div class="project_request_reading_info_item">
              <div class="project_request_reading_info_item_title">
                <p class="project_request_reading_info_item_title_typo">
                  납품 마감일
                </p>
              </div>
              <div class="project_request_reading_info_item_context">
                <p class="project_request_reading_info_item_context_typo">
                  ${DATA.DELIVERY_EXP_DATE4}
                </p>
              </div>
            </div>
          </div>
          <div class="project_request_reading_info_item_container">
						<div class="project_request_reading_info_item">
							<div class="project_request_reading_info_item_title">
							  <p class="project_request_reading_info_item_title_typo">
							    보철 종류
							  </p>
							</div>
							<a href="#supplementViewModal" class="project_request_reading_info_item_context" data-bs-toggle="modal" onclick="fnSupplementModal();">
							  <button type="button" class="project_request_view_prosthetics_type_button">
							    <p class="project_request_view_prosthetics_type_button_typo">보철종류 보기</p>
							  </button>
							</a>
						</div>
						<div class="project_request_reading_info_item">
						  <div class="project_request_reading_info_item_title">
						    <p class="project_request_reading_info_item_title_typo">
						      선호 CAD S/W
						    </p>
						  </div>
						  <div class="project_request_reading_info_item_context">
						    <p class="project_request_reading_info_item_context_typo">
						      ${DATA.PREFER_CD_NM_1}
						      <c:if test="${not empty DATA.PREFER_CD_NM_1 and not empty DATA.PREFER_CD_NM_2}">,</c:if>
						      ${DATA.PREFER_CD_NM_2}
						      <c:if test="${(not empty DATA.PREFER_CD_NM_1 or not empty DATA.PREFER_CD_NM_2) and not empty DATA.PREFER_CD_NM_3}">,</c:if>
						      ${DATA.PREFER_CD_NM_3}
						      
						    </p>
						  </div>
						</div>
          </div>
          <div class="main_container_divider light divider_without_margin"></div>
          <div class="project_request_reading_info_detail">
            <p class="project_request_reading_info_detail_typo">
              ${DATA.ADD_CONTENT}
            </p>
          </div>  
          <div class="main_container_divider"></div>
        </div>
        <div class="project_request_button_wrapper">
          <div class="project_request_button_container left">
            <c:if test="${CNT04 eq 0}">
              <c:if test="${not empty sessionInfo.user and DATA.CREATE_ID ne sessionInfo.user.USER_ID}">
                <c:choose>
                   <c:when test="${sessionInfo.user.USER_TYPE_CD eq 1 or sessionInfo.user.USER_TYPE_CD eq 2}">
                      <!-- <a class="project_request_button blue" data-bs-toggle="modal" style="opacity:50%;cursor:not-allowed;" disabled>
                        <p class="project_request_button_typo blue" style="color:gray;">견적서 보내기</p>
                      </a> -->
                  </c:when>
                  <c:when test="${DATA.PUBLIC_CD eq 'U001'}"> <!-- 지정견적 -->
                    <c:if test="${fn:contains(DATA.APPOINT_USER, sessionInfo.user.USER_ID)}">
                      <a href="#estimatorModal" class="project_request_button blue" data-bs-toggle="modal" onclick="fnWriteEstimator();">
                        <p class="project_request_button_typo blue">견적서 보내기</p>
                      </a>
                    </c:if>
                  </c:when>
                  <c:when test="${DATA.PUBLIC_CD eq 'U002'}"> <!-- 공개견적 -->
                    <a href="#estimatorModal" class="project_request_button blue" data-bs-toggle="modal" onclick="fnWriteEstimator();">
                      <p class="project_request_button_typo blue">견적서 보내기</p>
                    </a>
                  </c:when>
                </c:choose>
              </c:if>
              <c:if test="${DATA.CREATE_ID eq sessionInfo.user.USER_ID}">
                <a href="javascript:fnViewEstimators();" class="project_request_button white">
                  <p class="project_request_button_typo white_typo">받은 견적서 보기</p>
                </a>
                <a href="javascript:fnModify();" class="project_request_button white">
                  <p class="project_request_button_typo white_typo">수정</p>
                </a>
                <a href="javascript:fnProjectDelete();" class="project_request_button white">
                  <p class="project_request_button_typo white_typo">삭제</p>
                </a>
              </c:if>
            </c:if>
          </div>
          
					<div class="project_request_button_container right">
					  <a href="/${api}/project/project_view_all" class="project_request_button white without_margin_right">
					    <p class="project_request_button_typo white_typo">목록</p>
					  </a>
					</div>
				</div>
                
        <!-- 전자견적서 보내기 modal -->
				<div class="modal fade" id="estimatorModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
				  <div class="modal-dialog modal-dialog-centered">
				    <div class="modal-content" style="width: fit-content;">
						  <div class="electronic_estimator_container">
				        <div class="dialog_header">
				          <p class="dialog_header_typo">
				          	전자견적서
				          </p>
				          <a href="javascript:void(0);" data-bs-dismiss="modal" aria-label="Close">
				            <img class="dialog_close_button" src="/public/assets/images/dialog_close_button.svg"/>
				          </a>
				        </div>
				        <div class="electronic_estimator_dialog_item">
				          <div class="electronic_estimator_dialog_item_title">
				            <p class="dialog_item_title_typo">
				              납품가능시간
				            </p>
				            <p class="electronic_estimator_dialog_item_sub_title_typo">
				              납품까지 소요시간이 아닌 예상날짜와 시간을 입력하세요
				            </p>
				          </div>
				          <div class="electronic_estimator_dialog_item_context_container">
				          	<div class="electronic_estimator_dialog_item_context">
				            	<div class="electronic_estimator_dialog_item_button_container">
												<div class="electronic_estimator_dialog_item_button" style="cursor: pointer;" onclick="fnDateDialogSet('today');">
												  <p class="electronic_estimator_dialog_item_button_typo">오늘</p>
												</div>
												<div class="electronic_estimator_dialog_item_button" style="cursor: pointer;" onclick="fnDateDialogSet('tomorrow');">
												  <p class="electronic_estimator_dialog_item_button_typo">내일</p>
												</div>
				              </div>
				              <div class="electronic_estimator_select_button_container" style="height: 38px;">
				              	<input type="hidden" id="DIALOG_YYYY">
												<input type="hidden" id="DIALOG_MM">
												<input type="hidden" id="DIALOG_DD">
												<input type="hidden" id="DIALOG_TTMM">
						            <div class="dropbox_year">
												  <div id="YYYY_DIV_1" class="dropbox_select_button" onclick="fnDateDialogSelect_1();" style="cursor: pointer;">
												    <div class="dropbox_select_button_typo_container">
												      <p class="dropbox_select_button_typo">YYYY</p>
												      <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
												    </div>
												  </div>
											  	<div id="YYYY_DIV_2" class="dropbox_select_button_item_container_year hidden" style="cursor: pointer;"></div>
												</div>
												<div class="dropbox_month">
												  <div id="MM_DIV_1" class="dropbox_select_button" onclick="fnDateDialogSelect_2();" style="cursor: pointer;">
								            <div class="dropbox_select_button_typo_container">
								              <p class="dropbox_select_button_typo">MM</p>
								              <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
								            </div>
								          </div>
												  <div id="MM_DIV_2" class="dropbox_select_button_item_container_month hidden" style="cursor: pointer;">
												    <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('01', '01월')">
												      <p class="dropbox_select_button_item_typo">01월</p>
												    </div>
												    <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('02', '02월')">
												      <p class="dropbox_select_button_item_typo">02월</p>
												    </div>
												    <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('03', '03월')">
												      <p class="dropbox_select_button_item_typo">03월</p>
												    </div>
												    <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('04', '04월')">
												      <p class="dropbox_select_button_item_typo">04월</p>
												    </div>
												    <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('05', '05월')">
												      <p class="dropbox_select_button_item_typo">05월</p>
												    </div>
												    <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('06', '06월')">
												      <p class="dropbox_select_button_item_typo">06월</p>
												    </div>
												    <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('07', '07월')">
												      <p class="dropbox_select_button_item_typo">07월</p>
												    </div>
												    <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('08', '08월')">
												      <p class="dropbox_select_button_item_typo">08월</p>
												    </div>
												    <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('09', '09월')">
												      <p class="dropbox_select_button_item_typo">09월</p>
												    </div>
												    <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('10', '10월')">
												      <p class="dropbox_select_button_item_typo">10월</p>
												    </div>
												    <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('11', '11월')">
												      <p class="dropbox_select_button_item_typo">11월</p>
												    </div>
												    <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('12', '12월')">
												      <p class="dropbox_select_button_item_typo">12월</p>
												    </div>
												  </div>
												</div>
												<div class="dropbox_date">
												  <div id="DD_DIV_1" class="dropbox_select_button" onclick="fnDateDialogSelect_3();" style="cursor: pointer;">
									          <div class="dropbox_select_button_typo_container">
									            <p class="dropbox_select_button_typo">DD</p>
									            <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
									          </div>
									        </div>
												  <div id="DD_DIV_2" class="dropbox_select_button_item_container_date hidden"  style="cursor: pointer;"></div>
												</div>
				                <div class="dropbox_time">
													<div id="TTMM_DIV_1" class="dropbox_select_button" onclick="fnDateDialogSelect_4();" style="cursor: pointer;">
									          <div class="dropbox_select_button_typo_container">
									            <p class="dropbox_select_button_typo">TT:MM</p>
									            <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
									          </div>
									        </div>
				                  <div id="TTMM_DIV_2" class="dropbox_select_button_item_container_time hidden" style="cursor: pointer;">
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('0900', '09:00')">
														  <p class="dropbox_select_button_item_typo">09:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('0930', '09:30')">
														  <p class="dropbox_select_button_item_typo">09:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1000', '10:00')">
														  <p class="dropbox_select_button_item_typo">10:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1030', '10:30')">
														  <p class="dropbox_select_button_item_typo">10:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1100', '11:00')">
														  <p class="dropbox_select_button_item_typo">11:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1130', '11:30')">
														  <p class="dropbox_select_button_item_typo">11:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1200', '12:00')">
														  <p class="dropbox_select_button_item_typo">12:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1230', '12:30')">
														  <p class="dropbox_select_button_item_typo">12:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1300', '13:00')">
														  <p class="dropbox_select_button_item_typo">13:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1330', '13:30')">
														  <p class="dropbox_select_button_item_typo">13:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1400', '14:00')">
														  <p class="dropbox_select_button_item_typo">14:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1430', '14:30')">
														  <p class="dropbox_select_button_item_typo">14:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1500', '15:00')">
														  <p class="dropbox_select_button_item_typo">15:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1530', '15:30')">
														  <p class="dropbox_select_button_item_typo">15:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1600', '16:00')">
														  <p class="dropbox_select_button_item_typo">16:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1630', '16:30')">
														  <p class="dropbox_select_button_item_typo">16:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1700', '17:00')">
														  <p class="dropbox_select_button_item_typo">17:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1730', '17:30')">
														  <p class="dropbox_select_button_item_typo">17:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1800', '18:00')">
														  <p class="dropbox_select_button_item_typo">18:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1830', '18:30')">
														  <p class="dropbox_select_button_item_typo">18:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1900', '19:00')">
														  <p class="dropbox_select_button_item_typo">19:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1930', '19:30')">
														  <p class="dropbox_select_button_item_typo">19:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2000', '20:00')">
														  <p class="dropbox_select_button_item_typo">20:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2030', '20:30')">
														  <p class="dropbox_select_button_item_typo">20:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2100', '21:00')">
														  <p class="dropbox_select_button_item_typo">21:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2130', '21:30')">
														  <p class="dropbox_select_button_item_typo">21:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2200', '22:00')">
														  <p class="dropbox_select_button_item_typo">22:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2230', '22:30')">
														  <p class="dropbox_select_button_item_typo">22:30</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2300', '23:00')">
														  <p class="dropbox_select_button_item_typo">23:00</p>
														</div>
														<div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2330', '23:30')">
														  <p class="dropbox_select_button_item_typo">23:30</p>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
				        </div>
        				<div class="main_container_divider without_margin"></div>
        				<div class="electronic_estimator_dialog_item_row">
			            <div class="electronic_estimator_dialog_item_title">
			                <p class="dialog_item_title_typo">
			                    금액
			                </p>
			                <p class="electronic_estimator_dialog_item_sub_title_typo">
			                    항목 직접 작성
			                </p>
			            </div>
			            <div class="electronic_estimator_dialog_item_context_container_price_area">
			                <div class="electronic_estimator_dialog_item_context">
			                    <div class="electronic_estimator_dialog_request_container">
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
			                                보철종류
			                            </p>
			                        </div>
			                        <div class="prosthetics_type_data_type_divider"></div>
			                        <div class="prosthetics_type_data_type">
			                            <p class="prosthetics_type_data_type_typo">
			                                개수
			                            </p>
			                        </div>
			                    </div>
			                    <div class="prosthetics_type_list_container_wrapper"></div>
			                </div>
			                <div class="dotted_divider_container">
			                    <img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
			                    <img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
			                </div>
			                <div id="suppInfoContextWrapper">
			                </div>
			                <div class="electronic_estimator_total_price_wrapper">
			                    <div class="dialog_item_context_typo_container total_price_area">
			                        <p class="dialog_item_context_typo total_price">총 금액</p>
			                        <p class="dialog_item_context_typo price_num"></p>
			                        <p class="dialog_item_context_typo"> 원</p>
			                    </div>
			                </div>
			            </div>
        				</div>
        				<div class="main_container_divider without_margin"></div>
				        <div class="electronic_estimator_dialog_item">
									<div class="electronic_estimator_dialog_item_title">
										<p class="dialog_item_title_typo">
											구동 가능한 CAD(Computer Aided Design) S/W
											<button type="button" class="refresh" onclick="javascript:fnSelectReset();">
	                      <img src="/public/assets/images/refresh.png" alt="">
	                      <span>선택초기화</span>
                      </button>
										</p>
									</div>
				          <div class="electronic_estimator_dialog_item_context">
				          	<div class="electronic_estimator_select_button_container without_margin" style="height: 38px;">
											<div class="project_request_select_button_container">
											  <div class="dropbox_project_request_preference">
											    <div class="dropbox_select_button">
											      <div id="CADSW_CD_DIV_1_1" class="dropbox_select_button_typo_container" onclick="fnSelect_4('1');" style="cursor: pointer;">
											        <p class="dropbox_select_button_typo">선택</p>
											        <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
											      </div>
											    </div>
											    <div id="CADSW_CD_DIV_1_2" class="dropbox_select_button_item_container hidden" style="cursor: pointer;">
											      <c:forEach var="item" items="${CADSW_CD_LIST}" varStatus="status">
											        <div class="dropbox_select_button_item" onclick="fnSelect_4('1', '${item.CODE_CD}', '${item.CODE_NM}')">
											          <p class="dropbox_select_button_item_typo">${item.CODE_NM}</p>
											        </div>
											      </c:forEach>
											    </div>
											  </div>
											</div>
											<div class="project_request_select_button_container">
											  <div class="dropbox_project_request_preference">
											    <div class="dropbox_select_button">
											      <div id="CADSW_CD_DIV_2_1" class="dropbox_select_button_typo_container" onclick="fnSelect_4('2');" style="cursor: pointer;">
											        <p class="dropbox_select_button_typo">선택</p>
											        <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
											      </div>
											    </div>
											    <div id="CADSW_CD_DIV_2_2" class="dropbox_select_button_item_container hidden" style="cursor: pointer;">
											      <c:forEach var="item" items="${CADSW_CD_LIST}" varStatus="status">
											        <div class="dropbox_select_button_item" onclick="fnSelect_4('2', '${item.CODE_CD}', '${item.CODE_NM}')">
											          <p class="dropbox_select_button_item_typo">${item.CODE_NM}</p>
											        </div>
											      </c:forEach>
											    </div>
											  </div>
											</div>
											<div class="project_request_select_button_container">
											  <div class="dropbox_project_request_preference">
											    <div class="dropbox_select_button">
											      <div id="CADSW_CD_DIV_3_1" class="dropbox_select_button_typo_container" onclick="fnSelect_4('3');" style="cursor: pointer;">
											        <p class="dropbox_select_button_typo">선택</p>
											        <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
											      </div>
											    </div>
											    <div id="CADSW_CD_DIV_3_2" class="dropbox_select_button_item_container hidden" style="cursor: pointer;">
											      <c:forEach var="item" items="${CADSW_CD_LIST}" varStatus="status">
											        <div class="dropbox_select_button_item" onclick="fnSelect_4('3', '${item.CODE_CD}', '${item.CODE_NM}')">
											          <p class="dropbox_select_button_item_typo">${item.CODE_NM}</p>
											        </div>
											      </c:forEach>
											    </div>
											  </div>
											</div>
				            </div>
				            <div class="electronic_estimator_dialog_item_context_info">
											<p class="electronic_estimator_dialog_item_context_info_typo">
				              	최대 3개까지 선택이 가능합니다
				              </p>
				            </div>
				          </div>
				        </div>
        				<div class="main_container_divider without_margin"></div>
				        <div class="electronic_estimator_dialog_item_row">
									<div class="electronic_estimator_dialog_item_title">
									  <p class="dialog_item_title_typo">
									    대표사진 첨부하기
									  </p>
									</div>
									<div class="electronic_estimator_pic_upload_wrapper">
									  <div class="electronic_estimator_pic_upload_container">
									    <div class="electronic_estimator_main_pic_upload_wrapper">
									      <img id="mainPicImage" class="electronic_estimator_main_pic_upload" src="/public/assets/images/profile_image.svg" style="width: 100%; height: 100%;"/>
									    </div>
									  </div>
									  <button id="imaageUploadTypo" class="electronic_estimator_upload_button" type="button">
									    <p class="electronic_estimator_upload_button_typo">이미지 업로드</p>
									  </button>
									  <input type="file" name="IMG_FILE" id="IMG_FILE" onchange="previewImage();" style="display: none;"/>
									</div>
				        </div>
				        <div class="electronic_estimator_sub_pic_upload_wrapper">
				            <div class="electronic_estimator_sub_pic_upload_container">
				                <div class="electronic_estimator_sub_pic_upload"></div>
				                <div class="electronic_estimator_sub_pic_upload"></div>
				                <div class="electronic_estimator_sub_pic_upload"></div>
				                <div class="electronic_estimator_sub_pic_upload"></div>
				                <div class="electronic_estimator_sub_pic_upload"></div>
				            </div>
				            <div class="electronic_estimator_sub_pic_upload_container">
				                <div class="electronic_estimator_sub_pic_upload"></div>
				                <div class="electronic_estimator_sub_pic_upload"></div>
				                <div class="electronic_estimator_sub_pic_upload"></div>
				                <div class="electronic_estimator_sub_pic_upload"></div>
				                <div class="electronic_estimator_sub_pic_upload"></div>
				            </div>
				        </div>
				        <div class="main_container_divider without_margin"></div>
<!-- 				        <div class="electronic_estimator_dialog_item"> -->
<!-- 				            <div class="electronic_estimator_dialog_item_title"> -->
<!-- 				                <p class="dialog_item_title_typo"> -->
<!-- 				                    치자이너 정보 -->
<!-- 				                </p> -->
<!-- 				            </div> -->
<!-- 				            <div class="electronic_estimator_dialog_item_context"> -->
<!-- 				                <div class="electronic_estimator_profile_pic_upload"></div> -->
<!-- 				                <div class="electronic_estimator_profile_name"> -->
<%-- 				                    <p class="electronic_estimator_profile_name_typo">${sessionInfo.user.USER_NICK_NAME}</p> --%>
<!-- 				                    <p class="electronic_estimator_dialog_item_sub_title_typo"> -->
<!-- 				                        세금 계산서 발행 가능 -->
<!-- 				                    </p> -->
<!-- 				                </div> -->
<!-- 				                <div class="electronic_estimator_profile_info_container"> -->
<!-- 				                    <div class="electronic_estimator_profile_info"> -->
<!-- 				                        <p class="electronic_estimator_profile_info_typo"> -->
<!-- 				                            거래 성공률 -->
<!-- 				                        </p> -->
<!-- 				                        <p class="electronic_estimator_profile_info_typo"> -->
<!-- 				                            100 % -->
<!-- 				                        </p> -->
<!-- 				                    </div> -->
<!-- 				                    <div class="electronic_estimator_profile_info"> -->
<!-- 				                        <p class="electronic_estimator_profile_info_typo"> -->
<!-- 				                            만족도 -->
<!-- 				                        </p> -->
<!-- 				                        <p class="electronic_estimator_profile_info_typo"> -->
<!-- 				                            82 % -->
<!-- 				                        </p> -->
<!-- 				                    </div> -->
<!-- 				                    <div class="electronic_estimator_profile_info"> -->
<!-- 				                        <p class="electronic_estimator_profile_info_typo"> -->
<!-- 				                            현재까지 거래 총 금액 -->
<!-- 				                        </p> -->
<!-- 				                        <p class="electronic_estimator_profile_info_typo"> -->
<!-- 				                            1234,567 원 -->
<!-- 				                        </p> -->
<!-- 				                    </div> -->
<!-- 				                </div> -->
<!-- 				            </div> -->
<!-- 				        </div> -->
				        <div class="main_container_divider without_margin"></div>
				        <div class="electronic_estimator_button_container_wrapper">
				            <!-- <button type="button" class="electronic_estimator_button_white invisible">
				                <p class="button_white_typo">수정요청</p>
				            </button> -->
				            <div class="electronic_estimator_button_container" style="margin-left: auto;">
				                <a href="javascript:void(0)" class="electronic_estimator_button_white" data-bs-dismiss="modal">
				                    <p class="button_white_typo">취소</p>
				                </a>
				                <a href="javascript:void(0)" class="electronic_estimator_button_blue" onclick="fnSave();">
				                    <p class="button_blue_typo">보내기</p>
				                </a>
				            </div>
				        </div>
    					</div>
				    </div>
				  </div>
				</div>
				<!-- 전자견적서 보내기 modal end -->
				
				<!-- 받은 견적서 보기 modal -->
				<div class="modal fade" id="estimatorViewModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
				  <div class="modal-dialog modal-dialog-centered">
				    <div class="modal-content" style="width: fit-content;">
						  <div class="cad_container">
				        <div class="dialog_header">
				         	<p class="dialog_header_typo">
				          	CAD 견적서 보기
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
										<p id="viewDeliveryPosDateTypo" class="dialog_item_context_typo">
										</p>
									</div>
				        </div>
				        <div class="main_container_divider without_margin"></div>
				        <div class="cad_estimator_dialog_item_column">
									<div class="dialog_item_title cad_title">
										<p class="dialog_item_title_typo">
											금액
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
														보철종류
													</p>
												</div>
												<div class="prosthetics_type_data_type_divider"></div>
												<div class="prosthetics_type_data_type">
													<p class="prosthetics_type_data_type_typo">
														개수
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
												<p class="dialog_item_context_typo total_price">총 금액</p>
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
											구동가능한 CAD S/W
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
											사진 업로드
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
				        <div class="button_container">
									<a href="javascript:void(0)" class="button_white" onclick="fnDeleteEstimator();">
										<p class="button_white_typo">견적서 삭제하기</p>
									</a>
									<a href="javascript:void(0)" class="button_blue" onclick="fnMatching();">
									  <p class="button_blue_typo">매칭하기</p>
									</a>
				        </div>
				    	</div>
				    </div>
				  </div>
				</div>
				<!-- 받은 견적서 보기 modal end -->
                
		</div>
	</div>
	</form:form>
</div>


<div class="modal fade" id="supplementViewModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="width: fit-content;">
      <div class="project_request_view_container">
        <div class="project_request_view_header">
          <p class="project_request_view_header_typo">보철종류</p>
          <a href="javascript:void(0);" data-bs-dismiss="modal" aria-label="Close">
            <img class="project_request_view_close_button" src="/public/assets/images/dialog_close_button.svg"/>
          </a>
        </div>
        <div class="project_request_view_body">
          <div class="project_request_request_container">
            <div class="project_request_request">
              <p class="project_request_request_title">의뢰서1</p>
              <p class="project_request_request_context">지르코니아 2개, 인레이 1개</p>
            </div>
            <div class="list_divider"></div>
            <div class="project_request_request">
              <p class="project_request_request_title">의뢰서2</p>
              <p class="project_request_request_context">크라운 1개, 인레이 2개</p>
            </div>
            <div class="list_divider"></div>
          </div>
          <div class="dotted_divider_container">
            <img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
            <img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
          </div>
          <div class="prosthetics_type_container">
            <div class="prosthetics_type_data_type_container">
              <div class="prosthetics_type_data_type">
                <p class="prosthetics_type_data_type_typo">보철종류</p>
              </div>
              <div class="prosthetics_type_data_type_divider"></div>
              <div class="prosthetics_type_data_type">
                <p class="prosthetics_type_data_type_typo">개수</p>
              </div>
            </div>
            <div id="supplementListDiv"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
