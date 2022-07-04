package com.cheeth.busiCpnt.logout;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import com.cheeth.comAbrt.service.AbstractService;

@Service("LogoutService")
public class LogoutService extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(LogoutService.class);
  
  public void logout(HttpServletRequest request) {
    HttpSession session = request.getSession(false);
    if(session != null && request.isRequestedSessionIdValid()) {
      session.invalidate();
    }
  }

}
