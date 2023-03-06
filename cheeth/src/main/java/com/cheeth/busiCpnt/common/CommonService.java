package com.cheeth.busiCpnt.common;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.ObjectUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.LocaleResolver;

import com.cheeth.busiCpnt.sam0101.Sam0101Service;
import com.cheeth.comAbrt.service.AbstractService;
import com.cheeth.comUtils.file.FileUtil;
import com.popbill.api.MessageService;
import com.popbill.api.PopbillException;

@Service("CommonService")
public class CommonService extends AbstractService {

  protected Logger logger = LogManager.getLogger(Sam0101Service.class);

  @Value("${upload.default.path}")
  String uploadDir; 
  
  @Value("${popbill.testCorpNum}")
  private String testCorpNum;
  
  @Value("${popbill.testUserID}")
  private String testUserID;
  
  @Autowired
  private MessageService messageService;

  @Autowired
  private MessageSource messagesource;

  @Autowired
  private LocaleResolver localeResolver;
  
  @Autowired
  private FileUtil fileUtil;

  public List<?> getList(Map<String, Object> parameter) throws Exception {

    List<?> list = list("getCode", parameter);

    return list;
  }

  public String geti18n(HttpServletRequest request, String property) throws Exception {
	String msg = messagesource.getMessage(property, null, localeResolver.resolveLocale(request));
	if(msg == null)
		msg = "";
	return msg;
  }
  
  public String geti18nParam(HttpServletRequest request, String property, String[] param) throws Exception {
	String msg = messagesource.getMessage(property, param, localeResolver.resolveLocale(request));
	if(msg == null)
		msg = "";
	return msg;
  }
  
  public List<?> getListLang(Map<String, Object> parameter) throws Exception {

	    List<?> list = list("getCodeLang", parameter);

	    return list;
	  }

  public Integer checkId(Map<String, Object> parameter) throws Exception {
    Integer result = integer("checkId", parameter);
    return result;
  }
  
  public Integer checkSign(Map<String, Object> parameter) throws Exception {
	  Integer result = integer("checkSign", parameter);
	  return result;
  }

  public Integer checkNickName(Map<String, Object> parameter) throws Exception {
    Integer result = integer("checkNickName", parameter);
    return result;
  }
  
  public Map<String, Object> uploadImage(Map<String, Object> parameter, MultipartFile[] multipartFiles) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<>();
    
    if(!fileUtil.imgMimeTypeChk(multipartFiles)) {
      throw new IllegalStateException("올바른 파일이 아닙니다.");
    }
    
    List<Map<String, Object>> fileList = new ArrayList<>();
    String fileDiv = String.valueOf(parameter.get("fileDiv"));
    List<Map<String, Object>> fileInfoList = fileUtil.getMultiPartFileInfo(Arrays.asList(multipartFiles), fileDiv);
    
    int fileIdx = 0;
    for(Map<String, Object> fileInfo : fileInfoList) {
      
      if(!ObjectUtils.isEmpty(parameter.get("path"))) {
        String path = ((String)parameter.get("path")).replaceAll("&#47;", "\\/");
        fileUtil.setFileSaveUrlDirect(fileDiv, path, fileInfo);
      }
      fileUtil.saveMultiPartFileBack(multipartFiles[fileIdx++], fileInfo, uploadDir + File.separator);
      fileList.add(fileInfo);
    }
    rtnMap.put("fileList", fileList);
    return rtnMap;
  }
  
  public String sendSMS(Map<String, Object> parameter) throws Exception {
	  String sender = "02-2273-2822";
	  String receiver = String.valueOf(parameter.get("userPhone"));
	  String content = String.valueOf(parameter.get("content"));
	
	  // 전송예약일시, null인 경우 즉시전송
	  Date reserveDT = null;
	
	  // 광고 메시지 여부 ( true , false 중 택 1)
	  // └ true = 광고 , false = 일반
	  Boolean adsYN = false;
	
	  // 전송요청번호
	  // 팝빌이 접수 단위를 식별할 수 있도록 파트너가 할당한 식별번호.
	  // 1~36자리로 구성. 영문, 숫자, 하이픈(-), 언더바(_)를 조합하여 팝빌 회원별로 중복되지 않도록 할당.
	  String requestNum = "";
	
	
	  String receiptNum = messageService.sendSMS(testCorpNum, sender, receiver, "", content, reserveDT, adsYN, testUserID, requestNum);

    return receiptNum;
  }
  

}
