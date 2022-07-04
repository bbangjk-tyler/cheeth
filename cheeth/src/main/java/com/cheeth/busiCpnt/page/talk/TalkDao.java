package com.cheeth.busiCpnt.page.talk;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("TalkDao")
public class TalkDao extends AbstractDao {
  
  public TalkDao() {
    super.nameSpace = "talk";
  }

}
