package org.com.controller;

import java.util.Date;

import javax.inject.Inject;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.com.service.MemberService;
import org.com.vo.MemberVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.WebUtils;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/member")
public class LoginController {

	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
	private static final String LOGIN = "login";

	@Inject
	private MemberService service;
	
	
	@GetMapping("/login")
	public void loginGET(@ModelAttribute("dto") MemberVO dto){
		logger.info("Login Get!!!!!!!!");
	}
	
	@GetMapping("/register")
	public void registerGET(@ModelAttribute("dto") MemberVO dto){
		logger.info("register Get!!!!!!!!");
	}
	
	@GetMapping("/registerPost")
	public void registerPOSTT(@ModelAttribute("dto") MemberVO dto){
		logger.info("register Post!!!!!!!!");
		service.register(dto);
		
	}
	
	@PostMapping("/loginPost")
	public void loginPOST(MemberVO dto,HttpSession session, Model model) throws Exception{
		
		logger.info("==============================================================================");
		logger.info("Login Post !!!!!!!!");
		logger.info(dto.toString());
		
		MemberVO vo = service.login(dto);
		
		if(vo == null){
			return;
		}
		
		model.addAttribute("memberVO", vo);
		
		if(dto.isUseCookie()){
			
			int amount = 60*60*24*7;			
			Date sessionLimit = new Date(System.currentTimeMillis()+(1000*amount));
			service.keepLogin(vo.getMemberId(), session.getId(), sessionLimit);
			
		}
		
	}
	
	@GetMapping("/logout")
	public String logoutGet(HttpSession session, RedirectAttributes rttr, HttpServletRequest request, HttpServletResponse response ){
		
		logger.info("logout ......");
		
		Object obj = session.getAttribute(LOGIN);
		
		if (obj != null) {
			MemberVO vo = (MemberVO) obj;
			session.removeAttribute(LOGIN);
			session.invalidate();
			Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");			
			
			if (loginCookie !=null) {
				
				loginCookie.setPath("/");
				loginCookie.setMaxAge(0);
				response.addCookie(loginCookie);
				service.keepLogin(vo.getMemberId(), session.getId(), new Date());
			}
			rttr.addFlashAttribute("logoutmsg","success");
		}
		return "redirect:login";
		
	}
	
}
