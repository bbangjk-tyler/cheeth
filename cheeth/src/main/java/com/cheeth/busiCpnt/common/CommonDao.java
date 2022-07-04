package com.cheeth.busiCpnt.common;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("CommonDao")
public class CommonDao extends AbstractDao {
  
  public CommonDao() {
    super.nameSpace = "common";
  }

}
