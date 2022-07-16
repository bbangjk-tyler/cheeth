package com.cheeth;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Gmail extends Authenticator{
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		//return new PasswordAuthentication("hyun2daum@gmail.com", "ehdgus8282");
		//return new PasswordAuthentication("hyun2daum@gmail.com", "rytnzhkriowdbpbg");
		//qljkbznixhzkowgw
		return new PasswordAuthentication("hyun2daum@gmail.com", "qljkbznixhzkowgw");
	}
}