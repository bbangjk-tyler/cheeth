<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<script>
function getCookie(name) {
    var cookie = document.cookie;
    
    if (document.cookie != "") {
        var cookie_array = cookie.split("; ");
        for ( var index in cookie_array) {
            var cookie_name = cookie_array[index].split("=");
            
            if (cookie_name[0] == "popupYN") {
                return cookie_name[1];
            }
        }
    }
    return ;
}

/* function openPopup(url) { 
    var cookieCheck = getCookie("popupYN");
    if (cookieCheck != "N")
        window.open(url, '', 'width=450,height=750,left=0,top=0')
} */
var popupbool = 0;
function checkPopupbye(){
	if(popupbool == 0){
		popupbool = 1;
	}else{
		popupbool = 0;
	}
}
function closePopup() {
	if(popupbool == 1){
	       setCookie("popupYN", "N", 1);		
	}

} 
function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+ d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}
$(document).ready(function(){
	var lang = localStorage.getItem('lang');
	if(lang == null || lang == ""){
		lang = navigator.language;
	}
	$.ajax({
	      url: '/' + API + '/message/i18n',
	      type: 'GET',
	      data: { lang : lang },
	      cache: false,
	      async: false,
	      success: function(data) {
	    	localStorage.setItem('lang',lang);
	      },
	      error: function(err){
	    	  alert(JSON.stringify(err));
	      }
	    });
	
    var cookieCheck = getCookie("popupYN");
    if (cookieCheck != "N"){
    	$("#EventePopupBTN").trigger('click');
    }
});
jQuery(function($){

	var sect1_swiper = new Swiper('#cheesigner_swiper .swiper-container', {
		loop:true,
		slidesPerView: 'auto',
		spaceBetween: 30,
		speed:600,
		autoplay: {
			delay: 4000,
			disableOnInteraction: false,
		},
		navigation: {
			nextEl: '.main_cheesigner .swiper-button-next',
			prevEl: '.main_cheesigner .swiper-button-prev',
		},
	});

});
  var progPage = 0;
  var progCnt = toNumber('${PROG_CNT}');
  
  var curPage_Prog = 0;
  var totalPage_Prog = Math.floor(progCnt/4);
  if(progCnt%4 != 0){
	  totalPage_Prog += 1;
  }
  
  function fnSearchProg() {
    var dvsn = arguments[0];
    if(dvsn === 'next') {
      progPage += 4;
      if(curPage_Prog < totalPage_Prog){
          curPage_Prog = curPage_Prog + 1; 
          $("#prevBTN").attr("src", "/public/assets/images/main_carousel_arrow_left1.svg");
      }
      if(curPage_Prog == totalPage_Prog){
    	  
    	  $("#nextBTN").attr("src", "/public/assets/images/main_carousel_arrow_right2.svg");
      }
      

    }
    
    if(progPage > 0) {
      var limitCnt = Math.ceil(progCnt/4) * 4 - 4;
      if(progPage > limitCnt) {
        progPage -= 4;
        return;
      }
    }
    
    if(dvsn === 'prev') {
      progPage -= 4;
      if(curPage_Prog > 0){
          curPage_Prog = curPage_Prog - 1;    	  
          $("#nextBTN").attr("src", "/public/assets/images/main_carousel_arrow_right1.svg");
      }
      if(curPage_Prog == 0){
    	  console.log("change");
    	  $("#prevBTN").attr("src", "/public/assets/images/main_carousel_arrow_left2.svg");
      }
    }
    console.log(curPage_Prog);
    console.log(totalPage_Prog);
    if(progPage < 0) {
      progPage = 0;
      return;
    }
    
    $.ajax({
      url: '/' + API + '/main/getProgList',
      type: 'GET',
      data: { PROG_PAGE : toNumber(progPage) },
      cache: false,
      async: false,
      success: function(data) {
        if(isNotEmpty(data)) {
          var html = '';
          for(var i=0; i<data.length; i++) {
            html += '<div class="main_main_center_carousel_card">';
            html += '<div class="main_main_center_carousel_card_chip">';
            html += '<p class="main_main_center_carousel_card_chip_typo">' + data[i].AREA_NM + '</p>';
            html += '</div>';
            html += '<div class="main_main_center_carousel_card_title_typo">' + data[i].CENTER_NM + '</div>';
            html += '<div class="main_main_center_carousel_card_divider"></div>';
            html += '<p class="main_main_center_carousel_card_item_typo">&nbsp;' + data[i].WORK_ITEM_NM + '</p>';
            html += '<div class="main_main_center_carousel_card_item_description_typo">' + data[i].INTRO + '</div>';
            html += '</div>';
          }
          $('.main_main_center_carousel_card_container').html(html);
        }
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  var tag = document.createElement('script');
  tag.src = "https://www.youtube.com/iframe_api";
  var firstScriptTag = document.getElementsByTagName('script')[0];
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
  
  var player;
  function onYouTubeIframeAPIReady() {
    player = new YT.Player('youtube_player', {
      height : '300',
      width : '550',
      videoId : 'EJ1PTPSPuR8',
      events : {
        'onReady' : onPlayerReady,
        'onStateChange' : onPlayerStateChange
      }
    });
  }

  function onPlayerReady(event) {
	// 플레이어 자동실행 (주의: 모바일에서는 자동실행되지 않음)
    //event.target.playVideo();
  }

  var done = false;
  function onPlayerStateChange(event) {
    if(event.data == YT.PlayerState.PLAYING && !done) {
      setTimeout(stopVideo, 6000);
      done = true;
    }
  }
  
  function stopVideo() {
    player.stopVideo();
  }
  stopVideo();
  $(document).ready(function() {
    
    if(isNotEmpty('${msg}')) {
      alert('${msg}');
    }
  });
  function processingPageGo(obj){
	  var id = $(obj).attr("id");
	  location.href = ('/api/processing/processing_center_profile?PROG_NO=' + id);
  }
</script>

<div class="main_main_body">
  <div class="main_main_banner_img_wrapper">
    <img class="main_main_banner_img" src="/public/assets/images/main_banner.svg" />
    <div class="main_main_banner_button_container">
      <c:choose>
        <c:when test="${empty sessionInfo.user}">
          <a href="javascript:alert(getI8nMsg('alert.plzlogin'));" class="main_main_banner_button main_main_banner_button_01">
            <p class="main_main_banner_button_typo"><spring:message code="main.estimate" text="견적 · 의뢰 내역" /></p>
          </a>
        </c:when>
        <c:otherwise>
          <c:if test="${sessionInfo.user.USER_TYPE_CD eq 2}">
          <a href="/${api}/mypage/equipment_estimator_my_page_cad" class="main_main_banner_button main_main_banner_button_01">
            <p class="main_main_banner_button_typo"><spring:message code="main.estimate" text="나의 견적 / 의뢰 내역" /></p>
          </a>
		  </c:if>
		  <c:if test="${sessionInfo.user.USER_TYPE_CD eq 3}">
          <a href="/${api}/mypage/equipment_estimator_my_page_sent" class="main_main_banner_button main_main_banner_button_01">
            <p class="main_main_banner_button_typo"><spring:message code="main.estimate" text="나의 견적 / 의뢰 내역" /></p>
          </a>
		  </c:if>
		  <c:if test="${sessionInfo.user.USER_TYPE_CD eq 1 && !empty sessionInfo.user.COMP_FILE_CD}">
          <a href="/${api}/mypage/equipment_estimator_my_page_equipment" class="main_main_banner_button main_main_banner_button_01">
            <p class="main_main_banner_button_typo"><spring:message code="main.estimate" text="나의 견적 / 의뢰 내역" /></p>
          </a>
		  </c:if>
		  <c:if test="${sessionInfo.user.USER_TYPE_CD eq 1 && empty sessionInfo.user.COMP_FILE_CD}">
          <a href="javascript:alert(getI8nMsg('alert.enterAddInfo'));location.href=('/${api}/mypage/my_page_edit_info')" class="main_main_banner_button main_main_banner_button_01">
            <p class="main_main_banner_button_typo"><spring:message code="main.estimate" text="나의 견적 / 의뢰 내역" /></p>
          </a>
		  </c:if>
        </c:otherwise>
      </c:choose>
      
      <a href="/${api}/mypage/equipment_estimator_my_page_progress" class="main_main_banner_button main_main_banner_button_02">
        <p class="main_main_banner_button_typo"><spring:message code="main.progress" text="진행내역" /></p>
      </a>
<%--       <c:choose>
        <c:when test="${empty sessionInfo.user}">
          <a href="javascript:alert('로그인 후 이용해 주시기 바랍니다.');" class="main_main_banner_button main_main_banner_button_03">
            <p class="main_main_banner_button_typo">전자치과기공물 <br/>의뢰서 작성하기</p>
          </a>
        </c:when>
        <c:otherwise>
          <a href="/${api}/tribute/tribute_request" class="main_main_banner_button main_main_banner_button_03">
            <p class="main_main_banner_button_typo">전자치과기공물 <br/>의뢰서 작성하기</p>
          </a>
        </c:otherwise>
      </c:choose> --%>
          <a href="/${api}/tribute/tribute_request" class="main_main_banner_button main_main_banner_button_03">
            <p class="main_main_banner_button_typo"><spring:message code="main.submitreq" text="전자치과기공물 <br/>의뢰서 작성하기" /></p>
          </a>
    </div>
  </div>
  <div class="main_main_menu_list_container">
    <div class="main_main_menu_item_container" onclick="javascript:location.href='/${api}/project/project_view_all?SEARCH_PROJECT_CD=P001'">
      <img class="main_main_menu_item_img_01" src="/public/assets/images/main_menu_icon_1.png" />
      <p class="main_main_menu_item_typo"><spring:message code="main.crown" text="크라운&캡" /></p>
    </div>
    <div class="main_main_menu_item_container" onclick="javascript:location.href='/${api}/project/project_view_all?SEARCH_PROJECT_CD=P002'">
      <img class="main_main_menu_item_img_02" src="/public/assets/images/main_menu_icon_2.png" />
      <p class="main_main_menu_item_typo"><spring:message code="main.inlay" text="인레이(온레이)" /></p>
    </div>
    <div class="main_main_menu_item_container" onclick="javascript:location.href='/${api}/project/project_view_all?SEARCH_PROJECT_CD=P003'">
      <img class="main_main_menu_item_img_03" src="/public/assets/images/main_menu_icon_3.png" />
      <p class="main_main_menu_item_typo"><spring:message code="main.frame" text="프레임" /></p>
    </div>
    <div class="main_main_menu_item_container" onclick="javascript:location.href='/${api}/project/project_view_all?SEARCH_PROJECT_CD=P004'">
      <img class="main_main_menu_item_img_04" src="/public/assets/images/main_menu_icon_4.png" />
      <p class="main_main_menu_item_typo"><spring:message code="main.dentures" text="의치 및 배열" /></p>
    </div>
    <div class="main_main_menu_item_container" onclick="javascript:location.href='/${api}/project/project_view_all?SEARCH_PROJECT_CD=P005'">
      <img class="main_main_menu_item_img_05" src="/public/assets/images/main_menu_icon_5.png" />
      <p class="main_main_menu_item_typo"><spring:message code="main.splint" text="스프린트 및 서지컬 가이드" /></p>
    </div>
    <div class="main_main_menu_item_container" onclick="javascript:location.href='/${api}/project/project_view_all?SEARCH_PROJECT_CD=P006'">
      <img class="main_main_menu_item_img_06" src="/public/assets/images/main_menu_icon_6.png" />
      <p class="main_main_menu_item_typo"><spring:message code="main.aligner" text="교정" /></p>
    </div>
    <div class="main_main_menu_item_container" onclick="javascript:location.href='/${api}/project/project_view_all?SEARCH_PROJECT_CD=P007'">
      <img class="main_main_menu_item_img_07" src="/public/assets/images/main_menu_icon_7.png" />
      <p class="main_main_menu_item_typo"><spring:message code="main.abutment" text="어버트먼트" /></p>
    </div>
    <div class="main_main_menu_item_container" onclick="javascript:location.href='/${api}/project/project_view_all?SEARCH_PROJECT_CD=P008'">
      <img class="main_main_menu_item_img_08" src="/public/assets/images/main_menu_icon_8.png" />
      <p class="main_main_menu_item_typo"><spring:message code="main.etc" text="기타" /></p>
    </div>
  </div>
  <div class="main_main_divider"></div>
  <div class="main_main_center_container">
    <div class="main_main_center_title_container">
      <div class="main_main_center_left_container">
        <div class="main_main_center_title_typo"><spring:message code="main.dental" text="가공센터" /></div>
        <div class="main_main_center_carousel_button_container">
          <button type="button" class="main_main_center_carousel_button" onclick="fnSearchProg('prev');">
            <img class="main_main_center_carousel_button_img" id="prevBTN" src="/public/assets/images/main_carousel_arrow_left2.svg" />
          </button>
          <div class="main_main_center_carousel_button_divider"></div>
          <button type="button" class="main_main_center_carousel_button" onclick="fnSearchProg('next');">
            <img class="main_main_center_carousel_button_img" id="nextBTN" src="/public/assets/images/main_carousel_arrow_right1.svg" />
          </button>
        </div>
      </div>
      <p class="main_main_center_see_more_typo" style="cursor: pointer;" onclick="javascript:location.href='/${api}/processing/processing_center'"><spring:message code="main.veiw" text="지역별 보기" /> ></p>
    </div>
    <c:if test="${empty sessionInfo.user}">
    <div class="main_main_center_carousel_card_container" style="filter: blur(4px);">
    </c:if>
    <c:if test="${!empty sessionInfo.user}">
    <div class="main_main_center_carousel_card_container">
    </c:if>
      <c:forEach var="item" items="${PROG_LIST}" varStatus="status">
        <div class="main_main_center_carousel_card" id="${item.PROG_NO}" style="cursor:pointer;" onclick="processingPageGo(this)">
          <div class="main_main_center_carousel_card_chip">
            <p class="main_main_center_carousel_card_chip_typo">${item.AREA_NM}</p>
          </div>
          <div class="main_main_center_carousel_card_title_typo">${item.CENTER_NM}</div>
          <div class="main_main_center_carousel_card_divider"></div>
          <p class="main_main_center_carousel_card_item_typo">&nbsp;${item.WORK_ITEM_NM}</p>
          <div class="main_main_center_carousel_card_item_description_typo">${item.INTRO}</div>
        </div>
      </c:forEach>
    </div>
    <div class="main_main_center_carousel_background_wrapper"></div>
  </div>
</div>
<div class="main_sub_body">
</div>
<%-- 			<section class="main_cheesigner" style="margin-top:150px;margin-bottom:150px;">

				<div class="main_cheesigner_info">
					<div class="info_title">이달의 치자이너</div>
					<div class="info_text"><a href="#">모두 보기 ></a></div>

					<div class="control">
						<div class="swiper-button-prev" style="background:url('/public/assets/images/sub_banner_left_arrow.svg') no-repeat 50% 50%"></div>
						<div class="swiper-button-next" style="background:url('/public/assets/images/sub_banner_right_arrow.svg') no-repeat 50% 50%"></div>
					</div>

				</div>

				<div id="cheesigner_swiper" <c:if test="${empty sessionInfo.user}">style="filter: blur(4px);"</c:if>>
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<a href="#">
									<div class="inner_level">크라운</div>
									<div class="inner_name">sunny88</div>
									<dl class="inner_data">
										<dt>이번달 만족도</dt>
										<dd class="data1">80 <sub>%</sub></dd>
										<dt>이번달 거래 총 금액</dt>
										<dd class="data2">250 <sub>만원</sub></dd>
									</dl>
									<div class="inner_text">국민경제자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다. </div>
								</a>
							</div>
							<div class="swiper-slide">
								<a href="#">
									<div class="inner_level">크라운</div>
									<div class="inner_name">sunny88</div>
									<dl class="inner_data">
										<dt>이번달 만족도</dt>
										<dd class="data1">80 <sub>%</sub></dd>
										<dt>이번달 거래 총 금액</dt>
										<dd class="data2">250 <sub>만원</sub></dd>
									</dl>
									<div class="inner_text">국민경제자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다. </div>
								</a>
							</div>
							<div class="swiper-slide">
								<a href="#">
									<div class="inner_level">크라운</div>
									<div class="inner_name">sunny88</div>
									<dl class="inner_data">
										<dt>이번달 만족도</dt>
										<dd class="data1">80 <sub>%</sub></dd>
										<dt>이번달 거래 총 금액</dt>
										<dd class="data2">250 <sub>만원</sub></dd>
									</dl>
									<div class="inner_text">국민경제자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다. </div>
								</a>
							</div>
							<div class="swiper-slide">
								<a href="#">
									<div class="inner_level">크라운</div>
									<div class="inner_name">sunny88</div>
									<dl class="inner_data">
										<dt>이번달 만족도</dt>
										<dd class="data1">80 <sub>%</sub></dd>
										<dt>이번달 거래 총 금액</dt>
										<dd class="data2">250 <sub>만원</sub></dd>
									</dl>
									<div class="inner_text">국민경제자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다. </div>
								</a>
							</div>
							<div class="swiper-slide">
								<a href="#">
									<div class="inner_level">크라운</div>
									<div class="inner_name">sunny88</div>
									<dl class="inner_data">
										<dt>이번달 만족도</dt>
										<dd class="data1">80 <sub>%</sub></dd>
										<dt>이번달 거래 총 금액</dt>
										<dd class="data2">250 <sub>만원</sub></dd>
									</dl>
									<div class="inner_text">국민경제자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다. </div>
								</a>
							</div>
							<div class="swiper-slide">
								<a href="#">
									<div class="inner_level">크라운</div>
									<div class="inner_name">sunny88</div>
									<dl class="inner_data">
										<dt>이번달 만족도</dt>
										<dd class="data1">80 <sub>%</sub></dd>
										<dt>이번달 거래 총 금액</dt>
										<dd class="data2">250 <sub>만원</sub></dd>
									</dl>
									<div class="inner_text">국민경제자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다. </div>
								</a>
							</div>
						</div>
					</div>
				</div>

			</section> --%>

<div class="main_footer_body">
  <div class="main_footer_body_header">
    <div class="main_footer_body_typo_container">
      <p class="main_footer_body_header_typo"><spring:message code="main.dentalequipm" text="치과/치과기공 장비 견적소" /></p>
      <a href="/${api}/equipment/equipment_estimator_list">
      	<p class="main_footer_body_header_see_all"><spring:message code="main.viewall" text="모두보기" /> ></p>
      </a>
    </div>
    <c:if test="${empty sessionInfo.user}">
    <div class="main_footer_body_item_container" style="filter: blur(4px);">
    </c:if>
    <c:if test="${!empty sessionInfo.user}">
    <div class="main_footer_body_item_container">
    </c:if>
      <a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=E001" class="main_footer_body_item">
        <p class="main_footer_body_item_typo"><spring:message code="main.3dprinter" text="3D프린터" /></p>
      </a>
      <a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=E002" class="main_footer_body_item">
        <p class="main_footer_body_item_typo"><spring:message code="main.milling" text="밀링머신" /></p>
      </a>
      <a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=E003" class="main_footer_body_item">
        <p class="main_footer_body_item_typo"><spring:message code="main.furness" text="퍼네스" /></p>
      </a>
      <a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=E004" class="main_footer_body_item">
        <p class="main_footer_body_item_typo"><spring:message code="main.scanner" text="스캐너" /></p>
      </a>
      <a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=E005" class="main_footer_body_item">
        <p class="main_footer_body_item_typo"><spring:message code="main.polishing" text="폴리싱장비" /></p>
      </a>  
    </div>
    <c:if test="${empty sessionInfo.user}">
    <div class="main_footer_body_item_container" style="filter: blur(4px);">
    </c:if>
    <c:if test="${!empty sessionInfo.user}">
    <div class="main_footer_body_item_container">
    </c:if>
      <a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=E006" class="main_footer_body_item">
        <p class="main_footer_body_item_typo"><spring:message code="main.sw" text="S/W" /></p>
      </a>
      <a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=E007" class="main_footer_body_item">
        <p class="main_footer_body_item_typo"><spring:message code="main.steam" text="스팀기" /></p>
      </a>
      <a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=E008" class="main_footer_body_item">
        <p class="main_footer_body_item_typo"><spring:message code="main.casting" text="캐스팅머신" /></p>
      </a>
      <a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=E009" class="main_footer_body_item">
        <p class="main_footer_body_item_typo"><spring:message code="main.curing" text="큐링장비" /></p>
      </a>
      <a href="/${api}/equipment/equipment_estimator_list?SEARCH_EQ_CD=E010" class="main_footer_body_item">
        <p class="main_footer_body_item_typo"><spring:message code="main.etc" text="기타" /></p>
      </a>  
    </div>
    <div class="main_footer_body_divider"></div>
  </div>

  <div class="main_project_youtube_container">
    <div class="main_project">
        <p class="main_project_typo"><spring:message code="main.project" text="Project 현황" /></p>
        <div class="main_project_box">
          <div class="main_project_box_item">
            <img class="main_project_box_item_img" src="/public/assets/images/main_project_1.svg" />
            <p class="main_project_box_item_main_typo">${PJT.USER_CNT}</p>
            <p class="main_project_box_item_sub_typo"><spring:message code="main.membernum" text="회원가입 수" /></p>
          </div>
          <div class="main_project_box_item">
            <img class="main_project_box_item_img" src="/public/assets/images/main_project_2.svg" />
            <p class="main_project_box_item_main_typo">${PJT.PJT_CNT}</p>
            <p class="main_project_box_item_sub_typo"><spring:message code="main.totproj" text="등록된 총 프로젝트 수" /></p>
          </div>
          <div class="main_project_box_item">
            <img class="main_project_box_item_img" src="/public/assets/images/main_project_3.svg" />
            <p class="main_project_box_item_main_typo">${PJT.PJT_AMOUNT}</p>
            <p class="main_project_box_item_sub_typo"><spring:message code="main.cumproj" text="누적 프로젝트 총 금액" /></p>
          </div>
        </div>
      </div>
    <div class="main_youtube">
      <p class="main_project_youtube_typo">Youtube</p>
      <div class="main_youtube_box" id="youtube_player"> </div>
    </div>
  </div>
  <div class="main_partners">
    <p class="main_partners_typo">Partners</p>
    <div class="main_partners_box_container">
      <div class="main_partners_box"></div>
      <div class="main_partners_box"></div>
      <div class="main_partners_box"></div>
      <div class="main_partners_box"></div>
      <div class="main_partners_box"></div>
    </div>
  </div>
</div>
<button id="EventePopupBTN" type="button" class="btn btn-primary" style="display:none;" data-bs-toggle="modal" data-bs-target="#exampleModal"></button>
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body" style="padding:0">
        <img style="width:100%;" src="/public/assets/images/popup.jpg">
      </div>
      <div class="modal-footer" style="background-color:#FFF3F4;justify-content:normal;height: 49px;">
      <div class="form-check" style="margin-top: -7px;">
		  <input class="form-check-input" type="checkbox" value="" onclick="checkPopupbye()" id="flexCheckDefault" style="margin-top:3px;margin-left:-2px;">
		  <label class="form-check-label" for="flexCheckDefault">
		   	 <spring:message code="pop.today" text="오늘하루 열지 않기" />
		  </label>
		</div>
 
        <!-- <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color:black!important;backtround-color:#FFF3F4;">오늘하루 열지 않기</button> --><!-- onclick="closePopup()" -->
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal" onclick="closePopup()" style="margin-top: -7px;color:black!important;background-color:#FFF3F4!important;float:right;margin-left:204px;border-color:#FFF3F4!important;"><spring:message code="close" text="닫기" /> X</button>
      </div>
    </div>
  </div>
</div>
<style>
.form-check-input:checked[type=checkbox]{
	background-image:none;
}
</style>