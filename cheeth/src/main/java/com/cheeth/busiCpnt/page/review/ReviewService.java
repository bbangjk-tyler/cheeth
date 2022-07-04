package com.cheeth.busiCpnt.page.review;

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

@Service("ReviewService")
public class ReviewService extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(ReviewService.class);
  
  @Value("${upload.default.path}")
  String uploadDir;
  
  @Autowired
  private FileUtil fileUtil;
  
  public Map<String, Object> getData01(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    
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
    
    Integer cnt = integer("getCnt01", parameter);
    List<?> list =list("getList01", parameter);
    
    rtnMap.put("TOTAL_CNT", cnt);
    rtnMap.put("LIST", list);
    
    return rtnMap;
    
  }
  
  public Map<String, Object> getData02(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    
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
    
    Integer cnt = integer("getCnt02", parameter);
    List<?> list =list("getList02", parameter);
    
    rtnMap.put("TOTAL_CNT", cnt);
    rtnMap.put("LIST", list);
    
    return rtnMap;
    
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save01(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    Integer cnt03 = integer("getCnt03", parameter); // 후기가 등록되어 있는지 확인
    Integer cnt08 = integer("getCnt08", parameter); // 후기가 등록 가능한 계정인지 확인
    
    if(cnt03 == 0 && cnt08 > 0) {
      List<MultipartFile> multipartFileList = (List<MultipartFile>) parameter.get("files");
      if(!ObjectUtils.isEmpty(multipartFileList)) {
        if(!fileUtil.imgMimeTypeChk(multipartFileList.toArray(new MultipartFile[multipartFileList.size()]))) {
          throw new IllegalStateException("올바른 파일이 아닙니다.");
        }
        String fileDiv = "REVIEW";
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
      insert("insert01", parameter);
    }
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save02(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    Integer cnt05 = integer("getCnt05", parameter); // 답변 가능한 계정인지 확인
    Integer cnt06 = integer("getCnt06", parameter); // 답변 등록되어 있는지 확인
    if(cnt05 > 0) {
      if(cnt06 == 0) {
        insert("insert02", parameter);
      } else {
        update("update02", parameter);
      }
    }
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save03(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    Integer cnt6 = integer("getCnt06", parameter); // 답변 여부
    Integer cnt7 = integer("getCnt07", parameter); // 후기가 등록 가능한 계정인지 확인
    if(cnt6 == 0 && cnt7 > 0) {
      int fileCnt = 0;
      List<MultipartFile> multipartFileList = (List<MultipartFile>) parameter.get("files");
      if(!ObjectUtils.isEmpty(multipartFileList)) {
        if(!fileUtil.imgMimeTypeChk(multipartFileList.toArray(new MultipartFile[multipartFileList.size()]))) {
          throw new IllegalStateException("올바른 파일이 아닙니다.");
        }
        String fileDiv = "REVIEW";
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
          fileCnt++;
        }
      }
      if(fileCnt == 0) {
        update("update03", parameter);
      } else {
        update("update01", parameter); // 파일변경
      }
    }
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> delete01(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    Integer cnt = integer("getCnt04", parameter);
    if(cnt > 0) {
      delete("delete02", parameter); // 답변삭제
      delete("delete01", parameter); // 후기삭제
    }
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> delete02(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    Integer cnt = integer("getCnt07", parameter); // 후기 작성자 확인
    if(cnt > 0) {
      delete("delete02", parameter); // 답변삭제
      delete("delete01", parameter); // 후기삭제
    }
    
    return rtnMap;
  }

}
