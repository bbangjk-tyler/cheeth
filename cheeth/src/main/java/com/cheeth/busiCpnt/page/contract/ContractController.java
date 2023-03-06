package com.cheeth.busiCpnt.page.contract;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.cheeth.busiCpnt.page.talk.TalkController;
import com.cheeth.comAbrt.controller.BaseController;
import com.cheeth.comUtils.ParameterUtil;

@RestController
@RequestMapping(value="${api.url}/contract")
public class ContractController extends BaseController {
  
  protected Logger logger = LogManager.getLogger(TalkController.class);
  
  @Autowired
  private ContractService service;
  
  @GetMapping(value="/project_electronic_contract")
  public ModelAndView receive(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/contract/project_electronic_contract");

    String lang = request.getSession().getAttribute("language").toString();
    parameter.put("LANG", lang);
    Map<?, ?> data = service.getData01(parameter);
    
    mv.addObject("PROJECT_CD_LIST", data.get("PROJECT_CD_LIST")); // 프로젝트 코드
    mv.addObject("DATA", data.get("DATA")); // 전자계약 정보 조회
    
    mv.addObject("CNT01", data.get("CNT01")); // 프로젝트 생성자
    mv.addObject("CNT02", data.get("CNT02")); // 치자이너
    mv.addObject("CNT04", data.get("CNT04")); // 치자이너
    
    Integer cnt01 = Integer.parseInt(data.get("CNT01").toString());
    Integer cnt02 = Integer.parseInt(data.get("CNT02").toString());
    Integer cnt04 = Integer.parseInt(data.get("CNT04").toString());
    
//    if(cnt01 == 0 && cnt02 == 0) {
//      mv.setViewName("redirect:/");
//    } else if(cnt04 > 0) {
//      mv.setViewName("redirect:/");
//    }
//    if(cnt01 == 0 && cnt02 == 0) {
//        mv.setViewName("redirect:/");
//      }
    
    mv.addObject("ESTIMATOR_NO", parameter.get("ESTIMATOR_NO"));
    mv.addObject("MY_PAGE", parameter.get("MY_PAGE"));
    
    return mv;
  }
  
  // 승인요청
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
  
  // 승인
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
    
    // 전자계약 완료 ( 의뢰서를 수령하세요 ), 전자계약 완료 ( 전자계약이 완료되었습니다. )
    String result = resultMap.get("result").toString();
    if(result.equals("Y")) {
      
    }
    
    return resultMap;
  }
  
  // 수정요청
  @PostMapping(value="/save03")
  public Map<?, ?> save03(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();
    
    try {
      resultMap = service.save03(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
    
    return resultMap;
  }
  
  // 승인취소
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

}
