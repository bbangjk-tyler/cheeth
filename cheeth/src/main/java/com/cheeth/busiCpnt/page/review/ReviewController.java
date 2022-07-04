package com.cheeth.busiCpnt.page.review;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
@RequestMapping(value="${api.url}/review")
public class ReviewController extends BaseController {
  
  protected Logger logger = LogManager.getLogger(ReviewController.class);
  
  @Value("${api.url}")
  String apiUrl;
  
  @Autowired
  private ReviewService service;
  
  @GetMapping(value="/getData", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<?, ?> getSuppInfo(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    Map<?, ?> data = service.map("getData01", parameter);
    
    return data;
  }
  
  @GetMapping(value="/client_review")
  public ModelAndView client_review(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/review/client_review");
    if(isSession()) {
      mv.addObject("PAGE", ObjectUtils.isEmpty(parameter.get("PAGE")) ? "1" : parameter.get("PAGE")); // 현재 페이지
      Map<String, Object> data = service.getData01(parameter);
      mv.addObject("DATA", data);
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @GetMapping(value="/my_review")
  public ModelAndView my_review(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/review/my_review");
    if(isSession()) {
      mv.addObject("PAGE", ObjectUtils.isEmpty(parameter.get("PAGE")) ? "1" : parameter.get("PAGE")); // 현재 페이지
      Map<String, Object> data = service.getData02(parameter);
      mv.addObject("DATA", data);
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  // 후기등록
  @PostMapping(value="/save01")
  public Map<?, ?> save01(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();

    try {
      resultMap = service.save01(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  
  // 리뷰 답변
  @PostMapping(value="/save02")
  public Map<?, ?> save02(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();
    
    try {
      resultMap = service.save02(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  
  // 후기 수정
  @PostMapping(value="/save03")
  public Map<?, ?> save03(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();

    try {
      resultMap = service.save03(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  
  // 고객후기 삭제
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
  
  // 내가쓴 후기 삭제
  @PostMapping(value="/delete02")
  public Map<?, ?> delete02(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();

    try {
      resultMap = service.delete02(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }

}
