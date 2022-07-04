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

<script>

	var estimatorViewModal;
	var matchingModal;

  function fnView() {
    var estimatorNo = arguments[0];
    var url = '/' + API + '/contract/project_electronic_contract';
    url += '?ESTIMATOR_NO=' + estimatorNo;
    location.href = url;
  }
  
  function fnSearch() {
    var page = arguments[0] ?? '1';
    $('#PAGE').val(page);
    $('#searchForm').submit();
   }
  
  function fnViewEstimators() {
	  const eqNo = arguments[0];
		fnGetEstimators(eqNo);
	}
	  
	var estimatorArr = new Array();
	  
	function fnGetEstimators() {
	  var eqNo = arguments[0];
	  
	  $.ajax({
	    url: '/' + API + '/equipment/getEstimators',
	    type: 'GET',
	    data: { EQ_NO : eqNo },
	    cache: false,
	    async: false,
	    success: function(data) {
	 	 		estimatorArr = data.estimatorList;
		 	 	if(isEmpty(estimatorArr)) {
		 	 		alert('받은 견적서가 존재하지 않습니다.');
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
		 	 			$('.equipment_estimator_pagination').hide();
		 	 			$('#cheesignerInfoWrapper').show();
		 	 			$('#cheesignerCompNm').text(estimatorArr[idx].COMP_NAME);
		 	 			$('#cheesignerPhone').text(estimatorArr[idx].USER_PHONE);
		 	 		} else {
		 	 			$('#btnWrapper').show();
		 	 			$('.equipment_estimator_pagination').show();
		 	 			$('#cheesignerInfoWrapper').hide();
		 	 		}
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
		
		var imgHtml = '';
		var imgWrapper = document.querySelector('.dialog_item_context_pic_upload_wrapper');
		imgWrapper.innerHTML = '';
		
		currEstimator.fileList.map((m, i) => {
			m.FILE_DIRECTORY = m.FILE_DIRECTORY.replace(/\\/g, '\/');
			var imgDiv = document.createElement('div');
			imgDiv.className = 'dialog_item_context_pic_upload';
			imgDiv.style.backgroundImage = "url('/upload/" + m.FILE_DIRECTORY + "')";
			imgWrapper.appendChild(imgDiv);

			//const target = $('.dialog_item_context_pic_upload').eq(i);
			//target.css('background-image', "url('/upload/" + m.FILE_DIRECTORY + "')");
		});
		//$('.dialog_item_context_pic_upload:gt(' + (currEstimator.fileList.length - 1) + ')').css('background-image', '');
		
		fnSetEstimatorPageInfo(index);
	}
	
	function fnDeleteEstimator() {
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
		    		//fnGetEstimators(eqNo);
		    		location.reload();
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
	    		alert('매칭되었습니다.');
	    		matchingModal.hide();
	    		fnGetEstimators(eqNo);
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
  });
  
</script>

<form:form id="searchForm" name="searchForm" action="/${api}/mypage/equipment_estimator_my_page_equipment" method="GET">
  
	<div class="equipment_estimator_header">
  	<p class="equipment_estimator_header_typo">
    	견적·의뢰내역
    </p>
  </div>
	
	<div class="equipment_estimator_body">
        <div class="side_menu">
            <div class="side_menu_title">
                <p class="side_menu_title_typo">
                    전체보기
                </p>
            </div>
            <a href="/${api}/mypage/equipment_estimator_my_page_equipment" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo_blue">견적·의뢰내역</p>
				    </a>
				    <a href="/${api}/tribute/request_basket" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo">의뢰서 바구니</p>
				    </a>
				    <a href="/${api}/mypage/equipment_estimator_my_page_progress" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo">진행내역</p>
				    </a>
            <c:choose>
              <c:when test="${sessionInfo.user.USER_TYPE_CD eq 1 or sessionInfo.user.USER_TYPE_CD eq 2}">
                <a href="/${api}/mypage/profile_management" class="side_menu_list">
                  <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                  <p class="side_menu_list_typo">프로필 관리</p>
                </a>
              </c:when>
              <c:when test="${sessionInfo.user.USER_TYPE_CD eq 3}">
                <a href="/${api}/mypage/profile_management_cheesigner" class="side_menu_list">
                  <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                  <p class="side_menu_list_typo">프로필 관리</p>
                </a>
              </c:when>
            </c:choose>
				    <a href="/${api}/review/client_review" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo">후기관리</p>
				    </a>
				    <a href="/${api}/mypage/my_page_edit_info" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo">내정보 수정</p>
				    </a>
				    <a href="javascript:fnLogOut();" class="side_menu_list">
				      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
				      <p class="side_menu_list_typo">로그아웃</p>
				    </a>
        </div>
        <div class="equipment_estimator_main_container">
            <div class="equipment_estimator_connection_location_container" style="margin-bottom: 44px;">
                <a href="./main.html" class="equipment_estimator_connection_location_typo">
                    <img class="equipment_estimator_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
                </a>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo">마이페이지</p>
                </div>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo_bold">견적·의뢰내역 전체보기</p>
                </div>
            </div>
            <div class="equipment_estimator_my_page_request_history_wrapper">
                <div class="equipment_estimator_my_page_request_history_chip_container">
                    <a href="/${api}/mypage/equipment_estimator_my_page_equipment" class="equipment_estimator_my_page_request_history_chip">
                        <p class="equipment_estimator_my_page_request_history_chip_selected_typo">
                            장비 견적함
                        </p>
                    </a>
                    <a href="/${api}/mypage/equipment_estimator_my_page_cad" class="equipment_estimator_my_page_request_history_chip">
                        <p class="equipment_estimator_my_page_request_history_chip_typo">
                            CAD 견적함
                        </p>
                    </a>
                    <a href="/${api}/mypage/equipment_estimator_my_page_sent" class="equipment_estimator_my_page_request_history_chip">
                        <p class="equipment_estimator_my_page_request_history_chip_typo">
                            내가 보낸 견적
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
                                의뢰내용
                            </p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_count">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                견적수
                            </p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_date_requested">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                의뢰일
                            </p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_date_expiry">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                만료일
                            </p>
                        </div>
                        <div class="equipment_estimator_my_page_request_history_datatype equipment_estimator_my_page_estimator_read">
                            <p class="equipment_estimator_my_page_request_history_datatype_typo">
                                견적서보기
                            </p>
                        </div>
                    </div>
                    <div class="equipment_estimator_my_page_request_history_list_container">
                    	<c:forEach items="${LIST}" var="item" varStatus="status">
                        <div class="equipment_estimator_my_page_request_history_list">
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_category flex_start">
                            <p class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.EQ_CD_NM}
                            </p>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_context flex_start">
                            <a href="/${api}/equipment/equipment_estimator_view?EQ_NO=${item.EQ_NO}&SEARCH_EQ_CD=${item.EQ_CD}" class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.TITLE}
                            </a>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_count">
                            <p class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.EQ_CNT}
                            </p>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_date_requested">
                            <p class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.CREATE_DATE}
                            </p>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_date_expiry">
                            <p class="equipment_estimator_my_page_request_history_list_item_typo">
                            	${item.EQ_EXP_DATE}
                            </p>
                          </div>
                          <div class="equipment_estimator_my_page_request_history_list_item equipment_estimator_my_page_estimator_read">
                            <a href="javascript:fnViewEstimators('${item.EQ_NO}');" class="equipment_estimator_my_page_estimator_read_button">
                              <p class="equipment_estimator_my_page_estimator_read_button_typo">
                                보기
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
											                        <!-- <div class="dialog_item_context_pic_upload"></div>
											                        <div class="dialog_item_context_pic_upload"></div>
											                        <div class="dialog_item_context_pic_upload"></div>
											                        <div class="dialog_item_context_pic_upload"></div>
											                        <div class="dialog_item_context_pic_upload"></div>
											                        <div class="dialog_item_context_pic_upload"></div>
											                        <div class="dialog_item_context_pic_upload"></div>
											                        <div class="dialog_item_context_pic_upload"></div>
											                        <div class="dialog_item_context_pic_upload"></div>
											                        <div class="dialog_item_context_pic_upload"></div> -->
											                </div>
											            </div>
											        </div>
											        <div id="cheesignerInfoWrapper" class="dialog_item" style="display: none;">
										            <div class="dialog_item_title">
										                <p class="dialog_item_title_typo">
										                    견적자 정보
										                </p>
										            </div>
										            <div class="dialog_item_context_container">
										                <div class="dialog_item_context_typo_container info">
										                    <p class="dialog_item_context_typo info_title">
										                        상호
										                    </p>
										                    <p id="cheesignerCompNm" class="dialog_item_context_typo info_context">
										                        명량핫도그 기공사
										                    </p>
										                </div>
										                <div class="dialog_item_context_typo_container info">
										                    <p class="dialog_item_context_typo info_title">
										                        전화번호
										                    </p>
										                    <p id="cheesignerPhone" class="dialog_item_context_typo info_context">
										                        02-123-4567
										                    </p>
										                </div>
										            </div>
										        </div>
											        <div id="btnWrapper" class="button_container">
											            <a href="javascript:fnDeleteEstimator()" class="button_white">
											                <div class="button_white_typo">
											                    견적서 삭제하기
											                </div>
											            </a>
											            <a href="#matchingModal" class="button_blue" data-bs-toggle="modal">
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
											
											<!-- 매칭하기 modal -->
											<div class="modal fade" id="matchingModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
											  <div class="modal-dialog modal-dialog-centered">
											    <div class="modal-content" style="width: fit-content;">
											    	<div class="matching_container">
												        <div class="matching_header">
												            <p class="matching_header_typo">
												                매칭하기
												            </p>
												            <a href="#estimatorViewModal" class="dialog_close_button_wrapper" data-bs-toggle="modal">
												                <img class="dialog_close_button" src="/public/assets/images/dialog_close_button.svg"/>
												            </a>
												        </div>
												        <div class="matching_body">
												            <div class="matching_body_typo_wrapper">
												                <p class="matching_body_typo">
												                    매칭하시겠습니까?
												                </p>
												            </div>
												            <div class="matching_button_container">
												                <a href="#estimatorViewModal" class="matching_button_white" data-bs-toggle="modal">
												                    <div class="matching_button_white_typo">
												                        아니오
												                    </div>
												                </a>
												                <a href="javascript:fnMatching()" class="matching_button_blue">
												                    <div class="matching_button_blue_typo">
												                        네
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