package com.cheeth.comUtils.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.HandlerInterceptor;

import com.cheeth.comUtils.CommonUtil;

@Configuration
public class ApiInterceptor implements HandlerInterceptor {
  
  private final Logger logger = LogManager.getLogger(ApiInterceptor.class);
  
  @Value("${api.url}")
  private String apiUrl;

  @Value("${spring.profiles.active}")
  private String active;
  
  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    
    String uri = request.getRequestURI();
    String userIp = CommonUtil.getIpAddress(request);
    logger.info(uri);
    
    if(uri.indexOf("test03") > -1) {
      logger.info("권한 테스트");
      return false;
    }
    
    return true;
  }

}
