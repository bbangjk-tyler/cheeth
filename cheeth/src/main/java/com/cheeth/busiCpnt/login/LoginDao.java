package com.cheeth.busiCpnt.login;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("LoginDao")
public class LoginDao extends AbstractDao {
  
  public LoginDao() {
    super.nameSpace = "login.login";
  }

}
