package com.cheeth.busiCpnt.page.processing;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("ProcessingDao")
public class ProcessingDao extends AbstractDao {
  
  public ProcessingDao() {
    super.nameSpace = "processing";
  }

}
