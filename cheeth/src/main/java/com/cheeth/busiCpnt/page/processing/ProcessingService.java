package com.cheeth.busiCpnt.page.processing;

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

@Service("ProcessingService")
public class ProcessingService extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(ProcessingService.class);
  
  @Autowired
  private FileUtil fileUtil;
  
  @Value("${upload.default.path}")
  String uploadDir;
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save01(Map<String, Object> parameter) throws Exception {

    Map<String, Object> rtnMap = new HashMap<String, Object>();
    
    String progNo = ObjectUtils.isEmpty(parameter.get("PROG_NO")) ? "" : parameter.get("PROG_NO").toString();
    
    if(ObjectUtils.isEmpty(progNo)) {
      insert("insert01", parameter);
      progNo = string("common", "getLastInsertId", parameter);
      
      // 가공 기능 품목 start
      String workItem = ObjectUtils.isEmpty(parameter.get("WORK_ITEM")) ? "" : ParameterUtil.reverseCleanXSS(parameter.get("WORK_ITEM").toString());
      if(!ObjectUtils.isEmpty(workItem)) {
        JsonElement jsonElement = JsonParser.parseString(workItem);
        Map<String, Object> insertMap = new HashMap<String, Object>();
        insertMap.put("PROG_NO", progNo);
        for(int i=0; i<jsonElement.getAsJsonArray().size(); i++) {
          JsonObject object = new JsonObject();
          object = (JsonObject) jsonElement.getAsJsonArray().get(i);
          String workItemCd = object.get("WORK_ITEM_CD").getAsString();
          String workItemNm = object.get("WORK_ITEM_NM").getAsString();
          insertMap.put("WORK_ITEM_CD", workItemCd);
          insertMap.put("WORK_ITEM_NM", ParameterUtil.cleanXSS(workItemNm));
          insertMap.put("CREATE_ID", parameter.get("CREATE_ID"));
          insertMap.put("UPDATE_ID", parameter.get("UPDATE_ID"));
          insert("insert02", insertMap);
        }
      }
      // 가공 기능 품목 end
      
    } else {
      update("update01", parameter);
      // 가공 기능 품목 start
      String workItem = ObjectUtils.isEmpty(parameter.get("WORK_ITEM")) ? "" : ParameterUtil.reverseCleanXSS(parameter.get("WORK_ITEM").toString());
      if(!ObjectUtils.isEmpty(workItem)) {
        JsonElement jsonElement = JsonParser.parseString(workItem);
        Map<String, Object> insertMap = new HashMap<String, Object>();
        insertMap.put("PROG_NO", progNo);
        if(jsonElement.getAsJsonArray().size() > 0) delete("delete02", parameter); // 가공센터 가공 가능 품목 삭제
        for(int i=0; i<jsonElement.getAsJsonArray().size(); i++) {
          JsonObject object = new JsonObject();
          object = (JsonObject) jsonElement.getAsJsonArray().get(i);
          String workItemCd = object.get("WORK_ITEM_CD").getAsString();
          String workItemNm = object.get("WORK_ITEM_NM").getAsString();
          insertMap.put("WORK_ITEM_CD", workItemCd);
          insertMap.put("WORK_ITEM_NM", ParameterUtil.cleanXSS(workItemNm));
          insertMap.put("CREATE_ID", parameter.get("CREATE_ID"));
          insertMap.put("UPDATE_ID", parameter.get("UPDATE_ID"));
          insert("insert02", insertMap);
        }
      }
      // 가공 기능 품목 end
    }

    rtnMap.put("result", "Y");

    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save02(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    
    List<MultipartFile> filesList = (List<MultipartFile>) parameter.get("files");
    if(!ObjectUtils.isEmpty(filesList)) {
      if(!fileUtil.imgMimeTypeChk(filesList.toArray(new MultipartFile[filesList.size()]))) {
        throw new IllegalStateException("올바른 파일이 아닙니다.");
      }
      String fileDiv = "PROG";
      List<Map<String, Object>> fileInfoList = fileUtil.getMultiPartFileInfo(filesList, fileDiv);
      int fileIdx = 0;
      for(Map<String, Object> fileInfo : fileInfoList) {
        if(!ObjectUtils.isEmpty(parameter.get("path"))) {
          String path = ((String)parameter.get("path")).replaceAll("&#47;", "\\/");
          fileUtil.setFileSaveUrlDirect(fileDiv, path, fileInfo);
        }
        fileUtil.saveMultiPartFileBack(filesList.get(fileIdx++), fileInfo, uploadDir + File.separator);
        fileInfo.put("CREATE_ID", parameter.get("CREATE_ID"));
        insert("common", "insertFile", fileInfo);
        parameter.put("PROFILE_FILE_CD", fileInfo.get("FILE_CD"));
      }
    }
    
    String imageFileCd = ObjectUtils.isEmpty(parameter.get("PROFILE_FILE_CD")) ? "" : parameter.get("PROFILE_FILE_CD").toString();
    if(!ObjectUtils.isEmpty(imageFileCd)) update("update02", parameter); // 이미지 파일
    
    rtnMap.put("result", "Y");
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> delete01(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    Integer cnt = integer("getCnt02", parameter);
    if(cnt > 0) {
      delete("delete02", parameter); // 가공센터 가공 가능 품목 삭제
      delete("delete01", parameter); // 가공센터 삭제
    }
    
    return rtnMap;
  }

}
