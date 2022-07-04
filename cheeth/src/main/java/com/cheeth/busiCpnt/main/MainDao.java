package com.cheeth.busiCpnt.main;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("MainDao")
public class MainDao extends AbstractDao {

  public MainDao() {
    super.nameSpace = "main";
  }
}
