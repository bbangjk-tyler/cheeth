<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty sessionInfo.user}">
  <script>
   alert(getI8nMsg("alert.plzlogin"));//'로그인 후 이용가능 합니다.'
   location.href = '/api/login/view';
</script>
</c:if>
<link type="text/css" rel="stylesheet" href="/public/assets/css/modal.css"/>

<script type="text/javascript">

	$(function() {
		fnSetPageInfo(1, 5, 5);
	});

	function fnSearch() {
		var searchTxt = $('#SEARCH_TXT').val();
		if(isEmpty(searchTxt)) {
			[...document.querySelectorAll('.faq_item_wrapper')].map(
				wrapper => { wrapper.classList.remove('hidden'); }
			);
		} else {
			var regex = /\s/gi;
			searchTxt = searchTxt.replace(regex, '');
			[...document.querySelectorAll('.faq_item_wrapper')].map(
				wrapper => {
					var title = wrapper.querySelector('span.faq_item_title').innerText.replace(regex, '');
					var content = wrapper.querySelector('p.faq_item_context_typo').innerText.replace(regex, '');
					if(title.includes(searchTxt) || content.includes(searchTxt)) {
						wrapper.classList.remove('hidden');
					} else {
						wrapper.classList.add('hidden');
					}
				}
			);
		}
	}

	function toggleContext() {
		var el = arguments[0];
		$(el).parents('.faq_item_wrapper').find('.faq_item_context').toggleClass('hidden');
	}

</script>

<div class="faq_header">
	<p class="faq_header_typo">FAQ</p>
	<div class="faq_connection_location_container">
	  <a href="/" class="faq_connection_location_typo">
	    <img class="faq_connection_location_home_button" src="/public/assets/images/connection_location_home_button_white.svg"/>
	  </a>
	  <img class="faq_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	  <div class="faq_connection_location">
	    <p class="faq_connection_location_typo_bold">FAQ</p>
	  </div>
	</div>
</div>
<div class="faq_body">
	<div class="side_menu">
		<div class="side_menu_title">
		  <p class="side_menu_title_typo">
		    전체보기
		  </p>
		</div>
		<a href="/${api}/board/list?BOARD_TYPE=NOTICE" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo">공지사항</p>    
    </a>
    <a href="/${api}/board/list?BOARD_TYPE=FAQ" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo_blue">FAQ</p>    
    </a>
    <a href="/${api}/board/list?BOARD_TYPE=QNA" class="side_menu_list">
      <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
      <p class="side_menu_list_typo">1:1게시판</p>    
    </a>
	</div>
	<div class="faq_main_container">
	  <div class="faq_search">
	    <p class="faq_search_title">자주묻는 질문</p>
	    <div class="faq_search_bar">
	      <input class="faq_search_blank" id="SEARCH_TXT" placeholder="검색어를 입력해 주세요."/>
	      <button class="faq_search_button" onclick="fnSearch();">
	        <img class="faq_search_button_icon" src="/public/assets/images/faq_search_button_icon.svg"/>
	        <p class="faq_search_button_typo">검색</p>
	      </button>
	    </div>
	  </div>
	  <div class="main_container_divider divider_without_margin"></div>
			<div class="faq_item_container">
				<div class="faq_item_wrapper">
				  <div class="faq_item">
				    <a href="javascript:void(0)" onclick="toggleContext(this);" style="width: 100%;">
				    <span class="faq_item_title">Q.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자주묻는 질문 1</span>
				    	<img class="faq_item_button_arrow" src="/public/assets/images/faq_item_button_arrow.svg" style="float: right; margin-top: 15px;"/>
				    </a>
				  </div>
				  <div class="faq_item_context hidden">
				    <p class="faq_item_context_typo">
				      민주평화통일자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다. 사회적 특수계급의 제도는 인정되지 아니하며, 어떠한 형태로도 이를 창설할 수 없다. 형사피해자는 법률이 정하는 바에 의하여 당해 사건의 재판절차에서 진술할 수 있다. 국회의원은 현행범인인 경우를 제외하고는 회기중 국회의 동의없이 체포 또는 구금되지 아니한다. 대통령은 국가의 원수이며, 외국에 대하여 국가를 대표한다. 법관이 중대한 심신상의 장해로 직무를 수행할 수 없을 때에는 법률이 정하는 바에 의하여 퇴직하게 할 수 있다
				    </p>
				  </div>
			  </div>
			  <div class="faq_item_wrapper">
				  <div class="faq_item">
				    <a href="javascript:void(0)" onclick="toggleContext(this);" style="width: 100%;">
				    <span class="faq_item_title">Q.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자주묻는 질문 2</span>
				    	<img class="faq_item_button_arrow" src="/public/assets/images/faq_item_button_arrow.svg" style="float: right; margin-top: 15px;"/>
				    </a>
				  </div>
				  <div class="faq_item_context hidden">
				    <p class="faq_item_context_typo">
				      민주평화통일자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다. 사회적 특수계급의 제도는 인정되지 아니하며, 어떠한 형태로도 이를 창설할 수 없다. 형사피해자는 법률이 정하는 바에 의하여 당해 사건의 재판절차에서 진술할 수 있다. 국회의원은 현행범인인 경우를 제외하고는 회기중 국회의 동의없이 체포 또는 구금되지 아니한다. 대통령은 국가의 원수이며, 외국에 대하여 국가를 대표한다. 법관이 중대한 심신상의 장해로 직무를 수행할 수 없을 때에는 법률이 정하는 바에 의하여 퇴직하게 할 수 있다
				    </p>
				  </div>
			  </div>
			  <div class="faq_item_wrapper">
				  <div class="faq_item">
				    <a href="javascript:void(0)" onclick="toggleContext(this);" style="width: 100%;">
				    <span class="faq_item_title">Q.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자주묻는 질문 3</span>
				    	<img class="faq_item_button_arrow" src="/public/assets/images/faq_item_button_arrow.svg" style="float: right; margin-top: 15px;"/>
				    </a>
				  </div>
				  <div class="faq_item_context hidden">
				    <p class="faq_item_context_typo">
				      민주평화통일자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다. 사회적 특수계급의 제도는 인정되지 아니하며, 어떠한 형태로도 이를 창설할 수 없다. 형사피해자는 법률이 정하는 바에 의하여 당해 사건의 재판절차에서 진술할 수 있다. 국회의원은 현행범인인 경우를 제외하고는 회기중 국회의 동의없이 체포 또는 구금되지 아니한다. 대통령은 국가의 원수이며, 외국에 대하여 국가를 대표한다. 법관이 중대한 심신상의 장해로 직무를 수행할 수 없을 때에는 법률이 정하는 바에 의하여 퇴직하게 할 수 있다
				    </p>
				  </div>
			  </div>
			  <div class="faq_item_wrapper">
				  <div class="faq_item">
				    <a href="javascript:void(0)" onclick="toggleContext(this);" style="width: 100%;">
				    <span class="faq_item_title">Q.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자주묻는 질문 4</span>
				    	<img class="faq_item_button_arrow" src="/public/assets/images/faq_item_button_arrow.svg" style="float: right; margin-top: 15px;"/>
				    </a>
				  </div>
				  <div class="faq_item_context hidden">
				    <p class="faq_item_context_typo">
				      민주평화통일자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다. 사회적 특수계급의 제도는 인정되지 아니하며, 어떠한 형태로도 이를 창설할 수 없다. 형사피해자는 법률이 정하는 바에 의하여 당해 사건의 재판절차에서 진술할 수 있다. 국회의원은 현행범인인 경우를 제외하고는 회기중 국회의 동의없이 체포 또는 구금되지 아니한다. 대통령은 국가의 원수이며, 외국에 대하여 국가를 대표한다. 법관이 중대한 심신상의 장해로 직무를 수행할 수 없을 때에는 법률이 정하는 바에 의하여 퇴직하게 할 수 있다
				    </p>
				  </div>
			  </div>
			  <div class="faq_item_wrapper">
				  <div class="faq_item">
				    <a href="javascript:void(0)" onclick="toggleContext(this);" style="width: 100%;">
				    <span class="faq_item_title">Q.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자주묻는 질문 5</span>
				    	<img class="faq_item_button_arrow" src="/public/assets/images/faq_item_button_arrow.svg" style="float: right; margin-top: 15px;"/>
				    </a>
				  </div>
				  <div class="faq_item_context hidden">
				    <p class="faq_item_context_typo">
				      민주평화통일자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다. 사회적 특수계급의 제도는 인정되지 아니하며, 어떠한 형태로도 이를 창설할 수 없다. 형사피해자는 법률이 정하는 바에 의하여 당해 사건의 재판절차에서 진술할 수 있다. 국회의원은 현행범인인 경우를 제외하고는 회기중 국회의 동의없이 체포 또는 구금되지 아니한다. 대통령은 국가의 원수이며, 외국에 대하여 국가를 대표한다. 법관이 중대한 심신상의 장해로 직무를 수행할 수 없을 때에는 법률이 정하는 바에 의하여 퇴직하게 할 수 있다
				    </p>
				  </div>
			  </div>
			</div>
	    <div class="faq_sub_container">
	    	<div class="pagination"></div>
	    </div>
	</div>
</div>