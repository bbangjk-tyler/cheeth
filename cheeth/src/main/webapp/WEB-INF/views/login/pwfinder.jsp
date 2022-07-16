<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<meta name ="google-signin-client_id" content="424263397710-33kiaq16joefkfn7cdeffjmvg0vvg5jr.apps.googleusercontent.com">

<form:form id="loginForm" name="loginForm" action="/api/login/emailSendAction" method="post">
	<div class="login_body">
	  <div class="login_container">
	    <p class="login_title_typo">비밀번호 찾기</p>
	    <div class="login_editor_container">
	      <input type="text" class="login_editor" id="id" name="email" placeholder="이메일을 입력해주세요." />
	    </div>
	    <button type="submit" class="login_submit_button" style="cursor: pointer;" onclick="fnLogin();">
	      <p class="login_submit_button_typo">찾기</p>
	    </button>
	  </div>
	</div>
</form:form>
<script>
function fnLogin(){
	$("#loginForm").submit();	
}
</script>