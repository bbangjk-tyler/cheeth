<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
	.sign_up_info_membership_type_select_button { cursor: pointer; }
	.sign_up_info_membership_type_select_button:hover,
	.sign_up_info_membership_type_select_button.active { border: 1px solid #3baaff; }
	.sign_up_info_membership_type_select_button:hover p,
	.sign_up_info_membership_type_select_button.active p { color: #3baaff; }
	
	.valid-nick { border: 1px solid #10c110; }
	.invalid-nick { border: 1px solid #e34d20; }
	.valid-phone { border: 1px solid #10c110; }
	.invalid-phone { border: 1px solid #e34d20; }
</style>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>

	isValidNickname = null;
	isValidPhone = null;
	isValidAccount = null;
	var licenseFile;
	var compFile;
  
	$(function() {
		
		$('#type_expert_button, #expert_type_dropbox').hover(
			function() {
				if(!$('#expert_type_dropbox').hasClass('selected')) {
					$('#expert_type_dropbox').removeClass('invisible');
					$('#type_expert_button').addClass('active');
				}
			},
			function() {
				if(!$('#expert_type_dropbox').hasClass('selected')) {
					$('#expert_type_dropbox').addClass('invisible');
					$('#type_expert_button').removeClass('active');
				}
			}
		);
		
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
	
	function fnPrev() {
		$('#snsForm #SNS_DVSN').val('${snsInfo.SNS_DVSN}');
		$('#snsForm #SNS_ID').val('${snsInfo.SNS_ID}');
		$('#snsForm #SNS_MOBILE').val('${snsInfo.SNS_MOBILE}');
		$('#snsForm #SNS_NAME').val('${snsInfo.SNS_NAME}');
		$('#snsForm #SNS_ADDRESS').val('${snsInfo.SNS_ADDRESS}');
		$('#snsForm #SNS_NICKNAME').val('${snsInfo.SNS_NICKNAME}');
		document.snsForm.submit();
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
	function chkAccountName() {
		  var bankCd = $('input[id=BANK_CD]').val();
		  var accountNm = $('input[id=ACCOUNT_NM]').val();
		  var accountNo = $('input[id=ACCOUNT_NO]').val();
		  if(bankCd && accountNm && accountNo && !isValidAccount) {
		    if(checkAccount(bankCd, accountNm, accountNo)) {
		      isValidAccount = true;
		      alert('?????? ?????? ?????? ???????????????.');
			    $('input[id=ACCOUNT_NM]').addClass('valid-account');
		    } else {
		      isValidNickname = false;
		      alert('????????? ?????? ???????????????. ?????? ????????? ?????????');
		      $('input[id=ACCOUNT_NM]').focus();
			    $('input[id=ACCOUNT_NM]').addClass('invalid-account');
		    }
		  }
		}
	  var cheebool = 0;
	function selectIndividual() {
		$('#type_individual_button').addClass('active');
		$('#type_expert_button').removeClass('active');
		$('#expert_type_dropbox').addClass('invisible').removeClass('selected');
		$('#expertClient, #expertCheesigner').removeClass('selected');
		$('#expert_info_container').hide();
		$('#cheesigner_info_container').hide();
		$('input[id=USER_TYPE_CD]').val('1');
		$('input[id=JOB_CD]').val('');
		$('#JOB_CD_DIV_2_CHEESIGNER, #JOB_CD_DIV_2_CLIENT').addClass('hidden');
		$('#JOB_CD_DIV_1_CHEESIGNER, #JOB_CD_DIV_1_CLIENT').find('p').html('??????');
		$(".sign_up_info_item_blank_with_button").removeClass('required');	
		$(".sign_up_info_item_blank").removeClass('required');	
		cheebool = 0;
		type = 1;
	}
	
	function selectExpertType(target) {
		var $target = $(target);
		$('#type_individual_button').removeClass('active');
		$target.addClass('selected');
		if($target.attr('id') == 'expertClient') {
			$(".sign_up_info_item_blank_with_button").removeClass('required');	
			$(".sign_up_info_item_blank").removeClass('required');	
			$('#expertCheesigner').removeClass('selected');
			$('#cheesigner_info_container').hide();
			$('input[id=USER_TYPE_CD]').val('2');
			$target.addClass("active");
			$("#expertCheesigner").removeClass("active");
			$('#client_job_container').show();
			$('#cheesigner_job_container').hide();
			$('#JOB_CD_DIV_2_CHEESIGNER').addClass('hidden');
			$('#JOB_CD_DIV_1_CHEESIGNER').find('p').html('??????');
			cheebool = 0;
			type = 2;
		} else if($target.attr('id') == 'expertCheesigner') {
			
			$('#expertClient').removeClass('selected');
			$('#cheesigner_info_container').show();
			$('input[id=USER_TYPE_CD]').val('3');
			
			$target.addClass("active");
			$("#expertClient").removeClass("active");
			
			$('#cheesigner_job_container').show();
			$('#client_job_container').hide();
			$('#JOB_CD_DIV_2_CLIENT').addClass('hidden');
			$('#JOB_CD_DIV_1_CLIENT').find('p').html('??????');
			$(".sign_up_info_item_blank_with_button").addClass('required');	
			$(".sign_up_info_item_blank").addClass('required');	
			cheebool = 1;
			type = 3;
		}
		$('input[id=JOB_CD]').val('');
		$('#expert_type_dropbox').addClass('selected');
		$('#expert_info_container').show();
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

	function chkNickNameDuplication() {
	  var nickName = $('input[id=USER_NICK_NAME]').val();
	  if(nickName && !isValidNickname) {
	    if(checkNickName(nickName)) {
	      isValidNickname = true;
	      alert('?????? ????????? ????????? ?????????.');
		    $('input[id=USER_NICK_NAME]').addClass('valid-nick');
	    } else {
	      isValidNickname = false;
	      alert('????????? ????????? ?????????.');
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
			  alert('????????? ????????? ???????????? ???????????????.');
		  } else {
			  
			  if(flag == '0'){
				  checkPhoneNo(userPhone, flag, '');
				  alert('??????????????? ?????? ???????????????.')
			  } else {
				  var authNo = $('input[id=AUTH_NO]').val();
				  if(!authNo){
					  alert('??????????????? ???????????? ???????????????.');
					  return;
				  }
				  var result = checkPhoneNo(userPhone, flag, authNo);
				  if('A' == result){
					  isValidPhone = false;
					  alert('??????????????? ?????? ???????????????.');
					  $('input[id=USER_PHONE]').addClass('invalid-phone');
				  } else if('B' == result) {
					  isValidPhone = false;
					  $('input[id=USER_PHONE]').addClass('invalid-phone');
					  alert('??????????????? ???????????? ????????????.');
				  } else if('Y' == result){
					  isValidPhone = true;
					  $('input[id=USER_PHONE]').removeClass('invalid-phone');
					  $('input[id=USER_PHONE]').addClass('valid-phone');
					  $('input[id=USER_PHONE]').prop('readonly',true);
					  alert('?????????????????????.');
				  } else{
					  isValidPhone = false;
					  $('input[id=USER_PHONE]').addClass('invalid-phone');
					  alert('????????? ?????????????????????.');
				  }
			  }
		  }
		  
		}
	var Choicebool = 0;
	function fnSave() {
		if(!$('input[id=USER_TYPE_CD]').val()) {
			alert('?????? ????????? ??????????????????.');
			return;
		}
		
		if(isEmpty(isValidNickname)) {
			alert('????????? ?????? ????????? ?????? ???????????????.');
			$('input[id=USER_NICK_NAME]').focus();
			return;
		} else {
			if(!isValidNickname) {
				alert('????????? ????????? ?????????.');
				$('input[id=USER_NICK_NAME]').focus();
				return;
			}
		}
		if(cheebool == 1){
		if(isEmpty(isValidAccount)){
    		alert('?????? ?????? ????????? ?????? ???????????????.');
			$('input[id=ACCOUNT_NM]').focus();
			return;
    	} else {
			if(!isValidAccount) {
				alert('?????? ?????? ????????? ?????? ???????????????.');
				$('input[id=USER_NICK_NAME]').focus();
				return;
			}
		}
		}
		if(isEmpty(isValidPhone)) {
            alert('????????? ????????? ?????? ???????????????.');
            $('input[id=USER_PHONE]').focus();
            return;
        } else {
            if(!isValidPhone) {
                alert('????????? ????????? ?????? ???????????????.');
                $('input[id=USER_PHONE]').focus();
                return;
            }
        }
		var type = 1;
        if(!checkSign($('input[id=USER_PHONE]').val(), type)) {
    		alert('?????? ????????? ????????? ?????? ?????????.');
    	  $('input[id=USER_PHONE]').focus();
    	  return;
    	}
		
	  if(validate()) {
	    if(confirm('?????????????????????????')) {
	  	  /* var form = document.sign_up_form;
	      form.action = '/' + API + '/sign/sign_up';
	      form.submit(); */
	      if(Choicebool == 1){
	      var formData = new FormData(document.getElementById('sign_up_form'));
			 	for(var key of formData.keys()) {
			 		formData.set(key, JSON.stringify(formData.get(key)));
			 	}
			 	formData.append('COMP_FILE', compFile);
			 	formData.append('LICENSE_FILE', licenseFile);
			 	
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
						  alert('????????? ?????????????????????.');
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
		  if (window.confirm("\n ???????????? ????????? ??? ???????????? ????????? ?????? ??? ????????????.\n ??????????????? ????????? ???????????? ????????? ???????????????. \n \n ????????? ?????????????????????????")) {
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
						  alert('????????? ?????????????????????.');
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
	    if($elm.is(':visible') || ($('input[id=USER_TYPE_CD]').val() !== '1' && $elm.attr('id') == 'JOB_CD')) {
		    var field = $elm.data('field');
		    var value = $elm.val();
		    
		    if(value) {
		      var regExp;
		      if(field == '????????? ??????') {
		        regExp = /^01([0|1|6|7|8|9])([0-9]{3,4})([0-9]{4})$/;
		      }
		      if(regExp && !regCheck(regExp, value)) {
		        alert('????????? ' + field + ' ???(???) ??????????????????.');
		        $elm.focus();
		        result = false;
		        return false;
		      }
		    } else {
		      alert(field + ' ???(???) ??????????????????.');
		      $elm.focus();
		      result = false;
		      return false;
		    }
	    }
	  });
	  
	  return result;
	}
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
<style>
.dropbox_sign_up_membership_type_select_item_typo.active{
	color:#3baaff;
	font-weight:800;
}
</style>
<div class="sign_up_sign_up_container">
  <div class="sign_up_sign_up_typo_container">
    <p class="sign_up_sign_up_typo">????????????</p>
  </div>
  <div class="sign_up_sign_up_step_container">
    <div class="sign_up_sign_up_step">
      <p class="sign_up_sign_up_step_number">STEP 1</p>
      <p class="sign_up_sign_up_step_title">???????????? ??????</p>
    </div>
    <img class="sign_up_sign_up_step_arrow" src="/public/assets/images/sign_up_steps_right_arrow.svg">
    <div class="sign_up_sign_up_step">
      <p class="sign_up_sign_up_step_number">STEP 2</p>
      <p class="sign_up_sign_up_step_title">????????????</p>
    </div>
    <img class="sign_up_sign_up_step_arrow" src="/public/assets/images/sign_up_steps_right_arrow.svg">
    <div class="sign_up_sign_up_step" style="color: #2093EB;">
      <p class="sign_up_sign_up_step_number">STEP 3</p>
      <p class="sign_up_sign_up_step_title">????????????</p>
    </div>
  </div>
</div>

<div class="sign_up_info_wrapper">
	<form name="sign_up_form" id="sign_up_form" method="post" enctype="multipart/form-data">
	<input type="hidden" name="SNS_YN" id="SNS_YN" value="Y" />
	<input type="hidden" name="SNS_DVSN" id="SNS_DVSN" value="${snsInfo.SNS_DVSN}" />
	<input type="hidden" name="USER_TYPE_CD" id="USER_TYPE_CD" />
	<input type="hidden" name="USER_ID" id="USER_ID" value="${snsInfo.SNS_ID}" />
	<input type="hidden" name="USER_PW" id="USER_PW" value="${snsInfo.SNS_ID}" />
  <div class="sign_up_top_divider"></div>
  <div class="sign_up_info_container">
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_title">???????????? ??????</p>
    </div>
    <div class="sign_up_info_membership_type_select_button_wrapper">
      <div class="sign_up_info_membership_type_select_button_container">
        <button id="type_individual_button" class="sign_up_info_membership_type_select_button" type="button" onclick="selectIndividual();">
          <p class="sign_up_info_membership_type_select_button_typo">?????? ????????????</p>
        </button>
        <div class="dropbox_sign_up_membership_type_select_container invisible">
          <div class="dropbox_sign_up_membership_type_select_top hidden">
            <div class="dropbox_line_border"></div>
            <div class="dropbox_left_inclined_border"></div>
            <div class="dropbox_right_inclined_border"></div>
            <div class="dropbox_line_border"></div>
          </div>
          <div class="dropbox_sign_up_membership_type_select_body hidden">
            <div class="dropbox_sign_up_membership_type_select_item">
              <p class="dropbox_sign_up_membership_type_select_item_typo">?????????</p>
            </div>
            <div class="dropbox_sign_up_membership_type_select_item">
              <p class="dropbox_sign_up_membership_type_select_item_selected_typo">????????????(CAD ????????????)</p>
            </div>
          </div>
        </div>
      </div>
      <div class="sign_up_info_membership_type_select_button_container">
        <button id="type_expert_button" class="sign_up_info_membership_type_select_button" type="button">
          <p class="sign_up_info_membership_type_select_button_typo">????????? ????????????</p>
        </button>
        <!-- invisible class ??????: dropdown menu ????????? (?????? ?????????) -->
        <div id="expert_type_dropbox" class="dropbox_sign_up_membership_type_select_container invisible">
          <div class="dropbox_sign_up_membership_type_select_top">
            <div class="dropbox_line_border"></div>
            <div class="dropbox_left_inclined_border"></div>
            <div class="dropbox_right_inclined_border"></div>
            <div class="dropbox_line_border"></div>
          </div>
          <div class="dropbox_sign_up_membership_type_select_body">
            <div class="dropbox_sign_up_membership_type_select_item">
              <p id="expertClient" class="dropbox_sign_up_membership_type_select_item_typo" style="cursor:pointer;" onclick="selectExpertType(this);">?????????</p>
            </div>
           <div class="dropbox_sign_up_membership_type_select_item">
             <p id="expertCheesigner" class="dropbox_sign_up_membership_type_select_item_typo" style="text-align: center;cursor:pointer;" onclick="selectExpertType(this);">????????????<br>(CAD ????????????)</p>
           </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="sign_up_info_container_divider"></div>
  <div class="sign_up_info_container">
  		<div class="sign_up_info_item">
			<p class="sign_up_info_item_typo">????????? ??????</p>
			<input class="sign_up_info_item_blank_with_button required" style="width: 296px;" type="text" name="USER_PHONE" id="USER_PHONE" 
							value="${snsInfo.SNS_MOBILE}" data-field="????????? ??????" onkeyup="keyupPhone()"/>
			<button class="sign_up_info_item_button" type="button" onclick="chkPhoneNo('0')">
				<p class="sign_up_info_item_button_typo">???????????? ??????</p>
			</button>
		</div>
		<div class="sign_up_info_item">
			<p class="sign_up_info_item_typo">????????? ?????? ??????</p>
			<input class="sign_up_info_item_blank_with_button" style="width: 156px;" type="text" name="AUTH_NO" id="AUTH_NO" />
			<button class="sign_up_info_item_button" type="button" onclick="chkPhoneNo('1')">
				<p class="sign_up_info_item_button_typo">?????? ??????</p>
			</button>
		</div>
  		<div class="sign_up_info_item">
			<p class="sign_up_info_item_typo">??????</p>
			<input class="sign_up_info_item_blank required" type="text" name="USER_NM" id="USER_NM" value="${snsInfo.SNS_NAME}" data-field="??????" />
		</div>
		<div class="sign_up_info_item">
			<p class="sign_up_info_item_typo">??????</p>
			<input class="sign_up_info_item_blank required" type="text" name="USER_ADDRESS" id="USER_ADDRESS" value="${snsInfo.SNS_ADDRESS}" data-field="??????" readonly />
			<input class="sign_up_info_item_blank" type="text" name="USER_ADDRESS_DTL" id="USER_ADDRESS_DTL" data-field="?????? ??????" />
		</div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">?????????(????????????)</p>
      <input class="sign_up_info_item_blank_with_button required" style="width: 177px;" type="text" name="USER_NICK_NAME" id="USER_NICK_NAME" data-field="?????????"
							onkeyup="keyupNickName()" value="${snsInfo.SNS_NICKNAME}" />
			<button class="sign_up_info_item_button" type="button" onclick="chkNickNameDuplication()" style="cursor: pointer;">
				<p class="sign_up_info_item_button_typo">?????? ??????</p>
			</button>
    </div>
  </div>
  <div class="sign_up_info_container_divider"></div>
  
  <div id="expert_info_container" style="display: none;">
	  <div class="sign_up_info_container">
	  	<input class="required" type="hidden" name="JOB_CD" id="JOB_CD" data-field="??????" />
			<div id="cheesigner_job_container" class="sign_up_info_item" style="display: none;">
				<p class="sign_up_info_item_typo">????????????</p>
				<div class="dropbox_sign_up_expert_job">
					<div id="JOB_CD_DIV_1_CHEESIGNER" class="dropbox_select_button codebox1" onclick="fnSelect(this);" style="cursor: pointer;">
						<div class="dropbox_select_button_typo_container">
							<p class="dropbox_select_button_typo">??????</p>
							<img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg" />
						</div>
					</div>
					<div id="JOB_CD_DIV_2_CHEESIGNER" class="dropbox_select_button_item_container hidden codebox2 cheesigner" style="cursor: pointer;">
						<c:forEach items="${jobCdList1}" var="job">
							<div class="dropbox_select_button_item">
								<p class="dropbox_select_button_item_typo" onclick="fnSelect('${job.CODE_CD}', '${job.CODE_NM}');" data-div="JOB_CD">
								  ${job.CODE_NM}
								</p>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
			<div id="client_job_container" class="sign_up_info_item" style="display: none;">
				<p class="sign_up_info_item_typo">????????????</p>
				<div class="dropbox_sign_up_expert_job">
					<div id="JOB_CD_DIV_1_CLIENT" class="dropbox_select_button codebox1" onclick="fnSelect(this);" style="cursor: pointer;">
						<div class="dropbox_select_button_typo_container">
							<p class="dropbox_select_button_typo">??????</p>
							<img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg" />
						</div>
					</div>
					<div id="JOB_CD_DIV_2_CLIENT" class="dropbox_select_button_item_container hidden codebox2 cheesigner" style="cursor: pointer;">
						<c:forEach items="${jobCdList2}" var="job">
							<div class="dropbox_select_button_item">
								<p class="dropbox_select_button_item_typo" onclick="fnSelect('${job.CODE_CD}', '${job.CODE_NM}');" data-div="JOB_CD">
								  ${job.CODE_NM}
								</p>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo">????????? ??????</p>
				<input class="sign_up_info_item_blank_with_button required" style="width: 341px;" data-field="?????????"/>
				<input type="file" name="LICENSE_FILE" id="LICENSE_FILE" style="display: none;" onchange="fnSetFile();"/>
				<button class="sign_up_info_item_button" type="button" id="licenseFileBtn">
					<p class="sign_up_info_item_button_typo">????????????</p>
				</button>
			</div>
			<div class="sign_up_info_item">
				<p class="sign_up_info_item_typo">????????? ??????</p>
				<input class="sign_up_info_item_blank required" type="text" name="LICENSE_NO" id="LICENSE_NO" data-field="????????? ??????" />
			</div>
		</div>
		<div class="sign_up_info_container_divider"></div>
	</div>
	
  <div class="sign_up_info_container">

    <div id="cheesigner_info_container" class="sign_up_info_container" style="display: none;">
		<div class="sign_up_info_item">
			<p class="sign_up_info_item_typo">??????</p>
			<input type="hidden" name="BANK_CD" id="BANK_CD" />
			<div class="dropbox_sign_up_expert_bank">
				<div id="BANK_CD_DIV_1" class="dropbox_select_button codebox1" onclick="fnSelect(this);" style="cursor: pointer;">
					<div class="dropbox_select_button_typo_container">
						<p class="dropbox_select_button_typo">??????</p>
						<img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg" />
					</div>
				</div>
				<div id="BANK_CD_DIV_2" class="dropbox_select_button_item_container hidden codebox2" style="cursor: pointer;width:171px;height: 500px;overflow: auto;">
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0003', '??????')" data-div="BANK_CD">??????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0004', '??????')" data-div="BANK_CD">??????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0011', '??????')" data-div="BANK_CD">??????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0020', '??????')" data-div="BANK_CD">??????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0081', '??????')" data-div="BANK_CD">??????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0088', '??????')" data-div="BANK_CD">??????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0090', '???????????????')" data-div="BANK_CD">???????????????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0027', '??????????????????')" data-div="BANK_CD">??????????????????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0023', 'SC????????????')" data-div="BANK_CD">SC????????????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0039', '????????????')" data-div="BANK_CD">????????????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0034', '????????????')" data-div="BANK_CD">????????????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0031', '????????????')" data-div="BANK_CD">????????????</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0032', '????????????')" data-div="BANK_CD">????????????</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0037', '????????????')" data-div="BANK_CD">????????????</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0035', '????????????')" data-div="BANK_CD">????????????</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0011', '????????????')" data-div="BANK_CD">????????????</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0012', '???????????????')" data-div="BANK_CD">???????????????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0007', '????????????')" data-div="BANK_CD">????????????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0002', '????????????')" data-div="BANK_CD">????????????</p>
						</div>
						<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0071', '?????????')" data-div="BANK_CD">?????????</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0045', '???????????????')" data-div="BANK_CD">???????????????</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0050', 'SBI????????????')" data-div="BANK_CD">????????????</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0089', '????????????')" data-div="BANK_CD">????????????</p>
						</div>
												<div class="dropbox_select_button_item">
							<p class="dropbox_select_button_item_typo" onclick="fnSelect('0098', '????????????')" data-div="BANK_CD">????????????</p>
						</div>
				</div>
			</div>
		</div>
		<div class="sign_up_info_item">
			<p class="sign_up_info_item_typo">?????????</p>
			<input class="sign_up_info_item_blank_with_button required" data-field="?????????" style="width: 142px;" type="text" name="ACCOUNT_NM" id="ACCOUNT_NM" />
			<button class="sign_up_info_item_button" type="button" onclick="chkAccountName()">
				<p class="sign_up_info_item_button_typo">????????????</p>
			</button>
		</div>
		<div class="sign_up_info_item">
			<p class="sign_up_info_item_typo">????????????</p>
			<input class="sign_up_info_item_blank required" data-field="????????????" placeholder='"-"??? ???????????? ??????????????? ????????????.' type="number" name="ACCOUNT_NO" id="ACCOUNT_NO" />
		</div>
		<div class="sign_up_info_container_divider"></div>
		</div>
	</div>
    
  <div class="sign_up_info_container">
      <div class="sign_up_info_item">
      <p class="sign_up_info_item_title">????????????</p>
    </div>
    <div class="sign_up_info_item">
			<p class="sign_up_info_item_typo">????????????</p>
			<input type="hidden" name="COMP_GROUP_NM" id="COMP_GROUP_NM" />
			<input type="hidden" name="COMP_GROUP_CD" id="COMP_GROUP_CD" />
			<div class="dropbox_sign_up_expert_sectors">
				<div id="COMP_GROUP_CD_DIV_1" class="dropbox_select_button codebox1" onclick="fnSelect(this);" style="cursor: pointer;">
					<div class="dropbox_select_button_typo_container">
						<p class="dropbox_select_button_typo">??????</p>
						<img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg" />
					</div>
				</div>
				<div id="COMP_GROUP_CD_DIV_2" class="dropbox_select_button_item_container hidden codebox2" style="cursor: pointer;">
					<div class="dropbox_select_button_item">
						<p class="dropbox_select_button_item_typo" onclick="fnSelect('B001', '??????')" data-div="COMP_GROUP_CD">??????</p>
					</div>
					<div class="dropbox_select_button_item">
						<p class="dropbox_select_button_item_typo" onclick="fnSelect('B002', '???????????????')" data-div="COMP_GROUP_CD">???????????????</p>
					</div>
				</div>
			</div>
		</div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">?????????????????????</p>
      <input class="sign_up_info_item_blank" type="text" name="COMP_NO" id="COMP_NO" data-field="?????????????????????" onchange="RequiredAdd()"/>
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">??????</p>
      <input class="sign_up_info_item_blank" style="width: 253px;" type="text" name="COMP_NAME" data-field="??????" onchange="RequiredAdd()" id="COMP_NAME" />
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">????????? ??????</p>
      <input class="sign_up_info_item_blank" type="text" name="COMP_ADDRESS" id="COMP_ADDRESS" data-field="??????" onchange="RequiredAdd()" readonly />
			<input class="sign_up_info_item_blank" type="text" name="COMP_ADDRESS_DTL" id="COMP_ADDRESS_DTL" data-field="????????????" onchange="RequiredAdd()" />
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo">?????????????????? ??????</p>
      <input class="sign_up_info_item_blank_with_button" style="width: 341px;"/>
      <input type="file" name="COMP_FILE" id="COMP_FILE" style="display: none;" data-field="??????" onchange="fnSetFile();" />
      <button class="sign_up_info_item_button" type="button" id="compFileBtn">
        <p class="sign_up_info_item_button_typo">????????????</p>
      </button>
    </div>
    <div class="sign_up_info_item">
      <p class="sign_up_info_item_typo"></p>
      <p class="sign_up_info_item_blank_comment">??? ????????? ???????????? ????????? ??????????????????. ????????? ??? ???????????? ????????? ?????? ??? ????????????.
      										<br>??? ??????????????? ?????? ?????? ????????? ????????? ?????? ??? ?????? ????????????.
      </p>
    </div>
  </div>
  </form>
</div>

<div class="sign_up_page_button_container" style="margin-top: 50.5px;">
  <a href="javascript:fnPrev()" class="sign_up_page_button">
    <p class="sign_up_page_button_typo">?????? ?????????</p>
  </a>
  <a href="javascript:void(0)" class="sign_up_confirm_button" onclick="fnSave();">
		<p class="sign_up_confirm_button_typo">??????</p>
	</a>
</div>

<form name="snsForm" id="snsForm" action="/${api}/sign/accept_conditions" method="post">
	<input type="hidden" name="dvsn" id="dvsn" value="sns" />
	<input type="hidden" name="SNS_DVSN" id="SNS_DVSN" />
	<input type="hidden" name="SNS_ID" id="SNS_ID" />
	<input type="hidden" name="SNS_MOBILE" id="SNS_MOBILE" />
	<input type="hidden" name="SNS_NAME" id="SNS_NAME" />
	<input type="hidden" name="SNS_ADDRESS" id="SNS_ADDRESS" />
	<input type="hidden" name="SNS_NICKNAME" id="SNS_NICKNAME" />
</form>
