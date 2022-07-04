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
<style>
	.valid-nick { border: 1px solid #10c110; }
	.invalid-nick { border: 1px solid #e34d20; }
</style>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>

isValidNickname = null;
var compFile;

function keyupNickName() {
  isValidNickname = null;
  $('input[id=USER_NICK_NAME]').removeClass('valid-nick invalid-nick');
}

function chkNickNameDuplication() {
  var nickName = $('input[id=USER_NICK_NAME]').val();
  if(nickName && !isValidNickname) {
    if(checkNickName(nickName)) {
      isValidNickname = true;
      alert('사용 가능한 닉네임 입니다.');
	    $('input[id=USER_NICK_NAME]').addClass('valid-nick');
    } else {
    	if('${DATA.USER_NICK_NAME}' == nickName){
    		isValidNickname = true;
    		alert('기존 닉네임 입니다.');
    		$('input[id=USER_NICK_NAME]').addClass('valid-nick');
    	} else{
	      isValidNickname = false;
	      alert('중복된 닉네임 입니다.');
	      $('input[id=USER_NICK_NAME]').focus();
		    $('input[id=USER_NICK_NAME]').addClass('invalid-nick');
    	}
    }
  }
}

function fnSetFile() {
	  var target = event.target;
	  var file = target.files[0];
	  var fileNmInputEl = $(target).prev();
	  fileNmInputEl.val(file.name);

	  if(target.id == 'LICENSE_FILE') licenseFile = file;
	  else if(target.id == 'COMP_FILE') compFile = file;
}

function fnSave() {

    if (validate()) {

        if (isEmpty(isValidNickname)) {
            alert('닉네임 중복 확인이 되지 않았습니다.');
            $('input[id=USER_NICK_NAME]').focus();
            return;
        } else {
            if (!isValidNickname) {
                alert('중복된 닉네임 입니다.');
                $('input[id=USER_NICK_NAME]').focus();
                return;
            }
        }


        if (confirm('정보를 변경 하시겠습니까?')) {

            var formData = new FormData(document.getElementById('mypage_edit_form'));
            for (var key of formData.keys()) {
                formData.set(key, JSON.stringify(formData.get(key)));
            }
            formData.append('COMP_FILE', compFile);

            $.ajax({
                url: '/' + API + '/mypage/edit_info/save07',
                type: 'POST',
                data: formData,
                cache: false,
                async: false,
                contentType: false,
                processData: false,
                success: function(data) {
                    if (data.result == 'Y') {
                        alert('변경이 완료되었습니다.');
                        location.href = '/' + API + '/mypage/my_page_edit_info';
                    }
                },
                complete: function() {

                },
                error: function() {

                }
            });
        }
    }
}

function regCheck(regExp, str) {
    return regExp.test(str);
}

function validate() {
    var result = true;

    $('#mypage_edit_form input.required').each(function(idx, elm) {

        var $elm = $(elm);
        var field = $elm.data('field');
        var value = $elm.val();

        if (value) {
            var regExp;
            if (field == '이메일') {
                regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;
            } else if (field == '휴대폰 번호') {
                regExp = /^01([0|1|6|7|8|9])([0-9]{3,4})([0-9]{4})$/;
            }
            if (regExp && !regCheck(regExp, value)) {
                alert('올바른 ' + field + ' 을(를) 입력해주세요.');
                $elm.focus();
                result = false;
                return false;
            }

            if (field == '비밀번호') {
                var pwChk = $('input[id=USER_PW_CHK]').val();
                if (value != pwChk) {
                    alert('비밀번호가 일치하지 않습니다.');
                    $('input[id=USER_PW_CHK]').focus();
                    result = false;
                    return false;
                }
            }
        } else {
            alert(field + ' 을(를) 입력해주세요.');
            $elm.focus();
            result = false;
            return false;
        }
    });

    return result;
}

function fnView() {}

function fnSelect() {
    var code = arguments[0];
    var codeNm = arguments[1];
    var target = $('#COMP_GROUP_CD_DIV_2');
    if (target.hasClass('hidden')) {
        target.removeClass('hidden');
    } else {
        target.addClass('hidden');
    }

    if (isNotEmpty(code)) {
        $('#COMP_GROUP_CD_P_1').html(codeNm);
        $('input[id=COMP_GROUP_CD]').val(code);
        if (code == 'A003') { // 기타
            $('input[id=COMP_GROUP_NM_ETC]').val('');
            $('input[id=COMP_GROUP_NM_ETC]').show();
        } else {
            $('input[id=COMP_GROUP_NM_ETC]').hide();
            $('input[id=COMP_GROUP_NM]').val(codeNm);
        }
    }
}

function fnSetSelect() {
    var code = '${DATA.COMP_GROUP_CD}';
    var codeNm = '${DATA.COMP_GROUP_NM}';

    if (isNotEmpty(code)) {
        $('#COMP_GROUP_CD_P_1').html(codeNm);
        $('input[id=COMP_GROUP_CD]').val(code);
        if (code == 'A003') { // 기타
            $('input[id=COMP_GROUP_NM_ETC]').val('');
            $('input[id=COMP_GROUP_NM_ETC]').show();
        } else {
            $('input[id=COMP_GROUP_NM_ETC]').hide();
            $('input[id=COMP_GROUP_NM]').val(codeNm);
        }
    }
}

$(document).ready(function() {
 fnSetSelect();
 
 $('#compFileBtn').click(function() {
	  $('input[id=COMP_FILE]').trigger('click');
 });
 
 $('input[id=USER_ADDRESS]').click(function() {
	  new daum.Postcode({
		  oncomplete: function(data) {
			  $('input[id=USER_ADDRESS]').val(data.address);
			  $('input[id=USER_ADDRESS_DTL]').focus();
		  }
	  }).open();
 });
 
 $('input[id=COMP_ADDRESS]').click(function() {
	  new daum.Postcode({
		  oncomplete: function(data) {
			  $('input[id=COMP_ADDRESS]').val(data.address);
			  $('input[id=COMP_ADDRESS_DTL]').focus();
		  }
	  }).open();
 });
 
});
  
</script>


<div class="equipment_estimator_header">
        <p class="equipment_estimator_header_typo">
            마이페이지
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
                <p class="side_menu_list_typo_blue">내정보 수정</p>
            </a>
            <a href="javascript:void(0);" class="side_menu_list" onclick="fnLogOut();">
                <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                <p class="side_menu_list_typo">로그아웃</p>
            </a>
        </div>
        <div class="equipment_estimator_edit_info_main_container">
            <div class="equipment_estimator_connection_location_container">
                <a href="./main.html" class="equipment_estimator_connection_location_typo">
                    <img class="equipment_estimator_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
                </a>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo">마이페이지</p>
                </div>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo_bold">내정보 수정</p>
                </div>
            </div>
            <div class="equipment_estimator_edit_info_wrapper">
            	<form name="mypage_edit_form" id="mypage_edit_form">
                <p class="equipment_estimator_edit_info_title"></p>
                <div class="connection_location_divider divider_without_margin"></div>
                <div class="equipment_estimator_edit_info_container">
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title">이메일(ID겸용)</p>
                        <p class="equipment_estimator_edit_info_item_constant_context">${DATA.USER_ID}</p>
                    </div>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title">비밀번호</p>
                        <input class="equipment_estimator_edit_info_item_blank required" type="password" name="USER_PW" id="USER_PW" data-field="비밀번호" />
                    </div>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title">비밀번호 확인</p>
                        <input class="equipment_estimator_edit_info_item_blank required" type="password" name="USER_PW_CHK" id="USER_PW_CHK" />
                    </div>
                </div>
                <div class="equipment_estimator_edit_info_divider"></div>
                <div class="equipment_estimator_edit_info_container">
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title">이름</p>
                        <p class="equipment_estimator_edit_info_item_constant_context">${DATA.USER_NM}</p>
                    </div>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title">주소</p>
                        <input class="equipment_estimator_edit_info_item_blank required" type="text" name="USER_ADDRESS" id="USER_ADDRESS" data-field="주소" readonly value="${DATA.USER_ADDRESS}"/>
						<input class="equipment_estimator_edit_info_item_blank required" type="text" name="USER_ADDRESS_DTL" id="USER_ADDRESS_DTL" data-field="주소 상세" value="${DATA.USER_ADDRESS_DTL}"/>
                    </div>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title">닉네임(중복조회)</p>
                        <input class="equipment_estimator_edit_info_item_blank required" style="width: 177px;" type="text" name="USER_NICK_NAME" id="USER_NICK_NAME" data-field="닉네임"
										onkeyup="keyupNickName()" value="${DATA.USER_NICK_NAME}"/>
						<button class="equipment_estimator_edit_info_item_button" type="button" onclick="chkNickNameDuplication()" style="cursor: pointer;">
							<p class="equipment_estimator_edit_info_item_button_typo">중복 확인</p>
						</button>
                    </div>
                </div>
                <div class="equipment_estimator_edit_info_divider"></div>
                <div class="equipment_estimator_edit_info_container">
                    <p class="equipment_estimator_edit_info_container_title">추가정보</p>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title">업종선택</p>
                        <input type="hidden" name="COMP_GROUP_NM" id="COMP_GROUP_NM" />
				        <input type="hidden" name="COMP_GROUP_CD" id="COMP_GROUP_CD" />
                        <div class="dropbox_equipment_estimator_edit_info">
                            <div id="COMP_GROUP_CD_DIV_1" class="dropbox_select_button" onclick="fnSelect();" style="cursor: pointer;">
					            <div class="dropbox_select_button_typo_container">
					              <p id="COMP_GROUP_CD_P_1" class="dropbox_select_button_typo">선택</p>
					              <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
					            </div>
					          </div>
					          <div id="COMP_GROUP_CD_DIV_2" class="dropbox_select_button_item_container hidden" style="cursor: pointer;">
					          	<c:if test="${DATA.USER_TYPE eq 1}">
						            <div class="dropbox_select_button_item">
						              <p class="dropbox_select_button_item_typo" onclick="fnSelect('A001', '의료기기판매업')">의료기기판매업</p>
						            </div>
						            <div class="dropbox_select_button_item">
						              <p class="dropbox_select_button_item_typo" onclick="fnSelect('A002', '의료기기제조업')">의료기기제조업</p>
						            </div>
						            <div class="dropbox_select_button_item">
						              <p class="dropbox_select_button_item_typo" onclick="fnSelect('A003', '기타(직접입력)')">기타(직접입력)</p>
						            </div>
					          	</c:if>
					          	<c:if test="${DATA.USER_TYPE ne 1}">
						            <div class="dropbox_select_button_item">
										<p class="dropbox_select_button_item_typo" onclick="fnSelect('B001', '치과')" data-div="COMP_GROUP_CD">치과</p>
									</div>
									<div class="dropbox_select_button_item">
										<p class="dropbox_select_button_item_typo" onclick="fnSelect('B002', '치과기공소')" data-div="COMP_GROUP_CD">치과기공소</p>
									</div>
					          	</c:if>
					          </div>
                        </div>
                         <input class="sign_up_info_item_blank_with_button" type="text" id="COMP_GROUP_NM_ETC"
				              style="width: 253px; margin-left: 10px; height: 40px; display: none;" />
                    </div>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title">사업자등록번호</p>
                        <input class="equipment_estimator_edit_info_item_blank" name="COMP_NO" id="COMP_NO" data-field="사업자등록번호" value="${DATA.COMP_NO}"/>
                    </div>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title">사업장 주소</p>
                        <input class="equipment_estimator_edit_info_item_blank" type="text" name="COMP_ADDRESS" id="COMP_ADDRESS" data-field="사업장 주소"  readonly value="${DATA.COMP_ADDRESS}"/>
                        <input class="equipment_estimator_edit_info_item_blank" type="text" name="COMP_ADDRESS_DTL" id="COMP_ADDRESS_DTL" data-field="사업장 주소 상세"  value="${DATA.COMP_ADDRESS_DTL}"/>
                    </div>
                    
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title">사업자등록증 첨부</p>
                        
                        <input class="equipment_estimator_edit_info_item_blank" data-field="사업자등록증" style="width: 341px;" value="${DATA.FILE_ORIGIN_NM}"/>
						<input type="file" name="COMP_FILE" id="COMP_FILE" style="display: none;" onchange="fnSetFile();" />
						<button class="equipment_estimator_edit_info_item_button" type="button" id="compFileBtn">
							<p class="equipment_estimator_edit_info_item_button_typo">파일첨부</p>
						</button>
                    </div>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title"></p>
                        <p class="equipment_estimator_edit_info_item_caution">※ 소속된 사업장의 정보를 입력해주세요. 미입력시 서비스에 제한이 있을 수 있습니다.</p>
                    </div>
                </div>
                </form>
            </div>
            
            <div class="equipment_estimator_edit_info_button_container">
            	<a href="/${api}/main/main">
                <button class="equipment_estimator_edit_info_button_white">
                    <p class="equipment_estimator_edit_info_button_white_typo">취소</p>
                </button>
                </a>
                <button class="equipment_estimator_edit_info_button_blue" onclick="fnSave();">
                    <p class="equipment_estimator_edit_info_button_blue_typo">확인</p>
                </button>
            </div>
        </div>
    </div>