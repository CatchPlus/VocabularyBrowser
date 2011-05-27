import java.io.IOException;
import java.io.UnsupportedEncodingException;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.AbstractDependencyInjectionSpringContextTests;
import org.xml.sax.SAXException;

import vocrep.controllers.RepoController;

public class TestJsonRepoController extends AbstractDependencyInjectionSpringContextTests {
	
	@Autowired RepoController repoController;
	
	@Override
	protected String[] getConfigLocations() {
		return new String[]{"classpath:applicationContextControllers.xml"};
	}

	public void testJson() throws TransformerConfigurationException, IOException, ParserConfigurationException, TransformerException, SAXException  {
		MockHttpServletRequest request = new MockHttpServletRequest();
		MockHttpServletResponse response = new MockHttpServletResponse();
		
		int lengthBefore = response.getContentAsString().length();
		
		request.setRequestURI("csg.json");
		request.setAttribute("uri", "blablabla");
				
		repoController.csg(response, "http://brinkman.kb.nl/btr/BrinkmanScheme");
		
		int lengthAfter = response.getContentAsString().length();
		
		
		assertTrue(lengthAfter > lengthBefore);
		System.out.println(response.getContentAsString());
		
		
	}
}
