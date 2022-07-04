package com.cheeth.busiCpnt.common;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.cheeth.busiCpnt.page.sign.SignController;
import com.cheeth.comAbrt.controller.BaseController;
import com.cheeth.comUtils.ParameterUtil;
import com.popbill.api.AccountCheckInfo;
import com.popbill.api.AccountCheckService;

@RestController
@RequestMapping(value = "${api.url}/common")
public class CommonController extends BaseController {

  protected Logger logger = LogManager.getLogger(SignController.class);

  @Autowired
  private CommonService service;
  
  @Autowired
  private AccountCheckService accountCheckService;
  
  @Value("${popbill.testCorpNum}")
  private String testCorpNum;

  @GetMapping(value="/getCode", produces=MediaType.APPLICATION_JSON_VALUE)
  public List<?> getCode(HttpServletRequest request) throws Exception {

    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);

    List<?> list = service.getList(parameter);

    return list;
  }

  @GetMapping(value="/checkId", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> checkId(HttpServletRequest request) throws Exception {
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> rtnMap = new HashMap<>();
    try {
      Integer result = service.checkId(parameter);
      rtnMap.put("result", result);
    } catch (Exception e) {
      logger.error(e.getMessage());
    }
    return rtnMap;
  }
  
  @GetMapping(value="/checkSign", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> checkSign(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  try {
		  Integer result = service.checkSign(parameter);
		  rtnMap.put("result", result);
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }

  @GetMapping(value="/checkNickName", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> checkNickName(HttpServletRequest request) throws Exception {
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> rtnMap = new HashMap<>();
    try {
      Integer result = service.checkNickName(parameter);
      rtnMap.put("result", result);
    } catch (Exception e) {
      logger.error(e.getMessage());
    }
    return rtnMap;
  }
  
  @GetMapping(value="/checkAccount", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> checkAccount(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  try {
		  AccountCheckInfo accountInfo = accountCheckService.CheckAccountInfo(testCorpNum, String.valueOf(parameter.get("bank_cd")), String.valueOf(parameter.get("account_no")));
		  Integer result = 0;
		  if(String.valueOf(parameter.get("account_nm")).equals(accountInfo.getAccountName())) {
			  result = 0;
		  }else {
			  result = 1;
		  }
		  rtnMap.put("result", result);
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }
  
  @PostMapping(value="/uploadImage", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> uploadImage(HttpServletRequest request, @RequestParam("files") MultipartFile[] multipartFiles) throws Exception {
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, Object> resultMap = new HashMap<>();
    try {
      resultMap = service.uploadImage(parameter, multipartFiles);
    } catch (Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
    return resultMap;
  }
  
  @GetMapping(value="/getFiles", produces=MediaType.APPLICATION_JSON_VALUE)
  public List<?> getFiles(HttpServletRequest request) throws Exception {
	Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
	List<?> list = service.list("getFileList", parameter);
	return list;
  }
  
  @GetMapping(value="/checkPhoneNo", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> checkPhoneNo(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  try {
		  LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));	
		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		  HttpSession session = request.getSession();
		  String rtnResult = "";
		  //인증번호 SMS 전송
		  if(String.valueOf(parameter.get("flag")).equals("0")) {
			  Random random = new Random();
			  String randDigit = String.format("%04d", random.nextInt(10000));
			  parameter.put("content", "[덴트너] 인증번호는 ["+randDigit+"] 입니다.");
			  String result = service.sendSMS(parameter);
			  session.setAttribute("smsNo", randDigit);
			  session.setAttribute("smsTime", now.format(formatter));
			  rtnResult = result;
		  }
		  //사용자 입력 인증번호 확인
		  else {
			  long oldTimeStamp = Long.parseLong(String.valueOf(session.getAttribute("smsTime")));
			  long newTimeStamp = Long.parseLong(now.format(formatter));
			  if(newTimeStamp - oldTimeStamp > 120) {
				  rtnResult = "A";
			  } else if(!parameter.get("authNo").equals(String.valueOf(session.getAttribute("smsNo")))){
				  rtnResult = "B";
			  } else {
				  session.removeAttribute("smsNo");
				  session.removeAttribute("smsTime");
				  rtnResult = "Y";
			  }
		  }
		  
		  rtnMap.put("result", rtnResult);
		  
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }

}
