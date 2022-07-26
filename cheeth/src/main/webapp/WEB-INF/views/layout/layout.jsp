<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <title>덴트너 | Dentner - 모든 치아들의 디자인 플랫폼</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Content-Script-Type" content="text/javascript" />
    <meta http-equiv="Content-Style-Type" content="text/css" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <link rel="icon" type="image/x-icon" href="/public/assets/images/favicon.png">
    
    <link type="text/css" rel="stylesheet" href="/public/assets/css/bootstrap/bootstrap.min.css"/>
    <link type="text/css" rel="stylesheet" href="/public/assets/css/default.css"/>
    <link type="text/css" rel="stylesheet" href="/public/assets/css/header.css"/>
    <link type="text/css" rel="stylesheet" href="/public/assets/css/footer.css"/>
    <link type="text/css" rel="stylesheet" href="/public/assets/css/etc.css"/>
    <script type="text/javascript" src="/js/bootstrap/bootstrap.bundle.min.js"></script>
    <script type="text/javascript" src="/js/jquery/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="/js/common/common.js"></script>
    <script type="text/javascript" src="/js/swiper.js"></script>
    <c:set var="api" value="api" scope="request" />
    
    <script>
    const API = '${api}';
    $(function() {
      
    });
    </script>
    
  </head>
   <body>
    <section class="content">
      <c:choose>
        <c:when test="${layout eq 'popup'}">
          <tiles:insertAttribute name="body"/>
        </c:when>
        <c:otherwise>
          <tiles:insertAttribute name="header"/>
          <tiles:insertAttribute name="body"/>
          <tiles:insertAttribute name="footer"/>
        </c:otherwise>
      </c:choose>
    </section>
  </body>
</html>
