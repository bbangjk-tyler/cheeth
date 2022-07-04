<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	//console.log(Kakao.isInitialized());

	$(function() {
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
		
	});
	
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
		$('#snsLoginForm > input[name=id]').val(id);
		$('#snsLoginForm > input[name=pw]').val(id);
		$('#snsLoginForm').submit();
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
	
	// 추후 사용 여부 검토 필요
	function kakaoLogout() {
		/* if(Kakao.Auth.getAccessToken()) {
			console.log('before logout -> ', Kakao.Auth.getAccessToken());
			Kakao.Auth.logout(function() {
				console.log('after logout -> ', Kakao.Auth.getAccessToken());
			});
		} */
		
		Kakao.API.request({
			url: '/v1/user/unlink',
			success: function(res) {
				console.log('unlink -> ', res);
			},
			fail: function(error) {
				console.log('unlink error -> ', error);
			}
		});
	}
	
	function naverLogout() {
		var testPopup = window.open("https://nid.naver.com/nidlogin.logout", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,width=500,height=700");
		setTimeout(function() {
			testPopup.close();
		}, 2000);
	}
	
	function googleLogout() {
		const auth2 = gapi.auth2.getAuthInstance();
		auth2.signOut().then(function() {
			console.log('google signed out');
		});
	}
	
  function fnViewType() {
    var target = $('.sign_up_popover');
    if(target.hasClass('hidden')) {
      target.removeClass('hidden');
    } else {
      target.addClass('hidden');
    }
  }
  
</script>

<div class="sign_up_sign_up_container membership_type_container">
  <div class="sign_up_sign_up_typo_container">
    <p class="sign_up_sign_up_typo">회원가입</p>
   </div>
  <div class="sign_up_sign_up_step_container">
     <div class="sign_up_sign_up_step" style="color: #2093EB;">
       <p class="sign_up_sign_up_step_number">STEP 1</p>
       <p class="sign_up_sign_up_step_title">회원유형 선택</p>
     </div>
     <img class="sign_up_sign_up_step_arrow" src="/public/assets/images/sign_up_steps_right_arrow.svg">
     <div class="sign_up_sign_up_step">
       <p class="sign_up_sign_up_step_number">STEP 2</p>
       <p class="sign_up_sign_up_step_title">약관동의</p>
     </div>
       <img class="sign_up_sign_up_step_arrow" src="/public/assets/images/sign_up_steps_right_arrow.svg">
       <div class="sign_up_sign_up_step">
         <p class="sign_up_sign_up_step_number">STEP 3</p>
         <p class="sign_up_sign_up_step_title">정보입력</p>
       </div>
  </div>
</div>

<div class="membership_type_wrapper">
  <div class="membership_type_container">
    <div class="membership_type_normal">
      <img class="membership_type_normal_image" src="/public/assets/images/sign_up_normal.svg"/>
       <a href="/${api}/sign/accept_conditions?dvsn=type01" class="membership_type_normal_button">
         <p class="membership_type_normal_button_typo">일반 회원가입</p>
       </a>
    </div>
    <div class="membership_type_expert">
      <img class="membership_type_expert_image" src="/public/assets/images/sign_up_expert.svg"/>
      <a href="javascript:fnViewType();" class="membership_type_expert_button">
        <p class="membership_type_expert_button_typo">전문가 회원가입</p>
      </a>
      <div class="sign_up_popover hidden">
         <div class="sign_up_popover_item">
           <a href="/${api}/sign/accept_conditions?dvsn=type02" id="expertClient" onclick="selectExpertType(this);">의뢰인</a>
         </div>
        <div class="sign_up_popover_item">
          <a href="/${api}/sign/accept_conditions?dvsn=type03" id="expertCheesigner" onclick="selectExpertType(this);">치자이너(CAD디자이너)</a>
        </div>
       </div>
    </div>
  </div>
  <div class="login_platform_container">
    <button class="login_platform_button login_platform_button_kakao" style="cursor: pointer;" onclick="kakaoLogin();">
      <p class="login_platform_button_kakao_typo"><img src="/public/assets/images/kakao.png" alt="">카카오 계정으로 로그인</p>
    </button>
    <button id="naverIdLogin_loginButton" class="login_platform_button login_platform_button_naver" style="cursor: pointer;">
    	<p class="login_platform_button_naver_typo"><img src="/public/assets/images/naver.png" alt="">네이버 계정으로 로그인</p>
    </button>
    <button id="GgCustomLogin" class="login_platform_button login_platform_button_google" style="cursor: pointer;">
      <p class="login_platform_button_google_typo"><img src="/public/assets/images/google.png" alt="">구글 계정으로 로그인</p>
    </button>
  </div>
  <form name="snsForm" id="snsForm" action="/${api}/sign/accept_conditions" method="post">
  	<input type="hidden" name="dvsn" id="dvsn" value="sns" />
  </form>
  <form name="snsLoginForm" id="snsLoginForm" action="/${api}/login/login" method="post">
  	<input type="hidden" id="id" name="id" />
	  <input type="hidden" id="pw" name="pw" />
  </form>
</div>
