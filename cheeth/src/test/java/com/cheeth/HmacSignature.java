package com.cheeth;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;

import javax.crypto.*;
import javax.crypto.spec.SecretKeySpec;
import org.apache.*;
/*import org.apache.tomcat.util.codec.binary.Base64;
import org.apache.tomcat.util.codec.binary.StringUtils;*/
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.StringUtils;

public class HmacSignature {
	public HmacSignature() {}
	public String makeSignature(long timestamp) throws UnsupportedEncodingException, NoSuchAlgorithmException, InvalidKeyException {
		String space = " ";					// one space
		String newLine = "\n";					// new line
		String method = "POST";					// method
		String url = "/sms/v2/services/ncp:sms:kr:259927151930:nineupsoft/messages";
//		long timestamp = System.currentTimeMillis();			// current timestamp (epoch)
		String accessKey = "K5dOTFHtEjtQPEOq1OPT";			// access key id (from portal or Sub Account)
		String secretKey = "UDpaPbjSKGMXFfWdT9I0mX2xkOFMn6cMOblm47G2";

		String message = new StringBuilder()
			.append(method)
			.append(space)
			.append(url)
			.append(newLine)
			.append(Long.toString(timestamp))
			.append(newLine)
			.append(accessKey)
			.toString();
		System.out.println(message);

		SecretKeySpec signingKey = new SecretKeySpec(secretKey.getBytes("UTF-8"), "HmacSHA256");
		Mac mac = Mac.getInstance("HmacSHA256");
		mac.init(signingKey);

		byte[] rawHmac = mac.doFinal(message.getBytes("UTF-8"));
		String encodeBase64String = Base64.encodeBase64String(rawHmac);
		System.out.println("End :: " + encodeBase64String);
		
		return encodeBase64String;
	}
}
