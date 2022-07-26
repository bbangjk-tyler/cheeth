package com.cheeth.busiCpnt.page.sign;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.cheeth.busiCpnt.common.CommonService;
import com.cheeth.comAbrt.controller.BaseController;
import com.cheeth.comUtils.ParameterUtil;

@RestController
@RequestMapping(value = "${api.url}/sign")
public class SignController extends BaseController {

  protected Logger logger = LogManager.getLogger(SignController.class);

  @Value("${api.url}")
  private String api;

  @Autowired
  private SignService service;

  @Autowired
  private CommonService commonService;

  // 회원가입
  @GetMapping(value = "/sign_up_membership_type")
  public ModelAndView sign_up_membership_type(HttpServletRequest request) throws Exception {

    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);

    ModelAndView mv = new ModelAndView("page/sign/sign_up_membership_type");

    return mv;
  }

  // 약관동의
  @RequestMapping(value = "/accept_conditions", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView accept_conditions(HttpServletRequest request) throws Exception {

    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);

    ModelAndView mv = new ModelAndView("page/sign/accept_conditions");
    
    String dvsn = (String) parameter.get("dvsn");
    mv.addObject("dvsn", dvsn);
    
    if("sns".equals(dvsn)) {
	  List<Map<String, Object>> snsInfoList = new ArrayList<>();
	  
	  parameter.forEach((key, value) -> {
	    if(key.startsWith("SNS_")) {
	      Map<String, Object> snsInfo = new HashMap<>();
	      snsInfo.put("KEY", key);
	      snsInfo.put("VALUE", value);
	      snsInfoList.add(snsInfo);
	    }
	  });
	  mv.addObject("snsInfoList", snsInfoList);
    }

    return mv;
  }

  // 일반회원가입
  @RequestMapping(value = "/sign_up_individual", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView sign_up_individual(HttpServletRequest request) throws Exception {

    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);

    ModelAndView mv = new ModelAndView("page/sign/sign_up_individual");

    return mv;
  }

  // 전문가 회원(치자이너)
  @RequestMapping(value = "/sign_up_expert_cheesigner", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView sign_up_expert_cheesigner(HttpServletRequest request) throws Exception {

    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);

    parameter.put("GROUP_CD", "JOB_CD_01");
    List<Map<String, String>> jobCdList = (List<Map<String, String>>) commonService.getList(parameter);

    parameter.put("GROUP_CD", ""); // 은행코드
    List<Map<String, String>> bankCdList = (List<Map<String, String>>) commonService.getList(parameter);

    ModelAndView mv = new ModelAndView("page/sign/sign_up_expert_cheesigner");
    mv.addObject("jobCdList", jobCdList);
    mv.addObject("bankCdList", bankCdList);

    return mv;
  }

  // 전문가 회원(의뢰인)
  @RequestMapping(value = "/sign_up_expert_client", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView sign_up_expert_client(HttpServletRequest request) throws Exception {

    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);

    parameter.put("GROUP_CD", "JOB_CD_02");
    List<Map<String, String>> jobCdList = (List<Map<String, String>>) commonService.getList(parameter);

    ModelAndView mv = new ModelAndView("page/sign/sign_up_expert_client");
    mv.addObject("jobCdList", jobCdList);

    return mv;
  }
  
  @PostMapping(value = "/sign_up_sns")
  public ModelAndView sign_up_sns(HttpServletRequest request) throws Exception {
	 
  	Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
  	
  	parameter.put("GROUP_CD", "JOB_CD_01");
    List<Map<String, String>> jobCdList1 = (List<Map<String, String>>) commonService.getList(parameter);
  	parameter.put("GROUP_CD", "JOB_CD_02");
  	List<Map<String, String>> jobCdList2 = (List<Map<String, String>>) commonService.getList(parameter);
  	
  	ModelAndView mv = new ModelAndView("page/sign/sign_up_sns");
  	Map<String, Object> snsInfo = new HashMap<>();
  	parameter.forEach((key, value) -> {
  	  if(key.startsWith("SNS_")) snsInfo.put(key, value);
  	});
  	mv.addObject("snsInfo", snsInfo);
  	mv.addObject("jobCdList1", jobCdList1);
  	mv.addObject("jobCdList2", jobCdList2);
  	  
  	return mv;
  }
  
  @PostMapping(value = "/sign_up", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> sign_up(HttpServletRequest request) throws Exception {

    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, Object> resultMap = new HashMap<>();
    
    //ModelAndView mv = new ModelAndView();
    try {
      resultMap = service.save01(parameter);
      //mv.setViewName("redirect:/" + api + "/login/view");
    } catch (Exception e) {
      logger.error(e.getMessage());
    }
    return resultMap;
  }
  
  @PostMapping(value = "/check_signed_up_sns", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> getInfo(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> rtnMap = new HashMap<>();
    try {
      Map<?, ?> info = service.getSnsInfo(parameter);
      if(ObjectUtils.isEmpty(info)) {
        rtnMap.put("result", "N");
      } else {
        rtnMap.put("result", "Y");
      }
    } catch (Exception e) {
      logger.error(e.getMessage());
    }
    return rtnMap;
  }
}