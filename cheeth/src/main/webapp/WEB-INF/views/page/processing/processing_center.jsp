<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:if test="${empty sessionInfo.user}">
  <script>
  alert(getI8nMsg("alert.plzlogin"));
   location.href = '/api/login/view';
</script>
</c:if>
<%-- <c:if test="${sessionInfo.user.USER_TYPE_CD eq 1}">
	<script>
		alert(getI8nMsg("alert.nhaveAccess"));//접근 권한이 없습니다.
		history.back();
	</script>
</c:if> --%>
<script>
  
  var searchCode = new Array();
  
  function fnAllView() {
    location.href = '/' + API + '/processing/processing_center';
  }
  
  function fnChk() {
    var target = arguments[0];
    var targetVal = $(target).val()
    if($(target).is(':checked')) {
      var isChk = searchCode.some((s)=> s === targetVal); // 중복 허용 안함
      if(!isChk) searchCode.push(targetVal);
    } else {
      var idx = searchCode.findIndex(function(f) {return f === targetVal});
      if(idx > -1) searchCode.splice(idx, 1);
    }
  }
  
  function fnSearch() {
    var page = arguments[0] ?? '1';
    var url = '/' + API + '/processing/processing_center';
    url += '?PAGE=' + page;
    url += '&AREA_CD=${AREA_CD}';
    url += '&SEARCH_TXT=' + encodeURI($('#SEARCH_TXT').val());
    if(searchCode && searchCode.length > 0) {
      var txt = '';
      for(var i=0; i<searchCode.length; i++) {
        if(i === 0) txt = searchCode[i];
        if(i > 0) txt += 'l' + searchCode[i];
      }
      url += '&SEARCH_CD=' + txt;
    }
    location.href = url;
  }
  
  $(document).ready(function() {
   
    fnSetPageInfo('${PAGE}', '${TOTAL_CNT}', 9);
    
    var searchCd = fnGetUrlParam('SEARCH_CD');
    if(isNotEmpty(searchCd)) {
      var s = searchCd.split("l");
      for(i=0; i<s.length; i++) {
        searchCode.push(s[i]);
        $('#'+ s[i]).prop('checked', true);
      }
    }
   
  });
  
  
</script>

<div class="processing_center_header">
  <p class="processing_center_header_typo"><spring:message code="proc.center" text="가공센터" /></p>
</div>

<div class="processing_center_body">
  <div class="side_menu">
    <div class="side_menu_title" style="cursor: pointer;" onclick="fnAllView();">
      <p class="side_menu_title_typo"><spring:message code="main.seeAll" text="전체보기" /></p>
    </div>
    <c:forEach var="item" items="${AREA_CD_LIST}" varStatus="status">
      <a href="/${api}/processing/processing_center?AREA_CD=${item.CODE_CD}" class="side_menu_list">
        <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
        <p class="side_menu_list_typo">${item.CODE_NM}</p>
      </a>
    </c:forEach>
  </div>
  
  <div class="processing_center_main_container">
    <div class="processing_center_connection_location_container">
      <a href="/" class="processing_center_connection_location_typo">
        <img class="processing_center_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
      </a>
      <img class="processing_center_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
      <div class="processing_center_connection_location">
        <p class="processing_center_connection_location_typo"><spring:message code="proc.center" text="가공센터" /></p>
      </div>
      <img class="processing_center_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
      <div class="processing_center_connection_location">
        <p class="processing_center_connection_location_typo_bold"><spring:message code="proc.allCenter" text="가공센터 전체보기" /></p>
      </div>
    </div>
    <div class="processing_center_filter_container">
      <c:forEach var="item" items="${WORK_ITEM_CD_LIST}" varStatus="status">
        <div class="processing_center_filter" style="cursor: pointer;">
          <input type="checkbox" id="${item.CODE_CD}" class="processing_center_filter_checkbox" style="cursor: pointer;" onchange="fnChk(this);" value="${item.CODE_CD}">
          <p class="processing_center_filter_typo"><label style="cursor: pointer;" for="${item.CODE_CD}">${item.CODE_NM}</label></p>
        </div>
      </c:forEach>
    </div>
    <div class="processing_center_main_center_carousel_card_container">
      <c:forEach var="item" items="${LIST}" varStatus="status">
        <div class="processing_center_main_center_carousel_card">
          <div class="processing_center_main_center_carousel_card_chip">
            <p class="processing_center_main_center_carousel_card_chip_typo">
              ${item.AREA_NM}
            </p>
          </div>
          <div class="processing_center_main_center_carousel_card_title_typo">
            <a href="/${api}/processing/processing_center_profile?PROG_NO=${item.PROG_NO}">
              ${item.CENTER_NM}
            </a>
          </div>
          <div class="processing_center_main_center_carousel_card_divider"></div>
          <p class="processing_center_main_center_carousel_card_item_typo">&nbsp;${item.WORK_ITEM_NM}</p>
          <div class="processing_center_main_center_carousel_card_item_description_typo">${item.INTRO}</div>
        </div>
      </c:forEach>
    </div>
    <div class="processing_center_writing_button_container">
<%--       <c:if test="${not empty sessionInfo.user}">
        <a href="/${api}/processing/processing_center_profile" class="processing_center_writing_button">
          <p class="processing_center_writing_button_typo">글쓰기</p>
        </a>
      </c:if> --%>
      <c:choose>
	      <c:when test="${not empty sessionInfo.user and sessionInfo.user.USER_TYPE_CD eq 2 and not empty sessionInfo.user.COMP_FILE_CD}">
		      <div class="project_writing_button_container">
		        <a href="/${api}/processing/processing_center_profile" class="processing_center_writing_button">
		          <p class="processing_center_writing_button_typo"><spring:message code="proj.toReq" text="견적 요청" /></p>
		        </a>
		      </div>
	      </c:when>
	      <c:when test="${not empty sessionInfo.user and sessionInfo.user.USER_TYPE_CD eq 3}">
		      <div class="project_writing_button_container">
		        <a href="/${api}/processing/processing_center_profile" class="processing_center_writing_button">
		          <p class="processing_center_writing_button_typo"><spring:message code="proj.toReq" text="견적 요청" /></p>
		        </a>
		      </div>
	      </c:when>
	      <c:otherwise>
		      <div class="project_writing_button_container">
		        <a href="javascript:confirmModal()" class="project_writing_button">
		          <img class="project_writing_button_icon" src="/public/assets/images/writing_button.svg">
		          <p class="project_writing_button_typo"><spring:message code="proj.toReq" text="견적 요청" /></p>
		        </a>
		      </div>
	      </c:otherwise>
	      </c:choose>
    </div>
    <div class="processing_center_sub_container">
      <div class="pagination"></div>
      <div class="search">
        <div class="search_field_wrapper">
          <select id="SEARCH_TYPE" name="SEARCH_TYPE" class="search_field search_field_typo">
            <option value="ALL" <c:if test="${empty param.SEARCH_TYPE or param.SEARCH_TYPE eq 'ALL'}">selected="selected"</c:if>><spring:message code="cent.name" text="센터이름" /></option>
          </select>
          <img class="search_field_arrow" src="/public/assets/images/search_field_arrow.svg" style="float: right; margin: -20px 10px;"/>
        </div>
        <input type="text" class="search_bar" id="SEARCH_TXT" name="SEARCH_TXT" value="${param.SEARCH_TXT}">
        <button class="search_button" onclick="fnSearch();">
          <img class="Search_button_icon" src="/public/assets/images/search_button_icon.svg"/>
          <p class="search_button_typo"><spring:message code="search" text="검색" /></p>
        </button>
      </div>
    </div>
  </div>
</div>
