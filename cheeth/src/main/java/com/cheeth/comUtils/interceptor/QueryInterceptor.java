package com.cheeth.comUtils.interceptor;

import java.lang.reflect.Field;
import java.sql.Statement;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Signature;
import org.apache.ibatis.session.ResultHandler;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.util.StringUtils;

@Intercepts({
    @Signature(type = StatementHandler.class, method = "query", args = { Statement.class, ResultHandler.class }),
    @Signature(type = StatementHandler.class, method = "update", args = { Statement.class }) })
public class QueryInterceptor implements Interceptor {

  private final Logger logger = LogManager.getLogger(QueryInterceptor.class);

  @Override
  public Object intercept(Invocation arg0) throws Throwable {

    StatementHandler handler = (StatementHandler) arg0.getTarget();

    Object param = handler.getParameterHandler().getParameterObject();

    String sql = bindSql(handler);
    logger.info(sql);
    logger.info(param);

    return arg0.proceed();
  }

  private String bindSql(StatementHandler handler) throws NoSuchFieldException, IllegalAccessException {

    BoundSql boundSql = handler.getBoundSql();

    // 쿼리실행시 맵핑되는 파라미터를 구한다
    Object param = handler.getParameterHandler().getParameterObject();
    // 쿼리문을 가져온다(이 상태에서의 쿼리는 값이 들어갈 부분에 ?가 있다)
    String sql = boundSql.getSql();

    // 바인딩 파라미터가 없으면
    if (StringUtils.isEmpty(param)) {
      sql = sql.replaceFirst("\\?", "''");
      return sql;
    }

    // 해당 파라미터의 클래스가 Integer, Long, Float, Double 클래스일 경우
    if (param instanceof Integer || param instanceof Long || param instanceof Float || param instanceof Double) {
      sql = sql.replaceFirst("\\?", param.toString());
    }
    // 해당 파라미터의 클래스가 String인 경우
    else if (param instanceof String) {
      sql = sql.replaceFirst("\\?", "'" + param + "'");
    }
    // 해당 파라미터의 클래스가 Map인 경우
    else if (param instanceof Map) {
      List<ParameterMapping> paramMapping = boundSql.getParameterMappings();
      for (ParameterMapping mapping : paramMapping) {
        String propValue = mapping.getProperty();
        Object value = ((Map<?, ?>) param).get(propValue);
        if (StringUtils.isEmpty(value)) {
          // __frch_ PREFIX에 대한 처리
          if (boundSql.hasAdditionalParameter(propValue)) { // myBatis가 추가 동적인수를 생성했는지 체크하고
            value = boundSql.getAdditionalParameter(propValue); // 해당 추가 동적인수의 Value를 가져옴
          }
          if (StringUtils.isEmpty(value)) {
            value = "";
          }
        }

        if (value instanceof String) {
          sql = sql.replaceFirst("\\?", "'" + value + "'");
        } else {
          sql = sql.replaceFirst("\\?", value.toString());
        }
      }
    }
    // 해당 파라미터의 클래스가 사용자 정의 클래스인 경우
    else {
      List<ParameterMapping> paramMapping = boundSql.getParameterMappings();
      Class<? extends Object> paramClass = param.getClass();

      for (ParameterMapping mapping : paramMapping) {
        String propValue = mapping.getProperty();
        Field field = paramClass.getDeclaredField(propValue);
        field.setAccessible(true);
        Class<?> javaType = mapping.getJavaType();
        if (String.class == javaType) {
          sql = sql.replaceFirst("\\?", "'" + field.get(param) + "'");
        } else {
          sql = sql.replaceFirst("\\?", field.get(param).toString());
        }
      }
    }

    return sql;
  }

}
