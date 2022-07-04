package com.cheeth.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.popbill.api.AccountCheckService;
import com.popbill.api.MessageService;
import com.popbill.api.accountcheck.AccountCheckServiceImp;
import com.popbill.api.message.MessageServiceImp;

@Configuration
public class PopBillConfig {
	
	@Value("${popbill.linkID}")
	private String linkID;
	@Value("${popbill.secretKey}")
	private String secretKey;
	@Value("${popbill.isTest}")
	private boolean isTest;
	@Value("${popbill.isIPRestrictOnOff}")
	private boolean isIPRestrictOnOff;
	@Value("${popbill.useStaticIP}")
	private boolean useStaticIP;
	@Value("${popbill.useLocalTimeYN}")
	private boolean useLocalTimeYN;
	
	@Bean(name="AccountCheckService")
	AccountCheckService accountCheckService(){
		
		AccountCheckServiceImp service = new AccountCheckServiceImp();
		service.setLinkID(linkID);
		service.setSecretKey(secretKey);
		service.setTest(isTest);
		service.setIPRestrictOnOff(isIPRestrictOnOff);
		service.setUseStaticIP(useStaticIP);
		service.setUseLocalTimeYN(useLocalTimeYN);
      	return service;
	}
	
	@Bean(name="MessageService")
	MessageService messageService(){
		
		MessageServiceImp service = new MessageServiceImp();
		service.setLinkID(linkID);
		service.setSecretKey(secretKey);
		service.setTest(isTest);
		service.setIPRestrictOnOff(isIPRestrictOnOff);
		service.setUseStaticIP(useStaticIP);
		service.setUseLocalTimeYN(useLocalTimeYN);
		return service;
	}
  
}
