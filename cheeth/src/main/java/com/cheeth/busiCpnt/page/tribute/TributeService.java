package com.cheeth.busiCpnt.page.tribute;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

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

@Service("TributeService")
public class TributeService extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(TributeService.class);
  
  @Value("${upload.default.path}")
  String uploadDir;
  
  @Autowired
  private FileUtil fileUtil;
  
  public Map<String, Object> saveOftenWord(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    
    parameter.put("USER_ID", parameter.get("CREATE_ID"));
    
    insert("insert01", parameter);
    
    rtnMap.put("MNG_NO", parameter.get("MNG_NO"));
    rtnMap.put("result", "Y");
    return rtnMap;
  }
  
  @Transactional(propagation = Propagation.REQUIRED)
  public Map<String, Object> uploadFile(Map<String, Object> parameter) throws Exception {
	  
    Map<String, Object> rtnMap = new HashMap<>();
	  
	List<MultipartFile> multipartFileList = (List<MultipartFile>) parameter.get("files");
		
	if(!ObjectUtils.isEmpty(multipartFileList)) {
	 
	  String fileDiv = String.valueOf(parameter.get("fileDiv"));
	  List<Map<String, Object>> fileInfoList = fileUtil.getMultiPartFileInfo(multipartFileList, fileDiv);
	      
	  int fileIdx = 0;
	  for(Map<String, Object> fileInfo : fileInfoList) {
	        
	    if(!ObjectUtils.isEmpty(parameter.get("path"))) {
	      String path = ((String)parameter.get("path")).replaceAll("&#47;", "\\/");
	      fileUtil.setFileSaveUrlDirect(fileDiv, path, fileInfo);
	    }
	    fileUtil.saveMultiPartFileBack(multipartFileList.get(fileIdx++), fileInfo, uploadDir + File.separator);
	    
	    if(!ObjectUtils.isEmpty(parameter.get("fileCd"))) {
	      fileInfo.put("FILE_CD", parameter.get("fileCd"));
	    }
	    
	    if(!ObjectUtils.isEmpty(parameter.get("fileNo"))) {
	      fileInfo.put("FILE_NO", parameter.get("fileNo"));
	    }
	    
	    fileInfo.put("CREATE_ID", parameter.get("CREATE_ID"));
	    
	    Map<?, ?> deleteFile = map("common", "getFileList", fileInfo);
	    if(!ObjectUtils.isEmpty(deleteFile)) {
	      delete("common", "deleteFile", deleteFile);
	      fileUtil.deleteFile(uploadDir + File.separator + deleteFile.get("FILE_DIRECTORY"));
	    }
	    insert("common", "insertFile", fileInfo);
	  }
	  rtnMap.put("result", "Y");	  
	}
    return rtnMap;
  }
  
  @Transactional(propagation = Propagation.REQUIRED)
  public Map<String, Object> save(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    
    List<Map<String, Object>> cardList = (List<Map<String, Object>>) parameter.get("cards");
    String groupCd = string("getGroupCd", parameter);
    String rqstNo = "";
    String tabNo = "";
    
    for(Map<String, Object> card : cardList) {
      
      card.put("GROUP_CD", groupCd);
      card.put("CREATE_ID", parameter.get("CREATE_ID"));
      card.put("UPDATE_ID", parameter.get("UPDATE_ID"));
      
      Map<String, Object> suppMap = (Map<String, Object>) card.get("SUPP_INFO");
      for(Entry<String, Object> supp : suppMap.entrySet()) {
        card.put(supp.getKey(), supp.getValue());
      }
      insert("insert02", card);
      
      rqstNo = string("common", "getLastInsertId", parameter);
      tabNo = card.get("TAB_NO").toString();
      
      List<String> toothList = (List<String>) card.get("TRIBUTE_DTL");
      for(String tooth : toothList) {
        Map<String, Object> toothMap = new HashMap<>();
        toothMap.put("RQST_NO", rqstNo);
        toothMap.put("GROUP_CD", groupCd);
        toothMap.put("TOOTH_NO", tooth);
        toothMap.put("TAB_NO", tabNo);
        toothMap.put("CREATE_ID", parameter.get("CREATE_ID"));
        toothMap.put("UPDATE_ID", parameter.get("UPDATE_ID"));
        insert("insert03", toothMap);
      }
      
      if(card.get("EXCEPTION_BRIDGE") != null) {
        List<String> exceptionBridgeList = (List<String>) card.get("EXCEPTION_BRIDGE");
        for(String bridge : exceptionBridgeList) {
          Map<String, Object> bridgeMap = new HashMap<>();
          bridgeMap.put("RQST_NO", rqstNo);
          bridgeMap.put("GROUP_CD", groupCd);
          bridgeMap.put("BRIDGE", bridge);
          bridgeMap.put("TAB_NO", tabNo);
          bridgeMap.put("CREATE_ID", parameter.get("CREATE_ID"));
          bridgeMap.put("UPDATE_ID", parameter.get("UPDATE_ID"));
          insert("insert04", bridgeMap);
        }
      }
      
    }
    
    update("update01", parameter);
    update("update02", parameter);
    update("update03", parameter);
    update("update04", parameter);
    update("update05", parameter);
    update("update06", parameter);
    update("update07", parameter);
    update("update08", parameter); // 빈코드 및 명칭 null 변경
    
    rtnMap.put("result", "Y");
    return rtnMap;
  }
  
  @Transactional(propagation = Propagation.REQUIRED)
  public Map<String, Object> delete(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    delete("delete02", parameter);
//    delete("delete03", parameter);
    rtnMap.put("result", "Y");
    return rtnMap;
  }
}
