package com.cheeth.busiCpnt.page.contract;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.ObjectUtils;

import com.cheeth.comAbrt.service.AbstractService;

@Service("ContractService")
public class ContractService extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(ContractService.class);
  
  public Map<String, Object> getData01(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    
    parameter.put("GROUP_CD", "PROJECT_CD");
    rtnMap.put("PROJECT_CD_LIST", list("common", "getCodeLang", parameter));
    //rtnMap.put("PROJECT_CD_LIST", list("common", "getCode", parameter));
    
    Integer cnt01 = integer("getCnt01", parameter);
    Integer cnt02 = integer("getCnt02", parameter);
    Integer cnt04 = integer("getCnt04", parameter); // 계약종료 여부
    
    rtnMap.put("CNT01", cnt01);
    rtnMap.put("CNT02", cnt02);
    rtnMap.put("CNT04", cnt04);
    
    Map<?, ?> data = map("getData01", parameter);
    rtnMap.put("DATA", data);
    
    return rtnMap;
  }
  
  // 승인요청
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save01(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    Integer cnt01 = integer("getCnt01", parameter); // 프로젝트 생성자
    Integer cnt02 = integer("getCnt02", parameter); // 치자이너
    Integer cnt03 = integer("getCnt03", parameter); // 등록여부
    
    if(cnt01 > 0) {
      if(cnt03 == 0) {
        insert("insert01", parameter);
      } else {
        parameter.put("PROGRESS_CD", "PC001"); // 의뢰자 승인요청
        update("update01", parameter);
      }
    } else if(cnt02 > 0) {
      parameter.put("PROGRESS_CD", "PC002"); // 치자이너 승인요청
      update("update01", parameter);
    } else {
      rtnMap.put("result", "N");
    }
    
    return rtnMap;
  }
  
  // 승인
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save02(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    Integer cnt01 = integer("getCnt01", parameter); // 프로젝트 생성자
    Integer cnt02 = integer("getCnt02", parameter); // 치자이너
    
    Map<?, ?> data = map("getData01", parameter);
    String progressCd = ObjectUtils.isEmpty(data.get("PROGRESS_CD")) ? "" : data.get("PROGRESS_CD").toString();
    
    if((cnt01 > 0 || cnt02 > 0) &&  !ObjectUtils.isEmpty(progressCd) && !progressCd.equals("PC005")) {
      insert("update04", parameter); // 계약완료
    } else {
      rtnMap.put("result", "N");
    }
    
    return rtnMap;
  }
  
  // 수정요청
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, Object> save03(Map<String, Object> parameter) throws Exception {
    
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("result", "Y");
    
    Integer cnt01 = integer("getCnt01", parameter); // 프로젝트 생성자
    Integer cnt02 = integer("getCnt02", parameter); // 치자이너
    
    Map<?, ?> data = map("getData01", parameter);
    String progressCd = ObjectUtils.isEmpty(data.get("PROGRESS_CD")) ? "" : data.get("PROGRESS_CD").toString();
    
    if(cnt01 > 0 && (progressCd.equals("PC002") || progressCd.equals("PC004"))) { // 프로젝트 생성자 기준으로 치자니어가 승인요청, 수정요청 한 경우 본인이 수정요청 가능
      parameter.put("PROGRESS_CD", "PC003");
      update("update05", parameter);
    } else if(cnt02 > 0 && (progressCd.equals("PC001") || progressCd.equals("PC003"))) { // 위와 반대
      parameter.put("PROGRESS_CD", "PC004");
      update("update05", parameter);
    } else {
      rtnMap.put("result", "N");
    }
    
    return rtnMap;
  }
  
  // 계약취소
  @Transactional(propagation=Propagation.REQUIRED)
  public Map<String, String> delete01(Map<String, Object> parameter) throws Exception {
    
    Map<String, String> rtnMap = new HashMap<String, String>();
    rtnMap.put("result", "Y");
    
    Integer resultCnt = 0;
    
    Integer cnt01 = integer("getCnt01", parameter);
    Integer cnt02 = integer("getCnt02", parameter);
    
    Map<?, ?> data = map("getData01", parameter);
    String progressCd = ObjectUtils.isEmpty(data.get("PROGRESS_CD")) ? "" : data.get("PROGRESS_CD").toString();
    
    if(cnt01 > 0 && (ObjectUtils.isEmpty(progressCd) || progressCd.equals("PC002") || progressCd.equals("PC004"))) { // 의뢰자(프로젝트 생성자) 삭제일 경우
      delete("delete01", parameter);
      update("update02", parameter);
      resultCnt++;
    } else if(cnt02 > 0 && (ObjectUtils.isEmpty(progressCd) || progressCd.equals("PC001") || progressCd.equals("PC003"))) { // 치자이너 삭제일 경우
      delete("delete01", parameter);
      update("update03", parameter);
      resultCnt++;
    }
    
    if(resultCnt == 0) {
      rtnMap.put("result", "N");
    }
    
    return rtnMap;
  }

}
