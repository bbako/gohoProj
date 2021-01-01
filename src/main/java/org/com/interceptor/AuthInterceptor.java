package org.com.interceptor;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.com.service.MemberService;
import org.com.vo.MemberVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.WebUtils;

public class AuthInterceptor extends HandlerInterceptorAdapter {

	private static final Logger logger = LoggerFactory.getLogger(AuthInterceptor.class);
	
	@Autowired
	private MemberService service;

	private void saveDest(HttpServletRequest req) {
		String uri = req.getRequestURI();

		String query = req.getQueryString();

		if (query == null || query.equals("null")) {
			query = "";
		} else {
			query = "?" + query;
		}

		if (req.getMethod().equals("GET")) {
			req.getSession().setAttribute("dest", uri + query);
		}
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		logger.info("Auth Interceptor !!!!");

		HttpSession session = request.getSession();

		if (session.getAttribute("login") == null) {

			logger.info("current user is not logined");

			saveDest(request);

			Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
			
			if (loginCookie != null) {
				MemberVO memberVO = service.checkSessionKey(loginCookie.getValue());

				if (memberVO != null) {
					session.setAttribute("login", memberVO);
					return true;
				}

			}

			response.sendRedirect("/member/login");

			return false;

		}

		return true;
	}

}
