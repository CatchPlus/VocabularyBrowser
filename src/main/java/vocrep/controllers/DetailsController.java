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
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import vocrep.service.ICatchAPI;
import vocrep.service.VocRepUtils;

@Controller
public class DetailsController {

	@Autowired ServletContext servletContext;
	@Autowired ICatchAPI iCatchAPI;

	@RequestMapping(value = "/c_details.do", method = RequestMethod.GET)
	public void home(ModelMap modelMap, HttpServletRequest request,
			HttpServletResponse response)
			throws TransformerFactoryConfigurationError, TransformerException,
			MalformedURLException, IOException, ServletRequestBindingException,
			SAXException, ParserConfigurationException {

		String uri = ServletRequestUtils.getStringParameter(request, "uri");
		String selectedScheme = ServletRequestUtils.getStringParameter(request, "selectedScheme");

		Writer buffer = new StringWriter();
		File file = new File(servletContext
				.getRealPath("/WEB-INF/xsl/c_details.xslt"));
		Transformer transformer = TransformerFactory.newInstance().newTransformer(new StreamSource(file));
		transformer.setOutputProperty(OutputKeys.INDENT, "yes");
		transformer.setOutputProperty(OutputKeys.ENCODING, "ISO-8859-1");
		transformer.transform(new DOMSource(getDetailsContent(uri, iCatchAPI.getLhsAlignment(selectedScheme), iCatchAPI.getRhsAlignment(selectedScheme))),new StreamResult(buffer));

		response.getWriter().write(buffer.toString());

	}

	private Document getDetailsContent(String uri, URL LAlignmentUrl, URL RAlignmentUrl) throws IOException, SAXException, ParserConfigurationException, TransformerConfigurationException, TransformerException {		
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();        
		StringBuffer buffer = new StringBuffer();
		buffer.append("<uri>"+uri+"</uri>");
		buffer.append("<labels>"+VocRepUtils.GetOuterXml(VocRepUtils.GetXMLDocumentForURI(iCatchAPI.getConceptDetails(uri)).getDocumentElement())+"</labels>");
		buffer.append("<relations>"+VocRepUtils.GetOuterXml(VocRepUtils.GetXMLDocumentForURI(iCatchAPI.getConceptRelations(uri)).getDocumentElement())+"</relations>");
		buffer.append("<scheme>"+VocRepUtils.GetOuterXml(VocRepUtils.GetXMLDocumentForURI(iCatchAPI.findConceptInScheme(uri)).getDocumentElement())+"</scheme>");
		
		if(!LAlignmentUrl.toString().isEmpty())
			buffer.append("<lalignment>"+VocRepUtils.GetOuterXml(VocRepUtils.GetXMLDocumentForURI(LAlignmentUrl).getDocumentElement())+"</lalignment>");
		if(!RAlignmentUrl.toString().isEmpty())
			buffer.append("<ralignment>"+VocRepUtils.GetOuterXml(VocRepUtils.GetXMLDocumentForURI(RAlignmentUrl).getDocumentElement())+"</ralignment>");
		
		Document document = builder.parse(new InputSource(new StringReader("<root>"+ buffer.toString()+"</root>")));
		return document;
	}
}
