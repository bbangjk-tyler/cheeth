package com.cheeth.comAbrt.dao;


import java.util.List;
import java.util.Map;

public interface DaoIterface {

  public List<?> list(String name, Object parameter) throws Exception;
  public List<?> list(String namespace, String name,Object parameter) throws Exception;
  
  public Map<?,?> map(String name, Object parameter) throws Exception;
  public Map<?,?> map(String namespace, String name, Object parameter) throws Exception;
  
  public String string(String name, Object parameter) throws Exception;
  public String string(String namespace, String name, Object parameter) throws Exception;

  public Integer integer(String name, Object parameter) throws Exception;
  public Integer integer(String namespace, String name, Object parameter) throws Exception;
  
  public Object insert(String name, Object parameter) throws Exception;
  public Object insert(String namespace, String name, Object parameter) throws Exception;
  
  public Object update(String name, Object parameter) throws Exception; 
  public Object update(String namespace, String name, Object parameter) throws Exception;
  
  public Object delete(String name, Object parameter) throws Exception;
  public Object delete(String namespace, String name, Object parameter) throws Exception;

  public Object procedure(String name, Object parameter) throws Exception;
  public Object procedure(String namespace, String name, Object parameter) throws Exception;

}