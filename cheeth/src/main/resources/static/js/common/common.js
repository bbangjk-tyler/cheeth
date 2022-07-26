
function isObjectType() {
  var args = arguments[0];
  return Object.prototype.toString.call(args).slice(8, -1);
}

function isEmpty(args) {
  
  var args = arguments[0];
  var result = false;
  const type = isObjectType(args);

  if(type === 'String') { // String
    if(args === '' || args === "") result = true;
  } else if(type === 'Number') { // Number
    result = false;
  } else if(type === 'Boolean') { // Boolean
    result = false;
  } else if(type === 'Undefined') { // Undefined
    result = true;
  } else if(type === 'Null') { // Null
    result = true;
  } else if(type === 'Object') { // Object
    if(Object.keys(args).length === 0) result = true;
  } else if(type === 'Array') { // Array
    if(args.length === 0) result = true;
  } else if(type === 'RegExp') { // RegExp
    result = false;
  } else if(type === 'Math') { // Math
    result = false;
  } else if(type === 'Date') { // Date
    result = false;
  } else if(type === 'Function') { // Function
    result = false;
  } else if(type === 'File') { // File
    result = false;
  }

  return result;
}

function isNotEmpty() {
  var args = arguments[0];
  let result= true;
  if(isEmpty(args)) {
    result = false;
  }
  return result;
}

function getCode() {
  var groupCd = arguments[0];
  var rtnArray = new Array();
  $.ajax({
    url: '/' + API + '/common/getCode',
    type: 'GET',
    data: { GROUP_CD: groupCd },
    cache: false,
    async: false,
    success: function(data) {
      rtnArray = data;
    }, complete: function() {

    }, error: function() {
      
    }
  });
  return rtnArray;
}

// 비밀번호 정규식
function fnPwdValidation() {
  var param = arguments[0];
  var str = param;
  var patt = new RegExp(/^.*(?=^.{9,16}$)(?=.*\d)(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[~!@#$%^*_+=]).*$/);
  var res = patt.test(str);

  return res;
}

// 허용 가능 특수문자 확인
function fnSpecialCharacterValidation() {
  var param = arguments[0];
  var str = param;
  var patt = new RegExp(/^.*(?=.*[~!@#$%^*_+=]).*$/);
  var res = patt.test(str);

  return res;
}

// text에 특수문자 여부 확인
function fnCheckSpecial(){
  var str = arguments[0];
  var pattern = new RegExp(/^.*(?=^.{9,16}$)(?=.*\d)(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[~!@#$%^*_+=]).*$/);
//  if(!pattern.test(str)){
//    alert('8~15자의 대문자,소문자,특수문자,숫자 모두 포함해야 합니다.\n허용 가능한 특수문자: ~!@#$%^*_+=');
//    return false;
//  }

  var checkNumber = str.search(/[0-9]/g);
  var checkCapitalLetter = str.search(/[A-Z]/g);
  var checkSmallLetter = str.search(/[a-z]/g);
  var checkSpecial = str.search(/[~!@#$%^*_+=]/gi);

  if(str.length < 8 || str.length > 15){
    alert("8~15자를 입력해주세요.");
    return false;
  }

  if(checkNumber < 0){
    alert("숫자가 포함되어야 합니다.");
    return false;
  }

  if(checkCapitalLetter < 0){
    alert("대문자가 포함되어야 합니다.");
    return false;
  }

  if(checkSmallLetter < 0){
    alert("소문자가 포함되어야 합니다.");
    return false;
  }

  if(checkSpecial < 0){
    alert("특수문자가 포함되어야 합니다. \n허용 특수문자 : ~!@#$%^*_+=");
    return false;
  }

  return true;
}

function fnGetUrlParam() {
  var name = arguments[0];
  var url = arguments[1];
  if(isEmpty(url)) url = location.href;
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp(regexS);
  var results = regex.exec(url);
    
  return isEmpty(results) ? '' : results[1];
}

function checkId(id) {
  var result = true;
  $.ajax({
    url: '/' + API + '/common/checkId',
    type: 'GET',
    data: { user_id: id },
    cache: false,
    async: false,
    success: function(data) {
      if(data.result && +data.result > 0) {
        result = false;
      }
    }, complete: function() {
        
    }, error: function() {
        
    }
  });
  return result;
}

function checkId(id) {
  var result = true;
  $.ajax({
    url: '/' + API + '/common/checkId',
    type: 'GET',
    data: { user_id: id },
    cache: false,
    async: false,
    success: function(data) {
      if(data.result && +data.result > 0) {
        result = false;
      }
    }, complete: function() {
        
    }, error: function() {
        
    }
  });
  return result;
}

function checkSign(userPhone, userTypeCd) {
  var result = true;
  $.ajax({
    url: '/' + API + '/common/checkSign',
    type: 'GET',
    data: { user_phone: userPhone, user_type_cd: userTypeCd},
    cache: false,
    async: false,
    success: function(data) {
      if(data.result && +data.result > 0) {
        result = false;
      }
    }, complete: function() {
        
    }, error: function() {
        
    }
  });
  return result;
}

function checkNickName(nickName) {
  var result = true;
  $.ajax({
    url: '/' + API + '/common/checkNickName',
    type: 'GET',
    data: { user_nick_name: nickName },
    cache: false,
    async: false,
    success: function(data) {
      if(data.result && +data.result > 0) {
        result = false;
      }
    }, complete: function() {
      
    }, error: function() {
      
    }
  });
  return result;
}

function checkAccount(bankCd, accountNm, accountNo) {
  var result = true;
  $.ajax({
    url: '/' + API + '/common/checkAccount',
    type: 'GET',
    data: { account_nm: accountNm, bank_cd : bankCd, account_no : accountNo},
    cache: false,
    async: false,
    success: function(data) {
      if(data.result && +data.result > 0) {
        result = false;
      }
    }, complete: function() {
      
    }, error: function() {
      
    }
  });
  return result;
}

function checkPhoneNo(userPhone, flag, authNo) {
  var result = '';
  $.ajax({
    url: '/' + API + '/common/checkPhoneNo',
    type: 'GET',
    data: { userPhone: userPhone, flag: flag, authNo: authNo},
    cache: false,
    async: false,
    success: function(data) {
		result = data.result;
    }, complete: function() {
      
    }, error: function() {
      
    }
  });
  return result;
}

function getSaveObj() {
  var formNm = arguments[0];
  var saveObj = new Object();
  $('#' + formNm + ' input, textarea').each(function() {
    var input = $(this);
    var name =  input.prop('name');
    var value =  input.prop('value');
    if(isNotEmpty(name)) {
      saveObj[name] = value;
    }
  });
  return saveObj;
}

function fnSetPageInfo() {
    
  var args_page = arguments[0];
  var args_listCnt = arguments[1];
  var args_listSize = isEmpty(arguments[2]) ? 10 : arguments[2];
  
  var listSize = args_listSize; // 한페이지당 게시물 수
  var rangeSize = 10; // 페이징 범위
  var page = 1;
  var range = 0;
  var rangePrev = null;
  var rangeNext = null;
  var listCnt = null;
  var pageCnt = null;
  var startPage = null;
  var startList = null;
  var endPage = 0;
  var prev = null;
  var next = true;
  
  page = args_page;
  range = args_page%10 === 0 ? (args_page - (rangeSize - 1)) : (Math.floor(args_page / 10) * 10) + 1;
  rangePrev = range - listSize;
  rangeNext = range + listSize;
  listCnt = args_listCnt;

  // 전체 페이지수
  pageCnt = Math.ceil(listCnt/listSize);

  // 시작 페이지
  startPage = (range - 1) * rangeSize + 1 ;

  // 끝 페이지
  endPage = range * rangeSize;

  // 게시판 시작번호
  startList = (page - 1) * listSize;

  // 이전 버튼 상태
  prev = range === 1 ? false : true;

  // 다음버튼 상태
  next = endPage > pageCnt ? false : true;
  if(endPage > pageCnt) {
    endPage = pageCnt;
    next = false;
  }
  
  var html = ``;
  
  if(listCnt == 0) {
    html += `<button class="pagination_numb_now" style="cursor: pointer;" onclick="fnSearch(1);"><p class="pagination_numb_now_typo">1</p></button>`;
  } else {
    if(prev) {
      html += `<button class="pagination_before" style="cursor: pointer;" onclick="fnSearch(` + rangePrev + `);">`;
      html += `<img class="pagination_next_arrow" src="/public/assets/images/connection_location_arrow.svg"/>`;
      html += `<p class="pagination_before_typo">이전&nbsp;&nbsp;</p>`;
      html += `</button>`;
    }
    
    for(var i=0; i<listSize; i++) {
      if(i+range <= endPage) {
        if(page == (i+range)) {
          html += `<button class="pagination_numb_now" style="cursor: pointer;" onclick="fnSearch(` + (i+range) + `);">`;
          html += `<p class="pagination_numb_now_typo">`;
        } else {
          html += `<button class="pagination_numb" style="cursor: pointer;" onclick="fnSearch(` + (i+range) + `);">`;
          html += `<p class="pagination_numb_typo">`;
        }
        html += (i+range);
        html += `</p>`;
        html += `</button>`;
      }
    }
    
    if(next) {
      html += `<button class="pagination_next" style="cursor: pointer;" onclick="fnSearch(` + rangeNext + `);">`;
      html += `<p class="pagination_next_typo">다음&nbsp;&nbsp;</p>`;
      html += `<img class="pagination_next_arrow" src="/public/assets/images/connection_location_arrow.svg"/>`;
      html += `</button>`;
    }
  }
  
  
  $('.pagination').html(html);
  
  return page;
}

function commonCreateRandomKey() {
  const d = new Date();
  const curYear = d.getFullYear();
  const curMonth = d.getMonth() + 1;
  const curDate = d.getDate();
  const curHour = d.getHours();
  const curMin = d.getMinutes();
  const curSec = d.getSeconds();
  const curMsec = d.getMilliseconds();

  let randomKey = '';
  randomKey += String(curYear);
  randomKey += String(curMonth);
  randomKey += String(curDate);
  randomKey += String(curHour);
  randomKey += String(curMin);
  randomKey += String(curSec);
  randomKey += String(curMsec);

  randomKey = commonRpad(randomKey, 17, '0');
  randomKey += commonRpad(String(Math.floor(Math.random()*1000)+1), 2, '0');
  
  return randomKey;
}

function commonRpad(s, padLength, padString) {
  while(s.toString().length <= padLength) {
    s += padString;
  }
  return s.toString();
}

function fnGetSuppCd() {
  var code = [
    { SUPP_CD: 'SP101', SUPP_NM: 'Crown', LVL: 1, P_SUPP_CD: '' },
    { SUPP_CD: 'SP102', SUPP_NM: 'Inlay(onlay)', LVL: 1, P_SUPP_CD: '' },
    { SUPP_CD: 'SP103', SUPP_NM: 'Frame', LVL: 1, P_SUPP_CD: '' },
    { SUPP_CD: 'SP104', SUPP_NM: 'Splint', LVL: 1, P_SUPP_CD: '' },
    { SUPP_CD: 'SP105', SUPP_NM: '의치', LVL: 1, P_SUPP_CD: '' },
    { SUPP_CD: 'SP106', SUPP_NM: 'Custom abutment', LVL: 1, P_SUPP_CD: '' },
    { SUPP_CD: 'SP107', SUPP_NM: '교정', LVL: 1, P_SUPP_CD: '' },
    { SUPP_CD: 'SP108', SUPP_NM: '트레이', LVL: 1, P_SUPP_CD: '' },
    { SUPP_CD: 'SP109', SUPP_NM: '기타', LVL: 1, P_SUPP_CD: '' },
    
    { SUPP_CD: 'SP201', SUPP_NM: '지르코니아', LVL: 2, P_SUPP_CD: 'SP101' },
    { SUPP_CD: 'SP202', SUPP_NM: 'Metal', LVL: 2, P_SUPP_CD: 'SP101' },
    { SUPP_CD: 'SP203', SUPP_NM: 'Temp Cr.', LVL: 2, P_SUPP_CD: 'SP101' },
    { SUPP_CD: 'SP204', SUPP_NM: 'Full', LVL: 2, P_SUPP_CD: 'SP103' },
    { SUPP_CD: 'SP205', SUPP_NM: 'Partial', LVL: 2, P_SUPP_CD: 'SP103' },
    { SUPP_CD: 'SP206', SUPP_NM: 'Surgical guid', LVL: 2, P_SUPP_CD: 'SP104' },
    { SUPP_CD: 'SP207', SUPP_NM: 'Bite Splint', LVL: 2, P_SUPP_CD: 'SP104' },
    { SUPP_CD: 'SP208', SUPP_NM: 'Full', LVL: 2, P_SUPP_CD: 'SP105' },
    { SUPP_CD: 'SP209', SUPP_NM: 'Partial', LVL: 2, P_SUPP_CD: 'SP105' },
    { SUPP_CD: 'SP210', SUPP_NM: 'Metal', LVL: 2, P_SUPP_CD: 'SP106' },
    { SUPP_CD: 'SP211', SUPP_NM: 'Zirconia', LVL: 2, P_SUPP_CD: 'SP106' },
    
    { SUPP_CD: 'SP301', SUPP_NM: '일반', LVL: 3, P_SUPP_CD: 'SP201' },
    { SUPP_CD: 'SP302', SUPP_NM: 'SCRP', LVL: 3, P_SUPP_CD: 'SP201' },
    { SUPP_CD: 'SP303', SUPP_NM: '국소의치 지대치', LVL: 3, P_SUPP_CD: 'SP201' },
    { SUPP_CD: 'SP304', SUPP_NM: '일반', LVL: 3, P_SUPP_CD: 'SP202' },
    { SUPP_CD: 'SP305', SUPP_NM: 'SCRP', LVL: 3, P_SUPP_CD: 'SP202' },
    { SUPP_CD: 'SP306', SUPP_NM: '국소의치 지대치', LVL: 3, P_SUPP_CD: 'SP202' },
    { SUPP_CD: 'SP307', SUPP_NM: '일반', LVL: 3, P_SUPP_CD: 'SP203' },
    { SUPP_CD: 'SP308', SUPP_NM: 'SCRP', LVL: 3, P_SUPP_CD: 'SP203' },
    { SUPP_CD: 'SP309', SUPP_NM: '국소의치 지대치', LVL: 3, P_SUPP_CD: 'SP203' },
    
    { SUPP_CD: 'SP401', SUPP_NM: '일반', LVL: 4, P_SUPP_CD: 'SP303' },
    { SUPP_CD: 'SP402', SUPP_NM: 'SCRP', LVL: 4, P_SUPP_CD: 'SP303' },
    { SUPP_CD: 'SP403', SUPP_NM: '일반', LVL: 4, P_SUPP_CD: 'SP306' },
    { SUPP_CD: 'SP404', SUPP_NM: 'SCRP', LVL: 4, P_SUPP_CD: 'SP306' }
  ];
  
  return code;
}

function fnFindSuppCdList() {
  var pSuppCd = arguments[0];
  var list = fnGetSuppCd();
  var rtnList = new Array();
  for(var i=0; i<list.length; i++) {
    if(pSuppCd === list[i].P_SUPP_CD) {
      rtnList.push(list[i]);
    }
  }
  return rtnList;
}

function fnFindSuppNm() {
  var suppCd = arguments[0];
  var suppNm = '';
  
  var list = fnGetSuppCd();
  for(var i=0; i<list.length; i++) {
    if(suppCd === list[i].SUPP_CD) {
      suppNm = list[i].SUPP_NM;
      break;
    }
  }
  
  return suppNm;
}

function fnOpenWindowPopup() {
  
  var args = arguments[0];
  var url = args?.url ?? '';
  var target = args?.target ?? 'winPopup1';
  var width = args?.width ?? 400;
  var height = args?.height ?? 400;
  var param = args?.param ?? {};
  
  console.log('url', url);

  var scrollbarsOption = args?.scrollbarsOption ?? false;
  var resizableOption = args?.resizableOption ?? true;
  var restOption = args?.restOption ?? false;

  var left = (screen.availWidth-width) / 2;
  if(window.screenLeft < 0) {
    left += window.screen.width * -1;
  } else if(window.screenLeft > window.screen.width) {
    left += window.screen.width;
  }
  var top = (screen.availHeight - height) / 2 - 10;

  var openStr  = 'width=' + width;
  openStr += ', height=' + height;
  openStr += ', left=' + left;
  openStr += ', top=' + top;

  if(scrollbarsOption) {
    openStr += ', scrollbars=yes';
  } else {
    openStr += ', scrollbars=no';
  }

  if(resizableOption) {
    openStr += ', resizable=yes';
  } else {
    openStr += ', resizable=no';
  }

  if(restOption) {
    openStr += ',toolbar=yes, menubar=yes, location=yes, status=yes';
  }

  if(isNotEmpty(param)) {
    var cnt = 0;
    if(url?.indexOf('?') > -1) {
      cnt++;
    }
    Object.keys(param).forEach(k => {
      if(isNotEmpty(param[k])) {
        if(cnt === 0) {
          url += '?';
        } else {
          url += '&';
        }
        url += k;
        url += '=';
        url += param[k];
        cnt++;
      }
    });
  }

  var popup = window.open(encodeURI(url), target, openStr);
  if(popup) popup?.focus();
  return popup;
}

function fnPopuupClose() {
  window.close();
}

function fnCheckAll() {
  var target = arguments[0];
  var divId = arguments[1];
  var isCheck = $(target).is(':checked');
  var checkTarget = $('#' + divId).find('input');
  if(isCheck) {
    checkTarget.prop('checked', true);
  } else {
    checkTarget.prop('checked', false);
  }
}

function fnCheck() {
  var target = arguments[0];
  var divId = arguments[1];
  var isCheck = $(target).is(':checked');
  if(isCheck) {
    var cnt1 = $('#' + divId).find('input').length;
    var cnt2 = 0;
    $('#' + divId).find('input').each(function(k,v) {
      if($(v).is(':checked')) cnt2++;
    });
    if(cnt1 === cnt2) {
      $('#checkAll').prop('checked', true);
    } else {
      $('#checkAll').prop('checked', false);
    }
  } else {
    $('#checkAll').prop('checked', false);
  }
}

function fnFileDownload() {
  var fileCd = arguments[0];
  var fileNo = arguments[1];
  console.log("fileCd :: " + fileCd);
  console.log("fileNo :: " + fileNo);
  $('#fileDownloadForm #FILE_CD').val(fileCd);
  $('#fileDownloadForm #FILE_NO').val(fileNo);
  $('#fileDownloadForm').submit();
}

function fnIsValidDate() {
  var args = arguments[0];
  try {
    var tempDate = args.replace(/[^0-9]/g, '');
    if(tempDate.length !== 8) {
      return false;
    }

    var year = Number(tempDate.substring(0, 4));
    var month = Number(tempDate.substring(4, 6));
    var day = Number(tempDate.substring(6, 8));

    if(month < 1 || month > 12) {
      return false;
    }

    const maxDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var maxDay = maxDaysInMonth[month-1];

    // 윤년 체크
    if( month === 2 && ( (year%4 === 0 && year%100 !== 0) || year%400 === 0 ) ) {
      maxDay = 29;
    }

    if(day <= 0 || day > maxDay) {
      return false;
    }

    return true;

  } catch (err) {
    return false;
  }
}

function addComma() {
  const args = arguments[0];
  let rtnVal = '';
  if(isNotEmpty(args)) {
    const tempArgs = args.toString().replace(/[^0-9]/g, '');
    if(isNotEmpty(tempArgs)) {
      let str = removeComma(args.toString());
      let x = str.split('.');
      let x1 = x[0];
      let x2 = x.length > 1 ? '.' + x[1] : '';
      var regex = /(\d+)(\d{3})/;
      while(regex.test(x1)) {
        x1 = x1.replace(regex, '$1' + ',' + '$2');
      }
      rtnVal = x1 + x2;
    }
  }
  return rtnVal;
}

function removeComma() {
  const args = arguments[0];
  const regex = /,/g;
  return args.replace(regex, '');
}

function fnGetMaxIdx() {
  var f = arguments[0];
  if(f.length === 0) {
    return 1;
  } else {
    var max = f.reduce(function(p, c) {
      return (p.IDX > c.IDX) ? p : c
    });
    return max.IDX+1;
  }
}

function fnIsCheckDate(){
  var args = arguments[0];
  var today = new Date();
  var year = today.getFullYear();
  var month = ('0' + (today.getMonth() + 1)).slice(-2);
  var day = ('0' + today.getDate()).slice(-2);
  var toDayStr = year + month + day;
  if(args < toDayStr){
    return false;
  }
  return true;
}

function replaceAll() {
  var str = arguments[0];
  var searchStr = arguments[1];
  var replaceStr = arguments[2];
  if(isNotEmpty(str) && typeof str == 'string') {
    while(str.indexOf(searchStr) != -1) {
      str = str.replace(searchStr, replaceStr);
    }
  }
  return str;
}

function toNumber() {
  var value = arguments[0];
  var nullValue = arguments[1];
  var rtnValue = 0;
  var targetValue = replaceAll(value, ',', '');
  if(isEmpty(nullValue)) nullValue = 0;
  if(isEmpty(targetValue)) {
    rtnValue = nullValue;
  } else {
    rtnValue = targetValue;
  }
  if(isNaN(rtnValue)) rtnValue = 0;

  return Number(rtnValue);
}
