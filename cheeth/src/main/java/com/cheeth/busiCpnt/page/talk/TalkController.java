package com.cheeth.busiCpnt.page.talk;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.cheeth.comAbrt.controller.BaseController;
import com.cheeth.comUtils.ParameterUtil;

@RestController
@RequestMapping(value="${api.url}/talk")
public class TalkController extends BaseController {
  
  protected Logger logger = LogManager.getLogger(TalkController.class);
  
  @Value("${api.url}")
  String apiUrl;
  
  @Autowired
  private TalkService service;
  
  @GetMapping(value="/receive")
  public ModelAndView receive(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/talk/receive");
    if(isSession()) {
      mv.addObject("PAGE", ObjectUtils.isEmpty(parameter.get("PAGE")) ? "1" : parameter.get("PAGE")); // 현재 페이지

      String lang = request.getSession().getAttribute("language").toString();
      parameter.put("LANG", lang);
      Map<String, Object> rtnMap = service.getData01(parameter);
      
      mv.addObject("TALK_CD_LIST", rtnMap.get("TALK_CD_LIST")); // 읽은쪽지, 안읽은쪽지 코드
      mv.addObject("TOTAL_CNT", rtnMap.get("TOTAL_CNT")); // 총건수
      mv.addObject("LIST", rtnMap.get("LIST")); // 목록조회
      mv.addObject("SEND_CNT", rtnMap.get("SEND_CNT")); // 보낸 쪽지 수
      
      mv.addObject("TOTAL_RECEIVE_CNT", rtnMap.get("TOTAL_RECEIVE_CNT")); // 받은 전제 쪽지 수
      mv.addObject("NREAD_RECEIVE_CNT", rtnMap.get("NREAD_RECEIVE_CNT")); // 안읽은 쪽지 수
      
      mv.addObject("USER_LIST", rtnMap.get("USER_LIST"));
      mv.addObject("USER_CNT", rtnMap.get("USER_CNT"));
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @GetMapping(value="/send")
  public ModelAndView send(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/talk/send");
    if(isSession()) {
      mv.addObject("PAGE", ObjectUtils.isEmpty(parameter.get("PAGE")) ? "1" : parameter.get("PAGE")); // 현재 페이지

      String lang = request.getSession().getAttribute("language").toString();
      parameter.put("LANG", lang);
      Map<String, Object> rtnMap = service.getData02(parameter);
      
      mv.addObject("TALK_CD_LIST", rtnMap.get("TALK_CD_LIST")); // 읽은쪽지, 안읽은쪽지 코드
      mv.addObject("TOTAL_CNT", rtnMap.get("TOTAL_CNT")); // 총건수
      mv.addObject("LIST", rtnMap.get("LIST")); // 목록조회
      mv.addObject("SEND_CNT", rtnMap.get("SEND_CNT")); // 보낸 쪽지 수
      
      mv.addObject("TOTAL_RECEIVE_CNT", rtnMap.get("TOTAL_RECEIVE_CNT")); // 받은 전제 쪽지 수
      mv.addObject("NREAD_RECEIVE_CNT", rtnMap.get("NREAD_RECEIVE_CNT")); // 안읽은 쪽지 수
      
      mv.addObject("USER_LIST", rtnMap.get("USER_LIST"));
      mv.addObject("USER_CNT", rtnMap.get("USER_CNT"));
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @PostMapping(value="/save01")
  public Map<?, ?> save01(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
      resultMap = service.save01(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  @PostMapping(value="/save05")
  public Map<?, ?> save05(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
      resultMap = service.save05(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  
  // 받은쪽지 삭제
  @PostMapping(value="/delete01")
  public Map<?, ?> delete01(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
      resultMap = service.delete01(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  
  // 받은쪽지 삭제 단건
  @PostMapping(value="/delete02")
  public Map<?, ?> delete02(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
      resultMap = service.delete02(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  
  // 보낸쪽지 삭제
  @PostMapping(value="/delete03")
  public Map<?, ?> delete03(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
      resultMap = service.delete03(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
 
  // 보낸쪽지 삭제 단건
  @PostMapping(value="/delete04")
  public Map<?, ?> delete04(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, String> resultMap = new HashMap<String, String>();

    try {
      resultMap = service.delete04(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  
  // 받은 쪽지 상세보기
  @GetMapping(value="/getData03")
  public Map<?, ?> getData03(HttpServletRequest request) throws Exception {
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    String lang = request.getSession().getAttribute("language").toString();
    parameter.put("LANG", lang);
    Map<String, Object> resultMap = service.getData03(parameter);
    return resultMap;
  }
  
  // 보낸 쪽지 상세보기
  @GetMapping(value="/getData04")
  public Map<?, ?> getData04(HttpServletRequest request) throws Exception {
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    String lang = request.getSession().getAttribute("language").toString();
    parameter.put("LANG", lang);
    Map<String, Object> resultMap = service.getData04(parameter);
    return resultMap;
  }
  //안읽은 메시지
  @GetMapping(value="/getUnreadCnt2")
  public Map<?, ?> getUnreadCnt2(HttpServletRequest request) throws Exception {
	    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
	    Map<String, Object> resultMap = service.getUnreadCnt2(parameter);
	    return resultMap;
	  }
}
