package com.cheeth.busiCpnt.page.equipment;

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
import com.cheeth.comUtils.file.FileUtil;

@Service("EquipmentService")
public class EquipmentService extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(EquipmentService.class);
  
  @Value("${upload.default.path}")
  String uploadDir;
  
  @Autowired
  private FileUtil fileUtil;
  
  public Map<?, ?> getData01(Map<String, Object> parameter) throws Exception {
    
    Map<?, ?> rtnMap = map("getData01", parameter);
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> save01(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    
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
    
    String deliveryExpDate1 = ObjectUtils.isEmpty(parameter.get("DELIVERY_EXP_DATE_1")) ? "" : parameter.get("DELIVERY_EXP_DATE_1").toString().replaceAll("-", "");
    String deliveryExpDate2 = ObjectUtils.isEmpty(parameter.get("DELIVERY_EXP_DATE_2")) ? "2330" : parameter.get("DELIVERY_EXP_DATE_2").toString();
    parameter.put("DELIVERY_EXP_DATE", deliveryExpDate1 + deliveryExpDate2);
    insert("insert01", parameter);
    
    rtnMap.put("result", "Y");

    return rtnMap;
  
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> update05(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    
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
    
    String deliveryExpDate1 = ObjectUtils.isEmpty(parameter.get("DELIVERY_EXP_DATE_1")) ? "" : parameter.get("DELIVERY_EXP_DATE_1").toString().replaceAll("-", "");
    String deliveryExpDate2 = ObjectUtils.isEmpty(parameter.get("DELIVERY_EXP_DATE_2")) ? "2330" : parameter.get("DELIVERY_EXP_DATE_2").toString();
    parameter.put("DELIVERY_EXP_DATE", deliveryExpDate1 + deliveryExpDate2);
    update("update05", parameter);
    
    rtnMap.put("result", "Y");

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
    String eqpmtMatchingNo = string("common", "getLastInsertId", parameter);
    
    List<Map<String, Object>> dtlInfoList = (List<Map<String, Object>>) parameter.get("dtlInfo");
    for(Map<String, Object> dtlInfo : dtlInfoList) {
      dtlInfo.put("MATCHING_NO", eqpmtMatchingNo);
      dtlInfo.put("EQ_NO", parameter.get("EQ_NO"));
      dtlInfo.put("CREATE_ID", parameter.get("CREATE_ID"));
      dtlInfo.put("UPDATE_ID", parameter.get("UPDATE_ID"));
      insert("insert03", dtlInfo);
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
  public Map<String, String> delete01(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    
    delete("delete01", parameter);
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
