package com.cheeth.busiCpnt.login;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import com.cheeth.comAbrt.service.AbstractService;

@Service("LoginService")
public class LoginService extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(LoginService.class);
  
  public String login(HttpServletRequest request, Map<String, Object> parameter) throws Exception {
    
    String id = ObjectUtils.isEmpty(parameter.get("id")) ? "" : parameter.get("id").toString();
    String pw = ObjectUtils.isEmpty(parameter.get("pw")) ? "" : parameter.get("pw").toString();
    
    String rtn = "N";
    if(!id.equals("") && !pw.equals("")) {
      Map<?, ?> info = map("getInfo", parameter);
      if(info != null && !info.isEmpty()) {
        HttpSession session = request.getSession();
        if(session != null) {
          // 로그인 성공 세션 생성
          Map<String, Object> sessionInfo = new HashMap<String, Object>();
          sessionInfo.put("user", info); // 사용자 정보
          session.setAttribute("sessionInfo", sessionInfo);
          rtn = "Y";
        }
      }
    }
    
    return rtn;
  }
  public String login2(HttpServletRequest request, Map<String, Object> parameter) throws Exception {
	    
	    String id = ObjectUtils.isEmpty(parameter.get("id")) ? "" : parameter.get("id").toString();
	    
	    String rtn = "N";

	      Map<?, ?> info = map("getInfo2", parameter);
	      if(info != null && !info.isEmpty()) {
	        HttpSession session = request.getSession();
	        if(session != null) {
	          // 로그인 성공 세션 생성
	          Map<String, Object> sessionInfo = new HashMap<String, Object>();
	          sessionInfo.put("user", info); // 사용자 정보
	          session.setAttribute("sessionInfo", sessionInfo);
	          rtn = "Y";
	        }
	      }
	    return rtn;
	  }
}
