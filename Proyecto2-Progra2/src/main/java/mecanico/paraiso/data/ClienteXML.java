package mecanico.paraiso.data;

import mecanico.paraiso.domain.Cliente;
import org.w3c.dom.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.*;
import java.util.*;

public class ClienteXML {
    private static final String XML_PATH = "src/main/resources/data/clientes.xml";

    public static List<Cliente> leerClientes() {
        List<Cliente> clientes = new ArrayList<>();
        try {
            File xmlFile = new File(XML_PATH);
            if (!xmlFile.exists()) return clientes;

            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(xmlFile);

            NodeList nList = doc.getElementsByTagName("cliente");
            for (int i = 0; i < nList.getLength(); i++) {
                Node n = nList.item(i);
                if (n.getNodeType() == Node.ELEMENT_NODE) {
                    Element e = (Element) n;
                    Cliente c = new Cliente(
                            getTagValue("id", e),
                            getTagValue("nombre", e),
                            getTagValue("apellidos", e),
                            getTagValue("telefono", e),
                            getTagValue("direccion", e),
                            getTagValue("correo", e)
                    );
                    clientes.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return clientes;
    }

    public static void guardarClientes(List<Cliente> clientes) {
        try {
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.newDocument();

            Element root = doc.createElement("clientes");
            doc.appendChild(root);

            for (Cliente c : clientes) {
                Element cliente = doc.createElement("cliente");

                appendElement(doc, cliente, "id", c.getId());
                appendElement(doc, cliente, "nombre", c.getNombre());
                appendElement(doc, cliente, "apellidos", c.getApellidos());
                appendElement(doc, cliente, "telefono", c.getTelefono());
                appendElement(doc, cliente, "direccion", c.getDireccion());
                appendElement(doc, cliente, "correo", c.getCorreo());

                root.appendChild(cliente);
            }

            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer t = tf.newTransformer();
            t.setOutputProperty(OutputKeys.INDENT, "yes");
            t.transform(new DOMSource(doc), new StreamResult(new File(XML_PATH)));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void appendElement(Document doc, Element parent, String tag, String val) {
        Element e = doc.createElement(tag);
        e.appendChild(doc.createTextNode(val));
        parent.appendChild(e);
    }

    private static String getTagValue(String tag, Element elem) {
        NodeList nl = elem.getElementsByTagName(tag);
        if (nl.getLength() == 0) return "";
        return nl.item(0).getTextContent();
    }

    public static Cliente buscarClientePorId(List<Cliente> clientes, String id) {
        for (Cliente c : clientes) {
            if (c.getId().equals(id)) return c;
        }
        return null;
    }

    public static void ordenarClientesPorId(List<Cliente> clientes) {
        clientes.sort(Comparator.comparing(Cliente::getId));
    }
}