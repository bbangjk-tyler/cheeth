package com.cheeth.message;

import java.lang.reflect.Array;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.mail.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.ognl.enhance.LocalReference;
import org.apache.tomcat.util.descriptor.LocalResolver;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.util.WebUtils;

import com.cheeth.busiCpnt.common.CommonController;
import com.cheeth.busiCpnt.common.CommonService;
import com.cheeth.comUtils.ParameterUtil;


@RestController
@RequestMapping(value="${api.url}/message")
public class MessageController {

    @Autowired
    MessageSource messageSource;
    
    @Autowired
    LocaleResolver localeResolver;
    

    @RequestMapping(value = "/i18n", method = RequestMethod.GET)
    public void i18n(HttpServletRequest request) throws Exception {
    	Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    	
        String lang = parameter.get("lang").toString();
    	Locale locale = new Locale(lang);
        localeResolver.setLocale(request, null, locale);
        
    	request.getSession();
    	request.getSession().setAttribute("language", lang);
   }

    @RequestMapping(value = "/getI18nMsg", method = RequestMethod.GET)
    public String getI18nMsg(HttpServletRequest request) throws Exception {
    	Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
        String property = parameter.get("property").toString();
        String param = parameter.getOrDefault("param", "").toString();
        String msg = messageSource.getMessage(property, new String[]{param}, localeResolver.resolveLocale(request));
        return msg;
   }
}
