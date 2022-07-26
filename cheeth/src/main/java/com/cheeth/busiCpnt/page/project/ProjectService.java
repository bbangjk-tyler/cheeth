package com.cheeth.busiCpnt.page.project;

import java.io.File;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.ObjectUtils;
import org.springframework.web.multipart.MultipartFile;

import com.cheeth.comAbrt.service.AbstractService;
import com.cheeth.comUtils.ParameterUtil;
import com.cheeth.comUtils.file.FileUtil;
import com.cheeth.busiCpnt.page.talk.TalkService;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.popbill.api.MessageService;

import com.popbill.api.PopbillException;
@Service("ProjectService")
public class ProjectService extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(ProjectService.class);
  
  @Autowired
  private MessageService messageService;
  
  @Value("${upload.default.path}")
  String uploadDir;
  
  @Autowired
  private FileUtil fileUtil;
  
  @Value("${popbill.testCorpNum}")
  private String testCorpNum;
  
  @Value("${popbill.testUserID}")
  private String testUserID;
  public Map<?, ?> getData01(Map<String, Object> parameter) throws Exception {
    
    Map<?, ?> rtnMap = map("getData01", parameter);
    
    return rtnMap;
  }
  
  public Map<?, ?> getData02(Map<String, Object> parameter) throws Exception {
    
    Map<?, ?> rtnMap = map("getData02", parameter);
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> save01(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> user = getUserInfo();
    String userId = user.get("USER_ID");
    
    String projectNo = ObjectUtils.isEmpty(parameter.get("PROJECT_NO")) ? "" : parameter.get("PROJECT_NO").toString();
    String reqs = ObjectUtils.isEmpty(parameter.get("REQS")) ? "" : parameter.get("REQS").toString();
    
    String deliveryExpDate1 = ObjectUtils.isEmpty(parameter.get("DELIVERY_EXP_DATE_1")) ? "" : parameter.get("DELIVERY_EXP_DATE_1").toString().replaceAll("-", "");
    String deliveryExpDate2 = ObjectUtils.isEmpty(parameter.get("DELIVERY_EXP_DATE_2")) ? "2330" : parameter.get("DELIVERY_EXP_DATE_2").toString();
    parameter.put("DELIVERY_EXP_DATE", deliveryExpDate1 + deliveryExpDate2);
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    rtnMap.put("result", "Y");
    
    if(ObjectUtils.isEmpty(projectNo)) {
      if(ObjectUtils.isEmpty(reqs)) {
        rtnMap.put("result", "N");
      } else {
        String[] reqsList = reqs.split("l");
        if(reqsList == null || reqsList.length == 0) {
          rtnMap.put("result", "N");
        } else {
          insert("insert01", parameter);
          projectNo = string("common", "getLastInsertId", parameter);
          for(int i=0; i<reqsList.length; i++) {
            Map<String, String> insertMap = new HashMap<String, String>();
            insertMap.put("PROJECT_NO", projectNo);
            insertMap.put("RQST_NO", reqsList[i]);
            insertMap.put("CREATE_ID", userId);
            insertMap.put("UPDATE_ID", userId);
            insert("insert04", insertMap);
            update("update05", insertMap);
          }
        }
      }
    } else {
      update("update01", parameter);
      String[] reqsList = reqs.split("l");
      if(reqsList != null && reqsList.length > 0) {
        delete("delete02", parameter);
        for(int i=0; i<reqsList.length; i++) {
          Map<String, String> insertMap = new HashMap<String, String>();
          insertMap.put("PROJECT_NO", projectNo);
          insertMap.put("RQST_NO", reqsList[i]);
          insertMap.put("CREATE_ID", userId);
          insertMap.put("UPDATE_ID", userId);
          insert("insert04", insertMap);

        }
      }
    }
    System.out.println("들어옴1");
    System.out.println("projectNo : " + projectNo);
    rtnMap.put("projectNo", projectNo);
    // 지정견적자 등록
    String publicCd = ObjectUtils.isEmpty(parameter.get("PUBLIC_CD")) ? "" : parameter.get("PUBLIC_CD").toString();
    String receiveIdList = ObjectUtils.isEmpty(parameter.get("RECEIVE_ID_LIST")) ? "" : ParameterUtil.reverseCleanXSS(parameter.get("RECEIVE_ID_LIST").toString());
    if(!ObjectUtils.isEmpty(projectNo) && publicCd.equals("U001") && !ObjectUtils.isEmpty(receiveIdList)) {
       System.out.println("들어옴2");
      JsonElement jsonElement = JsonParser.parseString(receiveIdList);
      if(jsonElement != null && jsonElement.getAsJsonArray().size() > 0) {
        parameter.put("PROJECT_NO", projectNo);
        delete("delete03", parameter);
      }
      for(int i=0; i<jsonElement.getAsJsonArray().size(); i++) {
        JsonObject object = new JsonObject();
        System.out.println("들어옴3");
        object = (JsonObject) jsonElement.getAsJsonArray().get(i);
        String receiveId = object.get("USER_ID").getAsString();
        Map<String, String> insertMap = new HashMap<String, String>();
        insertMap.put("PROJECT_NO", projectNo);
        insertMap.put("USER_ID", receiveId);
        insertMap.put("CREATE_ID", userId);
        insertMap.put("UPDATE_ID", userId);
        
        insert("insert05", insertMap);
        
        // talk/save01 넣기(메시지 전송)
        Map<String, String> rtnMap2 = new HashMap<String, String>();
       
        rtnMap2.put("SEND_ID", "관리자");
        rtnMap2.put("RECEIVE_ID", receiveId);
        String CONTENT = "<a class=\"note_box_list_context\" href=\"javascript:location.href='https://dentner.co.kr/api/project/project_request_view?PROJECT_NO=" + projectNo + "'\">귀하에게 견적 문의가 들어왔습니다.</a>"; 
        rtnMap2.put("CONTENT", CONTENT);
        rtnMap2.put("FILE_CD", fileUtil.createFileCd());
        rtnMap2.put("CREATE_ID", "관리자");
        rtnMap2.put("UPDATE_ID", "관리자");
        System.out.println("CONTENT" + CONTENT);
        System.out.println("FILE_CD" + fileUtil.createFileCd());
        System.out.println("projectNo" + projectNo);
        
        insert("insert06", rtnMap2);
        
		  LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));	
		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		 
		  String rtnResult = "";
		  //인증번호 SMS 전송
		  
		  parameter.put("CREATE_ID", receiveId);
		  String userPhone  = string("common", "getPhoneNum02", parameter);
		  
		  parameter.put("userPhone", userPhone);
		  parameter.put("content", "[덴트너] 지정견적 요청이 왔습니다.");
		  String result = sendSMS(parameter);
      }
    }
    
    
    return rtnMap;
  }
  public String sendSMS(Map<String, Object> parameter) throws Exception {
	  String sender = "02-2273-2822";
	  String receiver = String.valueOf(parameter.get("userPhone"));
	  String content = String.valueOf(parameter.get("content"));
	
	  // 전송예약일시, null인 경우 즉시전송
	  Date reserveDT = null;
	
	  // 광고 메시지 여부 ( true , false 중 택 1)
	  // └ true = 광고 , false = 일반
	  Boolean adsYN = false;
	
	  // 전송요청번호
	  // 팝빌이 접수 단위를 식별할 수 있도록 파트너가 할당한 식별번호.
	  // 1~36자리로 구성. 영문, 숫자, 하이픈(-), 언더바(_)를 조합하여 팝빌 회원별로 중복되지 않도록 할당.
	  String requestNum = "";
	
	
	  String receiptNum = messageService.sendSMS(testCorpNum, sender, receiver, "", content, reserveDT, adsYN, testUserID, requestNum);

    return receiptNum;
  }
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> save02(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    
    int cnt = integer("getCnt02", parameter);
    if(cnt > 0) {
      rtnMap.put("result", "N");
      rtnMap.put("msg", "이미 견적서를 제출하셨습니다.");
      return rtnMap;
    }
    
    List<MultipartFile> multipartFileList = (List<MultipartFile>) parameter.get("files");
    if(!ObjectUtils.isEmpty(multipartFileList)) {
      if(!fileUtil.imgMimeTypeChk(multipartFileList.toArray(new MultipartFile[multipartFileList.size()]))) {
        throw new IllegalStateException("올바른 파일이 아닙니다.");
      }
      
      String fileDiv = String.valueOf(parameter.get("fileDiv"));
      List<Map<String, Object>> fileInfoList = fileUtil.getMultiPartFileInfo(multipartFileList, fileDiv);
      
      int fileIdx = 0;
      for(Map<String, Object> fileInfo : fileInfoList) {
        if(!ObjectUtils.isEmpty(parameter.get("path"))) {
          String path = ((String)parameter.get("path")).replaceAll("&#47;", "\\/");
          fileUtil.setFileSaveUrlDirect(fileDiv, path, fileInfo);
        }
        fileUtil.saveMultiPartFileBack(multipartFileList.get(fileIdx++), fileInfo, uploadDir + File.separator);
        fileInfo.put("CREATE_ID", parameter.get("CREATE_ID"));
        insert("common", "insertFile", fileInfo);
        parameter.put("FILE_CD", fileInfo.get("FILE_CD"));
      }
    }
    
    insert("insert02", parameter);
    String estimatorNo = string("common", "getLastInsertId", parameter);
    
    List<Map<String, Object>> suppInfoList = (List<Map<String, Object>>) parameter.get("suppInfo");
    for(Map<String, Object> suppInfo : suppInfoList) {
      suppInfo.put("ESTIMATOR_NO", estimatorNo);
      suppInfo.put("CREATE_ID", parameter.get("CREATE_ID"));
      suppInfo.put("UPDATE_ID", parameter.get("UPDATE_ID"));
      insert("insert03", suppInfo);
    }
    
    rtnMap.put("result", "Y");

    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> delete01(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    
    Integer cnt = 0; // 삭제 조건 추후 수정
    if(cnt == 0) {
    	
    	delete("delete03", parameter);
    	delete("delete02", parameter);
    	delete("delete01", parameter);
    }
    
    rtnMap.put("result", "Y");
    
    return rtnMap;
  }
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> updateHit(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    
    update("update02", parameter);
    
    rtnMap.put("result", "Y");
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> updateEstimatorDelYn(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    
    update("update03", parameter);
    rtnMap.put("result", "Y");
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> updateMatchingYn(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    
    int cnt = integer("getCnt03", parameter);
    if(cnt > 0) {
      rtnMap.put("result", "N");
      rtnMap.put("msg", "이미 매칭된 견적서가 존재합니다.");
      return rtnMap;
    }
    
    update("update04", parameter);
    rtnMap.put("result", "Y");
    
    return rtnMap;
  }
}