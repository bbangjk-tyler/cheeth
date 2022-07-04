package com.cheeth.busiCpnt.page.contract;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("ContractDao")
public class ContractDao extends AbstractDao {
  
  public ContractDao() {
    super.nameSpace = "contract";
  }

}
