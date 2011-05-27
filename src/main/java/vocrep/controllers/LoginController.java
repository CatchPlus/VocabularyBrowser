package vocrep.controllers;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import vocrep.service.VocRepUtils;

@Controller
public class LoginController{
	
	@Value(value="#{appProperties.password}")
	private String systemPass;
	
	@RequestMapping(value = "/login.do", method = RequestMethod.POST)
	public String home(ModelMap modelMap, HttpServletRequest request, String password) throws NoSuchAlgorithmException, UnsupportedEncodingException {
		if (systemPass.equals(VocRepUtils.EncryptPasswordAsSHA1(password))){
			request.getSession().setAttribute("loggedon", true);
		}
		modelMap.addAttribute("loggedon", request.getSession().getAttribute("loggedon"));
		return "home";
	}
	
}
