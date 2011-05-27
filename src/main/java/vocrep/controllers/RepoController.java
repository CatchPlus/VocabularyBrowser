package vocrep.controllers;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.MalformedURLException;
import java.net.URL;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import vocrep.service.ICatchAPI;
import vocrep.service.VocRepUtils;

@Controller
public class RepoController{
	
	@Autowired ServletContext servletContext;
	@Autowired ICatchAPI iCatchAPI;	
	
	@Value(value="#{appProperties.pathtofilterschemes}")
	private String pathToFilterSchemes;	

	@RequestMapping(value = "/repo.do", method = RequestMethod.GET)
	public void home(ModelMap modelMap, HttpServletRequest request, HttpServletResponse response) throws TransformerFactoryConfigurationError, TransformerException, MalformedURLException, IOException, ServletRequestBindingException, ParserConfigurationException, SAXException {
		
		int level = ServletRequestUtils.getIntParameter(request, "level");
		String uri = ServletRequestUtils.getStringParameter(request, "uri");
		String letter = ServletRequestUtils.getStringParameter(request, "letter");
		String highlight = ServletRequestUtils.getStringParameter(request, "highlight");
		URL catchResourceUrl = getCatchResourceUrl(level, uri, letter);	
		boolean loggedon = request.getSession().getAttribute("loggedon") == null ? false : (Boolean)request.getSession().getAttribute("loggedon");
		
		@SuppressWarnings("unused")
		Source xml = new StreamSource(catchResourceUrl.openConnection().getInputStream());
		Writer buffer = new StringWriter();
			
		//@SuppressWarnings("unused")
		Document doc = buildContent(catchResourceUrl, iCatchAPI.getLhsAlignment(uri), iCatchAPI.getRhsAlignment(uri), loggedon);
		File file = new File(servletContext.getRealPath("/WEB-INF/xsl/branch.xslt"));
		
		Transformer transformer = TransformerFactory.newInstance().newTransformer(new StreamSource(file));
		transformer.setParameter("loggedon", loggedon);
		transformer.setParameter("level", level);
		transformer.setParameter("nextlevel", level + 1);		
		transformer.setParameter("letter", letter == null ? "" : letter);		
		transformer.setParameter("highlight", highlight == null ? "" : highlight);
		transformer.setOutputProperty(OutputKeys.INDENT, "yes");
		transformer.setOutputProperty(OutputKeys.ENCODING, "ISO-8859-1");
		
		transformer.transform(new DOMSource(doc),new StreamResult(buffer));

		response.getWriter().write(buffer.toString());
	}	
	
	private URL getCatchResourceUrl(int level, String uri, String letter) throws MalformedURLException {
		if (level == 0){ return iCatchAPI.getAllConceptschemeGroups();}
		else if (level == 1){ return iCatchAPI.getAllConceptschemes(uri);}
		else if (level == 2){ return iCatchAPI.getConcepts(uri, letter);}
		else if (level > 2){ return iCatchAPI.getConceptRelations(uri);}
		return null;
	}
		
	private Document buildContent(URL uri, URL LAlignmentUrl, URL RAlignmentUrl, boolean isLoggedOn) throws IOException, SAXException, ParserConfigurationException, TransformerConfigurationException, TransformerException {	
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        File filters = new File(pathToFilterSchemes+"filterschemes.xml");
		StringBuffer buffer = new StringBuffer();
				
		buffer.append("<results>"+VocRepUtils.GetOuterXml(VocRepUtils.GetXMLDocumentForURI(uri).getDocumentElement())+"</results>");
		
		//only apply filtering when not logged on
		if (filters.exists())
			buffer = VocRepUtils.applySchemeFilters(filters, buffer);			
		
		if(!LAlignmentUrl.toString().isEmpty())
			buffer.append("<lalignment>"+VocRepUtils.GetOuterXml(VocRepUtils.GetXMLDocumentForURI(LAlignmentUrl).getDocumentElement())+"</lalignment>");
		if(!RAlignmentUrl.toString().isEmpty())
			buffer.append("<ralignment>"+VocRepUtils.GetOuterXml(VocRepUtils.GetXMLDocumentForURI(RAlignmentUrl).getDocumentElement())+"</ralignment>");
		
		Document document = builder.parse(new InputSource(new StringReader("<root>"+ buffer.toString()+"</root>")));
		return document;
	}
	
	@RequestMapping(value = "/csg.json", method = RequestMethod.GET)
	public void csg(HttpServletResponse response, String uri) throws IOException, TransformerConfigurationException, ParserConfigurationException, TransformerException, SAXException  {		
		
		try
		{
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	        DocumentBuilder builder = factory.newDocumentBuilder();
	
			StringBuffer buffer = new StringBuffer();
			buffer.append("<results>"+VocRepUtils.GetOuterXml(VocRepUtils.GetXMLDocumentForURI(iCatchAPI.findCSGbyCS(uri)).getDocumentElement())+"</results>");
			
			Document document = builder.parse(new InputSource(new StringReader("<root>"+ buffer.toString()+"</root>")));
			
			String csg  = document.getDocumentElement().getElementsByTagName("vameta:hasConceptScheme").item(0).getTextContent();
	
			response.getWriter().write("{csg:'" +csg+ "'}");
		}
		catch(Exception e)
		{
			String error = "{csg: null}";
			response.getWriter().write(error);
		}
	}
}