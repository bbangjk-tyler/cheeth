package com.cheeth.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.cheeth.comUtils.interceptor.ApiInterceptor;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
  
  @Value("${api.url}")
  private String apiUrl;
  
  @Value("${upload.resource}")
  private String uploadResource;

  @Value("${upload.directory}")
  private String uploadDirectory;
  
  @Autowired
  private ApiInterceptor apiInterceptor;
  
  @Override
  public void addInterceptors(InterceptorRegistry registry) {
    
    registry.addInterceptor(apiInterceptor)
            .addPathPatterns("/" + apiUrl + "/**");
  }
  
  @Override
  public void addResourceHandlers(ResourceHandlerRegistry registry) {
    registry.addResourceHandler(uploadResource)
            .addResourceLocations(uploadDirectory);
  }
  
  @Override
  public void addViewControllers(ViewControllerRegistry registry) {
      registry.addViewController("/").setViewName("redirect:/" + apiUrl + "/main/main");
  }

}
