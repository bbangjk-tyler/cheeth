package com.cheeth.busiCpnt.page.equipment;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("EquipmentDao")
public class EquipmentDao extends AbstractDao {
  
  public EquipmentDao() {
    super.nameSpace = "equipment";
  }

}
