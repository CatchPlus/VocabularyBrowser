import java.io.IOException;
import java.net.URL;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.AbstractDependencyInjectionSpringContextTests;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import vocrep.service.ICatchAPI;


public class TestConceptdetails extends AbstractDependencyInjectionSpringContextTests{
	
	@Autowired ICatchAPI iCatchAPI;
	
	@Override
	protected String[] getConfigLocations() {
		return new String[]{"classpath:applicationContext.xml"};
	}
	
	public void test() throws SAXException, IOException, ParserConfigurationException{		
		URL conceptDetails = iCatchAPI.getConceptDetails("http://www.boekbond.nl/nur/100-199");
		
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        
        Document document = builder.parse(conceptDetails.toString());		
        
        //let's view the result in the console
        printNode(document, "");
        
        assertTrue(document != null);
	}
    private static void printNode(Node node, String indent)  {

        switch (node.getNodeType()) {

            case Node.DOCUMENT_NODE:
                System.out.println("<xml version=\"1.0\">\n");
                // recurse on each child
                NodeList nodes = node.getChildNodes();
                if (nodes != null) {
                    for (int i=0; i<nodes.getLength(); i++) {
                        printNode(nodes.item(i), "");
                    }
                }
                break;
               
            case Node.ELEMENT_NODE:
                String name = node.getNodeName();
                System.out.print(indent + "<" + name);
                NamedNodeMap attributes = node.getAttributes();
                for (int i=0; i<attributes.getLength(); i++) {
                    Node current = attributes.item(i);
                    System.out.print(
                        " " + current.getNodeName() +
                        "=\"" + current.getNodeValue() +
                        "\"");
                }
                System.out.print(">");
               
                // recurse on each child
                NodeList children = node.getChildNodes();
                if (children != null) {
                    for (int i=0; i<children.getLength(); i++) {
                        printNode(children.item(i), indent + "  ");
                    }
                }
               
                System.out.print("</" + name + ">");
                break;

            case Node.TEXT_NODE:
                System.out.print(node.getNodeValue());
                break;
        }
    }

}
