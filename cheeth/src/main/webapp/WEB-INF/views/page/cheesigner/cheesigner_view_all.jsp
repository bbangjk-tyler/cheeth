<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
<c:if test="${empty sessionInfo.user}">
  <script>
   alert('로그인 후 이용가능 합니다.');
   location.href = '/api/login/view';
</script>
</c:if>
<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>

<script>

  function fnAllView() {
    location.href = '/' + API + '/cheesigner/cheesigner_view_all';
  }
  
  function fnSearch() {
	  var page = arguments[0] ?? '1';
	  $('#PAGE').val(page);
	  $('#searchForm').submit();
	}
  
  $(function() {
	  
	  fnSetPageInfo('${PAGE}', '${TOTAL_CNT}', 10);
	  
  });
  
</script>

<form:form id="searchForm" name="searchForm" action="/${api}/cheesigner/cheesigner_view_all" method="GET">
  
  <input type="hidden" id="PAGE" name="PAGE" value="${PAGE}">
  <input type="hidden" id="SEARCH_PROJECT_CD" name="SEARCH_PROJECT_CD" value="${param.SEARCH_PROJECT_CD}">

	<div class="cheesigner_view_all_header">
		<p class="cheesigner_view_all_header_typo">
			치자이너 전체보기
		</p>
	</div>
	<div class="cheesigner_view_all_body">
		<div class="side_menu">
			<div class="side_menu_title" style="cursor: pointer;" onclick="fnAllView();">
				<p class="side_menu_title_typo">
					전체보기
				</p>
			</div>
			<c:forEach var="item" items="${PROJECT_CD_LIST}" varStatus="status">
		      <a href="/${api}/cheesigner/cheesigner_view_all?SEARCH_PROJECT_CD=${item.CODE_CD}" class="side_menu_list">
		        <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
		        <c:if test="${item.CODE_CD eq param.SEARCH_PROJECT_CD}">
			        <p class="side_menu_list_typo_blue">${item.CODE_NM}</p>
		        </c:if>
		        <c:if test="${item.CODE_CD ne param.SEARCH_PROJECT_CD}">
			        <p class="side_menu_list_typo">${item.CODE_NM}</p>
		        </c:if>
		      </a>
		    </c:forEach>
		</div>
		<div class="cheesigner_view_all_list_main_container">
		  <div class="cheesigner_view_all_connection_location_container">
				<a href="/" class="cheesigner_view_all_connection_location_typo">
					<img class="cheesigner_view_all_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
				</a>
				<!-- <img class="cheesigner_view_all_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
				<div class="cheesigner_view_all_connection_location">
				    <p class="cheesigner_view_all_connection_location_typo">치자이너 전체보기</p>
				</div> -->
				<img class="cheesigner_view_all_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
				<div class="cheesigner_view_all_connection_location">
					<p class="cheesigner_view_all_connection_location_typo_bold" style="cursor: pointer;" onclick="fnAllView();">치자이너 전체보기</p>
				</div>
		  </div>
		  <div class="cheesigner_view_all_list_filter_container hidden">
				<div class="dropbox_cheesigner_view_all_container">
					<div class="dropbox_select_button">
						<div class="dropbox_select_button_typo_container">
							<p class="dropbox_select_button_typo">인기 순</p>
							<img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
						</div>
					</div>
					<div class="dropbox_select_button_item_container hidden">
						<div class="dropbox_select_button_item">
						  <p class="dropbox_select_button_item_typo">닉네임 가나다 순</p>
						</div>
						<div class="dropbox_select_button_item">
						  <p class="dropbox_select_button_item_typo">만족도 순</p>
						</div>
						<div class="dropbox_select_button_item">
						  <p class="dropbox_select_button_item_typo">거래 총 금액 순</p>
						</div>
					</div>
				</div>
			</div>
			<div class="cheesigner_view_all_list_container">
				<div class="cheesigner_view_all_list_data_type_container">
					<div class="cheesigner_view_all_list_data_type cheesigner_view_all_list_order">
					  <p class="cheesigner_view_all_list_data_typo_typo">NO</p>
					</div>
					<div class="cheesigner_view_all_list_data_type cheesigner_view_all_list_nickname">
					  <p class="cheesigner_view_all_list_data_type_typo">닉네임</p>
					</div>
					<div class="cheesigner_view_all_list_data_type cheesigner_view_all_list_success_rate">
					  <p class="cheesigner_view_all_list_data_type_typo">거래 성공률</p>
					</div>
					<div class="cheesigner_view_all_list_data_type cheesigner_view_all_list_satisfaction">
					  <p class="cheesigner_view_all_list_data_type_typo">만족도</p>
					</div>
					<div class="cheesigner_view_all_list_data_type cheesigner_view_all_list_total_project">
					  <p class="cheesigner_view_all_list_data_type_typo">거래 총 프로젝트 수</p>
					</div>
					<div class="cheesigner_view_all_list_data_type cheesigner_view_all_list_total_price">
					  <p class="cheesigner_view_all_list_data_type_typo">거래 총 금액</p>
					</div>
				</div>                
				<div class="list_divider"></div>
				<c:forEach items="${LIST}" var="item" varStatus="status">
					<div class="cheesigner_view_all_list">
				    <div class="cheesigner_view_all_list cheesigner_view_all_list_order">
				    	<p class="cheesigner_view_all_list_order_typo">${item.RN}</p>
				    </div>
				    <div class="cheesigner_view_all_list cheesigner_view_all_list_nickname">
				      <p class="cheesigner_view_all_list_typo">${item.USER_NICK_NAME}</p>
				    </div>
				    <div class="cheesigner_view_all_list cheesigner_view_all_list_success_rate">
				      <p class="cheesigner_view_all_list_typo">${item.COMPLETE_RATIO}%</p>
				    </div>
				    <div class="cheesigner_view_all_list cheesigner_view_all_list_satisfaction">
				      <p class="cheesigner_view_all_list_typo">${item.SCORE_AVG} / 10</p>
				    </div>
				    <div class="cheesigner_view_all_list cheesigner_view_all_list_total_project">
				      <div class="cheesigner_view_all_list_typo">${item.COMPLETE_CNT}</div>
				    </div>
				    <div class="cheesigner_view_all_list cheesigner_view_all_list_total_price">
				      <p class="cheesigner_view_all_list_typo">${item.COMPLETE_AMOUNT}</p>
				    </div>
				  </div>
				  <div class="list_divider"></div>
				</c:forEach>
	    </div>
			<div class="cheesigner_view_all_list_sub_container">
				<div class="pagination"></div>
				<div class="search">
					<div class="search_field_wrapper">
					  <select id="SEARCH_TYPE" name="SEARCH_TYPE" class="search_field search_field_typo">
					    <option value="ALL" <c:if test="${empty param.SEARCH_TYPE or param.SEARCH_TYPE eq 'ALL'}">selected="selected"</c:if>>전체</option>
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
    