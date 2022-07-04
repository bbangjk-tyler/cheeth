package com.cheeth.busiCpnt.page.project;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("ProjectDao")
public class ProjectDao extends AbstractDao {
  
  public ProjectDao() {
    super.nameSpace = "project";
  }

}
