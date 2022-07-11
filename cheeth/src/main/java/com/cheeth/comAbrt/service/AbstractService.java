package com.cheeth.comAbrt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.util.ObjectUtils;

import com.cheeth.comAbrt.dao.AbstractDao;
import com.cheeth.comUtils.CommonUtil;

public class AbstractService implements ServiceInterface {

  @Autowired
  private ApplicationContext appContext;

  @Autowired
  private HttpServletRequest request;
  
  public AbstractDao dao;
  public String name;
  public AbstractService() {}
  
  public AbstractDao getDao() {
    return dao;
  }  

  public void setDao(AbstractDao dao) {
    this.dao = dao;
  }

  public void chkDao() {
    if(dao == null) {
      if(ObjectUtils.isEmpty(name)) {
        String serviceNm = this.getClass().getSimpleName();
        name = serviceNm.replace("Service", "Dao");
      }
      Class<? extends AbstractDao> classObj = AbstractDao.class;
      dao = classObj.cast(appContext.getBean(name));
    }
  }

  public String getName() {
    return name;
  }
  
  public void setName(String name) {
    this.name = name;
  }
  
  protected Map<String, String> getUserInfo() {

    HttpSession session = request.getSession();
    Map<String, String> rtnMap = new HashMap<String, String>();
    if(session != null && session.getAttribute("sessionInfo") != null) {
      
      Map<?, ?> sessionInfo = (Map<?, ?>) session.getAttribute("sessionInfo");
      Map<?, ?> user = (Map<?, ?>) sessionInfo.get("user");

      String userId = ObjectUtils.isEmpty(user.get("USER_ID")) ? "" : user.get("USER_ID").toString();
      String ipAddress = CommonUtil.getIpAddress(request);
      
      rtnMap.put("CREATE_ID", userId);
      rtnMap.put("UPDATE_ID", userId);
      rtnMap.put("USER_ID", userId);
    }

    return rtnMap;
  }

  
  @Override
  public List<?> list(String name, Object parameter) throws Exception {
    chkDao();
    return dao.list(name, parameter);
  }

  @Override
  public List<?> list(String nameSpace, String name, Object parameter) throws Exception {
    chkDao();
    return dao.list(nameSpace, name, parameter);
  }

  @Override
  public Map<?, ?> map(String name, Object parameter) throws Exception {
    chkDao();
    return dao.map(name, parameter);
  }

  @Override
  public Map<?, ?> map(String nameSpace, String name, Object parameter) throws Exception {
    chkDao();
    return dao.map(nameSpace, name, parameter);
  }

  @Override
  public String string(String name, Object parameter) throws Exception {
    chkDao();
    return dao.string(name, parameter);
  }

  @Override
  public String string(String nameSpace, String name, Object parameter) throws Exception {
    chkDao();
    return dao.string(nameSpace, name, parameter);
  }

  @Override
  public Integer integer(String name, Object parameter) throws Exception {
    chkDao();
    return dao.integer(name, parameter);
  }

  @Override
  public Integer integer(String nameSpace, String name, Object parameter) throws Exception {
    chkDao();
    return dao.integer(nameSpace, name, parameter);
  }
  
  @Override
  public Object insert(String name, Object parameter) throws Exception {
    chkDao();
    return dao.insert(name, parameter);
  }

  @Override
  public Object insert(String nameSpace, String name, Object parameter) throws Exception {
    chkDao();
    return dao.insert(nameSpace, name, parameter);
  }

  @Override
  public Object update(String name, Object parameter) throws Exception {
    chkDao();
    return dao.update(name, parameter);
  }

  @Override
  public Object update(String nameSpace, String name, Object parameter) throws Exception {
    chkDao();
  return dao.update(nameSpace, name, parameter);
  }

  @Override
  public Object delete(String name, Object parameter) throws Exception {
    chkDao();
    return dao.delete(name, parameter);
  }

  @Override
  public Object delete(String nameSpace, String name, Object parameter) throws Exception {
    chkDao();
  return dao.delete(nameSpace, name, parameter);
  }

  @Override
  public Object procedure(String name, Object parameter) throws Exception {
    chkDao();
    return dao.procedure(name, parameter);
  }

  @Override
  public Object procedure(String nameSpace, String name, Object parameter) throws Exception {
    chkDao();
    return dao.procedure(nameSpace, name, parameter);
  }

}