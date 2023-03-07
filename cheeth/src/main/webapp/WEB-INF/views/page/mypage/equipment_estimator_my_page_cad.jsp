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

	var estimatorViewModal;
	var matchingModal;
	var lang = localStorage.getItem('lang');
	var req = getI8nMsg("proj.request");
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
  
	function fnViewEstimators() {
	  
		const projectNo = arguments[0];
		
		const estimatorNo = arguments[1];
		const contractYn = arguments[2];
		
		// 전자계약 버튼
		if(isNotEmpty(estimatorNo) && contractYn === 'N') {
			$('#btnWrapper2').show();
			var html = '<a href="/${api}/contract/project_electronic_contract?ESTIMATOR_NO=' + estimatorNo + '" class="button_blue">';
			html += '<p class="button_blue_typo">전자계약</p>';
			html += '</a>';
			$('#btnWrapper2').html(html);
		} else {
      $('#btnWrapper2').hide();
      $('#btnWrapper2').html('');
		}
		
		fnSetReqInfo(projectNo);
		
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
				return nm + ' ' + cntArr[i] + getI8nMsg('unit');
			}).join(', ');
			
			reqHtml += '<div class="cad_estimator_dialog_request">';
			reqHtml += '  <p class="cad_estimator_dialog_request_title">'+ req + (index + 1) + '</p>';
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
	  
		fnGetEstimators(projectNo);
  }
  
  var estimatorArr = new Array();
  
  function fnGetEstimators() {
	  var projectNo = arguments[0];
	  
	  $.ajax({
		  url: '/' + API + '/project/getEstimators',
		  type: 'GET',
		  data: { PROJECT_NO : projectNo },
		  cache: false,
		  async: false,
		  success: function(data) {
				estimatorArr = data.estimatorList;
				if(isEmpty(estimatorArr)) {
					alert(getI8nMsg("alert.noQuo"));
					estimatorViewModal.hide();
				} else {
		 	 		var idx = 0;
		 	 		if(estimatorArr.some((s, i) => {
		 	 			if(s.MATCHING_YN == 'Y') {
		 	 				idx = i;
		 	 				return true;
		 	 			}
		 	 		})) {
		 	 			$('#btnWrapper').hide();
		 	 			$('.cad_estimator_pagination').hide();
		 	 		} else {
		 	 			$('#btnWrapper').show();
		 	 			$('.cad_estimator_pagination').show();
		 	 		}
		 	 		$('#nick_p_1').html(estimatorArr[idx].USER_NICK_NAME);
					fnSetEstimator(idx);
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
	  
	  fnSetEstimatorPageInfo(index);
	  
	  // 치자이너 정보 변경
	  $('#nick_p_1').html(currEstimator.USER_NICK_NAME);
	  
	    if(currEstimator.TAX_BILL_YN === 'Y') {
	        $('#texbool').html('세금 계산서 발행 가능');
	      } else {
	        $('#texbool').html('');
	      }
	      
	      $('#successrate').html(currEstimator.COMPLETE_RATIO + ' %'); // 거래 성공률
	      $('#stafyrate').html(currEstimator.SCORE_AVG + ' / 10'); // 만족도
	      $('#amountCash').html(addComma(currEstimator.COMPLETE_AMOUNT) + ' 원'); // 거래 총 금액
	      
  }
  
  function fnDeleteEstimator() {
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
		    		//fnGetEstimators(projectNo);
		    		location.reload();
		    	}
		    }, complete: function() {
		      
		    }, error: function() {
		      
		    }
		  });
	  }
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
  
  $(function() {

	  fnSetPageInfo('${PAGE}', '${TOTAL_CNT}', 10);
    estimatorViewModal = new bootstrap.Modal(document.getElementById('estimatorViewModal'));
    matchingModal = new bootstrap.Modal(document.getElementById('matchingModal'));
    
    var estimatorViewModalEl = document.getElementById('estimatorViewModal');
    estimatorViewModalEl.addEventListener('hidden.bs.modal', function(e) {
			
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

<form:form id="searchForm" name="searchForm" action="/${api}/mypage/equipment_estimator_my_page_cad" method="GET">
  
	<div class="equipment_estimator_header">
  	<p class="equipment_estimator_header_typo">
    	<spring:message code="req.reqHis" text="견적·의뢰내역" />
    </p>
  </div>
	
	<div class="equipment_estimator_body">
        <div class="side_menu">
            <div class="side_menu_title">
                <p class="side_menu_title_typo">
                    <spring:message code="main.seeAll" text="전체보기" />
                </p>
            </div>
          <c:if test="${sessionInfo.user.USER_TYPE_CD eq 2}">
          <a href="/${api}/mypage/equipment_estimator_my_page_cad" class="side_menu_list">
		  </c:if>
		  <c:if test="${sessionInfo.user.USER_TYPE_CD eq 3}">
          <a href="/${api}/mypage/equipment_estimator_my_page_sent" class="side_menu_list">
		  </c:if>
		  <c:if test="${sessionInfo.user.USER_TYPE_CD eq 1}">
          <a href="/${api}/mypage/equipment_estimator_my_page_equipment" class="side_menu_list">
		  </c:if>
            		
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo_blue"><spring:message code="req.reqHis" text="견적·의뢰내역" /></p>
				    </a>
				    <a href="/${api}/tribute/request_basket" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo"><spring:message code="req.myReq" text="의뢰서 바구니" /></p>
				    </a>
				    <a href="/${api}/mypage/equipment_estimator_my_page_progress" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo"><spring:message code="req.progD" text="진행내역" /></p>
				    </a>
            <c:choose>
              <c:when test="${sessionInfo.user.USER_TYPE_CD eq 1 or sessionInfo.user.USER_TYPE_CD eq 2}">
                <a href="/${api}/mypage/profile_management" class="side_menu_list">
                  <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                  <p class="side_menu_list_typo"><spring:message code="req.myProf" text="프로필 관리" /></p>
                </a>
              </c:when>
              <c:when test="${sessionInfo.user.USER_TYPE_CD eq 3}">
                <a href="/${api}/mypage/profile_management_cheesigner_show" class="side_menu_list">
                  <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                  <p class="side_menu_list_typo"><spring:message code="req.myProf" text="프로필 관리" /></p>
                </a>
              </c:when>
            </c:choose>
				    <a href="/${api}/review/client_review" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo"><spring:message code="req.myReview" text="후기관리" /></p>
				    </a>
				    <a href="/${api}/mypage/my_page_edit_info" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo"><spring:message code="req.manInfo" text="내정보 수정" /></p>
				    </a>
				    <a href="javascript:fnLogOut();" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo"><spring:message code="logout" text="로그아웃" /></p>
				    </a>
        </div>
        <div class="equipment_estimator_main_container">
            <div class="equipment_estimator_connection_location_container" style="margin-bottom: 44px;">
                <a href="./main.html" class="equipment_estimator_connection_location_typo">
                    <img class="equipment_estimator_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
                </a>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo"><spring:message code="req.myPage" text="마이페이지" /></p>
                </div>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo_bold"><spring:message code="equ.allReqH" text="견적·의뢰내역 전체보기" /></p>
                </div>
            </div>
            <div class="equipment_estimator_my_page_request_history_wrapper">
                <div class="equipment_estimator_my_page_request_history_chip_container">

                    <a href="/${api}/mypage/equipment_estimator_my_page_cad" class="equipment_estimator_my_page_request_history_chip">
                        <p class="equipment_estimator_my_page_request_history_chip_selected_typo">
                            <spring:message code="equ.cadQuoB" text="CAD 견적함" />
                        </p>
                    </a>
                    <a href="/${api}/mypage/equipment_estimator_my_page_sent" class="equipment_estimator_my_page_request_history_chip">
                        <p class="equipment_estimator_my_page_request_history_chip_typo">
                            <spring:message code="equ.sentQuo" text="내가 보낸 견적" />
                        </p>
                    </a>
                                        <a href="/${api}/mypage/equipment_estimator_my_page_equipment" class="equipment_estimator_my_page_request_history_chip">
                        <p class="equipment_estimator_my_page_request_history_chip_typo">
                            <spring:message code="equ.equQuoB" text="장비 견적함" />
                        </p>
                    </a>
                </div>
                <div class="equipment_estimator_my_page_request_history_container">
                    <div class="equipment_estimator_my_page_request_history_datatype_container">
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_category_datatype">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo"></p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_context">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                <spring:message code="equ.reqCont" text="의뢰내용" />
                            </p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_count">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                <spring:message code="equ.numQuo" text="견적수" />
                            </p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_date_requested">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                <spring:message code="equ.reqDate" text="의뢰일" />
                            </p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_date_expiry">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                <spring:message code="equ.expriDate" text="만료일" />
                            </p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_estimator_read">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                <spring:message code="equ.viewQuo" text="견적서보기" />
                            </p>
                        </div>
                    </div>
                    <div class="equipment_estimator_my_page_request_history_list_container">
                    	<c:forEach items="${LIST}" var="item" varStatus="status">
                        <div class="equipment_estimator_my_page_request_history_list">
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_category flex_start">
                            <p class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.PROJECT_CD_NM}
                            </p>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_context flex_start">
                            <a href="/${api}/project/project_request_view?PROJECT_NO=${item.PROJECT_NO}" class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.TITLE}
                            </a>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_count">
                            <p class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.PROJECT_CNT}
                            </p>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_date_requested">
                            <p class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.CREATE_DATE}
                            </p>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_date_expiry">
                            <p class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.PROJECT_EXP_DATE}
                            </p>
                          </div>
                          <c:choose>
			                      <c:when test="${item.CONTRACT_CNT gt 0}">
			                        <c:set var="CONTRACT_YN" value="Y"/>
			                      </c:when>
			                      <c:otherwise>
			                        <c:set var="CONTRACT_YN" value="N"/>
			                      </c:otherwise>
			                    </c:choose>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_estimator_read">
                            <a href="javascript:fnViewEstimators('${item.PROJECT_NO}', '${item.ESTIMATOR_NO}', '${CONTRACT_YN}');" class="equipment_estimator_my_page_estimator_read_button">
                              <p class="equipment_estimator_my_page_estimator_read_button_typo">
                                <spring:message code="view" text="보기" />
                              </p>
                            </a>
                          </div>
                        </div>
                        <div class="list_divider"></div>
                    	</c:forEach>
                    	
                    	<!-- 받은 견적서 보기 modal -->
											<div class="modal fade" id="estimatorViewModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
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
																		<spring:message code="proj.delivTm" text="납품가능시간" />
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
																					<spring:message code="proj.quot" text="개수" />
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
																		<spring:message code="proj.availaCADSW" text="구동가능한 CAD S/W" />
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
																	<!-- <div class="cad_estimator_profile_pic_upload"></div> -->
																	<div class="cad_estimator_profile_typo_container">
																		<div class="cad_estimator_profile_name">
																			<p class="cad_estimator_profile_name_typo" id="nick_p_1">중랑구 핫도그</p>
																			<p class="cad_estimator_dialog_item_sub_title_typo" id="texbool">
																			    <spring:message code="equ.taxInvCan" text="세금 계산서 발행 가능" />
																			</p>
																		</div>
																		<div class="cad_estimator_profile_info_container">
																			<div class="cad_estimator_profile_info">
																				<p class="cad_estimator_profile_info_typo" >
																				    <spring:message code="tesign.successR" text="거래 성공률" />
																				</p>
																				<p class="cad_estimator_profile_info_typo" id="successrate">
																				    100 %
																				</p>
																			</div>
																			<div class="cad_estimator_profile_info">
																				<p class="cad_estimator_profile_info_typo">
																				    <spring:message code="tesign.satisf" text="만족도" />
																				</p>
																				<p class="cad_estimator_profile_info_typo" id="stafyrate">
																				    82 %
																				</p>
																			</div>
																			<div class="cad_estimator_profile_info without_margin">
																				<p class="cad_estimator_profile_info_typo">
																				    <spring:message code="tesign.totalA" text="현재까지 거래 총 금액" />
																				</p>
																				<p class="cad_estimator_profile_info_typo" id="amountCash">
																				    1234,567 원
																				</p>
																			</div>
																		</div>
																	</div>
																</div>
											        </div>
											        <div class="main_container_divider without_margin"></div>
											        <div class="cad_estimator_pagination"></div>
											        <div id="btnWrapper" class="button_container">
																<a href="javascript:void(0);" class="button_white" onclick="fnDeleteEstimator();">
																	<p class="button_white_typo"><spring:message code="equ.delete" text="견적서 삭제하기" /></p>
																</a>
																<a href="#matchingModal" class="button_blue" data-bs-toggle="modal">
																  <p class="button_blue_typo"><spring:message code="match" text="매칭하기" /></p>
																</a>
											        </div>
											        <div id="btnWrapper2" class="button_container" style="display: none;">
                                <a href="javascript:void(0);" class="button_blue">
                                  <p class="button_blue_typo"><spring:message code="econtact" text="전자계약" /></p>
                                </a>
											        </div>
											    	</div>
											    </div>
											  </div>
											</div>
											<!-- 받은 견적서 보기 modal end -->
											
											<!-- 매칭하기 modal -->
											<div class="modal fade" id="matchingModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
											  <div class="modal-dialog modal-dialog-centered">
											    <div class="modal-content" style="width: fit-content;">
											    	<div class="matching_container">
												        <div class="matching_header">
												            <p class="matching_header_typo">
												                <spring:message code="req.myPage" text="마이페이지" />
												            </p>
												            <a href="#estimatorViewModal" class="dialog_close_button_wrapper" data-bs-toggle="modal">
												                <img class="dialog_close_button" src="/public/assets/images/dialog_close_button.svg"/>
												            </a>
												        </div>
												        <div class="matching_body">
												            <div class="matching_body_typo_wrapper">
												                <p class="matching_body_typo">
												                    <spring:message code="equ.msq.match" text="매칭하시겠습니까?" />
												                </p>
												            </div>
												            <div class="matching_button_container">
												                <a href="#estimatorViewModal" class="matching_button_white" data-bs-toggle="modal">
												                    <div class="matching_button_white_typo">
												                        <spring:message code="no" text="아니오" />
												                    </div>
												                </a>
												                <a href="javascript:fnMatching()" class="matching_button_blue">
												                    <div class="matching_button_blue_typo">
												                        <spring:message code="yes" text="네" />
												                    </div>
												                </a>
												            </div>
												        </div>
												    </div>
											    </div>
											  </div>
											</div>
											<!-- 매칭하기 modal end -->
								
                        <div class="pagination"></div>
                        <input type="hidden" id="PAGE" name="PAGE" value="${PAGE}">
                        <!-- <div class="equipment_estimator_my_page_pagination">
                            <div class="pagination_before">
                                <img class="pagination_before_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                                <p class="pagination_before_typo">&nbsp;&nbsp;이전</p>
                            </div>

                            <div class="pagination_numb_now">
                                <p class="pagination_numb_now_typo">1</p>
                            </div>
                            <div class="pagination_numb">
                                <p class="pagination_numb_typo">2</p>
                            </div>
                            <div class="pagination_numb">
                                <p class="pagination_numb_typo">3</p>
                            </div>
                            <div class="pagination_numb">
                                <p class="pagination_numb_typo">4</p>
                            </div>
                            <div class="pagination_numb">
                                <p class="pagination_numb_typo">5</p>
                            </div>
                            
                            <div class="pagination_next">
                                <p class="pagination_next_typo">다음&nbsp;&nbsp;</p>
                                <img class="pagination_next_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                            </div>
                        </div> -->
                    </div>
                </div>
            </div>
        </div>
    </div>
</form:form>