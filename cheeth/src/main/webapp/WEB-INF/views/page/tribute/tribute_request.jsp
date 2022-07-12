<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<%-- <c:if test="${sessionInfo.user.USER_TYPE_CD eq 2 and not empty sessionInfo.user.COMP_FILE_CD}">
  <script>
   alert('접근 권한이 없습니다.');
   history.back();
</script>
</c:if> --%>
<script>
function confirmModal() {
	  if (window.confirm("\n 해당 서비스를 이용하려면 추가정보 입력이 필요합니다. \n \n입력창으로 가시겠습니까?")) {
	    location.href = ('/api/mypage/my_page_edit_info');
	  } else {
		history.back();	  
	  }
	}
</script>
<c:choose>
	<c:when test="${sessionInfo.user.USER_TYPE_CD eq 2 and not empty sessionInfo.user.COMP_FILE_CD}">
	</c:when>
	<c:when test="${sessionInfo.user.USER_TYPE_CD eq 2 and empty sessionInfo.user.COMP_FILE_CD}">
		<script>
		confirmModal();
		</script>
	</c:when>
<c:otherwise>
 <script>
 alert("의뢰인 회원만 이용 가능합니다.");
   history.back();
</script>
</c:otherwise>
</c:choose>
	
<link type="text/css" rel="stylesheet" href="/public/assets/css/modal.css"/>

<style>
	.teeth_model_title_typo::placeholder {
		color: #a5a0a0;
	}
	
	.dropbox_select_button_item_large:hover,
	.dropbox_select_button_item:hover {
		cursor: pointer;
	}
</style>
<button id="tribute_request_button_displaynone" href="#prostheticsModal" style="display:none;" data-bs-toggle="modal"></button>
<script>
	var CategoryChoiceBool = 0;
	function CategoryChkBtn(){
		if(CategoryChoiceBool == 0){
			alert("보철종류 입력이 필요합니다.");
			
			$("#tribute_request_button_displaynone").trigger("click");
		}
	}
	var justonebool = 0;
	var topbool = 0;
	var bottombool = 0;
	
	const MAX_CARD_CNT = 6;
	var cardArr = new Array();
	var currCardObj = new Object();
	var pcurrCardObj = new Object();

	const suppCodeArr = fnGetSuppCd();
	const suppObj = new Object();
	
	var oftenWordModal;
	
	const uploadPath = commonCreateRandomKey();
	const fileCd = '${FILE_CD}';
	const fileDiv = 'TRIBUTE';

	/* shift 키 start */
	var preClcikToothNum = 0;
	var shiftbool = 0;
	$(document).ready(function() {
		$("body").attr("onkeydown", "shiftKeyDown(event)");
		$("body").attr("onkeyup", "shiftKeyUp(event)");
	});
	
	function shiftKeyDown(e){
/* 		  alert(
		    "Key Pressed: " + String.fromCharCode(e.charCode) + "\n"
		    + "charCode: " + e.charCode + "\n"
		    + "SHIFT key pressed: " + e.shiftKey + "\n"
		    + "ALT key pressed: " + e.altKey + "\n"
		  );  */
		  if(e.shiftKey == true){
			  shiftbool = 1;
		  } 
		  
		}
	function shiftKeyUp(e){
		if(shiftbool == 1){
			shiftbool = 0;
		} 
		
	}
	/* shift 키 end */
	$(function() {
		
		currCardObj['TAB_NO'] = cardArr.length + 1;
		currCardObj['TRIBUTE_DTL'] = new Array();
		currCardObj['EXCEPTION_BRIDGE'] = new Array();
		cardArr.push({...currCardObj});
		//currCardObj['BRIDGE'] = new Array();
		//currCardObj['SUPP'] = new Object();
		//currCardObj['PRO_METH'] = new Object();
		//currCardObj['SHADE'] = new Object();
		//currCardObj['DTL_TXT'] = '';
		
		const container = document.querySelector('div.dropbox_tribute_request_prosthetics_select_button_container');
		const itemContainer = container.querySelector('div.dropbox_select_button_item_container');
		
		suppCodeArr
		.filter(f => f.LVL == 1)
		.map(m => {
			var html = '<div class="dropbox_select_button_item_large" onclick="fnSelect(\'' + m.SUPP_CD + '\', \'' + m.SUPP_NM + '\');">';
			html += '			<p class="dropbox_select_button_item_typo">' + m.SUPP_NM + '</p>';
			html += '		</div>';
			itemContainer.insertAdjacentHTML('beforeend', html);
		});
		
		var prostheticsModalEl = document.getElementById('prostheticsModal');
		prostheticsModalEl.addEventListener('hidden.bs.modal', function(e) {
			[...container.querySelectorAll('.dropbox_select_button_item_container')].map(
				m => {
					m.classList.add('hidden');
					m.innerHTML = '';
					m.previousElementSibling.classList.remove('dropbox_select_button_inactive');
					m.previousElementSibling.querySelector('p').textContent = '선택';
				}
			);
			
			suppCodeArr
			.filter(f => f.LVL == 1)
			.map(m => {
				var html = '<div class="dropbox_select_button_item_large" onclick="fnSelect(\'' + m.SUPP_CD + '\', \'' + m.SUPP_NM + '\');">';
				html += '			<p class="dropbox_select_button_item_typo">' + m.SUPP_NM + '</p>';
				html += '		</div>';
				itemContainer.insertAdjacentHTML('beforeend', html);
			});
			
			document.querySelector('.prosthetics_select_etc_container').classList.add('hidden');
			[...document.querySelector('.prosthetics_select_etc_container').querySelectorAll('input[id^=ETC_SUPP_NM]')].map(
				m => { m.value = ''; }
			);
			
			/* $('input[id^=SUPP_CD]').each(function() {
			 	console.log('id : ' + $(this).attr('id') + ', val : ' + $(this).val());
			});
			$('input[id^=SUPP_NM]').each(function() {
			 	console.log('id : ' + $(this).attr('id') + ', val : ' + $(this).val());
			}); */
		});
		
		oftenWordModal = new bootstrap.Modal(document.getElementById('oftenWordModal'));
		
		var oftenWordModalEl = document.getElementById('oftenWordModal');
		oftenWordModalEl.addEventListener('hidden.bs.modal', function(e) {
			document.getElementById('WORD_TXT').value = '';
		});
		
		/* 클릭 */
		$('.teeth_model_tooth_img').click(function(e) {
			if(CategoryChoiceBool == 1){
			var isTrusted = e?.originalEvent?.isTrusted;

			var $el = $(this);
			var $div = $el.prev();
			var currIndex = $('img.teeth_model_tooth_img').index($el);
			var currToothNum = $el.attr('class').split('img_').pop();
			var tabNo = currCardObj.TAB_NO;
			
			var curClcikToothNum = $el.attr("toothNum");
			
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
			

			var $prev = $('img.teeth_model_tooth_img').eq(prevIndex);
			var $next = $('img.teeth_model_tooth_img').eq(nextIndex);
			var prevToothNum = $prev.attr('class').split('img_').pop();
			if($next.length > 0) {
				var nextToothNum = $next.attr('class').split('img_').pop();
			}
			
			var src = $el.attr('src');
			var toothNo = src.split('\/').pop().split('.')[0];
			
			curClcikToothNum *=1;
			
			/* shift 추가 */
			if(shiftbool == 1){
				if(preClcikToothNum != 0){
					var fc = 0;
					var lc = 0;
					preClcikToothNum *= 1;
					curClcikToothNum *= 1;
					var flag22 = 0;
					if(preClcikToothNum < curClcikToothNum){
						fc = preClcikToothNum;
						lc = curClcikToothNum;
					}else{
						fc = curClcikToothNum;
						lc = preClcikToothNum;
						if(curClcikToothNum != preClcikToothNum){
							flag22 = 1;							
						}

					}
					fc *= 1;
					lc *= 1;

					if(flag22 == 1){
						var k = lc - 1;
					
					$prevobj = $(".teeth_model_wrapper").find("img[toothNum='" + k + "']");
					$el3 = $(".teeth_model_wrapper").find("img[toothNum='" + lc + "']");
					
					var pevtooth_index = $prevobj.attr("toothindex");
					var curtooth_index = $el3.attr("toothindex");
						
					 var prevBridge2 = pevtooth_index + '_' + curtooth_index;
					 if($("#" + prevBridge2).length == 0) {
					  prevBridge2 = curtooth_index + '_' + pevtooth_index;
					  }
					 var bridgeTarget = $('#' + prevBridge2);
					
					 //var targetId = bridgeTarget.attr('id');
					 bridgeTarget.removeClass('hidden');
					}
					for(var i = fc+1; i < lc+1;i++){ // 치아 색 바꾸는 부분
						$el2 = $(".teeth_model_wrapper").find("img[toothNum='" + i + "']");

						var src2 = $el2.attr('src');
						var toothNo = i;
						var $div2 = $el2.prev();
						//var $prev2 = ;
						if(src2.includes('blue')) {
							continue;
						}
						if(src2.includes('normal')) {
							src2 = src2.replace('normal', 'blue');
					        $div2.removeClass('teeth_model_tooth').addClass('teeth_model_tooth_selected');
					        $div2.find('p').removeClass('teeth_model_tooth_numb').addClass('teeth_model_tooth_selected_numb');
						
 				        //if($prev2.attr('src').includes('blue')) {
 				        	// 브릿지 start
 				        	// toothindex
 				        	var j = i-1;
 				        	$prevobj = $(".teeth_model_wrapper").find("img[toothNum='" + j + "']");
 				        	var pevtooth_index = $prevobj.attr("toothindex");
 				        	var curtooth_index = $el2.attr("toothindex");
 				        	
				          var prevBridge2 = pevtooth_index + '_' + curtooth_index;
				          if($("#" + prevBridge2).length == 0) {
				        	  prevBridge2 = curtooth_index + '_' + pevtooth_index;
					          }
				          var bridgeTarget = $('#' + prevBridge2);

				          //var targetId = bridgeTarget.attr('id');
				          bridgeTarget.removeClass('hidden');
				          // 브릿지 end
					    var classStr = $el2.attr("class");
					    classStr = classStr.replace("teeth_model_tooth_img img_","");
				        var html = '';
						html += '<div class="selected_dental_item_non_bridge" data-number="' + classStr + '">';
						html += '	<p class="selected_dental_item_non_bridge_typo">' + $div2.find('p').text() + '</p>';
						html += '	<img class="selected_dental_close_button" src="/public/assets/images/selected_dental_close_button.svg" onclick="removeTooth(this);" style="cursor: pointer;" />';
						html += '</div>';
						
						$('.selected_dental_container').append(html);
						}
						$el2.attr('src', src2);
					}
					
				}
			}

			/* shift 끝 */
			if(src.includes('normal')) {
		        src = src.replace('normal', 'blue');
		        $div.removeClass('teeth_model_tooth').addClass('teeth_model_tooth_selected');
		        $div.find('p').removeClass('teeth_model_tooth_numb').addClass('teeth_model_tooth_selected_numb');
		        
		        if($prev.attr('src').includes('blue')) {
		          var prevBridge = prevToothNum + '_' + currToothNum;
		          if($('.bridge.' + prevBridge).length == 0) {
		            prevBridge = currToothNum + '_' + prevToothNum;
		          }
		          var bridgeTarget = $('.bridge.' + prevBridge);
		          var targetId = bridgeTarget.attr('id');
		          
		          if(isTrusted) {
		            var index = cardArr[tabNo-1]['EXCEPTION_BRIDGE'].findIndex(f => f === targetId);
		            if(index > -1) cardArr[tabNo-1]['EXCEPTION_BRIDGE'].splice(index, 1);
		          }
		          
		          var f = cardArr[tabNo-1]['EXCEPTION_BRIDGE'].filter((f) => f === targetId);
		          if(f.length === 0) bridgeTarget.removeClass('hidden');
		        }
		        
		        if($next.length > 0) {
		          if($next.attr('src').includes('blue')) {
		            var nextBridge = currToothNum + '_' + nextToothNum;
		            var bridgeTarget = $('.bridge.' + nextBridge);
		            var targetId = bridgeTarget.attr('id');
		            
		            if(isTrusted) {
		              var index = cardArr[tabNo-1]['EXCEPTION_BRIDGE'].findIndex(f => f === targetId);
		              if(index > -1) cardArr[tabNo-1]['EXCEPTION_BRIDGE'].splice(index, 1);
		            }
		            var f = cardArr[tabNo-1]['EXCEPTION_BRIDGE'].filter((f) => f === targetId);
		            if(f.length === 0) bridgeTarget.removeClass('hidden');
		          }
		        }
		        
		        if($('.selected_dental_container').hasClass('hidden')) {
		          $('.selected_dental_container').removeClass('hidden');
		          $('.tribute_request_info_selected_dental_blank_typo').addClass('hidden');
		        }
			
			var html = '';
			if($("div[data-number='" + currToothNum + "']").length == 0){
				html += '<div class="selected_dental_item_non_bridge" data-number="' + currToothNum + '">';
				html += '	<p class="selected_dental_item_non_bridge_typo">' + $div.find('p').text() + '</p>';
				html += '	<img class="selected_dental_close_button" src="/public/assets/images/selected_dental_close_button.svg" onclick="removeTooth(this);" style="cursor: pointer;" />';
				html += '</div>';
			}
			$('.selected_dental_container').append(html);
			
		} else if(src.includes('blue')) {
			if(shiftbool != 1){/* 추가 */
				src = src.replace('blue', 'normal');
				$div.removeClass('teeth_model_tooth_selected').addClass('teeth_model_tooth');
				$div.find('p').removeClass('teeth_model_tooth_selected_numb').addClass('teeth_model_tooth_numb');
				
				var prevBridge = prevToothNum + '_' + currToothNum;
				if($('.bridge.' + prevBridge).length == 0) {
					prevBridge = currToothNum + '_' + prevToothNum;
				}
				$('.bridge.' + prevBridge).addClass('hidden');
					
				var nextBridge = currToothNum + '_' + nextToothNum;
				$('.bridge.' + nextBridge).addClass('hidden');
				
				$('.selected_dental_container').find('div[data-number=' + currToothNum + ']').remove();
				
				if($('.selected_dental_container').find('div').length == 0) {
					$('.selected_dental_container').addClass('hidden');
					$('.tribute_request_info_selected_dental_blank_typo').removeClass('hidden');
				}
			}
		}
		$el.attr('src', src);
		console.log("preClcikToothNum " + preClcikToothNum);
		console.log("curClcikToothNum " + curClcikToothNum);
		if(preClcikToothNum != curClcikToothNum){
			preClcikToothNum = curClcikToothNum;				
		}else{
			if(src.includes('blue')){
				
			}else{
				preClcikToothNum = 0;
			}
			
		}
			}
			/* 위 아래 중 하나만 */
			if(justonebool == 1){
				if(curClcikToothNum < 17){
					
					if($(".selected_dental_container").children().length > 0){
						$("#bottom_div").css("display", "block");
						$("#bottom_div").css("filter", "blur(8px)");
						$("#bottom_div").css("opacity", "80%");
						$("#bottom_div").css("background-color", "gray");
						topbool = 1;
					}else{
						topbool = 0;
					
						$("#bottom_div").css("display", "none");
						$("#top_div").css("display", "none");
					}
				}else{
					
					if($(".selected_dental_container").children().length > 0){
						$("#top_div").css("display", "block");
						$("#top_div").css("filter", "blur(8px)");
						$("#top_div").css("opacity", "80%");
						$("#top_div").css("background-color", "gray");
						bottombool = 1;
					}else{
						$("#bottom_div").css("display", "none");
						$("#top_div").css("display", "none");		
						bottombool = 0;
					}
				}
			}
		});
		
		
    // 브릿지 클릭
    $('.bridge').click(function() {
      var tabNo = currCardObj.TAB_NO;
    	var target = $(this);
      var targetId = this.id;
      if(!target.hasClass('hidden')) {
        target.addClass('hidden');
        var s = cardArr[tabNo-1]['EXCEPTION_BRIDGE'].some(s => s === targetId);
        if(!s) {
          cardArr[tabNo-1]['EXCEPTION_BRIDGE'].push(targetId);
        }
      }
    });
    
	});
	
	function fnSetPantNm() {
		var input = arguments[0];
		var pantNm = $(input).val();
		cardArr.map(m => {
			m.PANT_NM = pantNm;
		});
	}
	
	function setCardTitle() {
		var el = arguments[0];
		var pantNm = $(el).val();
		$('.card_title').text(pantNm + ' 의뢰서');
	}
	
	function addCard() {
		
		const cardCnt = $('.card_chip').length;
		if(cardCnt == MAX_CARD_CNT) return;
		
		$('.card_chip').each(function() {
			$(this).removeClass('tribute_request_card_chip_selected').addClass('tribute_request_card_chip_not_selected');
			$(this).find('p').removeClass('tribute_request_card_chip_selected_typo').addClass('tribute_request_card_chip_not_selected_typo');
		});
		
		var html = '';
		html += '<div class="tribute_request_card_chip_selected card_chip">';
	  html += '  <p class="tribute_request_card_chip_selected_typo card_title" onclick="setCard(this);">의뢰서&nbsp;' + (cardCnt + 1) + '</p>';
	  html += '  <img class="tribute_request_card_chip_close_button" src="/public/assets/images/tribute_request_card_chip_close_button.svg" onclick="deleteCard();"/>';
	  html += '</div>';
	  $('.card_chip:last').after(html);
	  
	  saveCard();
    currCardObj = { 'TAB_NO' : cardArr.length + 1,
                    'TRIBUTE_DTL' : new Array(),
                    'EXCEPTION_BRIDGE' : new Array()
                  };
	  cardArr.push({...currCardObj});
	  
	  resetCard();
	}
	
	function saveCard() {
		
		currCardObj['PANT_NM'] = $('#PANT_NM').val();
		currCardObj['FILE_CD'] = fileCd;
		
		currCardObj['TRIBUTE_DTL'] = [];
		$('.selected_dental_container > div').each(function() {
	  	currCardObj['TRIBUTE_DTL'].push($(this).find('p').text());
		});
		
		currCardObj['BRIDGES'] = [];
		$('.bridge').each(function() {
			if(!$(this).hasClass('hidden')) {
				var bridgeId = $(this).attr('class').split('bridge').filter(f => f).pop().trim();
				currCardObj['BRIDGES'].push(bridgeId);
			}
		});
		
		currCardObj['PRO_METH_CD'] = $('input[id=PRO_METH_CD]').val();
		currCardObj['PRO_METH_NM'] = $('#pro_meth_container').find('.dropbox_select_button_typo').text();
		currCardObj['PRO_METH_ETC'] = $('input[id=PRO_METH_ETC]').val();
		if(currCardObj['PRO_METH_NM'] == '선택') {
			currCardObj['PRO_METH_NM'] = '';
		}
		
		currCardObj['SHADE_CD'] = $('input[id=SHADE_CD]').val();
		currCardObj['SHADE_NM'] = $('#shade_container').find('.dropbox_select_button_typo').text();
		currCardObj['SHADE_ETC'] = $('input[id=SHADE_ETC]').val();
		if(currCardObj['SHADE_NM'] == '선택') {
			currCardObj['SHADE_NM'] = '';
		}
		
		currCardObj['DTL_TXT'] = $('textarea[id=DTL_TXT]').val();
		
		currCardObj['EXCEPTION_BRIDGE'] = cardArr[+currCardObj['TAB_NO'] - 1]['EXCEPTION_BRIDGE'];
		
		cardArr[+currCardObj['TAB_NO'] - 1] = {...currCardObj};
	}
	
	function setCard() {
		var el = arguments[0];
		var tabIndex = $('.card_title').index(el);
		
		if(tabIndex != (+currCardObj['TAB_NO'] - 1)) {
			
			$('.card_chip').each(function(index) {
				if(index == tabIndex) {
					$(this).removeClass('tribute_request_card_chip_not_selected').addClass('tribute_request_card_chip_selected');
					$(this).find('p').removeClass('tribute_request_card_chip_not_selected_typo').addClass('tribute_request_card_chip_selected_typo');
				} else {
					$(this).removeClass('tribute_request_card_chip_selected').addClass('tribute_request_card_chip_not_selected');
					$(this).find('p').removeClass('tribute_request_card_chip_selected_typo').addClass('tribute_request_card_chip_not_selected_typo');
				}
			});
			
			/* if(isNotEmpty(cardArr[+currCardObj['TAB_NO'] - 1])) {
				saveCard();
			} */
			
			if(cardArr.some(s => s.TAB_NO == currCardObj.TAB_NO)) {
				saveCard();
			}
			currCardObj = {...cardArr[tabIndex]};
			resetCard();
			
			// 치식
			$('.teeth_model_tooth_img').each(function() {
				var $this = $(this);
				currCardObj['TRIBUTE_DTL'].map(m => {
					if($this.attr('src').includes(m)) {
						$this.trigger('click');
					}
				});
			});
			
			
			// 브릿지 예외처리
// 			currCardObj['EXCEPTION_BRIDGE'].map(m => {
// 				var a = $('#' + m);
// 				console.log('a', a);
// 			});
			
			
			// 보철종류
			var prostheticsTypo ='보철 종류를 선택해 주세요.';
			if(isNotEmpty(currCardObj['SUPP_INFO'])) {
				prostheticsTypo = Object.keys(currCardObj['SUPP_INFO']).map(
					m => {
						document.getElementById(m).value = currCardObj['SUPP_INFO'][m];
						if(m.includes('SUPP_NM')) return currCardObj['SUPP_INFO'][m];
				})
				.filter(f => f)
				.join(' - ');
			}
			document.querySelector('.tribute_request_info_prosthetics_blank_typo').textContent = prostheticsTypo;
			
			// 가공방법
			if(isNotEmpty(currCardObj['PRO_METH_CD'])) {
				fnSelect(currCardObj['PRO_METH_CD'], currCardObj['PRO_METH_NM'], 'pro_meth_container');
				if(currCardObj['PRO_METH_CD'] == 'P007') {
					$('input[id=PRO_METH_ETC]').val(currCardObj['PRO_METH_ETC']);
				}
			}
			
			// Shade
			if(isNotEmpty(currCardObj['SHADE_CD'])) {
				fnSelect(currCardObj['SHADE_CD'], currCardObj['SHADE_NM'], 'shade_container');
				if(currCardObj['SHADE_CD'] == 'S005') {
					$('input[id=SHADE_ETC]').val(currCardObj['SHADE_ETC']);
				}
			}
			
			// 상세내용
			$('textarea[id=DTL_TXT]').val(currCardObj['DTL_TXT']);
		}
	}
	
	function resetCard() {
		// 치식 초기화
		$('.teeth_model_tooth_img').each(function() {
		  var $this = $(this);
		  $this.attr('src', $this.attr('src').replace('blue', 'normal'));
		  $this.prev().removeClass('teeth_model_tooth_selected').addClass('teeth_model_tooth');
		  $this.prev().find('p').removeClass('teeth_model_tooth_selected_numb').addClass('teeth_model_tooth_numb');
		});
		$('.bridge').each(function() { $(this).addClass('hidden'); });
		$('.selected_dental_container').addClass('hidden');
		$('.selected_dental_container').html('');
		$('.tribute_request_info_selected_dental_blank_typo').removeClass('hidden');
			
		// 보철종류 초기화
		document.querySelector('.tribute_request_info_prosthetics_blank_typo').textContent = '보철 종류를 선택해 주세요.';
		[...document.querySelectorAll('input[id^=SUPP_CD], input[id^=SUPP_NM]')].map(m => { m.value = ''; });
			
		// 가공방법 초기화
		$('#pro_meth_container').find('.dropbox_select_button_typo').text('선택');
		$('#pro_meth_container').find('.tribute_request_info_blank').removeClass('hidden');
		$('#pro_meth_container').find('.tribute_request_info_blank_typo').text('');
		$('#pro_meth_container').find('.tribute_request_direct_input_container').addClass('hidden');
		$('input[id^=PRO_METH]').val('');
			
		// Shade 초기화
		$('#shade_container').find('.dropbox_select_button_typo').text('선택');
		$('#shade_container').find('.tribute_request_direct_input_container').addClass('hidden');
		$('input[id^=SHADE]').val('');
			
		// 상세내용 초기화
		$('textarea[id=DTL_TXT]').val('');
	}
	
	function deleteCard() {
		if($('.card_chip').length == 1) return;
		
		var cardChipEl = $(event.target).parent();
		var tabIndex = $('.card_chip').index(cardChipEl);

		cardChipEl.remove();
		
		$('.card_title').each(function(index) {
			$(this).text('의뢰서 ' + (index + 1));
		});
		
		cardArr.splice(tabIndex, 1);
		
		if((tabIndex + 1) == currCardObj['TAB_NO']) {
			$('.card_title').eq(tabIndex - 1).trigger('click');
		}

		cardArr.map((card, index) => {
			if(card['TAB_NO'] == currCardObj['TAB_NO']) {
				currCardObj['TAB_NO'] = index + 1;
			}
			card['TAB_NO'] = index + 1;
		});
	}
	
	function removeTooth() {
		var el = arguments[0];
		var $div = $(el).parent();
		$('img.img_' + $div.data('number')).trigger('click');
		$div.remove();
	}
	
	function fnSelect() {
		if(!$(arguments[0]).hasClass('dropbox_select_button_inactive')) {
		  var code = arguments[0];
		  var codeNm = arguments[1];
		  var div = arguments[2];
		  var target;
		
		  if(isObjectType(code) != 'String') {
		  	target = $(arguments[0]).next();
		  } else {
				target = $(event.target).parents('div.dropbox_select_button_item_container');
		  }
		  
		  if(target.hasClass('hidden')) {
		  	target.removeClass('hidden');
		  } else {
		  	target.addClass('hidden');
		  }
		  
		  if(div) target = $('#' + div).find('div.dropbox_select_button_item_container');
		    
		  if(isNotEmpty(code) && isObjectType(code) == 'String') {
		  	target.prev().find('p').html(codeNm);
		    
		  	if(code.startsWith('SP')) {
		  		var level = target.parent().index();
		  		suppObj['SUPP_CD_' + (level + 1)] = code;
		  		suppObj['SUPP_NM_' + (level + 1)] = codeNm;
				  fnSetSubSupp(code, level);
		  	} else {
		  		var div = target.data('div');
		  		var etcContainer = target.parent().siblings('.tribute_request_direct_input_container');
		  		$('input[id=' + div + ']').val(code);
		  		if(div == 'PRO_METH_CD') {
		  			if(code == 'P007') {	// 기타
		  				$('.tribute_request_info_blank').addClass('hidden');
			  			$('.tribute_request_info_blank_typo').text('');
			  			etcContainer.removeClass('hidden');
		  			} else {
		  				$('.tribute_request_info_blank').removeClass('hidden');
			  			$('.tribute_request_info_blank_typo').text(codeNm);
			  			etcContainer.addClass('hidden');
			  			$('input[id=PRO_METH_ETC]').val('');
			  			
		  			}
		  		} else if(div == 'SHADE_CD') {
		  			if(code == 'S005') {	// 직접입력
		  				etcContainer.removeClass('hidden');
		  			} else {
		  				etcContainer.addClass('hidden');
		  				$('input[id=SHADE_ETC]').val('');
		  			}
		  		}
		  	}
		  }
		}
	}
	
	function fnSetSubSupp() {
		const pSuppCd = arguments[0];
		const currLevel = arguments[1];
		const subArr = fnFindSuppCdList(pSuppCd);
		
		var subSelectBtns = $('div.dropbox_select_button_large:gt(' + currLevel + ')');
		subSelectBtns.each(function() {
			if(isEmpty(subArr)) {
				$(this).addClass('dropbox_select_button_inactive');
			} else {
				$(this).removeClass('dropbox_select_button_inactive');
			}
			$(this).find('p').html('선택');
		});
		
		var subContainers = $('.dropbox_tribute_request_prosthetics_select_button_container:eq(0) div.dropbox_select_button_item_container:gt(' + currLevel + ')');
		subContainers.html('');
		subContainers.addClass('hidden');
		
		Object.keys(suppObj)
		.map(key => {
			const index = key.split('_').pop();
			if(index > (currLevel + 1)) suppObj[key] = '';
		});
		
		if(pSuppCd == 'SP109') {
			$('div.prosthetics_select_etc_container').removeClass('hidden');
		} else {
			$('div.prosthetics_select_etc_container').addClass('hidden');
			$('div.prosthetics_select_etc_container').find('input.dropbox_prosthetics_type_etc_chosen_direct_input').each(function() {
				$(this).val('');
			});
		}
		
		if(isNotEmpty(subArr)) {
			var html = '';
			subArr.map(m => {
				html += '<div class="dropbox_select_button_item_large" onclick="fnSelect(\'' + m.SUPP_CD + '\', \'' + m.SUPP_NM + '\');">';
				html += '	<p class="dropbox_select_button_item_typo">' + m.SUPP_NM + '</p>';
				html += '</div>';
			});
			$('div.dropbox_select_button_item_container').eq(currLevel + 1).html(html);
		}
	}
	
	function saveSuppModal() {
		CategoryChoiceBool = 1;
		var rootSuppCd = suppObj['SUPP_CD_1'];
		
		if(rootSuppCd == 'SP109') {		// 기타
			[...document.querySelectorAll('input[id^=ETC_SUPP_NM]')].map(
				m => {
					const value = m.value;
					const index = m.id.split('_').pop();
					suppObj['SUPP_NM_' + index] = value;

				}
			);
		}

		var prostheticsTypo =
		Object.keys(suppObj)
		.map(m => {
			document.getElementById(m).value = suppObj[m];
			if(m.includes('SUPP_NM')) return suppObj[m];
		})
		.filter(f => f)
		.join(' - ');
		
		currCardObj['SUPP_INFO'] = {...suppObj};
		//Frame, Splint, 의치, 교정, 트레이
		if(isEmpty(prostheticsTypo)) prostheticsTypo = '보철 종류를 선택해 주세요.';
		document.querySelector('.tribute_request_info_prosthetics_blank_typo').textContent = prostheticsTypo;
		console.log("prostheticsTypo " + prostheticsTypo);
		var specialCategory = prostheticsTypo;
		if(specialCategory.includes("-")){
			specialCategory = specialCategory.split("-")[0];
			specialCategory = specialCategory.replaceAll(" ", "");
		}
		if(specialCategory == 'Frame' || specialCategory == 'Splint' || specialCategory == '의치'|| specialCategory == '교정'|| specialCategory == '트레이'){
			justonebool = 1;
		}else{
			justonebool = 0;
			$("#bottom_div").css("display", "none");
			$("#top_div").css("display", "none");
		}
		closeSuppModal();
	}
	
	function closeSuppModal() {
		Object.keys(suppObj).map(key => { suppObj[key] = ''; });
	}
	
	function saveOftenWordModal() {
		var wordTxt = $('input[id=WORD_TXT]').val().trim();
		if(isEmpty(wordTxt)) {
			alert('자주 쓰는 말을 입력해주세요.');
			return;
		} else {
			$.ajax({
				url: '/' + API + '/tribute/saveOftenWord',
			  type: 'POST',
			  data: { WORD_TXT : wordTxt },
			  cache: false,
			  async: false,
			  success: function(resp) {
				  const mngNo = resp.MNG_NO;
			  	var html = '';
					html += '<div class="tribute_request_info_more_item">';
				  html += '	<p class="tribute_request_info_more_item_typo" style="cursor: pointer;" onclick="fnSetDtlTxt(this);">' + wordTxt + '</p>'; 
				  html += ' <img class="tribute_request_info_more_item_close_button" src="/public/assets/images/tribute_request_info_more_item_close_button.svg"';
				  html += ' 			style="cursor: pointer;" onclick="deleteWord(' + mngNo + ');"/>'; 
				  html += '</div>';
			  	$('.tribute_request_info_more_body').append(html);
			  }, complete: function() {
			    
			  }, error: function() {
			    
			  }
			});
			
			oftenWordModal.hide();
		}
	}
	
	function deleteWord() {
		var mngNo = arguments[0];
		var $div = $(event.target).parent();
		$.ajax({
			url: '/' + API + '/tribute/deleteOftenWord',
		  type: 'POST',
		  data: { MNG_NO : mngNo },
		  cache: false,
		  async: false,
		  success: function(resp) {
				$div.remove(); 	
		  }, complete: function() {
		    
		  }, error: function() {
		    
		  }
		});
	}
	
	function fnSetDtlTxt() {
		var el = arguments[0];
		var word = el.textContent;
		var dtlTxt = document.getElementById('DTL_TXT').value + " ";
		document.getElementById('DTL_TXT').value = dtlTxt + word;
	}
	
	function fnUpload() {
		
		const file = event.target.files[0];
		const fileNo = arguments[0];
		const fileNmEl = $(event.target).parent().prev().find('p');
		
		if(isNotEmpty(file)) {
			var fileFormData = new FormData();
			fileFormData.append('files', file);
			fileFormData.append('fileCd', JSON.stringify(fileCd));
			fileFormData.append('fileNo', JSON.stringify(fileNo));
			fileFormData.append('fileDiv', JSON.stringify(fileDiv));
			fileFormData.append('path', JSON.stringify(uploadPath));
			
			$.ajax({
			  url: '/' + API + '/tribute/uploadFile',
			  type: 'POST',
			  data: fileFormData,
			  cache: false,
			  async: false,
			  contentType: false,
			  processData: false,
			  success: function(resp) {
				  if(resp.result == 'Y') {
					  alert('저장되었습니다.');
					  fileNmEl.text(file.name);
				  }
			  }, 
			  complete: function() {}, 
			  error: function() {}
			});
		}
	}
	
	function fnPreview() {
		
		if(isEmpty($('#PANT_NM').val())) {
			alert('환자명을 입력해주세요.');
			$('#PANT_NM').focus();
			return;
		}
		
		saveCard();
		$('.tribute_request_body').addClass('hidden');
		
		var previewBodyEl = $('.tribute_request_preview_body');
		var pantNm = $('#PANT_NM').val();
		previewBodyEl.removeClass('hidden');
		previewBodyEl.find('.teeth_model_title_typo').text(pantNm);
		
		var html = '';
		cardArr.map((v, i) => {
			html += '<div class="p_card_chip tribute_request_card_chip' + ((i == cardArr.length - 1) ? '' : '_not') + '_selected">';
	    html += '  <p class="p_card_title tribute_request_card_chip' + ((i == cardArr.length - 1) ? '' : '_not') + '_selected_typo" onclick="setPreviewCard(this);">의뢰서&nbsp;' + (i + 1) + '</p>';
	    html += '</div>';
		});
		previewBodyEl.find('.tribute_request_card_chip_numb').before(html);
		previewBodyEl.find('.tribute_request_card_chip_numb_typo').text(cardArr.length);
		
		pcurrCardObj = cardArr[cardArr.length-1];
		setPreviewCardContent();
	}
	
	function fnWriteView() {
		resetPreviewCard();
		$('.tribute_request_preview_body').find('.tribute_request_card_chip_container > div').each(function() { $(this).remove(); });
		$('.tribute_request_preview_body').addClass('hidden');
		$('.tribute_request_body').removeClass('hidden');
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
				if(src.includes(m)) {
					$this.attr('src', src.replace('gray', 'normal'));
					$div.removeClass('p_teeth_model_tooth').addClass('p_teeth_model_tooth_selected');
					$div.find('p').removeClass('teeth_model_tooth_numb').addClass('teeth_model_tooth_selected_numb');
					
					var html = '';
					html += '<div class="selected_dental_preview_item">';
					html += '	 <p class="selected_dental_preview_item_typo">' + m + '</p>';
					html += '</div>';
					
					$('.selected_dental_preview_container').append(html);
				}
			});
		});
			
		$('.p_bridge').each(function() {
			var $pbridge = $(this);
			pcurrCardObj['BRIDGES'].map(bridge => {
				if($pbridge.attr('class').includes(bridge)) {
					$pbridge.removeClass('hidden');
				}
			});
		});
		
		// 보철종류
		var prostheticsTypo = '';
		if(isNotEmpty(pcurrCardObj['SUPP_INFO'])) {
			prostheticsTypo = Object.keys(pcurrCardObj['SUPP_INFO']).map(m => {
				if(m.includes('SUPP_NM')) return pcurrCardObj['SUPP_INFO'][m];
			})
			.filter(f => f)
			.join(' - ');
		}
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
		$('.tribute_request_preview_body').find('.tribute_request_preview_info_more_detail').val(pcurrCardObj['DTL_TXT']);
		
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
		
		var previewBodyEl = $('.tribute_request_preview_body');
		
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
	
	function fnSave() {
		
		if(isEmpty($('#PANT_NM').val())) {
			alert('환자명을 입력해주세요.');
			return;
		}
		
		if(cardArr.some(s => isEmpty(s.SUPP_INFO)) || cardArr.some(s => isEmpty(s.SUPP_INFO['SUPP_CD_1']))) {
			alert('보철종류를 선택해주세요.');
			return;
		}
		
		if(cardArr.some(s => isEmpty(s.TRIBUTE_DTL))) {
			alert('치식을 선택해주세요.');
			return;
		}
		
		if(cardArr.some(s => isEmpty(s.PRO_METH_CD))) {
			alert('가공방법을 선택해주세요.');
			return;
		} else {
			if(cardArr.some(s => {
				if(s.PRO_METH_CD == 'P007') {
					if(isEmpty(s.PRO_METH_ETC)) return true;
				}
			})) {
				alert('기타 가공방법을 입력해주세요.');
				return;
			}
		}
		
		if(cardArr.some((s, i) => {
			if(s.SHADE_CD == 'S005') {
				if(isEmpty(s.SHADE_ETC)) return true;
			}
		})) {
			alert('Shade를 입력해주세요.');
			return;
		}
	
		if(confirm('저장하시겠습니까?')) {
			$.ajax({
				url: '/' + API + '/tribute/save',
			  type: 'POST',
			  data: JSON.stringify({ cards : cardArr }),
			  contentType: 'application/json; charset=utf-8',
			  cache: false,
			  async: false,
			  success: function(resp) {
					if(resp.result == 'Y') {
						alert('저장되었습니다.');
						location.href = '/' + API + '/tribute/request_basket';
					}
			  }, 
			  complete: function() {}, 
			  error: function() {}
			});
		}
	}
	
</script>

<div class="tribute_request_header">
	<p class="tribute_request_header_typo">전자치과기공물의뢰서</p>
	<div class="tribute_request_connection_location_container">
	  <a href="/" class="tribute_request_connection_location_typo">
	    <img class="tribute_request_connection_location_home_button" src="/public/assets/images/connection_location_home_button_white.svg"/>
	  </a>
	  <img class="tribute_request_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	  <div class="tribute_request_connection_location">
	    <p class="tribute_request_connection_location_typo">
	    	<a href="/${api}/tribute/request_basket" class="tribute_request_connection_location_typo">의뢰서 바구니</a>
	    </p>
	  </div>
	  <img class="tribute_request_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
	  <div class="tribute_request_connection_location">
	    <p class="tribute_request_connection_location_typo_bold">전자치과기공물 의뢰서 작성하기</p>
	  </div>
	</div>
</div>
<div class="tribute_request_body">
<form id="saveForm" name="saveForm" style="display: flex;">
	<div class="teeth_model_container">
		<div class="teeth_model_title">
		  <img class="teeth_model_title_icon" src="/public/assets/images/teeth_model_title_icon.svg"/>
		  <input class="teeth_model_title_typo" type="text" name="PANT_NM" id="PANT_NM" onkeyup="fnSetPantNm(this);" placeholder="환자명을 입력하세요." />
		</div>
		<div class="teeth_model_wrapper" onclick="CategoryChkBtn()">
		<div id="top_div" style="width:100%;height:50%;display:none;position: absolute;top:0;z-index:9998"></div>
		<div id="bottom_div" style="width:100%;height:50%;top:50%;display:none;position: absolute;z-index:9998"></div>
			<!-- 
			bridge: 일반 브릿지
			bridge_dash: 점선 브릿지
			
			one_one_one_two: 일반 브릿지
			d_one_one_one_two: 점선 브릿지
			p_one_one_one_two: 미리보기 브릿지 
			hidden으로 조절
			-->
			<div id="11_12" class="hidden bridge one_one_one_two" data-target-from="11" data-target-to="12"></div>
			<div id="12_13" class="hidden bridge one_two_one_three" data-target-from="12" data-target-to="13"></div>
			<div id="13_14" class="hidden bridge one_three_one_four" data-target-from="13" data-target-to="14"></div>
			<div id="14_15" class="hidden bridge one_four_one_five" data-target-from="14" data-target-to="15"></div>
			<div id="15_16" class="hidden bridge one_five_one_six" data-target-from="15" data-target-to="16"></div>
			<div id="16_17" class="hidden bridge one_six_one_seven" data-target-from="16" data-target-to="17"></div>
			<div id="17_18" class="hidden bridge one_seven_one_eight" data-target-from="17" data-target-to="18"></div>
			
			<div id="11_21" class="hidden bridge one_one_two_one" data-target-from="11" data-target-to="21"></div>
			<div id="21_22" class="hidden bridge two_one_two_two" data-target-from="21" data-target-to="22"></div>
			<div id="22_23" class="hidden bridge two_two_two_three" data-target-from="22" data-target-to="23"></div>
			<div id="23_24" class="hidden bridge two_three_two_four" data-target-from="23" data-target-to="24"></div>
			<div id="24_25" class="hidden bridge two_four_two_five" data-target-from="24" data-target-to="25"></div>
			<div id="25_26" class="hidden bridge two_five_two_six" data-target-from="25" data-target-to="26"></div>
			<div id="26_27" class="hidden bridge two_six_two_seven" data-target-from="26" data-target-to="27"></div>
			<div id="27_28" class="hidden bridge two_seven_two_eight" data-target-from="27" data-target-to="28"></div>
			
			<div id="31_32" class="hidden bridge three_one_three_two" data-target-from="31" data-target-to="32"></div>
			<div id="32_33" class="hidden bridge three_two_three_three" data-target-from="32" data-target-to="33"></div>
			<div id="33_34" class="hidden bridge three_three_three_four" data-target-from="33" data-target-to="34"></div>
			<div id="34_35" class="hidden bridge three_four_three_five" data-target-from="34" data-target-to="35"></div>
			<div id="35_36" class="hidden bridge three_five_three_six" data-target-from="35" data-target-to="36"></div>
			<div id="36_37" class="hidden bridge three_six_three_seven" data-target-from="36" data-target-to="37"></div>
			<div id="37_38" class="hidden bridge three_seven_three_eight" data-target-from="37" data-target-to="38"></div>
			
			<div id="31_41" class="hidden bridge three_one_four_one" data-target-from="31" data-target-to="41"></div>
			<div id="41_42" class="hidden bridge four_one_four_two" data-target-from="41" data-target-to="42"></div>
			<div id="42_43" class="hidden bridge four_two_four_three" data-target-from="42" data-target-to="43"></div>
			<div id="43_44" class="hidden bridge four_three_four_four" data-target-from="43" data-target-to="44"></div>
			<div id="44_45" class="hidden bridge four_four_four_five" data-target-from="44" data-target-to="45"></div>
			<div id="45_46" class="hidden bridge four_five_four_six" data-target-from="45" data-target-to="46"></div>
			<div id="46_47" class="hidden bridge four_six_four_seven" data-target-from="46" data-target-to="47"></div>
			<div id="47_48" class="hidden bridge four_seven_four_eight" data-target-from="47" data-target-to="48"></div>
				
			<div class="teeth_model_tooth tooth_numb_one_one">
			  <p class="teeth_model_tooth_numb">11</p>
			</div>
			<img class="teeth_model_tooth_img img_one_one" toothNum="8" toothindex="11" src="/public/assets/images/tooth/normal/11.png"/>
			<div class="teeth_model_tooth tooth_numb_one_two">
			  <p class="teeth_model_tooth_numb">12</p>
			</div>
			<img class="teeth_model_tooth_img img_one_two" toothNum="7" toothindex="12" src="/public/assets/images/tooth/normal/12.png"/>
			<div class="teeth_model_tooth tooth_numb_one_three">
			  <p class="teeth_model_tooth_numb">13</p>
			</div>
			<img class="teeth_model_tooth_img img_one_three" toothNum="6" toothindex="13" src="/public/assets/images/tooth/normal/13.png"/>
			<div class="teeth_model_tooth tooth_numb_one_four">
			  <p class="teeth_model_tooth_numb">14</p>
			</div>
			<img class="teeth_model_tooth_img img_one_four" toothNum="5" toothindex="14" src="/public/assets/images/tooth/normal/14.png"/>
			<div class="teeth_model_tooth tooth_numb_one_five">
			  <p class="teeth_model_tooth_numb">15</p>
			</div>
		  <img class="teeth_model_tooth_img img_one_five" toothNum="4" toothindex="15" src="/public/assets/images/tooth/normal/15.png"/>
		  <div class="teeth_model_tooth tooth_numb_one_six">
		    <p class="teeth_model_tooth_numb">16</p>
		  </div>
		  <img class="teeth_model_tooth_img img_one_six" toothNum="3" toothindex="16" src="/public/assets/images/tooth/normal/16.png"/>
		  <div class="teeth_model_tooth tooth_numb_one_seven">
		    <p class="teeth_model_tooth_numb">17</p>
		  </div>
	    <img class="teeth_model_tooth_img img_one_seven" toothNum="2" toothindex="17" src="/public/assets/images/tooth/normal/17.png"/>
	    <div class="teeth_model_tooth tooth_numb_one_eight">
	      <p class="teeth_model_tooth_numb">18</p>
	    </div>
	    <img class="teeth_model_tooth_img img_one_eight" toothNum="1"  toothindex="18" src="/public/assets/images/tooth/normal/18.png"/>
	
	    <div class="teeth_model_tooth tooth_numb_two_one">
	      <p class="teeth_model_tooth_numb">21</p>
	    </div>
	    <img class="teeth_model_tooth_img img_two_one" toothNum="9" toothindex="21" src="/public/assets/images/tooth/normal/21.png"/>
	    <div class="teeth_model_tooth tooth_numb_two_two">
	      <p class="teeth_model_tooth_numb">22</p>
	    </div>
	    <img class="teeth_model_tooth_img img_two_two" toothNum="10" toothindex="22" src="/public/assets/images/tooth/normal/22.png"/>
	    <div class="teeth_model_tooth tooth_numb_two_three">
	      <p class="teeth_model_tooth_numb">23</p>
	    </div>
	    <img class="teeth_model_tooth_img img_two_three" toothNum="11" toothindex="23" src="/public/assets/images/tooth/normal/23.png"/>
	    <div class="teeth_model_tooth tooth_numb_two_four">
	    	<p class="teeth_model_tooth_numb">24</p>
	    </div>
	    <img class="teeth_model_tooth_img img_two_four" toothNum="12" toothindex="24" src="/public/assets/images/tooth/normal/24.png"/>
			<div class="teeth_model_tooth tooth_numb_two_five">
			  <p class="teeth_model_tooth_numb">25</p>
			</div>
			<img class="teeth_model_tooth_img img_two_five" toothNum="13" toothindex="25" src="/public/assets/images/tooth/normal/25.png"/>
			<div class="teeth_model_tooth tooth_numb_two_six">
			  <p class="teeth_model_tooth_numb">26</p>
			</div>
			<img class="teeth_model_tooth_img img_two_six" toothNum="14" toothindex="26" src="/public/assets/images/tooth/normal/26.png"/>
			<div class="teeth_model_tooth tooth_numb_two_seven">
			  <p class="teeth_model_tooth_numb">27</p>
			</div>
			<img class="teeth_model_tooth_img img_two_seven" toothNum="15" toothindex="27" src="/public/assets/images/tooth/normal/27.png"/>
			<div class="teeth_model_tooth tooth_numb_two_eight">
			  <p class="teeth_model_tooth_numb">28</p>
			</div>
			<img class="teeth_model_tooth_img img_two_eight" toothNum="16" toothindex="28" src="/public/assets/images/tooth/normal/28.png"/>
				
			<div class="teeth_model_tooth tooth_numb_three_one">
			  <p class="teeth_model_tooth_numb">31</p>
			</div>
			<img class="teeth_model_tooth_img img_three_one"  toothNum="24" toothindex="31" src="/public/assets/images/tooth/normal/31.png"/>
			<div class="teeth_model_tooth tooth_numb_three_two">
			  <p class="teeth_model_tooth_numb">32</p>
			</div>
			<img class="teeth_model_tooth_img img_three_two" toothNum="23" toothindex="32" src="/public/assets/images/tooth/normal/32.png"/>
			<div class="teeth_model_tooth tooth_numb_three_three">
			  <p class="teeth_model_tooth_numb">33</p>
			</div>
			<img class="teeth_model_tooth_img img_three_three" toothNum="22" toothindex="33" src="/public/assets/images/tooth/normal/33.png"/>
      <div class="teeth_model_tooth tooth_numb_three_four">
        <p class="teeth_model_tooth_numb">34</p>
      </div>
      <img class="teeth_model_tooth_img img_three_four" toothNum="21" toothindex="34" src="/public/assets/images/tooth/normal/34.png"/>
      <div class="teeth_model_tooth tooth_numb_three_five">
        <p class="teeth_model_tooth_numb">35</p>
      </div>
      <img class="teeth_model_tooth_img img_three_five" toothNum="20" toothindex="35" src="/public/assets/images/tooth/normal/35.png"/>
      <div class="teeth_model_tooth tooth_numb_three_six">
        <p class="teeth_model_tooth_numb">36</p>
      </div>
      <img class="teeth_model_tooth_img img_three_six" toothNum="19" toothindex="36" src="/public/assets/images/tooth/normal/36.png"/>
      <div class="teeth_model_tooth tooth_numb_three_seven">
        <p class="teeth_model_tooth_numb">37</p>
      </div>
      <img class="teeth_model_tooth_img img_three_seven" toothNum="18" toothindex="37" src="/public/assets/images/tooth/normal/37.png"/>
      <div class="teeth_model_tooth tooth_numb_three_eight">
        <p class="teeth_model_tooth_numb">38</p>
      </div>
      <img class="teeth_model_tooth_img img_three_eight" toothNum="17" toothindex="38" src="/public/assets/images/tooth/normal/38.png"/>

      <div class="teeth_model_tooth tooth_numb_four_one">
        <p class="teeth_model_tooth_numb">41</p>
      </div>
      <img class="teeth_model_tooth_img img_four_one" toothNum="25" toothindex="41" src="/public/assets/images/tooth/normal/41.png"/>
      <div class="teeth_model_tooth tooth_numb_four_two">
        <p class="teeth_model_tooth_numb">42</p>
      </div>
      <img class="teeth_model_tooth_img img_four_two" toothNum="26" toothindex="42" src="/public/assets/images/tooth/normal/42.png"/>
      <div class="teeth_model_tooth tooth_numb_four_three">
        <p class="teeth_model_tooth_numb">43</p>
      </div>
      <img class="teeth_model_tooth_img img_four_three" toothNum="27" toothindex="43" src="/public/assets/images/tooth/normal/43.png"/>
      <div class="teeth_model_tooth tooth_numb_four_four">
        <p class="teeth_model_tooth_numb">44</p>
      </div>
      <img class="teeth_model_tooth_img img_four_four" toothNum="28" toothindex="44" src="/public/assets/images/tooth/normal/44.png"/>
      <div class="teeth_model_tooth tooth_numb_four_five">
        <p class="teeth_model_tooth_numb">45</p>
      </div>
      <img class="teeth_model_tooth_img img_four_five" toothNum="29" toothindex="45" src="/public/assets/images/tooth/normal/45.png"/>
      <div class="teeth_model_tooth tooth_numb_four_six">
        <p class="teeth_model_tooth_numb">46</p>
      </div>
      <img class="teeth_model_tooth_img img_four_six" toothNum="30" toothindex="46" src="/public/assets/images/tooth/normal/46.png"/>
      <div class="teeth_model_tooth tooth_numb_four_seven">
        <p class="teeth_model_tooth_numb">47</p>
      </div>
       <img class="teeth_model_tooth_img img_four_seven" toothNum="31" toothindex="47" src="/public/assets/images/tooth/normal/47.png"/>
			<div class="teeth_model_tooth tooth_numb_four_eight">
			  <p class="teeth_model_tooth_numb">48</p>
			</div>
			<img class="teeth_model_tooth_img img_four_eight" toothNum="32" toothindex="48" src="/public/assets/images/tooth/normal/48.png"/>
		</div>
		<div class="tribute_request_button_wrapper">
		  <div class="tribute_request_button_container">
		    <a href="#fileModal" class="tribute_request_button" data-bs-toggle="modal">
		      <p class="tribute_request_button_typo">파일 첨부하기</p> 
		    </a>
		    <a href="javascript:void(0)" class="tribute_request_button" onclick="fnPreview();">
		      <p class="tribute_request_button_typo">의뢰서 미리보기</p> 
		    </a>
		  </div>
<!-- 		  <a href="javascript:void(0)" class="tribute_request_button" onclick="alert('개발중입니다.');"> -->
<!-- 		    <p class="tribute_request_button_typo">임시저장</p>  -->
<!-- 		  </a> -->
		</div>
  </div>
  
  <!-- 파일 첨부 modal -->
  <div class="modal fade" id="fileModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true" style="z-index:9999;">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content" style="width: fit-content;">
				<div class="dialog_tribute_request_container">
          <div class="dialog_tribute_request_header">
            <p class="dialog_tribute_request_header_typo">파일 첨부</p>
            <a href="javascript:void(0)" class="dialog_tribute_request_header_close_button_wrapper" data-bs-dismiss="modal">
              <img class="dialog_tribute_request_header_close_button" src="/public/assets/images/tribute_request_dialog_close_button.svg"/>
            </a>
          </div>
          <div class="dialog_tribute_request_body">
          <font style="margin-left:10px">※ 파일 최대 용량 500MB (zip 형식의 압축파일을 권장합니다.) </font>
          	<div class="dialog_tribute_request_table">
							<div class="dialog_tribute_request_table_data_type_container">
								<div class="dialog_tribute_request_table_data_type_order">
								    <p class="dialog_tribute_request_table_data_type_typo">NO.</p>
								</div>
								<div class="dialog_tribute_request_table_data_type_document">
								    <p class="dialog_tribute_request_table_data_type_typo">문서유형</p>
								</div>
								<div class="dialog_tribute_request_table_data_type_necessary">
								    <p class="dialog_tribute_request_table_data_type_typo">필수</p>
								</div>
								<div class="dialog_tribute_request_table_data_type_file_name">
								    <p class="dialog_tribute_request_table_data_type_typo">파일명</p>
								</div>
								<div class="dialog_tribute_request_table_data_type_download">
								    <p class="dialog_tribute_request_table_data_type_typo">업로드</p>
								</div>
								<div class="dialog_tribute_request_table_data_type_note">
								    <p class="dialog_tribute_request_table_data_type_typo">비고</p>
								</div>
							</div>
							<div class="dialog_tribute_request_table_data_container">
							  <div class="dialog_tribute_request_table_data_order">
							    <p class="dialog_tribute_request_table_data_typo">1</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_document">
							    <p class="dialog_tribute_request_table_data_typo">스캔파일</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_necessary">
							    <p class="dialog_tribute_request_table_data_typo">Y</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_file_name">
							    <p class="dialog_tribute_request_table_data_typo"></p>
							  </div>
							  <div class="dialog_tribute_request_table_data_download">
							  	<input type="file" id="file1" class="tribute_file" onchange="fnUpload('1');">
							    <p class="dialog_tribute_request_table_data_typo">업로드</p>
							    <img class="dialog_tribute_request_table_data_download_img" src="/public/assets/images/tribute_request_table_data_download_img.svg"/> 
							  </div>
							  <div class="dialog_tribute_request_table_data_note">
							    <p class="dialog_tribute_request_table_data_typo"></p>
							  </div>
							</div>
							<div class="dialog_tribute_request_table_data_container">
							  <div class="dialog_tribute_request_table_data_order">
							    <p class="dialog_tribute_request_table_data_typo">2</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_document">
							    <p class="dialog_tribute_request_table_data_typo">기타</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_necessary">
							    <p class="dialog_tribute_request_table_data_typo">N</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_file_name">
							    <p class="dialog_tribute_request_table_data_typo"></p>
							  </div>
							  <div class="dialog_tribute_request_table_data_download">
							  	<input type="file" id="file2" class="tribute_file" onchange="fnUpload('2');">
							    <p class="dialog_tribute_request_table_data_typo">업로드</p>
							    <img class="dialog_tribute_request_table_data_download_img" src="/public/assets/images/tribute_request_table_data_download_img.svg"/> 
							  </div>
							  <div class="dialog_tribute_request_table_data_note">
							    <p class="dialog_tribute_request_table_data_typo"></p>
							  </div>
							</div>
							<div class="dialog_tribute_request_table_data_container">
							  <div class="dialog_tribute_request_table_data_order">
							    <p class="dialog_tribute_request_table_data_typo">3</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_document">
							    <p class="dialog_tribute_request_table_data_typo">기타</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_necessary">
							    <p class="dialog_tribute_request_table_data_typo">N</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_file_name">
							    <p class="dialog_tribute_request_table_data_typo"></p>
							  </div>
							  <div class="dialog_tribute_request_table_data_download">
							  	<input type="file" id="file3" class="tribute_file" onchange="fnUpload('3');">
							    <p class="dialog_tribute_request_table_data_typo">업로드</p>
							    <img class="dialog_tribute_request_table_data_download_img" src="/public/assets/images/tribute_request_table_data_download_img.svg"/> 
							  </div>
							  <div class="dialog_tribute_request_table_data_note">
							    <p class="dialog_tribute_request_table_data_typo"></p>
							  </div>
							</div>
							<div class="dialog_tribute_request_table_data_container">
							  <div class="dialog_tribute_request_table_data_order">
							    <p class="dialog_tribute_request_table_data_typo">4</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_document">
							    <p class="dialog_tribute_request_table_data_typo">기타</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_necessary">
							    <p class="dialog_tribute_request_table_data_typo">N</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_file_name">
							    <p class="dialog_tribute_request_table_data_typo"></p>
							  </div>
							  <div class="dialog_tribute_request_table_data_download">
							  	<input type="file" id="file4" class="tribute_file" onchange="fnUpload('4');">
							    <p class="dialog_tribute_request_table_data_typo">업로드</p>
							    <img class="dialog_tribute_request_table_data_download_img" src="/public/assets/images/tribute_request_table_data_download_img.svg"/> 
							  </div>
							  <div class="dialog_tribute_request_table_data_note">
							    <p class="dialog_tribute_request_table_data_typo"></p>
							  </div>
							</div>
							<div class="dialog_tribute_request_table_data_container">
							  <div class="dialog_tribute_request_table_data_order">
							    <p class="dialog_tribute_request_table_data_typo">5</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_document">
							    <p class="dialog_tribute_request_table_data_typo">기타</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_necessary">
							    <p class="dialog_tribute_request_table_data_typo">N</p>
							  </div>
							  <div class="dialog_tribute_request_table_data_file_name">
							    <p class="dialog_tribute_request_table_data_typo"></p>
							  </div>
							  <div class="dialog_tribute_request_table_data_download">
							  	<input type="file" id="file5" class="tribute_file" onchange="fnUpload('5');">
							    <p class="dialog_tribute_request_table_data_typo">업로드</p>
							    <img class="dialog_tribute_request_table_data_download_img" src="/public/assets/images/tribute_request_table_data_download_img.svg"/> 
							  </div>
							  <div class="dialog_tribute_request_table_data_note">
							    <p class="dialog_tribute_request_table_data_typo"></p>
							  </div>
							</div>
            </div>
            <div class="dialog_tribute_request_button_wrapper">
              <button class="dialog_tribute_request_button" type="button" data-bs-dismiss="modal">
                <p class="dialog_tribute_request_button_typo">닫기</p>
              </button>
            </div>
        	</div>
        </div>
			</div>
		</div>
	</div>
  <!-- 파일 첨부 modal end -->
  
  <div class="tribute_request_card">
		<div class="tribute_request_card_chip_container">
		  <div class="tribute_request_card_chip_selected card_chip">
		    <p class="tribute_request_card_chip_selected_typo card_title" onclick="setCard(this);">의뢰서 1</p>
		    <img class="tribute_request_card_chip_close_button" src="/public/assets/images/tribute_request_card_chip_close_button.svg" onclick="deleteCard();"/>
		  </div>
		  <button class="tribute_request_card_chip_add_button" type="button" onclick="addCard();">
		    <p class="tribute_request_card_chip_add_button_typo">+</p>
		  </button>
		</div>
		<div class="tribute_request_info_container">
			<div class="tribute_request_info_prosthetics_container">
			  <p class="tribute_request_info_typo">보철종류</p>
			  <div class="tribute_request_info_prosthetics">
			    <div class="tribute_request_info_prosthetics_blank">
			      <p class="tribute_request_info_prosthetics_blank_typo">보철 종류를 선택해 주세요.</p>
			    </div>
			    <a href="#prostheticsModal" class="tribute_request_info_prosthetics_button" data-bs-toggle="modal">
			      <p class="tribute_request_info_prosthetics_button_typo">보철종류 선택</p>
			    </a>
			  </div>
			</div>
			
			<input type="hidden" name="SUPP_CD_1" id="SUPP_CD_1">
			<input type="hidden" name="SUPP_NM_1" id="SUPP_NM_1">
			<input type="hidden" name="SUPP_CD_2" id="SUPP_CD_2">
			<input type="hidden" name="SUPP_NM_2" id="SUPP_NM_2">
			<input type="hidden" name="SUPP_CD_3" id="SUPP_CD_3">
			<input type="hidden" name="SUPP_NM_3" id="SUPP_NM_3">
			<input type="hidden" name="SUPP_CD_4" id="SUPP_CD_4">
			<input type="hidden" name="SUPP_NM_4" id="SUPP_NM_4">
			
			<!-- 보철 종류 modal -->
			<div class="modal fade" id="prostheticsModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true" style="z-index:9999;">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content" style="width: fit-content;">
						<div class="dropbox_tribute_request_etc_chosen" style="min-height: 280px; height: auto;">
							<div class="dropbox_tribute_request_prosthetics_select_button_etc_chosen">
							  <p class="tribute_request_prosthetics_select_button_typo">
							  	보철종류
							  </p>
							  <a href="javascript:void(0)" data-bs-dismiss="modal" aria-label="Close" onclick="closeSuppModal();">
								  <img class="dropbox_tribute_request_prosthetics_select_button_close_button" src="/public/assets/images/dialog_close_button.svg"/>
			          </a>
							</div>
			        <div class="dropbox_tribute_request_prosthetics_select_button_container">
								<div class="dropbox_prosthetics_type">
									<div class="dropbox_select_button_large" onclick="fnSelect(this);" style="cursor: pointer;">
									  <div class="dropbox_select_button_typo_container">
									    <p class="dropbox_select_button_typo">선택</p>
									    <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
									  </div>
									</div>
									<div class="dropbox_select_button_item_container hidden">
									</div>
								</div>
								<div class="dropbox_prosthetics_type">
								  <div class="dropbox_select_button_large" onclick="fnSelect(this);" style="cursor: pointer;">
								    <div class="dropbox_select_button_typo_container">
								      <p class="dropbox_select_button_typo">선택</p>
								      <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
								    </div>
								  </div>
								  <div class="dropbox_select_button_item_container hidden">
								  </div>
								</div>
								<div class="dropbox_prosthetics_type">
								  <div class="dropbox_select_button_large" onclick="fnSelect(this);" style="cursor: pointer;">
								    <div class="dropbox_select_button_typo_container">
								      <p class="dropbox_select_button_typo">선택</p>
								      <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
								    </div>
								  </div>
								  <div class="dropbox_select_button_item_container hidden">
								  </div>
								</div>
			          <div class="dropbox_prosthetics_type">
			            <div class="dropbox_select_button_large" onclick="fnSelect(this);" style="cursor: pointer;">
			              <div class="dropbox_select_button_typo_container">
			                <p class="dropbox_select_button_typo">선택</p>
			                <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
			              </div>
			            </div>
			            <div class="dropbox_select_button_item_container hidden">
			            </div>
			          </div>
			      	</div>
			      	<div class="prosthetics_select_etc_container hidden">
				      	<div class="dropbox_tribute_request_divider"></div>
		            <div class="dropbox_tribute_request_prosthetics_select_button_container">
		              <div class="dropbox_prosthetics_type"></div>
		              <div class="dropbox_prosthetics_type">
		                <input type="text" class="dropbox_prosthetics_type_etc_chosen_direct_input" id="ETC_SUPP_NM_2" placeholder="직접입력"/>
		              </div>
		              <div class="dropbox_prosthetics_type">
		                <input type="text" class="dropbox_prosthetics_type_etc_chosen_direct_input" id="ETC_SUPP_NM_3" placeholder="직접입력"/>
		              </div>
		              <div class="dropbox_prosthetics_type">
		                <input type="text" class="dropbox_prosthetics_type_etc_chosen_direct_input" id="ETC_SUPP_NM_4" placeholder="직접입력"/>
		              </div>
		            </div>
	            </div>
	            <div class="dropbox_tribute_request_button_wrapper" style="margin-bottom: 35px;">
	              <button type="button" class="dropbox_tribute_request_button" onclick="saveSuppModal();" data-bs-dismiss="modal">
	                <div class="dropbox_tribute_request_button_typo">입력완료</div>
	              </button>
	            </div>
			      </div>
					</div>
				</div>
			</div>
			<!-- 보철 종류 modal end -->
			
			
			<div class="tribute_request_info_selected_dental_container">
			  <p class="tribute_request_info_typo">선택된 치식</p>
			  <div class="tribute_request_info_selected_dental">
			    <div class="tribute_request_info_selected_dental_blank">
			      <p class="tribute_request_info_selected_dental_blank_typo" style="margin-bottom: 5px;">치식을 선택해 주세요.</p>
			      <div class="selected_dental_container hidden">
            </div>
			    </div>
			  </div>
			</div>
			<div id="pro_meth_container" class="tribute_request_info_with_select_button_container">
				<input class="required" type="hidden" name="PRO_METH_CD" id="PRO_METH_CD" />
				<p class="tribute_request_info_typo">가공방법</p>
			  <div class="tribute_request_info_select_button_container">
			    <div class="dropbox_tribute_request">
			      <div class="dropbox_select_button" style="cursor: pointer;" onclick="fnSelect(this);">
			      	<div class="dropbox_select_button_typo_container">
			        	<p class="dropbox_select_button_typo">선택</p>
			          <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
			        </div>
			      </div>
			      <div class="dropbox_select_button_item_container hidden" data-div="PRO_METH_CD">
			      	<c:forEach items="${PRO_METH_CD_LIST}" var="pro">
			      		<div class="dropbox_select_button_item">
			            <p class="dropbox_select_button_item_typo" onclick="fnSelect('${pro.CODE_CD}', '${pro.CODE_NM}');" data-code="${pro.CODE_CD}">${pro.CODE_NM}</p>
			        	</div>
			      	</c:forEach>
			      </div>
			    </div>
			    <div class="tribute_request_info_blank">
				    <div class="tribute_request_info_blank_typo_container">
				      <p class="tribute_request_info_blank_typo being_entered"></p>
				    </div>
					</div>
				  <div class="tribute_request_direct_input_container hidden">
					  <div class="tribute_request_direct_input">
						  <input class="tribute_request_direct_input_blank" name="PRO_METH_ETC" id="PRO_METH_ETC" placeholder="기타 가공방법을 입력해 주세요." style="font-size: smaller;"/>
					  </div>
					</div>
			  </div>
			</div>
			<div id="shade_container" class="tribute_request_info_with_select_button_container">
				<input class="required" type="hidden" name="SHADE_CD" id="SHADE_CD" />
				<p class="tribute_request_info_typo">Shade</p>
				<div class="tribute_request_info_select_button_container">
				  <div class="dropbox_tribute_request">
				    <div class="dropbox_select_button" style="cursor: pointer;" onclick="fnSelect(this);">
				      <div class="dropbox_select_button_typo_container">
				        <p class="dropbox_select_button_typo">선택</p>
				        <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
				      </div>
				    </div>
				    <div class="dropbox_select_button_item_container hidden" data-div="SHADE_CD">
				    	<c:forEach items="${SHADE_CD_LIST}" var="shade">
				    		<div class="dropbox_select_button_item">
				          <p class="dropbox_select_button_item_typo" onclick="fnSelect('${shade.CODE_CD}', '${shade.CODE_NM}');" data-code="${shade.CODE_CD}">${shade.CODE_NM}</p>
				      	</div>
				    	</c:forEach>
				    </div>
				  </div>
				  <div class="tribute_request_direct_input_container hidden">
					  <div class="tribute_request_direct_input">
						  <input class="tribute_request_direct_input_blank" name="SHADE_ETC" id="SHADE_ETC" placeholder="Shade를 입력해 주세요." style="font-size: smaller;"/>
					  </div>
					</div>
				</div>
			</div>
			<img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
			<textarea class="tribute_request_detail_info" name="DTL_TXT" id="DTL_TXT" placeholder="상세내용"></textarea>
			<div class="tribute_request_info_more_container">
			  <div class="tribute_request_info_more_header">
			    <p class="tribute_request_info_more_header_typo">자주 쓰는 말</p>
			    <div class="tribute_request_info_more_header_blank_container">
			      <div class="tribute_request_info_more_header_blank">
			        <p class="tribute_request_info_more_header_blank_typo">선택</p>
			      </div> 
			      <a href="#oftenWordModal" class="tribute_request_info_more_header_button" data-bs-toggle="modal">
			        <p class="tribute_request_info_more_header_button_typo">자주 쓰는 말 관리</p> 
			      </a> 
			    </div>
			  </div>
			  <div class="main_container_divider"></div>
			  <div class="tribute_request_info_more_body">
			  	<c:forEach items="${OFTEN_WORD_LIST}" var="word">
			  		<div class="tribute_request_info_more_item">
				      <p class="tribute_request_info_more_item_typo" style="cursor: pointer;" onclick="fnSetDtlTxt(this);">${word.WORD_TXT}</p> 
				      <img class="tribute_request_info_more_item_close_button" src="/public/assets/images/tribute_request_info_more_item_close_button.svg"
				      			style="cursor: pointer;" onclick="deleteWord('${word.MNG_NO}');"/> 
				    </div>
			  	</c:forEach>
			  </div>
			</div>
			
			<!-- 자주 쓰는 말 modal -->
			<div class="modal fade" id="oftenWordModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content" style="width: fit-content;">
						<div class="dialog_tribute_request_frequently_used_word_container">
		          <div class="dialog_tribute_request_frequently_used_word_header">
		            <p class="dialog_tribute_request_frequently_used_word_header_typo">자주 쓰는 말</p>
		            <a href="javascript:void(0)" data-bs-dismiss="modal" aria-label="Close">
		            	<img class="dialog_tribute_request_frequently_used_word_close_button" src="/public/assets/images/dialog_close_button.svg"/>
		            </a>
		          </div>
		          <div class="dialog_tribute_request_frequently_used_word_body">
		            <input class="dialog_tribute_request_frequently_used_word_direct_input" name="WORD_TXT" id="WORD_TXT" placeholder="자주 쓰는 말 입력"/>
		            <div class="dialog_tribute_request_frequently_used_word_button_wrapper">
		              <button type="button" class="dialog_tribute_request_frequently_used_word_button" onclick="saveOftenWordModal();">
		                <p class="dialog_tribute_request_frequently_used_word_button_typo">입력완료</p>
		              </button>
		            </div>
		          </div>
		        </div>
					</div>
				</div>
			</div>
			<!-- 자주 쓰는 말 modal end -->
    </div>
	</div>
</form>
</div>

<div class="tribute_request_preview_body hidden">
            <div class="teeth_model_container">
                <div class="teeth_model_title">
                    <img class="teeth_model_title_icon" src="/public/assets/images/teeth_model_title_icon.svg"/>
                    <p class="teeth_model_title_typo"></p>
                </div>
                <div class="teeth_model_preview_wrapper">
                  
                  <div class="hidden p_bridge p_one_one_one_two"></div>
                  <div class="hidden p_bridge p_one_two_one_three"></div>
                  <div class="hidden p_bridge p_one_three_one_four"></div>
                  <div class="hidden p_bridge p_one_four_one_five"></div>
                  <div class="hidden p_bridge p_one_five_one_six"></div>
                  <div class="hidden p_bridge p_one_six_one_seven"></div>
                  <div class="hidden p_bridge p_one_seven_one_eight"></div>

                  <div class="hidden p_bridge p_one_one_two_one"></div>
                  <div class="hidden p_bridge p_two_one_two_two"></div>
                  <div class="hidden p_bridge p_two_two_two_three"></div>
                  <div class="hidden p_bridge p_two_three_two_four"></div>
                  <div class="hidden p_bridge p_two_four_two_five"></div>
                  <div class="hidden p_bridge p_two_five_two_six"></div>
                  <div class="hidden p_bridge p_two_six_two_seven"></div>
                  <div class="hidden p_bridge p_two_seven_two_eight"></div>

                  <div class="hidden p_bridge p_three_one_three_two"></div>
                  <div class="hidden p_bridge p_three_two_three_three"></div>
                  <div class="hidden p_bridge p_three_three_three_four"></div>
                  <div class="hidden p_bridge p_three_four_three_five"></div>
                  <div class="hidden p_bridge p_three_five_three_six"></div>
                  <div class="hidden p_bridge p_three_six_three_seven"></div>
                  <div class="hidden p_bridge p_three_seven_three_eight"></div>

                  <div class="hidden p_bridge p_three_one_four_one"></div>
                  <div class="hidden p_bridge p_four_one_four_two"></div>
                  <div class="hidden p_bridge p_four_two_four_three"></div>
                  <div class="hidden p_bridge p_four_three_four_four"></div>
                  <div class="hidden p_bridge p_four_four_four_five"></div>
                  <div class="hidden p_bridge p_four_five_four_six"></div>
                  <div class="hidden p_bridge p_four_six_four_seven"></div>
                  <div class="hidden p_bridge p_four_seven_four_eight"></div>

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
                <div class="tribute_request_card">
                    <div class="tribute_request_card_chip_container">
                        <!-- <div class="tribute_request_card_chip_not_selected">
                            <p class="tribute_request_card_chip_not_selected_typo">환자명 의뢰서</p>
                            <img class="tribute_request_card_chip_close_button" src="/public/assets/images/tribute_request_card_chip_close_button.svg"/>
                        </div>
                        <div class="tribute_request_card_chip_selected">
                            <p class="tribute_request_card_chip_selected_typo">홍길동 의뢰서</p>
                            <img class="tribute_request_card_chip_close_button" src="/public/assets/images/tribute_request_card_chip_close_button.svg"/>
                        </div> -->
                        <button class="tribute_request_card_chip_numb">
                          <p class="tribute_request_card_chip_numb_typo">2</p>
                      </button>
                    </div>
                    <div class="tribute_request_preview_info_wrapper">
                        <div class="tribute_request_preview_info_container" style="margin-bottom: 80px;">
                            <div id="p_supp_container" class="tribute_request_preview_info">
                                <div class="tribute_request_preview_info_title">
                                    <p class="tribute_request_preview_info_title_typo">보철종류</p>
                                </div> 
                                <div class="tribute_request_preview_info_context">
                                    <p class="tribute_request_preview_info_context_typo">의치</p>
                                </div>    
                            </div>
                            <div class="tribute_request_preview_info">
                                <div class="tribute_request_preview_info_title">
                                    <p class="tribute_request_preview_info_title_typo">선택된 치식</p>
                                </div> 
                                <div class="tribute_request_preview_info_context">
                                    <div class="selected_dental_preview_container">
                                        <!-- <div class="selected_dental_preview_item">
                                            <p class="selected_dental_preview_item_typo">26</p>
                                        </div>
                                        <div class="selected_dental_preview_item">
                                            <p class="selected_dental_preview_item_typo">33</p>
                                        </div>
                                        <div class="selected_dental_preview_item">
                                            <p class="selected_dental_preview_item_typo">34</p>
                                        </div> -->
                                    </div>
                                </div>    
                            </div>
                            <div id="p_pro_meth_container" class="tribute_request_preview_info">
                                <div class="tribute_request_preview_info_title">
                                    <p class="tribute_request_preview_info_title_typo">가공방법</p>
                                </div> 
                                <div class="tribute_request_preview_info_context">
                                    <p class="tribute_request_preview_info_context_typo">3D프린팅(레진)</p>
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
                        <!-- <div class="tribute_request_preview_info_more">
                            <div class="tribute_request_preview_info_more_typo">군인은 현역을 면한 후가 아니면 국무위원으로 임명될 수 없다.</div>
                        </div> -->
                        <img class="dotted_divider" src="/public/assets/images/dotted_divider.svg"/>
                        <textarea class="tribute_request_preview_info_more_detail" placeholder="상세내용" readonly="readonly"></textarea>
                        <div class="tribute_request_preview_button_wrapper">
                            <a href="javascript:fnWriteView();" class="tribute_request_preview_button">
                            	<p class="tribute_request_preview_button_typo">수정하기</p>
                            </a>
                            <a href="javascript:fnSave();" class="tribute_request_preview_button">
                                <p class="tribute_request_preview_button_typo">의뢰서 바구니에 담기</p>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>