package org.com.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.text.DateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String main(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);

		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);

		String formattedDate = dateFormat.format(date);

		model.addAttribute("serverTime", formattedDate);

		return "home";
	}
	
	@GetMapping("/home")
	public void home(Locale locale, Model model) {
	}
	
// socket 통신
	@RequestMapping(value = "/getMp3.do", method = RequestMethod.POST)
	public HttpEntity<byte[]> getMp3(@RequestParam HashMap<String, String> paramMap, Model model) {
		
		String r_file_nm = (String) paramMap.get("r_file_nm");
		String srcPath = "temp/"; 
		String url = "WorkCode=0001&amp;FileNm=" + r_file_nm + "&amp;dstPath=";
		
		Socket clientSocket = null;
		OutputStream os = null;
		InputStream is = null;
		FileInputStream fi = null;
		
		HttpHeaders header = new HttpHeaders();
		
		byte[] f = null;
		
		try {
			clientSocket = new Socket(); 
			clientSocket.connect(new InetSocketAddress("130.1.56.81", 2000), 5000);
		
			os = clientSocket.getOutputStream(); 
			is = clientSocket.getInputStream();
			
			os.write(url.getBytes()); 
			os.flush();
			
			int resultSize = 0; 
			byte[] msgByte = new byte[1024];
			String readData = "";
			
			do {
				resultSize = is.read(msgByte);
				readData += new String(msgByte); 
			} while (resultSize >= 1024);
			
			File srcFile = new File(srcPath + "/" + r_file_nm + ".mp3");
			
			if (readData.indexOf("200") != -1 && readData.indexOf("SUCCESS") != -1 && srcFile.exists() == true){
				fi = new FileInputStream(srcFile); 
				f = IOUtils.toByteArray(fi);

				header.set("Accept-Ranges", "bytes"); 
				header.set("Content-Range", "bytes " + 0 + "-" + f.length + "/" + f.length);
				header.setContentType(new MediaType("audio", "mpeg"));
				header.setContentLength(f.length);

				srcFile.delete();
			}

		} catch (Exception e) {
			e.printStackTrace(); 
		} finally {
			try {
				if(fi != null){
					fi.close();
					fi = null;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			try { 
				if (os != null) {
					os.close();
					os = null;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			try { 
				if (is != null) {
					is.close(); 
					is = null;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				if (clientSocket != null) {
					clientSocket.close(); 
					clientSocket = null;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return new HttpEntity<byte[]>(f, header);
	}
}
