package com.cheeth.busiCpnt.page.mypage;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
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
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Service("MypageService")
public class MypageService extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(MypageService.class);
  
  @Autowired
  private FileUtil fileUtil;
  
  @Value("${upload.default.path}")
  String uploadDir;
  
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
  public Map<String, Object> getData10(Map<String, Object> parameter) throws Exception {
	  Map<String, Object> rtnMap = new HashMap<String, Object>();
	    Map<?, ?> data = map("getData01", parameter);
	    rtnMap.put("DATA", data);
	    return rtnMap;
	    //return data;
	  }
  public Map<?, ?> getData02(Map<String, Object> parameter) throws Exception {
    Map<?, ?> rtnMap = map("getData02", parameter);
    return rtnMap;
  }
  
  public Map<?, ?> getData04(Map<String, Object> parameter) throws Exception {
    Map<?, ?> rtnMap = map("getData04", parameter);
    return rtnMap;
  }
  
  public Map<?, ?> getData05(Map<String, Object> parameter) throws Exception {
    Map<?, ?> rtnMap = map("getData05", parameter);
    return rtnMap;
  }
  
  public Map<?, ?> getData06(Map<String, Object> parameter) throws Exception {
    Map<?, ?> rtnMap = map("getData06", parameter);
    return rtnMap;
  }
  public Map<String, Object> getData03(Map<String, Object> parameter) throws Exception {
	    
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
	    
	   // Integer cnt = integer("getCnt01", parameter);
	    List<?> list =list("getList10", parameter);
	    
	   // rtnMap.put("TOTAL_CNT", cnt);
	    rtnMap.put("LIST", list);
	    
	    return rtnMap;
	  }
  public Map<String, Object> getData07(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    
    Map<?,?> data01 = map("getData07", parameter); // 기본정보
    rtnMap.put("DATA_01", data01);
    
    Map<?,?> data02 = map("getData08", parameter); // 상세정보
    rtnMap.put("DATA_02", data02);
    
    Map<?,?> data03 = map("getData09", parameter); // 거래정보
    rtnMap.put("DATA_03", data03);
    
    parameter.put("GROUP_CD", "CAREER_CD");
    rtnMap.put("CAREER_CD_LIST", list("common", "getCode", parameter)); // 경력코드
    
    parameter.put("GROUP_CD", "PROJECT_CD");
    rtnMap.put("PROJECT_CD_LIST", list("common", "getCode", parameter)); // 프로젝트 코드
    
    return rtnMap;
  }
  
  public Map<?, ?> getProfile(Map<String, Object> parameter) throws Exception {
    
    String targetUserId = ObjectUtils.isEmpty(parameter.get("TARGET_USER_ID")) ? "" : parameter.get("TARGET_USER_ID").toString();
    Map<String, Object> data = new HashMap<String, Object>();
    if(!ObjectUtils.isEmpty(targetUserId)) {
      Map<String, String> serachMap = new HashMap<String, String>();
      serachMap.put("USER_ID", targetUserId);
      data.put("DATA_01", map("mypage", "getData07", serachMap));
      data.put("DATA_02", map("mypage", "getData08", serachMap));
      data.put("DATA_03", map("mypage", "getData09", serachMap));
    }
    
    return data;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save01(Map<String, Object> parameter) throws Exception {
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    Integer cnt = integer("getCnt02", parameter);
    rtnMap.put("cnt", cnt);
    if(cnt == 0) {
      Map<?, ?> data = map("getData03", parameter);
      if(data != null && !data.isEmpty()) {
        insert("insert01", data);
      }
    }
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save02(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    Map<String, String> user = getUserInfo();
    
    String wrNo = ObjectUtils.isEmpty(parameter.get("WR_NO")) ? "" : parameter.get("WR_NO").toString();
    Integer cnt04 = integer("getCnt04", parameter);
    Integer cnt05 = integer("getCnt05", parameter);
    
    List<MultipartFile> multipartFileList = (List<MultipartFile>) parameter.get("files");
    String fileList = ObjectUtils.isEmpty(parameter.get("fileList")) ? "" : ParameterUtil.reverseCleanXSS(parameter.get("fileList").toString());
    if(cnt04 > 0 && cnt05 == 0 && !ObjectUtils.isEmpty(wrNo) && !ObjectUtils.isEmpty(multipartFileList) && !ObjectUtils.isEmpty(fileList)) {

      Integer updateCnt = (Integer) update("update01", parameter);
      rtnMap.put("cnt", updateCnt);
      
      if(!fileUtil.mimeTypeChk(multipartFileList.toArray(new MultipartFile[multipartFileList.size()]))) {
//      throw new IllegalStateException("올바른 파일이 아닙니다.");
      }
      
      JsonElement jsonElement = JsonParser.parseString(fileList);
      Map<String, Object> insertMap = new HashMap<String, Object>();
      
      for(int i=0; i<jsonElement.getAsJsonArray().size(); i++) {
        
        JsonObject object = new JsonObject();
        object = (JsonObject) jsonElement.getAsJsonArray().get(i);
        String rqstNo = object.get("RQST_NO").getAsString();
        
        String fileCd = fileUtil.createFileCd();
        insertMap.put("WR_NO", wrNo);
        insertMap.put("FILE_CD", fileCd);
        insertMap.put("RQST_NO", rqstNo);
        insertMap.put("CREATE_ID", user.get("CREATE_ID"));
        insertMap.put("UPDATE_ID", user.get("UPDATE_ID"));
        
        insert("insert02", insertMap);
        
        MultipartFile multipartFile = multipartFileList.get(i); // 파일목록
        
        String fileOriginNm = multipartFile.getOriginalFilename();
        String saveFileNm = fileUtil.saveFileName() + "1";
        String fileExteNm = fileUtil.fileExteNm(fileOriginNm);
        String dir = fileUtil.makeUrl("wr");
        String saveUrl = dir + saveFileNm + "." + fileExteNm;
        
        insertMap.put("FILE_NO", 1);
        insertMap.put("FILE_CD", fileCd);
        insertMap.put("FILE_NM", saveFileNm + "." + fileExteNm);
        insertMap.put("FILE_DIRECTORY", saveUrl);
        insertMap.put("FILE_ORIGIN_NM", multipartFile.getOriginalFilename());
        insertMap.put("FILE_SIZE", multipartFile.getSize());
        insertMap.put("FILE_TYPE", fileExteNm);
        
        insert("common", "insertFile", insertMap);
        
        fileUtil.makeDirectory(uploadDir + File.separator + dir);
        fileUtil.save(uploadDir + File.separator + saveUrl, multipartFile);
      }
    } else {
      rtnMap.put("cnt", 0);
    }
    
    rtnMap.put("result", "Y");
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save03(Map<String, Object> parameter) throws Exception {
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    Integer cnt01 = integer("getCnt08", parameter);
    Integer cnt02 = integer("getCnt10", parameter); // 파일수령 여부
    if(cnt01 > 0 && cnt02 == 0) {
      Integer updateCnt = (Integer) update("update02", parameter);
      rtnMap.put("cnt", updateCnt);
    } else {
      rtnMap.put("cnt", 0);
    }
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save04(Map<String, Object> parameter) throws Exception {
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
//    WHERE A.PROJECT_NO = #{PROJECT_NO}
//    AND A.CREATE_ID = #{CREATE_ID}
    
    Map<?, ?> data = map("getData01", parameter);
    Map<?, ?> data2 = map("getData02", parameter);
    
    List<Map<String, Object>> cardsettingList = (List<Map<String, Object>>) parameter.get("cardsetting");

    if(data != null && !data.isEmpty()) {
//      delete("delete02", data);
      
//      delete("delete03", data);
      update("update03", data);
      update("update11", data2);
//      delete("delete01", data);
    }
    
    return rtnMap;
  }

  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> ProjectCancel(Map<String, Object> parameter) throws Exception {
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    if(parameter.get("WR_NO") != null) {
//    	delete("delete02", parameter);
//    	delete("delete01", parameter);
    	 update("update03", parameter);
    }
   
    update("update11", parameter);
    update("update14", parameter);
    return rtnMap;
  }
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> StateUpdate(Map<String, Object> parameter) throws Exception {
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    update("update11", parameter);
    return rtnMap;
  }
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save05(Map<String, Object> parameter) throws Exception {
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    Integer cnt = integer("getCnt08", parameter);
    if(cnt > 0) {
      Integer updateCnt = (Integer) update("update04", parameter);
      rtnMap.put("cnt", updateCnt);
    } else {
      rtnMap.put("cnt", 0);
    }
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save06(Map<String, Object> parameter) throws Exception {
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    Integer cnt = integer("getCnt11", parameter);
    if(cnt > 0) {
      Integer updateCnt = (Integer) update("update05", parameter);
      rtnMap.put("cnt", updateCnt);
    } else {
      rtnMap.put("cnt", 0);
    }
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save07(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    List<MultipartFile> compFiles = new ArrayList<>();
    List<MultipartFile> LicenseFiles = new ArrayList<>();
    if (!ObjectUtils.isEmpty(parameter.get("COMP_FILE"))) {
      compFiles = (List<MultipartFile>) parameter.get("COMP_FILE");
    }
    if (!ObjectUtils.isEmpty(parameter.get("LICENSE_FILE"))) {
    	LicenseFiles = (List<MultipartFile>) parameter.get("LICENSE_FILE");
    }
    
    List<Map<String, Object>> compFileInfoList = fileUtil.getMultiPartFileInfo(compFiles, "COMP");
    for(Map fileInfo : compFileInfoList) {
      fileUtil.saveMultiPartFileBack(compFiles.get(((int)fileInfo.get("FILE_NO"))-1), fileInfo, uploadDir + File.separator);
      System.out.println("FILE_CD 1 :: "  + fileInfo.get("FILE_CD"));
      parameter.put("COMP_FILE_CD", fileInfo.get("FILE_CD"));
      fileInfo.put("CREATE_ID", parameter.get("CREATE_ID"));
      insert("insertFile", fileInfo);
    }
    List<Map<String, Object>> LicenseFilesList = fileUtil.getMultiPartFileInfo(LicenseFiles, "COMP");
    for(Map fileInfo2 : LicenseFilesList) {
        fileUtil.saveMultiPartFileBack(LicenseFiles.get(((int)fileInfo2.get("FILE_NO"))-1), fileInfo2, uploadDir + File.separator);
        System.out.println("FILE_CD 2 :: "  + fileInfo2.get("FILE_CD"));
        parameter.put("LICENSE_FILE_CD", fileInfo2.get("FILE_CD"));
        fileInfo2.put("CREATE_ID", parameter.get("CREATE_ID"));
        insert("insertFile", fileInfo2);
      }
    
    Integer updateCnt = (Integer) update("update06", parameter);
    rtnMap.put("cnt", updateCnt);
    

    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save08(HttpServletRequest request, Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    String userNickName = ObjectUtils.isEmpty(parameter.get("USER_NICK_NAME")) ? "" : parameter.get("USER_NICK_NAME").toString().trim();
    if(!ObjectUtils.isEmpty(userNickName)) {
      parameter.put("USER_NICK_NAME", userNickName);
      Integer cnt = integer("getCnt12", parameter);
      if(cnt == 0) {
        Integer updateCnt = (Integer) update("update07", parameter);
        if(updateCnt > 0) {
          Map<?, ?> info = map("login.login", "getInfoRefresh", parameter); // 세션 닉네임 변경
          if(info != null && !info.isEmpty()) {
            HttpSession session = request.getSession();
            if(session != null) {
              session.invalidate();
              Map<String, Object> sessionInfo = new HashMap<String, Object>();
              sessionInfo.put("user", info); // 사용자 정보
              session.setAttribute("sessionInfo", sessionInfo);
              
              //로그아웃 ->로그인(세션정보 수정)
          //  HttpSession session = request.getSession();
          //  session.invalidate();
          //  Map<?, ?> info = new login.login.map("getInfo", parameter);
          //  Map<String, Object> sessionInfo = new HashMap<String, Object>();
          //  sessionInfo.put("user", info); // 사용자 정보
          //  session.setAttribute("sessionInfo", sessionInfo);
            }
          }
        }
      } else {
        rtnMap.put("result", "N");
        rtnMap.put("message", "이미 사용중인 닉네임 입니다.");
      }
    }
    
    return rtnMap;
  }
  
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save09(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    
    List<MultipartFile> profileFileList = (List<MultipartFile>) parameter.get("profile_files");
    if(!ObjectUtils.isEmpty(profileFileList)) {
      if(!fileUtil.imgMimeTypeChk(profileFileList.toArray(new MultipartFile[profileFileList.size()]))) {
        throw new IllegalStateException("올바른 파일이 아닙니다.");
      }
      String fileDiv = "PROFILE";
      List<Map<String, Object>> fileInfoList = fileUtil.getMultiPartFileInfo(profileFileList, fileDiv);
      int fileIdx = 0;
      for(Map<String, Object> fileInfo : fileInfoList) {
        if(!ObjectUtils.isEmpty(parameter.get("path"))) {
          String path = ((String)parameter.get("path")).replaceAll("&#47;", "\\/");
          fileUtil.setFileSaveUrlDirect(fileDiv, path, fileInfo);
        }
        fileUtil.saveMultiPartFileBack(profileFileList.get(fileIdx++), fileInfo, uploadDir + File.separator);
        fileInfo.put("CREATE_ID", parameter.get("CREATE_ID"));
        insert("common", "insertFile", fileInfo);
        parameter.put("PROFILE_FILE_CD", fileInfo.get("FILE_CD"));
      }
    }
    
    List<MultipartFile> imageFileList = (List<MultipartFile>) parameter.get("image_files");
    if(!ObjectUtils.isEmpty(imageFileList)) {
      if(!fileUtil.imgMimeTypeChk(imageFileList.toArray(new MultipartFile[imageFileList.size()]))) {
        throw new IllegalStateException("올바른 파일이 아닙니다.");
      }
      String fileDiv = "PROFILE";
      List<Map<String, Object>> fileInfoList = fileUtil.getMultiPartFileInfo(imageFileList, fileDiv);
      int fileIdx = 0;
      for(Map<String, Object> fileInfo : fileInfoList) {
        if(!ObjectUtils.isEmpty(parameter.get("path"))) {
          String path = ((String)parameter.get("path")).replaceAll("&#47;", "\\/");
          fileUtil.setFileSaveUrlDirect(fileDiv, path, fileInfo);
        }
        fileUtil.saveMultiPartFileBack(imageFileList.get(fileIdx++), fileInfo, uploadDir + File.separator);
        fileInfo.put("CREATE_ID", parameter.get("CREATE_ID"));
        insert("common", "insertFile", fileInfo);
        parameter.put("IMAGE_FILE_CD", fileInfo.get("FILE_CD"));
      }
    }
    
    String profileFileCd = ObjectUtils.isEmpty(parameter.get("PROFILE_FILE_CD")) ? "" : parameter.get("PROFILE_FILE_CD").toString();
    String imageFileCd = ObjectUtils.isEmpty(parameter.get("IMAGE_FILE_CD")) ? "" : parameter.get("IMAGE_FILE_CD").toString();
    
    Integer cnt = integer("getCnt13", parameter);
    if(cnt == 0) {
      insert("insert03", parameter);
    } else {
      update("update08", parameter);
      if(!ObjectUtils.isEmpty(profileFileCd)) update("update09", parameter); // 프로필 파일
      if(!ObjectUtils.isEmpty(imageFileCd)) update("update10", parameter); // 이미지 파일
    }
    
    rtnMap.put("result", "Y");
    
    return rtnMap;
  }

}
