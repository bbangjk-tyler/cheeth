package com.cheeth.busiCpnt.page.mypage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.cheeth.comAbrt.controller.BaseController;
import com.cheeth.comUtils.ParameterUtil;


@RestController
@RequestMapping(value="${api.url}/mypage")
public class MypageController extends BaseController {
  
  protected Logger logger = LogManager.getLogger(MypageController.class);
  
  @Value("${api.url}")
  String apiUrl;
  
  @Autowired
  private MypageService service;
  
  @GetMapping(value="/equipment_estimator_my_page_progress")
  public ModelAndView equipment_estimator_my_page_progress(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/mypage/equipment_estimator_my_page_progress");
    if(isSession()) {
      
      mv.addObject("PAGE", ObjectUtils.isEmpty(parameter.get("PAGE")) ? "1" : parameter.get("PAGE")); // 현재 페이지
      
      Map<String, Object> data = service.getData01(parameter);
      mv.addObject("DATA", data);
      
      mv.addObject("SEARCH_TXT", parameter.get("SEARCH_TXT"));
      
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @GetMapping(value="/receive_estimator")
  public ModelAndView receive_estimator(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/mypage/receive_estimator");
    if(isSession()) {
      
      Map<?, ?> data = service.getData02(parameter);
      if(data == null || data.isEmpty()) {
        mv.setViewName("redirect:/");
      } else {
        mv.addObject("DATA", data);
      }
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @PostMapping(value="/receive_estimator/save01")
  public Map<?, ?> save01(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();

    try {
      resultMap = service.save01(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  
  @GetMapping(value="/cad_completed")
  public ModelAndView cad_completed(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/mypage/cad_completed");
    if(isSession()) {
      
      Map<?, ?> data01 = service.getData02(parameter);
      Map<?, ?> data02 = service.getData04(parameter);
      if(data02 == null || data02.isEmpty()) {
        mv.setViewName("redirect:/");
      } else {
        mv.addObject("DATA_01", data01);
        mv.addObject("DATA_02", data02);
      }
      
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @PostMapping(value="/cad_completed/save02")
  public Map<?, ?> save02(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();

    boolean isException = true;
    try {
      resultMap = service.save02(parameter);
    } catch(Exception e) {
      isException = false;
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
    
    // CAD 완성 및 결제요청 (CAD가 완성되었습니다. 결제 진행해주세요)
    if(isException) {
      
    }

    return resultMap;
  }
  
  @GetMapping(value="/cad_completed_next")
  public ModelAndView cad_completed_next(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/mypage/cad_completed_next");
    if(isSession()) {
      
      Map<?, ?> data01 = service.getData02(parameter);
      Map<?, ?> data02 = service.getData05(parameter);
      if(data02 == null || data02.isEmpty()) {
        mv.setViewName("redirect:/");
      } else {
        mv.addObject("DATA_01", data01);
        mv.addObject("DATA_02", data02);
      }
      
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @PostMapping(value="/cad_completed_next/save05")
  public Map<?, ?> save05(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();

    boolean isException = true;
    try {
      resultMap = service.save05(parameter);
    } catch(Exception e) {
      isException = false;
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
    
    // 결제 완료 (결제가 완료되었습니다. 입금 확인 진행해주세요.)
    if(isException) {
      
    }

    return resultMap;
  }
  
  @PostMapping(value="/edit_info/save07")
  public Map<?, ?> save07(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();

    try {
      resultMap = service.save07(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    
    return resultMap;
  }
  
  @GetMapping(value="/receive_file")
  public ModelAndView receive_file(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/mypage/receive_file");
    if(isSession()) {
      
      Map<?, ?> data = service.getData02(parameter);
      Integer cnt = service.integer("getCnt07", parameter);
      if(data == null || data.isEmpty() || cnt == 0) {
        mv.setViewName("redirect:/");
      } else {
        mv.addObject("DATA", data);
      }
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @PostMapping(value="/receive_file/save03")
  public Map<?, ?> save03(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();

    try {
      resultMap = service.save03(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  
  @PostMapping(value="/equipment_estimator_my_page_progress/save04")
  public Map<?, ?> save04(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();

    try {
      resultMap = service.save04(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  
  // 입금확인
  @PostMapping(value="/equipment_estimator_my_page_progress/save06")
  public Map<?, ?> save06(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();

    boolean isException = true;
    try {
      resultMap = service.save06(parameter);
    } catch(Exception e) {
      isException = false;
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
    
    // 파일 수령 ( 파일을 수령해 주세요 )
    if(isException) {
      
    }

    return resultMap;
  }
  
  @GetMapping(value="/getSuppInfo", produces = MediaType.APPLICATION_JSON_VALUE)
  public List<Map<String, Object>> getSuppInfo(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    List<Map<String, Object>> list = (List<Map<String, Object>>) service.list("getSuppInfo", parameter);
    for(Map<String, Object> obj : list) {
      obj.put("SUPP_NM", ParameterUtil.reverseCleanXSS(obj.get("SUPP_NM").toString()));
    }
    
    return list;
  }
  
  @GetMapping(value="/my_page_edit_info")
  public ModelAndView my_info(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/mypage/my_page_edit_info");
    
    if(isSession()) {
      Map<?, ?> data = service.getData06(parameter);
      if(data == null || data.isEmpty()) {
        mv.setViewName("redirect:/");
      } else {
        mv.addObject("DATA", data);
      }
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @GetMapping(value="/equipment_estimator_my_page_equipment")
  public ModelAndView equipment_estimator_my_page_equipment(HttpServletRequest request) throws Exception {
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
        
    ModelAndView mv = new ModelAndView("page/mypage/equipment_estimator_my_page_equipment");
    if(isSession()) {
      
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
      
      mv.addObject("TOTAL_CNT", service.integer("getCnt03", parameter));
      mv.addObject("LIST", service.list("getList02", parameter));
      
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @GetMapping(value="/equipment_estimator_my_page_cad")
  public ModelAndView equipment_estimator_my_page_cad(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
      
    ModelAndView mv = new ModelAndView("page/mypage/equipment_estimator_my_page_cad");
    if(isSession()) {
      
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
      
      mv.addObject("TOTAL_CNT", service.integer("getCnt06", parameter));
      mv.addObject("LIST", service.list("getList03", parameter));
      
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
  }
  
    return mv;
  }
  
  @GetMapping(value="/equipment_estimator_my_page_sent")
  public ModelAndView equipment_estimator_my_page_sent(HttpServletRequest request) throws Exception {
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
        
    ModelAndView mv = new ModelAndView("page/mypage/equipment_estimator_my_page_sent");
    if(isSession()) {
      
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
      
      mv.addObject("TOTAL_CNT", service.integer("getCnt09", parameter));
      mv.addObject("LIST", service.list("getList04", parameter));
      
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @GetMapping(value="/profile_management")
  public ModelAndView profile_management(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView();
    if(isSession()) {
      Map<String, Object> data = service.getData07(parameter);
      mv.addObject("DATA", data);
      String userTypeCd = ObjectUtils.isEmpty(((Map<?, ?>) data.get("DATA_01")).get("USER_TYPE_CD")) ? "" : ((Map<?, ?>) data.get("DATA_01")).get("USER_TYPE_CD").toString();
      if(userTypeCd.equals("1") || userTypeCd.equals("2")) {
        mv.setViewName("page/mypage/profile_management");
      } else {
        mv.setViewName("redirect:" + "/" + apiUrl + "/mypage/profile_management_cheesigner");
      }
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @GetMapping(value="/profile_management_cheesigner")
  public ModelAndView profile_management_cheesigner(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView();
    if(isSession()) {
      Map<String, Object> data = service.getData07(parameter);
      mv.addObject("DATA", data);
      String userTypeCd = ObjectUtils.isEmpty(((Map<?, ?>) data.get("DATA_01")).get("USER_TYPE_CD")) ? "" : ((Map<?, ?>) data.get("DATA_01")).get("USER_TYPE_CD").toString();
      if(userTypeCd.equals("3")) {
        mv.setViewName("page/mypage/profile_management_cheesigner");
      } else {
        mv.setViewName("redirect:" + "/" + apiUrl + "/mypage/profile_management");
      }
    } else {
      mv.setViewName("redirect:" + "/" + apiUrl + "/login/view");
    }
    
    return mv;
  }
  
  @PostMapping(value="/profile_management_cheesigner/save08")
  public Map<?, ?> save08(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();
    try {
      resultMap = service.save08(request, parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }
  
  @PostMapping(value="/profile_management_cheesigner/save09")
  public Map<?, ?> save09(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, Object> resultMap = new HashMap<String, Object>();
    try {
      resultMap = service.save09(parameter);
    } catch(Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }

    return resultMap;
  }

  
  @GetMapping(value="/getProfile", produces=MediaType.APPLICATION_JSON_VALUE)
  public Map<?, ?> getProfile(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    Map<?, ?> data = service.getProfile(parameter);
    
    return data;
  }

}
