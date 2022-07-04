package com.cheeth.comAbrt.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;


@Component("BaseController")
public class BaseController {

  protected Logger logger = LogManager.getLogger(BaseController.class);
  
  @Autowired
  private HttpServletRequest request;
  
  @InitBinder
  public void initBinder(WebDataBinder dataBinder) {
    int autoGrowCollectionLimit = 2056;
    dataBinder.setAutoGrowCollectionLimit(autoGrowCollectionLimit);
  }
  
  protected boolean isSession() {
    
    boolean rtn = false;

    HttpSession session = request.getSession();
    if(session != null && session.getAttribute("sessionInfo") != null) {
      rtn = true;
    }

    return rtn;
  }
  
}