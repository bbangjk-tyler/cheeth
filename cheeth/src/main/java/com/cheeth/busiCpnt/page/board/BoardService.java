package com.cheeth.busiCpnt.page.board;

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

import com.cheeth.busiCpnt.page.processing.ProcessingService;
import com.cheeth.comAbrt.service.AbstractService;
import com.cheeth.comUtils.file.FileUtil;

@Service("BoardService")
public class BoardService extends AbstractService {

  protected Logger logger = LogManager.getLogger(ProcessingService.class);
  
  @Value("${upload.default.path}")
  String uploadDir;
  
  @Autowired
  private FileUtil fileUtil;
  
  @Transactional(propagation = Propagation.REQUIRED)
  public Map<String, Object> save(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    
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
        parameter.put("IMG_FILE_CD", fileInfo.get("FILE_CD"));
      }
    }
    insert("insert01", parameter);
    rtnMap.put("result", "Y");    
    return rtnMap;
  }
}
