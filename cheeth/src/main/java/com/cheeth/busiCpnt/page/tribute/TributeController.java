package com.cheeth.busiCpnt.page.tribute;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.cheeth.comAbrt.controller.BaseController;
import com.cheeth.comUtils.ParameterUtil;
import com.cheeth.comUtils.file.FileUtil;

@RestController
@RequestMapping(value="${api.url}/tribute")
public class TributeController extends BaseController {
  
  protected Logger logger = LogManager.getLogger(TributeController.class);
  
  @Value("${api.url}")
  String apiUrl;
  
  @Autowired
  private TributeService service;
  
  @Autowired
  private FileUtil fileUtil;
  
  @GetMapping(value="/tribute_request")
  public ModelAndView tribute_request(HttpServletRequest request) throws Exception {
      
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    ModelAndView mv = new ModelAndView("page/tribute/tribute_request");
    if(isSession()) {
      parameter.put("GROUP_CD", "PRO_METH_CD");
      mv.addObject("PRO_METH_CD_LIST", service.list("common", "getCode", parameter));
      
      parameter.put("GROUP_CD", "SHADE_CD");
      mv.addObject("SHADE_CD_LIST", service.list("common", "getCode", parameter));
      
      HttpSession session = request.getSession();
      if(session != null && session.getAttribute("sessionInfo") != null) {
        Map<?, ?> sessionInfo = (Map<?, ?>) session.getAttribute("sessionInfo");
        Map<?, ?> user = (Map<?, ?>) sessionInfo.get("user");
        parameter.put("USER_ID", user.get("USER_ID"));
        mv.addObject("OFTEN_WORD_LIST", service.list("getOftenWordList", parameter));
      }
      mv.addObject("FILE_CD", fileUtil.createFileCd());
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
      
    return mv;
  }
  
  @PostMapping(value = "/saveOftenWord", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> saveOftenWord(HttpServletRequest request) throws Exception {
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> resultMap = new HashMap<>();
    
    try {
      resultMap = service.saveOftenWord(parameter);
    } catch (Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
    return resultMap;
  }
  
  @PostMapping(value = "/deleteOftenWord", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> deleteOftenWord(HttpServletRequest request) throws Exception {
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> resultMap = new HashMap<>();
    
    try{
      parameter.put("USER_ID", parameter.get("CREATE_ID"));
      service.delete("delete01", parameter);
    }catch (Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
    return resultMap;
  }
  
  @PostMapping(value = "/uploadFile", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> uploadFile(HttpServletRequest request) throws Exception {
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, Object> resultMap = new HashMap<>();
    
    try {
        resultMap = service.uploadFile(parameter);
  	} catch (Exception e) {
  	  resultMap.put("result", "N");
  	  logger.error(e.getMessage());
  	}
    return resultMap;
  }
  
  @PostMapping(value = "/save", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> save(HttpServletRequest request, @RequestBody Map<String, Object> args) throws Exception {
  	Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
  	Map<String, Object> resultMap = new HashMap<>();
	  
	  try {
  		resultMap = service.save(parameter);
  	} catch (Exception e) {
  	  resultMap.put("result", "N");
  	  logger.error(e.getMessage());
  	}
  	return resultMap;
  }
  
  @GetMapping(value = "/request_basket")
  public ModelAndView request_basket(HttpServletRequest request) throws Exception {
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    ModelAndView mv = new ModelAndView("page/tribute/request_basket");
    
    mv.addObject("PAGE", ObjectUtils.isEmpty(parameter.get("PAGE")) ? "1" : parameter.get("PAGE")); // 현재 페이지
    Integer page = 0;
    if(!ObjectUtils.isEmpty(parameter.get("PAGE")) && parameter.get("PAGE").toString().chars().allMatch(Character::isDigit)) {
      page = Integer.parseInt(parameter.get("PAGE").toString());
      if(page == 1) {
        page = 0;
      } else {
        page = (page-1) * 5;
      }
    }
    parameter.put("PAGE", page);
    
    List<Map<String, Object>> list = (List<Map<String, Object>>) service.list("getRequestBasketList", parameter);
    for(Map<String, Object> obj : list) {
      obj.put("SUPP_NM_STR", ParameterUtil.reverseCleanXSS(obj.get("SUPP_NM_STR").toString()));
      
	  if(obj.get("SUPP_NM_STR").toString().contains("Frame") || obj.get("SUPP_NM_STR").toString().contains("Splint") || obj.get("SUPP_NM_STR").toString().contains("의치")
			  || obj.get("SUPP_NM_STR").toString().contains("교정") || obj.get("SUPP_NM_STR").toString().contains("트레이")) {
		  
		  Map<String, Object> parameter2 = ParameterUtil.getParameterMap(request);
		  String GROUP_CD = obj.get("GROUP_CD").toString();
		  parameter2.put("GROUP_CD", GROUP_CD);
		  List<Map<String, Object>> list2 = (List<Map<String, Object>>) service.list("getReqInfoList", parameter2);
		  int sumctn = 0;  
		  for(Map<String, Object> obj2 : list2) {     
		      int cnt = Integer.parseInt(obj2.get("SUPP_GROUP_CNT").toString());
		  	  if(obj2.get("SUPP_NM_1").toString().contains("Frame") || obj2.get("SUPP_NM_1").toString().contains("Splint") || obj2.get("SUPP_NM_1").toString().contains("의치")
		  			  || obj2.get("SUPP_NM_1").toString().contains("교정") || obj2.get("SUPP_NM_1").toString().contains("트레이")) {
		  		cnt = 1;
		  	  }
		  	sumctn += cnt;
		    }
		  obj.put("TOOTH_CNT", sumctn);
	  }
    }
    mv.addObject("LIST", list);
    mv.addObject("TOTAL_CNT", service.integer("getCnt01", parameter)); // 총건수
    mv.addObject("REQS", parameter.get("REQS"));
    mv.addObject("PROJECT_NO", parameter.get("PROJECT_NO"));
    
    return mv;
  }
  
  @GetMapping(value = "/getReqInfo", produces = MediaType.APPLICATION_JSON_VALUE)
  public List<Map<String, Object>> getReqInfo(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    List<Map<String, Object>> list = (List<Map<String, Object>>) service.list("getReqInfoList", parameter);
    for(Map<String, Object> obj : list) {
      obj.put("SUPP_NM_1", ParameterUtil.reverseCleanXSS(obj.get("SUPP_NM_1").toString()));
      obj.put("TRIBUTE_DTL", service.list("getReqDtlInfoList", obj));
      obj.put("EXCEPTION_BRIDGE", service.list("getExceptionBridgeList", obj));
      
	  if(obj.get("SUPP_NM_1").toString().contains("Frame") || obj.get("SUPP_NM_1").toString().contains("Splint") || obj.get("SUPP_NM_1").toString().contains("의치")
			  || obj.get("SUPP_NM_1").toString().contains("교정") || obj.get("SUPP_NM_1").toString().contains("트레이")) {
		  //SUPP_GROUP_CNT
		  //Frame, Splint, 의치, 교정, 트레이
		  obj.put("SUPP_GROUP_CNT", "1");
	  }
    }
    return list;
  }
  
  @PostMapping(value = "/getSuppInfo", produces = MediaType.APPLICATION_JSON_VALUE)
  public List<Map<String, Object>> getSuppInfo(HttpServletRequest request, @RequestBody Map<String, Object> args) throws Exception {
    
	Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
	List<Map<String, Object>> list = (List<Map<String, Object>>) service.list("getSuppInfoList", parameter);
	for(Map<String, Object> obj : list) {
	  obj.put("SUPP_NM_STR", ParameterUtil.reverseCleanXSS(obj.get("SUPP_NM_STR").toString()));
	  System.out.println("SUPP_NM_STR " + obj.get("SUPP_NM_STR").toString());
	  Iterator<String> keys = obj.keySet().iterator();
      while( keys.hasNext() ){
          String key = keys.next();
          String value = obj.get(key).toString();
          System.out.println("키 : "+key+", 값 : "+value);
      }
	  if(obj.get("SUPP_NM_STR").toString().contains("Frame") || obj.get("SUPP_NM_STR").toString().contains("Splint") || obj.get("SUPP_NM_STR").toString().contains("의치")
			  || obj.get("SUPP_NM_STR").toString().contains("교정") || obj.get("SUPP_NM_STR").toString().contains("트레이")) {
		  String GROUP_CD_STR = obj.get("GROUP_CD_STR").toString();
		  int cnt = 1;
		  
		  if(GROUP_CD_STR.contains("|")) {
			  String str[] = GROUP_CD_STR.split("\\|");
			  cnt = str.length;
			  System.out.println("cnt ::" + cnt);
		  }else {
			  cnt = 1;
		  }

		  obj.put("CNT", cnt);
	  }
	}
    return list;
  }
  
  @GetMapping(value = "/getRqstNoList", produces = MediaType.APPLICATION_JSON_VALUE)
  public List<Map<String, Object>> getRqstNoList(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    List<Map<String, Object>> list = (List<Map<String, Object>>) service.list("getRqstNoList", parameter);
    return list;
  }
  
  @PostMapping(value = "/delete", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> delete(HttpServletRequest request, @RequestBody Map<String, Object> args) throws Exception {
	Map<String, Object> rtnMap = new HashMap<>();
	Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	
	try {
	  rtnMap = service.delete(parameter);
	} catch (Exception e) {
	  rtnMap.put("result", "N");
	  logger.error(e.getMessage());
	}
	return rtnMap;
  }
}
