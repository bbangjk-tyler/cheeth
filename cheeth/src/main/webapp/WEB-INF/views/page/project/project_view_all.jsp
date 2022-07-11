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
    location.href = '/' + API + '/project/project_view_all';
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
  
  function fnSelect_1() {
    var code = arguments[0];
    var codeNm = arguments[1];
    
    var target = $('#SEARCH_ORDER_DIV_2');
    if(target.hasClass('hidden')) {
      target.removeClass('hidden');
    } else {
      target.addClass('hidden');
    } 
    
    if(isNotEmpty(code)) {
      $('#SEARCH_ORDER_DIV_1').find('p').html(codeNm);
      $('#SEARCH_ORDER').val(code);
      fnSearch();
    }
  }
  
  function fnSelectNm_1() {
    var code = arguments[0];
    if(isNotEmpty(code)) {
      var codeNm = '';
      if(code === 'A') {
        codeNm = '작성일 순';
      } else if(code === 'B') {
        codeNm = '견적만료시간 순';
      }
      if(isNotEmpty(codeNm)) $('#SEARCH_ORDER_DIV_1').find('p').html(codeNm);
    }
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
  
  $(document).ready(function() {
    
    fnSelectNm_1('${param.SEARCH_ORDER}');
    
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
  $(document).ready(function(){
	 $("#ProjectCategory").text(CategoryName); 
	 console.log(CategoryName);
  });
</script>

<form:form id="searchForm" name="searchForm" action="/${api}/project/project_view_all" method="GET">
  
  <input type="hidden" id="PAGE" name="PAGE" value="${PAGE}">
  <input type="hidden" id="SEARCH_ORDER" name="SEARCH_ORDER" value="${param.SEARCH_ORDER}">
  <input type="hidden" id="SEARCH_PROJECT_CD" name="SEARCH_PROJECT_CD" value="${param.SEARCH_PROJECT_CD}">
  <input type="hidden" id="SEARCH_OPTION_1" name="SEARCH_OPTION_1" value="${param.SEARCH_OPTION_1}">
  <input type="hidden" id="SEARCH_OPTION_2" name="SEARCH_OPTION_2" value="${param.SEARCH_OPTION_2}">

  <div class="project_header">
	  <p class="project_header_typo">프로젝트 보기</p>
	</div>
	
	<div class="project_body">
	  <div class="side_menu">
	    <div class="side_menu_title" style="cursor: pointer;" onclick="fnAllView();">
	      <p class="side_menu_title_typo">전체보기</p>
	    </div>
	    <c:forEach var="item" items="${PROJECT_CD_LIST}" varStatus="status">
	      <a href="/${api}/project/project_view_all?SEARCH_PROJECT_CD=${item.CODE_CD}" class="side_menu_list">
	        <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
	        <c:if test="${item.CODE_CD eq param.SEARCH_PROJECT_CD}">
		        <p class="side_menu_list_typo_blue">${item.CODE_NM}</p>
		        <script>
		        var CategoryName ="${item.CODE_NM}";
		        </script>
	        </c:if>
	        <c:if test="${item.CODE_CD ne param.SEARCH_PROJECT_CD}">
		        <p class="side_menu_list_typo">${item.CODE_NM}</p>
	        </c:if>
	      </a>
	    </c:forEach>
	  </div>
	  <div class="project_list_main_container">
	    <div class="project_connection_location_container">
	      <a href="/" class="project_connection_location_typo">
	        <img class="project_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
	      </a>
	      <img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="project_connection_location">
	        <p class="project_connection_location_typo">프로젝트 보기</p>
	      </div>
	      <img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="project_connection_location" style="cursor: pointer;" onclick="fnAllView();">
	        <p class="project_connection_location_typo">프로젝트 전체보기</p>
	      </div>
	      <img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	      <div class="project_connection_location" style="cursor: pointer;" onclick="fnAllView();">
	        <p class="project_connection_location_typo_bold" id="ProjectCategory"></p>
	      </div>
	    </div>
	    <div class="project_filter_container">
	      <c:if test="${not empty sessionInfo.user}">
		      <div class="project_filter">
		        <input type="checkbox" id="SEARCH_OPTION_1_CHK" onchange="fnSearchcheCkbox(this, 'SEARCH_OPTION_1');">
		        <p class="project_filter_typo">내가 쓴 글 보기</p>
		      </div>
	      </c:if>
	      <div class="project_filter">
	        <input type="checkbox" id="SEARCH_OPTION_2_CHK" onchange="fnSearchcheCkbox(this, 'SEARCH_OPTION_2');">
	        <p class="project_filter_typo">미체결건만 보기</p>
	      </div>
	      <div class="dropbox_project_view_all">
	        <div class="dropbox_select_button">
	          <div id="SEARCH_ORDER_DIV_1" class="dropbox_select_button_typo_container" onclick="fnSelect_1();" style="cursor: pointer;">
	            <p class="dropbox_select_button_typo">작성일 순</p>
	            <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
	          </div>
	        </div>
	        <div id="SEARCH_ORDER_DIV_2" class="dropbox_select_button_item_container hidden" style="cursor: pointer;">
	          <div class="dropbox_select_button_item" onclick="fnSelect_1('A', '작성일 순')">
	            <p class="dropbox_select_button_item_typo">작성일 순</p>
	          </div>
	          <div class="dropbox_select_button_item" onclick="fnSelect_1('B', '견적만료시간 순')">
	            <p class="dropbox_select_button_item_typo">견적만료시간 순</p>
	          </div>
	        </div>
	      </div>
	    </div>
	    <div class="connection_location_divider divider_without_margin"></div>
	    <div class="project_list_container">
	      <div class="project_list_data_type_container">
	        <div class="project_list_data_type project_list_order">
	          <p class="project_list_order_typo">NO</p>
	        </div>
	        <div class="project_list_data_type project_list_title">
	          <p class="project_list_data_type_title_typo">글제목</p>
	        </div>
	        <div class="project_list_data_type project_list_nickname">
	          <p class="project_list_data_type_location_typo">닉네임</p>
	        </div>
	        <div class="project_list_data_type project_list_nickname">
            <p class="project_list_data_type_location_typo">진행상태</p>
          </div>
	        <div class="project_list_data_type project_list_numb">
	          <p class="project_list_data_type_numb_typo">견적수</p>
	        </div>
	        <div class="project_list_data_type project_list_date_created">
	          <p class="project_list_data_type_date_created_typo">작성일</p>
	        </div>
	        <div class="project_list_data_type project_list_date_expiry">
	          <p class="project_list_data_type_date_expiry_typo">견적요청 만료시간</p>
	        </div>
	      </div>
	      <div class="list_divider"></div>
	      <c:forEach var="item" items="${LIST}" varStatus="status">
	        <div class="project_list">
		        <div class="project_list project_list_order">
		          <p class="project_list_order_typo">${item.RN}</p>
		        </div>
		        <div class="project_list project_list_title">
			        <a href="/${api}/project/project_request_view?PROJECT_NO=${item.PROJECT_NO}" >
			          <p class="project_list_title_typo">${item.TITLE}</p>
			        </a>
		        </div>
		        <div class="project_list project_list_nickname">
		          <p class="project_list_nickname_typo">${item.USER_NICK_NAME}</p>
		        </div>
		        <div class="project_list project_list_nickname">
              <p class="project_list_nickname_typo">${item.PROGRESS_NM}</p>
            </div>
		        <div class="project_list project_list_numb">
		          <p class="project_list_numb_typo">${item.PROJECT_CNT}</p>
		        </div>
		        <div class="project_list project_list_date_created">
		          <div class="project_list_date_created_typo">${item.CREATE_DATE}</div>
		        </div>
		        <div class="project_list project_list_date_expiry">
		          <p class="project_list_date_expiry_typo">${item.PROJECT_EXP_DATE}</p>
		        </div>
		      </div>
		      <div class="list_divider"></div>
	      </c:forEach>
	      <%-- <c:if test="${not empty sessionInfo.user}"> --%>
	      <c:if test="${not empty sessionInfo.user and sessionInfo.user.USER_TYPE_CD eq 2 and not empty sessionInfo.user.COMP_NO}">
		      <div class="project_writing_button_container">
		        <a href="/${api}/project/project_request" class="project_writing_button">
		          <img class="project_writing_button_icon" src="/public/assets/images/writing_button.svg">
		          <p class="project_writing_button_typo">견적요청 하기</p>
		        </a>
		      </div>
	      </c:if>
	      <c:if test="${not empty sessionInfo.user and sessionInfo.user.USER_TYPE_CD eq 2 and empty sessionInfo.user.COMP_NO}">
		      <div class="project_writing_button_container">
		        <a href="javascript:confirmModal()" class="project_writing_button">
		          <img class="project_writing_button_icon" src="/public/assets/images/writing_button.svg">
		          <p class="project_writing_button_typo">견적요청 하기</p>
		        </a>
		      </div>
	      </c:if>
	    </div>
	    <div class="project_sub_container">
	      <div class="pagination"></div>
	      <div class="search">
	        <select id="SEARCH_TYPE" name="SEARCH_TYPE" class="search_select">
	          <option value="ALL" <c:if test="${empty param.SEARCH_TYPE or param.SEARCH_TYPE eq 'ALL'}">selected="selected"</c:if>>전체</option>
	          <option value="TITLE" <c:if test="${param.SEARCH_TYPE eq 'TITLE'}">selected="selected"</c:if>>제목</option>
	          <option value="NICK" <c:if test="${param.SEARCH_TYPE eq 'NICK'}">selected="selected"</c:if>>닉네임</option>
          </select>
	        <input type="text" class="search_bar" id="SEARCH_TXT" name="SEARCH_TXT" value="${SEARCH_TXT}">
	        <button class="search_button" onclick="fnSearch();">
	          <img class="Search_button_icon" src="/public/assets/images/search_button_icon.svg"/>
	          <p class="search_button_typo">검색</p>
	        </button>
	      </div>
	    </div>
	  </div>
	</div>

</form:form>