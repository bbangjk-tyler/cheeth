<!-- 회원가입 관련 스크립트 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.mail.Transport" %>
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.Address" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Authenticator" %>
<%@ page import="java.util.Properties" %>
<%@ page import="javax.mail.Authenticator" %>
<%@ page import="javax.mail.PasswordAuthentication" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="util.Gmail" %>
<%@ page import="util.HmacSignature" %>
<%@ page import="util.SHA256" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<%

	String userID = null;
	if(session.getAttribute("UserIDForAccess") != null){
		userID = (String) session.getAttribute("UserIDForAccess");
	}

	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('잘못된 접근입니다.');");
		script.println("location.href = 'userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
	/* String host = "http://localhost:8080/Iddle/"; */
	
	String host = "https://dentner.co.kr/";
	String from = "dentnerkorea@gmail.com";
/* 	String to = userDAO.getUserEmail(userID); */
	String to = userID;
	String subject = "덴트너 이메일 비밀번호 재설정 메일 입니다.";
	String content = "다음 링크에 접속하여 비밀번호를 재설정하세요." +
		"<a href ='" + host + "api/login/emailCheckAction?code=" + URLEncoder.encode(userID, "UTF-8") + "'>비밀번호 재설정하기</a>";
		
	Properties p = new Properties();
	p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.googlemail.com");
	p.put("mail.smtp.port", "465");
	/* p.put("mail.smtp.port", "25"); */
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
 	p.put("mail.smtp.socketFactory.port", "465");
/* 	p.put("mail.smtp.socketFactory.port", "25"); */
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
	
	try{
		Authenticator auth = new Gmail();
		
		Session ses = Session.getInstance(p, auth);
		ses.setDebug(true);
		MimeMessage msg = new MimeMessage(ses);
		msg.setSubject(subject);
		Address fromAddr = new InternetAddress(from);
		msg.setFrom(fromAddr);
		Address toAddr = new InternetAddress(to);
		msg.addRecipient(Message.RecipientType.TO, toAddr);
		msg.setContent(content, "text/html;charset=UTF8");		
		Transport.send(msg);
	}catch(Exception e){
		e.printStackTrace();
		
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생했습니다.');"); 
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
%>

<body>
    <!-- Preloader -->
    <div class="cover"></div>
  	<br><br><br><br><br>
	<section class="container mt-3" style="max-width: 560px;">
		<div class="alert alert-success mt-4" role="alert">
			비밀번호 재설정 인증 메일이 전송되었습니다. 회원가입시 입력했던 이메일에 들어가셔서 인증해주세요.
		</div>
	</section>
	<div style="margin-left:auto;margin-right:auto;position:relative;width: 200px;">
		<button class="btn btn-success" style="margin-left:auto;margin-right:auto;position:relative;color:white!important;" onclick="gotologin()" href="./userLogin.jsp">로그인 페이지로 돌아가기</button>
	</div>
	<br><br><br><br><br><br><br><br><br><br><br><br><br>
		<!-- 제이쿼리 자바스크립트 추가하기 -->

	<script>
	function gotologin(){
		location.href = '/api/login/view';
	}
	</script>
			<!-- //////////////////////////////////////////////////////////// -->
	<!-- /////////////////////////////////////////////////////////// -->
</body>