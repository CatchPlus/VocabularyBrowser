package vocrep.service;

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
import java.net.URL;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

@Service
public class VocRepUtils{

	/**
	 * Retrieves content from an URI and builds a document
	 * @param uri
	 * @return Document
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 * @throws IOException
	 */
	public static Document GetXMLDocumentForURI(URL uri)
			throws ParserConfigurationException, SAXException, IOException {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();

		return builder.parse(new InputSource(new StringReader(ReadXML(uri))));
	}
	
	/**
	 * Gets the outerXML from a Node
	 * @param node
	 * @return String - the outer XML
	 * @throws TransformerConfigurationException
	 * @throws TransformerException
	 */
	public static String GetOuterXml(Node node)
			throws TransformerConfigurationException, TransformerException {
		Transformer transformer = TransformerFactory.newInstance()
				.newTransformer();
		transformer.setOutputProperty("omit-xml-declaration", "yes");
		StringWriter writer = new StringWriter();
		transformer.transform(new DOMSource(node), new StreamResult(writer));
		return writer.toString();
	}

	/**
	 * Connects to a dataprovider based on an URI and retrieves data
	 * @param url
	 * @return String - data from URI
	 * @throws IOException
	 */
	private static String ReadXML(URL url) throws IOException {
		Writer buffer = new StringWriter();
		BufferedReader in = new BufferedReader(new InputStreamReader(url
				.openConnection().getInputStream(), Charset.forName("UTF-8")));
		String inputLine;
		while ((inputLine = in.readLine()) != null)
			buffer.append(inputLine);

		in.close();

		return buffer.toString();
	}


	private static String convertToHex(byte[] data) {
		StringBuffer buf = new StringBuffer();
		for (int i = 0; i < data.length; i++) {
			int halfbyte = (data[i] >>> 4) & 0x0F;
			int two_halfs = 0;
			do {
				if ((0 <= halfbyte) && (halfbyte <= 9))
					buf.append((char) ('0' + halfbyte));
				else
					buf.append((char) ('a' + (halfbyte - 10)));
				halfbyte = data[i] & 0x0F;
			} while (two_halfs++ < 1);
		}
		return buf.toString();
	}

	public static String EncryptPasswordAsSHA1(String text) throws NoSuchAlgorithmException,
			UnsupportedEncodingException {
		MessageDigest md;
		md = MessageDigest.getInstance("SHA-1");
		byte[] sha1hash = new byte[40];
		md.update(text.getBytes("iso-8859-1"), 0, text.length());
		sha1hash = md.digest();
		return convertToHex(sha1hash);
	}
	
	/**
	 * Enrich the XML used by the parser with some filtering details from an filterlist(File)
	 * @param file
	 * @param buffer
	 * @return StringBuffer - the enriched buffer
	 * @throws IOException
	 */
	public static StringBuffer applySchemeFilters(File file, StringBuffer buffer) throws IOException {
	    FileInputStream fstream = new FileInputStream(file);	    
	    DataInputStream in = new DataInputStream(fstream);
	    BufferedReader br = new BufferedReader(new InputStreamReader(in));
	    String strLine;
	    while ((strLine = br.readLine()) != null)   {	      
	    	buffer.append(strLine);
	    }	    
	    in.close();	
	    
	    return buffer;
	}

}
