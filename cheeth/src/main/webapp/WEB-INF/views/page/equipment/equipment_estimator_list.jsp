<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!-- <script type="text/javascript">
  	var locations = document.location.href;
  	locations += ""; 
  	if (locations.includes('http://www.')) {
          document.location.href = document.location.href.replace('http://www.', 'https://');
     }else if(locations.includes('http:')){
    	 document.location.href = document.location.href.replace('http:', 'https:');
     }else if(locations.includes('https://www.')){
    	 document.location.href = document.location.href.replace('https://www.', 'https://');
     }
</script> -->
<c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if>

<script>
function confirmModal() {
	  if (window.confirm("\n 해당 서비스를 이용하려면 추가정보 입력이 필요합니다. \n \n입력창으로 가시겠습니까?")) {
	    location.href = ('/api/mypage/my_page_edit_info');
	  } else {
		  
	  }
	}
  function fnAllView() {
    location.href = '/' + API + '/equipment/equipment_estimator_list';
  }
  
  function fnCancel() {
    fnAllView();
  }
  
  function fnSave() {
    
  }
  
  function fnSearch() {
	  var page = arguments[0] ?? '1';
	  $('#PAGE').val(page);
	  $('#searchForm').submit();
	}
  
  function fnSearchcheCkbox() {
	  var target = arguments[0];
	  var id = arguments[1];
	  var chk = $(arguments[0]).is(':checked');
	  if(chk) {
	    $('#' + id).val('Y');
	  } else {
	    $('#' + id).val('N');
	  }
	  fnSearch();
	}
  
  $(function() {
	  
	  if('${param.SEARCH_OPTION_1}' === 'Y') {
	    $('#SEARCH_OPTION_1').val('Y');
	    $('#SEARCH_OPTION_1_CHK').prop('checked',true);
	  } else {
	    $('#SEARCH_OPTION_1').val('N');
	    $('#SEARCH_OPTION_1_CHK').prop('checked',false);
	  }
	  
	  if('${param.SEARCH_OPTION_2}' === 'Y') {
	    $('#SEARCH_OPTION_2').val('Y');
	    $('#SEARCH_OPTION_2_CHK').prop('checked',true);
	  } else {
	    $('#SEARCH_OPTION_2').val('N');
	    $('#SEARCH_OPTION_2_CHK').prop('checked',false);
	  }
	    
	  fnSetPageInfo('${PAGE}', '${TOTAL_CNT}', 10);
	  
  });
  
</script>

<form:form id="searchForm" name="searchForm" action="/${api}/equipment/equipment_estimator_list" method="GET">
  
  <input type="hidden" id="PAGE" name="PAGE" value="${PAGE}">
  <input type="hidden" id="SEARCH_EQ_CD" name="SEARCH_EQ_CD" value="${param.SEARCH_EQ_CD}">
  <input type="hidden" id="SEARCH_OPTION_1" name="SEARCH_OPTION_1" value="${param.SEARCH_OPTION_1}">
  <input type="hidden" id="SEARCH_OPTION_2" name="SEARCH_OPTION_2" value="${param.SEARCH_OPTION_2}">

<div class="equipment_estimator_header">
        <p class="equipment_estimator_header_typo">
            치과 / 치과기공 장비 견적소
        </p>
    </div>
    <div class="equipment_estimator_body">
        <div class="side_menu">
            <div class="side_menu_title" style="cursor: pointer;" onclick="fnAllView();">
                <p class="side_menu_title_typo">
                    전체보기
                </p>
            </div>
            <c:forEach var="item" items="${EQ_CD_LIST}" varStatus="status">
            	<c:if test="${item.CODE_CD eq SEARCH_EQ_CD}">
	            	<c:set var="SEARCH_EQ_NM" value="${item.CODE_NM}"/>
            	</c:if>
              <a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=${item.CODE_CD}" class="side_menu_list">
                <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
                <p class="side_menu_list_typo${item.CODE_CD eq SEARCH_EQ_CD ? '_blue' : ''}">${item.CODE_NM}</p>
              </a>
            </c:forEach>
        </div>
        <div class="equipment_estimator_list_main_container">
            <div class="equipment_estimator_connection_location_container">
                <a href="/" class="equipment_estimator_connection_location_typo">
                    <img class="equipment_estimator_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
                </a>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo">치과/치과기공 장비 견적소</p>
                </div>
                <img class="equipment_estimator_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
                <div class="equipment_estimator_connection_location">
                    <p class="equipment_estimator_connection_location_typo_bold">${empty SEARCH_EQ_NM ? '전체보기' : SEARCH_EQ_NM}</p>
                </div>
            </div>
            <div class="equipment_estimator_filter_container">
				      <c:if test="${not empty sessionInfo.user}">
                <div class="equipment_estimator_filter">
                  <input type="checkbox" id="SEARCH_OPTION_1_CHK" onchange="fnSearchcheCkbox(this, 'SEARCH_OPTION_1');">
                  <p class="equipment_estimator_filter_typo">내가 쓴 글 보기</p>
                </div>
              </c:if>
                <div class="equipment_estimator_filter">
                	<input type="checkbox" id="SEARCH_OPTION_2_CHK" onchange="fnSearchcheCkbox(this, 'SEARCH_OPTION_2');">
                  <p class="equipment_estimator_filter_typo"><label for="SEARCH_OPTION_2_CHK" style="cursor: pointer;">미체결건만 보기</label></p>
                </div>
                <select id="SEARCH_ORDER" name="SEARCH_ORDER" class="boardtop_select" onchange="fnSearch();">
	                <option value="A" ${param.SEARCH_ORDER eq 'A' ? 'selected' : ''}>작성일 순</option>
	                <option value="B" ${param.SEARCH_ORDER eq 'B' ? 'selected' : ''}>견적만료시간 순</option>
                </select>
            </div>
            <div class="equipment_estimator_list_container">
                <div class="equipment_estimator_list_data_type_container">
                    <div class="equipment_estimator_list_data_type_order">
                        <p class="equipment_estimator_list_data_type_order_typo">NO</p>
                    </div>
                    <div class="equipment_estimator_list_data_type_title">
                        <p class="equipment_estimator_list_data_type_title_typo">글제목</p>
                    </div>
                    <div class="equipment_estimator_list_data_type_numb">
                        <p class="equipment_estimator_list_data_type_numb_typo">견적수</p>
                    </div>
                    <div class="equipment_estimator_list_data_type_location">
                        <p class="equipment_estimator_list_data_type_location_typo">지역</p>
                    </div>
                    <div class="equipment_estimator_list_data_type_date_created">
                        <p class="equipment_estimator_list_data_type_date_created_typo">작성일</p>
                    </div>
                    <div class="equipment_estimator_list_data_type_date_expiry">
                        <p class="equipment_estimator_list_data_type_date_expiry_typo">견적요청 만료시간</p>
                    </div>
                </div>
                <div class="list_divider"></div>
                <c:forEach items="${LIST}" var="item" varStatus="vs">
	                <div class="equipment_estimator_list">
	                    <div class="equipment_estimator_list_order">
	                        <p class="equipment_estimator_list_typo">${item.RN}</p>
	                    </div>
	                    <a href="/${api}/equipment/equipment_estimator_view?EQ_NO=${item.EQ_NO}&SEARCH_EQ_CD=${SEARCH_EQ_CD}" class="equipment_estimator_list_title">
	                        <p class="equipment_estimator_list_typo">${item.TITLE}</p>
	                    </a>
	                    <div class="equipment_estimator_list_numb">
	                        <p class="equipment_estimator_list_typo">${item.EQ_CNT}</p>
	                    </div>
	                    <div class="equipment_estimator_list_location">
	                        <p class="equipment_estimator_list_typo">${item.AREA_NM}</p>
	                    </div>
	                    <div class="equipment_estimator_list_date_created">
	                        <div class="equipment_estimator_list_typo">${item.CREATE_DATE}</div>
	                    </div>
	                    <div class="equipment_estimator_list_date_expiry">
	                        <p class="equipment_estimator_list_typo">${item.EQ_EXP_DATE}</p>
	                    </div>
	                </div>
	                <div class="list_divider"></div>
                </c:forEach>
<%--                 <c:if test="${not empty sessionInfo.user}">
	                <a href="/${api}/equipment/equipment_estimator_writing" class="equipment_estimator_writing_button">
	                    <img class="equipment_estimator_writing_button_icon" src="/public/assets/images/writing_button.svg">
	                    <p class="equipment_estimator_writing_button_typo">
	                        	견적 요청
	                    </p>
	                </a>
                </c:if> --%>
			<c:choose>
	      <c:when test="${not empty sessionInfo.user and sessionInfo.user.USER_TYPE_CD eq 1 and empty sessionInfo.user.COMP_FILE_CD}">
		      <div class="project_writing_button_container">
		        <a href="javascript:confirmModal()" class="project_writing_button">
		          <img class="project_writing_button_icon" src="/public/assets/images/writing_button.svg">
		          <p class="project_writing_button_typo">견적 요청</p>
		        </a>
		      </div>
	      </c:when>
	      
	      <c:otherwise>
		      <div class="project_writing_button_container">
	                <a href="/${api}/equipment/equipment_estimator_writing" class="equipment_estimator_writing_button">
	                    <img class="equipment_estimator_writing_button_icon" src="/public/assets/images/writing_button.svg">
	                    <p class="equipment_estimator_writing_button_typo">
	                        	견적 요청
	                    </p>
	                </a>
		      </div>
	      </c:otherwise>
	      </c:choose>
            </div>
            
            <div class="equipment_estimator_sub_container">
            	<div class="pagination"></div>
              <div class="search">
              	<div class="search_field_wrapper">
						      <select id="SEARCH_TYPE" name="SEARCH_TYPE" class="search_field search_field_typo">
						        <option value="ALL" <c:if test="${empty param.SEARCH_TYPE or param.SEARCH_TYPE eq 'ALL'}">selected="selected"</c:if>>전체</option>
						        <option value="TITLE" <c:if test="${param.SEARCH_TYPE eq 'TITLE'}">selected="selected"</c:if>>제목</option>
						        <option value="NICK" <c:if test="${param.SEARCH_TYPE eq 'NICK'}">selected="selected"</c:if>>닉네임</option>
					        </select>
					        <img class="search_field_arrow" src="/public/assets/images/search_field_arrow.svg" style="float: right; margin: -20px 10px;"/>
				        </div>
					      <input type="text" class="search_bar" id="SEARCH_TXT" name="SEARCH_TXT" value="${param.SEARCH_TXT}">
					      <button class="search_button" onclick="fnSearch();">
					        <img class="Search_button_icon" src="/public/assets/images/search_button_icon.svg"/>
					        <p class="search_button_typo">검색</p>
					      </button>
					    </div>
            </div>
        </div>
    </div>
    
</form:form>
    