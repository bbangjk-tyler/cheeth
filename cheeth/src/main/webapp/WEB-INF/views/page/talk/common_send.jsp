<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:if test="${empty sessionInfo.user}">
  <script>
  alert(getI8nMsg("alert.plzlogin"));//'로그인 후 이용가능 합니다.'
   location.href = '/api/login/view';
</script>
</c:if>
<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>

<script>

  var fileArray = new Array();
  var sendUserList = new Array();

  function fnOpenTalk() {
    var userId = arguments[0];
    var userNickName = arguments[1];
    
    var div = $('#sendDiv');
    if(div.hasClass('hidden')) {
      div.removeClass('hidden');
    }
    
    sendUserList = new Array();
    sendUserList.push({USER_ID: userId, USER_NICK_NAME: userNickName});
    $('.send_note_receiver_blank_typo').html(userNickName);
    
    fileArray = new Array();
    $('.send_note_attatchment_container').removeClass('hidden').addClass('hidden');
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
  
  function fnSend() {
    
    if(isEmpty(sendUserList)) {
    	alert(getI8nMsg("alert.nExistRecip"));//받는사람이 존재하지 않습니다.
     	return;
   }
   
   var content = $('#CONTENT').val();
   if(isEmpty(content)) {
	 alert(getI8nMsg("alert.enterContent"));//내용을 입력해주세요.
     $('#CONTENT').focus();
     return;
   }
   
   var isConfirm = window.confirm(getI8nMsg("alert.confirm.sendNote"));//쪽지를 보내시겠습니까?
   if(!isConfirm) return;
   
   $('#RECEIVE_ID_LIST').val(JSON.stringify(sendUserList));
   
   var formData = new FormData(document.getElementById('sendForm'));
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
       fnDialogClose();
     }, complete: function() {
     }, error: function() {
       fnDialogClose();
     }
   });
  }
  
  function fnDialogClose() {
    
    var div = $('#sendDiv');
    if(!div.hasClass('hidden')) {
      div.addClass('hidden');
    }
    
    sendUserList = new Array();
    $('.send_note_receiver_blank_typo').html('');
    $('.send_note_attatchment_container').html('');
    
    $('#CONTENT').val('');
    
    fileArray = new Array();
    $('.send_note_attatchment_container').removeClass('hidden').addClass('hidden');
  }
  
  $(document).ready(function() {
    
  });
  
</script>

<div id="sendDiv" class="sample_dialog_root hidden">
  <form:form id="sendForm" name="sendForm">
    <input type="hidden" id="RECEIVE_ID_LIST" name="RECEIVE_ID_LIST">
    <div class="send_note_container">
      <div class="send_note_header">
        <p class="send_note_header_typo"><spring:message code="talk.sendMsg" text="쪽지 보내기" /></p>
        <a href="javascript:fnDialogClose();">
          <img class="send_note_dialog_close_button" src="/public/assets/images/send_note_dialog_close_button.svg"/>
        </a>
      </div>
      <div class="send_note_body">
        <div class="send_note_button_container">
          <a href="javascript:void(0);" class="send_note_send_button" onclick="fnSend();">
            <img class="send_note_send_button_icon" src="/public/assets/images/note_box_sending_icon.svg"/>
            <p class="send_note_send_button_typo"><spring:message code="talk.send" text="보내기" /></p>
          </a>
          <a href="javascript:void(0);" class="send_note_attatch_button" onclick="fnAddFile();">
            <p class="send_note_attatch_button_typo"><spring:message code="talk.attachF" text="파일첨부" /></p>
          </a>
        </div>
        <div class="send_note_attatchment_container hidden"></div>
        <div class="main_container_divider without_margin"></div>
        <div class="send_note_receiver">
          <p class="send_note_receiver_typo"><spring:message code="talk.receiver" text="받는사람" /></p>
          <div class="send_note_receiver_blank">
            <p class="send_note_receiver_blank_typo"></p>
          </div>
        </div>
        <textarea id="CONTENT" name="CONTENT" class="send_note_context" maxlength="1300"></textarea>
      </div>
    </div>
  </form:form>
</div>

<input style="display: none;" type="file" id="ADD_FILE" name="ADD_FILE" onchange="fnFileChange(this);">
