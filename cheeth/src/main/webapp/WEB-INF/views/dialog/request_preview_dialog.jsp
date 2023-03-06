<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:if test="${empty sessionInfo.user}">
  <script>
  alert(getI8nMsg("alert.plzlogin"));
   location.href = '/api/login/view';
</script>
</c:if>
<script>
	var locations = document.location.href;
	var cardArr = new Array();
	var pcurrCardObj = new Object();
	var groupCD_STR = "";
	function fnRewriteLink(){
		location.href = '/api/tribute/tribute_request?groupCd='+groupCD_STR;
	}

 	$(document).ready(function(){

		if(locations.includes("request_basket")){
			  Rewritebool = 1;
			  console.log(Rewritebool);
				$("#Rewritebtn").css("display", "block");
		}
	}); 
  function fnPreview() {

	  resetPreviewCard();
	  

	  const groupCd = arguments[0]; 
	  groupCD_STR = groupCd;
	  $.ajax({
      url: '/' + API + '/tribute/getReqInfo',
      type: 'GET',
      data: { GROUP_CD : groupCd },
      cache: false,
      async: false,
      success: function(data) {
        cardArr = data;
      }, complete: function() {
      
      }, error: function() {
      
      }
    });
	  
		var previewBodyEl = $('.rework_request_preview_dialog_body');
		previewBodyEl.find('.tribute_request_card_chip_container > div').each(function() { $(this).remove(); });
		
		var pantNm = cardArr[0].PANT_NM;
		previewBodyEl.find('.rework_request_preview_teeth_model_title_typo').text(pantNm);
		
		var html = '';
		var lang = localStorage.getItem('lang');
		var req= getI8nMsg("proj.request");
		
		
		cardArr.map((v, i) => {
			html += '<div class="p_card_chip tribute_request_card_chip' + ((i == cardArr.length - 1) ? '' : '_not') + '_selected">';
	    html += '  <p class="p_card_title tribute_request_card_chip' + ((i == cardArr.length - 1) ? '' : '_not') + '_selected_typo" onclick="setPreviewCard(this);">'+req+'&nbsp;' + (i + 1) + '</p>';
	    html += '</div>';
		});
		previewBodyEl.find('.tribute_request_card_chip_numb').before(html);
		previewBodyEl.find('.tribute_request_card_chip_numb_typo').text(cardArr.length);
		
		pcurrCardObj = cardArr[cardArr.length-1];
		setPreviewCardContent();
	}

	function fnSetBridges() {
		
		var $el = arguments[0];
		var $div = $el.prev();
		var currIndex = $('img.p_teeth_model_tooth_img').index($el);
		var currToothNum = $el.attr('class').split('img_').pop();
		
		var tabNo = pcurrCardObj.TAB_NO;
		var exceptionBridgeList = cardArr[tabNo-1]['EXCEPTION_BRIDGE'];
		
		var prevIndex = currIndex - 1;
		var nextIndex = currIndex + 1;
		if(currIndex == 0) {
			prevIndex = 8;
		} else if(currIndex == 8) {
			prevIndex = 0;
		} else if(currIndex == 16) {
			prevIndex = 24;
		} else if(currIndex == 24) {
			prevIndex = 16;
		}
		
		var $prev = $('img.p_teeth_model_tooth_img').eq(prevIndex);
		var $next = $('img.p_teeth_model_tooth_img').eq(nextIndex);
		var prevToothNum = $prev.attr('class').split('img_').pop();
		if($next.length > 0) {
			var nextToothNum = $next.attr('class').split('img_').pop();
		}
		
		var src = $el.attr('src');
		var toothNo = src.split('\/').pop().split('.')[0];

		if($prev.attr('src').includes('normal')) {
			var prevBridge = 'p_' + prevToothNum + '_' + currToothNum;
			if($('.p_bridge.' + prevBridge).length == 0) {
				prevBridge = 'p_' + currToothNum + '_' + prevToothNum;
			}
			var bridgeTarget = $('.p_bridge.' + prevBridge);
      var targetId = bridgeTarget.attr('id');
      var f = exceptionBridgeList.filter((f) => f.BRIDGE === targetId);
      if(f.length === 0) bridgeTarget.removeClass('hidden');
		}
		
		if($next.length > 0) {
			if($next.attr('src').includes('normal')) {
				var nextBridge = 'p_' + currToothNum + '_' + nextToothNum;
				var bridgeTarget = $('.p_bridge.' + nextBridge);
				var targetId = bridgeTarget.attr('id');
				var f = exceptionBridgeList.filter((f) => f.BRIDGE === targetId);
        if(f.length === 0) bridgeTarget.removeClass('hidden');
			}
		}
	}

	function setPreviewCardContent() {
		// 치식
		$('.p_teeth_model_tooth_img').each(function() {
			var $this = $(this);
			var $div = $this.prev();
			var currIndex = $('img.p_teeth_model_tooth_img').index($this);
			var currToothNum = $this.attr('class').split('p_img_').pop();
			var src = $this.attr('src');
			
			pcurrCardObj['TRIBUTE_DTL'].map(m => {
				if(src.includes(m.TOOTH_NO)) {
					
					$this.attr('src', src.replace('gray', 'normal'));
					$div.removeClass('p_teeth_model_tooth').addClass('p_teeth_model_tooth_selected');
					$div.find('p').removeClass('teeth_model_tooth_numb').addClass('teeth_model_tooth_selected_numb');

					fnSetBridges($this);
					
					var html = '';
					html += '<div class="selected_dental_preview_item">';
					html += '	 <p class="selected_dental_preview_item_typo">' + m.TOOTH_NO + '</p>';
					html += '</div>';
					
					$('.selected_dental_preview_container').append(html);
				}
			});
		});
			
		// 보철종류
		var prostheticsTypo = '';
		prostheticsTypo = Object.keys(pcurrCardObj).sort().map(m => {
			if(m.includes('SUPP_NM')) return pcurrCardObj[m];
		})
		.filter(f => f)
		.join(' - ');
		$('#p_supp_container').find('.tribute_request_preview_info_context > p').text(prostheticsTypo);
		
		// 가공방법
		var proMethNm = pcurrCardObj['PRO_METH_NM'];
		if(pcurrCardObj['PRO_METH_CD'] == 'P007') proMethNm = pcurrCardObj['PRO_METH_ETC'];
		$('#p_pro_meth_container').find('.tribute_request_preview_info_context > p').text(proMethNm);
		
		// Shade
		var shadeNm = pcurrCardObj['SHADE_NM'];
		if(pcurrCardObj['SHADE_CD'] == 'S005') shadeNm = pcurrCardObj['SHADE_ETC'];
		$('#p_shade_container').find('.tribute_request_preview_info_context > p').text(shadeNm);
		
		// 상세내용
		$('.tribute_request_preview_info_more_detail').val(pcurrCardObj['DTL_TXT']);
	
	}

	function setPreviewCard() {
		var el = arguments[0];
		var tabIndex = $('.p_card_title').index(el);
		
		if(tabIndex != (+pcurrCardObj['TAB_NO'] - 1)) {
			
			$('.p_card_chip').each(function(index) {
				if(index == tabIndex) {
					$(this).removeClass('tribute_request_card_chip_not_selected').addClass('tribute_request_card_chip_selected');
					$(this).find('p').removeClass('tribute_request_card_chip_not_selected_typo').addClass('tribute_request_card_chip_selected_typo');
				} else {
					$(this).removeClass('tribute_request_card_chip_selected').addClass('tribute_request_card_chip_not_selected');
					$(this).find('p').removeClass('tribute_request_card_chip_selected_typo').addClass('tribute_request_card_chip_not_selected_typo');
				}
			});
			
			pcurrCardObj = cardArr[tabIndex];
			resetPreviewCard();
			setPreviewCardContent();
		}
	}

	function resetPreviewCard() {
	
		var previewBodyEl = $('.rework_request_preview_dialog_body');
		
		// 치식 초기화
		$('.p_teeth_model_tooth_img').each(function() {
		  var $this = $(this);
		  $this.attr('src', $this.attr('src').replace('normal', 'gray'));
		  $this.prev().removeClass('p_teeth_model_tooth_selected').addClass('p_teeth_model_tooth');
		  $this.prev().find('p').removeClass('teeth_model_tooth_selected_numb').addClass('teeth_model_tooth_numb');
		});
		$('.p_bridge').each(function() { $(this).addClass('hidden'); });
		$('.selected_dental_preview_container').html('');
			
		// 보철종류 초기화
		$('#p_supp_container').find('.tribute_request_preview_info_context > p').text('');
			
		// 가공방법 초기화
		$('#p_pro_meth_container').find('.tribute_request_preview_info_context > p').text('');
			
		// Shade 초기화
		$('#p_shade_container').find('.tribute_request_preview_info_context > p').text('');
			
		// 상세내용 초기화
		previewBodyEl.find('.tribute_request_preview_info_more_detail').val('');
	}
  
  $(function() {
    
    
  });
  
</script>
<style>
#Rewritebtn{
    display: block;
    position: absolute;
    /* right: 8px; */
    margin-right: 10px;
    right: 26px;
    top: 108px;
    /* top: 8px; */
    background: gray;
    z-index: 9999;
    color: white!important;
    padding: 10px 10px;
}
</style>
<div class="modal fade" id="requestModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content" style="width: fit-content;">
		<button id="Rewritebtn" style="display:none" onclick="fnRewriteLink()"><spring:message code="edit" text="수정하기" /></button>
			<div class="rework_request_preview_dialog_container">
				<div class="rework_request_preview_dialog_header">
					<p class="rework_request_preview_dialog_header_typo"><spring:message code="dialog.req.previReq" text="의뢰서 미리보기" /></p>
					<a href="javascript:void(0);" data-bs-dismiss="modal">
						<img class="rework_request_preview_dialog_header_close_button" src="/public/assets/images/dialog_close_button.svg"/>
					</a>
				</div>
        <div class="rework_request_preview_dialog_body">
					<div class="rework_request_preview_teeth_model_container">
						<div class="rework_request_preview_teeth_model_title">
							<img class="rework_request_preview_teeth_model_title_icon" src="/public/assets/images/teeth_model_title_icon.svg"/>
							<p class="rework_request_preview_teeth_model_title_typo">홍길동</p>
						</div>
						<div class="rework_request_preview_teeth_model_preview_wrapper">
							<div id="11_12" class="hidden p_bridge p_one_one_one_two"></div>
							<div id="12_13" class="hidden p_bridge p_one_two_one_three"></div>
							<div id="13_14" class="hidden p_bridge p_one_three_one_four"></div>
							<div id="14_15" class="hidden p_bridge p_one_four_one_five"></div>
							<div id="15_16" class="hidden p_bridge p_one_five_one_six"></div>
							<div id="16_17" class="hidden p_bridge p_one_six_one_seven"></div>
							<div id="17_18" class="hidden p_bridge p_one_seven_one_eight"></div>
							
							<div id="11_21" class="hidden p_bridge p_one_one_two_one"></div>
							<div id="21_22" class="hidden p_bridge p_two_one_two_two"></div>
							<div id="22_23" class="hidden p_bridge p_two_two_two_three"></div>
							<div id="23_24" class="hidden p_bridge p_two_three_two_four"></div>
							<div id="24_25" class="hidden p_bridge p_two_four_two_five"></div>
							<div id="25_26" class="hidden p_bridge p_two_five_two_six"></div>
							<div id="26_27" class="hidden p_bridge p_two_six_two_seven"></div>
							<div id="27_28" class="hidden p_bridge p_two_seven_two_eight"></div>
							
							<div id="31_32" class="hidden p_bridge p_three_one_three_two"></div>
							<div id="32_33" class="hidden p_bridge p_three_two_three_three"></div>
							<div id="33_34" class="hidden p_bridge p_three_three_three_four"></div>
							<div id="34_35" class="hidden p_bridge p_three_four_three_five"></div>
							<div id="35_36" class="hidden p_bridge p_three_five_three_six"></div>
							<div id="36_37" class="hidden p_bridge p_three_six_three_seven"></div>
							<div id="37_38" class="hidden p_bridge p_three_seven_three_eight"></div>
      
							<div id="31_41" class="hidden p_bridge p_three_one_four_one"></div>
							<div id="41_42" class="hidden p_bridge p_four_one_four_two"></div>
							<div id="42_43" class="hidden p_bridge p_four_two_four_three"></div>
							<div id="43_44" class="hidden p_bridge p_four_three_four_four"></div>
							<div id="44_45" class="hidden p_bridge p_four_four_four_five"></div>
							<div id="45_46" class="hidden p_bridge p_four_five_four_six"></div>
							<div id="46_47" class="hidden p_bridge p_four_six_four_seven"></div>
							<div id="47_48" class="hidden p_bridge p_four_seven_four_eight"></div>
							
							<div class="p_teeth_model_tooth p_tooth_numb_one_one">
								<p class="teeth_model_tooth_numb">11</p>
							</div>
              <img class="p_teeth_model_tooth_img p_img_one_one" src="/public/assets/images/tooth/gray/11.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_one_two">
              	<p class="teeth_model_tooth_numb">12</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_one_two" src="/public/assets/images/tooth/gray/12.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_one_three">
                <p class="teeth_model_tooth_numb">13</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_one_three" src="/public/assets/images/tooth/gray/13.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_one_four">
                <p class="teeth_model_tooth_numb">14</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_one_four" src="/public/assets/images/tooth/gray/14.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_one_five">
                <p class="teeth_model_tooth_numb">15</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_one_five" src="/public/assets/images/tooth/gray/15.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_one_six">
                <p class="teeth_model_tooth_numb">16</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_one_six" src="/public/assets/images/tooth/gray/16.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_one_seven">
                <p class="teeth_model_tooth_numb">17</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_one_seven" src="/public/assets/images/tooth/gray/17.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_one_eight">
                <p class="teeth_model_tooth_numb">18</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_one_eight" src="/public/assets/images/tooth/gray/18.png"/>
      
              <div class="p_teeth_model_tooth p_tooth_numb_two_one">
                <p class="teeth_model_tooth_numb">21</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_two_one" src="/public/assets/images/tooth/gray/21.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_two_two">
              	<p class="teeth_model_tooth_numb">22</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_two_two" src="/public/assets/images/tooth/gray/22.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_two_three">
                <p class="teeth_model_tooth_numb">23</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_two_three" src="/public/assets/images/tooth/gray/23.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_two_four">
                <p class="teeth_model_tooth_numb">24</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_two_four" src="/public/assets/images/tooth/gray/24.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_two_five">
                <p class="teeth_model_tooth_numb">25</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_two_five" src="/public/assets/images/tooth/gray/25.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_two_six">
                <p class="teeth_model_tooth_numb">26</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_two_six" src="/public/assets/images/tooth/gray/26.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_two_seven">
                <p class="teeth_model_tooth_numb">27</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_two_seven" src="/public/assets/images/tooth/gray/27.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_two_eight">
                <p class="teeth_model_tooth_numb">28</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_two_eight" src="/public/assets/images/tooth/gray/28.png"/>
      
              <div class="p_teeth_model_tooth p_tooth_numb_three_one">
								<p class="teeth_model_tooth_numb">31</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_three_one" src="/public/assets/images/tooth/gray/31.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_three_two">
                <p class="teeth_model_tooth_numb">32</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_three_two" src="/public/assets/images/tooth/gray/32.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_three_three">
                <p class="teeth_model_tooth_numb">33</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_three_three" src="/public/assets/images/tooth/gray/33.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_three_four">
                <p class="teeth_model_tooth_numb">34</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_three_four" src="/public/assets/images/tooth/gray/34.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_three_five">
                <p class="teeth_model_tooth_numb">35</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_three_five" src="/public/assets/images/tooth/gray/35.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_three_six">
                <p class="teeth_model_tooth_numb">36</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_three_six" src="/public/assets/images/tooth/gray/36.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_three_seven">
                <p class="teeth_model_tooth_numb">37</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_three_seven" src="/public/assets/images/tooth/gray/37.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_three_eight">
                <p class="teeth_model_tooth_numb">38</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_three_eight" src="/public/assets/images/tooth/gray/38.png"/>
      
              <div class="p_teeth_model_tooth p_tooth_numb_four_one">
              	<p class="teeth_model_tooth_numb">41</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_four_one" src="/public/assets/images/tooth/gray/41.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_four_two">
                <p class="teeth_model_tooth_numb">42</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_four_two" src="/public/assets/images/tooth/gray/42.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_four_three">
                <p class="teeth_model_tooth_numb">43</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_four_three" src="/public/assets/images/tooth/gray/43.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_four_four">
                <p class="teeth_model_tooth_numb">44</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_four_four" src="/public/assets/images/tooth/gray/44.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_four_five">
                <p class="teeth_model_tooth_numb">45</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_four_five" src="/public/assets/images/tooth/gray/45.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_four_six">
                <p class="teeth_model_tooth_numb">46</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_four_six" src="/public/assets/images/tooth/gray/46.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_four_seven">
                <p class="teeth_model_tooth_numb">47</p>
              </div>
              <img class="p_teeth_model_tooth_img p_img_four_seven" src="/public/assets/images/tooth/gray/47.png"/>
              <div class="p_teeth_model_tooth p_tooth_numb_four_eight">
                <p class="teeth_model_tooth_numb">48</p>
              </div>
            	<img class="p_teeth_model_tooth_img p_img_four_eight" src="/public/assets/images/tooth/gray/48.png"/>
            </div>
          </div>
          
					<div class="tribute_request_preview_main_container">
						<div class="tribute_request_preview_card">
							<div class="dialog_tribute_request_card_chip_container tribute_request_card_chip_container">
								<button class="tribute_request_card_chip_numb">
							  	<p class="tribute_request_card_chip_numb_typo"></p>
							  </button>
							</div>
							<div class="dialog_tribute_request_preview_info_wrapper">
								<div class="tribute_request_preview_info_container">
									<div id="p_supp_container" class="tribute_request_preview_info">
									  <div class="tribute_request_preview_info_title">
									    <p class="tribute_request_preview_info_title_typo"><spring:message code="req.prosthT" text="보철 종류" /></p>
									  </div> 
									  <div class="tribute_request_preview_info_context">
									    <p class="tribute_request_preview_info_context_typo"><spring:message code="dialog.req.denture" text="의치" /></p>
									  </div>    
									</div>
									<div class="tribute_request_preview_info">
									  <div class="tribute_request_preview_info_title">
									  	<p class="tribute_request_preview_info_title_typo"><spring:message code="dialog.req.seleT" text="선택된 치식" /></p>
									  </div> 
									  <div class="tribute_request_preview_info_context">
									    <div class="selected_dental_preview_container">
									    </div>
									  </div>    
									</div>
									<div id="p_pro_meth_container" class="tribute_request_preview_info">
									  <div class="tribute_request_preview_info_title">
									  	<p class="tribute_request_preview_info_title_typo"><spring:message code="" text="가공방법" /></p>
									  </div> 
									  <div class="tribute_request_preview_info_context">
									    <p class="tribute_request_preview_info_context_typo"></p>
									  </div>    
									</div>
									<div id="p_shade_container" class="tribute_request_preview_info">
									  <div class="tribute_request_preview_info_title">
									    <p class="tribute_request_preview_info_title_typo">Shade</p>
									  </div> 
									  <div class="tribute_request_preview_info_context">
									    <p class="tribute_request_preview_info_context_typo"></p>
									  </div>    
									</div>
								</div>
								<div class="tribute_request_preview_info_more">
								  <div class="tribute_request_preview_info_more_typo"></div>
								</div>
								<img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
								<textarea class="tribute_request_preview_info_more_detail" placeholder="<spring:message code="header.about" text="상세내용" />" readonly></textarea>
              </div>
            </div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
