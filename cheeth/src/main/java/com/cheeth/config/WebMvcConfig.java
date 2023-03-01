package com.cheeth.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
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
  
  
  @Bean
  public ReloadableResourceBundleMessageSource messageSource() {
		ReloadableResourceBundleMessageSource source = new ReloadableResourceBundleMessageSource();
		// 메세지 프로퍼티파일의 위치와 이름을 지정한다.
      source.setBasename("classpath:/messages/message");
      // 기본 인코딩을 지정한다.
      source.setDefaultEncoding("UTF-8");
      // 프로퍼티 파일의 변경을 감지할 시간 간격을 지정한다.
      source.setCacheSeconds(60);
      // 없는 메세지일 경우 예외를 발생시키는 대신 코드를 기본 메세지로 한다.
      source.setUseCodeAsDefaultMessage(true);
      return source;
  }
  	/**
	 * 변경된 언어 정보를 기억할 로케일 리졸퍼를 생성한다.
	 * 여기서는 세션에 저장하는 방식을 사용한다.
	 * @return
	 */
	@Bean
	public SessionLocaleResolver localeResolver() {
		SessionLocaleResolver localeResolver = new SessionLocaleResolver();
		//localeResolver.setDefaultLocale(Locale.KOREA); //Locale.US
		return localeResolver;
	}
	/**
	언어 변경을 위한 인터셉터를 생성한다.
	 */
	@Bean
	public LocaleChangeInterceptor localeChangeInterceptor() {
		LocaleChangeInterceptor interceptor = new LocaleChangeInterceptor();
		interceptor.setParamName("lang");
		return interceptor;
	}
	
}
