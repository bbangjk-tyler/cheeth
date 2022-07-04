package com.cheeth.comAbrt.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.mybatis.spring.support.SqlSessionDaoSupport;

public class AbstractDao extends SqlSessionDaoSupport implements DaoIterface {
  
  protected Logger logger = LogManager.getLogger(AbstractDao.class);
  protected String nameSpace;

  public SqlSessionFactory factory;

  public String getNameSpace() {
    return nameSpace;
  }

  public void setNameSpace(String nameSpace) {
    this.nameSpace = nameSpace;
  }

  @Override
  @Resource(name="sqlSessionFactorybean1") 
  public void setSqlSessionFactory(SqlSessionFactory sqlSessionFactory) {
    super.setSqlSessionFactory(sqlSessionFactory);
  }
  
  @Override
  public List<?> list(String name, Object parameter) throws Exception {
    return getSqlSession().selectList(this.nameSpace + "." + name, parameter);
  }

  @Override
  public List<?> list(String nameSpace, String name, Object parameter) throws Exception {
    return getSqlSession().selectList(nameSpace + "." + name, parameter);
  }
  
  @Override
  public Map<?,?> map(String name, Object parameter) throws Exception {
    return (Map<?,?>)getSqlSession().selectOne(this.nameSpace + "." + name, parameter);
  }

  @Override
  public Map<?, ?> map(String nameSpace, String name, Object parameter) throws Exception {
    return (Map<?, ?>) getSqlSession().selectOne(nameSpace + "." + name, parameter);
  }

  @Override
  public String string(String name, Object parameter) throws Exception {
    return (String) getSqlSession().selectOne(this.nameSpace + "." + name, parameter);
  }

  @Override
  public String string(String nameSpace, String name, Object parameter) throws Exception {
    return (String) getSqlSession().selectOne(nameSpace + "." + name, parameter);
  }

  @Override
  public Integer integer(String name, Object parameter) throws Exception {
    return (Integer) getSqlSession().selectOne(this.nameSpace + "." + name, parameter);
  }

  @Override
  public Integer integer(String nameSpace, String name, Object parameter) throws Exception {
    return (Integer) getSqlSession().selectOne(nameSpace + "." + name, parameter);
  }

  @Override
  public Object insert(String name, Object parameter) throws Exception {
    return getSqlSession().insert(this.nameSpace + "." + name, parameter);
  }

  @Override
  public Object insert(String nameSpace, String name, Object parameter) throws Exception {
    return getSqlSession().insert(nameSpace + "." + name, parameter);
  }

  @Override
  public Object update(String name, Object parameter) throws Exception {
    return getSqlSession().update(this.nameSpace + "." + name, parameter);
  }

  @Override
  public Object update(String nameSpace, String name, Object parameter) throws Exception {
    return getSqlSession().update(nameSpace + "." + name, parameter);
  }

  @Override
  public Object delete(String name, Object parameter) throws Exception {
    return getSqlSession().delete(this.nameSpace + "." + name, parameter);
  }

  @Override
  public Object delete(String nameSpace, String name, Object parameter) throws Exception {
    return getSqlSession().delete(nameSpace + "." + name, parameter);
  }

  @Override
  public Object procedure(String name, Object parameter) throws Exception {
    return getSqlSession().selectOne(this.nameSpace + "." + name, parameter);
  }

  @Override
  public Object procedure(String nameSpace, String name, Object parameter) throws Exception {
    return getSqlSession().selectOne(nameSpace + "." + name, parameter);
  }

}