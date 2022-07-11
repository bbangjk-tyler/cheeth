package com.cheeth.busiCpnt.page.talk;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Service("TalkService")
public class TalkService extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(TalkService.class);
  
  @Value("${upload.default.path}")
  String uploadDir;
  
  @Autowired
  private FileUtil fileUtil;
  
  public Map<String, Object> getData01(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    
    Map<String, String> user = getUserInfo();
    String userId = user.get("USER_ID").toString();
    
    parameter.put("RECEIVE_ID", userId);
    
    Integer page = 0;
    if(!ObjectUtils.isEmpty(parameter.get("PAGE")) && parameter.get("PAGE").toString().chars().allMatch(Character::isDigit)) {
      page = Integer.parseInt(parameter.get("PAGE").toString());
      if(page == 1) {
        page = 0;
      } else {
        page = (page-1) * 10;
      }
    }
    parameter.put("PAGE", page);
    
    rtnMap.put("TOTAL_CNT", integer("getCnt01", parameter)); // 총건수
    rtnMap.put("LIST", list("getList01", parameter)); // 목록조회
    
    parameter.put("GROUP_CD", "TALK_CD");
    rtnMap.put("TALK_CD_LIST", list("common", "getCode", parameter)); // 읽은쪽지, 안읽은쪽지 코드
    
    Map<String, Object> searchMap = new HashMap<String, Object>();
    searchMap.put("SEND_ID", userId);
    
    rtnMap.put("SEND_CNT", integer("getCnt02", searchMap));
    
    searchMap.clear();
    searchMap.put("RECEIVE_ID", userId);
    
    rtnMap.put("TOTAL_RECEIVE_CNT", integer("getCnt03", searchMap)); // 전체쪽지 수
    rtnMap.put("NREAD_RECEIVE_CNT", integer("getCnt04", searchMap)); // 안읽은 쪽시 수
    
    // 전체회원 목록 조회
    searchMap.clear();
    searchMap.put("USER_ID", userId);
    List<?> userList = list("getUserList", searchMap);
    rtnMap.put("USER_LIST", userList);
    rtnMap.put("USER_CNT", userList.size());
    
    return rtnMap;
  }
  public  Map<String, Object> getUnreadCnt(Map<String, Object> parameter) {
	  Map<String, Object> rtnMap = new HashMap<String, Object>();
	  try {
		rtnMap.put("TOTAL_CNT", integer("getCnt04", parameter));
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	  
	  return rtnMap;
  }
  public  Map<String, Object> getUnreadCnt2(Map<String, Object> parameter) {
	    Map<String, String> user = getUserInfo();
	    String userId = user.get("USER_ID").toString();
	    parameter.put("RECEIVE_ID", userId);
	    Map<String, Object> rtnMap = new HashMap<String, Object>();
	  try {
		rtnMap.put("TOTAL_CNT", integer("getCnt05", parameter));
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	  return rtnMap;
  }
//  public  Map<String, String> getUnreadCnt2(String userID) {
//	    Map<String, String> user = getUserInfo();
//	    
//	    Map<String, String> parameter = new HashMap<String, String>();
//	    parameter.put("SEND_ID", userID);
//	    Map<String, String> rtnMap = new HashMap<String, String>();
//	  try {
//		  rtnMap.put("TOTAL_CNT", integer("getCnt04", parameter));
//	} catch (Exception e) {
//		// TODO Auto-generated catch block
//		e.printStackTrace();
//	}
//	  return rtnMap;
//}
  public Map<String, Object> getData02(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    
    Map<String, String> user = getUserInfo();
    String userId = user.get("USER_ID").toString();
    
    parameter.put("SEND_ID", userId);
    
    Integer page = 0;
    if(!ObjectUtils.isEmpty(parameter.get("PAGE")) && parameter.get("PAGE").toString().chars().allMatch(Character::isDigit)) {
      page = Integer.parseInt(parameter.get("PAGE").toString());
      if(page == 1) {
        page = 0;
      } else {
        page = (page-1) * 10;
      }
    }
    parameter.put("PAGE", page);
    
    rtnMap.put("TOTAL_CNT", integer("getCnt02", parameter)); // 총건수
    rtnMap.put("LIST", list("getList02", parameter)); // 목록조회
    
    parameter.put("GROUP_CD", "TALK_CD");
    rtnMap.put("TALK_CD_LIST", list("common", "getCode", parameter)); // 읽은쪽지, 안읽은쪽지 코드
    
    Map<String, Object> searchMap = new HashMap<String, Object>();
    searchMap.put("SEND_ID", userId);
    
    rtnMap.put("SEND_CNT", integer("getCnt02", searchMap));
    
    searchMap.clear();
    searchMap.put("RECEIVE_ID", userId);
    
    rtnMap.put("TOTAL_RECEIVE_CNT", integer("getCnt03", searchMap));
    rtnMap.put("NREAD_RECEIVE_CNT", integer("getCnt04", searchMap));
    
    // 전체회원 목록 조회
    searchMap.clear();
    searchMap.put("USER_ID", userId);
    List<?> userList = list("getUserList", searchMap);
    rtnMap.put("USER_LIST", userList);
    rtnMap.put("USER_CNT", userList.size());
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> getData03(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> user = getUserInfo();
    parameter.put("RECEIVE_ID", user.get("USER_ID").toString());
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    Map<?, ?> dataMap = map("getData03", parameter);
    rtnMap.put("info", dataMap);
    rtnMap.put("fList", "");
    if(dataMap != null && !dataMap.isEmpty()) {
      update("update03", parameter); // 읽음처리
      String fileCd = ObjectUtils.isEmpty(dataMap.get("FILE_CD")) ? "" : dataMap.get("FILE_CD").toString();
      if(!ObjectUtils.isEmpty(fileCd)) {
        rtnMap.put("fList", list("file.file", "getFileList", dataMap));
      }
    }
    
    return rtnMap;
  }
  
  public Map<String, Object> getData04(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> user = getUserInfo();
    parameter.put("SEND_ID", user.get("USER_ID").toString());
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    Map<?, ?> dataMap = map("getData04", parameter);
    rtnMap.put("info", dataMap);
    rtnMap.put("fList", "");
    if(dataMap != null && !dataMap.isEmpty()) {
      String fileCd = ObjectUtils.isEmpty(dataMap.get("FILE_CD")) ? "" : dataMap.get("FILE_CD").toString();
      if(!ObjectUtils.isEmpty(fileCd)) {
        rtnMap.put("fList", list("file.file", "getFileList", dataMap));
      }
    }
    
    return rtnMap;
  }
  
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> save01(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    Map<String, String> user = getUserInfo();
    
    String receiveIdList = ObjectUtils.isEmpty(parameter.get("RECEIVE_ID_LIST")) ? "" : ParameterUtil.reverseCleanXSS(parameter.get("RECEIVE_ID_LIST").toString()); // 받는사람
    if(!ObjectUtils.isEmpty(receiveIdList)) {
      List<MultipartFile> multipartFileList = (List<MultipartFile>) parameter.get("files");
      if(!ObjectUtils.isEmpty(multipartFileList)) {
        
        if(!fileUtil.mimeTypeChk(multipartFileList.toArray(new MultipartFile[multipartFileList.size()]))) {
//        throw new IllegalStateException("올바른 파일이 아닙니다.");
        }
        
        String fileDiv = "talk";
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
      
      parameter.put("SEND_ID", user.get("USER_ID").toString());
      if(ObjectUtils.isEmpty(parameter.get("FILE_CD"))) {
        parameter.put("FILE_CD", fileUtil.createFileCd());
      }
      
      JsonElement jsonElement = JsonParser.parseString(receiveIdList);
      for(int i=0; i<jsonElement.getAsJsonArray().size(); i++) {
        JsonObject object = new JsonObject();
        object = (JsonObject) jsonElement.getAsJsonArray().get(i);
        String userId = object.get("USER_ID").getAsString();
        parameter.put("RECEIVE_ID", userId);
        insert("insert01", parameter);
      }
    }
    
    rtnMap.put("result", "Y");

    return rtnMap;
  }
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> save05(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    
    parameter.put("SEND_ID", "관리자");
    parameter.put("RECEIVE_ID", parameter.get("RECEIVE_ID"));
    parameter.put("CONTENT", parameter.get("CONTENT"));
    insert("insert01", parameter);

    rtnMap.put("result", "Y");

    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> delete01(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    Map<String, String> user = getUserInfo();
    
    String talkItem = ObjectUtils.isEmpty(parameter.get("TALK_ITEM")) ? "" : ParameterUtil.reverseCleanXSS(parameter.get("TALK_ITEM").toString());
    if(!ObjectUtils.isEmpty(talkItem)) {
      JsonElement jsonElement = JsonParser.parseString(talkItem);
      Map<String, Object> updateMap = new HashMap<String, Object>();
      for(int i=0; i<jsonElement.getAsJsonArray().size(); i++) {
        JsonObject object = new JsonObject();
        object = (JsonObject) jsonElement.getAsJsonArray().get(i);
        String talkCd = object.get("TALK_NO").getAsString();
        updateMap.put("TALK_NO", talkCd);
        updateMap.put("RECEIVE_ID", user.get("USER_ID"));
        insert("update01", updateMap);
      }
    }
    
    rtnMap.put("result", "Y");
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> delete02(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    Map<String, String> user = getUserInfo();
    parameter.put("RECEIVE_ID", user.get("USER_ID").toString());
    
    insert("update01", parameter);
    
    rtnMap.put("result", "Y");

    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> delete03(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    Map<String, String> user = getUserInfo();
    
    String talkItem = ObjectUtils.isEmpty(parameter.get("TALK_ITEM")) ? "" : ParameterUtil.reverseCleanXSS(parameter.get("TALK_ITEM").toString());
    if(!ObjectUtils.isEmpty(talkItem)) {
      JsonElement jsonElement = JsonParser.parseString(talkItem);
      Map<String, Object> updateMap = new HashMap<String, Object>();
      for(int i=0; i<jsonElement.getAsJsonArray().size(); i++) {
        JsonObject object = new JsonObject();
        object = (JsonObject) jsonElement.getAsJsonArray().get(i);
        String talkCd = object.get("TALK_NO").getAsString();
        updateMap.put("TALK_NO", talkCd);
        updateMap.put("SEND_ID", user.get("USER_ID"));
        insert("update02", updateMap);
      }
    }
    
    rtnMap.put("result", "Y");
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> delete04(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    Map<String, String> user = getUserInfo();
    parameter.put("SEND_ID", user.get("USER_ID").toString());
    
    insert("update02", parameter);
    
    rtnMap.put("result", "Y");

    return rtnMap;
  }
  

}
