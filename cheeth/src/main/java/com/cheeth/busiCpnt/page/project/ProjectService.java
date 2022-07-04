package com.cheeth.busiCpnt.page.project;

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

@Service("ProjectService")
public class ProjectService extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(ProjectService.class);
  
  @Value("${upload.default.path}")
  String uploadDir;
  
  @Autowired
  private FileUtil fileUtil;
  
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
    
    // 지정견적자 등록
    String publicCd = ObjectUtils.isEmpty(parameter.get("PUBLIC_CD")) ? "" : parameter.get("PUBLIC_CD").toString();
    String receiveIdList = ObjectUtils.isEmpty(parameter.get("RECEIVE_ID_LIST")) ? "" : ParameterUtil.reverseCleanXSS(parameter.get("RECEIVE_ID_LIST").toString());
    if(!ObjectUtils.isEmpty(projectNo) && publicCd.equals("U001") && !ObjectUtils.isEmpty(receiveIdList)) {
      JsonElement jsonElement = JsonParser.parseString(receiveIdList);
      if(jsonElement != null && jsonElement.getAsJsonArray().size() > 0) {
        parameter.put("PROJECT_NO", projectNo);
        delete("delete03", parameter);
      }
      for(int i=0; i<jsonElement.getAsJsonArray().size(); i++) {
        JsonObject object = new JsonObject();
        object = (JsonObject) jsonElement.getAsJsonArray().get(i);
        String receiveId = object.get("USER_ID").getAsString();
        Map<String, String> insertMap = new HashMap<String, String>();
        insertMap.put("PROJECT_NO", projectNo);
        insertMap.put("USER_ID", receiveId);
        insertMap.put("CREATE_ID", userId);
        insertMap.put("UPDATE_ID", userId);
        insert("insert05", insertMap);
      }
    }
    
    return rtnMap;
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
