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
<c:if test="${sessionInfo.user.USER_TYPE_CD eq 1}">
  <script>
   alert(getI8nMsg("alert.nhaveAccess"));//접근 권한이 없습니다.
   history.back();
</script>
</c:if>
<c:if test="${sessionInfo.user.USER_TYPE_CD eq 2 && empty sessionInfo.user.COMP_FILE_CD}">
  <script>
   alert(getI8nMsg("alert.enterAddInfo"));//추가 정보를 입력하세요.
   history.back();
</script>
</c:if>
<link type="text/css" rel="stylesheet" href="/public/assets/css/vanillajs-datepicker/datepicker.min.css">
<link type="text/css" rel="stylesheet" href="/public/assets/css/dialog.css"/>
<script type="text/javascript" src="/js/vanillajs-datepicker/datepicker.min.js"></script>
<script type="text/javascript" src="/js/vanillajs-datepicker/locales/ko.js"></script>

<style>
  #datepickerInput,
  #datepickerInput::placeholder {
    color: #b6b6b6;
    font-size: 13px;
    font-weight: 400;
    width: 147px;
    height: 100%;
    margin-left: 15px;
  }
  .datepicker button {
    color: #363636 !important;
  }
</style>

<script>

  var sendUserList = new Array();
  var log = 0;
  function fnAllView() {
    location.href = '/' + API + '/project/project_view_all';
  }
  
  function fnCancel() {
    fnAllView();
  }
  
  function fnSave() {
    
    // 정합성 체크
    var projectCd = $('#PROJECT_CD').val();
    if(isEmpty(projectCd)) {
    	alert(getI8nMsg("alert.nselectProsth"));//선택된 보철물이 없습니다.
      	return;
    }
    
    var publicCd = $('#PUBLIC_CD').val();
    if(isEmpty(publicCd)) {
    	alert(getI8nMsg("alert.selectQuoMeth"));//지정 견적/공개 견적을 선택하세요.
      	return;
    }	
    
    var title = $('#TITLE').val();
    if(isEmpty(title)) {
      alert(getI8nMsg("alert.enterTitle"));//제목을 입력해주세요.
      $('#TITLE').focus();
      return;
    }
    
    var title = $('#TITLE').val();
    if(isEmpty(title)) {
      alert(getI8nMsg("alert.enterTitle"));//제목을 입력해주세요.
      $('#TITLE').focus();
      return;
    }
    
    var projectExpDate = $('#PROJECT_EXP_DATE').val();
    if(isEmpty(projectExpDate)) {
    	alert(getI8nMsg("alert.selectExpirTm"));//견적요청 만료시간을 선택하세요.
     	return;
    }
    
    var deliveryExpDate = $('#DELIVERY_EXP_DATE').val();
    var deliveryExpDate1 = $('#DELIVERY_EXP_DATE_1').val();
    var deliveryExpDate2 = $('#DELIVERY_EXP_DATE_2').val();
    if(isEmpty(deliveryExpDate) && (isEmpty(deliveryExpDate1) || isEmpty(deliveryExpDate2))) {
    	alert(getI8nMsg("alert.selectDeadln"));//납품 마감일을 선택 및 입력하세요.
      return;
    }
    
    var preferCd1 = $('#PREFER_CD_1').val();
    var preferCd2 = $('#PREFER_CD_2').val();
    var preferCd3 = $('#PREFER_CD_3').val();
    var preferCd4 = $('#PREFER_CD_4').val();
    
    var preferNm1 = $('#PREFER_NM_1').val();
    var preferNm2 = $('#PREFER_NM_2').val();
    var preferNm3 = $('#PREFER_NM_3').val();
    var preferNm4 = $('#PREFER_NM_4').val();
    
    var pCnt = 0;
    if(isNotEmpty(preferCd1) && (preferCd1 === preferCd2 || preferCd1 === preferCd3 || preferCd1 === preferCd4)) {
      pCnt++;
    }
    
    if(isNotEmpty(preferCd2) && (preferCd2 === preferCd1 || preferCd2 === preferCd3 || preferCd2 === preferCd4)) {
      pCnt++;
    }
    
    if(isNotEmpty(preferCd3) && (preferCd3 === preferCd1 || preferCd3 === preferCd2 || preferCd3 === preferCd4)) {
      pCnt++;
    }
    
    if(isNotEmpty(preferCd4) && (preferCd4 === preferCd1 || preferCd4 === preferCd2 || preferCd4 === preferCd3)) {
      pCnt++;
    }
    
    if(pCnt > 0) {
    	alert(getI8nMsg("alert.dupPrefCADSW"));//중복된 선호 CAD S/W가 존재 합니다.
      	return;
    }
    
    if(preferCd1 === 'R004' && isEmpty(preferNm1)) {
      alert(getI8nMsg("alert.enterOther"));//기타를 입력하세요.
      $('#PREFER_NM_1').focus();
      return;
    } else if(preferCd2 === 'R004' && isEmpty(preferNm2)) {
    	alert(getI8nMsg("alert.enterOther"));//기타를 입력하세요.
      $('#PREFER_NM_2').focus();
      return;
    } else if(preferCd3 === 'R004' && isEmpty(preferNm3)) {
    	alert(getI8nMsg("alert.enterOther"));//기타를 입력하세요.
      $('#PREFER_NM_3').focus();
      return;
    } else if(preferCd4 === 'R004' && isEmpty(preferNm4)) {
    	alert(getI8nMsg("alert.enterOther"));//기타를 입력하세요.
      $('#PREFER_NM_4').focus();
      return;
    }
    
    var isConfirm = window.confirm(getI8nMsg("alert.confirm.save")); //저장하시겠습니까?
    if(!isConfirm) return;
    
    if(isNotEmpty(preferCd1) && preferCd1 !== 'R004') $('#PREFER_NM_1').val(''); // 기타 아닐 경우
    if(isNotEmpty(preferCd2) && preferCd2 !== 'R004') $('#PREFER_NM_2').val('');
    if(isNotEmpty(preferCd3) && preferCd3 !== 'R004') $('#PREFER_NM_3').val('');
    if(isNotEmpty(preferCd4) && preferCd4 !== 'R004') $('#PREFER_NM_4').val('');
    
    var saveObj = getSaveObj('saveForm');
    
    $.ajax({
      url: '/' + API + '/project/save01',
      type: 'POST',
      data: saveObj,
      cache: false,
      async: false,
      success: function(data) {
    	console.log("projectNo ${DATA.PROJECT_NO}");
    	console.log("result " + data.result);
    	
        fnAllView();
      }, complete: function() {
      }, error: function() {
      }
    });
  }
  
  function fnSelect_1() {
    var code = arguments[0];
    var codeNm = arguments[1];
    var target = $('#PROJECT_CD_DIV_2');
    if(target.hasClass('hidden')) {
      target.removeClass('hidden');
    } else {
      target.addClass('hidden');
    } 
    
    if(isNotEmpty(code)) {
      $('#PROJECT_CD_DIV_1').find('p').html(codeNm);
      $('#PROJECT_CD').val(code);
    }
  }
  
  function fnSelect_2() {
    var code = arguments[0];
    var codeNm = arguments[1];
    var target = $('#PUBLIC_CD_DIV_2');
    if(target.hasClass('hidden')) {
      target.removeClass('hidden');
    } else {
      target.addClass('hidden');
    }
    
    if(isNotEmpty(code)) {
      $('#PUBLIC_CD_DIV_1').find('p').html(codeNm);
      $('#PUBLIC_CD').val(code);
      if(code === 'U001') {
    	  if(sendUserList && sendUserList.length > 0) $('.quote_list').removeClass('hidden');
        fnOpenAdress();
      } else {
        $('.quote_list').addClass('hidden');
      }
    }
  }
  
  function fnSelect_3() {
    var code = arguments[0];
    var codeNm = arguments[1];
    var target = $('#TIME_CD_DIV_2');
    if(target.hasClass('hidden')) {
      target.removeClass('hidden');
    } else {
      target.addClass('hidden');
    } 
    
    if(isNotEmpty(code)) {
      $('#TIME_CD_DIV_1').find('p').html(codeNm);
      $('#DELIVERY_EXP_DATE_2').val(code);
    }
  }
  
  function fnSelect_4() {
    var index = arguments[0];
    var code = arguments[1];
    var codeNm = arguments[2];
    var target = $('#' + 'PREFER_CD_DIV_' + index + '_2');
    if(target.hasClass('hidden')) {
      target.removeClass('hidden');
    } else {
      target.addClass('hidden');
    } 
    
    if(isNotEmpty(code)) {
    	$('#' + 'PREFER_CD_DIV_' + index + '_1').find('p').html(codeNm);
      $('#PREFER_CD_' + index).val(code);
      if(code === 'R004') { // 기타
        $('#PREFER_NM_' + index).focus();
      } else {
        $('#PREFER_NM_' + index).val('');
      }
    }
  }
  
  function fnSetPjtExpDate() {
    $('#PROJECT_EXP_DATE').val(arguments[0]);
    $('.equipment_estimator_writing_info_date_expiry_typo').html(arguments[1]);
  }
  
  function fnMoveBasket() {
    var gsc = '${GCS}';
    var projectNo = '${PROJECT_NO}';
    var url = '/' + API + '/tribute/request_basket';
    if(isNotEmpty(projectNo)) {
      url += '?PROJECT_NO=' + projectNo;
    }
    if(isEmpty(gsc)) {
      location.href = url;
    } else {
      var isConfirm = window.confirm(getI8nMsg("alert.confirm.moveBasket"));//의뢰서 바구니로 이동 됩니다. 계속 하시겠습니까?\n저장되지 않는 데이터는 사라집니다.
      
      if(!isConfirm) return;
      location.href = url;
    }
  }
  
  function fnSetReqInfo() {
    var gsc = '${GCS}';
    if(isEmpty(gsc)) {
      setTimeout(() => {
    	alert(getI8nMsg("alert.moveReqB")); ;//견적요청할 의뢰서를 선택하기 위해 의뢰서바구니로 이동됩니다.
        setTimeout(() => {
          fnMoveBasket();
        }, 1000);
      }, 100);
    } else {
    	gsc.split('l').map((groupCd, index) => {
        var pantNm;
        var totalCnt;
        var rtnArray = new Array();
        $.ajax({
          url: '/' + API + '/project/getSuppInfo',
          type: 'GET',
          data: { GROUP_CD : groupCd },
          cache: false,
          async: false,
          success: function(data) {
            rtnArray = data;
            var html = '';
            html += '<div class="project_request_writing_info_item">';
            html += '  <div class="project_request_request">';
            html += '    <p class="project_request_request_typo_title">의뢰서' + (index + 1) + '</p>';
            html += '    <p class="project_request_request_typo_title">' + rtnArray[0]['PANT_NM'] + '</p>';
            html += '    <p class="project_request_request_typo_context">';
            rtnArray.map(m => {
              html += m.SUPP_NM + ' ' + m.CNT + '개, ';
            });
            html = html.substring(0, html.lastIndexOf(','));
            html += '    </p>';
            html += '  </div>';
            html += '</div>';
            $('.project_request_writing_info_container').append(html);
          }, complete: function() {
          }, error: function() {
          }
        });
      });
    }
  }
  
  function fnOpenAdress() {
    fnDialogClose();
    var div = $('#adressDiv');
    if(div.hasClass('hidden')) {
      div.removeClass('hidden');
    }
  }
  
  function fnDialogClose() {
    var div1 = $('#adressDiv');
    if(!div1.hasClass('hidden')) {
      div1.addClass('hidden');
    }
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
  
  function fnAdressOk() {
	  sendUserList = new Array();
	  $('.address_list_receiver_name_container > p').each(function(k,v) {
	    //if($(v).hasClass('address_list_name_selected') || $(v).hasClass('address_list_name')) {
	      var userId = $(v).data('user-id');
	      var nickName = $(v).data('nick-name');
	      sendUserList.push({USER_ID: userId.toString(), USER_NICK_NAME: nickName.toString()});
	      console.log("들어옴");
	    //}
	  });
	  if(sendUserList.length > 0) {
	    var reStr = '';
	    for(var i=0; i<sendUserList.length; i++) {
	      if(reStr.length === 0) {
	        reStr = sendUserList[i].USER_NICK_NAME;
	      } else {
	        reStr += ',' + sendUserList[i].USER_NICK_NAME;
	      }
	    }
	    console.log("reStr " + reStr);
	    reStr = '<p>' + reStr + '</p>';
	    $('.quote_list').html(reStr);
	    $('.quote_list').removeClass('hidden');
	    $('#RECEIVE_ID_LIST').val(JSON.stringify(sendUserList));
	    
	  }
	  fnDialogClose();
	}
 
  function fnAdressCancel() {
    fnDialogClose();
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
  
  $(document).ready(function() {
    
    fnSetReqInfo();
    
    const datepickerEl = document.querySelector('#datepickerInput');
    const datepicker = new Datepicker(datepickerEl, {
      language : 'ko',
      format : 'yyyy-mm-dd',
      autohide : true
    });
    
    $('.project_request_calendar_image').click(function() {
      datepicker.show();
    });
    
    datepickerEl.addEventListener('changeDate', function(e) {
      var date = datepicker.getDate('yyyy-mm-dd');
      $('input[id=DELIVERY_EXP_DATE_1]').val(date);
      $("#date_for_chk").text(date);
      CheckDate();
    });
    
    if(isNotEmpty('${DATA.PROJECT_NO}')) {
      $('#PROJECT_CD_DIV_1').find('p').html('${DATA.PROJECT_NM}');
      $('#PUBLIC_CD_DIV_1').find('p').html('${DATA.PUBLIC_NM}');
      $('.equipment_estimator_writing_info_date_expiry_typo').html('${DATA.PROJECT_EXP_DATE2}');
      $('#TIME_CD_DIV_1').find('p').html('${DATA.DELIVERY_EXP_DATE3}');
      var select = getI8nMsg("select"); //선택
      var preferNm1 = isEmpty('${DATA.PREFER_CD_NM_1}') ? select : '${DATA.PREFER_CD_NM_1}';
      var preferNm2 = isEmpty('${DATA.PREFER_CD_NM_2}') ? select : '${DATA.PREFER_CD_NM_2}';
      var preferNm3 = isEmpty('${DATA.PREFER_CD_NM_3}') ? select : '${DATA.PREFER_CD_NM_3}';
      var preferNm4 = isEmpty('${DATA.PREFER_CD_NM_4}') ? select : '${DATA.PREFER_CD_NM_4}';
      $('#PREFER_CD_DIV_1_1').find('p').html(preferNm1);
      $('#PREFER_CD_DIV_2_1').find('p').html(preferNm2);
      $('#PREFER_CD_DIV_3_1').find('p').html(preferNm3);
      $('#PREFER_CD_DIV_4_1').find('p').html(preferNm4);
      
      $('input[id=DELIVERY_EXP_DATE_1]').val('${DATA.DELIVERY_EXP_DATE2}');
      $('input[id=datepickerInput]').val('${DATA.DELIVERY_EXP_DATE2}');
      
      var publicCd = $('#PUBLIC_CD').val();
      var appointUser = '${DATA.APPOINT_USER}';
      
      var appointUser_indi;
      if(appointUser.includes(",")){
          appointUser_indi = appointUser.split(",");  
    	  console.log("appointUser_indi0 " + appointUser_indi[0]);
    	  console.log("appointUser_indi1 " + appointUser_indi[1]);
      }
	
      if(publicCd === 'U001' && isNotEmpty(appointUser)) {
    	  $('.quote_list').html('<p>' + appointUser + '</p>');
    	  if(appointUser.includes(",")){
    		  for(var i = 0;i < appointUser_indi.length; i++){
    			  var datauserid = $("p[data-nick-name='"+appointUser_indi[i]+"']").attr("data-user-id");
        	      var htttml = '<p class="address_list_receiver_name" style="cursor: pointer;" data-user-id="'+ datauserid +'" data-nick-name="'+appointUser_indi[i]+'" onclick="fnAdressSelect2(this);">'+appointUser_indi[i]+'</p>';
            	  $(".address_list_receiver_name_container").append(htttml);    		      			  
    		  }
    	  }else{
    		  var datauserid = $("p[data-nick-name='"+appointUser+"']").attr("data-user-id");
    	      var htttml = '<p class="address_list_receiver_name" style="cursor: pointer;" data-user-id="'+ datauserid +'" data-nick-name="'+appointUser+'" onclick="fnAdressSelect2(this);">'+appointUser+'</p>';
        	  $(".address_list_receiver_name_container").html(htttml);    		  
    	  }

        $('.quote_list').removeClass('hidden');
        
      } else {
        $('.quote_list').addClass('hidden');
      }
    }else{//수정
    	
    	log = 1;
    	
		 console.log("ggggg");
		 setTimeout(function(){
			 console.log("wwww");
			 $(".equipment_estimator_writing_info_date_expiry_typo").html(getI8nMsg("proj.estimReq")); //견적요청 만료시간     
         }, 100);

    }
    
  });

</script>
<div id="date_for_chk" onchange="CheckDate()" style="opacity:0;position:absolute;z-index:-1;"></div>
        <script>
        var okbool = 0;
        $('#datepickerInput').change( function() {
            alert('Change!');
            CheckDate();

        });

        function CheckDate(){
           var args = $("#DELIVERY_EXP_DATE_1").val();
         args = args.replaceAll("-", "");
           
           var today = new Date();
           var year = today.getFullYear();
           var month = ('0' + (today.getMonth() + 1)).slice(-2);
           var day = ('0' + today.getDate()).slice(-2);
           
           
           if(ccyear == ""){
        	   ccyear = year;
           }
           if(ccmonth == ""){
        	   ccmonth = month;
           }
		   if(ccday == ""){
			   ccday = day;
           }
		   console.log("ccyear " + ccyear);
		   console.log("ccmonth " + ccmonth);
		   console.log("ccday " + ccday);
		   
           console.log(args);
           var toDayStr = year + month + day;
           if(args <= toDayStr){
             okbool =0;
             alert(getI8nMsg("alert.selectAfQuotT"));//견적만료시간 이후 날짜를 선택해주세요.
            var div = $(".datepicker-cell.day.selected.focused");
            console.log("div.length " + div.length);
            setTimeout(function(){
                $(div).removeClass("selected");
                $(div).removeClass("focused");               
            }, 100);

            $("#datepickerInput").val("");
             return false;
           }
           okbool = 1;
           return true;
         }
        var picdate = "";
       $(".datepicker-grid").click(function(){
          alert('gg');
          var curpicdate = $("#DELIVERY_EXP_DATE_1").val();
          if(curpicdate != picdate){
             picdate = curpicdate;
             CheckDate();
          }
       });
        </script>
<div class="project_header">
  <p class="project_header_typo"><spring:message code="proj.writeProj" text="프로젝트 작성하기" /></p>
</div>

<div class="project_body">
  <div class="side_menu">
    <div class="side_menu_title" style="cursor: pointer;" onclick="fnAllView();">
      <p class="side_menu_title_typo"><spring:message code="main.seeAll" text="전체보기" /></p>
    </div>
    <c:forEach var="item" items="${PROJECT_CD_LIST}" varStatus="status">
      <a href="/${api}/project/project_view_all?SEARCH_PROJECT_CD=${item.CODE_CD}" class="side_menu_list">
        <img class="side_menu_list_point" src="/public/assets/images/side_menu_list_point.svg"/>
        <p class="side_menu_list_typo">${item.CODE_NM}</p>
      </a>
    </c:forEach>
  </div>
  <form:form id="saveForm" name="saveForm">
    <input type="hidden" id="PROJECT_NO" name="PROJECT_NO" value="${DATA.PROJECT_NO}">
    <input type="hidden" id="PROJECT_CD" name="PROJECT_CD" value="${DATA.PROJECT_CD}">
    <input type="hidden" id="PUBLIC_CD" name="PUBLIC_CD" value="${DATA.PUBLIC_CD}">
    <input type="hidden" id="PROJECT_EXP_DATE" name="PROJECT_EXP_DATE" value="${DATA.PROJECT_EXP_DATE}">
    <input type="hidden" id="DELIVERY_EXP_DATE" name="DELIVERY_EXP_DATE" value="${DATA.DELIVERY_EXP_DATE}">
    <input type="hidden" id="DELIVERY_EXP_DATE_1" name="DELIVERY_EXP_DATE_1" value="">
    <input type="hidden" id="DELIVERY_EXP_DATE_2" name="DELIVERY_EXP_DATE_2" value="">
    <input type="hidden" id="PREFER_CD_1" name="PREFER_CD_1" value="${DATA.PREFER_CD_1}">
    <input type="hidden" id="PREFER_CD_2" name="PREFER_CD_2" value="${DATA.PREFER_CD_2}">
    <input type="hidden" id="PREFER_CD_3" name="PREFER_CD_3" value="${DATA.PREFER_CD_3}">
    <input type="hidden" id="PREFER_CD_4" name="PREFER_CD_4" value="${DATA.PREFER_CD_4}">
    <input type="hidden" id="REQS" name="REQS" value="${REQS}">
    <input type="hidden" id="RECEIVE_ID_LIST" name="RECEIVE_ID_LIST" value="">
    
    <div class="project_request_main_container">
      <div class="project_connection_location_container">
        <a href="/" class="project_connection_location_typo">
          <img class="project_connection_location_home_button" src="/public/assets/images/connection_loaction_home_button.svg"/>
        </a>
        <img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
        <div class="project_connection_location">
          <p class="project_connection_location_typo"><spring:message code="header.project" text="프로젝트 보기" /></p>
        </div>
        <img class="project_connection_location_arrow" src="/public/assets/images/connection_location_arrow.svg"/>
        <div class="project_connection_location">
          <p class="project_connection_location_typo_bold"><spring:message code="proj.writeProj" text="프로젝트 작성하기" /></p>
        </div>
      </div>
      <div class="connection_location_divider"></div>
      <div class="project_request_writing_info_wrapper">
        <div class="project_request_writing_info_sub_container">
          <div class="dropbox_project_request_select_board">
            <div class="dropbox_select_button_large">
              <div id="PROJECT_CD_DIV_1" class="dropbox_select_button_typo_container" onclick="fnSelect_1();" style="cursor: pointer;">
                <p class="dropbox_select_button_typo"><spring:message code="proj.selectProsyh" text="보철물 선택" /></p>
                <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
              </div>
            </div>
            <div id="PROJECT_CD_DIV_2" class="dropbox_select_button_item_container_select_board hidden" style="cursor: pointer;">
              <c:forEach var="item" items="${PROJECT_CD_LIST}" varStatus="status">
                <div class="dropbox_select_button_item_large" onclick="fnSelect_1('${item.CODE_CD}', '${item.CODE_NM}')">
                  <p class="dropbox_select_button_item_typo">${item.CODE_NM}</p>
                </div>
              </c:forEach>
            </div>
          </div>
          <div class="dropbox_project_request_quote_type">
            <div class="dropbox_select_button_large">
              <div id="PUBLIC_CD_DIV_1" class="dropbox_select_button_typo_container" onclick="fnSelect_2();" style="cursor: pointer;">
                <p class="dropbox_select_button_typo"><spring:message code="" text="지정 견적 / 공개 견적" /></p>
                <img class="project_request_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
              </div>
            </div>
            <div id="PUBLIC_CD_DIV_2" class="dropbox_select_button_item_container hidden" style="cursor: pointer;">
              <c:forEach var="item" items="${PUBLIC_CD_LIST}" varStatus="status">
                <div class="dropbox_select_button_item_large" onclick="fnSelect_2('${item.CODE_CD}', '${item.CODE_NM}')">
                  <p class="dropbox_select_button_item_typo">${item.CODE_NM}</p>
                </div>
              </c:forEach>
            </div>
          </div>
        </div>
        <!-- 지정견적 선택 리스트 -->
        <div class="quote_list hidden"></div>
        <!-- //지정견적 선택 리스트 -->
        <div class="equipment_estimator_writing_info_sub_container">
          <input id="TITLE" name="TITLE" class="equipment_estimator_writing_info_title" maxlength="50" placeholder="<spring:message code="proj.enter.title" text="제목입력" />" value="${DATA.TITLE}">
          <div class="equipment_estimator_writing_info_date_expiry">
            <p class="equipment_estimator_writing_info_date_expiry_typo"><spring:message code="proj.estimReq" text="견적요청 만료시간" /></p>
          </div>
          <a href="javascript:fnDateDialogOpen();" class="equipment_estimator_writing_info_date_expiry_button">
            <p class="equipment_estimator_writing_info_date_expiry_button_typo"><spring:message code="proj.selectDT" text="시간선택하기" /></p>
          </a>
        </div>
        <div class="project_request_writing_info_main_container">
          <div class="project_request_writing_info_intro">
            <p class="project_request_writing_info_intro_typo">
              <strong>[필독]</strong> 게시글 제목에 의뢰하시는 보철물 종류와 개수를 쓰시면 정확한 견적에 도움이 됩니다.<br/>예) 크라운3 커스텀어버트 3 / 상악 프레임
            </p>
          </div>
          <div class="project_request_writing_info_item_container">
            <div class="request_basket_info_container" style="display: flex;">
              <a href="javascript:fnMoveBasket();" class="project_request_move_button" style="height: 38px; color: #0083e8; font-size: 13px; font-weight: 500;"><spring:message code="req.reqCart" text="의뢰서 바구니가기" /></a>
              <div class="project_request_writing_info_container" style="width: 670px;"></div>
            </div>
            <div class="main_container_divider"></div>
            <div class="project_request_writing_info_item">
              <p class="project_request_writing_info_item_typo"><spring:message code="proj.delivDl" text="납품 마감일" /></p>
               <div class="project_request_select_button_container">
                <div class="dropbox_project_request_calendar">
                  <div id="datepickerContainer" class="dropbox_select_button">
                    <input id="datepickerInput" type="text" placeholder="<spring:message code="proj.date" text="날짜선택" />" style="cursor: pointer;" autocomplete="off">
                    <img class="project_request_calendar_image" src="/public/assets/images/calendar_image.svg" style="cursor: pointer;"/>
                  </div>
                </div>
                <div class="dropbox_project_request_time">
                  <div class="dropbox_select_button">
                    <div id="TIME_CD_DIV_1" class="dropbox_select_button_typo_container" onclick="fnSelect_3();" style="cursor: pointer;">
                      <p class="dropbox_select_button_typo"><spring:message code="proj.time" text="시간" /></p>
                      <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
                    </div>
                  </div>
                  <div id="TIME_CD_DIV_2" class="dropbox_project_request_select_button_item_container_time hidden" style="cursor: pointer;">
                    <c:forEach var="item" items="${TIME_CD_LIST}" varStatus="status">
                      <div class="dropbox_select_button_item_small" onclick="fnSelect_3('${item.CODE_CD}', '${item.CODE_NM}')">
                        <p class="dropbox_select_button_item_typo">${item.CODE_NM}</p>
                      </div>
                    </c:forEach>
                  </div>
                </div>
              </div>
            </div>
            <div class="project_request_writing_info_item">
              <p class="project_request_writing_info_item_typo"><spring:message code="proj.preferCADSW" text="선호 CAD S/W" /></p>
              <div class="project_request_select_button_container">
                <div class="dropbox_project_request_preference">
                  <div class="dropbox_select_button">
                    <div id="PREFER_CD_DIV_1_1" class="dropbox_select_button_typo_container" onclick="fnSelect_4('1');" style="cursor: pointer;">
                      <p class="dropbox_select_button_typo"><spring:message code="select" text="선택" /></p>
                      <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
                    </div>
                  </div>
                  <div id="PREFER_CD_DIV_1_2" class="dropbox_select_button_item_container hidden" style="cursor: pointer;">
                    <c:forEach var="item" items="${PREFER_CD_LIST}" varStatus="status">
                      <div class="dropbox_select_button_item" onclick="fnSelect_4('1', '${item.CODE_CD}', '${item.CODE_NM}')">
                        <p class="dropbox_select_button_item_typo">${item.CODE_NM}</p>
                      </div>
                    </c:forEach>
                  </div>
                </div>
              </div>
              <div class="project_request_writing_info_underline_box">
                <input type="text" id="PREFER_NM_1" name="PREFER_NM_1" maxlength="100" value="${DATA.PREFER_NM_1}">
              </div>
            </div>
            <div class="project_request_writing_info_item">
              <p class="project_request_writing_info_item_typo"></p>
              <div class="project_request_select_button_container">
                <div class="dropbox_project_request_preference">
                  <div class="dropbox_select_button">
                    <div id="PREFER_CD_DIV_2_1" class="dropbox_select_button_typo_container" onclick="fnSelect_4('2');" style="cursor: pointer;">
                      <p class="dropbox_select_button_typo"><spring:message code="select" text="선택" /></p>
                      <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
                    </div>
                  </div>
                  <div id="PREFER_CD_DIV_2_2" class="dropbox_select_button_item_container hidden" style="cursor: pointer;">
                    <c:forEach var="item" items="${PREFER_CD_LIST}" varStatus="status">
                      <div class="dropbox_select_button_item" onclick="fnSelect_4('2', '${item.CODE_CD}', '${item.CODE_NM}')">
                        <p class="dropbox_select_button_item_typo">${item.CODE_NM}</p>
                      </div>
                    </c:forEach>
                  </div>
                </div>
              </div>
              <div class="project_request_writing_info_underline_box">
                <input type="text" id="PREFER_NM_2" name="PREFER_NM_2" maxlength="100" value="${DATA.PREFER_NM_2}">
              </div>
            </div>
            <div class="project_request_writing_info_item project_request_detail">
              <p class="project_request_writing_info_item_typo"><spring:message code="proj.addCont" text="추가내용" /></p>
              <textarea id="ADD_CONTENT" name="ADD_CONTENT" class="project_request_writing_info_detail_blank" maxlength="1300" placeholder="<spring:message code='proj.enter.detail' text='상세내용을 적어주세요' />">${DATA.ADD_CONTENT}</textarea>
            </div>
          </div>
        </div>
        <div class="project_request_writing_info_button_container">
          <a href="javascript:fnSave();" class="project_request_writing_info_button_right_submit">
            <p class="project_request_writing_info_button_right_submit_typo"><spring:message code="submit" text="글쓰기" /></p>
          </a>
        </div>
      </div>
    </div>
  </form:form>
</div>

<div id="adressDiv" class="sample_dialog_root hidden">
  <div class="address_list_container">
    <div class="address_list_header">
      <p class="address_list_header_typo"><spring:message code="talk.address" text="주소록" /></p>
      <a href="javascript:fnDialogClose();" class="address_list_close_button_wrapper">
        <img  class="address_list_close_button" src="/public/assets/images/send_note_dialog_close_button.svg"/>
      </a>
    </div>
    <div class="address_list_body">
      <div class="address_list_total_trader">
        <div class="address_list_total_trader_typo_container">
          <p class="address_list_total_trader_title"><spring:message code="" text="전체 거래자" /></p>
          <p class="address_list_total_trader_context">${USER_CNT}</p>
        </div>
      </div>
      <div class="address_list_main_container">
        <div class="address_list_search">
          <input type="text" class="address_list_search_blank" id="findNickName" maxlength="30" placeholder="<spring:message code="proj.findUserNm" text="닉네임 찾기" />">
          <button class="address_list_search_button" onclick="fnFindNickName();">
            <p class="address_list_search_button_typo"><spring:message code="search" text="찾기" /></p>
          </button>
        </div>
        <div class="dialog_main_container_divider"></div>
        <div class="address_list_name_container">
          <c:forEach var="item" items="${USER_LIST}" varStatus="status">
            <p class="address_list_name" 
               style="cursor: pointer;"
               data-user-id="${item.USER_ID}"
               data-nick-name="${item.USER_NICK_NAME}"
               onclick="fnAdressSelect1(this);">${item.USER_NICK_NAME}</p>
          </c:forEach>
        </div>
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
          <p class="address_list_receiver_title"><spring:message code="" text="받는사람" /></p>
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
          <p class="address_list_button_typo"><spring:message code="ok" text="확인" /></p>
        </a>
        <a href="javascript:fnAdressCancel();" class="address_list_button">
          <p class="address_list_button_typo"><spring:message code="cancel" text="취소" /></p>
        </a>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/dialog/date_dialog.jsp" flush="false">
  <jsp:param name="callback" value="fnSetPjtExpDate" />
</jsp:include>
