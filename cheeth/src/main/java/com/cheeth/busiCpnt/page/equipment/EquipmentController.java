package com.cheeth.busiCpnt.page.equipment;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.cheeth.comAbrt.controller.BaseController;
import com.cheeth.comUtils.ParameterUtil;

@RestController
@RequestMapping(value="${api.url}/equipment")
public class EquipmentController extends BaseController {
  
  protected Logger logger = LogManager.getLogger(EquipmentController.class);
  
  @Autowired
  private EquipmentService service;
  
  @GetMapping(value="/equipment_estimator_list")
  public ModelAndView equipment_estimator_list(HttpServletRequest request) throws Exception {
      
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/equipment/equipment_estimator_list");
    
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
    
    mv.addObject("TOTAL_CNT", service.integer("getCnt01", parameter)); // 총건수
    
    mv.addObject("LIST", service.list("getList01", parameter)); // 목록조회
    
    parameter.put("GROUP_CD", "EQ_CD");
    mv.addObject("EQ_CD_LIST", service.list("common", "getCode", parameter)); // 게시판 코드
    
    parameter.put("GROUP_CD", "AREA_CD");
    mv.addObject("AREA_CD_LIST", service.list("common", "getCode", parameter)); // 지역코드
    
    mv.addObject("SEARCH_EQ_CD", parameter.get("SEARCH_EQ_CD"));
      
    return mv;
  }
  
  @GetMapping(value = "/equipment_estimator_view")
  public ModelAndView equipment_estimator_view(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    service.updateHit(parameter);
    
    ModelAndView mv = new ModelAndView("page/equipment/equipment_estimator_view");
    mv.addObject("SEARCH_EQ_CD", parameter.get("SEARCH_EQ_CD"));
    
    parameter.put("GROUP_CD", "EQ_CD");
    mv.addObject("EQ_CD_LIST", service.list("common", "getCode", parameter)); // 게시판 코드
    
    Map<?, ?> data = service.getData01(parameter);
    mv.addObject("DATA", data);
    
    mv.addObject("CNT04", service.integer("getCnt04", parameter));
    
    parameter.put("FILE_CD", data.get("FILE_CD"));
    List<Map<String, Object>> imgFileList = (List<Map<String, Object>>) service.list("common", "getFileList", parameter);
    mv.addObject("IMG_FILE_LIST", imgFileList);
    
    return mv;
  }
  
  @GetMapping(value="/equipment_estimator_writing")
  public ModelAndView equipment_estimator_writing(HttpServletRequest request) throws Exception {
      
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
      
    ModelAndView mv = new ModelAndView("page/equipment/equipment_estimator_writing");
    
    parameter.put("GROUP_CD", "EQ_CD");
    mv.addObject("EQ_CD_LIST", service.list("common", "getCode", parameter)); // 게시판 코드
    
    parameter.put("GROUP_CD", "AREA_CD");
    mv.addObject("AREA_CD_LIST", service.list("common", "getCode", parameter)); // 지역코드
    
    parameter.put("GROUP_CD", "TIME_CD");
    mv.addObject("TIME_CD_LIST", service.list("common", "getCode", parameter)); // 시간 코드
    
    Map<?, ?> data = service.getData01(parameter);
    mv.addObject("DATA", data);
      
    return mv;
  }
  
  @PostMapping(value="/save01")
  public Map<?, ?> save01(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
      resultMap = service.save01(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
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
  
  @PostMapping(value="/delete01")
  public Map<?, ?> delete01(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
      resultMap = service.delete01(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  
  @GetMapping(value = "/getEstimators", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> getEstimators(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> resultMap = new HashMap<>();
    
    List<Map<String, Object>> list = (List<Map<String, Object>>) service.list("getList02", parameter);
    for(Map<String, Object> estimator : list) {
      estimator.put("dtlInfo", service.list("getList03", estimator));
      estimator.put("fileList", service.list("common", "getFileList", estimator));
    }
    resultMap.put("estimatorList", list);
    
    return resultMap;
  }
  
  @GetMapping(value = "/getMyEstimator", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> getMyEstimator(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> resultMap = new HashMap<>();
    
    Map<String, Object> estimator = (Map<String, Object>) service.map("getData02", parameter);
    estimator.put("dtlInfo", service.list("getList03", estimator));
    estimator.put("fileList", service.list("common", "getFileList", estimator));
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
  
  @PostMapping(value="/matching")
  public Map<?, ?> matching(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
      resultMap = service.updateMatchingYn(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }

}
