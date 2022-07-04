<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
<c:if test="${sessionInfo.user.USER_TYPE_CD eq 1}">
  <script>
  alert("의뢰인, 치자이너 회원만 이용 가능합니다.");
  history.back();
</script>
</c:if>
<c:choose>
	<c:when test="${sessionInfo.user.USER_TYPE_CD eq 2 and not empty sessionInfo.user.COMP_FILE_CD}">
	</c:when>
	<c:when test="${sessionInfo.user.USER_TYPE_CD eq 2 and empty sessionInfo.user.COMP_FILE_CD}">
		<script>
		confirmModal();
		</script>
	</c:when>
	      </c:choose>
<script>

  var workItem = new Array();
  var fileArray = new Array();
  
  function fnAllView() {
    location.href = '/' + API + '/processing/processing_center';
  }
  
  function fnSave() {
    
    // 정합성 체크
    var areaCd = $('#AREA_CD').val();
    if(isEmpty(areaCd)) {
    	$('#AREA_CD_DIV_2').removeClass('hidden');
      alert('지역을 선택하세요.');
      return;
    }
    
    var centerNm = $('#CENTER_NM').val();
    if(isEmpty(centerNm)) {
      $('#CENTER_NM').focus();
      alert('센터이름을 입력하세요.');
      return;
    }
    
    if(isEmpty(workItem)) {
    	$('#WORK_ITEM_DIV_2').removeClass('hidden');
      alert('가공 가능 품목을 선택하세요.');
      return;
    }
    
    var intro = $('#INTRO').val();
    if(isEmpty(intro)) {
      $('#INTRO').focus();
      alert('프로필 홍보 및 소개를 입력하세요.');
      return;
    }
    
    var serviceDesc = $('#SERVICE_DESC').val();
    if(isEmpty(serviceDesc)) {
      $('#SERVICE_DESC').focus();
      alert('서비스 설명을 입력하세요.');
      return;
    }
    
    var isConfirm = window.confirm('저장 하시겠습니까?');
    if(!isConfirm) return;
    
    var saveObj = getSaveObj('saveForm');
	  
	  saveObj.WORK_ITEM = JSON.stringify(workItem);
	  
	  $.ajax({
      url: '/' + API + '/processing/save01',
      type: 'POST',
      data: saveObj,
      cache: false,
      async: false,
      success: function(data) {
        if(fileArray.length === 0) {
        	fnAllView();
        } else {
          fnSaveFile();
        }
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  function fnSaveFile() {
    
    var formData = new FormData(document.getElementById('saveForm'));
    for(var key of formData.keys()) {
      formData.set(key, JSON.stringify(formData.get(key)));
    }
    
    for(var i=0; i<fileArray.length; i++) {
      formData.append("files", fileArray[i].FILE);
    }
    
    $.ajax({
      url: '/' + API + '/processing/save02',
      type: 'POST',
      data: formData,
      cache: false,
      async: false,
      contentType: false,
      processData: false,
      success: function(data) {
    	  fnAllView();
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  function fnDelete() {
    
    var isConfirm = window.confirm('삭제 하시겠습니까?');
    if(!isConfirm) return;
    
    $.ajax({
      url: '/' + API + '/processing/delete01',
      type: 'POST',
      data: { PROG_NO : '${DATA.PROG_NO}' },
      cache: false,
      async: false,
      success: function(data) {
        fnAllView();
      }, complete: function() {
      }, error: function() {
      }
    });
    
  }
  
  function fnGetProgWorkItem() {
    $.ajax({
      url: '/' + API + '/processing/getProgWorkItem',
      type: 'GET',
      data: { PROG_NO : '${DATA.PROG_NO}' },
      cache: false,
      async: false,
      success: function(data) {
        if(isNotEmpty(data)) {
        	console.log(data);
          for(var i=0; i<data.length; i++) {
            var item = new Object();
            item.WORK_ITEM_CD = data[i].WORK_ITEM_CD;
            item.WORK_ITEM_NM = data[i].WORK_ITEM_NM;
            workItem.push(item);
          }
          setWorkItem();
        }
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  function fnCancel() {
    fnAllView();
  }
  
  function fnSelect_1() {
    var code = arguments[0];
    var codeNm = arguments[1];
    var target = $('#AREA_CD_DIV_2');
    if(target.hasClass('hidden')) {
      target.removeClass('hidden');
    } else {
      target.addClass('hidden');
    }
    
    $('#WORK_ITEM_DIV_2').addClass('hidden');
    
    if(isNotEmpty(code)) {
      $('#AREA_CD_DIV_1').find('p').html(codeNm);
      $('#AREA_CD').val(code);
    }
  }
  
  function fnSelect_2() {
    var code = arguments[0];
    var codeNm = arguments[1];
    var target = $('#WORK_ITEM_DIV_2');
    if(target.hasClass('hidden')) {
      target.removeClass('hidden');
    } else {
      target.addClass('hidden');
    }
    
    if(isNotEmpty(code)) {
      $('#WORK_ITEM_DIV_1').find('p').html(codeNm);
	    var item = new Object();
	    if(code === 'W006') { // 기타(직접입력)
        $('#WORK_ITEM_ETC_DIV').show();
        $('#WORK_ITEM_ETC').focus();
      } else {
        item.WORK_ITEM_CD = code;
        item.WORK_ITEM_NM = codeNm;
        var isChk = workItem.some((s)=> s.WORK_ITEM_CD === code); // 중복 허용 안함
        if(!isChk) workItem.push(item);
        setWorkItem(); // 가공 가능 품목 세팅
        $('#WORK_ITEM_ETC_DIV').hide();
        $('#WORK_ITEM_ETC').val('');
      }
    }
  }
  
  function setWorkItem() {
    if(isEmpty(workItem)) {
      $('#WORK_ITEM_VIEW_DIV').html('');
    } else {
      var html = '';
      workItem.forEach(function(k,v) {
        html += `<div class="processing_center_profile_profile_info_blank_typo_container">`;
        html += `<p class="processing_center_profile_profile_info_blank_typo being_entered">` + k.WORK_ITEM_NM + `</p>`;
        html += `<img class="processing_center_profile_etc_chosen_close_button" src="/public/assets/images/etc_chosen_close_button.svg" style="cursor: pointer;" onclick="fnDeleteWorkItem('` + k.WORK_ITEM_CD + `', '` + k.WORK_ITEM_NM + `');" />`;
        html += `</div>`;
      });
      if(isNotEmpty(html)) $('#WORK_ITEM_VIEW_DIV').html(html);
    }
  }
  
  function fnDeleteWorkItem() {
    var workItemCd = arguments[0];
    var workItemNm = arguments[1];
    var idx = workItem.findIndex(function(f) {return f.WORK_ITEM_CD === workItemCd});
    if(workItemCd === 'W006') idx = workItem.findIndex(function(f) {return f.WORK_ITEM_CD === workItemCd && f.WORK_ITEM_NM === workItemNm});
    if(idx > -1) workItem.splice(idx, 1);
    setWorkItem();
  }
  
  function fnEtc() {
    var workItemEtc = $('#WORK_ITEM_ETC').val().trim();
    if(isEmpty(workItemEtc)) {
      alert('가공 가능 품목을 입력해 주세요.');
      $('#WORK_ITEM_ETC').focus();
    } else {
      var item = new Object();
      item.WORK_ITEM_CD = 'W006'; // 기타(직접입력)
      item.WORK_ITEM_NM = workItemEtc;
      var isChk = workItem.some((s)=> s.WORK_ITEM_CD === 'W006' && s.WORK_ITEM_NM === workItemEtc); // 중복 허용 안함
      if(!isChk) workItem.push(item);
      setWorkItem();
      $('#WORK_ITEM_ETC').val('');
    }
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
          $('#IMAGE_FILE').prop('src', imgSrc);
        }
        var obj = new Object();
        obj.FILE = file;
        fileArray = new Array();
        fileArray.push(obj);
      } else {
        alert('이미지 파일이 아닙니다.');
        fileArray = new Array();
        $('#IMAGE_FILE').prop('src', defaultImgSrc);
      }
    }
  }
  
  $(document).ready(function() {
    
    var progNo = '${DATA.PROG_NO}';
    if(isNotEmpty(progNo)) {
      fnGetProgWorkItem()
    }
    
    var areaCd = '${DATA.AREA_CD}';
    if(isNotEmpty(areaCd)) {
      $('#p_area_nm').html('${DATA.AREA_NM}');
    }
    
  });
  
</script>

<div class="processing_center_header">
  <p class="processing_center_header_typo">가공센터</p>
</div>

<div class="processing_center_body">
  <div class="side_menu">
    <div class="side_menu_title" style="cursor: pointer;" onclick="fnAllView();">
      <p class="side_menu_title_typo">전체보기</p>
    </div>
    <c:forEach var="item" items="${AREA_CD_LIST}" varStatus="status">
      <a href="/${api}/processing/processing_center?AREA_CD=${item.CODE_CD}" class="side_menu_list">
        <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
        <p class="side_menu_list_typo">${item.CODE_NM}</p>
      </a>
    </c:forEach>
  </div>
  <div class="processing_center_main_container">
    <div class="processing_center_connection_location_container">
      <a href="/" class="processing_center_connection_location_typo">
        <img class="processing_center_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
      </a>
      <img class="processing_center_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
      <div class="processing_center_connection_location">
        <p class="processing_center_connection_location_typo">가공센터</p>
      </div>
      <img class="processing_center_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
      <div class="processing_center_connection_location">
        <p class="processing_center_connection_location_typo">가공센터 전체보기</p>
      </div>
      <img class="processing_center_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
      <div class="processing_center_connection_location">
        <p class="processing_center_connection_location_typo_bold">글쓰기</p>
      </div>
    </div>
    <form:form id="saveForm" name="saveForm" action="" method="post">
      <input type="hidden" id="PROG_NO" name="PROG_NO" value="${DATA.PROG_NO}">
      <input type="hidden" id="AREA_CD" name="AREA_CD" value="${DATA.AREA_CD}">
	    <div class="processing_center_profile_profile_wrapper">
	      <div class="processing_center_profile_profile_container">
	        <div class="processing_center_profile_profile_item_container">
	          <p class="processing_center_profile_profile_item_typo">대표이미지</p>
	          <c:choose>
              <c:when test="${empty sessionInfo.user or (not empty DATA.PROG_NO and DATA.CREATE_ID ne sessionInfo.user.USER_ID)}">
                <div class="processing_center_profile_profile_image_wrapper">
                  <c:choose>
                    <c:when test="${empty DATA.PROFILE_FILE_CD}">
                      <img class="processing_center_profile_profile_image" src="/public/assets/images/profile_image.svg" alt="no_image">
                    </c:when>
                    <c:otherwise>
                      <img class="processing_center_profile_profile_image" src="/upload/${DATA.PROFILE_FILE_DIRECTORY}" alt="${DATA.PROFILE_FILE_DIRECTORY}">
                    </c:otherwise>
                  </c:choose>
                </div>
              </c:when>
              <c:otherwise>
                <c:choose>
                  <c:when test="${empty DATA.PROG_NO or DATA.CREATE_ID eq sessionInfo.user.USER_ID}">
                    <div class="processing_center_profile_profile_image_wrapper" style="cursor: pointer;" onclick="javascript:document.getElementById('imageFileInput').click()">
                      <input id="imageFileInput" type="file" class="hidden" onchange="fnPreviewImage();">
                      <c:choose>
                        <c:when test="${empty DATA.PROFILE_FILE_CD}">
                          <img id="IMAGE_FILE" class="processing_center_profile_profile_image" src="/public/assets/images/profile_image.svg" alt="no_image">
                        </c:when>
                        <c:otherwise>
                          <img id="IMAGE_FILE" class="processing_center_profile_profile_image" src="/upload/${DATA.PROFILE_FILE_DIRECTORY}" alt="${DATA.PROFILE_FILE_DIRECTORY}">
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </c:when>
                </c:choose>
              </c:otherwise>
            </c:choose>
          </div>
	        <div class="processing_center_profile_profile_item_container">
	          <div class="processing_center_profile_profile_item">
	            <p class="processing_center_profile_profile_item_typo">센터이름</p>
	            <div class="processing_center_profile_profile_info_container">
	              <div class="dropbox_processing_center_profile">
	                <div id="AREA_CD_DIV_1" class="dropbox_select_button" onclick="fnSelect_1();" style="cursor: pointer;">
	                  <div class="dropbox_select_button_typo_container">
	                    <p id="p_area_nm" class="dropbox_select_button_typo">지역선택</p>
	                    <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
	                  </div>
	                </div>
	                <div id="AREA_CD_DIV_2" class="dropbox_select_button_item_container_location_small hidden" style="cursor: pointer;">
		                <c:forEach var="item" items="${AREA_CD_LIST}" varStatus="status">
	                    <div class="dropbox_processing_center_profile_select_button_item" onclick="fnSelect_1('${item.CODE_CD}', '${item.CODE_NM}')">
	                      <p class="dropbox_select_button_item_typo">${item.CODE_NM}</p>
	                    </div>
		                </c:forEach>
	                </div>
	              </div>
	              <input id="CENTER_NM" name="CENTER_NM" class="processing_center_profile_profile_info_blank" placeholder="센터이름" value="${DATA.INTRO}">
	            </div>
	          </div>
	          <div class="processing_center_profile_profile_item">
	            <p class="processing_center_profile_profile_item_typo">가공 가능 품목</p>
	            <div class="processing_center_profile_profile_info_container">
	              <div class="dropbox_processing_center_profile">
	                <div id="WORK_ITEM_DIV_1" class="dropbox_processing_center_profile_select_button" onclick="fnSelect_2();" style="cursor: pointer;">
	                  <div class="dropbox_select_button_typo_container">
	                    <p class="dropbox_select_button_typo">품목선택</p>
	                    <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
	                  </div>
	                </div>
	                <div id="WORK_ITEM_DIV_2" class="dropbox_select_button_item_container hidden" style="cursor: pointer;">
	                  <c:forEach var="item" items="${WORK_ITEM_CD_LIST}" varStatus="status">
		                  <div class="dropbox_processing_center_profile_select_button_item" onclick="fnSelect_2('${item.CODE_CD}', '${item.CODE_NM}')">
		                    <p class="dropbox_select_button_item_typo">${item.CODE_NM}</p>
		                  </div>
	                  </c:forEach>
	                </div>
	              </div>
	              <div id="WORK_ITEM_VIEW_DIV" class="processing_center_profile_profile_info_blank"></div>
	            </div>
	            <div id="WORK_ITEM_ETC_DIV" class="processing_center_profile_profile_info_container" style="display: none;">
	              <div class="processing_center_profile_direct_input">
	                <input id="WORK_ITEM_ETC" class="processing_center_profile_direct_input_blank" placeholder="가공 가능 품목을 입력해 주세요."/>
	                <div class="processing_center_profile_direct_input_button" onclick="fnEtc();" style="cursor: pointer;">
	                  <p class="processing_center_profile_direct_input_button_typo">입력</p>
	                </div>
	              </div>
	            </div>
	          </div>
	          <div class="processing_center_profile_profile_item">
	            <p class="processing_center_profile_profile_item_typo">프로필 홍보 및 소개</p>
	            <div class="processing_center_profile_profile_info_container">
	              <input id="INTRO" name="INTRO" class="processing_center_profile_profile_info_blank without_select_button without_margin" placeholder="소개를 작성해 주세요(20자)" maxlength="20" value="${DATA.INTRO}">
	            </div>
	          </div>
	        </div>
	      </div>
	      <div class="processing_center_profile_profile_container">
	        <div class="processing_center_profile_profile_item_container">
	          <div class="processing_center_profile_profile_item_typo_container">
	            <p class="processing_center_profile_profile_item_typo">서비스 설명</p>
	            <p class="processing_center_profile_profile_item_typo">대표전화번호 입력</p>
	          </div>
	          <textarea id="SERVICE_DESC" name="SERVICE_DESC" class="processing_center_profile_profile_item processing_center_profile_service_explanation" placeholder="서비스 설명을 작성해 주세요(최대 1000자)" maxlength="1000">${DATA.SERVICE_DESC}</textarea>
	        </div>
	      </div>
	    </div>
    </form:form>
    <div class="processing_center_profile_button_container">
      <a href="javascript:fnCancel()" class="processing_center_profile_cancel_button">
        <p class="processing_center_profile_cancel_button_typo">목록</p>
      </a>
      <c:if test="${not empty sessionInfo.user and DATA.CREATE_ID eq sessionInfo.user.USER_ID}">
        <a href="javascript:fnDelete()" class="processing_center_profile_cancel_button">
          <p class="processing_center_profile_cancel_button_typo">삭제</p>
        </a>
      </c:if>
      <c:if test="${not empty sessionInfo.user}">
        <c:choose>
          <c:when test="${empty DATA.PROG_NO}">
            <a href="javascript:fnSave();" class="processing_center_profile_writing_button">
              <p class="processing_center_profile_writing_button_typo">등록</p>
            </a>
          </c:when>
          <c:when test="${DATA.CREATE_ID eq sessionInfo.user.USER_ID}">
            <a href="javascript:fnSave();" class="processing_center_profile_writing_button">
              <p class="processing_center_profile_writing_button_typo">수정 </p>
            </a>
          </c:when>
        </c:choose>
      </c:if>
    </div>
  </div>
</div>
