package Controller;

import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.ByteArrayInputStream;
import java.io.IOException;

public class Controller {

    public void parser(String str) throws ParserConfigurationException, IOException, SAXException, ParserConfigurationException {
        org.w3c.dom.Document xml = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(new InputSource(new ByteArrayInputStream(str.getBytes("UTF-8"))));
        Node root = xml.getFirstChild();
        Node child = root.getFirstChild();
        switch (child.getNodeName()) {
            case "text":
            case "filerequest":
            case "filerespond":
            case "encrypt":
            case "disconnect":
            case "keyrequest":
            case "request":
        }
    }
}
