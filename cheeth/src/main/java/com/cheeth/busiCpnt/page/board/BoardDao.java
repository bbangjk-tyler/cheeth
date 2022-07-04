package com.cheeth.busiCpnt.page.board;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("BoardDao")
public class BoardDao extends AbstractDao {

  public BoardDao() {
    super.nameSpace = "board";
  }
}
