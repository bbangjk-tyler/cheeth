<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<meta name ="google-signin-client_id" content="424263397710-33kiaq16joefkfn7cdeffjmvg0vvg5jr.apps.googleusercontent.com">

<script src="https://developers.kakao.com/sdk/js/kakao.js" charset="utf-8"></script>
<script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js" charset="utf-8"></script>
<script src="https://apis.google.com/js/platform.js?onload=initGoogle" async defer></script>

<script>
  
  Kakao.init('4f8ae9cfa86e5822181be24a7663f424');
  
  $(function() {
	  
    var state = fnGetUrlParam('state');
    if(state === 'fail') {
//       if(window.localStorage) window.localStorage.removeItem('login_save_id');
      setTimeout(function(){
        alert('로그인 실패하였습니다.');
        $('#id').focus();
      }, 500);
    }
    
    const naverLogin = new naver.LoginWithNaverId(
			{ 
				clientId: '3jKyXLNuAfly04AOvZ5U',
				callbackUrl: 'https://www.dentner.co.kr/' + API + '/sign/sign_up_membership_type',
				isPopup: true
			}		
		);
		naverLogin.init();
		
		naverLogin.getLoginStatus(function(status) {
			if(status) {
				
				const id = naverLogin.user.id;
// 				const name = naverLogin.user.name;
				const nickname = naverLogin.user.nickname;
// 				const mobile = (naverLogin.user.mobile).replace(/\-/g, '');
// 				const email = naverLogin.user.email;
				
				const obj = { 'SNS_DVSN'		 : 'NAVER',
											'SNS_ID' 			 : id,
											'SNS_NAME' 		 : '',
											'SNS_NICKNAME' : nickname,
											'SNS_MOBILE' 	 : '',
											'SNS_EMAIL' 	 : '' };
				
				if(window.opener.checkSignedUp(id)) {
					window.opener.submitSnsLoginForm(id);
				} else {
					window.opener.submitSnsForm(obj);
				}
				window.close();
			}
		});
		
    if(window.localStorage) {
      var login_save_id = window.localStorage.getItem('login_save_id');
      if(isNotEmpty(login_save_id)) {
        $('#id').val(login_save_id);
        $('#login_save_id').prop('checked', true);
        $('#pw').focus();
      }
    }
    
  });
  
  function fnLogin() {
   
    var id = $('#id').val();
    var pw = $('#pw').val();
    
    if(isEmpty(id)) {
      alert('아이디를 입력하세요.');
      $('#id').focus();
      return;
    }
    
    if(isEmpty(pw)) {
      alert('비밀번호를 입력하세요.');
      $('#pw').focus();
      return;
    }
   
    var target = $('#login_save_id');
    if(target.is(':checked')) {
      if(window.localStorage) window.localStorage.setItem('login_save_id', id);
    } else {
      if(window.localStorage) window.localStorage.removeItem('login_save_id');
    }
    
    $('#loginForm').submit();
  }
  
  function initGoogle() {
		gapi.load('auth2', function() {
			gapi.auth2.init();
			options = new gapi.auth2.SigninOptionsBuilder();
			options.setPrompt('select_account');
			options.setScope('email profile openid https://www.googleapis.com/auth/user.addresses.read');
			gapi.auth2.getAuthInstance().attachClickHandler('GgCustomLogin', options, onGoogleSignIn, onGoogleSignInFail);
		});
	}
	
	function onGoogleSignIn(googleUser) {
		
		var profile = googleUser.getBasicProfile();
		const id = profile.getId();
		const name = profile.getName();
		const email = profile.getEmail();
		
		const obj = { 'SNS_DVSN'		 : 'GOOGLE',
									'SNS_ID' 			 : id,
									'SNS_NAME' 		 : name,
									'SNS_EMAIL' 	 : email };
		
		const access_token = googleUser.getAuthResponse().access_token;
		$.ajax({
			url: 'https://people.googleapis.com/v1/people/me',
			type: 'GET',
			data: { 
						  'personFields' : 'addresses', 
							'key' 				 : 'AIzaSyCg2saJ2GfVQjMtla3phIJs_ydImf1o5-g',
							'access_token' : access_token 
						},
			cache: false,
			async: false,
			success: function(data) {
				if(data.addresses) obj['SNS_ADDRESS'] = data.addresses[0].formattedValue;
			}
		});
		
		if(checkSignedUp(id)) {
			submitSnsLoginForm(id);
		} else {
			submitSnsForm(obj);
		}
	}
	
	function onGoogleSignInFail(error) {
		console.log('onGoogleSignInFail error => ', error);
	}
	
	function submitSnsForm(obj) {
		var snsForm = document.snsForm;
		for(const property in obj) {
			const input = document.createElement('input');
			input.type = 'hidden';
			input.name = property;
			input.value = obj[property];
			snsForm.appendChild(input);
		}
		snsForm.submit();
	}
	
	function submitSnsLoginForm(id) {
		$('#loginForm input[name=id]').val(id);
		$('#loginForm input[name=pw]').val(id);
		$('#loginForm').submit();
	}
	
	function kakaoLogin() {
		Kakao.Auth.login({
			success: function(res) {
				Kakao.Auth.setAccessToken(res.access_token);
				getKakaoInfo();
			},
			fail: function(error) {
				console.log('kakaoLogin error => ', error);
			}
		});
	}
	
	function getKakaoInfo() {
		Kakao.API.request({
			url: '/v2/user/me',
			success: function(res) {
				const id = res.id;
				const nickname = res.kakao_account.profile.nickname;
				
				if(checkSignedUp(id)) {
					submitSnsLoginForm(id);
				} else {
					const obj = { 'SNS_DVSN' 		: 'KAKAO',
												'SNS_ID'			: id,
												'SNS_NICKNAME': nickname };
					submitSnsForm(obj);
				}
			},
			fail: function(error) {
				console.log('getKakaoInfo error => ', error);
			}
		});
	}
	
	function checkSignedUp(id) {
		var result;
		$.ajax({
		  url: '/' + API + '/sign/check_signed_up_sns',
		  type: 'POST',
		  data: { SNS_ID : id },
		  cache: false,
		  async: false,
		  success: function(data) {
		    result = data.result == 'Y' ? true : false;
		  }, complete: function() {

		  }, error: function() {
		    
		  }
		});
		return result;
	}
	
	
</script>

<form:form id="loginForm" nmame="loginForm" action="/${api}/login/login" method="post">
	<div class="login_body">
	  <div class="login_container">
	    <p class="login_title_typo">로그인</p>
	    <div class="login_editor_container">
	      <input type="text" class="login_editor" id="id" name="id" placeholder="이메일 로그인" />
	      <input type="password" class="login_editor" id="pw" name="pw" placeholder="비밀번호" />
	    </div>
	    <button type="button" class="login_submit_button" style="cursor: pointer;" onclick="fnLogin();">
	      <p class="login_submit_button_typo">로그인</p>
	    </button>
	    <div class="login_find_container">
	      <div class="login_find_save_container">
	        <input type="checkbox" id="login_save_id" name="login_save_id">
	        <p class="login_find_save_typo"><label style="cursor: pointer;" for="login_save_id">아이디 저장</label></p>
	      </div>
	      <div class="login_find_info_container">
	        <p class="login_find_info_typo" onclick="javascript:alert('아이디 찾기');">아이디 찾기</p>
	        <p class="login_find_info_typo" onclick="javascript:alert('비밀번호 찾기');">비밀번호 찾기</p>
	      </div>
	    </div>
	    <div class="login_platform_container">
	      <button type="button" class="login_platform_button login_platform_button_kakao" style="cursor: pointer;" onclick="kakaoLogin();">
		      <p class="login_platform_button_kakao_typo"><img src="/public/assets/images/kakao.png" alt="카카오 계정으로 로그인">카카오 계정으로 로그인</p>
		    </button>
		    <button type="button" id="naverIdLogin_loginButton" class="login_platform_button login_platform_button_naver" style="cursor: pointer;">
		    	<p class="login_platform_button_naver_typo"><img src="/public/assets/images/naver.png" alt="네이버 계정으로 로그인">네이버 계정으로 로그인</p>
		    </button>
		    <button type="button" id="GgCustomLogin" class="login_platform_button login_platform_button_google" style="cursor: pointer;">
		      <p class="login_platform_button_google_typo"><img src="/public/assets/images/google.png" alt="구글 계정으로 로그인">구글 계정으로 로그인</p>
		    </button>
	    </div>
	  </div>
	</div>
</form:form>

<form:form name="snsForm" id="snsForm" action="/${api}/sign/accept_conditions" method="post">
  <input type="hidden" name="dvsn" id="dvsn" value="sns" />
</form:form>
