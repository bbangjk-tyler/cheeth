package com.cheeth.busiCpnt.page.sign;

import org.springframework.stereotype.Component;

import com.cheeth.comAbrt.dao.AbstractDao;

@Component("SignDao")
public class SignDao extends AbstractDao {

    public SignDao() {
        super.nameSpace = "sign";
    }
}
