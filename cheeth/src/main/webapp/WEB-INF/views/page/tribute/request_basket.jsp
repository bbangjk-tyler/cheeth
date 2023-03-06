<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:if test="${empty sessionInfo.user}">
  <script>
  alert(getI8nMsg("alert.plzlogin"));
   location.href = '/api/login/view';
</script>
</c:if>
<link type="text/css" rel="stylesheet" href="/public/assets/css/modal.css"/>
<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>
<script>

	var reqArr = new Array();
	var suppInfo = new Array();
	var rqstNoArr = new Array();
	var Rewritebool = 1;
	var fileModal;
	
	$(function() {
		
		fileModal = new bootstrap.Modal(document.getElementById('fileModal'));
		
		var fileModalEl = document.getElementById('fileModal');
		fileModalEl.addEventListener('hidden.bs.modal', function(e) {
			$('.file_modal_item').each(function(index) {
				$('.file_modal_name').eq(index).text('');
				$('.file_modal_download').eq(index).addClass('hidden');
				$('.file_modal_download').eq(index).off('click');
			});
		});
		
		fnSetPageInfo('${PAGE}', '${TOTAL_CNT}', 5);
		
		var reqs = '${REQS}';
		console.log("reqs reqs reqs " + reqs);
		if(isNotEmpty(reqs)) {
			reqs.split('l').map(m => { fnSelectReq(m); });
		}
	});
	
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
	
	function fnSearch() {
		var page = arguments[0];
		var url = '/' + API + '/tribute/request_basket';
		url += '?PAGE=' + page ;
		url += '&REQS=' + Array.from(new Set(reqArr.map(m => m.GROUP_CD))).join('l');
		if(isNotEmpty('${PROJECT_NO}')) {
      		url += '&PROJECT_NO=${PROJECT_NO}';
    	}
		location.href = url;
	}
	
	function removeReqEl() {
    	console.log("번호 1");
		var groupCd = arguments[0];
		var el = event.target;
		var $div = $(el).parent();
		$div.remove();
		
		if($('.request_basket_request_container').find('div').length == 0) {
			$('.request_basket_context_typo').removeClass('hidden');
		}
		suppInfo = suppInfo.map((m, i) => {
			console.log("groupCd :: " + groupCd);
			console.log("m.GROUP_CD_LIST :: " + m.GROUP_CD_LIST);
			if(m.GROUP_CD_LIST.includes(groupCd)) {
				reqArr.map(m2 => {
					if((m2.GROUP_CD == groupCd) && 
							(m.SUPP_CD_LIST.includes(m2.SUPP_CD_1)) && (m.RQST_NO_LIST.includes(m2.RQST_NO.toString()))) {
						console.log("m.CNT :: " + m.CNT);
						console.log("m.CNT2 :: " + m2.CNT);
						m.CNT = +m.CNT - +m2.CNT;
						console.log("result :: " + m.CNT);
					}
				});
			}
			return m;
		})
		.filter(f => f.CNT > 0);
		
		reqArr = reqArr.filter(f => f.GROUP_CD != groupCd);
		rqstNoArr = rqstNoArr.filter(f => f.GROUP_CD != groupCd);
		
		var suppHtml = '';
	  suppInfo.map(m => {
			suppHtml += '<div class="request_basket_total_prosthetics_info_container">';
		  	suppHtml += '	<p class="request_basket_total_prosthetics_info">' + m.SUPP_NM_STR + '</p>';
      		suppHtml += ' <p class="request_basket_total_prosthetics_info">' + m.CNT + '</p>';
      		suppHtml += '</div>';
	  });
	  $('.request_basket_total_prosthetics_info_container_wrapper').html(suppHtml);
	  return;
	}

	function fnSelectReq() {
		var groupCd = arguments[0];
		var pantNm;
		var totalCnt;
		console.log(groupCd);
		if(event) {
			pantNm = $(event.target).parent().prev().find('p').text();
			totalCnt = $(event.target).parent().next().find('p').text();
		}
		var rtnArray = new Array();
		if(!reqArr.some(s => s.GROUP_CD == groupCd)) {
			$.ajax({
			  url: '/' + API + '/tribute/getReqInfo',
			  type: 'GET',
			  data: { GROUP_CD : groupCd },
			  cache: false,
			  async: false,
			  success: function(data) {
			    rtnArray = data;
			    $('.request_basket_context_typo').addClass('hidden');
			    
			    var html = '';
			    html += '<div class="request_basket_request">';
		        html += '	<p class="request_basket_request_name">' + (isEmpty(pantNm) ? rtnArray[0]['PANT_NM'] : pantNm) + '</p>';
		        html += ' <p class="request_basket_request_context">';
	        
	        var duplicateChkSuppArr = new Array();

		        rtnArray.map(m => {
		        	console.log("CNT :: " + m.CNT);
		        	reqArr.push(m);
		        	
		        	if(!duplicateChkSuppArr.includes(m.SUPP_CD_1)) {
			        	duplicateChkSuppArr.push(m.SUPP_CD_1);
			        	html += m.SUPP_NM_1 + ' ' + m.SUPP_GROUP_CNT + '개, ';
		        	}
		        	
		        });
	        
	        html = html.substring(0, html.lastIndexOf(','));
	        html += '	</p>';
	        html += '	<p class="request_basket_request_count">' + (isEmpty(totalCnt) ? rtnArray[0]['TOTAL_CNT'] : totalCnt) + '개</p>';
	        html += ` <img class="request_basket_request_close_button" src="/public/assets/images/request_close_button.svg" style="cursor: pointer;" id="` + groupCd + `" onclick="removeReqEl('` + groupCd + `');"/>`;
	        html += '</div>';
			    $('.request_basket_request_container').append(html);
			  }, complete: function() {
	
			  }, error: function() {
			    
			  }
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
							
							suppHtml += '<div class="request_basket_total_prosthetics_info_container">';
							suppHtml += '	<p class="request_basket_total_prosthetics_info">' + m.SUPP_NM_STR + '</p>';
				      suppHtml += ' <p class="request_basket_total_prosthetics_info">' + m.CNT + '</p>';
				      suppHtml += '</div>';
				      
						});
						
						$('.request_basket_total_prosthetics_info_container_wrapper').html(suppHtml);
						suppInfo = [...suppList];
					}
			  }, 
			  complete: function() {}, 
			  error: function() {}
			});
			
			$.ajax({
			  url: '/' + API + '/tribute/getRqstNoList',
			  type: 'GET',
			  data: { GROUP_CD : groupCd },
			  cache: false,
			  async: false,
			  success: function(data) {
				  for(var i=0; i<data.length; i++) {
					  var rqstNo = data[i].RQST_NO;
					  if(!rqstNoArr.some(s=> s.RQST_NO === rqstNo)) {
						  rqstNoArr.push(data[i]);
					  }
				  }
			  }, 
			  complete: function() {}, 
			  error: function() {}
			});
		}
	}
	
  function fnMoveProject() {
    var gcs = Array.from(new Set(reqArr.map(m => m.GROUP_CD))).join('l');
    var reqs = Array.from(new Set(rqstNoArr.map(m => m.RQST_NO))).join('l');
    if(isEmpty(gcs)) {
      alert(getI8nMsg("alert.nselectReq")); //선택된 의뢰서가 없습니다.
      return;
    }
    var url = '/' + API + '/project/project_request?GCS=' + gcs + '&REQS=' + reqs;
    if(isNotEmpty('${PROJECT_NO}')) {
      url += '&PROJECT_NO=${PROJECT_NO}';
    }
    location.href = url;
  }
  
	function fnDeleteReq() {
		var deleteArr = new Array();
		[...document.querySelectorAll('input[id^=REQ_CHECK]')].map(m => {
			if(m.checked) deleteArr.push(m.value);
		});
		
		if(isEmpty(deleteArr)) {
			alert(getI8nMsg("alert.selectReq"));//의뢰서를 선택해주세요.
			return;
		} else {
			if(confirm('의뢰서를 삭제하시겠습니까?')) {
				$.ajax({
				  url: '/' + API + '/tribute/delete',
				  type: 'POST',
				  data: JSON.stringify({ GROUP_CD_LIST : deleteArr }),
				  contentType: 'application/json; charset=utf-8',
				  cache: false,
				  async: false,
				  success: function(data) {
					  if(data.result == 'Y') {
						  alert(getI8nMsg("alert.delete"));//삭제되었습니다.
						  location.href = '/' + API + '/tribute/request_basket';
					  }
				  }, complete: function() {
				  
				  }, error: function() {
				    
				  }
				});
			}
		}
	}
	var requestPreviewModal;
	
	  $(document).ready(function() {
	    requestPreviewModal = new bootstrap.Modal(document.getElementById('requestModal'));

	  });
	  function fnRequestView() {
		    var groupCd = arguments[0];
		    fnPreview(groupCd);
		    requestPreviewModal.show();
		    $("#Rewritebtn").css("display", "block");
		  }
	function fnCheckAll(obj) {
		var checked = event.target.checked;
		[...document.querySelectorAll('input[id^=REQ_CHECK]')].map(m => { m.checked = checked; });
		
        var chkboxbool = $(obj).attr("chkboxbool");
        console.log("chkboxbool " + chkboxbool);
        var list = $(".request_basket_list_container").find(".request_basket_list").find(".request_basket_checkbox").get();
		console.log("list.length :: " + list.length);
        if(chkboxbool == "0"){
            for(var i = 0;i < list.length;i++){
                $(list[i]).attr("chkboxbool", "1");
                var chkid = $(list[i]).attr("chkid");
                fnSelectReq(chkid);
            }
        }else{
            for(var i = 0;i < list.length;i++){
                $(list[i]).attr("chkboxbool", "0");
                var chkid = $(list[i]).attr("chkid");
                fnSelectReq(chkid);
            }
        }
	}
	
</script>
<jsp:include page="/WEB-INF/views/dialog/request_preview_dialog.jsp" flush="true" />
<div class="request_basket_header">
        <p class="request_basket_header_typo"><spring:message code="req.myReq" text="의뢰서 바구니" /></p>
    </div>
    
    <div class="request_basket_body">
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
                <p class="side_menu_list_typo"><spring:message code="req.reqHis" text="견적·의뢰내역" /></p>
            </a>
            <a href="/${api}/tribute/request_basket" class="side_menu_list">
                <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                <p class="side_menu_list_typo_blue"><spring:message code="req.myReq" text="의뢰서 바구니" /></p>
            </a>
            <a href="/${api}/mypage/equipment_estimator_my_page_progress" class="side_menu_list">
                <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                <p class="side_menu_list_typo"><spring:message code="req.progD" text="진행내역" /></p>
            </a>
            <c:choose>
              <c:when test="${sessionInfo.user.USER_TYPE_CD eq 1 or sessionInfo.user.USER_TYPE_CD eq 2}">
                <a href="/${api}/mypage/profile_management" class="side_menu_list">
                  <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                  <p class="side_menu_list_typo"><spring:message code="prof.mamP" text="프로필 관리" /></p>
                </a>
              </c:when>
              <c:when test="${sessionInfo.user.USER_TYPE_CD eq 3}">
                <a href="/${api}/mypage/profile_management_cheesigner" class="side_menu_list">
                  <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                  <p class="side_menu_list_typo"><spring:message code="prof.mamP" text="프로필 관리" /></p>
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
            <a href="javascript:void(0);" class="side_menu_list" onclick="fnLogOut();">
                <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                <p class="side_menu_list_typo"><spring:message code="logout" text="로그아웃" /></p>
            </a>
        </div>
        <div class="request_basket_list_main_container">
          <div class="request_basket_connection_location_container">
            <a href="/" class="request_basket_connection_location_typo">
              <img class="request_basket_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
            </a>
            <img class="request_basket_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
            <div class="request_basket_connection_location">
              <p class="request_basket_connection_location_typo"><spring:message code="req.myPage" text="마이페이지" /></p>
            </div>
            <img class="request_basket_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
            <div class="request_basket_connection_location">
              <p class="request_basket_connection_location_typo_bold"><spring:message code="req.myReq" text="의뢰서 바구니" /></p>
            </div>
          </div>
          <div class="request_basket_filter_container">
            <div class="request_basket_button_container">
              <div class="request_basket_button_white">
                <p class="request_basket_button_white_typo" style="cursor: pointer;" onclick="fnDeleteReq();">
                  <spring:message code="delete" text="삭제하기" />
                </p>
              </div>
            </div>
<!--             <select name="Option" class="boardtop_select"> -->
<!-- 			        <option value="All" selected>지난 의뢰서 보기</option> -->
<!-- 			        <option value="A">1주일 이내</option> -->
<!-- 			        <option value="B">1달 이내</option> -->
<!-- 			        <option value="C">3개월 이내</option> -->
<!-- 			        <option value="D">1년 이내</option> -->
<!-- 			      </select> -->
          </div>
          <div class="request_basket_list_container">
            <div class="request_basket_list_data_type_container">
              <input class="request_basket_checkbox" type="checkbox" id="REQ_ALL_CHECK" chkboxbool="0" onchange="fnCheckAll(this);" />
              <div class="request_basket_list_data_type request_basket_order">
                <p class="request_basket_list_data_type_typo">NO</p>
              </div>
              <div class="request_basket_list_data_type_margin"></div>
              <div class="request_basket_list_data_type request_basket_name_vol2">
                <p class="request_basket_list_data_type_typo"><spring:message code="req.patientNm" text="환자명" /></p>
              </div>
              <div class="request_basket_list_data_type request_basket_prosthetics_type_vol2">
                <p class="request_basket_list_data_type_typo"><spring:message code="req.prosthT" text="보철 종류" /></p>
              </div>
              <div class="request_basket_list_data_type request_basket_count">
                <p class="request_basket_list_data_type_typo"><spring:message code="req.quant" text="개수" /></p>
              </div>
              <div class="request_basket_list_data_type request_basket_attatchment">
                <p class="request_basket_list_data_type_typo"><spring:message code="req.attach" text="첨부파일" /></p>
              </div>
            </div>
            <script>
            function chkboxChange(obj){
            	var chkboxbool = $(obj).attr("chkboxbool");
            	var chkid = $(obj).attr("chkid");
            	
            	console.log("chkboxbool " + chkboxbool);
            	
            	if(chkboxbool == "0"){
            		console.log("1");
            		fnSelectReq(chkid);
            		$(obj).attr("chkboxbool", "1");
            	}
            	if(chkboxbool == "1"){
            		console.log("2");
            		removeReqEl2(chkid);
            		$(obj).attr("chkboxbool", "0");
            	}
            }
            function removeReqEl2(k){
            	console.log("번호 2");
        		var groupCd = k;
        		var $div = $("#"+groupCd).parent();
        		$div.remove();

        		if($('.request_basket_request_container').find('div').length == 0) {
        			$('.request_basket_context_typo').removeClass('hidden');
        		}
        		
        		suppInfo = suppInfo.map((m, i) => {
        			if(m.GROUP_CD_LIST.includes(groupCd)) {
        				reqArr.map(m2 => {
        					if((m2.GROUP_CD == groupCd) && 
        							(m.SUPP_CD_LIST.includes(m2.SUPP_CD_1)) && (m.RQST_NO_LIST.includes(m2.RQST_NO.toString()))) {
        						m.CNT = +m.CNT - +m2.CNT;
        					}
        				});
        			}
        			return m;
        		})
        		.filter(f => f.CNT > 0);
        		
        		reqArr = reqArr.filter(f => f.GROUP_CD != groupCd);
        		rqstNoArr = rqstNoArr.filter(f => f.GROUP_CD != groupCd);
        		
        		var suppHtml = '';
        	  suppInfo.map(m => {
        			suppHtml += '<div class="request_basket_total_prosthetics_info_container">';
        		  suppHtml += '	<p class="request_basket_total_prosthetics_info">' + m.SUPP_NM_STR + '</p>';
              suppHtml += ' <p class="request_basket_total_prosthetics_info">' + m.CNT + '</p>';
              suppHtml += '</div>';
        	  });
        	  $('.request_basket_total_prosthetics_info_container_wrapper').html(suppHtml);
            }
            </script>
              <c:forEach items="${LIST}" var="item">
	              <div class="list_divider"></div>
	              <div class="request_basket_list">
	                <input class="request_basket_checkbox" type="checkbox" chkboxbool="0" chkid="${item.GROUP_CD}" onclick="chkboxChange(this)" id="REQ_CHECK_${item.GROUP_CD}" value="${item.GROUP_CD}"/>
	                
	                <div class="request_basket_list request_basket_order">
	                  <p class="request_basket_list_order_typo">${item.RN}</p>
	                </div>
	                <div class="request_basket_list request_basket_name_vol2">
	                  <p class="request_basket_list_typo">${item.PANT_NM}</p>
	                </div>
	                <div class="request_basket_list request_basket_prosthetics_type_vol2">
	                  <%-- <p class="request_basket_list_typo" style="cursor: pointer;" onclick="fnSelectReq('${item.GROUP_CD}');">${item.SUPP_NM_STR}</p> --%>
	                  <p class="request_basket_list_typo" style="cursor: pointer;" onclick="fnRequestView('${item.GROUP_CD}');">${item.SUPP_NM_STR}</p>
	                </div>
	                <div class="request_basket_list request_basket_count">
	                  <p class="request_basket_list_typo">${item.TOOTH_CNT}</p>
	                </div>
	                <div class="request_basket_list request_basket_attatchment">
	                  <p class="request_basket_list_typo" style="cursor: pointer;" onclick="fnOpenFileModal('${item.FILE_CD}');"><spring:message code="req.see" text="확인하기" /> (${item.FILE_CNT})</p>
	                </div>
	              </div>
              </c:forEach>
              <c:if test="${empty LIST}">
              	<div class="list_divider"></div>
              	<div class="request_basket_list">
              		<div><p>등록된 의뢰서가 없습니다.</p></div>
              	</div>
              </c:if>
              <div class="list_divider"></div>
          </div>
            
          <!-- 파일 첨부 modal -->
					<div class="modal fade" id="fileModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
						<div class="modal-dialog modal-dialog-centered">
							<div class="modal-content" style="width: fit-content;">
								<div class="dialog_tribute_request_container">
					        <div class="dialog_tribute_request_header">
					          <p class="dialog_tribute_request_header_typo"><spring:message code="req.attach" text="파일 첨부" /></p>
					          <a href="javascript:void(0)" class="dialog_tribute_request_header_close_button_wrapper" data-bs-dismiss="modal">
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
												    <p class="dialog_tribute_request_table_data_type_typo"><spring:message code="docType" text="문서유형" /></p>
												</div>
												<div class="dialog_tribute_request_table_data_type_necessary">
												    <p class="dialog_tribute_request_table_data_type_typo"><spring:message code="nece" text="필수" /></p>
												</div>
												<div class="dialog_tribute_request_table_data_type_file_name">
												    <p class="dialog_tribute_request_table_data_type_typo"><spring:message code="fileNm" text="파일명" /></p>
												</div>
												<div class="dialog_tribute_request_table_data_type_download">
												    <p class="dialog_tribute_request_table_data_type_typo"><spring:message code="download" text="다운로드" /></p>
												</div>
												<div class="dialog_tribute_request_table_data_type_note">
												    <p class="dialog_tribute_request_table_data_type_typo"><spring:message code="note" text="비고" /></p>
												</div>
											</div>
											<div class="dialog_tribute_request_table_data_container file_modal_item">
											  <div class="dialog_tribute_request_table_data_order">
											    <p class="dialog_tribute_request_table_data_typo">1</p>
											  </div>
											  <div class="dialog_tribute_request_table_data_document">
											    <p class="dialog_tribute_request_table_data_typo"><spring:message code="scanfile" text="스캔파일" /></p>
											  </div>
											  <div class="dialog_tribute_request_table_data_necessary">
											    <p class="dialog_tribute_request_table_data_typo">Y</p>
											  </div>
											  <div class="dialog_tribute_request_table_data_file_name">
											    <p class="dialog_tribute_request_table_data_typo file_modal_name"></p>
											  </div>
											  <div class="dialog_tribute_request_table_data_download">
											  	<div class="hidden file_modal_download" style="display: flex; cursor: pointer;">
												    <p class="dialog_tribute_request_table_data_typo"><spring:message code="download" text="다운로드" /></p>
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
											    <p class="dialog_tribute_request_table_data_typo"><spring:message code="etc" text="기타" /></p>
											  </div>
											  <div class="dialog_tribute_request_table_data_necessary">
											    <p class="dialog_tribute_request_table_data_typo">N</p>
											  </div>
											  <div class="dialog_tribute_request_table_data_file_name">
											    <p class="dialog_tribute_request_table_data_typo file_modal_name"></p>
											  </div>
											  <div class="dialog_tribute_request_table_data_download">
											  	<div class="hidden file_modal_download" style="display: flex; cursor: pointer;">
												    <p class="dialog_tribute_request_table_data_typo"><spring:message code="download" text="다운로드" /></p>
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
											    <p class="dialog_tribute_request_table_data_typo"><spring:message code="etc" text="기타" /></p>
											  </div>
											  <div class="dialog_tribute_request_table_data_necessary">
											    <p class="dialog_tribute_request_table_data_typo">N</p>
											  </div>
											  <div class="dialog_tribute_request_table_data_file_name">
											    <p class="dialog_tribute_request_table_data_typo file_modal_name"></p>
											  </div>
											  <div class="dialog_tribute_request_table_data_download">
											  	<div class="hidden file_modal_download" style="display: flex; cursor: pointer;">
												    <p class="dialog_tribute_request_table_data_typo"><spring:message code="download" text="다운로드" /></p>
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
											    <p class="dialog_tribute_request_table_data_typo"><spring:message code="etc" text="기타" /></p>
											  </div>
											  <div class="dialog_tribute_request_table_data_necessary">
											    <p class="dialog_tribute_request_table_data_typo">N</p>
											  </div>
											  <div class="dialog_tribute_request_table_data_file_name">
											    <p class="dialog_tribute_request_table_data_typo file_modal_name"></p>
											  </div>
											  <div class="dialog_tribute_request_table_data_download">
											  	<div class="hidden file_modal_download" style="display: flex; cursor: pointer;">
												    <p class="dialog_tribute_request_table_data_typo"><spring:message code="download" text="다운로드" /></p>
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
											    <p class="dialog_tribute_request_table_data_typo"><spring:message code="etc" text="기타" /></p>
											  </div>
											  <div class="dialog_tribute_request_table_data_necessary">
											    <p class="dialog_tribute_request_table_data_typo">N</p>
											  </div>
											  <div class="dialog_tribute_request_table_data_file_name">
											    <p class="dialog_tribute_request_table_data_typo file_modal_name"></p>
											  </div>
											  <div class="dialog_tribute_request_table_data_download">
											  	<div class="hidden file_modal_download" style="display: flex; cursor: pointer;">
												    <p class="dialog_tribute_request_table_data_typo"><spring:message code="download" text="다운로드" /></p>
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
					            	<p class="dialog_tribute_request_button_typo"><spring:message code="close" text="닫기" /></p>
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
            
            <div class="pagination"></div>
            <div class="request_basket_item">
                <p class="request_basket_title"><spring:message code="proj.request" text="의뢰서" /></p>
                <div class="request_basket_context">
                    <p class="request_basket_context_typo">
                    	선택된 의뢰서가 없습니다.
                    </p>
                    <div class="request_basket_request_container">
                    </div>
                </div>
            </div>
            <div class="dotted_divider_container">
                <img class="dotted_divider without_margin" src="/public/assets/images/dotted_divider.svg"/>
                <img class="dotted_divider without_margin" src="/public/assets/images/dotted_divider.svg"/>
            </div>
            <div class="request_basket_item">
                <p class="request_basket_title"><spring:message code="req.totNum" text="총 개수" /></p>
                <div class="request_basket_total_prosthetics">
                    <div class="request_basket_total_prosthetics_data_type_container">
                        <p class="request_basket_total_prosthetics_data_type"><spring:message code="req.prosthT" text="보철종류" /></p>
                        <p class="request_basket_total_prosthetics_data_type"><spring:message code="req.quant" text="개수" /></p>
                    </div>
                    <div class="request_basket_total_prosthetics_divider"></div>
                    <div class="request_basket_total_prosthetics_info_container_wrapper" style="min-height: 45px;"></div>
                </div>
            </div>
            <div class="request_basket_button_wrapper">
                <a href="/${api}/tribute/tribute_request" class="request_basket_tribute_request_writing_button">
                    <p class="request_basket_tribute_request_writing_button_typo"><spring:message code="req.submReq" text="전자치과기공물 의뢰서 작성하기" /></p>
                </a>
                <button class="request_basket_request_button" onclick="fnMoveProject();">
                    <p class="request_basket_request_button_typo"><spring:message code="req.reqQuotat" text="견적 요청하기" /></p>
                </button>
            </div>
        </div>
    </div>