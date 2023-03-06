<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:if test="${empty sessionInfo.user}">
  <script>
  alert(getI8nMsg("alert.plzlogin"));
   location.href = '/api/login/view';
</script>
</c:if>
<c:if test="${sessionInfo.user.USER_TYPE_CD eq 1 && empty sessionInfo.user.COMP_FILE_CD}">
  <script>
   alert(getI8nMsg("alert.nhaveAccess"));//접근 권한이 없습니다.
   history.back();
</script>
</c:if>
<link type="text/css" rel="stylesheet" href="/public/assets/css/vanillajs-datepicker/datepicker.min.css">
<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>
<link type="text/css" rel="stylesheet" href="/public/assets/css/modal.css"/>
<script type="text/javascript" src="/js/vanillajs-datepicker/datepicker.min.js"></script>
<script type="text/javascript" src="/js/vanillajs-datepicker/locales/ko.js"></script>

<style>
  #datepickerInput,
  #datepickerInput::placeholder {
    color: #b6b6b6;
    font-size: 13px;
    font-weight: 400;
    width: 147px;
    height: 100%;
    margin-left: 15px;
  }
  .datepicker button {
    color: #363636 !important;
  }
</style>

<script>

	function fnAllView() {
    location.href = '/' + API + '/equipment/equipment_estimator_list';
  }

	function fnSetEqmtExpDate() {
    $('#EQ_EXP_DATE').val(arguments[0]);
    $('.equipment_estimator_writing_info_date_expiry_typo').html(arguments[1]);
  }
	
	function fnSelect_3() {
	  var code = arguments[0];
	  var codeNm = arguments[1];
	  var target = $('#TIME_CD_DIV_2');
	  if(target.hasClass('hidden')) {
	    target.removeClass('hidden');
	  } else {
	    target.addClass('hidden');
	  } 
	  
	  if(isNotEmpty(code)) {
	    $('#TIME_CD_DIV_1').find('p').html(codeNm);
	    $('#DELIVERY_EXP_DATE_2').val(code);
	  }
	}
	
	const MAX_UPLOAD_CNT = 10;
	const defaultImgSrc = '/public/assets/images/profile_image.svg';
	
	var uploadImgArr = new Array();
	var realUploadImgArr = new Array();
	
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
					const target = $('.qna_pic_attatchment_sub_pic_upload').eq(uploadImgArr.length-1);
					target.addClass('active');
					target.css('background-image', 'url(' + imageSrc + ')')
					target.append('<img class="qna_pic_attatchment_remove_button" src="/public/assets/images/dialog_close_button.svg" onclick="removeImage(this);"/>');
				};
			}
		}
	}
	console.log("uploadImgArr " + uploadImgArr);
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
		
		$('.qna_pic_attatchment_sub_pic_upload').each(function(index, item) {
			if(uploadImgArr[index]) {
				$(item).css('background-image', 'url(' + uploadImgArr[index]['IMG_SRC'] + ')');
			} else {
				$(item).removeClass('active');
				$(item).css('background-image', '');
				$(item).find('.qna_pic_attatchment_remove_button').remove();
			}
		});
		event.stopPropagation();
	}
	
	function fnUpload() {
		
		realUploadImgArr = [...uploadImgArr];
		
		if(isEmpty(realUploadImgArr)) {
			inactiveImageSlider();
		} else {
			activeImageSlider();
		}
	}
	
	function cleanImageSlider() {
		$('.carousel-indicators').find('button').remove();
		$('.carousel-inner').find('.carousel-item').remove();
	}
	
	function activeImageSlider() {
		cleanImageSlider();
		$('#imageSlider').removeClass('hidden');
		
		realUploadImgArr.map((m, i) => {
			var innerHTML = '';
			innerHTML += '<button type="button" data-bs-target="#imageSlider" data-bs-slide-to="' + i + '"';
			innerHTML += (i == 0 ? ' class="active" ' : '') + 'aria-current="true" aria-label="Slide ' + (i+1) + '"></button>';
			$('#imageSlider > .carousel-indicators').append(innerHTML);
			
			innerHTML = '';
			innerHTML += '<div class="carousel-item w-100 h-100' + (i == 0 ? ' active' : '') + '">';
			innerHTML += '	<img src="'+ m.IMG_SRC +'" class="d-block" alt="' + m.FILE.name + '">';
			innerHTML += '</div>';
			$('#imageSlider > .carousel-inner').append(innerHTML);
		});
	}
	
	function inactiveImageSlider() {
		cleanImageSlider();
		$('#imageSlider').addClass('hidden');
	}
	
	function closePicAttachModal() {
		uploadImgArr = [];
		$('#mainPicImage').attr('src', defaultImgSrc);
		$('.qna_pic_attatchment_sub_pic_upload').removeClass('active');
		$('.qna_pic_attatchment_sub_pic_upload').css('background-image', '');
		$('.qna_pic_attatchment_sub_pic_upload').find('.qna_pic_attatchment_remove_button').remove();
	}
	
	function fnSave() {
		
		if(validate()) {
		 	var formData = new FormData(document.getElementById('saveForm'));
		 	for(var key of formData.keys()) {
		 		formData.set(key, JSON.stringify(formData.get(key)));
		 	}
		 	
		 	const content = $('#ADD_CONTENT').val().replace(/(\n|\r|\n)/g, '<br>');
		 	formData.set('ADD_CONTENT', JSON.stringify(content));
			realUploadImgArr.map(m => { formData.append('files', m.FILE); });
			formData.append('fileDiv', JSON.stringify('EQUIPMENT'));
			if(okbool == 1){
		 	$.ajax({
		    url: '/' + API + '/equipment/save01',
		    type: 'POST',
		    data: formData,
		    cache: false,
		    async: false,
		    contentType: false,
			  processData: false,
		    success: function(data) {
				  if(data.result == 'Y') {
					  alert(getI8nMsg("alert.save"));//저장되었습니다.
					  fnAllView();
				  }else{
					  alert(getI8nMsg("alert.tryAgain"));//오류가 발생했습니다. 다시 시도해주세요.
				  }
		    }, complete: function() {
		    }, error: function() {
		    }
		  });
			}else{
				alert(getI8nMsg("alert.enterFuTime"));//미래시간을 입력하세요.
			}
		}else{
			
		}
	}
	function fnUpdate() {
		
		if(validate()) {
		 	var formData = new FormData(document.getElementById('saveForm'));
		 	for(var key of formData.keys()) {
		 		formData.set(key, JSON.stringify(formData.get(key)));
		 	}
		 	
		 	const content = $('#ADD_CONTENT').val().replace(/(\n|\r|\n)/g, '<br>');
		 	formData.set('ADD_CONTENT', JSON.stringify(content));
			realUploadImgArr.map(m => { formData.append('files', m.FILE); });
			formData.append('fileDiv', JSON.stringify('EQUIPMENT'));
			if(okbool == 1){
		 	$.ajax({
		    url: '/' + API + '/equipment/update05',
		    type: 'POST',
		    data: formData,
		    cache: false,
		    async: false,
		    contentType: false,
			  processData: false,
		    success: function(data) {
				  if(data.result == 'Y') {
					  alert(getI8nMsg("alert.save"));//저장되었습니다.
					  fnAllView();
				  }else{
					  alert(getI8nMsg("alert.tryAgain"));//오류가 발생했습니다. 다시 시도해주세요.
				  }
		    }, complete: function() {
		    }, error: function() {
		    }
		  });
			}else{
				alert(getI8nMsg("alert.enterFuTime"));//미래시간을 입력하세요.
			}
		}else{
			
		}
	}
	function validate() {
		var chkValid = [...document.querySelectorAll('.required')].some(s => {
			if(isEmpty(s.value) && s.id.includes('DELIVERY_EXP_DATE')) {
				if(isEmpty(document.getElementById('DELIVERY_EXP_DATE').value)) {
					alert(getI8nMsg("alert.param.plzEnter", null, '${s.title}')); //`\${s.title}을(를) 입력하세요.`
					return true;
				}
			} else {
				if(isEmpty(s.value)) {
					alert(getI8nMsg("alert.param.plzEnter", null, '${s.title}')); //`\${s.title}을(를) 입력하세요.`
					return true;
				}
			}
		});
		return !chkValid;
	}
	
	$(function() {
		
		const datepickerEl = document.querySelector('#datepickerInput');
	  const datepicker = new Datepicker(datepickerEl, {
	    language : 'ko',
	    format : 'yyyy-mm-dd',
	    autohide : true
	  });
	  
	  $('.equipment_estimator_calendar_image').click(function() {
	  	datepicker.show();
	  });
	  
	  datepickerEl.addEventListener('changeDate', function(e) {
	    var date = datepicker.getDate('yyyy-mm-dd');
	    $('input[id=DELIVERY_EXP_DATE_1]').val(date);
	    $("#date_for_chk").text(date);
	    CheckDate();
	  });
	  
	  if(isNotEmpty('${DATA.PROJECT_NO}')) {
	    $('#PROJECT_CD_DIV_1').find('p').html('${DATA.PROJECT_NM}');
	    $('#PUBLIC_CD_DIV_1').find('p').html('${DATA.PUBLIC_NM}');
	    $('.equipment_estimator_writing_info_date_expiry_typo').html('${DATA.PROJECT_EXP_DATE2}');
	    $('#TIME_CD_DIV_1').find('p').html('${DATA.DELIVERY_EXP_DATE3}');
	    
	    var preferNm1 = isEmpty('${DATA.PREFER_CD_NM_1}') ? '선택' : '${DATA.PREFER_CD_NM_1}';
	    var preferNm2 = isEmpty('${DATA.PREFER_CD_NM_2}') ? '선택' : '${DATA.PREFER_CD_NM_2}';
	    var preferNm3 = isEmpty('${DATA.PREFER_CD_NM_3}') ? '선택' : '${DATA.PREFER_CD_NM_3}';
	    var preferNm4 = isEmpty('${DATA.PREFER_CD_NM_4}') ? '선택' : '${DATA.PREFER_CD_NM_4}';
	    $('#PREFER_CD_DIV_1_1').find('p').html(preferNm1);
	    $('#PREFER_CD_DIV_2_1').find('p').html(preferNm2);
	    $('#PREFER_CD_DIV_3_1').find('p').html(preferNm3);
	    $('#PREFER_CD_DIV_4_1').find('p').html(preferNm4);
	    
	    $('input[id=DELIVERY_EXP_DATE_1]').val('${DATA.DELIVERY_EXP_DATE2}');
	    $('input[id=datepickerInput]').val('${DATA.DELIVERY_EXP_DATE2}');
	    
	    var publicCd = $('#PUBLIC_CD').val();
	    var appointUser = '${DATA.APPOINT_USER}';
	    if(publicCd === 'U001' && isNotEmpty(appointUser)) {
	  	  $('.quote_list').html('<p>' + appointUser + '</p>');
	      $('.quote_list').removeClass('hidden');
	    } else {
	      $('.quote_list').addClass('hidden');
	    }
	  }
	  
	  $('#imgUploadBtn').click(function() {
		  $('input[id=IMG_FILE]').trigger('click');
	  })
	  
	  $('.qna_pic_attatchment_sub_pic_upload').on('click', function() {
			if($(this).hasClass('active')) {
				const elIndex = $('.qna_pic_attatchment_sub_pic_upload').index($(this));
				$('#mainPicImage').attr('src', uploadImgArr[elIndex]['IMG_SRC']);
			}
		});
	  
	  var picAttachModalEl = document.getElementById('picAttachModal');
		picAttachModalEl.addEventListener('hidden.bs.modal', function() {
			closePicAttachModal();
		});
		
		picAttachModalEl.addEventListener('show.bs.modal', function() {
			uploadImgArr = [...realUploadImgArr];
		});
		
		picAttachModalEl.addEventListener('shown.bs.modal', function() {
			if(isNotEmpty(uploadImgArr)) {
				uploadImgArr.map((m, i) => {
					const target = $('.qna_pic_attatchment_sub_pic_upload').eq(i);
					target.addClass('active');
					target.css('background-image', 'url(' + m.IMG_SRC + ')')
					target.append('<img class="qna_pic_attatchment_remove_button" src="/public/assets/images/dialog_close_button.svg" onclick="removeImage(this);"/>');
				});
			}
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
              <a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=${item.CODE_CD}" class="side_menu_list">
                <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                <p class="side_menu_list_typo${item.CODE_CD eq DATA.EQ_CD ? '_blue' : ''}">${item.CODE_NM}</p>
              </a>
            </c:forEach>
        </div>
        <form:form id="saveForm" name="saveForm">
        <input type="hidden" name="FILE_CD" value="${DATA.FILE_CD}">
        <%-- <input type="hidden" name="EQ_NO" value="${DATA.EQ_NO}"> --%>
        <div id="date_for_chk" onchange="CheckDate()" style="opacity:0;position:absolute;z-index:-1;"></div>
        <input type="hidden" id="EQ_NO" name="EQ_NO" value="${DATA.EQ_NO}">
        <input type="hidden" id="EQ_EXP_DATE" name="EQ_EXP_DATE" class="required" value="${DATA.EQ_EXP_DATE}" title="견적요청 만료시간">
        <input type="hidden" id="DELIVERY_EXP_DATE" name="DELIVERY_EXP_DATE" value="${DATA.DELIVERY_EXP_DATE}">
		<input type="hidden" id="DELIVERY_EXP_DATE_1" class="required" onchange="CheckDate()" name="DELIVERY_EXP_DATE_1" value="" title="납품 마감 날짜">
		<input type="hidden" id="DELIVERY_EXP_DATE_2" class="required" name="DELIVERY_EXP_DATE_2" value="" title="납품 마감 시간">
        <script>
        $(document).ready(function(){
        	console.log("11 :: ${DATA.AREA_CD}");
        	/* 납품일 */
        	var DeliveryDate = "${DATA.DELIVERY_EXP_DATE}";
        	var del_date1 = "";
        	var del_Time = "";
        	if(DeliveryDate != ""){
        		okbool = 1;
        		del_date1 = DeliveryDate.split("T")[0];
        		del_Time = DeliveryDate.split("T")[1];
        		del_TimeCD = del_Time.replace(":", "");
        		$("#DELIVERY_EXP_DATE_1").val(del_date1);
        		$("#DELIVERY_EXP_DATE_2").val(del_TimeCD);
        		$("#datepickerInput").val(del_date1);
        		$("#TIME_CD_DIV_1").find(".dropbox_select_button_typo").text(del_Time);
        		
        	}
        	/* 견적 만료 */
        	
        	var exp_date = "${DATA.EQ_EXP_DATE}";
        	var exp_date1 = "";
        	var exp_Time = "";
        	var str = "";
        	if(exp_date != ""){
        		exp_date1 = exp_date.split(" ")[0];
        		exp_Time = exp_date.split(" ")[1];
        		
        		ttyear = exp_date1.split(".")[0];
        		ttmonth = exp_date1.split(".")[1].split(".")[0];
        		ttday = exp_date1.split(".")[2];
        		console.log("22 ::" + exp_date1);
        		ttHour = exp_Time.split(":")[0];
        		ttMinute = exp_Time.split(":")[1];
        		
        		str = ttyear + "년 " + ttmonth + "월 " + ttday + "일 " + ttHour+ "시 " + ttMinute+ "분";
        		$(".equipment_estimator_writing_info_date_expiry_typo").text(str);
        		
        	}
        });
        var okbool = 0;
        $('#datepickerInput').change( function() {
            alert('Change!');
            CheckDate();
        });

        function CheckDate(){
      	  var args = $("#DELIVERY_EXP_DATE_1").val();
      	args = args.replaceAll("-", "");
      	  
      	  var today = new Date();
      	  var year = today.getFullYear();
      	  var month = ('0' + (today.getMonth() + 1)).slice(-2);
      	  var day = ('0' + today.getDate()).slice(-2);
      	  var toDayStr = year + month + day;
      	  console.log(args);
      	  if(args <= toDayStr){
      		 okbool =0;
      		alert(getI8nMsg("alert.enterFuTime"));//미래시간을 입력하세요.
      		var div = $(".datepicker-cell.day.selected.focused");
      		console.log("div.length " + div.length);
      		setTimeout(function(){
          		$(div).removeClass("selected");
          		$(div).removeClass("focused");      			
      		}, 100);

      		$("#datepickerInput").val("");
      	    return false;
      	  }
      	  okbool = 1;
      	  return true;
      	}
        var picdate = "";
       $(".datepicker-grid").click(function(){
    	   alert('gg');
    	   var curpicdate = $("#DELIVERY_EXP_DATE_1").val();
    	   if(curpicdate != picdate){
    		   picdate = curpicdate;
    		   CheckDate();
    		   
    	   }
       });

        </script>
        <div class="equipment_estimator_main_container">
            <div class="equipment_estimator_connection_location_container" style="margin-bottom: 44px;">
                <a href="./main.html" class="equipment_estimator_connection_location_typo">
                    <img class="equipment_estimator_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
                </a>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo"><spring:message code="main.dentalequipm" text="치과 / 치과기공 장비 견적소" /></p>
                </div>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <!-- <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo">3D 프린터</p>
                </div>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/> -->
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo_bold"><spring:message code="write" text="글쓰기" /></p>
                </div>
            </div> 
            <div class="connection_location_divider"></div>
            <div class="equipment_estimator_writing_info_wrapper">
                <div class="equipment_estimator_writing_info_sub_container">
                    <div class="dropbox_equipment_estimator_select_board">
                        <div class="dropbox_select_button_large">
                            <select id="EQ_CD" name="EQ_CD" class="boardtop_select large required" title="게시판">
                            	<option value=""><spring:message code="equ.selectB" text="게시판 선택" /></option>
                            	<c:forEach items="${EQ_CD_LIST}" var="eqpmt">
                            		<option value="${eqpmt.CODE_CD}" ${eqpmt.CODE_CD eq DATA.EQ_CD ? 'selected' : ''}>${eqpmt.CODE_NM}</option>
                            	</c:forEach>
						                </select>
                        </div>
                    </div>
                    <div class="dropbox_equipment_estimator_select_location">
                      <div class="dropbox_select_button_large">
                        <select id="AREA_CD" name="AREA_CD" class="boardtop_select large required" title="지역">
                           <option value=""><spring:message code="equ.selectR" text="지역 선택" /></option>
                           <c:forEach items="${AREA_CD_LIST}" var="area">
                           	<%-- <option value="${area.CODE_CD}" ${area.CODE_CD eq DATA.AREA_CD ? 'selected' : ''}>${area.CODE_NM}</option> --%>
                           	<option value="${area.CODE_CD}" <c:if test="${area.CODE_NM eq DATA.AREA_NM}">selected</c:if>>${area.CODE_NM}</option>
                           </c:forEach>
                         </select>
                        </div>
                    </div>
                </div>
                <div class="equipment_estimator_writing_info_sub_container">
                    <input class="equipment_estimator_writing_info_title required" id="TITLE" name="TITLE" title="제목" placeholder="<spring:message code="equ.enter.title" text="제목입력" />" value="${DATA.TITLE}"/>
                    <div class="equipment_estimator_writing_info_date_expiry">
                        <p class="equipment_estimator_writing_info_date_expiry_typo">
                            <spring:message code="proj.estimReq" text="견적요청 만료시간" />
                        </p>
                    </div> 
                    <a href="javascript:fnDateDialogOpen();" class="equipment_estimator_writing_info_date_expiry_button">
					            <p class="equipment_estimator_writing_info_date_expiry_button_typo"><spring:message code="proj.selectDT" text="시간선택하기" /></p>
					          </a>
                </div>
                <div class="equipment_estimator_writing_info_main_container">
                    <div class="equipment_estimator_writing_info_intro">
                        <p class="equipment_estimator_writing_info_intro_typo_top">
                            <strong>[필독]</strong> 플랫폼을 통한 장비구매시, 업체에게 받으신 견적서를 보시고 원하시는 업체를 선정하고 매칭하시면 됩니다.
														보다 나은 견적을 위해 상호간의 업체 정보는 비공개로 진행해 주세요.
                        </p>
                        <p class="equipment_estimator_writing_info_intro_typo_bottom">
                            매칭 완료 시 해당 업체의 정보 열람이 가능합니다.
                        </p>
                    </div>
                    <div class="equipment_estimator_writing_info_item_container">
                        <div class="equipment_estimator_writing_info_item">
                            <p class="equipment_estimator_writing_info_item_typo">
                                <spring:message code="equ.brand" text="브랜드" />
                            </p>
                            <input class="equipment_estimator_writing_info_item_blank required" id="BRAND_NM" name="BRAND_NM" title="브랜드" placeholder="<spring:message code="equ.enter.brand" text="브랜드를 입력해 주세요" />" value="${DATA.BRAND_NM}"/>
                        </div>
                        <div class="equipment_estimator_writing_info_item">
                            <p class="equipment_estimator_writing_info_item_typo">
                                <spring:message code="" text="장비 이름" />
                            </p>
                            <input class="equipment_estimator_writing_info_item_blank required" id="EQ_NM" name="EQ_NM" title="장비" placeholder="<spring:message code="" text="장비명을 입력해 주세요" />" value="${DATA.EQ_NM}"/>
                        </div>
                        <div class="equipment_estimator_writing_info_item">
                            <p class="equipment_estimator_writing_info_item_typo">
                                <spring:message code="" text="원하는 납품 날짜" />
                            </p>
                            <div class="equipment_estimator_writing_info_select_button_container">
							                <div class="dropbox_project_request_calendar">
							                  <div id="datepickerContainer" class="dropbox_select_button">
							                    <input id="datepickerInput" type="text" placeholder="<spring:message code="proj.date" text="날짜선택" />"  style="cursor: pointer;" autocomplete="off">
							                    <img class="equipment_estimator_calendar_image" src="/public/assets/images/calendar_image.svg" style="cursor: pointer;"/>
							                  </div>
							                </div>
							                <div class="dropbox_project_request_time">
							                  <div class="dropbox_select_button">
							                    <div id="TIME_CD_DIV_1" class="dropbox_select_button_typo_container" onclick="fnSelect_3();" style="cursor: pointer;">
							                      <p class="dropbox_select_button_typo"><spring:message code="proj.time" text="시간" /></p>
							                      <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
							                    </div>
							                  </div>
							                  <div id="TIME_CD_DIV_2" class="dropbox_project_request_select_button_item_container_time hidden" style="cursor: pointer;">
							                    <c:forEach var="item" items="${TIME_CD_LIST}" varStatus="status">
							                      <div class="dropbox_select_button_item_small" onclick="fnSelect_3('${item.CODE_CD}', '${item.CODE_NM}')">
							                        <p class="dropbox_select_button_item_typo">${item.CODE_NM}</p>
							                      </div>
							                    </c:forEach>
							                  </div>
							                </div>
							              </div>
                        </div>
                        <div class="main_container_divider"></div>
                        <div class="equipment_estimator_writing_info_detail">
                            <p class="equipment_estimator_writing_info_detail_typo"><spring:message code="details" text="상세내용" /></p>
							<c:choose>
							<c:when test="${not empty imgFileList}">
	                        	<div id="imageSlider" class="carousel slide qna_writing_image_slider_wrapper" data-bs-ride="carousel">
							      <div class="carousel-indicators">
							      	<c:forEach items="${imgFileList}" var="item" varStatus="vs">
							      		<button type="button" data-bs-target="#imageSlider" data-bs-slide-to="${vs.index}" ${vs.index eq 0 ? 'class="active" aria-current="true"' : ''} aria-label="Slide ${vs.count}"></button>
							      	</c:forEach>
									  </div>
									  <div class="carousel-inner h-100">
									  	<c:forEach items="${imgFileList}" var="item" varStatus="vs">
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
                        </c:when>
                        <c:otherwise>
                            <div id="imageSlider" class="carousel slide qna_writing_image_slider_wrapper hidden" data-bs-ride="carousel">
					       		<div class="carousel-indicators">
							  	</div>
							  	<div class="carousel-inner h-100">
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
                        </c:otherwise>
                        </c:choose>
                            <textarea class="equipment_estimator_writing_info_detail_blank" maxlength="1300" id="ADD_CONTENT" name="ADD_CONTENT" placeholder="<spring:message code="proj.enter.detail" text="상세내용을 적어주세요" />">${DATA.ADD_CONTENT}</textarea>
                        </div>
                        
                    </div>
                </div>
                <div class="equipment_estimator_writing_info_button_container">
                    <button class="equipment_estimator_writing_info_button_left" type="button" data-bs-toggle="modal" data-bs-target="#picAttachModal">
                        <p class="equipment_estimator_writing_info_button_left_typo">
                            <spring:message code="equ.attachI" text="사진첨부" />
                        </p>
                    </button>
                    <div class="equipment_estimator_writing_info_button_right_container">
<!--                         <a class="equipment_estimator_writing_info_button_right_save"> -->
<!--                             <p class="equipment_estimator_writing_info_button_right_save_typo"> -->
<!--                                 임시저장 -->
<!--                             </p> -->
<!--                         </a> -->
						<c:choose>
							<c:when test="${empty DATA.EQ_NO}">
	                        <a href="javascript:fnSave()" class="equipment_estimator_writing_info_button_right_submit">
	                            <p class="equipment_estimator_writing_info_button_right_submit_typo">
	                            	<spring:message code="write" text="글쓰기" />
	                            </p>
	                        </a>
	                        </c:when>
	                        <c:otherwise>
	                        <a href="javascript:fnUpdate()" class="equipment_estimator_writing_info_button_right_submit">
	                            <p class="equipment_estimator_writing_info_button_right_submit_typo">
	                            	<spring:message code="write" text="글쓰기" />
	                            </p>
	                        </a>
	                        </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="modal fade" id="picAttachModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
									<div class="modal-dialog modal-dialog-centered">
										<div class="modal-content" style="width: fit-content;">
											<div class="qna_pic_attachment_container">
						            <div class="qna_pic_attachment_header">
						                <p class="qna_pic_attachment_header_typo"><spring:message code="equ.attachI" text="사진 첨부" /></p>
						                <a href="#" data-bs-dismiss="modal" aria-label="Close" onclick="">
						                	<img class="qna_pic_attatchment_close_button" src="/public/assets/images/dialog_close_button.svg"/>
						                </a>
						            </div>
						            <div class="qna_pic_attachment_body">
						                <p class="qna_pic_attachment_title"><spring:message code="equ.upload" text="사진 업로드" /></p>
						                <p class="qna_pic_attachment_sub_title">최대 10장까지 업로드 가능합니다.</p>
						                <font style="margin-left:10px;display: block;margin-bottom: 20px;margin-top: -10px;">※ 파일 최대 용량 500MB (zip 형식의 압축파일을 권장합니다.) </font>
						                <div class="qna_pic_attatchment_pic_upload_container">
						                  <div class="qna_pic_attatchment_main_pic_upload_wrapper">
						                    <img class="qna_pic_attatchment_main_pic_upload" id="mainPicImage" src="/public/assets/images/profile_image.svg"/>
						                  </div>
						                  <div style="display: flex;">
						                  	<button id="imgUploadBtn" class="qna_pic_attachment_pic_upload_button" type="button">
						                    	<p class="qna_pic_attachment_pic_upload_button_typo"><spring:message code="equ.upload" text="이미지 업로드" /></p>
						                    </button>
								                <input type="file" name="IMG_FILE" id="IMG_FILE" onchange="previewImage();" style="display: none;"/>
								              </div>
						                </div>
						                <div class="qna_pic_attatchment_sub_pic_upload_wrapper">
						                    <!-- hidden과 invisible로 조절 imgFileList-->
						                    <c:choose>
						                    <c:when test="${empty imgFileList}">
						                    <div class="qna_pic_attatchment_sub_pic_upload_container">
						                      <div class="qna_pic_attatchment_sub_pic_upload"></div>
						                      <div class="qna_pic_attatchment_sub_pic_upload"></div>
						                      <div class="qna_pic_attatchment_sub_pic_upload"></div>
						                      <div class="qna_pic_attatchment_sub_pic_upload"></div>
						                      <div class="qna_pic_attatchment_sub_pic_upload"></div>
						                    </div>
						                    <div class="qna_pic_attatchment_sub_pic_upload_container">
						                      <div class="qna_pic_attatchment_sub_pic_upload"></div>
						                      <div class="qna_pic_attatchment_sub_pic_upload"></div>
						                      <div class="qna_pic_attatchment_sub_pic_upload"></div>
						                      <div class="qna_pic_attatchment_sub_pic_upload"></div>
						                      <div class="qna_pic_attatchment_sub_pic_upload"></div>
						                    </div>
						                    </c:when>
						                    <c:otherwise>
						                    	<c:set var="imagelengthFirst" value="${fn:length(imgFileList)}"></c:set>
						                    	<div class="qna_pic_attatchment_sub_pic_upload_container">
							                    	<c:forEach var="item" items="${imgFileList}" varStatus="status" begin="0" end="4">
							                    		<div class="qna_pic_attatchment_sub_pic_upload" style="background-image:url(https://dentner.co.kr/upload/${item.FILE_DIRECTORY});"></div>
							                    	</c:forEach>
							                    	<c:if test="${imagelengthFirst < 5}">
							                    	<c:forEach begin="0" end="${4 - imagelengthFirst}">
							                    		<div class="qna_pic_attatchment_sub_pic_upload"></div>
							                    	</c:forEach>
							                    	</c:if>
						                    	</div>
						                    	<div class="qna_pic_attatchment_sub_pic_upload_container">
							                    	<c:forEach var="item" items="${imgFileList}" varStatus="status" begin="5" end="9">
							                    		<div class="qna_pic_attatchment_sub_pic_upload" style="background-image:url(https://dentner.co.kr/upload/${item.FILE_DIRECTORY});"></div>
							                    	</c:forEach>
							                    	<c:if test="${imagelengthFirst < 5}">
							                    	<c:forEach begin="0" end="4">
							                    		<div class="qna_pic_attatchment_sub_pic_upload"></div>
							                    	</c:forEach>
							                    	</c:if>
							                    	<c:if test="${imagelengthFirst >= 5 and imagelengthFirst < 10}">
							                    	<c:forEach begin="0" end="${9 - imagelengthFirst}">
							                    		<div class="qna_pic_attatchment_sub_pic_upload"></div>
							                    	</c:forEach>
							                    	</c:if>
						                    	</div>
						                    </c:otherwise>
						                    </c:choose>

						                </div>
						                <div class="main_container_divider"></div>
						                <div class="qna_pic_attatchment_button_container">
						                    <a href="#" class="qna_pic_attatchment_button_white" data-bs-dismiss="modal" aria-label="Close" onclick="">
						                    	<p class="qna_pic_attatchment_button_white_typo"><spring:message code="cancel" text="취소" /></p>
						                    </a>
						                    <a href="#" class="qna_pic_attatchment_button_blue" data-bs-dismiss="modal" onclick="fnUpload();">
						                    	<p class="qna_pic_attatchment_button_blue_typo"><spring:message code="upload" text="업로드" /></p>
						                    </a>
						                </div>
						            </div>
						        	</div>
										</div>
									</div>
								</div>
            </div>  
        </div>
        </form:form>
    </div>
    
<jsp:include page="/WEB-INF/views/dialog/date_dialog.jsp" flush="false">
  <jsp:param name="callback" value="fnSetEqmtExpDate" />
</jsp:include>
    