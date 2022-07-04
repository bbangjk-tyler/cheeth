package com.cheeth.busiCpnt.main;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.cheeth.comAbrt.controller.BaseController;
import com.cheeth.comUtils.ParameterUtil;

@RestController
@RequestMapping(value="${api.url}/main")
public class MainController extends BaseController {
  
  protected Logger logger = LogManager.getLogger(MainController.class);
  
  @Autowired
  private MainService service;
  
  @GetMapping(value="/main")
  public ModelAndView login(HttpServletRequest request) throws Exception {
      
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
      
    ModelAndView mv = new ModelAndView("main/main");
    
    parameter.put("PROG_PAGE", 0);
    mv.addObject("PROG_LIST", service.list("getProgList01", parameter)); // 가공센터 목록
    mv.addObject("PROG_CNT", service.integer("getProgCnt01", parameter));
    
    mv.addObject("PJT", service.map("getPjtSummary", parameter));
    mv.addObject("msg", parameter.get("msg"));
    
    return mv;
  }
  
  @GetMapping(value="/getProgList", produces=MediaType.APPLICATION_JSON_VALUE)
  public List<?> getProgList(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    Integer progPage = ObjectUtils.isEmpty(parameter.get("PROG_PAGE")) ? 0 : Integer.parseInt(parameter.get("PROG_PAGE").toString());
    parameter.put("PROG_PAGE", progPage);
    List<?> list = service.list("getProgList01", parameter);
    
    return list;
  }

}
