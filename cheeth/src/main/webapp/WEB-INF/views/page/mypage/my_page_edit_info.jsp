<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:if test="${empty sessionInfo.user}">
	<script>
	alert(getI8nMsg("alert.plzlogin"));
	   location.href = '/api/login/view';
	</script>
</c:if>
<style>
	.valid-nick { border: 1px solid #10c110; }
	.invalid-nick { border: 1px solid #e34d20; }
</style>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
isValidAccount = null;
var pwbool = 0;
isValidNickname = null;
var compFile;
var licenseFile;
var bankbool = 0;
var lang = localStorage.getItem('lang');
function keyupNickName() {
  isValidNickname = null;
  $('input[id=USER_NICK_NAME]').removeClass('valid-nick invalid-nick');
}

function chkNickNameDuplication() {
  var nickName = $('input[id=USER_NICK_NAME]').val();
  if(nickName && !isValidNickname) {
    if(checkNickName(nickName)) {
      isValidNickname = true;
      alert(getI8nMsg("alert.nickAvail")); //사용 가능한 닉네임 입니다.
	    $('input[id=USER_NICK_NAME]').addClass('valid-nick');
    } else {
    	if('${DATA.USER_NICK_NAME}' == nickName){
    		isValidNickname = true;
    		alert(getI8nMsg("alert.nickAlre")); //기존 닉네임 입니다.
    		$('input[id=USER_NICK_NAME]').addClass('valid-nick');
    	} else{
	      isValidNickname = false;
	      alert(getI8nMsg("alert.nickDupli")); //중복된 닉네임 입니다.
	      $('input[id=USER_NICK_NAME]').focus();
		    $('input[id=USER_NICK_NAME]').addClass('invalid-nick');
    	}
    }
  }
}
function chkAccountName() {
	  var bankCd = $('input[id=BANK_CD]').val();
	  var accountNm = $('input[id=ACCOUNT_NM]').val();
	  var accountNo = $('input[id=ACCOUNT_NO]').val();
	  if(bankCd && accountNm && accountNo && !isValidAccount) {
	    if(checkAccount(bankCd, accountNm, accountNo)) {
	      isValidAccount = true;
	      alert(getI8nMsg("alert.accountVerifSu"));//계좌 실명 인증 되었습니다.
		    $('input[id=ACCOUNT_NM]').addClass('valid-account');
	    } else {
	      isValidNickname = false;
	      alert(getI8nMsg("alert.accountInvalid"));//잘못된 계좌 정보입니다. 다시 인증해 주세요
	      $('input[id=ACCOUNT_NM]').focus();
		    $('input[id=ACCOUNT_NM]').addClass('invalid-account');
	    }
	  }
	}
function fnSelect2() {
    
	  var code = arguments[0];
  var codeNm = arguments[1];
  var target;

  if(isObjectType(code) !== 'String') {
  	target = $(arguments[0]).next();
  } else {
  	target = $(event.target).parents('div.codebox2');
  }
  if(target.hasClass('hidden')) {
  	target.removeClass('hidden');
  } else {
  	target.addClass('hidden');
  }
    
  if(isNotEmpty(code) && isObjectType(code) == 'String') {
  	target.prev().find('p').html(codeNm);
    var div = $(event.target).data('div');
    $('input[name=' + div + ']').val(code);
    if(div == 'COMP_GROUP_CD') {
  	  $('input[name=COMP_GROUP_NM]').val(codeNm);
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
        	alert(getI8nMsg("alert.userNmChkFail"));//닉네임 중복 확인이 되지 않았습니다.
            $('input[id=USER_NICK_NAME]').focus();
            return;
        } else {
            if (!isValidNickname) {
            	alert(getI8nMsg("alert.nickDupli")); //중복된 닉네임 입니다.
                $('input[id=USER_NICK_NAME]').focus();
                return;
            }
        }
        if(bankbool == 1){
        	if(isEmpty(isValidAccount)){
        		alert(getI8nMsg("alert.accountAuthFail"));//계좌 본인 인증이 되지 않았습니다.
    			$('input[id=ACCOUNT_NM]').focus();
    			return;
        	} else {
    			if(!isValidAccount) {
    				alert(getI8nMsg("alert.accountAuthFail"));//계좌 본인 인증이 되지 않았습니다.
    				$('input[id=USER_NICK_NAME]').focus();
    				return;
    			}
    		}
        }

        if (confirm(getI8nMsg("alert.confirm.chgInfo"))) {//정보를 변경 하시겠습니까?
            var formData = new FormData(document.getElementById('mypage_edit_form'));

            for (var key of formData.keys()) {
                formData.set(key, JSON.stringify(formData.get(key)));
            }
            formData.append('COMP_FILE', compFile);
            formData.append('LICENSE_FILE', licenseFile);
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
                    	alert(getI8nMsg("alert.change"));//변경이 완료되었습니다.
                        location.href = '/' + API + '/mypage/my_page_edit_info';
                    }
                },
                complete: function() {

                },
                error: function() {

                }
            });
            
            $.ajax({
                url: '/' + API + '/mypage/edit_info/save10',
                type: 'POST',
                data: formData,
                cache: false,
                async: false,
                contentType: false,
                processData: false,
                success: function(data) {
                    if (data.result == 'Y') {
                    	alert(getI8nMsg("alert.change"));//변경이 완료되었습니다.
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
$(function(){
	$('#licenseFileBtn').click(function() {
	  	$('input[id=LICENSE_FILE]').trigger('click');
		});
});
function validate() {
    var result = true;

    $('#mypage_edit_form input.required').each(function(idx, elm) {

        var $elm = $(elm);
        var field = $elm.data('field');
        var value = $elm.val();

        if (value) {
            var regExp;
            if (field == getI8nMsg("email")) {//이메일
                regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;
            } else if (field == getI8nMsg("join.mobNum")) { //휴대폰 번호
                regExp = /^01([0|1|6|7|8|9])([0-9]{3,4})([0-9]{4})$/;
            }
            if (regExp && !regCheck(regExp, value)) {
            	alert(getI8nMsg("alert.param.plzValid", null, field)); //올바른 ' + field + ' 을(를) 입력해주세요.
                $elm.focus();
                result = false;
                return false;
            }

            if (field == getI8nMsg("login.passwd")) { //'비밀번호'
                var pwChk = $('input[id=USER_PW_CHK]').val();
                if (value != pwChk) {
                	alert(getI8nMsg("alert.wrongPw"));//비밀번호가 일치하지 않습니다.
                    $('input[id=USER_PW_CHK]').focus();
                    result = false;
                    return false;
                }
            }
        } else {
        	alert(getI8nMsg("alert.param.plzEnter", null, field)); //field + ' 을(를) 입력해주세요.'
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
function fnSelect3() {
    
	 var code = arguments[0];
	  var codeNm = arguments[1];
	  var target;

	  if(isObjectType(code) !== 'String') {
	  	target = $(arguments[0]).next();
	  } else {
	  	target = $(event.target).parents('div.codebox2');
	  }
	  if(target.hasClass('hidden')) {
	  	target.removeClass('hidden');
	  } else {
	  	target.addClass('hidden');
	  }
	    
	  if(isNotEmpty(code) && isObjectType(code) == 'String') {
	  	target.prev().find('p').html(codeNm);
	    var div = $(event.target).data('div');
	    $('input[name=' + div + ']').val(code);
	    if(div == 'COMP_GROUP_CD') {
	  	  $('input[name=COMP_GROUP_NM]').val(codeNm);
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

 //fnSetSelect();
 var code = '${DATA.COMP_GROUP_CD}';
 var codeNm = '${DATA.COMP_GROUP_NM}';
 setTimeout(function(){
	 $("#COMP_GROUP_CD_P_1").text(codeNm);
 },600);
 //fnSelect(code, codeNm);
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
function keyupAccounNm() {
	  //isValidAccount = null;
	  $('input[id=ACCOUNT_NM]').removeClass('valid-account invalid-account');
	}
</script>


<div class="equipment_estimator_header">
        <p class="equipment_estimator_header_typo">
            <spring:message code="req.manInfo" text="내 정보 수정" />
        </p>
    </div>
    <div class="equipment_estimator_body">
        <div class="side_menu">
            <div class="side_menu_title">
                <p class="side_menu_title_typo">
                    <spring:message code="seeAll" text="전체보기" />
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
                <p class="side_menu_list_typo_blue"><spring:message code="req.manInfo" text="내정보 수정" /></p>
            </a>
            <a href="javascript:void(0);" class="side_menu_list" onclick="fnLogOut();">
                <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                <p class="side_menu_list_typo"><spring:message code="logout" text="로그아웃" /></p>
            </a>
        </div>
        
        <div class="equipment_estimator_edit_info_main_container">
            <div class="equipment_estimator_connection_location_container">
                <a href="./main.html" class="equipment_estimator_connection_location_typo">
                    <img class="equipment_estimator_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
                </a>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo"><spring:message code="req.myPage" text="마이페이지" /></p>
                </div>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo_bold"><spring:message code="req.manInfo" text="내정보 수정" /></p>
                </div>
            </div>
            <div class="equipment_estimator_edit_info_wrapper">
            	<form name="mypage_edit_form" id="mypage_edit_form">
            	<input type="hidden" name="USER_TYPE_CD" value="${sessionInfo.user.USER_TYPE_CD}">
                <p class="equipment_estimator_edit_info_title"></p>
                <div class="connection_location_divider divider_without_margin"></div>
                <div class="equipment_estimator_edit_info_container">
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title"><spring:message code="equ.emailId" text="이메일(ID겸용)" /></p>
                        <p class="equipment_estimator_edit_info_item_constant_context">${DATA.USER_ID}</p>
                    </div>
                    <c:choose>
	                    <c:when test="${fn:contains(DATA.USER_ID, '@')}">
	                    <div class="equipment_estimator_edit_info_item">
	                        <p class="equipment_estimator_edit_info_item_title"><spring:message code="equ.pw" text="비밀번호" /></p>
	                        <input class="equipment_estimator_edit_info_item_blank required" type="password" name="USER_PW" id="USER_PW" data-field="비밀번호" />
	                    </div>
	                    <div class="equipment_estimator_edit_info_item">
	                        <p class="equipment_estimator_edit_info_item_title"><spring:message code="equ.confirmPw" text="비밀번호 확인" /></p>
	                        <input class="equipment_estimator_edit_info_item_blank required" type="password" name="USER_PW_CHK" id="USER_PW_CHK" />
	                    </div>
	                    </c:when>
	                    <c:otherwise>
	                    <script>pwbool = 1;</script>
	                    <input class="equipment_estimator_edit_info_item_blank required" type="hidden" name="USER_PW" id="USER_PW" data-field="비밀번호" value="${DATA.USER_ID}"/>
	                     <input class="equipment_estimator_edit_info_item_blank required" type="hidden" name="USER_PW_CHK" id="USER_PW_CHK" value="${DATA.USER_ID}"/>
	                    </c:otherwise>
                    </c:choose>
                </div>
                <div class="equipment_estimator_edit_info_divider"></div>
                <div class="equipment_estimator_edit_info_container">
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title"><spring:message code="join.nm" text="이름" /></p>
                        <p class="equipment_estimator_edit_info_item_constant_context">${DATA.USER_NM}</p>
                    </div>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title"><spring:message code="join.addr" text="주소" /></p>
                        <input class="equipment_estimator_edit_info_item_blank required" style="margin-left: 37px;" type="text" name="USER_ADDRESS" id="USER_ADDRESS" data-field="주소" readonly value="${DATA.USER_ADDRESS}"/>
						<input class="equipment_estimator_edit_info_item_blank required" type="text" name="USER_ADDRESS_DTL" id="USER_ADDRESS_DTL" data-field="주소 상세" value="${DATA.USER_ADDRESS_DTL}"/>
                    </div>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title"><spring:message code="equ.usrNmChk" text="닉네임(중복조회)" /></p>
                        <input class="equipment_estimator_edit_info_item_blank required" style="width: 177px;" type="text" name="USER_NICK_NAME" id="USER_NICK_NAME" data-field="닉네임"
										onkeyup="keyupNickName()" value="${DATA.USER_NICK_NAME}"/>
						<button class="equipment_estimator_edit_info_item_button" type="button" onclick="chkNickNameDuplication()" style="cursor: pointer;">
							<p class="equipment_estimator_edit_info_item_button_typo"><spring:message code="join.chkAvail" text="중복 확인" /></p>
						</button>
                    </div>
                </div>
                <div class="equipment_estimator_edit_info_divider"></div>
                	<c:if test="${sessionInfo.user.USER_TYPE_CD eq 3}">
                	<script>
                	bankbool = 1;
                	var index = "${DATA.BANK_CD}";
                	if(index != ""){
                    	var bankName = $("#${DATA.BANK_CD}").text();                		
                	}

                	$(document).ready(function(){
                		$(".dropbox_select_button_typo").text(bankName);
                	});
                	</script>
           <div class="sign_up_info_container">
			<div class="sign_up_info_item" >
				<p class="sign_up_info_item_typo"><spring:message code="bank" text="은행" /></p>
				<input type="hidden" name="BANK_CD" id="BANK_CD" data-field="은행선택" value="${DATA.BANK_CD}" required/>
				<div class="dropbox_sign_up_expert_bank">
					<div id="BANK_CD_DIV_1" class="dropbox_select_button codebox1" onclick="fnSelect2(this);" style="cursor: pointer;">
						<div class="dropbox_select_button_typo_container">
							<p class="dropbox_select_button_typo" id="banknm"><spring:message code="req.manInfo" text="선택" /></p>
							<img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg" />
						</div>
					</div>
					<div id="BANK_CD_DIV_2" class="dropbox_select_button_item_container hidden codebox2" style="cursor: pointer;width:171px;height: 500px;overflow: auto;">
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0003" onclick="fnSelect2('0003', '기업')" data-div="BANK_CD">기업</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0004" onclick="fnSelect2('0004', '국민')" data-div="BANK_CD">국민</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0011"onclick="fnSelect2('0011', '농협')" data-div="BANK_CD">농협</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0020"onclick="fnSelect2('0020', '우리')" data-div="BANK_CD">우리</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0081"onclick="fnSelect2('0081', '하나')" data-div="BANK_CD">하나</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0088"onclick="fnSelect2('0088', '신한')" data-div="BANK_CD">신한</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0090"onclick="fnSelect2('0090', '카카오뱅크')" data-div="BANK_CD">카카오뱅크</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0027"onclick="fnSelect2('0027', '한국시티은행')" data-div="BANK_CD">한국시티은행</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0023"onclick="fnSelect2('0023', 'SC제일은행')" data-div="BANK_CD">SC제일은행</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0039"onclick="fnSelect2('0039', '경남은행')" data-div="BANK_CD">경남은행</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0034"onclick="fnSelect2('0034', '광주은행')" data-div="BANK_CD">광주은행</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0031"onclick="fnSelect2('0031', '대구은행')" data-div="BANK_CD">대구은행</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0032"onclick="fnSelect2('0032', '부산은행')" data-div="BANK_CD">부산은행</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0037"onclick="fnSelect2('0037', '전북은행')" data-div="BANK_CD">전북은행</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0035"onclick="fnSelect2('0035', '제주은행')" data-div="BANK_CD">제주은행</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0011"onclick="fnSelect2('0011', '농협은행')" data-div="BANK_CD">농협은행</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0012"onclick="fnSelect2('0012', '지역농축협')" data-div="BANK_CD">지역농축협</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0007"onclick="fnSelect2('0007', '수협은행')" data-div="BANK_CD">수협은행</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0002"onclick="fnSelect2('0002', '산업은행')" data-div="BANK_CD">산업은행</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0071"onclick="fnSelect2('0071', '우체국')" data-div="BANK_CD">우체국</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0045"onclick="fnSelect2('0045', '새마을금고')" data-div="BANK_CD">새마을금고</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0050"onclick="fnSelect2('0050', 'SBI저축은행')" data-div="BANK_CD">저축은행</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0089"onclick="fnSelect2('0089', '케이뱅크')" data-div="BANK_CD">케이뱅크</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" id="0098" onclick="fnSelect2('0098', '토스뱅크')" data-div="BANK_CD">토스뱅크</p>
						</div>
					</div>
				</div>
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo">예금주</p>
				<input class="sign_up_info_item_blank_with_button valid-account required" style="width: 142px;" type="text" name="ACCOUNT_NM" id="ACCOUNT_NM" onkeyup="keyupAccounNm()" data-field="예금주" value="${DATA.ACCOUNT_NM}" required/>
 				<button class="sign_up_info_item_button" type="button" onclick="chkAccountName()">
					<p class="sign_up_info_item_button_typo">본인인증</p>
				</button>
			</div>
			<div class="sign_up_info_item"><spring:message code="join.acntWithout" text='"-"를 제외하고 입력하시기 바랍니다.' />
				<p class="sign_up_info_item_typo"><spring:message code="join.acntno" text="계좌번호" /></p>
				<input class="sign_up_info_item_blank valid-account required" placeholder='<spring:message code="join.acntWithout" text='"-"를 제외하고 입력하시기 바랍니다.' />' type="number" name="ACCOUNT_NO" id="ACCOUNT_NO" data-field="계좌번호" value="${DATA.ACCOUNT_NO}" required/>
			</div>
			
		</div>
		<div class="sign_up_info_container_divider"></div>
		</c:if>
		<c:if test="${sessionInfo.user.USER_TYPE_CD eq 2 or sessionInfo.user.USER_TYPE_CD eq 3}">
			<script>
			$(document).ready(function(){
				var JOB_CD = "${DATA.JOB_CD}";
				
				if(JOB_CD == "J001"){
					$("#jabnm").text(getI8nMsg("dentist"));
				}else if(JOB_CD == "J002"){
					$("#jabnm").text(getI8nMsg("dentalTech"));
				}				
				setTimeout(function(){
					bankbool = 1;
					isValidAccount = true;
				},300);
			});

			</script>
		  <div id="expert_info_container">
	  		<div class="sign_up_info_container">
			<input class="required" type="hidden" name="JOB_CD" id="JOB_CD" value="${DATA.JOB_CD}" data-field="직업" />
			<c:if test="${sessionInfo.user.USER_TYPE_CD eq 3}">
			<div id="cheesigner_job_container" class="sign_up_info_item">
				<p class="sign_up_info_item_typo">직업선택</p>
				<div class="dropbox_sign_up_expert_job">
					<div id="JOB_CD_DIV_1_CHEESIGNER" class="dropbox_select_button codebox1" onclick="fnSelect3(this);" style="cursor: pointer;">
						<div class="dropbox_select_button_typo_container">
							<p class="dropbox_select_button_typo" id="jabnm"><spring:message code="select" text="선택" /></p>
							<img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg" />
						</div>
					</div>
					<div id="JOB_CD_DIV_2_CHEESIGNER" class="dropbox_select_button_item_container hidden codebox2 cheesigner" style="cursor: pointer;">
						<div class="dropbox_select_button_item">
								<p class="dropbox_select_button_item_typo" onclick="fnSelect3('J001', '치과의사');" data-div="JOB_CD">
								  <spring:message code="dentist" text="치과의사" />
								</p>
							</div>
							<div class="dropbox_select_button_item">
								<p class="dropbox_select_button_item_typo" onclick="fnSelect3('J002', '치과기공사');" data-div="JOB_CD">
								  <spring:message code="dentalTech" text="치과기공사" />
								</p>
							</div>
						<%-- <c:forEach items="${jobCdList1}" var="job">
							<div class="dropbox_select_button_item">
								<p class="dropbox_select_button_item_typo" onclick="fnSelect3('${job.CODE_CD}', '${job.CODE_NM}');" data-div="JOB_CD">
								  ${job.CODE_NM}
								</p>
							</div>
						</c:forEach> --%>
					</div>
				</div>
			</div>
			</c:if>
			<c:if test="${sessionInfo.user.USER_TYPE_CD eq 2}">
			<script>
			$(document).ready(function(){
			var JOB_CD = "${DATA.JOB_CD}";
			if(JOB_CD == "K001"){
				$("#jabnm").text(getI8nMsg("dentist")); //치과의사
			}else if(JOB_CD == "K002"){
				$("#jabnm").text(getI8nMsg("dentalTech")); //치과기공사
			}else if(JOB_CD == "K003"){
				$("#jabnm").text(getI8nMsg("dentalHygi")); //치과위생사
			}
			});
			</script>
			<div id="client_job_container" class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="equ.select.profess" text="직업선택" /></p>
				<div class="dropbox_sign_up_expert_job">
					<div id="JOB_CD_DIV_1_CLIENT" class="dropbox_select_button codebox1" onclick="fnSelect3(this);" style="cursor: pointer;">
						<div class="dropbox_select_button_typo_container">
							<p class="dropbox_select_button_typo" id="jabnm"><spring:message code="select" text="선택" /></p>
							<img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg" />
						</div>
					</div>
					<div id="JOB_CD_DIV_2_CLIENT" class="dropbox_select_button_item_container hidden codebox2 cheesigner" style="cursor: pointer;">
						<c:forEach items="${jobCdList2}" var="job">
							<div class="dropbox_select_button_item">
								<p class="dropbox_select_button_item_typo" onclick="fnSelect3('${job.CODE_CD}', '${job.CODE_NM}');" data-div="JOB_CD">
								  ${job.CODE_NM}
								</p>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
			</c:if>
           <div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="equ.attachL" text="면허증 첨부" /></p>
				<input class="sign_up_info_item_blank_with_button required" style="width: 341px;" value="${DATA.LICENSE_FILE}" data-field="면허증"/>
				<input type="file" name="LICENSE_FILE" id="LICENSE_FILE" style="display: none;" onchange="fnSetFile();"/>
				<input type="hidden" name="licensecd" value="${DATA.LICENSE_FILE_CD}">
				<button class="sign_up_info_item_button" type="button" id="licenseFileBtn">
					<p class="sign_up_info_item_button_typo"><spring:message code="join.attachF" text="파일첨부" /></p>
				</button>
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="equ.licenNum" text="면허증 번호" /></p>
				<input type="hidden" name="licenseNO" value="${DATA.LICENSE_NO}">
				<input class="sign_up_info_item_blank required" type="text" name="LICENSE_NO" value="${DATA.LICENSE_NO}" id="LICENSE_NO" data-field="면허증 번호" />
			</div>
			</div>
			</div>
        </c:if>
        
        <c:if test="${sessionInfo.user.USER_TYPE_CD eq 1}">
        <input type="file" name="LICENSE_FILE" id="LICENSE_FILE" style="display: none;" onchange="fnSetFile();"/>
        </c:if>
        	    <script>
	    var aaa = "${DATA.ACCOUNT_NM}";
	    var bbb = "${DATA.ACCOUNT_NO}";
	    var ccc = "${DATA.BANK_CD}";
	    var banknm = "";
	    var bankcd = "${DATA.BANK_CD}";
	      if(bankcd == "0003") {
	    	  banknm = "기업";
	      }else if(bankcd=="0004") {
	    	  banknm = "국민";
	      }else if(bankcd=="0011") {
	    	  banknm = "농협";
	      }else if(bankcd=="0020") {
	    	  banknm = "우리";
	      }else if(bankcd=="0081") {
	    	  banknm = "하나";
	      }else if(bankcd=="0088") {
	    	  banknm = "신한";
	      }else if(bankcd=="0090") {
	    	  banknm = "카카오뱅크";
	      }else if(bankcd=="0027") {
	    	  banknm = "한국시티은행";
	      }else if(bankcd=="0023") {
	    	  banknm = "SC제일은행";
	      }else if(bankcd=="0039") {
	    	  banknm = "경남은행";
	      }else if(bankcd=="0034") {
	    	  banknm = "광주은행";
	      }else if(bankcd=="0031") {
	    	  banknm = "대구은행";
	      }else if(bankcd=="0032") {
	    	  banknm = "부산은행";
	      }else if(bankcd=="0037") {
	    	  banknm = "전북은행";
	      }else if(bankcd=="0035") {
	    	  banknm = "제주은행";
	      }else if(bankcd=="0011") {
	    	  banknm = "농협은행";
	      }else if(bankcd=="0012") {
	    	  banknm = "지역농축협";
	      }else if(bankcd=="0007") {
	    	  banknm = "수협은행";
	      }else if(bankcd=="0002") {
	    	  banknm = "산업은행";
	      }else if(bankcd=="0071") {
	    	  banknm = "우체국";
	      }else if(bankcd=="0045") {
	    	  banknm = "새마을금고";
	      }else if(bankcd=="0050") {
	    	  banknm = "SBI저축은행";
	      }else if(bankcd=="0089") {
	    	  banknm = "케이뱅크";
	      }else if(bankcd=="0098") {
	    	  banknm = "토스뱅크";
	      }
	      $(document).ready(function(){
	    	  $("#banknm").text(banknm);
	      });
	    </script>
                <div class="equipment_estimator_edit_info_container">
                    <p class="equipment_estimator_edit_info_container_title"><spring:message code="join.addInfo" text="추가정보" /></p>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title"><spring:message code="join.selectBiz" text="업종선택" /></p>
                        <input type="hidden" name="COMP_GROUP_NM" id="COMP_GROUP_NM" value="${DATA.COMP_GROUP_NM}"/>
				        <input type="hidden" name="COMP_GROUP_CD" id="COMP_GROUP_CD" value="${DATA.COMP_GROUP_CD}"/>
                        <div class="dropbox_equipment_estimator_edit_info">
                            <div id="COMP_GROUP_CD_DIV_1" class="dropbox_select_button" onclick="fnSelect();" style="cursor: pointer;">
					            <div class="dropbox_select_button_typo_container">
					              <p id="COMP_GROUP_CD_P_1" class="dropbox_select_button_typo">${DATA.COMP_GROUP_NM}</p>
					              <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
					            </div>
					          </div>
					          <div id="COMP_GROUP_CD_DIV_2" class="dropbox_select_button_item_container hidden" style="cursor: pointer;">
					          	<c:if test="${DATA.USER_TYPE_CD eq 1}">
						            <div class="dropbox_select_button_item">
						              <p class="dropbox_select_button_item_typo" onclick="fnSelect('A001', getI8nMsg('join.mediSalebiz'))"><spring:message code="join.mediSalebiz" text="의료기기판매업" /></p>
						            </div>
						            <div class="dropbox_select_button_item">
						              <p class="dropbox_select_button_item_typo" onclick="fnSelect('A002', getI8nMsg('join.mediManufu'))"><spring:message code="join.mediManufu" text="의료기기제조업" /></p>
						            </div>
						            <div class="dropbox_select_button_item">
						              <p class="dropbox_select_button_item_typo" onclick="fnSelect('A003', getI8nMsg('join.mediEtc'))"><spring:message code="join.mediEtc" text="기타(직접입력)" /></p>
						            </div>
					          	</c:if>
					          	<c:if test="${DATA.USER_TYPE_CD ne 1}">
						            <div class="dropbox_select_button_item">
										<p class="dropbox_select_button_item_typo" onclick="fnSelect('B001', '치과')" data-div="COMP_GROUP_CD"><spring:message code="join.dental" text="치과" /></p>
									</div>
									<div class="dropbox_select_button_item">
										<p class="dropbox_select_button_item_typo" onclick="fnSelect('B002', '치과기공소')" data-div="COMP_GROUP_CD"><spring:message code="join.dentalLabor" text="치과기공소" /></p>
									</div>
					          	</c:if>
					          </div>
                        </div>
                         <input class="sign_up_info_item_blank_with_button" type="text" id="COMP_GROUP_NM_ETC"
				              style="width: 253px; margin-left: 10px; height: 40px; display: none;" />
                    </div>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title"><spring:message code="join.bizNum" text="사업자등록번호" /></p>
                        <input class="equipment_estimator_edit_info_item_blank" name="COMP_NO" id="COMP_NO" data-field="사업자등록번호" value="${DATA.COMP_NO}"/>
                    </div>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title"><spring:message code="join.compAddr" text="사업장 주소" /></p>
                        <input class="equipment_estimator_edit_info_item_blank" style="margin-left: 37px;" type="text" name="COMP_ADDRESS" id="COMP_ADDRESS" data-field="사업장 주소"  readonly value="${DATA.COMP_ADDRESS}"/>
                        <input class="equipment_estimator_edit_info_item_blank" type="text" name="COMP_ADDRESS_DTL" id="COMP_ADDRESS_DTL" data-field="사업장 주소 상세"  value="${DATA.COMP_ADDRESS_DTL}"/>
                    </div>
                    
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title"><spring:message code="join.attachBizRegi" text="사업자등록증 첨부" /></p>
                        <input type="hidden" name="compfile" value="${DATA.COMP_FILE_CD}">
                        <input class="equipment_estimator_edit_info_item_blank" data-field="사업자등록증" style="width: 341px;" value="${DATA.FILE_ORIGIN_NM}"/>
						<input type="file" name="COMP_FILE" id="COMP_FILE" style="display: none;" onchange="fnSetFile();" />
						<button class="equipment_estimator_edit_info_item_button" type="button" id="compFileBtn">
							<p class="equipment_estimator_edit_info_item_button_typo"><spring:message code="join.attachF" text="파일첨부" /></p>
						</button>
                    </div>
                    <div class="equipment_estimator_edit_info_item">
                        <p class="equipment_estimator_edit_info_item_title"></p>
                        <p class="equipment_estimator_edit_info_item_caution">※ <spring:message code="join.enter.bizInfo" text="소속된 사업장의 정보를 입력해주세요. 미입력시 서비스에 제한이 있을 수 있습니다." /></p>
                    </div>
                </div>
                </form>
            </div>
            
            <div class="equipment_estimator_edit_info_button_container">
            	<a href="/${api}/main/main">
                <button class="equipment_estimator_edit_info_button_white">
                    <p class="equipment_estimator_edit_info_button_white_typo"><spring:message code="cancel" text="취소" /></p>
                </button>
                </a>
                <button class="equipment_estimator_edit_info_button_blue" onclick="fnSave();">
                    <p class="equipment_estimator_edit_info_button_blue_typo"><spring:message code="save" text="확인" /></p>
                </button>
            </div>
        </div>
    </div>
        <style>
    .swiper-slide{
        width: 214px;
    height: 180px;
    margin-right: 24px;
    }
    #IMAGE_FILE{
    	width: 100%;
    }
    </style>