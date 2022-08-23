package com.cheeth.busiCpnt.page.cheesigner;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.cheeth.comAbrt.controller.BaseController;
import com.cheeth.comUtils.ParameterUtil;

@RestController
@RequestMapping(value="${api.url}/cheesigner")
public class CheesignerController extends BaseController {
	 @Value("${api.url}")
	  String apiUrl;
  protected Logger logger = LogManager.getLogger(CheesignerController.class);
  
  @Autowired
  CheesignerService service;
  
  @GetMapping(value="/cheesigner_view_all")
  public ModelAndView cheesigner_view_all(HttpServletRequest request) throws Exception {
      
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
      
    ModelAndView mv = new ModelAndView("page/cheesigner/cheesigner_view_all");
    
    mv.addObject("PAGE", ObjectUtils.isEmpty(parameter.get("PAGE")) ? "1" : parameter.get("PAGE")); // 현재 페이지
    Integer page = 0;
    if(!ObjectUtils.isEmpty(parameter.get("PAGE")) && parameter.get("PAGE").toString().chars().allMatch(Character::isDigit)) {
      page = Integer.parseInt(parameter.get("PAGE").toString());
      if(page == 1) {
        page = 0;
      } else {
        page = (page-1) * 10;
      }
    }
    parameter.put("PAGE", page);
    
    mv.addObject("TOTAL_CNT", service.integer("getCnt01", parameter));
    
    mv.addObject("LIST", service.list("getList01", parameter));
    
    parameter.put("GROUP_CD", "PROJECT_CD");
    mv.addObject("PROJECT_CD_LIST", service.list("common", "getCode", parameter)); // 프로젝트 코드
      
    return mv;
  }
  @GetMapping(value="/cheesigner_info")
  public ModelAndView cheesigner_info(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    String UserID = service.string("getUserID", parameter);
    parameter.put("USER_ID", UserID);
    parameter.put("CREATE_ID", parameter.get("USER_ID"));
    parameter.put("PAGE", 0);
    ModelAndView mv = new ModelAndView();
    if(isSession()) {
      Map<String, Object> data = service.getData07(parameter);
      mv.addObject("DATA", data);
      String userTypeCd = ObjectUtils.isEmpty(((Map<?, ?>) data.get("DATA_01")).get("USER_TYPE_CD")) ? "" : ((Map<?, ?>) data.get("DATA_01")).get("USER_TYPE_CD").toString();

      mv.addObject("LIST", service.list("getList10", parameter));
      if(userTypeCd.equals("3")) {
        mv.setViewName("page/cheesigner/cheesigner_info");
      } else {
        mv.setViewName("redirect:" + "/" + apiUrl + "/cheesigner/cheesigner_info");
      }
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
}
