package com.cheeth.comUtils.session;

import java.util.ArrayList;
import java.util.List;

public class ExclusionUrl {
  
  public List<String> getSessionUrlList(final String api) {
    
    StringBuilder hostUrl = new StringBuilder();
    hostUrl.append("/");
    hostUrl.append(api);
    
    List<String> urlList = new ArrayList<String>();
    urlList.add(hostUrl.toString() + "/login/sso");
    
    return urlList;
  }
  
  public List<String> getAuthUrlList(final String api) {
    
    StringBuilder hostUrl = new StringBuilder();
    hostUrl.append("/");
    hostUrl.append(api);

    List<String> urlList = new ArrayList<String>();
    
    urlList.add(hostUrl.toString() + "/login/getMenuInfo");
    
    return urlList;
  }

}
