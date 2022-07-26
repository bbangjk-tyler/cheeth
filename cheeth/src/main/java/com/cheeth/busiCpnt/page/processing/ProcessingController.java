package com.cheeth.busiCpnt.page.processing;

import java.util.ArrayList;
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
@RequestMapping(value="${api.url}/processing")
public class ProcessingController extends BaseController {
  
  protected Logger logger = LogManager.getLogger(ProcessingController.class);
  
  @Autowired
  private ProcessingService service;
  
  @GetMapping(value="/processing_center")
  public ModelAndView processing_center(HttpServletRequest request) throws Exception {
      
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/processing/processing_center");
    
    String searchCd = ObjectUtils.isEmpty(parameter.get("SEARCH_CD")) ? "" : parameter.get("SEARCH_CD").toString();
    if(!ObjectUtils.isEmpty(searchCd)) {
      String[] s = searchCd.split("l");
      if(s != null) {
        List<String> searchCdList = new ArrayList<String>();
        for(int i=0; i<s.length; i++) {
          searchCdList.add(s[i]);
        }
        parameter.put("SEARCH_CD", searchCdList);
      }
    }
    
    mv.addObject("PAGE", ObjectUtils.isEmpty(parameter.get("PAGE")) ? "1" : parameter.get("PAGE")); // 현재 페이지
    Integer page = 0;
    if(!ObjectUtils.isEmpty(parameter.get("PAGE")) && parameter.get("PAGE").toString().chars().allMatch(Character::isDigit)) {
      page = Integer.parseInt(parameter.get("PAGE").toString());
      if(page == 1) {
        page = 0;
      } else {
        page = (page-1) * 9; // 9는 페이지 개수마다 변경 해야 함
      }
    }
    parameter.put("PAGE", page);
    
    parameter.put("GROUP_CD", "AREA_CD");
    mv.addObject("AREA_CD_LIST", service.list("common", "getCode", parameter)); // 지역코드
    
    parameter.put("GROUP_CD", "WORK_ITEM_CD");
    mv.addObject("WORK_ITEM_CD_LIST", service.list("common", "getCode", parameter)); // 가공 가능 품목
    
    mv.addObject("TOTAL_CNT", service.integer("getCnt01", parameter)); // 총건수
    
    mv.addObject("LIST", service.list("getList01", parameter)); // 목록조회
     
    return mv;
  }
  
  @GetMapping(value="/processing_center_profile")
  public ModelAndView processing_center_profile(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/processing/processing_center_profile");
    
    parameter.put("GROUP_CD", "AREA_CD");
    mv.addObject("AREA_CD_LIST", service.list("common", "getCode", parameter)); // 지역코드
    
    parameter.put("GROUP_CD", "WORK_ITEM_CD");
    mv.addObject("WORK_ITEM_CD_LIST", service.list("common", "getCode", parameter)); // 가공 가능 품목
    
    mv.addObject("DATA", service.map("getData01", parameter));
    
    return mv;
  }
  
  @GetMapping(value="/getProgWorkItem", produces=MediaType.APPLICATION_JSON_VALUE)
  public List<?> getProgWorkItem(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    List<?> list = service.list("getProgWorkItem", parameter);
    
    return list;
  }
  
  @PostMapping(value="/save01")
  public Map<?, ?> save01(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();

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
    Map<String, Object> resultMap = new HashMap<String, Object>();

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
    Map<String, Object> resultMap = new HashMap<String, Object>();

    try {
      resultMap = service.delete01(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }

}
