package com.cheeth.busiCpnt.page.mypage;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("MypageDao")
public class MypageDao extends AbstractDao {
  
  public MypageDao() {
    super.nameSpace = "mypage";
  }

}
