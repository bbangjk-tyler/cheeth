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
<script>
  
  var profileFileArray = new Array();
  var imageFileArray = new Array();
  
  function fnSaveNickName() {
    
    var userNickName = $('#USER_NICK_NAME').val();
    if(isEmpty(userNickName)) {
      alert('닉네임을 입력하세요.');
      $('#USER_NICK_NAME').focus();
      return;
    }
    
    var isConfirm = window.confirm('닉네임을 변경 하시겠습니까?\n닉네임 변경 시 새로고침 됩니다.');
    if(!isConfirm) return;
    
    $.ajax({
    	url: '/' + API + '/mypage/profile_management_cheesigner/save08',
      type: 'POST',
      data: { USER_NICK_NAME : $('#USER_NICK_NAME').val() },
      cache: false,
      async: false,
      success: function(data) {
        if(data.result === 'N' && isNotEmpty(data.message)) {
          alert(data.message);
        } else {
          location.href = '/' + API + '/mypage/profile_management_cheesigner';
        }
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  function fnSave() {
    
    var projectCd8 = $('#PROJECT_CD_8').is(':checked');
    var projectNm8 = $('#PROJECT_NM_8').val();
    
    if(projectCd8 && isEmpty(projectNm8)) {
      alert('기타를 입력하세요.');
      $('#PROJECT_NM_8').focus();
      return;
    }
    
    var isConfirm = window.confirm('저장 하시겠습니까?');
    if(!isConfirm) return;
    
    var formData = new FormData(document.getElementById('saveForm'));
    for(var key of formData.keys()) {
      formData.set(key, JSON.stringify(formData.get(key)));
    }
    
    for(var i=0; i<profileFileArray.length; i++) {
      formData.append("profile_files", profileFileArray[i].FILE);
    }
    
    for(var i=0; i<imageFileArray.length; i++) {
      formData.append("image_files", imageFileArray[i].FILE);
    }
    
    $.ajax({
      url: '/' + API + '/mypage/profile_management_cheesigner/save09',
      type: 'POST',
      data: formData,
      cache: false,
      async: false,
      contentType: false,
      processData: false,
      success: function(data) {
        location.href = '/' + API + '/mypage/profile_management_cheesigner';
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  function fnPreviewImage() {
    var target = arguments[0];
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
          if(target === 'profile') {
            $('#PROFILE_FILE').prop('src', imgSrc);
          } else if(target === 'image') {
            $('#IMAGE_FILE').prop('src', imgSrc);
          }
        }
        var obj = new Object();
        obj.FILE = file;
        if(target === 'profile') {
        	profileFileArray = new Array();
          profileFileArray.push(obj);
        } else if(target === 'image') {
        	imageFileArray = new Array();
          imageFileArray.push(obj);
        }
      } else {
        alert('이미지 파일이 아닙니다.');
        if(target === 'profile') {
          profileFileArray = new Array();
          $('#PROFILE_FILE').prop('src', defaultImgSrc);
        } else if(target === 'image') {
          imageFileArray = new Array();
          $('#IMAGE_FILE').prop('src', defaultImgSrc);
        }
      }
    }
  }
  
  function fnProject() {
    var projectCd = arguments[0];
    if(projectCd === 'P008') {
      var projectCd8 = $('#PROJECT_CD_8').is(':checked');
      var projectNm8 = $('#PROJECT_NM_8').val();
      if(projectCd8) {
        $('#PROJECT_NM_8').focus();
      } else {
        $('#PROJECT_NM_8').val('');
      }
    }
  }
  
  $(document).ready(function() {
    
   var projectCd1 = '${DATA.DATA_02.PROJECT_CD_1}';
   var projectCd2 = '${DATA.DATA_02.PROJECT_CD_2}';
   var projectCd3 = '${DATA.DATA_02.PROJECT_CD_3}';
   var projectCd4 = '${DATA.DATA_02.PROJECT_CD_4}';
   var projectCd5 = '${DATA.DATA_02.PROJECT_CD_5}';
   var projectCd6 = '${DATA.DATA_02.PROJECT_CD_6}';
   var projectCd7 = '${DATA.DATA_02.PROJECT_CD_7}';
   var projectCd8 = '${DATA.DATA_02.PROJECT_CD_8}';
   
   if(isNotEmpty(projectCd1)) $('#PROJECT_CD_1').prop('checked', true);
   if(isNotEmpty(projectCd2)) $('#PROJECT_CD_2').prop('checked', true);
   if(isNotEmpty(projectCd3)) $('#PROJECT_CD_3').prop('checked', true);
   if(isNotEmpty(projectCd4)) $('#PROJECT_CD_4').prop('checked', true);
   if(isNotEmpty(projectCd5)) $('#PROJECT_CD_5').prop('checked', true);
   if(isNotEmpty(projectCd6)) $('#PROJECT_CD_6').prop('checked', true);
   if(isNotEmpty(projectCd7)) $('#PROJECT_CD_7').prop('checked', true);
   if(isNotEmpty(projectCd8)) $('#PROJECT_CD_8').prop('checked', true);
   
  });
  
</script>

<div class="equipment_estimator_header">
  <p class="equipment_estimator_header_typo">프로필 관리</p>
</div>
<div class="equipment_estimator_body">
  <div class="side_menu">
    <div class="side_menu_title">
      <p class="side_menu_title_typo">전체보기</p>
    </div>
    <a href="/${api}/mypage/equipment_estimator_my_page_equipment" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo">견적·의뢰내역</p>
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
          <p class="side_menu_list_typo_blue">프로필 관리</p>
        </a>
      </c:when>
      <c:when test="${sessionInfo.user.USER_TYPE_CD eq 3}">
        <a href="/${api}/mypage/profile_management_cheesigner" class="side_menu_list">
          <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
          <p class="side_menu_list_typo_blue">프로필 관리</p>
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
  <form:form id="saveForm" name="saveForm">
	  <div class="profile_management_main_container">
	    <div class="profile_management_connection_location_container">
	      <a href="/" class="profile_management_connection_location_typo">
	        <img class="profile_management_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
	      </a>
	      <img class="profile_management_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="profile_management_connection_location">
	        <p class="profile_management_connection_location_typo">마이페이지</p>
	      </div>
	      <img class="profile_management_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="profile_management_connection_location">
	        <p class="profile_management_connection_location_typo">프로필관리</p>
	      </div>  
	      <img class="profile_management_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="profile_management_connection_location">
	        <p class="profile_management_connection_location_typo_bold">프로필 수정하기</p>
	      </div>
	    </div>
	    <div class="connection_location_divider"></div>
	    <div class="profile_management_profile_container">
	      <div class="profile_management_writing_profile_item basic_info_writing">
	        <p class="profile_management_writing_profile_item_title">프로필 작성</p>
	        <div class="profile_management_profile_item_context">
	          <div class="profile_management_profile_item_wrap">
              <div class="profile_management_profile_item_item">
                <c:choose>
                  <c:when test="${empty DATA.DATA_02.PROFILE_FILE_CD}">
                    <img id="PROFILE_FILE" class="profile_management_writing_profile_pic_upload" src="/public/assets/images/profile_management_writing_profile_pic_upload.svg" alt="no_image">
                  </c:when>
                  <c:otherwise>
                    <img id="PROFILE_FILE" class="profile_management_writing_profile_pic_upload" src="/upload/${DATA.DATA_02.PROFILE_FILE_DIRECTORY}" alt="${DATA.DATA_02.PROFILE_FILE_ORIGIN_NM}">
                  </c:otherwise>
                </c:choose>
              </div>
	            <button type="button" class="profile_img_btn" onclick="javascript:document.getElementById('profileFileInput').click()">
	              <span>프로필사진 변경</span>
	            </button>
	            <input id="profileFileInput" type="file" class="hidden" onchange="fnPreviewImage('profile');">
	          </div>
	          <div class="profile_management_writing_basic_info_container">
	            <div class="profile_management_writing_basic_info">
	              <p class="profile_management_writing_basic_info_title">닉네임</p>
	              <input class="profile_management_writing_basic_info_input" id="USER_NICK_NAME" name="USER_NICK_NAME" maxlength="15" value="${DATA.DATA_01.USER_NICK_NAME}">
	              <button type="button" class="profile_management_writing_basic_info_input_button" onclick="fnSaveNickName();">
                  <p class="profile_management_writing_basic_info_input_button_typo">닉네임 변경</p>
                </button>
	            </div>
	            <div class="main_container_divider without_margin"></div>
	            <div class="profile_management_writing_basic_info">
	              <p class="profile_management_writing_basic_info_title">회원구분</p>
	              <p class="profile_management_writing_basic_info_context">${DATA.DATA_01.USER_TYPE_NM}</p>
	            </div>
	            <div class="main_container_divider without_margin"></div>
	            <div class="profile_management_writing_basic_info">
	              <p class="profile_management_writing_basic_info_title">세금계산서 발행가능 유무</p>
	              <div class="dropbox_profile_management_writing_basic_info_container">
	                <select id="TAX_BILL_YN" name="TAX_BILL_YN" class="select">
	                  <option value="" <c:if test="${empty DATA.DATA_02.TAX_BILL_YN}">selected="selected"</c:if>>::선택::</option>
	                  <option value="Y" <c:if test="${DATA.DATA_02.TAX_BILL_YN eq 'Y'}">selected="selected"</c:if>>유</option>
	                  <option value="N" <c:if test="${DATA.DATA_02.TAX_BILL_YN eq 'N'}">selected="selected"</c:if>>무</option>
	                </select>
	              </div>
	            </div>
	          </div>
	        </div>
	      </div>
	      <div class="main_container_divider without_margin"></div>
	      <div class="profile_management_profile_item etc_info_writing">
	        <p class="profile_management_writing_profile_item_title">내 거래 정보</p>
	        <div class="profile_management_writing_profile_etc_info_success_rate">
	          <p class="profile_management_writing_profile_etc_info_title">거래성공률</p>
	          <div class="profile_management_writing_profile_etc_info_context_container">
	            <p class="profile_management_writing_profile_etc_info_context">${DATA.DATA_03.COMPLETE_RATIO}</p>
	            <p class="profile_management_writing_profile_etc_info_context">&nbsp;%</p>
	          </div>
	        </div>
	        <div class="profile_management_writing_profile_etc_info_satisfaction">
	          <p class="profile_management_writing_profile_etc_info_title">만족도</p>
	          <div class="profile_management_writing_profile_etc_info_context_container">
	            <p class="profile_management_writing_profile_etc_info_context">${DATA.DATA_03.SCORE_AVG}</p>
	            <p class="profile_management_writing_profile_etc_info_context">/10</p>
	          </div>
	        </div>
	        <div class="profile_management_writing_profile_etc_info_total_project">
	          <p class="profile_management_writing_profile_etc_info_title">거래 총 프로젝트 수</p>
	          <div class="profile_management_writing_profile_etc_info_context_container">
	            <p class="profile_management_writing_profile_etc_info_context">${DATA.DATA_03.COMPLETE_CNT}</p>
	            <p class="profile_management_writing_profile_etc_info_context">건</p>
	          </div>
	        </div>
	        <div class="profile_management_writing_profile_etc_info_total_price">
	          <p class="profile_management_writing_profile_etc_info_title">거래 총 금액</p>
	          <div class="profile_management_writing_profile_etc_info_context_container">
	            <p class="profile_management_writing_profile_etc_info_context">${DATA.DATA_03.COMPLETE_AMOUNT}</p>
	            <p class="profile_management_writing_profile_etc_info_context">원</p>
	          </div>
	        </div>
	        <!-- <div class="profile_management_writing_profile_etc_info_mean_response">
	          <p class="profile_management_writing_profile_etc_info_title">평균응답시간</p>
	          <div class="profile_management_writing_profile_etc_info_context_container">
	            <p class="profile_management_writing_profile_etc_info_context">1</p>
	            <p class="profile_management_writing_profile_etc_info_context">시간&nbsp;&nbsp;~&nbsp;&nbsp;</p>
	            <p class="profile_management_writing_profile_etc_info_context">2</p>
	            <p class="profile_management_writing_profile_etc_info_context">시간</p>
	          </div>
	        </div> -->
	      </div>
	      <div class="main_container_divider without_margin"></div>
	      <div class="profile_management_writing_profile_item self_intro_writing">
	        <p class="profile_management_writing_profile_item_title">자기소개</p>
	        <textarea class="profile_management_writing_profile_self_intro_context_input" id="INTRO_CONTENT" name="INTRO_CONTENT" placeholder="자기소개를 작성해 주세요">${DATA.DATA_02.INTRO_CONTENT}</textarea>
	      </div>
	      <div class="main_container_divider without_margin"></div>
	      <div class="profile_management_writing_profile_item career_writing">
	        <p class="profile_management_writing_profile_item_title">경력</p>
	        <div class="profile_management_writing_profile_career_container">
	          <c:forEach var="item" items="${DATA.CAREER_CD_LIST}" varStatus="status">
	            <label class="checkbox_small">
	              <input type="radio" id="CAREER_CD_${status.count}" name="CAREER_CD" value="${item.CODE_CD}" <c:if test="${DATA.DATA_02.CAREER_CD eq item.CODE_CD}">checked="checked"</c:if>>
	              ${item.CODE_NM}
	            </label>
	          </c:forEach>
	        </div>
	      </div>
	      <div class="main_container_divider without_margin"></div>
	      <div class="profile_management_profile_item design_field_writing">
	        <p class="profile_management_writing_profile_item_title">디자인 활동 분야</p>
	        <div class="profile_management_writing_profile_design_main_container">
	          <div class="profile_management_writing_profile_design_field_container">
	            <c:forEach var="item" items="${DATA.PROJECT_CD_LIST}" varStatus="status">
	              <label class="checkbox_small">
	                <input type="checkbox" id="PROJECT_CD_${status.count}" name="PROJECT_CD_${status.count}" value="${item.CODE_CD}" onchange="fnProject('${item.CODE_CD}');">
	                ${item.CODE_NM}
	              </label>
	            </c:forEach>
	            <div class="profile_management_profile_design_field_etc_direct_input">
	              <input id="PROJECT_NM_8" name="PROJECT_NM_8" class="profile_management_profile_design_field_etc_direct_input_blank" maxlength="30" placeholder="기타(직접작성)" value="${DATA.DATA_02.PROJECT_NM_8}">
	            </div>
	          </div>
	        </div>
	      </div>
	      <div class="main_container_divider without_margin"></div>
	      <div class="profile_management_writing_profile_item pic_writing">
	        <div class="profile_management_writing_profile_item_title_container">
	          <p class="profile_management_writing_profile_item_title">사진 업로드</p>
<!-- 	          <p class="profile_management_writing_profile_item_sub_title">사진을 업로드 해주세요.</p> -->
	        </div>
	        <div class="profile_management_writing_profile_item_context">
	          <div class="profile_management_pic_upload_wrapper">
	            <div class="profile_management_main_pic_upload_wrapper">
	              
	              <c:choose>
                  <c:when test="${empty DATA.DATA_02.IMAGE_FILE_CD}">
                    <img id="IMAGE_FILE" class="profile_management_main_pic_upload" src="/public/assets/images/profile_image.svg" alt="no_image">
                  </c:when>
                  <c:otherwise>
                    <img id="IMAGE_FILE" class="profile_management_main_pic_upload" src="/upload/${DATA.DATA_02.IMAGE_FILE_DIRECTORY}" alt="${DATA.DATA_02.IMAGE_FILE_ORIGIN_NM}">
                  </c:otherwise>
                </c:choose>
	            </div>
	            <input id="imageFileInput" type="file" class="hidden" onchange="fnPreviewImage('image');">
	            <button type="button" class="profile_management_pic_upload_button" onclick="javascript:document.getElementById('imageFileInput').click()">
	              <p class="profile_management_pic_upload_button_typo">이미지 업로드</p>
	            </button>
	          </div>
	        </div>
	      </div>
	      <div class="profile_management_writing_button_wrapper">
	        <div class="profile_management_writing_button_container">
	          <a href="javascript:fnSave();" class="profile_management_writing_button_blue">
	            <p class="profile_management_writing_button_blue_typo">저장하기</p>
	          </a>
	        </div>
	      </div>
	    </div>
	  </div>
  </form:form>
</div>
