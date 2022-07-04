package com.cheeth.busiCpnt.sam0101;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.cheeth.comAbrt.controller.BaseController;
import com.cheeth.comUtils.ParameterUtil;
import com.cheeth.comUtils.encipher.AESEncryptor;

@RestController
@RequestMapping(value="${api.url}/sam/sam0101")
public class Sam0101Controller extends BaseController {
  
  protected Logger logger = LogManager.getLogger(Sam0101Controller.class);
  
  @Autowired
  private Sam0101Service service;
  
  @GetMapping(value="/test01")
  public ModelAndView test01(HttpServletRequest request) throws Exception {
      
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    AESEncryptor aesEncryptor = new AESEncryptor();
    String en = aesEncryptor.encrypt("tttaabbcd!@#$%_)(*&^%$#@~<>?");
    System.out.println("en -> " + en);
    
    String de = aesEncryptor.decrypt(en);
    System.out.println("de -> " + de);
      
    ModelAndView mv = new ModelAndView("sam/sam0101");
    mv.addObject("test", "ttttttttt");
    
      
    return mv;
  }
  
  @GetMapping(value="/test02", produces=MediaType.APPLICATION_JSON_VALUE)
  public List<?> test02(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    List<?> list = service.getList(parameter);
    
    return list;
  
  }
  
  @GetMapping(value="/test03", produces=MediaType.APPLICATION_JSON_VALUE)
  public List<?> test03(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    List<?> list = service.getList(parameter);
    
    return list;
  
  }

}
