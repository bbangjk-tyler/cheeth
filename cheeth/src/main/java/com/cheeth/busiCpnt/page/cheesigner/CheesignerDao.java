package com.cheeth.busiCpnt.page.cheesigner;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("CheesignerDao")
public class CheesignerDao extends AbstractDao {
  
  public CheesignerDao() {
    super.nameSpace = "cheesigner";
  }

}
