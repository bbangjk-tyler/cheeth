package com.cheeth.busiCpnt.page.cheesigner;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import com.cheeth.comAbrt.service.AbstractService;

@Service("CheesignerService")
public class CheesignerService extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(CheesignerService.class);
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
}
