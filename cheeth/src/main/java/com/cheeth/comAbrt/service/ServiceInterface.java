package com.cheeth.comAbrt.service;

import java.util.List;
import java.util.Map;

public interface ServiceInterface {

  public List<?> list(String name, Object parameter) throws Exception;
  public List<?> list(String nameSpace, String name, Object parameter) throws Exception;

  public Map<?,?> map(String name, Object parameter) throws Exception;
  public Map<?,?> map(String nameSpace, String name, Object parameter) throws Exception;

  public Object string(String name, Object parameter) throws Exception;
  public Object string(String nameSpace, String name, Object parameter) throws Exception;

  public Object integer(String name, Object parameter) throws Exception;
  public Object integer(String nameSpace, String name, Object parameter) throws Exception;
  
  public Object insert(String name, Object parameter) throws Exception;
  public Object insert(String nameSpace, String name, Object parameter) throws Exception;

  public Object update(String name, Object parameter) throws Exception; 
  public Object update(String nameSpace, String name, Object parameter) throws Exception;

  public Object delete(String name, Object parameter) throws Exception;
  public Object delete(String nameSpace, String name, Object parameter) throws Exception;

  public Object procedure(String name, Object parameter) throws Exception;
  public Object procedure(String nameSpace, String name, Object parameter) throws Exception;

}