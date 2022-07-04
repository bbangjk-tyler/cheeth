package com.cheeth.busiCpnt.page.tribute;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("TributeDao")
public class TributeDao extends AbstractDao {
  
  public TributeDao() {
    super.nameSpace = "tribute";
  }

}
