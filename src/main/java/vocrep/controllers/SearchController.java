package vocrep.controllers;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
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
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPathExpressionException;

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
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import vocrep.service.ICacheAPI;
import vocrep.service.ICatchAPI;
import vocrep.service.VocRepUtils;

@SuppressWarnings("unused")
@Controller
public class SearchController{
	
	@Autowired ServletContext servletContext;
	@Autowired ICatchAPI iCatchAPI;	
	@Autowired ICacheAPI iCacheAPI;
	
	@Value(value="#{appProperties.pathtofilterschemes}")
	private String pathToFilterSchemes;	
	
	@RequestMapping(value = "/search.do", method = RequestMethod.GET)
	public void search(ModelMap modelMap, HttpServletRequest request, HttpServletResponse response) throws TransformerFactoryConfigurationError, TransformerException, MalformedURLException, IOException, ServletRequestBindingException, ParserConfigurationException, SAXException, XPathExpressionException {
		
		String query = ServletRequestUtils.getStringParameter(request, "query");
		String match = ServletRequestUtils.getStringParameter(request, "match");
		if (match == null)
			match = "";
		
		String label = ServletRequestUtils.getStringParameter(request, "label");
		String lang = ServletRequestUtils.getStringParameter(request, "taal");
		String group = ServletRequestUtils.getStringParameter(request, "group");
		boolean loggedon = request.getSession().getAttribute("loggedon") == null ? false : (Boolean)request.getSession().getAttribute("loggedon");
		
		Writer buffer = new StringWriter();
		Document doc = null;
		File file = new File(servletContext.getRealPath("/WEB-INF/xsl/search.xslt"));
		Transformer transformer = TransformerFactory.newInstance().newTransformer(new StreamSource(file));
		
		URL searchUrl = null;
		
		if(query != null && match != null && label != null && lang != null && group != null)
		{
			searchUrl = getSeacrhConceptUrl(query, match, label, lang, group);
			
			transformer.setParameter("loggedon", loggedon);
			
			transformer.setParameter("lang", lang);
			transformer.setParameter("query", query);
			transformer.setParameter("match", match);
			transformer.setParameter("label", label);
			transformer.setParameter("group", group);
		}	
		doc = BuildContent(searchUrl, loggedon);
		
		transformer.setOutputProperty(OutputKeys.INDENT, "yes");
		transformer.setOutputProperty(OutputKeys.ENCODING, "ISO-8859-1");
		
	
		transformer.transform(new DOMSource(doc),new StreamResult(buffer));
		response.setContentType("text/html");
		response.getWriter().write(buffer.toString());
	}
	
	// TODO: Je kan alleen zoeken met een regex wanneer ook een schema (in dit geval group) bekend is.
	// Dit moet of hier of op de frontend opgevangen worden en duidelijk worden gemaakt naar de gebruiker
	private URL getSeacrhConceptUrl(String query, String match, String label, String lang, String group) throws MalformedURLException, UnsupportedEncodingException {
		if(group.isEmpty())
			return iCatchAPI.getFreeSearchUri(query, match, label, lang);
		else
			return iCatchAPI.getSearchConceptsUri(query, match, label, lang, group);		
	}	
	
	private Document BuildContent(URL uri, boolean isLoggedOn) throws IOException, SAXException, ParserConfigurationException, TransformerConfigurationException, TransformerException {		
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();  
        File filters = new File(pathToFilterSchemes+"filterschemes.xml");
		
		StringBuffer buffer = new StringBuffer();		
		
		if(uri != null)
			buffer.append("<concepts>"+VocRepUtils.GetOuterXml(VocRepUtils.GetXMLDocumentForURI(uri).getDocumentElement())+"</concepts>");								
		
		// groupschema's willen we altijd hebben
		Document schemes = iCacheAPI.GetSchemeCache();
		if(schemes == null)
		{
			schemes = getAllSchemes();			
			iCacheAPI.CacheDocument(schemes);
		}
		buffer.append(VocRepUtils.GetOuterXml(schemes));
		//only apply filtering when not logged on
		if (filters.exists())
			buffer = VocRepUtils.applySchemeFilters(filters, buffer);
		
		Document document = builder.parse(new InputSource(new StringReader("<search>"+ buffer.toString()+"</search>")));
		return document;
	}
	
	private Document getAllSchemes() throws MalformedURLException, ParserConfigurationException, SAXException, IOException, TransformerConfigurationException, TransformerException
	{
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
		
        StringBuffer buffer = new StringBuffer();		
        
		for(Node childNode = VocRepUtils.GetXMLDocumentForURI(iCatchAPI.getAllConceptschemeGroups()).getDocumentElement().getFirstChild(); childNode!=null;){
			Node nextChild = childNode.getNextSibling();
			//we slaan het eerste kindje over (statuscode)
			childNode = nextChild;
			
			//String uri = childNode.getFirstChild().getNodeValue();
			String uri = getUriURL(VocRepUtils.GetOuterXml(childNode));
			if(uri != "")
			{
				Document groupSchemes = VocRepUtils.GetXMLDocumentForURI(iCatchAPI.getAllConceptschemes(uri));
				buffer.append("<group>"+VocRepUtils.GetOuterXml(childNode)+"<schemes>"+VocRepUtils.GetOuterXml(groupSchemes)+"</schemes></group>");
			}		
		}
		
		Document document = builder.parse(new InputSource(new StringReader("<groups>"+buffer.toString()+"</groups>")));
		return document;
	}	
	
	//TODO: Please refactor
	private String getUriURL(String node)
	{
		String[] buf = node.split("<uri>");
		if(buf.length < 2)
			return "";
		return buf[1].split("</uri>")[0];
	}	
}
