<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%
  String callback = request.getParameter("callback");
%>
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
<script>
  
  function fnDateDialogOpen() {
    var div1 = $('#dateDialogDiv');
    if(div1.hasClass('hidden')) {
      div1.removeClass('hidden');
    }
  }
  
  function fnDateDialogClose() {
    var div1 = $('#dateDialogDiv');
    if(!div1.hasClass('hidden')) {
      div1.addClass('hidden');
    }
  }
  
  function fnDateDialogSelect_1() {
    var code = arguments[0];
    var codeNm = arguments[1];
    var target = $('#YYYY_DIV_2');
    if(target.hasClass('hidden')) {
      target.removeClass('hidden');
    } else {
      target.addClass('hidden');
    }
    
    if(isNotEmpty(code)) {
      $('#YYYY_DIV_1').find('p').html(codeNm);
      $('#DIALOG_YYYY').val(code);
    }
  }
  
  function fnDateDialogSelect_2() {
    var code = arguments[0];
    var codeNm = arguments[1];
    var target = $('#MM_DIV_2');
    if(target.hasClass('hidden')) {
      target.removeClass('hidden');
    } else {
      target.addClass('hidden');
    }
    
    if(isNotEmpty(code)) {
      $('#MM_DIV_1').find('p').html(codeNm);
      $('#DIALOG_MM').val(code);
      
      // 일자
      var yaer = $('#DIALOG_YYYY').val();
      if(isNotEmpty(yaer)) {
        var cnt = 30;
        if(code === '01' || code === '03' || code === '05' || code === '07' || code === '08' || code === '10' || code === '12') {
          cnt = 31
        } else if(code === '02') {
          cnt = 28;
          if( (yaer%4 === 0 && yaer%100 !== 0) || yaer%400 === 0 ) {
            cnt = 29;
          }
        }
        var html = ``;
        for(var i=0; i<cnt; i++) {
          if(i < 9) {
            var code = ('0' + (i+1));
            var codeNm = ('0' + (i+1)) + '일';
            html += `<div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_3('` + code +`', '` + codeNm + `')">`;
            html += `<p class="dropbox_select_button_item_typo">` + ('0' + (i+1)) + '일' + `</p>`;
          } else {
            var code = (i+1);
            var codeNm = (i+1) + '일';
        	  html += `<div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_3('` + code +`', '` + codeNm + `')">`;
            html += `<p class="dropbox_select_button_item_typo">` + (i+1) + '일' + `</p>`;
          }
          html += `</div>`;
        }
        $('#DD_DIV_2').html(html);
      }
    }
  }
  
  function fnDateDialogSelect_3() {
    var code = arguments[0];
    var codeNm = arguments[1];
    var target = $('#DD_DIV_2');
    if(target.hasClass('hidden')) {
      target.removeClass('hidden');
    } else {
      target.addClass('hidden');
    } 
    
    if(isNotEmpty(code)) {
      $('#DD_DIV_1').find('p').html(codeNm);
      $('#DIALOG_DD').val(code);
    }
  }
  
  function fnDateDialogSelect_4() {
	  var code = arguments[0];
	    var codeNm = arguments[1];
	    var target = $('#TTMM_DIV_2');
	    if(target.hasClass('hidden')) {
	      target.removeClass('hidden');
	    } else {
	      target.addClass('hidden');
	    }
	    
	    if(isNotEmpty(code)) {
	      $('#TTMM_DIV_1').find('p').html(codeNm);
	      $('#DIALOG_TTMM').val(code);
	    }
  }
  
  function fnDateDialogSearch() {
    $.ajax({
      url: '/' + API + '/common/getCode',
      type: 'GET',
      data: { GROUP_CD: 'YYYY_CD' },
      cache: false,
      async: false,
      success: function(data) {
        var html = ``;
        for(var i=0; i<data.length; i++) {
          html += `<div class="dropbox_select_button_item_large" onclick="fnDateDialogSelect_1('` + data[i].CODE_CD +`', '` + data[i].CODE_NM + `')">`;
          html += `<p class="dropbox_select_button_item_typo">` + data[i].CODE_NM + `</p>`;
          html += `</div>`;
        }
        $('#YYYY_DIV_2').html(html);
      }
    });
  }
  
  function fnDateDialogSave() {
    var yyyy = $('#DIALOG_YYYY').val();
    var mm = $('#DIALOG_MM').val();
    var dd = $('#DIALOG_DD').val();
    var ttmm = isEmpty($('#DIALOG_TTMM').val()) ? '0000' : $('#DIALOG_TTMM').val();
    var is = fnIsValidDate(yyyy + mm + dd);
    if(is) {
      var callback = '<%= callback %>';
      if(isNotEmpty(callback)) {
        var date = yyyy + '년 ' + mm + '월 ' + dd + '일 ' + ttmm.substring(0,2) + '시 ' + ttmm.substring(2,4) + '분';
    	  eval(callback + `(` + (yyyy + mm + dd + ttmm) + `,` + `'` + date + `'` + `)` );
    	  
    	  if(fnIsCheckDate(yyyy + mm + dd)){
	        fnDateDialogClose();
    	  }else{
    		  alert('미래 일자를 선택해 주시기 바랍니다.');
    	  }
      }
    } else {
      alert('선택한 일자가 올바르지 않습니다.');
    }
  }
  
  $(document).ready(function() {
    
    fnDateDialogSearch();
    
  });
  
</script>

<div id="dateDialogDiv" class="sample_dialog_root hidden">
  <div class="dropbox_date_expiry_dialog">
    <div class="dropbox_date_expiry_dialog_header">
      <p class="dropbox_date_expiry_dialog_header_typo">견적요청 만료시간</p>
      <a href="javascript:fnDateDialogClose();">
        <img class="dropbox_date_expiry_dialog_close_button" src="/public/assets/images/dialog_close_button.svg"/>
      </a>
    </div>
    <div class="dropbox_date_expiry_dialog_body">
      <div class="dropbox_date_expiry_dialog_select_button_container">
        <div class="dropbox_year">
          <div id="YYYY_DIV_1" class="dropbox_select_button" onclick="fnDateDialogSelect_1();" style="cursor: pointer;">
            <div class="dropbox_select_button_typo_container">
              <p class="dropbox_select_button_typo">YYYY</p>
              <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
            </div>
          </div>
          <div id="YYYY_DIV_2" class="dropbox_select_button_item_container_year hidden" style="cursor: pointer;"></div>
        </div>
        <div class="dropbox_month">
          <div id="MM_DIV_1" class="dropbox_select_button" onclick="fnDateDialogSelect_2();" style="cursor: pointer;">
            <div class="dropbox_select_button_typo_container">
              <p class="dropbox_select_button_typo">MM</p>
              <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
            </div>
          </div>
          <div id="MM_DIV_2" class="dropbox_select_button_item_container_month hidden" style="cursor: pointer;">
            <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('01', '01월')">
              <p class="dropbox_select_button_item_typo">01월</p>
            </div>
            <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('02', '02월')">
              <p class="dropbox_select_button_item_typo">02월</p>
            </div>
            <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('03', '03월')">
              <p class="dropbox_select_button_item_typo">03월</p>
            </div>
            <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('04', '04월')">
              <p class="dropbox_select_button_item_typo">04월</p>
            </div>
            <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('05', '05월')">
              <p class="dropbox_select_button_item_typo">05월</p>
            </div>
            <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('06', '06월')">
              <p class="dropbox_select_button_item_typo">06월</p>
            </div>
            <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('07', '07월')">
              <p class="dropbox_select_button_item_typo">07월</p>
            </div>
            <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('08', '08월')">
              <p class="dropbox_select_button_item_typo">08월</p>
            </div>
            <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('09', '09월')">
              <p class="dropbox_select_button_item_typo">09월</p>
            </div>
            <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('10', '10월')">
              <p class="dropbox_select_button_item_typo">10월</p>
            </div>
            <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('11', '11월')">
              <p class="dropbox_select_button_item_typo">11월</p>
            </div>
            <div class="dropbox_select_button_item_small" onclick="fnDateDialogSelect_2('12', '12월')">
              <p class="dropbox_select_button_item_typo">12월</p>
            </div>
          </div>
      </div>
      <div class="dropbox_date">
        <div id="DD_DIV_1" class="dropbox_select_button" onclick="fnDateDialogSelect_3();" style="cursor: pointer;">
          <div class="dropbox_select_button_typo_container">
            <p class="dropbox_select_button_typo">DD</p>
            <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
          </div>
        </div>
        <div id="DD_DIV_2" class="dropbox_select_button_item_container_date hidden"  style="cursor: pointer;"></div>
      </div>
      <div class="dropbox_time">
        <div id="TTMM_DIV_1" class="dropbox_select_button" onclick="fnDateDialogSelect_4();" style="cursor: pointer;">
          <div class="dropbox_select_button_typo_container">
            <p class="dropbox_select_button_typo">TT:MM</p>
            <img class="dropbox_select_button_arrow" src="/public/assets/images/info_select_button_arrow.svg"/>
          </div>
        </div>
        <div id="TTMM_DIV_2" class="dropbox_select_button_item_container_time hidden" style="cursor: pointer;">
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('0900', '09:00')">
            <p class="dropbox_select_button_item_typo">09:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('0930', '09:30')">
            <p class="dropbox_select_button_item_typo">09:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1000', '10:00')">
            <p class="dropbox_select_button_item_typo">10:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1030', '10:30')">
            <p class="dropbox_select_button_item_typo">10:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1100', '11:00')">
            <p class="dropbox_select_button_item_typo">11:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1130', '11:30')">
            <p class="dropbox_select_button_item_typo">11:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1200', '12:00')">
            <p class="dropbox_select_button_item_typo">12:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1230', '12:30')">
            <p class="dropbox_select_button_item_typo">12:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1300', '13:00')">
            <p class="dropbox_select_button_item_typo">13:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1330', '13:30')">
            <p class="dropbox_select_button_item_typo">13:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1400', '14:00')">
            <p class="dropbox_select_button_item_typo">14:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1430', '14:30')">
            <p class="dropbox_select_button_item_typo">14:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1500', '15:00')">
            <p class="dropbox_select_button_item_typo">15:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1530', '15:30')">
            <p class="dropbox_select_button_item_typo">15:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1600', '16:00')">
            <p class="dropbox_select_button_item_typo">16:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1630', '16:30')">
            <p class="dropbox_select_button_item_typo">16:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1700', '17:00')">
            <p class="dropbox_select_button_item_typo">17:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1730', '17:30')">
            <p class="dropbox_select_button_item_typo">17:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1800', '18:00')">
            <p class="dropbox_select_button_item_typo">18:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1830', '18:30')">
            <p class="dropbox_select_button_item_typo">18:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1900', '19:00')">
            <p class="dropbox_select_button_item_typo">19:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('1930', '19:30')">
            <p class="dropbox_select_button_item_typo">19:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2000', '20:00')">
            <p class="dropbox_select_button_item_typo">20:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2030', '20:30')">
            <p class="dropbox_select_button_item_typo">20:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2100', '21:00')">
            <p class="dropbox_select_button_item_typo">21:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2130', '21:30')">
            <p class="dropbox_select_button_item_typo">21:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2200', '22:00')">
            <p class="dropbox_select_button_item_typo">22:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2230', '22:30')">
            <p class="dropbox_select_button_item_typo">22:30</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2300', '23:00')">
            <p class="dropbox_select_button_item_typo">23:00</p>
          </div>
          <div class="dropbox_select_button_item_small"onclick="fnDateDialogSelect_4('2330', '23:30')">
            <p class="dropbox_select_button_item_typo">23:30</p>
          </div>
        </div>
      </div>
      </div>
      <div class="dropbox_date_expiry_dialog_button_wrapper">
        <a href="javascript:fnDateDialogSave();" class="dropbox_date_expiry_dialog_button">
          <p class="dropbox_date_expiry_dialog_button_typo">입력완료</p>
        </a>
      </div>
    </div>
  </div>
</div>

<input type="hidden" id="DIALOG_YYYY">
<input type="hidden" id="DIALOG_MM">
<input type="hidden" id="DIALOG_DD">
<input type="hidden" id="DIALOG_TTMM">
