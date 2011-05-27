package vocrep.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactoryConfigurationError;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController{
	
	@RequestMapping(value = "/index.html", method = RequestMethod.GET)
	public String home(ModelMap modelMap, HttpServletRequest request) throws TransformerFactoryConfigurationError, TransformerException {
		modelMap.addAttribute("loggedon", request.getSession().getAttribute("loggedon"));
		return "home";
	}
	
}
