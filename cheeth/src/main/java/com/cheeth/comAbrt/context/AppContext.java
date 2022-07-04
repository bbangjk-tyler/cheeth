package com.cheeth.comAbrt.context;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

@Component
public class AppContext implements ApplicationContextAware {

  private static ApplicationContext ctx;
  
  public static ApplicationContext getApplicationContext() {
    return ctx;
  }

  @Override
  public void setApplicationContext(ApplicationContext ctx) throws BeansException {
    AppContext.ctx = ctx;
  }

}