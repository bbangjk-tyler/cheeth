<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
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

  var fileArray = new Array();
  var sendUserList = new Array();
  
  function fnInitOpenTalk() {
    var div = $('#sendDiv');
    if(div.hasClass('hidden')) {
      div.removeClass('hidden');
	  fileArray = new Array();
	  sendUserList = new Array();
	  $('.send_note_attatchment_container').html('').addClass('hidden');
	  $('.send_note_receiver_blank_typo').html('')
	  $('#CONTENT').val('');
	  
	  $('.address_list_receiver_name_container > p').remove();
      var cnt = $('.address_list_receiver_name_container > p').length;
      $('.address_list_receiver_context').html(cnt);
      
      $('.address_list_name_container > p').each(function(k,v) {
    	  if($(v).hasClass('address_list_name_selected')) {
			  $(v).removeClass('address_list_name_selected');
			  $(v).addClass('address_list_name');
    	  }
      });
      $('#findNickName').val('');
      $('.address_list_name_container > p').show();
    
    }
  }
 
  function fnOpenTalk() {
    var div = $('#sendDiv');
    if(div.hasClass('hidden')) {
      div.removeClass('hidden');
    }
  }
  
  function fnAddFile() {
    $('#ADD_FILE').click();
  }
  
  function fnFileChange() {
    var target = arguments[0];
    if(isNotEmpty(target.files[0])) {
      var obj = new Object();
      obj.IDX = fnGetMaxIdx(fileArray);
      obj.FILE = target.files[0];
      fileArray.push(obj);
      var div = $('.send_note_attatchment_container');
      if(fileArray.length === 0) {
        div.addClass('hidden');
      } else {
        div.removeClass('hidden');
      }
      var html = ``;
      for(var i=0; i<fileArray.length; i++) {
        var fileNm = fileArray[i].FILE.name;
        html += `<div class="send_note_attatchment">`;
        html += `<img class="send_note_attatchment_icon" src="/public/assets/images/note_box_attatchment.svg"/>`;
        html += `<p class="send_note_attatchment_typo">` + fileNm + `</p>`;
        html += `</div>`;
        div.html(html);
      }
    }
  }
  
  function fnOpenAdress() {
	  fnDialogClose();
    var div = $('#adressDiv');
    if(div.hasClass('hidden')) {
      div.removeClass('hidden');
    }
  }
  
  function fnSelect() {
    var code = arguments[0];
    var codeNm = arguments[1];
    
    var target = $('#TALK_CD_DIV_2');
    if(target.hasClass('hidden')) {
      target.removeClass('hidden');
    } else {
      target.addClass('hidden');
    }
    
    $('#TALK_CD_DIV_1').find('p').html(codeNm);
    $('#TALK_CD').val(code);
    
    if(isNotEmpty(code)) {
      fnSearch();
    }
  }
  
  function fnDelete() {
    
    var talkItem = new Array();
    $('#dataListDiv').find('input').each(function(k,v) {
      if($(v).is(':checked')) {
        var item = new Object();
        item.TALK_NO = $(v).data('talk-no');
        talkItem.push(item);
      }
    });
    
    if(talkItem.length === 0) {
      alert('삭제 대상을 선택하세요.');
      return;
    }
    
    var isConfirm = window.confirm('삭제 하시겠습니까?');
    if(!isConfirm) return;
    
    var saveObj = new Object();
    saveObj.TALK_ITEM = JSON.stringify(talkItem);
    
    $.ajax({
      url: '/' + API + '/talk/delete03',
      type: 'POST',
      data: saveObj,
      cache: false,
      async: false,
      success: function(data) {
        fnSearch();
      }, complete: function() {
        
      }, error: function() {
        
      }
    });
  }
  
  function fnOneDelete() {
	  var talkNo = $('#d_talk_no').val();
    var isConfirm = window.confirm('삭제 하시겠습니까?');
    if(!isConfirm) return;
    $.ajax({
      url: '/' + API + '/talk/delete04',
      type: 'POST',
      data: { TALK_NO : talkNo },
      cache: false,
      async: false,
      success: function(data) {
    	  fnDialogClose();
        fnSearch();
      }, complete: function() {
        
      }, error: function() {
        
      }
    });
  }
  
  function fnSearch() {
    var page = arguments[0] ?? '1';
    var url = '/' + API + '/talk/send';
    url += '?PAGE=' + page;
    url += '&TALK_CD=' + $('#TALK_CD').val();
    location.href = url;
  }
  
  function fnDtlView() {
    var talkNo= arguments[0];
    $('#d_talk_no').val(talkNo);
    var div = $('#dtlDiv');
    if(div.hasClass('hidden')) {
      div.removeClass('hidden');
    }
    
    $.ajax({
      url: '/' + API + '/talk/getData04',
      type: 'GET',
      data: { TALK_NO: talkNo },
      cache: false,
      async: false,
      success: function(data) {
        $('#dtl_r_nm').html(data.info.RECEIVE_NM);
        $('#dtl_s_date').html(data.info.SEND_DATE);
        $('#dtl_content').html(data.info.CONTENT);
        var dtlContent = $('#dtl_content')[0].outerHTML;
        var fileCnt = data.info.FILE_CNT ?? 0;
        if(fileCnt > 0) {
          var html = ``;
          for(var i=0; i<fileCnt; i++) {
            var fileCd = data.fList[i].FILE_CD;
            var fileNo = data.fList[i].FILE_NO;
            var fileOriginNm = data.fList[i].FILE_ORIGIN_NM;
            html += `<a href="javascript:fnFileDownload('` + fileCd + `','` + fileNo + `');">` + fileOriginNm + `</a>`;
          }
          html += dtlContent;
          $('.received_note_context').html(html);
        }
      }, complete: function() {
        
      }, error: function() {
        
      }
    });
  }
  
  function fnSend() {
   
   if(isEmpty(sendUserList)) {
     alert('받는사람이 존재하지 않습니다.');
     return;
   }
   
   var content = $('#CONTENT').val();
   if(isEmpty(content)) {
     alert('내용을 입력하세요.');
     $('#CONTENT').focus();
     return;
   }
   
   var isConfirm = window.confirm('쪽지를 보내시겠습니까?');
   if(!isConfirm) return;
     var formData = new FormData(document.getElementById('saveForm'));
     for(var key of formData.keys()) {
       formData.set(key, JSON.stringify(formData.get(key)));
     }
     
     for(var i=0; i<fileArray.length; i++) {
       formData.append("files", fileArray[i].FILE);
     }
    
     $.ajax({
       url: '/' + API + '/talk/save01',
       type: 'POST',
       data: formData,
       cache: false,
       async: false,
       contentType: false,
       processData: false,
       success: function(data) {
         fnSearch();
       }, complete: function() {
    	   
       }, error: function() {
       }
     });
  }
  
  function fnSendView() {
    var div = $('#sendDiv');
    if(div.hasClass('hidden')) {
      div.removeClass('hidden');
    }
  }
  
  function fnDialogClose() {
    var div1 = $('#dtlDiv');
    if(!div1.hasClass('hidden')) {
      div1.addClass('hidden');
    }
    var div2 = $('#sendDiv');
    if(!div2.hasClass('hidden')) {
      div2.addClass('hidden');
    }
    var div3 = $('#adressDiv');
    if(!div3.hasClass('hidden')) {
      div3.addClass('hidden');
    }
  }
  
  function fnAdressSelect1() {
    var target = $(arguments[0]);
    if(target.hasClass('address_list_name_selected')) {
      target.removeClass('address_list_name_selected');
      target.addClass('address_list_name');
    } else {
      target.removeClass('address_list_name');
      target.addClass('address_list_name_selected');
    }
  }
  
  function fnAdressSelect2() {
    var target = $(arguments[0]);
    if(target.hasClass('address_list_receiver_name_selected')) {
      target.removeClass('address_list_receiver_name_selected');
      target.addClass('address_list_receiver_name');
    } else {
      target.removeClass('address_list_receiver_name');
      target.addClass('address_list_receiver_name_selected');
    }
  }
  
  function fnAdressMoveRight() {
    var target = $(arguments[0]);
    $('.address_list_name_container > p').each(function(k,v) {
      if($(v).hasClass('address_list_name_selected')) {
        var userId = $(v).data('user-id');
        var chkCnt = $(`.address_list_receiver_name_container [data-user-id="` + userId + `"]`).length;
        if(chkCnt === 0) {
          var p = $(v)[0]
          .outerHTML
          .replace('address_list_name_selected', 'address_list_receiver_name')
          .replace('fnAdressSelect1', 'fnAdressSelect2');
          $('.address_list_receiver_name_container').append(p);
        }
      }
    });
    var cnt = $('.address_list_receiver_name_container > p').length;
    $('.address_list_receiver_context').html(cnt);
  }
  
  function fnAdressOk() {
    sendUserList = new Array();
    $('.address_list_name_container > p').each(function(k,v) {
      if($(v).hasClass('address_list_name_selected')) {
        var userId = $(v).data('user-id');
        var nickName = $(v).data('nick-name');
        sendUserList.push({USER_ID: userId.toString(), USER_NICK_NAME: nickName.toString()});
      }
    });
    if(sendUserList.length > 0) {
      var reStr = '';
      for(var i=0; i<sendUserList.length; i++) {
        if(reStr.length === 0) {
          reStr = sendUserList[i].USER_NICK_NAME;
        } else {
          reStr += ', ' + sendUserList[i].USER_NICK_NAME;
        }
      }
      $('.send_note_receiver_blank_typo').html(reStr);
      $('#RECEIVE_ID_LIST').val(JSON.stringify(sendUserList));
    }
    fnDialogClose();
    fnOpenTalk();
  }
  
  function fnAdressCancel() {
    fnDialogClose();
    fnOpenTalk();
  }
  
  function fnAdressMoveLeft() {
    var target = $(arguments[0]);
    $('.address_list_receiver_name_container > p').each(function(k,v) {
      if($(v).hasClass('address_list_receiver_name_selected')) {
    	  $(v).remove();
      }
    });
    var cnt = $('.address_list_receiver_name_container > p').length;
    $('.address_list_receiver_context').html(cnt);
  }
  
  function fnFindNickName() {
    var findNickName = $('#findNickName').val();
    if(findNickName.length === 0) {
      $('.address_list_name_container > p').each(function(k,v) {
        $(v).show();
      });
    } else {
      $('.address_list_name_container > p').each(function(k,v) {
        var nickName = $(v).data('nick-name') + '';
        if(nickName.indexOf(findNickName) === -1) {
          $(v).hide();
        } else {
          $(v).show();
        }
      });
    }
  }
  
  $(document).ready(function() {
	  fnSetPageInfo('${PAGE}', '${TOTAL_CNT}', 10);
  });
  
</script>

<input type="hidden" id="TALK_CD" name="TALK_CD" value="">

<div class="note_box_header">
  <p class="note_box_header_typo">보낸 쪽지함</p>
</div>

<div class="note_box_body">
  <div class="note_box_side_menu">
    <a href="javascript:void(0);" class="note_box_side_menu_title" onclick="fnInitOpenTalk();">
      <img class="note_box_sending_icon" src="/public/assets/images/note_box_sending_icon.svg"/>
      <p class="note_box_side_menu_title_typo">쪽지보내기</p>
    </a>
    <div class="note_box_side_menu_list_main">
      <p class="note_box_side_menu_list_main_typo_title">전체 쪽지</p>
      <p class="note_box_side_menu_list_main_typo_context">${TOTAL_RECEIVE_CNT}</p>
      <p class="note_box_side_menu_list_main_typo_title">안읽음</p>
      <p class="note_box_side_menu_list_main_typo_context">${NREAD_RECEIVE_CNT}</p>
    </div>
    <a href="/${api}/talk/receive" class="note_box_side_menu_list_sub">
      <img class="note_box_side_menu_list_sub_icon" src="/public/assets/images/received_note_box.svg"/>
      <p class="note_box_side_menu_list_sub_typo_title">받은쪽지함</p>
      <p class="note_box_side_menu_list_sub_typo_context"></p>
    </a>
    <a href="javascript:fnOpenAdress();" class="note_box_side_menu_list_sub">
      <img class="note_box_side_menu_list_sub_icon" src="/public/assets/images/view_address_list.svg"/>
      <p class="note_box_side_menu_list_sub_typo_title">주소록 보기</p>
      <p class="note_box_side_menu_list_sub_typo_context"></p>
    </a>
    <a href="/${api}/talk/send" class="note_box_side_menu_list_sub">
      <img class="note_box_side_menu_list_sub_icon" src="/public/assets/images/sent_note_box.svg"/>
      <p class="note_box_side_menu_list_sub_typo_title_selected">보낸쪽지함</p>
      <p class="note_box_side_menu_list_sub_typo_context">${SEND_CNT}</p>
    </a>
  </div>
  <div class="note_box_main_container">
    <div class="note_box_button_wrapper">
      <div class="note_box_button_container" style="cursor: pointer;">
        <div class="note_box_button" onclick="fnDelete();">
          <img class="note_box_delete_button_icon" src="/public/assets/images/note_box_delete_button_icon.svg"/> 
          <p class="note_box_button_typo">삭제</p>
        </div>
      </div>
      <div class="dropbox_note_box">
        <div id="TALK_CD_DIV_1" class="dropbox_select_button" onclick="fnSelect();" style="cursor: pointer;">
          <div class="dropbox_select_button_typo_container">
            <p class="dropbox_select_button_typo">전체쪽지</p>
            <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
          </div>
        </div>
        <div id="TALK_CD_DIV_2" class="dropbox_select_button_item_container hidden">
          <div class="dropbox_select_button_item" style="cursor: pointer;" onclick="fnSelect('ALL', '전체쪽지')">
            <p class="dropbox_select_button_item_typo">전체쪽지</p>
          </div>
          <c:forEach var="item" items="${TALK_CD_LIST}" varStatus="status">
            <div class="dropbox_select_button_item" style="cursor: pointer;" onclick="fnSelect('${item.CODE_CD}', '${item.CODE_NM}')">
              <p class="dropbox_select_button_item_typo">${item.CODE_NM}</p>
            </div>
          </c:forEach>
        </div>
      </div>
    </div>
    <div class="note_box_list_container">
      <div class="note_box_list_data_type_container">
        <input type="checkbox" id="checkAll" onchange="fnCheckAll(this, 'dataListDiv');">
        <div class="note_box_list_data_type_receiver">
          <p class="note_box_list_data_type_typo">받는사람</p>
        </div>
        <div class="note_box_attatchment invisible">
          <img class="note_box_attatchment" src="/public/assets/images/note_box_attatchment.svg"/>
        </div>
        <div class="note_box_list_data_type_context">
          <p class="note_box_list_data_type_typo">내용</p>
        </div>
        <div class="note_box_list_data_type_date_sent">
          <p class="note_box_list_data_type_typo">보낸날짜</p>
        </div>
        <div class="note_box_list_data_type_date_received">
          <p class="note_box_list_data_type_typo">받은날짜</p>
        </div>
      </div>
      <div id="dataListDiv">
        <c:forEach var="item" items="${LIST}" varStatus="status">
          <div class="note_box_list">
            <input type="checkbox" data-talk-no="${item.TALK_NO}" onchange="fnCheck(this, 'dataListDiv');">
            <div class="note_box_list_receiver">
              <p class="note_box_list_receiver_typo">${item.RECEIVE_NM}</p>
            </div>
            <c:if test="${item.FILE_CNT gt 0}">
	            <div class="note_box_attatchment">
	              <img class="note_box_attatchment" src="/public/assets/images/note_box_attatchment.svg"/>
	            </div>
            </c:if>
            <a href="javascript:fnDtlView('${item.TALK_NO}');" class="note_box_list_context">
              <p class="note_box_list_context_typo note_box_txt_line">${item.CONTENT}</p>
            </a>
            <div class="note_box_list_date_sent">
              <p class="note_box_list_date_typo">${item.SEND_DATE}</p>
            </div>
            <div class="note_box_list_date_received">
              <p class="note_box_list_date_typo">${item.RECEIVE_DATE}</p>
            </div>
          </div>
          <div class="list_divider"></div>
        </c:forEach>
      </div>
    </div>
    <div class="pagination"></div>
  </div>
</div>

<div id="dtlDiv" class="sample_dialog_root hidden">
  <input type="hidden" id="d_talk_no" value="">
  <div class="received_note_container">
    <div class="received_note_header">
      <a href="javascript:fnDialogClose();" class="received_note_header_close_button_wrapper">
        <img class="received_note_header_close_button" src="/public/assets/images/received_note_close_button.svg"/>
      </a>
    </div>
    <div class="received_note_body">
      <div class="received_note_button_wrapper">
        <a href="javascript:fnOneDelete();" class="received_note_button_delete">
          <p class="received_note_button_delete_typo">삭제</p>
        </a>
<!--         <div class="received_note_button_container"> -->
<!--           <button class="received_note_button_before"> -->
<!--             <img class="received_note_button_before_arrow" src="/public/assets/images/connection_location_arrow.svg"/> -->
<!--             <p class="received_note_button_before_typo">이전</p> -->
<!--           </button> -->
<!--           <div class="received_note_button_divider"></div> -->
<!--           <button class="received_note_button_after"> -->
<!--             <p class="received_note_button_after_typo">다음</p> -->
<!--             <img class="received_note_button_after_arrow" src="/public/assets/images/connection_location_arrow.svg"/> -->
<!--           </button> -->
<!--         </div> -->
      </div>
      <div class="main_container_divider without_margin"></div>
      <div class="received_note_info_container">
        <div class="received_note_info">
          <p class="received_note_info_title">받는사람</p>
          <p class="received_note_info_context" id="dtl_r_nm"></p>
        </div>
        <div class="received_note_info">
          <p class="received_note_info_title">보낸시간</p>
          <p class="received_note_info_context" id="dtl_s_date"></p>
        </div>
      </div>
      <div class="main_container_divider without_margin"></div>
      <div class="received_note_context">
<!--         <a href="./note_box_attatchment.html" class="received_note_attatchment_button"> -->
<!--           hidden으로 첨부파일 유무에 따라 조절 -->
<!--           <img class="received_note_attatchment_button_icon" src="/public/assets/images/received_note_attatchment_icon.svg"/> -->
<!--           <p class="received_note_attatchment_button_typo">첨부파일</p> -->
<!--           hidden으로 첨부파일 개수에 따라 조절 -->
<!--           <p class="received_note_attatchment_button_count_typo">2</p> -->
<!--         </a> -->
	      <p class="received_note_context_typo" id="dtl_content"></p>
	    </div>
    </div>
  </div>
</div>

<div id="sendDiv" class="sample_dialog_root hidden">
  <form:form id="saveForm" name="saveForm">
    <input type="hidden" id="RECEIVE_ID_LIST" name="RECEIVE_ID_LIST">
    <div class="send_note_container">
      <div class="send_note_header">
        <p class="send_note_header_typo">쪽지 보내기</p>
        <a href="javascript:fnDialogClose();">
          <img class="send_note_dialog_close_button" src="/public/assets/images/send_note_dialog_close_button.svg"/>
        </a>
      </div>
      <div class="send_note_body">
        <div class="send_note_button_container">
          <a href="javascript:void(0);" class="send_note_send_button" onclick="fnSend();">
            <img class="send_note_send_button_icon" src="/public/assets/images/note_box_sending_icon.svg"/>
            <p class="send_note_send_button_typo">보내기</p>
          </a>
          <a href="javascript:void(0);" class="send_note_attatch_button" onclick="fnAddFile();">
            <p class="send_note_attatch_button_typo">파일첨부</p>
          </a>
        </div>
        <div class="send_note_attatchment_container hidden"></div>
        <div class="main_container_divider without_margin"></div>
        <div class="send_note_receiver">
          <p class="send_note_receiver_typo">받는사람</p>
          <div class="send_note_receiver_blank">
            <p class="send_note_receiver_blank_typo"></p>
          </div>
          <a href="javascript:void(0);" class="send_note_receiver_button" onclick="fnOpenAdress();">
            <p class="send_note_receiver_button_typo">주소록</p>
          </a>
        </div>
        <textarea id="CONTENT" name="CONTENT" class="send_note_context" maxlength="1300"></textarea>
      </div>
    </div>
  </form:form>
</div>

<div id="adressDiv" class="sample_dialog_root hidden">
  <div class="address_list_container">
    <div class="address_list_header">
      <p class="address_list_header_typo">주소록</p>
      <a href="javascript:fnDialogClose();" class="address_list_close_button_wrapper">
        <img  class="address_list_close_button" src="/public/assets/images/send_note_dialog_close_button.svg"/>
      </a>
    </div>
    <div class="address_list_body">
      <div class="address_list_total_trader">
        <div class="address_list_total_trader_typo_container">
          <p class="address_list_total_trader_title">전체 거래자</p>
          <p class="address_list_total_trader_context">${USER_CNT}</p>
        </div>
      </div>
      <div class="address_list_main_container">
        <div class="address_list_search">
          <input type="text" class="address_list_search_blank" id="findNickName" maxlength="30" placeholder="닉네임 찾기">
          <button class="address_list_search_button" onclick="fnFindNickName();">
            <p class="address_list_search_button_typo">찾기</p>
          </button>
        </div>
        <div class="dialog_main_container_divider"></div>
        <div class="address_list_name_container">
          <!-- selected로 조절 -->
          <c:forEach var="item" items="${USER_LIST}" varStatus="status">
	          <p class="address_list_name" 
               style="cursor: pointer;"
               data-user-id="${item.USER_ID}"
               data-nick-name="${item.USER_NICK_NAME}"
               onclick="fnAdressSelect1(this);">${item.USER_NICK_NAME}</p>
          </c:forEach>
        </div>
<!--         <div class="dialog_main_container_divider"></div> -->
<!--         <div class="address_list_pagination"> -->
<!--           <p class="address_list_pagination_current_page">1 / 3</p> -->
<!--           <div class="address_list_pagination_button_container"> -->
<!--             <div class="address_list_pagination_button_divider"></div> -->
<!--             <button class="address_list_pagination_button"> -->
<!--               <img class="address_list_pagination_button_before" src="/public/assets/images/connection_location_arrow.svg"/> -->
<!--             </button> -->
<!--             <div class="address_list_pagination_button_divider"></div> -->
<!--             <button class="address_list_pagination_button"> -->
<!--               <img class="address_list_pagination_button_after" src="/public/assets/images/connection_location_arrow.svg"/> -->
<!--             </button> -->
<!--           </div> -->
<!--         </div> -->
      </div>
      <div class="address_list_move_button_container">
        <button class="address_list_move_button" onclick="fnAdressMoveRight();">
          <img class="address_list_move_button_arrow_right" src="/public/assets/images/address_list_move_button_arrow_right.svg"/>
        </button>
        <button class="address_list_move_button" onclick="fnAdressMoveLeft();">
          <img class="address_list_move_button_arrow_left" src="/public/assets/images/address_list_move_button_arrow_right.svg"/>
        </button>
      </div>
      <div class="address_list_receiver">
        <div class="address_list_receiver_typo_container">
          <p class="address_list_receiver_title">받는사람</p>
          <p class="address_list_receiver_context">0</p>
        </div>
        <div class="address_list_receiver_name_container"></div>
      </div>
    </div>
    <div class="address_list_footer">
      <div class="dialog_main_container_divider"></div>
      <p class="address_list_tip"></p>
      <div class="address_list_button_container">
        <a href="javascript:fnAdressOk();" class="address_list_button">
          <p class="address_list_button_typo">확인</p>
        </a>
        <a href="javascript:fnAdressCancel();" class="address_list_button">
          <p class="address_list_button_typo">취소</p>
        </a>
      </div>
    </div>
  </div>
</div>

<input style="display: none;" type="file" id="ADD_FILE" name="ADD_FILE" onchange="fnFileChange(this);">

<form:form id="fileDownloadForm" name="fileDownloadForm" action="/${api}/file/download" method="POST">
  <input type="hidden" id="FILE_CD" name="FILE_CD" value="">
  <input type="hidden" id="FILE_NO" name="FILE_NO" value="">
</form:form>
