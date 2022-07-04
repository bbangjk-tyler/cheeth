package com.cheeth.busiCpnt.login;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.cheeth.comAbrt.controller.BaseController;
import com.cheeth.comUtils.ParameterUtil;

@RestController
@RequestMapping(value="${api.url}/login")
public class LoginController extends BaseController {
  
  protected Logger logger = LogManager.getLogger(LoginController.class);
  
  @Value("${api.url}")
  private String api;
  
  @Autowired
  private LoginService service;
  
  @GetMapping(value="/view")
  public ModelAndView login(HttpServletRequest request) throws Exception {
      
    ModelAndView mv = new ModelAndView("login/login");
      
    return mv;
  }
  
  @PostMapping(value="/login")
  public ModelAndView setSession(HttpServletRequest request) throws Exception {
      
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    String result = service.login(request, parameter);
    
    ModelAndView mv;
    if(result.equals("Y")) {
      mv = new ModelAndView("redirect:/" + api + "/main/main"); // 로그인 성공
    } else {
      mv = new ModelAndView("redirect:/" + api + "/login/view?state=fail"); // 로그인 실패
    }
    
    return mv;
  }

}
