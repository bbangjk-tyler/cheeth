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
  @PostMapping(value="/message01", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> message01(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  try {
		  LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));	
		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		  HttpSession session = request.getSession();
		  String rtnResult = "";
		  
		  //String userID = parameter.get("CREATE_ID").toString();
		  String userID =  parameter.get("USER_ID").toString();
		  parameter.put("RECEIVE_ID", userID);
		  String userPhone = service.string("getPhoneNum02", parameter);
		  parameter.put("userPhone", userPhone);
		  //parameter.put("RECEIVE_ID", userID);
		 // System.out.println("userID :: " + userID);
		  System.out.println("userPhone :: " + userPhone);
		  System.out.println("userPhone :: " + userPhone);
		  //userPhone
			  Random random = new Random();
			  String randDigit = String.format("%04d", random.nextInt(10000));
			  parameter.put("content", "[덴트너] 결제요청이 왔습니다.");
			  String result = service.sendSMS(parameter);
			  session.setAttribute("smsNo", randDigit);
			  session.setAttribute("smsTime", now.format(formatter));
			  rtnResult = result;
		        parameter.put("SEND_ID", "덴트너");
		        //parameter.put("RECEIVE_ID", receiveId);
		        //String CONTENT = "<a class=\"note_box_list_context\" href=\"javascript:location.href='https://dentner.co.kr/api/project/project_request_view?PROJECT_NO=" + projectNo + "'\">귀하에게 견적 문의가 들어왔습니다.</a>";
		        String CONTENT = "결제요청이 왔습니다.";
		        parameter.put("CONTENT", CONTENT);
		        parameter.put("CREATE_ID", "덴트너");
		        parameter.put("UPDATE_ID", "덴트너");
		        service.insert("insert01", parameter);
			  
		  
		  rtnMap.put("result", rtnResult);
		  
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }
  
  @PostMapping(value="/message02", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> message02(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  
	  String userID = service.string("getUserID", parameter);
	  String userPhone = service.string("getPhoneNum", parameter);
	  parameter.put("userPhone", userPhone);
	  parameter.put("RECEIVE_ID", userID);
	  try {
		  LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));	
		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		  HttpSession session = request.getSession();
		  String rtnResult = "";
		  //인증번호 SMS 전송
			  Random random = new Random();
			  String randDigit = String.format("%04d", random.nextInt(10000));
			  parameter.put("content", "[덴트너] 입금확인이 완료되었습니다. 파일을 확인해주세요.");
			  String result = service.sendSMS(parameter);
			  session.setAttribute("smsNo", randDigit);
			  session.setAttribute("smsTime", now.format(formatter));
			  rtnResult = result;

		  rtnMap.put("result", rtnResult);
		  
	        parameter.put("SEND_ID", "덴트너");
	        //parameter.put("RECEIVE_ID", receiveId);
	        //String CONTENT = "<a class=\"note_box_list_context\" href=\"javascript:location.href='https://dentner.co.kr/api/project/project_request_view?PROJECT_NO=" + projectNo + "'\">귀하에게 견적 문의가 들어왔습니다.</a>";
	        String CONTENT = "입금확인이 완료되었습니다. 파일을 확인해주세요.";
	        parameter.put("CONTENT", CONTENT);
	        parameter.put("CREATE_ID", "덴트너");
	        parameter.put("UPDATE_ID", "덴트너");
	        service.insert("insert01", parameter);
		  
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }
  @PostMapping(value="/message03", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> message03(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  
	  String userID = service.string("getUserID", parameter);
	  String userPhone = service.string("getPhoneNum", parameter);
	  parameter.put("userPhone", userPhone);
	  parameter.put("RECEIVE_ID", userID);
	  try {
		  LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));	
		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		  HttpSession session = request.getSession();
		  String rtnResult = "";
		  //인증번호 SMS 전송
			  Random random = new Random();
			  String randDigit = String.format("%04d", random.nextInt(10000));
			  parameter.put("content", "[덴트너] 특수계약 요청을 하였습니다.");
			  String result = service.sendSMS(parameter);
			  session.setAttribute("smsNo", randDigit);
			  session.setAttribute("smsTime", now.format(formatter));
			  rtnResult = result;

		  rtnMap.put("result", rtnResult);
		  
	        parameter.put("SEND_ID", "덴트너");
	        //parameter.put("RECEIVE_ID", receiveId);
	        //String CONTENT = "<a class=\"note_box_list_context\" href=\"javascript:location.href='https://dentner.co.kr/api/project/project_request_view?PROJECT_NO=" + projectNo + "'\">귀하에게 견적 문의가 들어왔습니다.</a>";
	        String CONTENT = "특수계약 요청을 하였습니다.";
	        parameter.put("CONTENT", CONTENT);
	        parameter.put("CREATE_ID", "덴트너");
	        parameter.put("UPDATE_ID", "덴트너");
	        service.insert("insert01", parameter);
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }
  @PostMapping(value="/message04", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> message04(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  
//	  String userID = service.string("getUserID", parameter);
//	  String userPhone = service.string("getPhoneNum", parameter);
	  
	  String userID = parameter.get("RECEIVE_ID").toString();
	  parameter.put("CREATE_ID", userID);
	  parameter.put("USER_ID", userID);
	  String userPhone = service.string("getPhoneNum02", parameter);
	  parameter.put("userPhone", userPhone);
	  
	  try {
		  LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));	
		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		  HttpSession session = request.getSession();
		  String rtnResult = "";
		  //인증번호 SMS 전송
			  Random random = new Random();
			  String randDigit = String.format("%04d", random.nextInt(10000));
			  parameter.put("content", "[덴트너] 전자계약이 승인되었습니다");
			  String result = service.sendSMS(parameter);
			  session.setAttribute("smsNo", randDigit);
			  session.setAttribute("smsTime", now.format(formatter));
			  rtnResult = result;

		  rtnMap.put("result", rtnResult);
		  
	        parameter.put("SEND_ID", "덴트너");
	        //parameter.put("RECEIVE_ID", receiveId);
	        //String CONTENT = "<a class=\"note_box_list_context\" href=\"javascript:location.href='https://dentner.co.kr/api/project/project_request_view?PROJECT_NO=" + projectNo + "'\">귀하에게 견적 문의가 들어왔습니다.</a>";
	        String CONTENT = "전자계약이 승인되었습니다.";
	        parameter.put("CONTENT", CONTENT);
	        parameter.put("CREATE_ID", "덴트너");
	        parameter.put("UPDATE_ID", "덴트너");
	        service.insert("insert01", parameter);
		  
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }
  @PostMapping(value="/message04_1", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> message04_1(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  
//	  String userID = service.string("getUserID", parameter);
//	  String userPhone = service.string("getPhoneNum", parameter);
	  
	  String userID = parameter.get("RECEIVE_ID").toString();
	  parameter.put("CREATE_ID", userID);
	  String userPhone = service.string("getPhoneNum02", parameter);
	  parameter.put("userPhone", userPhone);
	  
	  try {
		  LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));	
		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		  HttpSession session = request.getSession();
		  String rtnResult = "";
		  //인증번호 SMS 전송
			  Random random = new Random();
			  String randDigit = String.format("%04d", random.nextInt(10000));
			  parameter.put("content", "[덴트너] 전자계약 승인 요청이 왔습니다");
			  String result = service.sendSMS(parameter);
			  session.setAttribute("smsNo", randDigit);
			  session.setAttribute("smsTime", now.format(formatter));
			  rtnResult = result;

		  rtnMap.put("result", rtnResult);
		  
	        parameter.put("SEND_ID", "덴트너");
	        //parameter.put("RECEIVE_ID", receiveId);
	        //String CONTENT = "<a class=\"note_box_list_context\" href=\"javascript:location.href='https://dentner.co.kr/api/project/project_request_view?PROJECT_NO=" + projectNo + "'\">귀하에게 견적 문의가 들어왔습니다.</a>";
	        String CONTENT = "전자계약 승인 요청이 왔습니다.";
	        parameter.put("CONTENT", CONTENT);
	        parameter.put("CREATE_ID", "덴트너");
	        parameter.put("UPDATE_ID", "덴트너");
	        service.insert("insert01", parameter);
		  
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }
  @PostMapping(value="/message04_2", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> message04_2(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  
	  String userID = parameter.get("RECEIVE_ID").toString();
	  parameter.put("CREATE_ID", userID);
	  String userPhone = service.string("getPhoneNum02", parameter);
	  parameter.put("userPhone", userPhone);
	  
	  try {
		  LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));	
		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		  HttpSession session = request.getSession();
		  String rtnResult = "";
		  //인증번호 SMS 전송
			  Random random = new Random();
			  String randDigit = String.format("%04d", random.nextInt(10000));
			  parameter.put("content", "[덴트너] 전자계약 수정요청이 왔습니다.");
			  String result = service.sendSMS(parameter);
			  session.setAttribute("smsNo", randDigit);
			  session.setAttribute("smsTime", now.format(formatter));
			  rtnResult = result;

		  rtnMap.put("result", rtnResult);
		  
	        parameter.put("SEND_ID", "덴트너");
	        //parameter.put("RECEIVE_ID", receiveId);
	        //String CONTENT = "<a class=\"note_box_list_context\" href=\"javascript:location.href='https://dentner.co.kr/api/project/project_request_view?PROJECT_NO=" + projectNo + "'\">귀하에게 견적 문의가 들어왔습니다.</a>";
	        String CONTENT = "전자계약 수정요청이 왔습니다.";
	        parameter.put("CONTENT", CONTENT);
	        parameter.put("CREATE_ID", "덴트너");
	        parameter.put("UPDATE_ID", "덴트너");
	        service.insert("insert01", parameter);
		  
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }
  @PostMapping(value="/message05", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> message05(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  
	  String userID = service.string("getUserID", parameter);
	  String userPhone = service.string("getPhoneNum", parameter);
	  parameter.put("userPhone", userPhone);
	  parameter.put("RECEIVE_ID", userID);
	  try {
		  LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));	
		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		  HttpSession session = request.getSession();
		  String rtnResult = "";
		  //인증번호 SMS 전송
			  Random random = new Random();
			  String randDigit = String.format("%04d", random.nextInt(10000));
			  parameter.put("content", "[덴트너] 지정견적 요청이 왔습니다.");
			  String result = service.sendSMS(parameter);
			  session.setAttribute("smsNo", randDigit);
			  session.setAttribute("smsTime", now.format(formatter));
			  rtnResult = result;
		  rtnMap.put("result", rtnResult);
		  
	        parameter.put("SEND_ID", "덴트너");
	        //parameter.put("RECEIVE_ID", receiveId);
	        //String CONTENT = "<a class=\"note_box_list_context\" href=\"javascript:location.href='https://dentner.co.kr/api/project/project_request_view?PROJECT_NO=" + projectNo + "'\">귀하에게 견적 문의가 들어왔습니다.</a>";
	        String CONTENT = "지정견적 요청이 왔습니다.";
	        parameter.put("CONTENT", CONTENT);
	        parameter.put("CREATE_ID", "덴트너");
	        parameter.put("UPDATE_ID", "덴트너");
	        service.insert("insert01", parameter);
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }
  @PostMapping(value="/message06", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> message06(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  
	  String userID = service.string("getUserID", parameter);
	  String userPhone = service.string("getPhoneNum", parameter);
	  parameter.put("userPhone", userPhone);
	  parameter.put("RECEIVE_ID", userID);
	  try {
		  LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));	
		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		  HttpSession session = request.getSession();
		  String rtnResult = "";
		  //인증번호 SMS 전송
			  Random random = new Random();
			  String randDigit = String.format("%04d", random.nextInt(10000));
			  parameter.put("content", "[덴트너] 의뢰인이 전자계약 작성을 요청했습니다.");
			  String result = service.sendSMS(parameter);
			  session.setAttribute("smsNo", randDigit);
			  session.setAttribute("smsTime", now.format(formatter));
			  rtnResult = result;
		  rtnMap.put("result", rtnResult);
		  
	        parameter.put("SEND_ID", "덴트너");
	        //parameter.put("RECEIVE_ID", receiveId);
	        //String CONTENT = "<a class=\"note_box_list_context\" href=\"javascript:location.href='https://dentner.co.kr/api/project/project_request_view?PROJECT_NO=" + projectNo + "'\">귀하에게 견적 문의가 들어왔습니다.</a>";
	        String CONTENT = "의뢰인이 전자계약 작성을 요청했습니다.";
	        parameter.put("CONTENT", CONTENT);
	        parameter.put("CREATE_ID", "덴트너");
	        parameter.put("UPDATE_ID", "덴트너");
	        service.insert("insert01", parameter);
		  
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }
  @PostMapping(value="/message07", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> message07(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  
	  
	  String userID = parameter.get("USER_ID").toString();
	  String userPhone = service.string("getPhoneNum02", parameter);
	  parameter.put("userPhone", userPhone);
	  parameter.put("RECEIVE_ID", userID);
	  try {
		  LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));	
		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		  HttpSession session = request.getSession();
		  String rtnResult = "";
		  //인증번호 SMS 전송
			  Random random = new Random();
			  String randDigit = String.format("%04d", random.nextInt(10000));
			  parameter.put("content", "[덴트너] 의뢰인이 입금 확인을 요청합니다. 확인 후 '진행내역'에서 입금 확인 버튼을 눌러주세요.");
			  String result = service.sendSMS(parameter);
			  session.setAttribute("smsNo", randDigit);
			  session.setAttribute("smsTime", now.format(formatter));
			  rtnResult = result;

		  rtnMap.put("result", rtnResult);
		  
	        parameter.put("SEND_ID", "덴트너");
	        //parameter.put("RECEIVE_ID", receiveId);
	        //String CONTENT = "<a class=\"note_box_list_context\" href=\"javascript:location.href='https://dentner.co.kr/api/project/project_request_view?PROJECT_NO=" + projectNo + "'\">귀하에게 견적 문의가 들어왔습니다.</a>";
	        String CONTENT = "의뢰인이 입금 확인을 요청합니다. 확인 후 '진행내역'에서 입금 확인 버튼을 눌러주세요.";
	        parameter.put("CONTENT", CONTENT);
	        parameter.put("CREATE_ID", "덴트너");
	        parameter.put("UPDATE_ID", "덴트너");
	        service.insert("insert01", parameter);
		  
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }
  @PostMapping(value="/message08", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> message08(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  String userID = service.string("getUserID", parameter);
	  String userPhone = service.string("getPhoneNum", parameter);
	  parameter.put("userPhone", userPhone);
	  parameter.put("RECEIVE_ID", userID);
	  
	  try {
		  LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));	
		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		  HttpSession session = request.getSession();
		  String rtnResult = "";
		  //인증번호 SMS 전송
			  Random random = new Random();
			  String randDigit = String.format("%04d", random.nextInt(10000));
			  parameter.put("content", "[덴트너] 상대방이 계약 취소요청을 하였습니다.");
			  String result = service.sendSMS(parameter);
			  session.setAttribute("smsNo", randDigit);
			  session.setAttribute("smsTime", now.format(formatter));
			  rtnResult = result;

		  rtnMap.put("result", rtnResult);
		  
	        parameter.put("SEND_ID", "덴트너");
	        //parameter.put("RECEIVE_ID", receiveId);
	        //String CONTENT = "<a class=\"note_box_list_context\" href=\"javascript:location.href='https://dentner.co.kr/api/project/project_request_view?PROJECT_NO=" + projectNo + "'\">귀하에게 견적 문의가 들어왔습니다.</a>";
	        String CONTENT = "상대방이 계약 취소요청을 하였습니다.";
	        parameter.put("CONTENT", CONTENT);
	        parameter.put("CREATE_ID", "덴트너");
	        parameter.put("UPDATE_ID", "덴트너");
	        service.insert("insert01", parameter);
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }
  @PostMapping(value="/message08_2", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> message08_2(HttpServletRequest request) throws Exception {
	  Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	  Map<String, Object> rtnMap = new HashMap<>();
	  
	  String userID = parameter.get("RECEIVE_ID").toString();
	  parameter.put("USER_ID", userID);
	  String userPhone = service.string("getPhoneNum02", parameter);
	  parameter.put("userPhone", userPhone);
	  
	  try {
		  LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));	
		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		  HttpSession session = request.getSession();
		  String rtnResult = "";
		  //인증번호 SMS 전송
			  Random random = new Random();
			  String randDigit = String.format("%04d", random.nextInt(10000));
			  parameter.put("content", "[덴트너] 상대방이 계약 취소요청을 하였습니다.");
			  String result = service.sendSMS(parameter);
			  session.setAttribute("smsNo", randDigit);
			  session.setAttribute("smsTime", now.format(formatter));
			  rtnResult = result;

		  rtnMap.put("result", rtnResult);
		  
	        parameter.put("SEND_ID", "덴트너");

	        //parameter.put("RECEIVE_ID", receiveId);
	        //String CONTENT = "<a class=\"note_box_list_context\" href=\"javascript:location.href='https://dentner.co.kr/api/project/project_request_view?PROJECT_NO=" + projectNo + "'\">귀하에게 견적 문의가 들어왔습니다.</a>";
	        String CONTENT = "상대방이 계약 취소요청을 하였습니다. 마이페이지>진행내역에서 보실 수 있습니다. (제목: " + parameter.get("TITLE").toString() + ")";
	        parameter.put("CONTENT", CONTENT);
	        parameter.put("CREATE_ID", "덴트너");
	        parameter.put("UPDATE_ID", "덴트너");
	        service.insert("insert01", parameter);
	  } catch (Exception e) {
		  logger.error(e.getMessage());
	  }
	  return rtnMap;
  }
}
