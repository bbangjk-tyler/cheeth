package com.cheeth.comUtils.file;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.tika.Tika;
import org.springframework.stereotype.Component;
import org.springframework.util.ObjectUtils;
import org.springframework.web.multipart.MultipartFile;

import com.cheeth.comUtils.ParameterUtil;

@Component
public class FileUtil {
  
  private String ognFileNm; // 원본파일명
  private String saveFileNm; // 저장파일명
  private String fileSaveUrl; // 파일저장URL
  private String fileExteNm; // 파일 확장자명
  private String fileLngt; // 파일 사이즈
  private String IdNum;
  
  public String getOgnFileNmCleanXSS(String fileNm){
    return (String) ParameterUtil.cleanXSS(fileNm);
  }

  public String getOgnFileNmReverseCleanXSS(String fileNm) {
    return (String) ParameterUtil.reverseCleanXSS(fileNm);
  }

  public String getOgnFileNm() {
    return ognFileNm;
  }

  public String getSaveFileNm() {
    return saveFileNm + IdNum + "." + fileExteNm(getOgnFileNm());
  }

  public String getFileSaveUrl() {
    return fileSaveUrl;
  }

  public String getFileExteNm() {
    return fileExteNm;
  }

  public String getFileLngt() {
    return fileLngt;
  }

  public String getIdNum() {
    return IdNum;
  }
  
  public void setFileSaveUrl(String busiDivCd) {
    this.fileSaveUrl = makeUrl(busiDivCd);
  }
  
  public void setFileSaveUrlDirect(String busiDivCd, String path, Map<String, Object> file) {
    String urlPath = busiDivCd + File.separator + path + File.separator + file.get("FILE_NM");
    file.put("FILE_DIRECTORY", urlPath);
  }
  
  public void setIdNum(String idNum) {
    this.IdNum = idNum.substring(idNum.length()-11, idNum.length());    //id 뒤에서 11자리
  }

  public String createFileCd() {
    String randomKey = "";
    DateFormat format = new SimpleDateFormat("YYYYMMddHHmmss", Locale.KOREA);
    randomKey = format.format(Calendar.getInstance().getTime());
    randomKey += commonRpad(Integer.toString((int)((Math.random()*999)+1)), 4, "0");
    return randomKey;
  }
  
  public String commonRpad(String s, int padLength, String padString) {
    while(s.length() < padLength) {
      s += padString;
    }
    return s;
  }
  
  public String saveFileName() {
    Timestamp ts = new Timestamp(System.currentTimeMillis());
    SimpleDateFormat sdf = new SimpleDateFormat("YYYYMMddHHmmssSSS", Locale.KOREA);
    return sdf.format(new Date(ts.getTime()));
  }
  
  public String fileExteNm(String fileNm) {
    Integer idx = fileNm.lastIndexOf(".");
    if (idx != -1) {
      fileExteNm = fileNm.substring(idx + 1);
    }
    return fileExteNm;
  }
  
  private void setFileInfo(MultipartFile multipartFile) {
    ognFileNm = multipartFile.getOriginalFilename();
    saveFileNm = saveFileName();
    fileExteNm = fileExteNm(ognFileNm);
    fileLngt = Long.toString(multipartFile.getSize());
  }
  
  public List<Map<String, Object>> getMultiPartFileInfo(List<MultipartFile> multipartFiles, String divCd) throws Exception {
    
    List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    Integer idx = 1;
    String saveUrl = "";
    String fileCd = createFileCd();
    
    for(MultipartFile multipartFile : multipartFiles) {
      if(ObjectUtils.isEmpty(multipartFile.getOriginalFilename())) continue; 
      
      Map<String, Object> map = new HashMap<>();
      setFileInfo(multipartFile);
      saveFileNm = saveFileNm + idx;
      saveUrl = divCd + File.separator + saveFileNm + "." + getFileExteNm();
      saveUrl = makeUrl(divCd) + saveFileNm + "." + getFileExteNm();

      map.put("FILE_NO", idx++);
      map.put("FILE_CD", fileCd);
      map.put("FILE_DIV", divCd);
      map.put("FILE_NM", saveFileNm + "." + getFileExteNm());
      map.put("FILE_DIRECTORY", saveUrl);
      map.put("FILE_ORIGIN_NM", getOgnFileNm());
      map.put("FILE_SIZE", getFileLngt());
      map.put("FILE_TYPE", getFileExteNm());
      list.add(map);
    }
    return list;
  }
  
  public String makeUrl(String busiDivCd) {
    LocalDate date = LocalDate.now();
    String sYear  = date.format(DateTimeFormatter.ofPattern("YYYY"));
    String sMonth = date.format(DateTimeFormatter.ofPattern("MM"));
    String sDate  = date.format(DateTimeFormatter.ofPattern("dd"));

    String urlPath = busiDivCd + File.separator + sYear + File.separator + sMonth + File.separator + sDate + File.separator;

    return urlPath;
  }
  
  public void saveMultiPartFileBack(MultipartFile multipartFile, Map<String, Object> map, String rootPath) throws Exception {
    String saveUrl = rootPath + (String)map.get("FILE_DIRECTORY");
    String folder = saveUrl.substring(0, saveUrl.lastIndexOf(File.separator));
    makeDirectory(folder);
    save(saveUrl, multipartFile);
  }
  
  public void save(String path, MultipartFile multipartFile) throws IOException {
    OutputStream os = null;
    try {
      os = new FileOutputStream(path);
      os.write(multipartFile.getBytes());
    } finally {
      if(os != null) {
        os.close();
      }
    }
  }
  
  public void makeDirectory(String path) {
    File dir = new File(path);
    if(!dir.exists()) {
      dir.mkdirs();
    }
  }
  
  public void deleteFile(String path) throws Exception {
    File file = new File(path);
    if (file.exists()) {
      file.delete();
    }
  }
  
  public boolean imgMimeTypeChk(MultipartFile[] multipartFiles) throws Exception {
    List<String> mimeTypeList = Arrays.asList("image/png", "image/jpeg", "image/gif", "image/bmp");
    for(MultipartFile file : multipartFiles) {
      String mimeType = new Tika().detect(file.getInputStream());
      if(!mimeTypeList.contains(mimeType)) return false;
    }
    return true;
  }
  
  public boolean mimeTypeChk(MultipartFile[] multipartFiles) throws Exception {
    
    List<String> mimeTypeList = Arrays.asList(
      "application/x-tika-msoffice",
      "application/msword",
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      "application/vnd.ms-excel",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "application/vnd.ms-powerpoint",
      "application/vnd.openxmlformats-officedocument.presentationml.presentation",
      "application/vnd.hancom.*",
      "application/x-hwp",
      "application/haansofthwp",
      "application/vnd.hancom.hwp",
      "application/hwp+zip",
      "application/vnd.hancom.hwpx",
      "application/haansofthwp",
      "application/pdf",
      "application/x-tika-ooxml",
      "application/vnd.oasis.opendocument.text",
      "application/vnd.oasis.opendocument.spreadsheet",
      "application/vnd.oasis.opendocument.presentation",
      "application/vnd.oasis.opendocument.graphics",
      "application/vnd.oasis.opendocument.formula",
      "application/zip",
      "application/x-zip-compressed",
      "text/plain",
      "text/html",
      "image/png",
      "image/jpeg",
      "image/gif",
      "image/bmp");
    
    for(MultipartFile file : multipartFiles) {
      String mimeType = new Tika().detect(file.getInputStream());
      if(!mimeTypeList.contains(mimeType)) return false;
    }
    
    return true;
  }
}
