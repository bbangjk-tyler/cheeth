package com.cheeth.comUtils;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.util.ObjectUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.ContentCachingRequestWrapper;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class ParameterUtil {
  
  public static Map<String, Object> getParameterMap(HttpServletRequest request) throws Exception {

    Map<String, Object> rtnMap = new HashMap<>();

    final ObjectMapper objectMapper = new ObjectMapper();
    final ContentCachingRequestWrapper requestWrapper = (ContentCachingRequestWrapper) request;

    JsonNode jsonNode = objectMapper.readTree(requestWrapper.getContentAsByteArray());

    ObjectMapper mapper = new ObjectMapper();
    Map<String, Object> result = mapper.convertValue(jsonNode, new TypeReference<Map<String, Object>>() {});
    if(result != null && result.size() > 0) {
      result = (Map<String, Object>) cleanXSS(result);
      rtnMap.putAll(result);
    }

    String key = "";
    Enumeration<?> obj = request.getParameterNames();
    while(obj.hasMoreElements()) {
      key = (String) obj.nextElement();
      if(!ObjectUtils.isEmpty(request.getParameter(key))) {
        rtnMap.put(key, cleanXSS(request.getParameter(key)));
      }
    }

    // 첨부파일
    if(request instanceof MultipartHttpServletRequest) {
      Iterator<String> itr = ((MultipartHttpServletRequest) request).getFileNames();
      while(itr.hasNext()) {
        String uploadFileName = itr.next();
        List<MultipartFile> fileList = ((MultipartHttpServletRequest) request).getFiles(uploadFileName);
        rtnMap.put(uploadFileName, fileList);
      }
    }

    String ipAddress = CommonUtil.getIpAddress(request);
    String userId = "";

    HttpSession session = request.getSession();
    if(session != null && session.getAttribute("sessionInfo") != null) {
      Map<?, ?> sessionInfo = (Map<?, ?>) session.getAttribute("sessionInfo");
      Map<?, ?> user = (Map<?, ?>) sessionInfo.get("user");
      userId = ObjectUtils.isEmpty(user.get("USER_ID")) ? "" : user.get("USER_ID").toString();
    }

    rtnMap.put("CREATE_ID", userId);
    rtnMap.put("UPDATE_ID", userId);
    
    if(ObjectUtils.isEmpty(rtnMap.get("USER_ID"))) { // 화면에서 USER_ID가 넘어온 경우가 있기 때문 예외처리
      rtnMap.put("USER_ID", userId);
    }

    return rtnMap;
  }
  
  public static Map<String, Object> getMultipartParameterMap(HttpServletRequest request) throws Exception {

    Map<String, Object> rtnMap = new HashMap<>();
    String key = "";
    Enumeration<?> enumer = request.getParameterNames();
    while(enumer.hasMoreElements()) {
      key = (String) enumer.nextElement();
      if (!ObjectUtils.isEmpty(request.getParameter(key))) {
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(request.getParameter(key));
        if(obj instanceof List || obj instanceof Map) {
          if(obj instanceof List) {
            JSONArray jsonArr = (JSONArray) obj;
            rtnMap.put(key, cleanXSS(jsonArr));
          } else if(obj instanceof Map) {
            JSONObject jsonObj = (JSONObject) obj;
            rtnMap.put(key, cleanXSS(jsonObj));
          }
        } else {
          rtnMap.put(key, cleanXSS(obj));
        }
      }
    }
    
    // 첨부파일
    if(request instanceof MultipartHttpServletRequest) {
      Iterator<String> itr = ((MultipartHttpServletRequest) request).getFileNames();
      while(itr.hasNext()) {
        String uploadFileName = itr.next();
        List<MultipartFile> fileList = ((MultipartHttpServletRequest) request).getFiles(uploadFileName);
        rtnMap.put(uploadFileName, fileList);
      }
    }

    String ipAddress = CommonUtil.getIpAddress(request);
    String userId = "";

    HttpSession session = request.getSession();
    if(session != null && session.getAttribute("sessionInfo") != null) {
      Map<?, ?> sessionInfo = (Map<?, ?>) session.getAttribute("sessionInfo");
      Map<?, ?> user = (Map<?, ?>) sessionInfo.get("user");
      userId = ObjectUtils.isEmpty(user.get("USER_ID")) ? "" : user.get("USER_ID").toString();
    }

    rtnMap.put("CREATE_ID", userId);
    rtnMap.put("UPDATE_ID", userId);
    
    if(ObjectUtils.isEmpty(rtnMap.get("USER_ID"))) { // 화면에서 USER_ID가 넘어온 경우가 있기 때문 예외처리
      rtnMap.put("USER_ID", userId);
    }

    return rtnMap;
  }
  

  public static Object cleanXSS(Object object) {
    
    if(object instanceof List || object instanceof Map) {
      if(object instanceof List) {
        List<Object> resultList = new ArrayList<Object>();
        for(int i=0; i<((List<?>)object).size(); i++) {
          Object obj = cleanXSS(((List<?>)object).get(i));
          if(obj != null) {
            resultList.add(i, obj);
          }
        }
        object = resultList;
      } else if(object instanceof Map) {
        for(Map.Entry<String, Object> entry:((Map<String, Object>) object).entrySet()) {
          entry.setValue(cleanXSS(entry.getValue()));
        }
      }
      return object;
    } else {
      String value = castToString(object);
      if(!ObjectUtils.isEmpty(value)) {
        value = value.replaceAll("\\<", "&#60;");
        value = value.replaceAll("\\>", "&#62;");
        value = value.replaceAll("\\(", "&#40;");
        value = value.replaceAll("\\)", "&#41;");
        value = value.replaceAll("\\[", "&#91;");
        value = value.replaceAll("\\]", "&#93;");
        value = value.replaceAll("\\/", "&#47;");
        value = value.replaceAll("\\$", "&#36;");
        value = value.replaceAll("\"", "&#34;");
        value = value.replaceAll("\'", "&#39;");
      }
      return value;
    }
  }

  public static String reverseCleanXSS(String value) {
    if(!ObjectUtils.isEmpty(value)) {
      value = value.replaceAll("&#60;", "\\<");
      value = value.replaceAll("&#62;", "\\>");
      value = value.replaceAll("&#40;", "\\(");
      value = value.replaceAll("&#41;", "\\)");
      value = value.replaceAll("&#91;", "\\[");
      value = value.replaceAll("&#93;", "\\]");
      value = value.replaceAll("&#47;", "\\/");
      value = value.replaceAll("&#36;", "\\$");
      value = value.replaceAll("&#34;", "\"");
      value = value.replaceAll("&#39;", "\'");
    }
    return value;
  }

  private static String castToString(Object obj) {
    String str = "";
    if(obj != null) {
      if (obj instanceof List) {
        str = ((List) obj).toString();
      } else if (obj instanceof Map) {
        str = ((Map) obj).toString();
      } else if (obj instanceof Integer) {
        str = Integer.toString((Integer) obj);
      } else if (obj instanceof Float) {
        str = Float.toString((Float) obj);
      } else if (obj instanceof Double) {
        str = Double.toString((Double) obj);
      } else if (obj instanceof BigDecimal) {
        str = ((BigDecimal) obj).toString();
      } else if (obj instanceof Boolean) {
        str = Boolean.toString((Boolean) obj);
      } else if (obj instanceof Long) {
        str = Long.toString((Long) obj);
      } else if (obj instanceof String) {
        str = (String) obj;
      } else {
        str = "";
      }
    }
    return str;
  }

}
