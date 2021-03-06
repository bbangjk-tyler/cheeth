package org.apache.ibatis.scripting.xmltags;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

import org.apache.ibatis.ognl.OgnlContext;
import org.apache.ibatis.ognl.OgnlRuntime;
import org.apache.ibatis.ognl.PropertyAccessor;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.session.Configuration;
import org.springframework.util.StringUtils;

@SuppressWarnings({"unchecked", "rawtypes"})
public class DynamicContext {

  public static final String PARAMETER_OBJECT_KEY = "_parameter";
  public static final String DATABASE_ID_KEY = "_databaseId";

  static {
    OgnlRuntime.setPropertyAccessor(ContextMap.class, (PropertyAccessor) new ContextAccessor());
  }

  private final ContextMap bindings;
  private final StringJoiner sqlBuilder = new StringJoiner(" ");
  private int uniqueNumber = 0;

  public DynamicContext(Configuration configuration, Object parameterObject) {
    if (parameterObject != null && !(parameterObject instanceof Map)) {
      MetaObject metaObject = configuration.newMetaObject(parameterObject);
      boolean existsTypeHandler = configuration.getTypeHandlerRegistry().hasTypeHandler(parameterObject.getClass());
      bindings = new ContextMap(metaObject, existsTypeHandler);
    } else {
      bindings = new ContextMap(null, false);
    }
    bindings.put(PARAMETER_OBJECT_KEY, parameterObject);
    bindings.put(DATABASE_ID_KEY, configuration.getDatabaseId());
  }

  public Map<String, Object> getBindings() {
    return bindings;
  }

  public void bind(String name, Object value) {
    bindings.put(name, value);
  }

  public void appendSql(String sql) {
    sqlBuilder.add(sql);
  }

  public String getSql() {
    return sqlBuilder.toString().trim();
  }

  public int getUniqueNumber() {
    return uniqueNumber++;
  }

  static class ContextMap extends HashMap<String, Object> {
    private static final long serialVersionUID = 2977601501966151582L;
    private final MetaObject parameterMetaObject;
    private final boolean fallbackParameterObject;

    public ContextMap(MetaObject parameterMetaObject, boolean fallbackParameterObject) {
      this.parameterMetaObject = parameterMetaObject;
      this.fallbackParameterObject = fallbackParameterObject;
    }

    @Override
    public Object get(Object key) {
      String strKey = (String) key;
      if (super.containsKey(strKey)) {
        return super.get(strKey);
      }

      if (parameterMetaObject == null) {
        return null;
      }

      if (fallbackParameterObject && !parameterMetaObject.hasGetter(strKey)) {
        return parameterMetaObject.getOriginalObject();
      } else {
        // issue #61 do not modify the context when reading
        return parameterMetaObject.getValue(strKey);
      }
    }

    public boolean isEmpty(String args) {
      boolean rtn = false;
      if (StringUtils.isEmpty(args)) {
        rtn = true;
      }
      return rtn;
    }

    public boolean isEmpty(Integer args) {
      boolean rtn = false;
      if (StringUtils.isEmpty(args)) {
        rtn = true;
      }
      return rtn;
    }

    public boolean isEmpty(Map args) {
      boolean rtn = false;
      if (args == null || args.isEmpty()) {
        rtn = true;
      }
      return rtn;
    }

    public boolean isEmpty(List args) {
      boolean rtn = false;
      if (args == null || args.isEmpty() || args.size() == 0) {
        rtn = true;
      }
      return rtn;
    }

    public boolean isNotEmpty(String args) {
      boolean rtn = true;
      if (isEmpty(args)) {
        rtn = false;
      }
      return rtn;
    }

    public boolean isNotEmpty(Integer args) {
      boolean rtn = true;
      if (isEmpty(args)) {
        rtn = false;
      }
      return rtn;
    }

    public boolean isNotEmpty(Map args) {
      boolean rtn = true;
      if (isEmpty(args)) {
        rtn = false;
      }
      return rtn;
    }

    public boolean isNotEmpty(List args) {
      boolean rtn = true;
      if (isEmpty(args)) {
        rtn = false;
      }
      return rtn;
    }

  }

  static class ContextAccessor implements PropertyAccessor {

    @Override
    public Object getProperty(Map context, Object target, Object name) {
      Map map = (Map) target;

      Object result = map.get(name);
      if (map.containsKey(name) || result != null) {
        return result;
      }

      Object parameterObject = map.get(PARAMETER_OBJECT_KEY);
      if (parameterObject instanceof Map) {
        return ((Map) parameterObject).get(name);
      }

      return null;
    }

    @Override
    public void setProperty(Map context, Object target, Object name, Object value) {
      Map<Object, Object> map = (Map<Object, Object>) target;
      map.put(name, value);
    }

    @Override
    public String getSourceAccessor(OgnlContext arg0, Object arg1, Object arg2) {
      return null;
    }

    @Override
    public String getSourceSetter(OgnlContext arg0, Object arg1, Object arg2) {
      return null;
    }
  }
}