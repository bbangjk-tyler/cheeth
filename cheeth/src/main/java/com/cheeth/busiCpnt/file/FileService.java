package com.cheeth.busiCpnt.file;

import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import com.cheeth.comAbrt.service.AbstractService;
import com.cheeth.comUtils.ParameterUtil;

@Service("FileService")
public class FileService extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(FileService.class);
  
  @Value("${upload.default.path}")
  String defaultPath;
  
  public void download(HttpServletRequest request, HttpServletResponse response) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    Map<String, String> user = getUserInfo();
    String userId = user.get("USER_ID").toString();
    
    Map<?, ?> fileInfo = map("getFileInfo", parameter);
    if(!ObjectUtils.isEmpty(fileInfo)) {
      String fileOriginNm = URLEncoder.encode(fileInfo.get("FILE_ORIGIN_NM").toString(), "UTF-8");
      String fileDirectory = fileInfo.get("FILE_DIRECTORY").toString();
      String fileNm = fileInfo.get("FILE_NM").toString();
      
      StringBuilder fileDownUrl = new StringBuilder();
      fileDownUrl.append(defaultPath);
      fileDownUrl.append(File.separator);
      fileDownUrl.append(fileDirectory);
      
//      System.out.println("fileDownUrl -> " + fileDownUrl.toString());
      
      File file = new File(fileDownUrl.toString());
      
      response.setContentType("application/force-download");
      response.setHeader("Content-Disposition", "attachment; filename=\"" + fileOriginNm + "\"");
      response.setHeader("Set-Cookie", "fileDownload=true; path=/");
      response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
      
      FileInputStream inStream = new FileInputStream(file);
      IOUtils.copy(inStream, response.getOutputStream());
      inStream.close();
    }
  }

}
