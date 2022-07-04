package com.cheeth.comUtils.filter;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.util.ContentCachingRequestWrapper;
import org.springframework.web.util.ContentCachingResponseWrapper;

@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class CommonFilter extends OncePerRequestFilter {

  @Value("${api.host}")
  private String host;

  @Value("${spring.profiles.active}")
  private String active;

  @Override
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
    throws ServletException, IOException {

    String uri = request.getRequestURI();

    response.setHeader("Access-Control-Allow-Origin", host);
    response.setHeader("Access-Control-Allow-Credentials", "true");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, HEAD, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Authorization, Content-Type, Access-Control-Request-Headers, Access-Control-Allow-Origin");
    response.setHeader("Access-Control-Max-Age", "3600");
    if(active.equals("prod")) { // 운영 서버일 경우
      response.setHeader("X-Frame-Options", "ALLOW-FROM " + host);
    }

    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    ContentCachingRequestWrapper wrappingRequest = new ContentCachingRequestWrapper(request);
    ContentCachingResponseWrapper wrappingResponse = new ContentCachingResponseWrapper(response);
    chain.doFilter(wrappingRequest, wrappingResponse);
    wrappingResponse.copyBodyToResponse();
  }

}
