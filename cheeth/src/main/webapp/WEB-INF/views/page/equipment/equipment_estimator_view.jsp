<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
   alert(getI8nMsg("alert.plzlogin"));
   location.href = '/api/login/view';
</script>
</c:if>

<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>
<link type="text/css" rel="stylesheet" href="/public/assets/css/modal.css"/>

<script>
	function confirmModal() {
	  if (window.confirm(getI8nMsg("alert.confirm.moveToEnter"))) {
	    location.href = ('/api/mypage/my_page_edit_info');
	  } else {
		  
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
	
	function fnAddMatchingDtl() {
		var html = '';
		html += '<div class="send_estimator_dialog_item_context dtl_context">';
    html += '  <div class="dialog_item_context_calculate_price_wrapper without_margin">';
    html += '    <div class="dialog_item_context_calculate_price without_margin">';
    html += '      <input class="send_estimator_dialog_item_context_blank_direct_input" name="ARTICLE_NM" maxlength="50" placeholder="보철종류"/>';
    html += '      <input class="send_estimator_dialog_item_context_blank_price unit_price" name="UNIT_PRICE" maxlength="20" onkeyup="fnCalculate();" placeholder="단가"/>';
    html += '      <p class="operator">X</p>';
    html += '      <input class="send_estimator_dialog_item_context_blank_count amount" name="AMOUNT" maxlength="5" onkeyup="fnCalculate();" placeholder="갯수"/>';
    html += '      <p class="operator">=</p>';
    html += '      <div class="dialog_item_context_typo_container price_area">';
    html += '        <p class="dialog_item_context_typo price_num">0</p>';
    html += '        <p class="dialog_item_context_typo">원</p>';
    html += '      </div>';
    html += '      <button type="button" onclick="fnDeleteMatchingDtl(this);" style="background: transparent;">';
    html += '      	<img class="price_close_button" src="/public/assets/images/dialog_blue_close_button.svg"/>';
    html += '      </button>';
    html += '    </div>';
    html += '  </div>';
    html += '</div>';
    $('#dtl_container').append(html);
	}
	
	function fnDeleteMatchingDtl() {
		var btnElm = arguments[0];
		$(btnElm).parents('.dtl_context').remove();
	}
	
	function fnCalculate() {
		var input = event.target;
		var value = input.value;
		var sumAmount;
		
		var regCheck = /^[0-9]*$/g;
		if(!regCheck.test(value)) {
			alert(getI8nMsg("alert.onlyNum"));//숫자만 입력 가능합니다.
			input.value = '';
		} else {
			sumAmount = value;
			$(input).siblings('.unit_price, .amount').each(function() {
				sumAmount *= $(this).val();
			});
			$(input).siblings('.price_area').find('.price_num').text(sumAmount);
		}
	}
	
	const MAX_UPLOAD_CNT = 10;
	const defaultImgSrc = '/public/assets/images/profile_image.svg';
	
	var uploadImgArr = new Array();
	
	function previewImage() {
		if(uploadImgArr.length >= MAX_UPLOAD_CNT) {
			alert(getI8nMsg("alert.param.uploadPhoto", null, MAX_UPLOAD_CNT)); //'최대 ' +  + '장까지 업로드 가능합니다.'
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
					const target = $('.send_estimator_sub_pic_upload').eq(uploadImgArr.length-1);
					target.addClass('active');
					target.css('background-image', 'url(' + imageSrc + ')')
					target.append('<img class="electronic_estimator_pic_attatchment_remove_button" src="/public/assets/images/dialog_close_button.svg" onclick="removeImage(this);"/>');
				};
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
		
		$('.send_estimator_sub_pic_upload').each(function(index, item) {
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
		  alert(getI8nMsg("alert.selectDtnV"));//선택한 일자가 올바르지 않습니다
	    return;
	  }
	  
	  if([...document.querySelectorAll('input[name=ARTICLE_NM]')].some(s => isEmpty(s.value))) {
		  alert(getI8nMsg("alert.enterProsth"));//보철종류를 입력해주세요.
		  return;
	  }
	  if([...document.querySelectorAll('input[name=UNIT_PRICE]')].some(s => isEmpty(s.value))) {
		  alert(getI8nMsg("alert.enterUnit"));//단가를 입력해주세요.
		  return;
	  }
	  if([...document.querySelectorAll('input[name=AMOUNT]')].some(s => isEmpty(s.value))) {
		  alert(getI8nMsg("alert.enterNum"));//갯수를 입력해주세요.
		  return;
	  }
	  
	  uploadImgArr.map(m => { formData.append('files', m.FILE); });
	  formData.append('fileDiv', JSON.stringify('EQUIPMENT_ESTIMATOR'));
	  
	  var dtlInfo = new Array();
	  
	  $('.dtl_context').each(function() {
		  var obj = new Object();
		  obj['ARTICLE_NM'] = $(this).find('input[name=ARTICLE_NM]').val();
		  obj['UNIT_PRICE'] = $(this).find('input[name=UNIT_PRICE]').val();
		  obj['AMOUNT'] = $(this).find('input[name=AMOUNT]').val();
		  obj['SUM_AMOUNT'] = $(this).find('.price_area p.price_num').text();
		  dtlInfo.push(obj);
	  });
		formData.append('dtlInfo', JSON.stringify(dtlInfo));
	  
		if(confirm(getI8nMsg("alert.confirm.save"))) { //저장하시겠습니까?
		  $.ajax({
			  url: '/' + API + '/equipment/save02',
			  type: 'POST',
			  data: formData,
			  cache: false,
			  async: false,
			  contentType: false,
			  processData: false,
			  success: function(data) {
				  if(data.result == 'Y') {
					  alert(getI8nMsg("alert.sent"));//발송되었습니다.
					  estimatorModal.hide();
					  location.reload();
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
	
	function fnCloseEstimatorModal() {
	  
	  // 납품가능시간 초기화
	  $('#YYYY_DIV_2, #MM_DIV_2, #DD_DIV_2, #TTMM_DIV_2').addClass('hidden');
	  
	  $('#YYYY_DIV_1').find('p').html('YYYY');
	  $('#MM_DIV_1').find('p').html('MM');
	  $('#DD_DIV_1').find('p').html('DD');
	  $('#TTMM_DIV_1').find('p').html('TT:MM');
	  
	  $('input[id^=DIALOG_]').val('');
	  
	  $('.dtl_context:gt(0)').remove();
	  $('.dtl_context:eq(0)').find('input').val('');
	  $('.dtl_context:eq(0)').find('.price_area .price_num').text('0');
	  
	  $('#AS_INFO, #DTL_CONTENT').val('');
	  
	  // 이미지 초기화
	  uploadImgArr = [];
	  $('#mainPicImage').attr('src', defaultImgSrc);
	  $('.send_estimator_sub_pic_upload').each(function(index, item) {
			$(item).removeClass('active');
			$(item).css('background-image', '');
			$(item).find('.electronic_estimator_pic_attatchment_remove_button').remove();
		});
	}
	
	function fnViewEstimators() {
	  
		fnGetEstimators();
	}
	  
	var estimatorArr = new Array();
	  
	function fnGetEstimators() {
	  var eqNo = '${DATA.EQ_NO}';
	  
	  $.ajax({
	    url: '/' + API + '/equipment/getEstimators',
	    type: 'GET',
	    data: { EQ_NO : eqNo },
	    cache: false,
	    async: false,
	    success: function(data) {
	 	 		estimatorArr = data.estimatorList;
		 	 	if(isEmpty(estimatorArr)) {
		 	 		alert(getI8nMsg("alert.quoteNotExi"));//받은 견적서가 존재하지 않습니다.
		 	 		estimatorViewModal.hide();
		 	 	} else {
		 	 		//$('#nick_p_1').html(data.estimatorList[0].USER_NICK_NAME);
		 	 		fnSetEstimator(0);
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
	
		$('.equipment_estimator_pagination').html(btnHtml);
	}
	  
	var currEstimator;
	  
	function fnSetEstimator() {
		var index = arguments[0];
		currEstimator = estimatorArr[index];
		
		$('#viewDeliveryPosDateTypo').text(currEstimator['DELIVERY_POS_DATE']);
		
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
		
		currEstimator.fileList.map((m, i) => {
			m.FILE_DIRECTORY = m.FILE_DIRECTORY.replace(/\\/g, '\/');
		 	const target = $('.dialog_item_context_pic_upload').eq(i);
			target.css('background-image', "url('/upload/" + m.FILE_DIRECTORY + "')");
		});
		$('.dialog_item_context_pic_upload:gt(' + (currEstimator.fileList.length - 1) + ')').css('background-image', '');
		
		fnSetEstimatorPageInfo(index);
		
		// 치자이너 정보 변경
		//$('#nick_p_1').html(currEstimator.USER_NICK_NAME);
	}
	
	function fnDeleteEstimator() {
		if(confirm(getI8nMsg("alert.confirm.delete"))) { //삭제하시겠습니까?
		  $.ajax({
			  url: '/' + API + '/equipment/deleteEstimator',
			  type: 'POST',
			  data: { MATCHING_NO : currEstimator['MATCHING_NO'] },
			  cache: false,
			  async: false,
			  success: function(data) {
		    	if(data.result == 'Y') {
		    		alert(getI8nMsg("alert.delete"));//삭제되었습니다.
		    		fnGetEstimators();
		    	}
		    }, complete: function() {
		      
		    }, error: function() {
		      
		    }
		  });
		}
	}
	
	function fnMatching() {
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
	    		//location.href = '/' + API + '/contract/project_electronic_contract?ESTIMATOR_NO=' + estimatorNo;
	    		alert(getI8nMsg("alert.save"));//저장되었습니다.
	    		estimatorViewModal.hide();
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
	
	function fnEquipmentDelete() {
   
  	var isConfirm = window.confirm(getI8nMsg("alert.confirm.delete")); //삭제하시겠습니까?
	  if(!isConfirm) return;
	  
	  $.ajax({
	    url: '/' + API + '/equipment/delete01',
	    type: 'POST',
	    data: { EQ_NO : '${DATA.EQ_NO}' },
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
	  var url = '/' + API + '/equipment/equipment_estimator_writing';
	  url += '?EQ_NO=${DATA.EQ_NO}';
	  //url += '&GCS=${DATA.GCS}';
	  //url += '&REQS=${DATA.REQS}';
	  location.href = url;
	}
	  
	function fnAllView() {
		location.href = '/' + API + '/equipment/equipment_estimator_list';
	}

	var estimatorModal;
	var estimatorViewModal;
	
	$(function() {
		fnDateDialogSearch();
		
		$('#imaageUploadTypo').click(function() {
	  	$('input[id=IMG_FILE]').trigger('click');
		});
		
		$('.send_estimator_sub_pic_upload').on('click', function() {
			if($(this).hasClass('active')) {
				const elIndex = $('.send_estimator_sub_pic_upload').index($(this));
				$('#mainPicImage').attr('src', uploadImgArr[elIndex]['IMG_SRC']);
			}
		});

		estimatorModal = new bootstrap.Modal(document.getElementById('estimatorModal'));
		estimatorViewModal = new bootstrap.Modal(document.getElementById('estimatorViewModal'));
		
		var estimatorModalEl = document.getElementById('estimatorModal');
		estimatorModalEl.addEventListener('hidden.bs.modal', function(e) {
			fnCloseEstimatorModal();
		});
		
	});
</script>

<div class="equipment_estimator_header">
	<p class="equipment_estimator_header_typo">
		<spring:message code="main.dentalequipm" text="치과 / 치과기공 장비 견적소" />
	</p>
</div>
    <div class="equipment_estimator_body">
        <div class="side_menu">
            <div class="side_menu_title" style="cursor: pointer;" onclick="fnAllView();">
                <p class="side_menu_title_typo">
                    <spring:message code="main.seeAll" text="전체보기" />
                </p>
            </div>
            <c:forEach var="item" items="${EQ_CD_LIST}" varStatus="status">
            	<c:if test="${item.CODE_CD eq SEARCH_EQ_CD}">
	            	<c:set var="SEARCH_EQ_NM" value="${item.CODE_NM}"/>
            	</c:if>
              <a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=${item.CODE_CD}" class="side_menu_list">
                <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                <p class="side_menu_list_typo${item.CODE_CD eq SEARCH_EQ_CD ? '_blue' : ''}">${item.CODE_NM}</p>
              </a>
            </c:forEach>
        </div>
        <form:form id="saveForm" name="saveForm">
        	<input type="hidden" id="EQ_NO" name="EQ_NO" value="${DATA.EQ_NO}">
        
        <div class="equipment_estimator_main_container">
            <div class="equipment_estimator_connection_location_container">
                <a href="./main.html" class="equipment_estimator_connection_location_typo">
                    <img class="equipment_estimator_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
                </a>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo"><spring:message code="main.dentalequipm" text="치과 / 치과기공 장비 견적소" /></p>
                </div>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo_bold">
	                    <c:if test="${SEARCH_EQ_NM eq null }">
	                    	<spring:message code="main.seeAll" text="전체보기" />
	                    </c:if>
	                    <c:if test="${SEARCH_EQ_NM ne null }">
	                    	${SEARCH_EQ_NM}
	                    </c:if>
                    </p>
                </div>
            </div> 
            <div class="equipment_estimator_view_info_button_container equipment_estimator_view_below_button">
            	<c:if test="${CNT04 eq 0}">
					      <c:if test="${DATA.CREATE_ID eq sessionInfo.user.USER_ID}">
					        <a href="javascript:fnModify()" class="equipment_estimator_view_info_button_edit">
	                	<p class="equipment_estimator_view_info_button_edit_typo"><spring:message code="edit" text="수정" /></p>
	                </a>
	                <a href="javascript:fnEquipmentDelete()" class="equipment_estimator_view_info_button_delete">
	                	<p class="equipment_estimator_view_info_button_delete_typo"><spring:message code="delete" text="삭제" /></p>
	                </a>
					      </c:if>
					    </c:if>
            </div>
            <div class="connection_location_divider"></div>
            <div class="equipment_estimator_view_info_wrapper">
                <div class="equipment_estimator_view_info_sub_container">
                    <div class="equipment_estimator_view_info_title">
                        <p class="equipment_estimator_view_info_title_typo">${DATA.TITLE}</p>
                    </div>
                    <div class="equipment_estimator_view_info_etc_container">
                        <div class="equipment_estimator_view_info_etc">
                            <p class="equipment_estimator_view_info_etc_typo">
                                <spring:message code="proj.board" text="게시판" />: ${DATA.EQ_CD_NM}
                            </p>
                        </div>
                        <div class="equipment_estimator_view_info_etc">
                            <p class="equipment_estimator_view_info_etc_typo">
                                <spring:message code="equ.preparDt" text="작성일" /> : ${DATA.CREATE_DATE}
                            </p>
                        </div>
                        <div class="equipment_estimator_view_info_etc">
                            <p class="equipment_estimator_view_info_etc_typo">
                                <spring:message code="proj.views" text="조회수" /> : ${DATA.HITS_COUNT}
                            </p>
                        </div>
                    </div>
                </div>
                <div class="equipment_estimator_view_info_main_container">
                    <div class="main_container_divider divider_without_margin"></div>
                    <div class="equipment_estimator_view_info_item_container">
                        <div class="equipment_estimator_view_info_item">
                            <div class="equipment_estimator_view_info_item_title">
                                <p class="equipment_estimator_view_info_item_title_typo">
                                    <spring:message code="equ.brand" text="브랜드" />
                                </p>
                            </div>
                            <div class="equipment_estimator_view_info_item_context">
                                <p class="equipment_estimator_view_info_item_context_typo">
                                    ${DATA.BRAND_NM}
                                </p>
                            </div>
                        </div>
                        <div class="equipment_estimator_view_info_item">
                            <div class="equipment_estimator_view_info_item_title">
                                <p class="equipment_estimator_view_info_item_title_typo">
                                    <spring:message code="equ.equ" text="장비이름" />
                                </p>
                            </div>
                            <div class="equipment_estimator_view_info_item_context">
                                <p class="equipment_estimator_view_info_item_context_typo">
                                    ${DATA.EQ_NM}
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="equipment_estimator_view_info_item_container">
                        <div class="equipment_estimator_view_info_item">
                            <div class="equipment_estimator_view_info_item_title">
                                <p class="equipment_estimator_view_info_item_title_typo">
                                    <spring:message code="proj.quot" text="견적수" />
                                </p>
                            </div>
                            <div class="equipment_estimator_view_info_item_context">
                                <p class="equipment_estimator_view_info_item_context_typo">
                                    ${DATA.EQ_CNT}
                                </p>
                            </div>
                        </div>
                        <div class="equipment_estimator_view_info_item">
                            <div class="equipment_estimator_view_info_item_title">
                                <p class="equipment_estimator_view_info_item_title_typo">
                                    <spring:message code="proj.region" text="지역" />
                                </p>
                            </div>
                            <div class="equipment_estimator_view_info_item_context">
                                <p class="equipment_estimator_view_info_item_context_typo">
                                    ${DATA.AREA_NM}
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="equipment_estimator_view_info_item_container">
                        <div class="equipment_estimator_view_info_item">
                            <div class="equipment_estimator_view_info_item_title">
                                <p class="equipment_estimator_view_info_item_title_typo">
                                    <spring:message code="equ.preparDt" text="작성일" />
                                </p>
                            </div>
                            <div class="equipment_estimator_view_info_item_context">
                                <p class="equipment_estimator_view_info_item_context_typo">
                                    ${DATA.CREATE_DATE}
                                </p>
                            </div>
                        </div>
                        <div class="equipment_estimator_view_info_item">
                            <div class="equipment_estimator_view_info_item_title">
                                <p class="equipment_estimator_view_info_item_title_typo">
                                    <spring:message code="equ.estimReq" text="견적요청 만료시간" />
                                </p>
                            </div>
                            <div class="equipment_estimator_view_info_item_context">
                                <p class="equipment_estimator_view_info_item_context_typo">
                                    ${DATA.EQ_EXP_DATE}
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="main_container_divider light divider_without_margin"></div>
                    <div class="equipment_estimator_view_info_detail">
                        <p class="equipment_estimator_view_info_detail_typo">
                            ${DATA.ADD_CONTENT}
                        </p>
                        <c:if test="${not empty IMG_FILE_LIST}">
                        	<div id="imageSlider" class="carousel slide qna_writing_image_slider_wrapper" data-bs-ride="carousel">
											      <div class="carousel-indicators">
											      	<c:forEach items="${IMG_FILE_LIST}" var="item" varStatus="vs">
											      		<button type="button" data-bs-target="#imageSlider" data-bs-slide-to="${vs.index}" ${vs.index eq 0 ? 'class="active" aria-current="true"' : ''} aria-label="Slide ${vs.count}"></button>
											      	</c:forEach>
													  </div>
													  <div class="carousel-inner h-100">
													  	<c:forEach items="${IMG_FILE_LIST}" var="item" varStatus="vs">
											      		<div class="carousel-item w-100 h-100 ${vs.index eq 0 ? 'active' : ''}">
														      <img src="/upload/${item.FILE_DIRECTORY}" class="d-block" alt="${item.FILE_ORIGIN_NM}">
														    </div>
											      	</c:forEach>
													  </div>
													  <button class="carousel-control-prev" type="button" data-bs-target="#imageSlider" data-bs-slide="prev">
													    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
													    <span class="visually-hidden">Previous</span>
													  </button>
													  <button class="carousel-control-next" type="button" data-bs-target="#imageSlider" data-bs-slide="next">
													    <span class="carousel-control-next-icon" aria-hidden="true"></span>
													    <span class="visually-hidden">Next</span>
													  </button>
													</div>
                        </c:if>
                        <div class="main_container_divider"></div>
                    </div>            
                </div>
                
                <div class="equipment_estimator_view_info_button_container">
                    <div class="equipment_estimator_view_info_button_right">
                    <c:choose>
                   <c:when test="${sessionInfo.user.USER_TYPE_CD eq 1 and !empty sessionInfo.user.COMP_FILE_CD}">
                   	     <c:if test="${CNT04 eq 0}">
			              <c:if test="${not empty sessionInfo.user and DATA.CREATE_ID ne sessionInfo.user.USER_ID}">
			                <a href="#estimatorModal" class="equipment_estimator_view_info_button_right_submit" data-bs-toggle="modal">
	                       		<p class="equipment_estimator_view_info_button_right_submit_typo"><spring:message code="proj.sendQuot" text="견적 보내기" /></p>
	                       	</a>
			              </c:if>
			              <c:if test="${DATA.CREATE_ID eq sessionInfo.user.USER_ID}">
			                <a href="javascript:fnViewEstimators();" class="project_request_button white">
			                  <p class="project_request_button_typo white_typo"><spring:message code="proj.viewQuot" text="받은 견적서 보기" /></p>
			                </a>
			              </c:if>
			            </c:if>
                   </c:when>
                   <c:when test="${sessionInfo.user.USER_TYPE_CD eq 1 and empty sessionInfo.user.COMP_FILE_CD}">
					  <a href="javascript:confirmModal()" class="project_request_button blue">
                        <p class="project_request_button_typo blue"><spring:message code="proj.sendQuot" text="견적서 보내기" /></p>
                      </a>
                   </c:when>
                   <c:otherwise>

			        </c:otherwise>
			        </c:choose>
                      	<a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=${SEARCH_EQ_CD}" class="equipment_estimator_view_info_button_right_list">
                        	<p class="equipment_estimator_view_info_button_right_list_typo"><spring:message code="list" text="목록" /></p>
                        </a>
                    </div>
                </div>
                
                <!-- 장비 견적서 보내기 modal -->
								<div class="modal fade" id="estimatorModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
								  <div class="modal-dialog modal-dialog-centered">
								    <div class="modal-content" style="width: fit-content;">
										  <div class="send_estimator_container">
									        <div class="dialog_header">
									            <p class="dialog_header_typo">
									            	<spring:message code="equ.sendEquQuo" text="장비 견적서 보내기" />
									            </p>
									            <a href="javascript:void(0)" class="dialog_close_button_wrapper" data-bs-dismiss="modal" aria-label="Close">
									            	<img class="dialog_close_button" src="/public/assets/images/dialog_close_button.svg"/>
									            </a>
									        </div>
									        <div class="send_estimator_dialog_item">
									            <div class="send_estimator_dialog_item_title wide">
									                <p class="dialog_item_title_typo">
									                    <spring:message code="proj.delivTm" text="납품가능시간" />
									                </p>
									                <p class="send_estimator_dialog_item_sub_title">
									                    납품까지 소요시간이 아닌 예상 날짜와 시간을 입력하세요
									                </p>
									            </div>
									            <div class="send_estimator_dialog_item_context_container">
									            	<div class="select_button_container" style="height: 38px;">
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
									        <div class="main_container_divider without_margin"></div>
									        <div class="send_estimator_dialog_item">
									          <div class="send_estimator_dialog_item_title">
									            <p class="dialog_item_title_typo">금액</p>
									            <p class="send_estimator_dialog_item_sub_title">항목 직접 작성</p>
									          </div>
									          <div id="dtl_container" class="send_estimator_dialog_item_context_container">
									            <div class="send_estimator_dialog_item_context dtl_context">
									              <div class="dialog_item_context_calculate_price_wrapper without_margin">
									                <div class="dialog_item_context_calculate_price without_margin">
									                  <input class="send_estimator_dialog_item_context_blank_direct_input" name="ARTICLE_NM" maxlength="50" placeholder="항목 직접 작성"/>
									                  <input class="send_estimator_dialog_item_context_blank_price unit_price" name="UNIT_PRICE" maxlength="20" onkeyup="fnCalculate();" placeholder="단가"/>
									                  <p class="operator">X</p>
									                  <input class="send_estimator_dialog_item_context_blank_count amount" name="AMOUNT" maxlength="5" onkeyup="fnCalculate();" placeholder="갯수"/>
									                  <p class="operator">=</p>
									                  <div class="dialog_item_context_typo_container price_area">
									                    <p class="dialog_item_context_typo price_num">0</p>
									                    <p class="dialog_item_context_typo">원</p>
									                  </div>
									                  <!-- <button type="button" onclick="fnDeleteMatchingDtl(this);" style="background: transparent;">
									                  	<img class="price_close_button" src="/public/assets/images/dialog_blue_close_button.svg"/>
									                  </button> -->
									                </div>
									              </div>
									              <button class="send_estimator_price_add_button" type="button" onclick="fnAddMatchingDtl();">
									                <p class="price_add_button_typo">+</p>
									              </button>
									            </div>
									          </div>
									        </div>
									        <div class="main_container_divider without_margin"></div>
									        <div class="send_estimator_dialog_item">
										        <div class="send_estimator_dialog_item_title">
											        <p class="dialog_item_title_typo">
																A/S 정보
											        </p>
										        </div>
										        <div class="send_estimator_dialog_item_context_container">
										        	<textarea class="send_estimator_dialog_item_context_blank" id="AS_INFO" name="AS_INFO" placeholder="정보를 작성해 주세요"></textarea>
										        </div>
									        </div>
									        <div class="main_container_divider without_margin"></div>
									        <div class="send_estimator_dialog_item">
										        <div class="send_estimator_dialog_item_title">
										          <p class="dialog_item_title_typo">
										          	상세설명
										          </p>
										        </div>
										        <div class="send_estimator_dialog_item_context_container">
										        	<textarea class="send_estimator_dialog_item_context_blank high" id="DTL_CONTENT" name="DTL_CONTENT" placeholder="상세내용을 적어주세요"></textarea>
										        </div>
									        </div>
									        <div class="main_container_divider without_margin"></div>
									        <div class="send_estimator_dialog_item_column">
									          <div class="send_estimator_dialog_item_title">
									            <p class="dialog_item_title_typo">
									            	<spring:message code="equ.upload" text="사진 업로드" />
									            </p>
									            <p class="send_estimator_dialog_item_sub_title">
									            	<spring:message code="talk.fileUpload" text="최대 10장까지 업로드 가능합니다." />
									            </p>
									          </div>
									          <div class="send_estimator_pic_upload_wrapper">
									            <div class="send_estimator_pic_upload_container">
									              <div class="send_estimator_main_pic_upload_wrapper">
									              	<img id="mainPicImage" class="send_estimator_main_pic_upload" src="/public/assets/images/profile_image.svg" style="width: 100%; height: 100%;" />
									              </div>
									            </div>
									            <button id="imaageUploadTypo" class="send_estimator_upload_button" type="button">
									            	<p class="send_estimator_upload_button_typo"><spring:message code="equ.upload" text="이미지 업로드" /></p>
									            </button>
									            <input type="file" name="IMG_FILE" id="IMG_FILE" onchange="previewImage();" style="display: none;"/>
									          </div>
									        </div>
									        <div class="send_estimator_sub_pic_upload_wrapper">
									            <div class="send_estimator_sub_pic_upload_container">
									                <div class="send_estimator_sub_pic_upload"></div>
									                <div class="send_estimator_sub_pic_upload"></div>
									                <div class="send_estimator_sub_pic_upload"></div>
									                <div class="send_estimator_sub_pic_upload"></div>
									                <div class="send_estimator_sub_pic_upload"></div>
									            </div>
									            <div class="send_estimator_sub_pic_upload_container">
									                <div class="send_estimator_sub_pic_upload"></div>
									                <div class="send_estimator_sub_pic_upload"></div>
									                <div class="send_estimator_sub_pic_upload"></div>
									                <div class="send_estimator_sub_pic_upload"></div>
									                <div class="send_estimator_sub_pic_upload"></div>
									            </div>
									        </div>
									        <div class="main_container_divider without_margin"></div>
									        <div class="button_container">
									            <a href="javascript:void(0)" class="button_white" data-bs-dismiss="modal">
									            	<p class="button_white_typo">
									              	<spring:message code="cancel" text="취소" />
									              </p>
									            </a>
									            <a href="javascript:fnSave();" class="button_blue">
									                <p class="button_blue_typo">
									                	<spring:message code="send" text="보내기" />
									                </p>
									            </a>
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
								<!-- 장비 견적서 보내기 modal end -->
								
								<!-- 받은 견적서 보기 modal -->
								<div class="modal fade" id="estimatorViewModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
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
								                <p id="viewDeliveryPosDateTypo" class="dialog_item_context_typo"></p>
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
								                    <div class="dialog_item_context_pic_upload_container">
								                        <div class="dialog_item_context_pic_upload"></div>
								                        <div class="dialog_item_context_pic_upload"></div>
								                    </div>
								                    <div class="dialog_item_context_pic_upload_container">
								                        <div class="dialog_item_context_pic_upload"></div>
								                        <div class="dialog_item_context_pic_upload"></div>
								                    </div>
								                    <div class="dialog_item_context_pic_upload_container">
								                        <div class="dialog_item_context_pic_upload"></div>
								                        <div class="dialog_item_context_pic_upload"></div>
								                    </div>
								                    <div class="dialog_item_context_pic_upload_container">
								                        <div class="dialog_item_context_pic_upload"></div>
								                        <div class="dialog_item_context_pic_upload"></div>
								                    </div>
								                    <div class="dialog_item_context_pic_upload_container">
								                        <div class="dialog_item_context_pic_upload"></div>
								                        <div class="dialog_item_context_pic_upload"></div>
								                    </div>
								                </div>
								            </div>
								        </div>
								        <div class="button_container">
								            <a href="javascript:fnDeleteEstimator()" class="button_white">
								                <div class="button_white_typo">
								                    견적서 삭제하기
								                </div>
								            </a>
								            <a href="javascript:fnMatching()" class="button_blue">
								                <div class="button_blue_typo">
								                    매칭하기
								                </div>
								            </a>
								        </div>
								        <div class="pagination equipment_estimator_pagination" style="margin: 50px 0 20px;">
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
								<!-- 받은 견적서 보기 modal end -->
            </div>
        </div>
        </form:form>
    </div>