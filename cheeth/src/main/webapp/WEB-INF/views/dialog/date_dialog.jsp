<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%
  String callback = request.getParameter("callback");
%>
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
    ccyear = code;
	  var today = new Date();
  	  var year3 = today.getFullYear() + "년";
  	  var month = ('0' + (today.getMonth() + 1)).slice(-2);
  	  var day = ('0' + today.getDate()).slice(-2);
  	  console.log("codeNm :: " + codeNm);
  	console.log("year3 :: " + year3);
  	  if(year3 == codeNm){
  		DateInit();
  	  }else{
  	  	  for(var i = 0;i < 12; i++){
  	  		  var j = i+1;
  	  		  j *= 1;
  	  		  $("#Month_" + j).removeClass("hidden");
  	  		  console.log();
  	  	  }
  	  }
    if(isNotEmpty(code)) {
      $('#YYYY_DIV_1').find('p').html(codeNm);
      $('#DIALOG_YYYY').val(code);
    }
  }
  var curmonth = 0;
  var curTime= 0;
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
      ccmonth = code;
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
        
  	  var today = new Date();
  	  var year3 = today.getFullYear();
  	  var month = ('0' + (today.getMonth() + 1)).slice(-2);
  	  var day = ('0' + today.getDate()).slice(-2);
  	  if(year3 == yaer){
  		DateInit();
  		
  	  }else{
  	  	  for(var i = 0;i < 12; i++){
  	  		  var j = i+1;
  	  		  $("#Month_" + j).removeClass("hidden");
  	  	  }

  	  }
        var k = 0;
        console.log("month " + month);
        console.log("code " + code);
        console.log("day " + day);
        if(month == code){
        	k = day;
        	k = k - 1;
        	curbool = 1;

        }
        for(var i=k; i<cnt; i++) {
          if(i < 9) {
        	i *= 1;
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
  $(document).ready(function(){
	  DateInit();  
  })
  var ccyear="";
  var ccmonth="";
  var ccday="";
  
  function fnDateDialogSelect_3() {
    var code = arguments[0];
    var codeNm = arguments[1];
    var target = $('#DD_DIV_2');
    if(target.hasClass('hidden')) {
      target.removeClass('hidden');
    } else {
      target.addClass('hidden');
    } 
    ccday = code;
    if(isNotEmpty(code)) {
      $('#DD_DIV_1').find('p').html(codeNm);
      $('#DIALOG_DD').val(code);
    }
    var today = new Date();
	var year3 = today.getFullYear() + "년";
	var month = ('0' + (today.getMonth() + 1)).slice(-2);
    var day = ('0' + today.getDate()).slice(-2);
    var dayNM = day+"일"
    var hours = today.getHours();
    var minutes = today.getMinutes();
    console.log("dayNM :: " + dayNM);
    console.log("codeNm :: " + codeNm);
    $("#TTMM_DIV_2").find("div:gt(0)").removeClass("hidden");
    if(curbool == 1){
    	if(dayNM == codeNm){
    	minutes *= 1;
    	hours *= 1;
    	if(minutes >= 0 && minutes < 30){
    		minutes = "30";
    	}else {
    		minutes = "00";
    		hours += 1;
    	}
    	if(hours.length == 1){
    		hours = "0" + hours;
    	}
    	
    	var hourid = hours + "" + minutes;
    	console.log("hours " + hours);
    	console.log("minutes " + minutes);
    	console.log("hourid " + hourid);
    	
    	var index = $("#"+hourid).index();
    	console.log("index " + index);
    	$("#TTMM_DIV_2").find("div:lt(" + index + ")").addClass("hidden");
    	}else{
        	var list = $("#TTMM_DIV_2").find("div").get();
        	for(var jj = 0; jj < list.length; jj++){
        		$("#TTMM_DIV_2").find("div").eq(jj).removeClass("hidden");    		
        	}

        }
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
  var curbool = 0;
  function DateInit(){
	  var today = new Date();
  	  var year = today.getFullYear();
  	  var month = ('0' + (today.getMonth() + 1)).slice(-2);
  	  var day = ('0' + today.getDate()).slice(-2);
  	  var toDayStr = year + month + day;
  	  var num = ('0' + (today.getMonth() + 1)).slice(-2);
  	  if(num != "10"){
  		num = num.replace("0", ""); 
  	  }
  	  num *=1;
  	  for(var i = 0;i < num-1; i++){
  		    var j = i+1;
  		    j *= 1;
  		  $("#Month_" + j).addClass("hidden");
  	  }
  }

  var ttyear = "";
  var ttmonth = "";
  var ttday = "";
  var ttHour = "";
  var ttMinute = "";
  
  $(window).on("load",function(){
	  setTimeout(function(){
		  
	  
	  var today = new Date();
		var year3 = today.getFullYear() + "년";
		var month = ('0' + (today.getMonth() + 1)).slice(-2) + "월";
	  var day = ('0' + today.getDate()).slice(-2);
	  var dayNM = day+"일"
	  var hours = today.getHours();
	  var minutes = today.getMinutes();
      var yaer = today.getFullYear();
      code = ('0' + (today.getMonth() + 1)).slice(-2);
		if(ttyear != ""){
			yaer = ttyear;
			year3 = ttyear+"년";
			
			month = ttmonth+"월";
			code = ttmonth;
			dayNM = ttday + "일";
			day = ttday;
			hours = ttHour;
			minutes = ttMinute;
		}
		minutes *= 1;
		hours *= 1;
		if(minutes >= 0 && minutes < 30){
			minutes = "30";
		}else {
			minutes = "00";
			hours += 1;
		}
		if(hours.length == 1){
			hours = "0" + hours;
		}
		
		var hourid = hours + "" + minutes;
		console.log("hours " + hours);
		console.log("minutes " + minutes);
		console.log("hourid " + hourid);
		
		var index = $("#"+hourid).index();
		console.log("index " + index);
		$("#TTMM_DIV_2").find("div:lt(" + index + ")").addClass("hidden");
	    var cTime = hours + ":" + minutes;
	    
	    
	  $("#YYYY_DIV_1").find(".dropbox_select_button_typo").text(year3);
	  $("#MM_DIV_1").find(".dropbox_select_button_typo").text(month);
	  $("#DD_DIV_1").find(".dropbox_select_button_typo").text(dayNM);
	  $("#TTMM_DIV_1").find(".dropbox_select_button_typo").text(cTime);
	  
      // 일자

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
        /*///////////////////////// */

  	    var k = 0;
        
       	k = day;
       	k = k - 1;

        $('#DIALOG_YYYY').val(yaer);
        $('#DIALOG_MM').val(code);
        $('#DIALOG_DD').val(day);
        $('#DIALOG_TTMM').val(hourid);
        
        for(var i=k; i<cnt; i++) {
          if(i < 9) {
        	i *= 1;
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
        var str = yaer + code + day + hourid;
        $("#EQ_EXP_DATE").val(str);
        fnDateDialogSave();
	  }, 10);
  })
	  
  
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
            <div class="dropbox_select_button_item_small" id="Month_1" onclick="fnDateDialogSelect_2('01', '01월')">
              <p class="dropbox_select_button_item_typo">01월</p>
            </div>
            <div class="dropbox_select_button_item_small" id="Month_2" onclick="fnDateDialogSelect_2('02', '02월')">
              <p class="dropbox_select_button_item_typo">02월</p>
            </div>
            <div class="dropbox_select_button_item_small" id="Month_3" onclick="fnDateDialogSelect_2('03', '03월')">
              <p class="dropbox_select_button_item_typo">03월</p>
            </div>
            <div class="dropbox_select_button_item_small" id="Month_4" onclick="fnDateDialogSelect_2('04', '04월')">
              <p class="dropbox_select_button_item_typo">04월</p>
            </div>
            <div class="dropbox_select_button_item_small" id="Month_5" onclick="fnDateDialogSelect_2('05', '05월')">
              <p class="dropbox_select_button_item_typo">05월</p>
            </div>
            <div class="dropbox_select_button_item_small" id="Month_6" onclick="fnDateDialogSelect_2('06', '06월')">
              <p class="dropbox_select_button_item_typo">06월</p>
            </div>
            <div class="dropbox_select_button_item_small" id="Month_7" onclick="fnDateDialogSelect_2('07', '07월')">
              <p class="dropbox_select_button_item_typo">07월</p>
            </div>
            <div class="dropbox_select_button_item_small" id="Month_8" onclick="fnDateDialogSelect_2('08', '08월')">
              <p class="dropbox_select_button_item_typo">08월</p>
            </div>
            <div class="dropbox_select_button_item_small" id="Month_9" onclick="fnDateDialogSelect_2('09', '09월')">
              <p class="dropbox_select_button_item_typo">09월</p>
            </div>
            <div class="dropbox_select_button_item_small" id="Month_10" onclick="fnDateDialogSelect_2('10', '10월')">
              <p class="dropbox_select_button_item_typo">10월</p>
            </div>
            <div class="dropbox_select_button_item_small" id="Month_11" onclick="fnDateDialogSelect_2('11', '11월')">
              <p class="dropbox_select_button_item_typo">11월</p>
            </div>
            <div class="dropbox_select_button_item_small" id="Month_12" onclick="fnDateDialogSelect_2('12', '12월')">
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
          <div class="dropbox_select_button_item_small" id="0900" onclick="fnDateDialogSelect_4('0900', '09:00')">
            <p class="dropbox_select_button_item_typo">09:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="0930" onclick="fnDateDialogSelect_4('0930', '09:30')">
            <p class="dropbox_select_button_item_typo">09:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1000" onclick="fnDateDialogSelect_4('1000', '10:00')">
            <p class="dropbox_select_button_item_typo">10:00</p>
          </div>
          <div class="dropbox_select_button_item_small"id="1030" onclick="fnDateDialogSelect_4('1030', '10:30')">
            <p class="dropbox_select_button_item_typo">10:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1100" onclick="fnDateDialogSelect_4('1100', '11:00')">
            <p class="dropbox_select_button_item_typo">11:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1130" onclick="fnDateDialogSelect_4('1130', '11:30')">
            <p class="dropbox_select_button_item_typo">11:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1200" onclick="fnDateDialogSelect_4('1200', '12:00')">
            <p class="dropbox_select_button_item_typo">12:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1230" onclick="fnDateDialogSelect_4('1230', '12:30')">
            <p class="dropbox_select_button_item_typo">12:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1300" onclick="fnDateDialogSelect_4('1300', '13:00')">
            <p class="dropbox_select_button_item_typo">13:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1330" onclick="fnDateDialogSelect_4('1330', '13:30')">
            <p class="dropbox_select_button_item_typo">13:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1400" onclick="fnDateDialogSelect_4('1400', '14:00')">
            <p class="dropbox_select_button_item_typo">14:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1430" onclick="fnDateDialogSelect_4('1430', '14:30')">
            <p class="dropbox_select_button_item_typo">14:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1500" onclick="fnDateDialogSelect_4('1500', '15:00')">
            <p class="dropbox_select_button_item_typo">15:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1530" onclick="fnDateDialogSelect_4('1530', '15:30')">
            <p class="dropbox_select_button_item_typo">15:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1600"onclick="fnDateDialogSelect_4('1600', '16:00')">
            <p class="dropbox_select_button_item_typo">16:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1630" onclick="fnDateDialogSelect_4('1630', '16:30')">
            <p class="dropbox_select_button_item_typo">16:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1700" onclick="fnDateDialogSelect_4('1700', '17:00')">
            <p class="dropbox_select_button_item_typo">17:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1730" onclick="fnDateDialogSelect_4('1730', '17:30')">
            <p class="dropbox_select_button_item_typo">17:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1800" onclick="fnDateDialogSelect_4('1800', '18:00')">
            <p class="dropbox_select_button_item_typo">18:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1830" onclick="fnDateDialogSelect_4('1830', '18:30')">
            <p class="dropbox_select_button_item_typo">18:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1900" onclick="fnDateDialogSelect_4('1900', '19:00')">
            <p class="dropbox_select_button_item_typo">19:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="1930" onclick="fnDateDialogSelect_4('1930', '19:30')">
            <p class="dropbox_select_button_item_typo">19:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="2000" onclick="fnDateDialogSelect_4('2000', '20:00')">
            <p class="dropbox_select_button_item_typo">20:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="2030" onclick="fnDateDialogSelect_4('2030', '20:30')">
            <p class="dropbox_select_button_item_typo">20:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="2100" onclick="fnDateDialogSelect_4('2100', '21:00')">
            <p class="dropbox_select_button_item_typo">21:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="2130" onclick="fnDateDialogSelect_4('2130', '21:30')">
            <p class="dropbox_select_button_item_typo">21:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="2200" onclick="fnDateDialogSelect_4('2200', '22:00')">
            <p class="dropbox_select_button_item_typo">22:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="2230" onclick="fnDateDialogSelect_4('2230', '22:30')">
            <p class="dropbox_select_button_item_typo">22:30</p>
          </div>
          <div class="dropbox_select_button_item_small" id="2300" onclick="fnDateDialogSelect_4('2300', '23:00')">
            <p class="dropbox_select_button_item_typo">23:00</p>
          </div>
          <div class="dropbox_select_button_item_small" id="2330" onclick="fnDateDialogSelect_4('2330', '23:30')">
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
<style>
.hidden{
	display:none;
}
</style>
<input type="hidden" id="DIALOG_YYYY">
<input type="hidden" id="DIALOG_MM">
<input type="hidden" id="DIALOG_DD">
<input type="hidden" id="DIALOG_TTMM">
