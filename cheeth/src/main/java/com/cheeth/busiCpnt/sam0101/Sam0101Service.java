package com.cheeth.busiCpnt.sam0101;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import com.cheeth.comAbrt.service.AbstractService;

@Service("Sam0101Service")
public class Sam0101Service extends AbstractService {
  
  protected Logger logger = LogManager.getLogger(Sam0101Service.class);
  
  public List<?> getList(Map<String, Object> parameter) throws Exception {
    
    List<?> list = list("getList", parameter);

    return list;
  }

}
