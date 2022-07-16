<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<script>

  function fnLogOut() {
    $('#logoutForm').submit();
  }
  
  $(document).ready(function() {
	  
  });

</script>
<div class="header">
  <div class="container header_container">
    <div class="header_left_container">
      <img class="header_logo_img" style="cursor: pointer;" src='/public/assets/images/logo.png' onclick="javascript:location.href='/'" title="dentner" />
      <div class="header_left_menu_container">
        <p class="header_left_menu_typo" onclick="javascript:location.href='/${api}/introduction/service_introduction'">서비스 소개</p>
        <p class="header_left_menu_typo" onclick="javascript:location.href='/${api}/project/project_view_all'">프로젝트 보기</p>
        <p class="header_left_menu_typo" onclick="javascript:location.href='/${api}/cheesigner/cheesigner_view_all'">치자이너 찾기</p>
      </div>
    </div>
    <div class="header_right_menu_container">
      <c:choose>
        <c:when test="${empty sessionInfo.user}">
          <div class="header_right_menu_user_info_container">
            <p class="header_right_menu_user_info_typo" onclick="javascript:location.href='/${api}/sign/sign_up_membership_type'">회원가입</p>
            <div class="header_right_menu_user_info_bar"></div>
            <p class="header_right_menu_user_info_typo" onclick="javascript:location.href='/${api}/login/view'">로그인</p>
          </div>
        </c:when>
        <c:otherwise>
          <!-- 로그인계정 -->
          <p class="header_right_menu_user_info_typo user">
            <img src="/public/assets/images/user.png" alt="${sessionInfo.user.USER_NICK_NAME}">
            
            <c:choose>
          	<c:when test="${sessionInfo.user.USER_TYPE_CD eq 1}">
          		<span class="username" onclick="javascript:location.href='/${api}/mypage/equipment_estimator_my_page_equipment'">${sessionInfo.user.USER_NICK_NAME}</span>
          	</c:when>
          	<c:when test="${sessionInfo.user.USER_TYPE_CD eq 2}">
          		<span class="username" onclick="javascript:location.href='/${api}/tribute/request_basket'">${sessionInfo.user.USER_NICK_NAME}</span>
          	</c:when>
          	<c:otherwise>
          		<span class="username" onclick="javascript:location.href='/${api}/mypage/equipment_estimator_my_page_sent'">${sessionInfo.user.USER_NICK_NAME}</span>
          	</c:otherwise>
          </c:choose>
            <c:choose>
          	<c:when test="${sessionInfo.user.USER_TYPE_CD eq 3}">
          		<span class="username_blue" onclick="javascript:location.href='/${api}/mypage/profile_management_cheesigner'">${sessionInfo.user.USER_TYPE_NM}</span>
          	</c:when>
          	<c:when test="${sessionInfo.user.USER_TYPE_CD eq 2}">
          		<span class="username_blue" onclick="javascript:location.href='/${api}/mypage/profile_management'">의뢰인</span>
          	</c:when>
          	<c:otherwise>
          		<span class="username_blue" onclick="javascript:location.href='/${api}/mypage/profile_management'">일반</span>
          	</c:otherwise>
          </c:choose>
            <span class="username_blue" onclick="javascript:location.href='/${api}/talk/receive'">쪽지함<img id="unread" src="/public/assets/images/notification_alert.svg" style="position:absolute;display:none;right:-18px;top:0px;width:15px;height:15px;"></span>
          </p>
          <!-- //로그인계정 -->
          <p class="header_right_menu_user_info_typo logout" onclick="fnLogOut();">로그아웃</p>
        </c:otherwise>
      </c:choose>
      <div class="header_left_menu_etc_container">
        <p class="header_left_menu_etc_typo" onclick="javascript:window('https://www.youtube.com/channel/UCKtPCLapHeXqhfYW_IyFQug')"><img src="/public/assets/images/youtube-icon.png" style="width:60px;"></p>
<!--         <p class="header_left_menu_etc_typo" onclick="javascript:alert('Language');">Language</p> -->
      </div>
    </div>
  </div>
</div>
<script>
function showUnread(result) {
	if(result != 0){
		$("#unread").css("display", "block");		
	}else{
		$("#unread").css("display", "none");
	}
}
$(document).ready(function(){
	/* getUnread();
	getInfiniteUnread();  */
});
function getUnread(){
	$.ajax({
		type: "GET",
		url: "/api/talk/getUnreadCnt2",
		/* data: { userID: encodeURIComponent( '${sessionInfo.user.USER}' ) }, */
		data: {  },
		success: function(result){
			console.log("result.TOTAL_CNT1 " + result.TOTAL_CNT);
			console.log("result.TOTAL_CNT2 " + result);
			if(result.TOTAL_CNT >= 1) {
				showUnread(result);
			}else {
				showUnread(0);
			}
		}
	});
}

function getInfiniteUnread() {
	setInterval(function(){
		getUnread();
	}, 2000);
}

</script>
<form:form id="logoutForm" nmame="logoutForm" action="/${api}/logout/logout" method="post"></form:form>
