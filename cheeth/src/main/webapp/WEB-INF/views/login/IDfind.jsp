<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<meta name ="google-signin-client_id" content="424263397710-33kiaq16joefkfn7cdeffjmvg0vvg5jr.apps.googleusercontent.com">

<form:form id="loginForm" nmame="loginForm" method="post">
	<div class="login_body">
	  <div class="login_container">
	    <p class="login_title_typo">아이디 목록</p>
	    <div class="login_editor_container">
	   
	    <c:choose>
	    <c:when test="${empty LIST}">
			<font>휴대전화와 일치하는 아이디가 없습니다.</font>
		</c:when>
		<c:otherwise>
			<c:forEach var="item" items="${LIST}" varStatus="status">
			<div>
		    	<font style="float:left;">${item.USER_ID}</font>
		    	<c:if test="${item.USER_TYPE_CD eq '1'}">
		    		<font style="float:right;">일반회원</font>
		    	</c:if>
		    	<c:if test="${item.USER_TYPE_CD eq '2'}">
		    		<font style="float:right;">의뢰인</font>
		    	</c:if>
		    	<c:if test="${item.USER_TYPE_CD eq '3'}">
		    		<font style="float:right;">치자이너</font>
		    	</c:if>
		    </div>
		    <br style="clear:both;">
		    </c:forEach>
		</c:otherwise>
	    </c:choose>

	    </div>
	    <button type="button" class="login_submit_button" style="cursor: pointer;" onclick="fnLogin();">
	      <p class="login_submit_button_typo">로그인 페이지로 이동</p>
	    </button>
	  </div>
	</div>
</form:form>
<script>
function fnLogin(){
	location.href = '/api/login/view';
}
</script>