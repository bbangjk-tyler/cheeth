package com.cheeth.busiCpnt.page.introduction;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.cheeth.comAbrt.controller.BaseController;
import com.cheeth.comUtils.ParameterUtil;

@RestController
@RequestMapping(value="${api.url}/introduction")
public class IntroductionController extends BaseController {
  
  protected Logger logger = LogManager.getLogger(IntroductionController.class);
  
  @GetMapping(value="/service_introduction")
  public ModelAndView service_introduction(HttpServletRequest request) throws Exception {
      
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
      
    ModelAndView mv = new ModelAndView("page/introduction/service_introduction");
      
    return mv;
  }

}
