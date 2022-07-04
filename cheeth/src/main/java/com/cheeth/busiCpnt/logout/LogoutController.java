package com.cheeth.busiCpnt.logout;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.cheeth.comAbrt.controller.BaseController;

@RestController
@RequestMapping(value="${api.url}/logout")
public class LogoutController extends BaseController {
  
protected Logger logger = LogManager.getLogger(LogoutController.class);
  
  @Value("${api.url}")
  private String api;
  
  @Autowired
  private LogoutService service;
  
  @PostMapping(value="/logout")
  public ModelAndView logout(HttpServletRequest request) throws Exception {
    
    ModelAndView mv = new ModelAndView("redirect:/" + api + "/main/main");
    
    service.logout(request);
    
    return mv;
  }  

}
