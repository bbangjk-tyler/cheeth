package com.cheeth.config;

import javax.sql.DataSource;

import com.zaxxer.hikari.HikariDataSource;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

@Configuration
public class DataSourcesConfig {

  @Bean
  @Primary
  @ConfigurationProperties("db1.hikari")
  DataSource ds1() {
    return DataSourceBuilder.create().type(HikariDataSource.class).build();
  }

  @Bean
  @Primary
  public DataSourceTransactionManager transactionManager1() {
    return new DataSourceTransactionManager(ds1());
  }

  @Bean
  @ConfigurationProperties("db2.hikari")
    DataSource ds2() {
    return DataSourceBuilder.create().type(HikariDataSource.class).build();
  }

  @Bean
  public DataSourceTransactionManager transactionManager2() {
    return new DataSourceTransactionManager(ds2());
  }
  
}
