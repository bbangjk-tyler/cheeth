package com.cheeth.busiCpnt.file;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cheeth.comAbrt.controller.BaseController;

@RestController
@RequestMapping(value="${api.url}/file")
public class FileController extends BaseController {
  
  protected Logger logger = LogManager.getLogger(FileController.class);
  
  @Autowired
  private FileService fileService;
  
  @PostMapping(value="/download")
  public void download(HttpServletRequest request, HttpServletResponse response) throws Exception {
    fileService.download(request, response);
  }

}
