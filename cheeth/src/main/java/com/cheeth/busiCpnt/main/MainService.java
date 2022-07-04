package com.cheeth.busiCpnt.main;

import java.util.HashMap;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.cheeth.busiCpnt.page.processing.ProcessingService;
import com.cheeth.comAbrt.service.AbstractService;

@Service("MainService")
public class MainService extends AbstractService {

  protected Logger logger = LogManager.getLogger(ProcessingService.class);
  
  @Transactional(propagation = Propagation.REQUIRED)
  public Map<String, Object> save(Map<String, Object> parameter) throws Exception {
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    return rtnMap;
  }
}
