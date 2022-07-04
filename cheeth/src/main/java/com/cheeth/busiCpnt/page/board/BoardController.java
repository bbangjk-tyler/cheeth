package com.cheeth.busiCpnt.page.board;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
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
@RequestMapping(value="${api.url}/board")
public class BoardController extends BaseController {
  
  protected Logger logger = LogManager.getLogger(BoardController.class);
  
  @Autowired
  private BoardService service;

  @GetMapping(value="/notice")
  public ModelAndView notice(HttpServletRequest request) throws Exception {
      
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
      
    ModelAndView mv = new ModelAndView("page/board/notice");
      
    return mv;
  }

  @GetMapping(value="/qna")
  public ModelAndView qna(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    ModelAndView mv = new ModelAndView("page/board/qna");
    mv.addObject("LIST", service.list("getList", parameter));
    return mv;
  }
  
  @GetMapping(value="/list")
  public ModelAndView list(HttpServletRequest request) throws Exception {
    
  	Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
  	
  	String type = ObjectUtils.isEmpty(parameter.get("BOARD_TYPE")) ? "NOTICE" : parameter.get("BOARD_TYPE").toString();
  	
  	ModelAndView mv = new ModelAndView("page/board/" + type.toLowerCase());
  	
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
    
    mv.addObject("BOARD_TYPE", type);
    mv.addObject("SEARCH_TXT", parameter.get("SEARCH_TXT"));
    mv.addObject("TOTAL_CNT", service.integer("getCnt01", parameter)); // 총건수
  	mv.addObject("LIST", service.list("getList", parameter));
  	
  	return mv;
  }
  
  @GetMapping(value="/view")
  public ModelAndView qna_view(HttpServletRequest request) throws Exception {
    
    Map<String, Object> parameter = ParameterUtil.getParameterMap(request);
    
    String type = parameter.get("BOARD_TYPE").toString().toLowerCase();
    
    ModelAndView mv = new ModelAndView("page/board/"+type+"_view");
    
    try {
      service.update("updateHits", parameter);
      Map<String, Object> boardMap = (Map<String, Object>) service.map("getBoard", parameter);
      boardMap.put("BOARD_CONTENT", ParameterUtil.reverseCleanXSS((String) boardMap.get("BOARD_CONTENT")));
      
      parameter.put("UP_BOARD_SEQ", boardMap.get("BOARD_SEQ"));
      List<Map<String, Object>> replyList = (List<Map<String, Object>>) service.list("getReply", parameter);
      
      parameter.put("FILE_CD", boardMap.get("IMG_FILE_CD"));
      List<Map<String, Object>> imgFileList = (List<Map<String, Object>>) service.list("common", "getFileList", parameter);
      
      mv.addObject("BOARD", boardMap);
      mv.addObject("REPLY_LIST", replyList);
      mv.addObject("IMG_FILE_LIST", imgFileList);
	} catch (Exception e) {
	  logger.error(e.getMessage());
	}
    
    return mv;
  }
  
  @GetMapping(value="/qna_writing")
  public ModelAndView qna_writing(HttpServletRequest request) throws Exception {
    ModelAndView mv = new ModelAndView("popup/page/board/popup/qna_writing");
    mv.addObject("layout", "popup");
    return mv;
  }
  
  @GetMapping(value="/qna_replying")
  public ModelAndView qna_replying(HttpServletRequest request) throws Exception {
	 ModelAndView mv = new ModelAndView("popup/page/board/popup/qna_replying");
	 mv.addObject("layout", "popup");
	 return mv;
  }
  
  @PostMapping(value="/save", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map<String, Object> save(HttpServletRequest request) throws Exception {
    Map<String, Object> parameter = ParameterUtil.getMultipartParameterMap(request);
    Map<String, Object> resultMap = new HashMap<>();
    
    try {
      resultMap = service.save(parameter);
    } catch (Exception e) {
      resultMap.put("result", "N");
      logger.error(e.getMessage());
    }
    return resultMap;
  }
}
