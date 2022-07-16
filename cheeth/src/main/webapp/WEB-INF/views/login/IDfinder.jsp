<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
	.valid-nick { border: 1px solid #10c110; }
	.invalid-nick { border: 1px solid #e34d20; }
	.valid-phone { border: 1px solid #10c110; }
	.invalid-phone { border: 1px solid #e34d20; }
</style>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
  
  isValidNickname = null;
  isValidPhone = null;
  
  var compFile;
  var Choicebool = 0;
  function fnSave() {
		if(validate()) {
			
			
	        if(isEmpty(isValidPhone)) {
	            alert('휴대폰 인증이 되지 않았습니다.');
	            $('input[id=USER_PHONE]').focus();
	            return;
	        } else {
	            if(!isValidPhone) {
	                alert('휴대폰 인증이 되지 않았습니다.');
	                $('input[id=USER_PHONE]').focus();
	                return;
	            }
	        }

		    var formData = new FormData(document.getElementById('sign_up_form'));

			$("#sign_up_form").submit();

		  
		}
  }

  function regCheck(regExp, str) {
	  return regExp.test(str);
  }
  
  function validate() {
	  var result = true;
	  
	  $('#sign_up_form input.required').each(function(idx, elm) {
		  
		  var $elm = $(elm);
		  var field = $elm.data('field');
		  var value = $elm.val();
		  
		  if(value) {
			  var regExp;
			  if(field == '이메일') {
				  regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;
			  } else if(field == '휴대폰 번호') {
				  regExp = /^01([0|1|6|7|8|9])([0-9]{3,4})([0-9]{4})$/;
			  }
			  if(regExp && !regCheck(regExp, value)) {
				  alert('올바른 ' + field + ' 을(를) 입력해주세요.');
				  $elm.focus();
				  result = false;
				  return false;
			  }
			  
			  if(field == '비밀번호') {
				  var pwChk = $('input[id=USER_PW_CHK]').val();
				  if(value != pwChk) {
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
  var flag = 0;
  function fnSetFile() {
	  var target = event.target;
	  var file = target.files[0];
	  var fileNmInputEl = $(target).prev();
	  fileNmInputEl.val(file.name);
	  compFile = file;
	  Choicebool = 1;
	  flag = 1;
  }
  
  function keyupPhone() {
	  isValidPhone = null;
	  $('input[id=USER_PHONE]').removeClass('valid-phone invalid-phone');
	}
  function chkPhoneNo(flag) {
	  var userPhone = $('input[id=USER_PHONE]').val();
	  
	  if($('input[id=USER_PHONE]').prop('readonly')){
		  return;
	  }
	  
	  if(!userPhone){
		  alert('휴대폰 번호가 입력되지 않았습니다.');
	  } else {
		  
		  if(flag == '0'){
			  checkPhoneNo(userPhone, flag, '');
			  alert('인증번호가 발송 되었습니다.')
		  } else {
			  var authNo = $('input[id=AUTH_NO]').val();
			  if(!authNo){
				  alert('인증번호가 입력되지 않았습니다.');
				  return;
			  }
			  var result = checkPhoneNo(userPhone, flag, authNo);
			  if('A' == result){
				  isValidPhone = false;
				  alert('유효기간이 초과 하였습니다.');
				  $('input[id=USER_PHONE]').addClass('invalid-phone');
			  } else if('B' == result) {
				  isValidPhone = false;
				  $('input[id=USER_PHONE]').addClass('invalid-phone');
				  alert('인증번호가 올바르지 않습니다.');
			  } else if('Y' == result){
				  isValidPhone = true;
				  $('input[id=USER_PHONE]').removeClass('invalid-phone');
				  $('input[id=USER_PHONE]').addClass('valid-phone');
				  $('input[id=USER_PHONE]').prop('readonly',true);
				  alert('인증되었습니다.');
			  } else{
				  isValidPhone = false;
				  $('input[id=USER_PHONE]').addClass('invalid-phone');
				  alert('인증에 실패하였습니다.');
			  }
		  }
	  }
	  
	}
  

</script>
<div class="sign_up_info_wrapper">
  <form name="sign_up_form" id="sign_up_form" method="POST" action="/api/login/IDfind">
  <div class="sign_up_top_divider"></div>
  <div class="sign_up_info_container">
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">휴대폰 번호</p>
      <input class="sign_up_info_item_blank_with_button required" style="width: 296px;" type="text" name="USER_PHONE" id="USER_PHONE" data-field="휴대폰 번호" onkeyup="keyupPhone()"/>
      <button class="sign_up_info_item_button" type="button" onclick="chkPhoneNo('0')">
        <p class="sign_up_info_item_button_typo">인증번호 발송</p>
      </button>
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">휴대폰 번호 인증</p>
      <input class="sign_up_info_item_blank_with_button" style="width: 156px;" type="text" name="AUTH_NO" id="AUTH_NO" />
      <button class="sign_up_info_item_button" type="button" onclick="chkPhoneNo('1')">
        <p class="sign_up_info_item_button_typo">인증 확인</p>
      </button>
    </div>
  </div>
  <div class="sign_up_info_container_divider"></div>
  </form>
</div>
 <script>
 
 </script>
<div class="sign_up_page_button_container">
  <a href="javascript:void(0)" class="sign_up_confirm_button" onclick="fnSave();">
    <p class="sign_up_confirm_button_typo">아이디 찾기</p>
  </a>
</div>
