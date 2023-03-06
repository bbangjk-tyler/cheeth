<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<style>
	.valid-nick { border: 1px solid #10c110; }
	.invalid-nick { border: 1px solid #e34d20; }
	.valid-account { border: 1px solid #10c110; }
	.invalid-account { border: 1px solid #e34d20; }
	.valid-phone { border: 1px solid #10c110; }
	.invalid-phone { border: 1px solid #e34d20; }
</style>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>

  isValidNickname = null;
  isValidAccount = null;
  //isValidAccount = true;
  isValidPhone = null;
  
  var licenseFile;
  var compFile;
  var Choicebool = 0;
  function fnSave() {
	  if(validate()) {
    	if(!checkId($('input[id=USER_ID]').val())) {
    		alert(getI8nMsg("alert.dupEmail"));//중복된 이메일 입니다.
    	  	$('input[id=USER_ID]').focus();
    	  	return;
    	}
    	
    	if(isEmpty(isValidNickname)) {
    		alert(getI8nMsg("alert.userNmChkFail"));//닉네임 중복 확인이 되지 않았습니다.
			$('input[id=USER_NICK_NAME]').focus();
			return;
		} else {
			if(!isValidNickname) {
				alert(getI8nMsg("alert.nickDupli"));//중복된 닉네임 입니다.
				$('input[id=USER_NICK_NAME]').focus();
				return;
			}
		}
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
        if(isEmpty(isValidPhone)) {
        	alert(getI8nMsg("alert.phoneNotAuth"));//휴대폰 인증이 되지 않았습니다.
            $('input[id=USER_PHONE]').focus();
            return;
        } else {
            if(!isValidPhone) {
            	alert(getI8nMsg("alert.phoneNotAuth"));//휴대폰 인증이 되지 않았습니다.
                $('input[id=USER_PHONE]').focus();
                return;
            }
        }
        
        if(!checkSign($('input[id=USER_PHONE]').val(),'3')) {
        	alert(getI8nMsg("alert.alreadyMobNum"));//이미 가입된 휴대폰 번호 입니다.
    	  	$('input[id=USER_PHONE]').focus();
    	  	return;
    	}
        
   	
      if(confirm(getI8nMsg("alert.confirm.signUp"))) {//'가입하시겠습니까?'
    	  if(Choicebool == 1){
        var formData = new FormData(document.getElementById('sign_up_form'));
			 	for(var key of formData.keys()) {
			 		formData.set(key, JSON.stringify(formData.get(key)));
			 	}
			 	formData.append('LICENSE_FILE', licenseFile);
			 	formData.append('COMP_FILE', compFile);
			 	
			 	$.ajax({
				  url: '/' + API + '/sign/sign_up',
				  type: 'POST',
				  data: formData,
				  cache: false,
				  async: false,
				  contentType: false,
				  processData: false,
				  success: function(data) {
					  if(data.result == 'Y') {
						  alert(getI8nMsg("alert.subsComp"));//가입이 완료되었습니다.
						  location.href = '/' + API + '/login/view';
					  }
				  }, complete: function() {
				  
				  }, error: function() {
				    
				  }
				});
    	  }else{
    		  confirmModal();
    	  }
      }
    }
  }
  function confirmModal() {
	  if (window.confirm(getI8nMsg("alert.confirm.signUp"))) {//"\n 추가정보 미입력 시 서비스에 제한이 있을 수 있습니다.\n 추가정보는 프로필 관리에서 수정이 가능합니다. \n \n 가입을 진행하시겠습니까?"
		  var formData = new FormData(document.getElementById('sign_up_form'));
		 	for(var key of formData.keys()) {
		 		formData.set(key, JSON.stringify(formData.get(key)));
		 	}
		 	formData.append('COMP_FILE', compFile);
		 	
		 	$.ajax({
			  url: '/' + API + '/sign/sign_up',
			  type: 'POST',
			  data: formData,
			  cache: false,
			  async: false,
			  contentType: false,
			  processData: false,
			  success: function(data) {
				  if(data.result == 'Y') {
					  alert(getI8nMsg("alert.subsComp"));//가입이 완료되었습니다.
					  location.href = '/' + API + '/login/view';
				  }
			  }, complete: function() {
			  
			  }, error: function() {
			    
			  }
			});
	  } else {
		  
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
        	alert(getI8nMsg("alert.param.plzValid", null, field)); //올바른 ' + field + ' 을(를) 입력해주세요.
          $elm.focus();
          result = false;
          return false;
        }
        
        if(field == '비밀번호') {
          var pwChk = $('input[id=USER_PW_CHK]').val();
          if(value != pwChk) {
        	alert(getI8nMsg("alert.wrongPw"));//비밀번호가 일치하지 않습니다.
            $('input[id=USER_PW_CHK]').focus();
            result = false;
            return false;
          }
        }
      } else {
    	alert(getI8nMsg("alert.param.plzEnter", null, field)); //field + ' 을(를) 입력해주세요.
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

	  if(target.id == 'LICENSE_FILE') licenseFile = file;
	  else if(target.id == 'COMP_FILE') compFile = file;
	  Choicebool = 1;
	  flag = 1;
  }
  
  function fnSelect() {
      
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
  
  function keyupNickName() {
	  isValidNickname = null;
	  $('input[id=USER_NICK_NAME]').removeClass('valid-nick invalid-nick');
	}
  
  function keyupPhone() {
	  isValidPhone = null;
	  $('input[id=USER_PHONE]').removeClass('valid-phone invalid-phone');
	}
  function keyupAccounNm() {
	  //isValidAccount = null;
	  $('input[id=ACCOUNT_NM]').removeClass('valid-account invalid-account');
	}
	
  
	function chkNickNameDuplication() {
	  var nickName = $('input[id=USER_NICK_NAME]').val();
	  if(nickName && !isValidNickname) {
	    if(checkNickName(nickName)) {
	      isValidNickname = true;
	      alert(getI8nMsg("alert.availUserNm"));//사용 가능한 닉네임 입니다.
		    $('input[id=USER_NICK_NAME]').addClass('valid-nick');
	    }else{
	      isValidNickname = false;
	      alert(getI8nMsg("alert.nickDupli"));//중복된 닉네임 입니다.
	      $('input[id=USER_NICK_NAME]').focus();
		    $('input[id=USER_NICK_NAME]').addClass('invalid-nick');
	    }
	  }
	}
  
	function chkPhoneNo(flag) {
		  var userPhone = $('input[id=USER_PHONE]').val();
		  
		  if($('input[id=USER_PHONE]').prop('readonly')){
			  return;
		  }
		  
		  if(!userPhone){
			  alert(getI8nMsg("alert.nEnterPhone"));//휴대폰 번호가 입력되지 않았습니다.
		  } else {
			  
			  if(flag == '0'){
				  checkPhoneNo(userPhone, flag, '');
				  alert(getI8nMsg("alert.certNumSent"));//인증번호가 발송 되었습니다.
			  } else {
				  var authNo = $('input[id=AUTH_NO]').val();
				  if(!authNo){
					  alert(getI8nMsg("alert.nEnterAuthNum"));//인증번호가 입력되지 않았습니다.
					  return;
				  }
				  var result = checkPhoneNo(userPhone, flag, authNo);
				  if('A' == result){
					  isValidPhone = false;
					  alert(getI8nMsg("alert.dtExceed"));//유효기간이 초과 하였습니다.
					  $('input[id=USER_PHONE]').addClass('invalid-phone');
				  } else if('B' == result) {
					  isValidPhone = false;
					  $('input[id=USER_PHONE]').addClass('invalid-phone');
					  alert(getI8nMsg("alert.certNumInval"));//인증번호가 올바르지 않습니다.
				  } else if('Y' == result){
					  isValidPhone = true;
					  $('input[id=USER_PHONE]').removeClass('invalid-phone');
					  $('input[id=USER_PHONE]').addClass('valid-phone');
					  $('input[id=USER_PHONE]').prop('readonly',true);
					  alert(getI8nMsg("alert.certified"));//인증되었습니다.
				  } else{
					  isValidPhone = false;
					  $('input[id=USER_PHONE]').addClass('invalid-phone');
					  alert(getI8nMsg("alert.authFail"));//인증에 실패하였습니다.
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
  
  $(function() {
	  $('#licenseFileBtn').click(function() {
		  $('input[id=LICENSE_FILE]').trigger('click');
	  });
	  
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
  function RequiredAdd(){
	  var passbool = 1;
	  if($("#COMP_NO").val().length > 0){
		  passbool = 0;
	  }
	if($("#COMP_NAME").val().length > 0){
		passbool = 0;
	}
	if($("#COMP_ADDRESS").val().length > 0){
		passbool = 0;
	  }
	if($("#COMP_ADDRESS_DTL").val().length > 0){
		passbool = 0;
	  }
	if(flag == 1){
		passbool = 0;
	  }
	
	if(passbool == 0){
		$("#COMP_NO").addClass('required');
		$("#COMP_NAME").addClass('required');
		$("#COMP_ADDRESS").addClass('required');
		$("#COMP_ADDRESS_DTL").addClass('required');
		$("#COMP_FILE").addClass('required');
	}else{
		$("#COMP_NO").removeClass('required');
		$("#COMP_NAME").removeClass('required');
		$("#COMP_ADDRESS").removeClass('required');
		$("#COMP_ADDRESS_DTL").removeClass('required');
		$("#COMP_FILE").removeClass('required');
		//$('#expert_type_dropbox').removeClass('invisible');		
	}
  }
</script>

<div class="sign_up_sign_up_container">
	<div class="sign_up_sign_up_typo_container">
		<p class="sign_up_sign_up_typo"><spring:message code="join" text="회원가입" /></p>
	</div>
	<div class="sign_up_sign_up_step_container">
		<div class="sign_up_sign_up_step">
			<p class="sign_up_sign_up_step_number">STEP 1</p>
			<p class="sign_up_sign_up_step_title"><spring:message code="join.step1" text="회원유형 선택" /></p>
		</div>
		<img class="sign_up_sign_up_step_arrow" src="/public/assets/images/sign_up_steps_right_arrow.svg">
		<div class="sign_up_sign_up_step">
			<p class="sign_up_sign_up_step_number">STEP 2</p>
			<p class="sign_up_sign_up_step_title"><spring:message code="join.step2" text="약관동의" /></p>
		</div>
		<img class="sign_up_sign_up_step_arrow" src="/public/assets/images/sign_up_steps_right_arrow.svg">
		<div class="sign_up_sign_up_step" style="color: #2093EB;">
			<p class="sign_up_sign_up_step_number">STEP 3</p>
			<p class="sign_up_sign_up_step_title"><spring:message code="join.step3" text="정보입력" /></p>
		</div>
	</div>
</div>

<div class="sign_up_info_wrapper">
	<form name="sign_up_form" id="sign_up_form">
		<input type="hidden" name="USER_TYPE_CD" id="USER_TYPE_CD" value="3" />
		<div class="sign_up_top_divider"></div>
		<div class="sign_up_info_container">
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="equ.emailId" text="이메일(ID겸용)" /></p>
				<input class="sign_up_info_item_blank required" type="text" name="USER_ID" id="USER_ID" data-field="이메일" />
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="equ.pw" text="비밀번호" /></p>
				<input class="sign_up_info_item_blank required" type="password" name="USER_PW" id="USER_PW" data-field="비밀번호" />
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="equ.confirmPw" text="비밀번호 확인" /></p>
				<input class="sign_up_info_item_blank" type="password" id="USER_PW_CHK" />
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="join.mobNum" text="휴대폰 번호" /></p>
				<input class="sign_up_info_item_blank_with_button required" style="width: 296px;" type="text" name="USER_PHONE" id="USER_PHONE" data-field="휴대폰 번호" onkeyup="keyupPhone()"/>
				<button class="sign_up_info_item_button" type="button" onclick="chkPhoneNo('0')">
					<p class="sign_up_info_item_button_typo"><spring:message code="join.verifiNum" text="인증번호 발송" /></p>
				</button>
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="join.mobNumVerifi" text="휴대폰 번호 인증" /></p>
				<input class="sign_up_info_item_blank_with_button" style="width: 156px;" type="text" name="AUTH_NO" id="AUTH_NO" />
				<button class="sign_up_info_item_button" type="button" onclick="chkPhoneNo('1')">
					<p class="sign_up_info_item_button_typo"><spring:message code="join.verify" text="인증 확인" /></p>
				</button>
			</div>
		</div>
		<div class="sign_up_info_container_divider"></div>
		<div class="sign_up_info_container">
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="join.nm" text="이름" /></p>
				<input class="sign_up_info_item_blank required" type="text" name="USER_NM" id="USER_NM" data-field="이름" />
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="join.addr" text="주소" /></p>
				<input class="sign_up_info_item_blank required" type="text" name="USER_ADDRESS" id="USER_ADDRESS" data-field="주소" readonly />
				<input class="sign_up_info_item_blank required" type="text" name="USER_ADDRESS_DTL" id="USER_ADDRESS_DTL" data-field="주소 상세" />
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="equ.usrNmChk" text="닉네임(중복조회)" /></p>
				<input class="sign_up_info_item_blank_with_button required" style="width: 177px;" type="text" name="USER_NICK_NAME" id="USER_NICK_NAME" data-field="닉네임"
								onkeyup="keyupNickName()" />
				<button class="sign_up_info_item_button" type="button" onclick="chkNickNameDuplication()" style="cursor: pointer;">
					<p class="sign_up_info_item_button_typo"><spring:message code="join.dupChk" text="중복 확인" /></p>
				</button>
			</div>
		</div>
		<div class="sign_up_info_container_divider"></div>
		<div class="sign_up_info_container">
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="equ.select.profess" text="직업선택" /></p>
				<input class="required" type="hidden" name="JOB_CD" id="JOB_CD" data-field="직업" />
				<div class="dropbox_sign_up_expert_job">
					<div id="JOB_CD_DIV_1" class="dropbox_select_button codebox1" onclick="fnSelect(this);" style="cursor: pointer;">
						<div class="dropbox_select_button_typo_container">
							<p class="dropbox_select_button_typo"><spring:message code="select" text="선택" /></p>
							<img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg" />
						</div>
					</div>
					<div id="JOB_CD_DIV_2" class="dropbox_select_button_item_container hidden codebox2" style="cursor: pointer;">
						<c:forEach items="${jobCdList}" var="job">
							<div class="dropbox_select_button_item">
								<p class="dropbox_select_button_item_typo" onclick="fnSelect('${job.CODE_CD}', '${job.CODE_NM}');" data-div="JOB_CD">
								  ${job.CODE_NM}
								</p>
							</div>
						</c:forEach>
						<!-- <div class="dropbox_select_button_item">
            <p class="dropbox_select_button_item_typo" onclick="fnSelect('J001', '치과의사')" data-div="job_cd">치과의사</p>
          </div>
          <div class="dropbox_select_button_item">
            <p class="dropbox_select_button_item_typo" onclick="fnSelect('J002', '치과기공사')" data-div="job_cd">치과기공사</p>
          </div>  -->
					</div>
				</div>
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="equ.attachL" text="면허증 첨부" /></p>
				<input class="sign_up_info_item_blank_with_button required" style="width: 341px;" data-field="면허증"/>
				<input type="file" name="LICENSE_FILE" id="LICENSE_FILE" style="display: none;" onchange="fnSetFile();"/>
				<button class="sign_up_info_item_button" type="button" id="licenseFileBtn">
					<p class="sign_up_info_item_button_typo"><spring:message code="join.attachF" text="파일첨부" /></p>
				</button>
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="equ.licenNum" text="면허증 번호" /></p>
				<input class="sign_up_info_item_blank required" type="text" name="LICENSE_NO" id="LICENSE_NO" data-field="면허증 번호" />
			</div>
		</div>
		<div class="sign_up_info_container_divider"></div>
		<div class="sign_up_info_container">
			<div class="sign_up_info_item" >
				<p class="sign_up_info_item_typo">은행</p>
				<input type="hidden" name="BANK_CD" id="BANK_CD" data-field="은행선택" required/>
				<div class="dropbox_sign_up_expert_bank">
					<div id="BANK_CD_DIV_1" class="dropbox_select_button codebox1" onclick="fnSelect(this);" style="cursor: pointer;">
						<div class="dropbox_select_button_typo_container">
							<p class="dropbox_select_button_typo">선택</p>
							<img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg" />
						</div>
					</div>
					<div id="BANK_CD_DIV_2" class="dropbox_select_button_item_container hidden codebox2" style="cursor: pointer;width:171px;height: 500px;overflow: auto;">
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0003', '기업')" data-div="BANK_CD">기업</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0004', '국민')" data-div="BANK_CD">국민</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0011', '농협')" data-div="BANK_CD">농협</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0020', '우리')" data-div="BANK_CD">우리</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0081', '하나')" data-div="BANK_CD">하나</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0088', '신한')" data-div="BANK_CD">신한</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0090', '카카오뱅크')" data-div="BANK_CD">카카오뱅크</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0027', '한국시티은행')" data-div="BANK_CD">한국시티은행</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0023', 'SC제일은행')" data-div="BANK_CD">SC제일은행</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0039', '경남은행')" data-div="BANK_CD">경남은행</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0034', '광주은행')" data-div="BANK_CD">광주은행</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0031', '대구은행')" data-div="BANK_CD">대구은행</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0032', '부산은행')" data-div="BANK_CD">부산은행</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0037', '전북은행')" data-div="BANK_CD">전북은행</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0035', '제주은행')" data-div="BANK_CD">제주은행</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0011', '농협은행')" data-div="BANK_CD">농협은행</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0012', '지역농축협')" data-div="BANK_CD">지역농축협</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0007', '수협은행')" data-div="BANK_CD">수협은행</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0002', '산업은행')" data-div="BANK_CD">산업은행</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0071', '우체국')" data-div="BANK_CD">우체국</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0045', '새마을금고')" data-div="BANK_CD">새마을금고</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0050', 'SBI저축은행')" data-div="BANK_CD">저축은행</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0089', '케이뱅크')" data-div="BANK_CD">케이뱅크</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0098', '토스뱅크')" data-div="BANK_CD">토스뱅크</p>
						</div>
					</div>
				</div>
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo">예금주</p>
				<input class="sign_up_info_item_blank_with_button required" style="width: 142px;" type="text" name="ACCOUNT_NM" id="ACCOUNT_NM" onkeyup="keyupAccounNm()" data-field="예금주" required/>
 				<button class="sign_up_info_item_button" type="button" onclick="chkAccountName()">
					<p class="sign_up_info_item_button_typo">본인인증</p>
				</button>
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="join.acntno" text="계좌번호" /></p>
				<input class="sign_up_info_item_blank valid-account required" placeholder='<spring:message code="join.acntWithout" text='"-"를 제외하고 입력하시기 바랍니다.' />' type="number" name="ACCOUNT_NO" id="ACCOUNT_NO" data-field="계좌번호" required/>
			</div>
			
		</div>
		<div class="sign_up_info_container_divider"></div>
		<div class="sign_up_info_container">
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_title"><spring:message code="join.addInfo" text="추가정보" /></p>
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"><spring:message code="join.selectBiz" text="업종선택" /></p>
				<input type="hidden" name="COMP_GROUP_NM" id="COMP_GROUP_NM" />
				<input type="hidden" name="COMP_GROUP_CD" id="COMP_GROUP_CD" />
				<div class="dropbox_sign_up_expert_sectors">
					<div id="COMP_GROUP_CD_DIV_1" class="dropbox_select_button codebox1" onclick="fnSelect(this);" style="cursor: pointer;">
						<div class="dropbox_select_button_typo_container">
							<p class="dropbox_select_button_typo"><spring:message code="select" text="선택" /></p>
							<img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg" />
						</div>
					</div>
					<div id="COMP_GROUP_CD_DIV_2" class="dropbox_select_button_item_container hidden codebox2" style="cursor: pointer;">
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('B001', '치과')" data-div="COMP_GROUP_CD"><spring:message code="join.dental" text="치과" /></p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('B002', '치과기공소')" data-div="COMP_GROUP_CD"><spring:message code="join.dentalLabor" text="치과기공소" /></p>
						</div>
					</div>
				</div>
			</div>
		    <div class="sign_up_info_item">
		      <p class="sign_up_info_item_typo"><spring:message code="join.bizNum" text="사업자등록번호" /></p>
		      <input class="sign_up_info_item_blank" type="text" name="COMP_NO" id="COMP_NO" data-field="사업자등록번호" onchange="RequiredAdd()"/>
		    </div>
		    <div class="sign_up_info_item">
		      <p class="sign_up_info_item_typo"><spring:message code="join.compNm" text="상호" /></p>
		      <input class="sign_up_info_item_blank" style="width: 253px;" type="text" name="COMP_NAME" id="COMP_NAME" data-field="상호" onchange="RequiredAdd()"/>
		    </div>
		    <div class="sign_up_info_item">
		      <p class="sign_up_info_item_typo"><spring:message code="join.compAddr" text="사업장 주소" /></p>
		      <input class="sign_up_info_item_blank" type="text" name="COMP_ADDRESS" id="COMP_ADDRESS" onchange="RequiredAdd()" data-field="주소" readonly />
			  <input class="sign_up_info_item_blank" type="text" name="COMP_ADDRESS_DTL" id="COMP_ADDRESS_DTL" data-field="상세주소" onchange="RequiredAdd()"/>
		    </div>
		    <div class="sign_up_info_item">
		      <p class="sign_up_info_item_typo"><spring:message code="join.attachBizRegi" text="사업자등록증 첨부" /></p>
		      <input class="sign_up_info_item_blank_with_button" style="width: 341px;"/>
		      <input type="file" name="COMP_FILE" id="COMP_FILE" style="display: none;" data-field="파일" onchange="fnSetFile();" />
		      <button class="sign_up_info_item_button" type="button" id="compFileBtn">
		        <p class="sign_up_info_item_button_typo"><spring:message code="join.attachF" text="파일첨부" /></p>
		      </button>
		    </div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo"></p>
				<p class="sign_up_info_item_blank_comment">※ <spring:message code="join.enter.bizInfo" text="소속된 사업장의 정보를 입력해주세요. 미입력 시 서비스에 제한이 있을 수 있습니다.<br>※ 전자계산서 발행 가능 여부는 프로필 작성 시 선택 바랍니다." />
													   <br>※ <spring:message code="join.select.electInv" text="전자계산서 발행 가능 여부는 프로필 작성 시 선택 바랍니다." /></p>
			</div>
		</div>
	</form>
</div>

<div class="sign_up_page_button_container">
	<a href="/${api}/sign/accept_conditions?dvsn=type02" class="sign_up_page_button">
		<p class="sign_up_page_button_typo"><spring:message code="join.pre" text="이전 페이지" /></p>
	</a>
	<a href="javascript:void(0)" class="sign_up_confirm_button" onclick="fnSave();">
		<p class="sign_up_confirm_button_typo"><spring:message code="join" text="확인" /></p>
	</a>
</div>
