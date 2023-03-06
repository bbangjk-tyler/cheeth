package com.cheeth.busiCpnt.page.project;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.tiles.jsp.taglib.GetAsStringTag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import com.cheeth.busiCpnt.common.CommonService;
import com.cheeth.comAbrt.controller.BaseController;
import com.cheeth.comUtils.ParameterUtil;

@RestController
@RequestMapping(value="${api.url}/project")
public class ProjectController extends BaseController {
  
  protected Logger logger = LogManager.getLogger(ProjectController.class);
  
  @Value("${api.url}")
  String apiUrl;
  
  @Autowired
  private ProjectService service;
  
  @Autowired
  private CommonService comm;
  
  @GetMapping(value="/project_view_all")
  public ModelAndView project_view_all(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/project/project_view_all");
    
    mv.addObject("PAGE", ObjectUtils.isEmpty(parameter.get("PAGE")) ? "1" : parameter.get("PAGE")); // 현재 페이지
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

    String lang = request.getSession().getAttribute("language").toString();
    parameter.put("LANG", lang);
    
    mv.addObject("TOTAL_CNT", service.integer("getCnt01", parameter)); // 총건수
    
    mv.addObject("LIST", service.list("getList01", parameter)); // 목록조회
    
    parameter.put("GROUP_CD", "PROJECT_CD");

    mv.addObject("PROJECT_CD_LIST", service.list("common", "getCodeLang", parameter));
    //mv.addObject("PROJECT_CD_LIST", service.list("common", "getCode", parameter)); // 프로젝트 코드
    mv.addObject("SEARCH_TXT", parameter.get("SEARCH_TXT"));
    return mv;
  }
  
  @GetMapping(value="/project_request_view")
  public ModelAndView project_request_view(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/project/project_request_view");
    
    if(isSession()) {
      service.updateHit(parameter);
      mv.addObject("PROJECT_NO", parameter.get("PROJECT_NO"));
      
      parameter.put("GROUP_CD", "PROJECT_CD");
      String lang = request.getSession().getAttribute("language").toString();
      parameter.put("LANG", lang);
      mv.addObject("PROJECT_CD_LIST", service.list("common", "getCodeLang", parameter)); 
      
      parameter.put("GROUP_CD", "CADSW_CD");
      mv.addObject("CADSW_CD_LIST", service.list("common", "getCodeLang", parameter));
      
      Map<?, ?> data = service.getData02(parameter);
      mv.addObject("DATA", data); // 저장 데이터
      
      mv.addObject("CNT04", service.integer("getCnt04", parameter));
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @GetMapping(value="/project_request")
  public ModelAndView project_request(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/project/project_request");
    
    parameter.put("GROUP_CD", "PROJECT_CD");
    String lang = request.getSession().getAttribute("language").toString();
    parameter.put("LANG", lang);
    mv.addObject("PROJECT_CD_LIST", service.list("common", "getCodeLang", parameter)); 
    //mv.addObject("PROJECT_CD_LIST", service.list("common", "getCode", parameter)); // 프로젝트 코드

    parameter.put("GROUP_CD", "PUBLIC_CD");
    mv.addObject("PUBLIC_CD_LIST", service.list("common", "getCodeLang", parameter)); 
    //mv.addObject("PROJECT_CD_LIST", service.list("common", "getCode", parameter)); // 공개 코드
    
    parameter.put("GROUP_CD", "TIME_CD");
    mv.addObject("TIME_CD_LIST", service.list("common", "getCodeLang", parameter)); 
    //mv.addObject("PROJECT_CD_LIST", service.list("common", "getCode", parameter));// 시간 코드
    
    parameter.put("GROUP_CD", "PREFER_CD");
    mv.addObject("PREFER_CD_LIST", service.list("common", "getCodeLang", parameter)); 
    //mv.addObject("PROJECT_CD_LIST", service.list("common", "getCode", parameter)); // 선호 CAD S/W
    
    Map<?, ?> data = service.getData01(parameter);
    mv.addObject("DATA", data); // 저장 데이터
    
    if(!ObjectUtils.isEmpty(parameter.get("REQS"))) {
      mv.addObject("REQS", parameter.get("REQS"));
    } else {
      if(data != null && !data.isEmpty()) mv.addObject("REQS", data.get("REQS"));
    }
    
    if(!ObjectUtils.isEmpty(parameter.get("GCS"))) {
      mv.addObject("GCS", parameter.get("GCS"));
    } else {
      if(data != null && !data.isEmpty()) mv.addObject("GCS", data.get("GCS"));
    }
    
    mv.addObject("PROJECT_NO", parameter.get("PROJECT_NO"));
    
    List<?> userList = service.list("talk", "getUserList", parameter);
    
    mv.addObject("USER_LIST", userList);
    mv.addObject("USER_CNT", userList.size());
    
    return mv;
  }
  
  // 치자이너가 견적서 넣음
  @PostMapping(value="/save01")
  public Map<?, ?> save01(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    boolean isException = true;
    try {
      resultMap = service.save01(parameter);
    } catch(Exception e) {
      isException = false;
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
  
    // 의뢰자에게 발송 -> 견적서 수신 (견적서가 도착했습니다)
    if(isException) {
      
    }

    return resultMap;
  }
  
  @PostMapping(value="/save02")
  public Map<?, ?> save02(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
      resultMap = service.save02(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
    return resultMap;
  }
  @PostMapping(value="/save03")
  public Map<?, ?> save03(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
      resultMap = service.save03(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
    return resultMap;
  }
  // 계약취소
  @PostMapping(value="/delete01")
  public Map<?, ?> delete01(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
    	List<Map<String, Object>> List = (List<Map<String, Object>>) service.list("getData05", parameter);

    	for(Map<String, Object> data : List) {
    		data.get("RQST_NO");
    		service.map("update06", data);
    	}
      resultMap = service.delete01(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
    return resultMap;
  }
  @PostMapping(value="/delete02")
  public Map<?, ?> delete02(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
      resultMap = service.delete02(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
    return resultMap;
  }
  @GetMapping(value = "/getReqInfo", produces = MediaType.APPLICATION_JSON_VALUE)
  public List<Map<String, Object>> getReqInfo(HttpServletRequest request) throws Exception {
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    List<Map<String, Object>> list = (List<Map<String, Object>>) service.list("getReqList", parameter);
    
    for(Map<String, Object> obj : list) {
  	  Iterator<String> keys = obj.keySet().iterator();
      while( keys.hasNext() ){
          String key = keys.next();
          String value = obj.get(key).toString();
          System.out.println("(2)키 : "+key+", 값 : "+value);
      }
      
 	  if(obj.get("SUPP_NM_STR").toString().contains("Frame") || obj.get("SUPP_NM_STR").toString().contains("Splint") || obj.get("SUPP_NM_STR").toString().contains("의치")
		  || obj.get("SUPP_NM_STR").toString().contains("교정") || obj.get("SUPP_NM_STR").toString().contains("트레이")
		  || obj.get("SUPP_NM_STR").toString().contains(comm.geti18n(request, "dialog.req.denture"))
		  || obj.get("SUPP_NM_STR").toString().contains(comm.geti18n(request, "main.aligner"))
 			  ) {
    	 
  		  String realctn = "1";
    	  if(obj.get("SUPP_NM_STR").toString().contains(",")) {
  	  		  String SUPP_NM_STR[] = obj.get("SUPP_NM_STR").toString().split(",");
  	  		  String CNT_STR[] = obj.get("CNT_STR").toString().split(",");
  	  		  realctn = obj.get("CNT_STR").toString();
  	  		 
  	  		
  	  		 for(int i = 0; i < SUPP_NM_STR.length; i++) {
	  	  			String ctnstr = "";
	  	  			String CNT_STR2[] = realctn.split(",");
	  	  			int cnt = 1;
	  	  			int fctn = 0;
	  	  			int fsplint = 0;
	  	  			int fu = 0;
	  	  			int fk = 0;
	  	  			int ft = 0;
	  	  			int bool = 0;
	  	  			int index = -1;
			  	  	
			  	  	
	  	  			if(SUPP_NM_STR[i].contains("Frame") || SUPP_NM_STR[i].contains("Splint") || SUPP_NM_STR[i].contains("의치")
	  	  					|| SUPP_NM_STR[i].toString().contains("교정") || SUPP_NM_STR[i].contains("트레이")
	  	  				    || SUPP_NM_STR[i].contains(comm.geti18n(request, "dialog.req.denture")) || SUPP_NM_STR[i].contains(comm.geti18n(request, "main.aligner"))) {
		  	  	  		  index = i;
		  	  	  		  bool = 1;
		  	  	  		  String GROUP_CD = obj.get("GROUP_CD").toString();
		  	  	  		  Map<String, Object> parameter2 = ParameterUtil.getParameterMap(request);
		  	  	  		  parameter2.put("GROUP_CD", GROUP_CD); 
		  	  	  		  List<Map<String, Object>> list2 = (List<Map<String, Object>>) service.list("getReqInfoList", parameter2);

	  	             for(Map<String, Object> obj2 : list2) {
		  	                if(obj2.get("SUPP_NM_1").toString().contains("Frame") || obj2.get("SUPP_NM_1").toString().contains("Splint") || obj2.get("SUPP_NM_1").toString().contains("의치")
		  	                        || obj2.get("SUPP_NM_1").toString().contains("교정") || obj2.get("SUPP_NM_1").toString().contains("트레이")) {
//		  	                if(SUPP_NM_STR[i].contains("Frame") || SUPP_NM_STR[i].contains("Splint") || SUPP_NM_STR[i].contains("의치")
//		  	                        || SUPP_NM_STR[i].contains("교정") || SUPP_NM_STR[i].contains("트레이")) {
		  	               	//String cat = obj2.get("SUPP_NM_1").toString();
		  	               	if(obj2.get("SUPP_NM_1").toString().contains("Frame")) {
		  	               		fctn++;
		  	               	}
		  	               	if(obj2.get("SUPP_NM_1").toString().contains("Splint")) {
		  	               		fsplint++;
		  	               	}
		  	               	if(obj2.get("SUPP_NM_1").toString().contains(comm.geti18n(request, "dialog.req.denture"))) {
		  	               		fu++;
		  	               	}
		  	               	if(obj2.get("SUPP_NM_1").toString().contains(comm.geti18n(request, "main.aligner"))) {
		  	               		fk++;
		  	               	}
		  	               	if(obj2.get("SUPP_NM_1").toString().contains("트레이")) {
		  	               		ft++;
		  	               	}
	  	                }
	  	           }
	  	          	   if(SUPP_NM_STR[i].contains("Frame")) {
	  	          		   cnt = fctn;
	  	             	}
	  	             	if(SUPP_NM_STR[i].contains("Splint")) {
	  	             		cnt =fsplint;
	  	             	}
	  	             	if(SUPP_NM_STR[i].contains(comm.geti18n(request, "dialog.req.denture"))) {
	  	             		cnt =fu;
	  	             	}
	  	             	if(SUPP_NM_STR[i].contains(comm.geti18n(request, "main.aligner"))) {
	  	             		cnt =fk;
	  	             	}
	  	             	if(SUPP_NM_STR[i].contains("트레이")) {
	  	             		cnt =ft;
	  	             	}
	  	             	if(cnt == 0) {
	  	             		cnt = 1;
	  	             	}
	  	  	  	  }
  	  			  System.out.println("cnt :: " + cnt);
  	  			  System.out.println("SUPP_NM_STR[i] :: " + SUPP_NM_STR[i]);
	  	          	System.out.println("i :: " + i);
  	  			  
 	    	  	 for(int j = 0; j < CNT_STR2.length; j++) {

	 	    	  		 if(j == index) {
		    	  			 //counting 부분 수정
		    	  			if(j == 0) {
				    	  		 ctnstr = "" + Integer.toString(cnt);	  			
			    	  		}else {
			    	  			ctnstr += "," + "" + Integer.toString(cnt);
			    	  		}
	 	    	  		 }
	    	  		 else {
		    	  		if(j == 0) {
			    	  		 ctnstr = CNT_STR2[j];	  			
		    	  		}else {
		    	  			ctnstr += "," + CNT_STR2[j];
		    	  		}
	    	  		 }
	  	  			  System.out.println("cnt2 :: " + cnt);
	  	  			  
		  	          	System.out.println("j :: " + j);
		  	          	System.out.println("ctnstr :: " + ctnstr);
	  	  		  }
	    	  	realctn = ctnstr;
    	  }
    	  }else {
	  	  		  String GROUP_CD = obj.get("GROUP_CD").toString();
 	               Map<String, Object> parameter2 = ParameterUtil.getParameterMap(request);
 	               parameter2.put("GROUP_CD", GROUP_CD); 
 	               List<Map<String, Object>> list2 = (List<Map<String, Object>>) service.list("getReqInfoList", parameter2);
 	  	  		   
 	               int cnt = 1;
 	               int fctn = 0;
 	  	           int fsplint = 0;
 	  	           int fu = 0;
 	  	           int fk = 0;
 	  	           int ft = 0;
	  	           
 	             for(Map<String, Object> obj2 : list2) {
	  	                if(obj2.get("SUPP_NM_1").toString().contains("Frame") || obj2.get("SUPP_NM_1").toString().contains("Splint") || obj2.get("SUPP_NM_1").toString().contains(comm.geti18n(request, "dialog.req.denture"))
	  	                        || obj2.get("SUPP_NM_1").toString().contains(comm.geti18n(request, "main.aligner")) || obj2.get("SUPP_NM_1").toString().contains("트레이")) {
	  	               	 
	  	               	String cat = obj2.get("SUPP_NM_1").toString();
	  	               	if(cat.contains("Frame")) {
	  	               		fctn++;
	  	               	}
	  	               	if(cat.contains("Splint")) {
	  	               		fsplint++;
	  	               	}
	  	               	if(cat.contains(comm.geti18n(request, "dialog.req.denture"))) {
	  	               		fu++;
	  	               	}
	  	               	if(cat.contains(comm.geti18n(request, "main.aligner"))) {
	  	               		fk++;
	  	               	}
	  	               	if(cat.contains("트레이")) {
	  	               		ft++;
	  	               	}
 	                }
 	           }
 	             //for(Map<String, Object> obj2 : list2) {

 	          	   if(obj.get("SUPP_NM_STR").toString().contains("Frame")) {
 	          		cnt = fctn;
 	             	}
 	             	if(obj.get("SUPP_NM_STR").toString().contains("Splint")) {
 	             		cnt =fsplint;
 	             	}
 	             	if(obj.get("SUPP_NM_STR").toString().contains(comm.geti18n(request, "dialog.req.denture"))) {
 	             		cnt =fu;
 	             	}
 	             	if(obj.get("SUPP_NM_STR").toString().contains(comm.geti18n(request, "main.aligner"))) {
 	             		cnt =fk;
 	             	}
 	             	if(obj.get("SUPP_NM_STR").toString().contains("트레이")) {
 	             		cnt =ft;
 	             	}
  	             	if(cnt == 0) {
  	             		cnt = 1;
  	             	}
	  	        //}
    		  
    		  realctn = "" + cnt;
      	  }
  	  		obj.put("CNT_STR", realctn); 
  	  }
  	 
//	  	  if(obj.get("SUPP_NM_1").toString().contains("Frame") || obj.get("SUPP_NM_1").toString().contains("Splint") || obj.get("SUPP_NM_1").toString().contains("의치")
//	  			  || obj.get("SUPP_NM_1").toString().contains("교정") || obj.get("SUPP_NM_1").toString().contains("트레이")) {
//	  		  //SUPP_GROUP_CNT
//	  		  //Frame, Splint, 의치, 교정, 트레이
//	  		 
//	  	  }
      }
    
    return list;
  }
  
  @GetMapping(value = "/getEstimators", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> getEstimators(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> resultMap = new HashMap<>();
    
    List<Map<String, Object>> list = (List<Map<String, Object>>) service.list("getEstimatorList", parameter);
    for(Map<String, Object> estimator : list) {
      estimator.put("dtlInfo", service.list("getEstimatorDtlInfo", estimator));
      estimator.put("fileList", service.list("common", "getFileList", estimator));
    }
    resultMap.put("estimatorList", list);
    
    return resultMap;
  }
  @GetMapping(value = "/getEstimatorInfo", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> getEstimatorInfo(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> resultMap = new HashMap<>();
    
    List<Map<String, Object>> list = (List<Map<String, Object>>) service.list("getEstimatorList2", parameter);
    for(Map<String, Object> estimator : list) {
      estimator.put("dtlInfo", service.list("getEstimatorDtlInfo", estimator));
      estimator.put("fileList", service.list("common", "getFileList", estimator));
    }
    resultMap.put("estimatorList", list);
    
    return resultMap;
  }
  
  @GetMapping(value = "/getMyEstimator", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> getMyEstimator(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();
    
    Map<String, Object> estimator = new HashMap<String, Object>();
    

    
    String type = ObjectUtils.isEmpty(parameter.get("TYPE")) ? "" : parameter.get("TYPE").toString();
    if(type.equals("MY_PAGE")) {
      estimator = (Map<String, Object>) service.map("getData04", parameter);
    } else {
      estimator = (Map<String, Object>) service.map("getData03", parameter);
    }
    
    estimator.put("dtlInfo", service.list("getEstimatorDtlInfo", estimator));
    estimator.put("fileList", service.list("common", "getFileList", estimator));
    
    Iterator<String> keys = estimator.keySet().iterator();
    while( keys.hasNext() ){
        String key = keys.next();
        String value = estimator.get(key).toString();
        System.out.println("(3)키 : "+key+", 값 : "+value);
    }
    
    resultMap.put("estimator", estimator);
    
    return resultMap;
  }
  
  @PostMapping(value="/deleteEstimator")
  public Map<?, ?> deleteEstimator(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
      resultMap = service.updateEstimatorDelYn(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  
  // 특정 견적서 매칭
  @PostMapping(value="/matching")
  public Map<?, ?> matching(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    boolean isException = true;
    try {
      resultMap = service.updateMatchingYn(parameter);
    } catch(Exception e) {
      isException = false;
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
    
    // 치자이너에게 발송 -> 내 견적서 매칭 or 전자계약 수신 (전자계약을 진행 해 주세요)
    if(isException) {
      
    }
    return resultMap;
  }
  
  @GetMapping(value="/getSuppInfo", produces=MediaType.APPLICATION_JSON_VALUE)
  public List<Map<String, Object>> getSuppInfo(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    List<Map<String, Object>> list = (List<Map<String, Object>>) service.list("getSuppInfoList", parameter);

    for(Map<String, Object> obj : list) {
      obj.put("SUPP_NM", ParameterUtil.reverseCleanXSS(obj.get("SUPP_NM").toString()));
      System.out.println("SUPP_NM :: " + obj.get("SUPP_NM").toString());
	  if(obj.get("SUPP_NM").toString().contains("Frame") || obj.get("SUPP_NM").toString().contains("Splint") || obj.get("SUPP_NM").toString().contains(comm.geti18n(request, "dialog.req.denture"))
			  || obj.get("SUPP_NM").toString().contains(comm.geti18n(request, "main.aligner")) || obj.get("SUPP_NM").toString().contains("트레이")) {
		  
				/* test */
	  		  String GROUP_CD = obj.get("GROUP_CD").toString();
	               Map<String, Object> parameter2 = ParameterUtil.getParameterMap(request);
	               parameter2.put("GROUP_CD", GROUP_CD); 
	               List<Map<String, Object>> list2 = (List<Map<String, Object>>) service.list("getReqInfoList", parameter2);
	               int fctn0 = 0;
	               int fctn1 = 0;
	               int fctn2 = 0;
	               
	               int fsplint0 = 0;
	               int fsplint1 = 0;
	               int fsplint2 = 0;
	               
	               int fu0 = 0;
	               int fu1 = 0;
	               int fu2 = 0;
	               int fk = 0;
	               int ft = 0;
	               String cat ="";
 	           int cnt = 1;
	             for(Map<String, Object> obj2 : list2) {
	              
	                cnt = Integer.parseInt(obj2.get("SUPP_GROUP_CNT").toString());
	                if(obj2.get("SUPP_NM_1").toString().contains("Frame") || obj2.get("SUPP_NM_1").toString().contains("Splint") || obj2.get("SUPP_NM_1").toString().contains(comm.geti18n(request, "dialog.req.denture"))
	                        || obj2.get("SUPP_NM_1").toString().contains(comm.geti18n(request, "main.aligner")) || obj2.get("SUPP_NM_1").toString().contains("트레이")) {
	               	 
	             	   if(obj2.get("SUPP_NM_2") == null || obj2.get("SUPP_NM_2").toString().equals("")) {
	               		  cat = obj2.get("SUPP_NM_1").toString();
	               	   }else {
	               		 cat = obj2.get("SUPP_NM_1").toString() + " - " + obj2.get("SUPP_NM_2").toString();
	               	   }
	            	   if(cat.equals("Frame")) {
	            		   fctn0++;
	            	   }
	            	   if(cat.contains("Frame - Full")) {
	            		   fctn1++;
	            	   }
	            	   if(cat.contains("Frame - Partial")) {
	            		   fctn2++;
	            	   }
	            	   if(cat.contains("Splint - Surgical guid")) {
		            		fsplint1++;
		            	}
	            	   if(cat.contains("Splint - Bite Splint")) {
		            		fsplint2++;
		            	}
		            	if(cat.contains(comm.geti18n(request, "dialog.req.denture")+" - Full")) {
		            		fu1++;
		            	}
		            	if(cat.contains(comm.geti18n(request, "dialog.req.denture")+" - Partial")) {
		            		fu2++;
		            	}
		            	if(cat.contains(comm.geti18n(request, "main.aligner"))) {
		            		fk++;
		            	}
		            	if(cat.contains("트레이")) {
		            		ft++;
		            	}
	                }
	           }
	        	  if(cat.equals("Frame")) {
	             		cnt = fctn0;
	           	  }
	           	   if(cat.contains("Frame - Full")) {
	           		  cnt =  fctn1;
	           	   }
	           	   if(cat.contains("Frame - Partial")) {
	           		  cnt = fctn2;
	           	   }
	           	  if(cat.equals("Splint")) {
	           		 cnt = fsplint0;
	           	  }
	           	   if(cat.contains("Splint - Surgical guid")) {
	           		  cnt = fsplint1;
	                 }
	           	   if(cat.contains("Splint - Bite Splint")) {
	           		  cnt = fsplint2;
	              	}
	           	  if(cat.equals(comm.geti18n(request, "dialog.req.denture"))) {
	           		 cnt = fu0;
	            	  }
	              	if(cat.contains(comm.geti18n(request, "dialog.req.denture")+" - Full")) {
	              		cnt = fu1;
	              	}
	              	if(cat.contains(comm.geti18n(request, "dialog.req.denture")+" - Partial")) {
	              		cnt = fu2;
	              	}
	              	if(cat.contains(comm.geti18n(request, "main.aligner"))) {
	              		cnt = fk;
	              	}
	              	if(cat.contains("트레이")) {
	              		cnt = ft;
	              	}
	             	if(cnt == 0) {
	            		cnt = 1;
	            	}
				/* test end */
		  obj.put("CNT", cnt);
	  }
    }
    
    return list;
  }

}
