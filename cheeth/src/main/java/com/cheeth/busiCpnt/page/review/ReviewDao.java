package com.cheeth.busiCpnt.page.review;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("ReviewDao")
public class ReviewDao extends AbstractDao {
  
  public ReviewDao() {
    super.nameSpace = "review";
  }

}
