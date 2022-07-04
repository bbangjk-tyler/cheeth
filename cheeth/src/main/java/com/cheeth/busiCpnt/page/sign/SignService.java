package com.cheeth.busiCpnt.page.sign;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

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

@Service("SignService")
public class SignService extends AbstractService {

  protected Logger logger = LogManager.getLogger(SignService.class);
  
  @Value("${upload.default.path}")
  String uploadDir; 
  
  @Autowired
  private FileUtil fileUtil;

  public Map getSnsInfo(Map<String, Object> parameter) throws Exception {
    return map("getSnsInfo", parameter);
  }

  @Transactional(propagation = Propagation.REQUIRED)
  public Map<String, Object> save01(Map<String, Object> parameter) throws Exception {
    
	Map<String, Object> rtnMap = new HashMap<>();
	
	List<MultipartFile> compFiles = new ArrayList<>();
	List<MultipartFile> licenseFiles = new ArrayList<>();
	
	if(!ObjectUtils.isEmpty(parameter.get("COMP_FILE"))) {
	  compFiles = (List<MultipartFile>) parameter.get("COMP_FILE");
	}
	if(!ObjectUtils.isEmpty(parameter.get("LICENSE_FILE"))) {
	  licenseFiles = (List<MultipartFile>) parameter.get("LICENSE_FILE");
	}
    
    List<Map<String, Object>> compFileInfoList = fileUtil.getMultiPartFileInfo(compFiles, "COMP");
    List<Map<String, Object>> licenseFileInfoList = fileUtil.getMultiPartFileInfo(licenseFiles, "LICENSE");
    
    List<Map<String, Object>> fileInfoList = Stream.of(compFileInfoList, licenseFileInfoList).flatMap(list -> list.stream()).collect(Collectors.toList());
    
    for(Map fileInfo : fileInfoList) {
      
      if("COMP".equals(fileInfo.get("FILE_DIV"))) {
        fileUtil.saveMultiPartFileBack(compFiles.get(((int)fileInfo.get("FILE_NO"))-1), fileInfo, uploadDir + File.separator);
        parameter.put("COMP_FILE_CD", fileInfo.get("FILE_CD"));
      } else if("LICENSE".equals(fileInfo.get("FILE_DIV"))) {
        fileUtil.saveMultiPartFileBack(licenseFiles.get(((int)fileInfo.get("FILE_NO"))-1), fileInfo, uploadDir + File.separator);
        parameter.put("LICENSE_FILE_CD", fileInfo.get("FILE_CD"));
      }
      
      fileInfo.put("CREATE_ID", parameter.get("USER_ID"));
      insert("insertFile", fileInfo);
    }
    
    parameter.put("CREATE_ID", parameter.get("USER_ID"));
    insert("save01", parameter);
    rtnMap.put("result", "Y");
    
    return rtnMap;
  }
  
}
