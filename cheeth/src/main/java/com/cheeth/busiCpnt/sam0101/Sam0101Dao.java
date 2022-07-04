package com.cheeth.busiCpnt.sam0101;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("Sam0101Dao")
public class Sam0101Dao extends AbstractDao {
  
  public Sam0101Dao() {
    super.nameSpace = "sam.sam0101";
  }
}