package com.cheeth.busiCpnt.file;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("FileDao")
public class FileDao extends AbstractDao {
  
  public FileDao() {
    super.nameSpace = "file.file";
  }

}
