package com.cheeth.config;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.type.JdbcType;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import com.cheeth.comUtils.interceptor.QueryInterceptor;

@Configuration
public class MybatisConfig {

  @Autowired
  @Qualifier("ds1") DataSource ds1;

  @Autowired
  @Qualifier("ds2") DataSource ds2;

  @Bean(name="sqlSessionFactorybean1")
  SqlSessionFactory sqlSessionFactorybean1() throws Exception {
    
    SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
    factoryBean.setDataSource(ds1);
    String[] strLoc = { "com/cheeth/busiCpnt/**/*.xml", "com/cheeth/busiCpnt/**/**/*.xml" };
    List<Resource[]> listRes = new ArrayList<>();
    int totalSize = 0;
    for(String loc : strLoc) {
      Resource[] locRes = new PathMatchingResourcePatternResolver().getResources(loc);
      listRes.add(locRes);
      totalSize += locRes.length;
    }
    
    Resource[] resources = new Resource[totalSize];
    int seq = 0;
    for(Resource[] arrRes : listRes) {
      for(Resource res : arrRes) {
        resources[seq] = res;
        seq++;
      }
    }

    factoryBean.setPlugins(new QueryInterceptor()); // query log
  
    factoryBean.setMapperLocations(resources);
    factoryBean.setConfigLocation(new PathMatchingResourcePatternResolver().getResource("mybatis-config.xml"));
    SqlSessionFactory sqlFactoryBean = factoryBean.getObject();
    sqlFactoryBean.getConfiguration().setJdbcTypeForNull(JdbcType.NULL);
    
    return sqlFactoryBean;
  }

  @Bean(name="SqlSessionTemplate1")
  SqlSessionTemplate SqlSessionTemplate1() throws Exception {
    return new SqlSessionTemplate(sqlSessionFactorybean1());
  }

  @Bean(name="sqlSessionFactorybean2")
  SqlSessionFactory sqlSessionFactorybean2() throws Exception {

    SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
    factoryBean.setDataSource(ds2);
    String[] strLoc = { "com/cheeth/busiCpnt/**/*.xml", "com/cheeth/busiCpnt/**/**/*.xml" };
    List<Resource[]> listRes = new ArrayList<>();
    int totalSize = 0;
    for (String loc : strLoc) {
      Resource[] locRes = new PathMatchingResourcePatternResolver().getResources(loc);
      listRes.add(locRes);
      totalSize += locRes.length;
    }

    Resource[] resources = new Resource[totalSize];
    int seq = 0;
    for (Resource[] arrRes : listRes) {
      for (Resource res : arrRes) {
        resources[seq] = res;
        seq++;
      }
    }

    factoryBean.setPlugins(new QueryInterceptor()); // query log

    factoryBean.setMapperLocations(resources);
    factoryBean.setConfigLocation(new PathMatchingResourcePatternResolver().getResource("mybatis-config.xml"));
    SqlSessionFactory sqlFactoryBean = factoryBean.getObject();
    sqlFactoryBean.getConfiguration().setJdbcTypeForNull(JdbcType.NULL);

    return sqlFactoryBean;
  }

  @Bean(name="SqlSessionTemplate2")
  SqlSessionTemplate SqlSessionTemplate2() throws Exception {
    return new SqlSessionTemplate(sqlSessionFactorybean2());
  }

}