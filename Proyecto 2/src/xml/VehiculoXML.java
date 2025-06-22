package xml;

import domain.Vehiculo;
import org.w3c.dom.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.*;
import java.util.*;

public class VehiculoXML {
    private static final String XML_PATH = "src/main/resources/data/vehiculos.xml";

    public static List<Vehiculo> leerVehiculos() {
        List<Vehiculo> vehiculos = new ArrayList<>();
        try {
            File xmlFile = new File(XML_PATH);
            if (!xmlFile.exists()) return vehiculos;

            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(xmlFile);

            NodeList nList = doc.getElementsByTagName("vehiculo");
            for (int i = 0; i < nList.getLength(); i++) {
                Node n = nList.item(i);
                if (n.getNodeType() == Node.ELEMENT_NODE) {
                    Element e = (Element) n;
                    Vehiculo v = new Vehiculo(
                            getTagValue("placa", e),
                            getTagValue("marca", e),
                            getTagValue("color", e),
                            getTagValue("estilo", e),
                            Integer.parseInt(getTagValue("anio", e)),
                            getTagValue("vin", e),
                            Double.parseDouble(getTagValue("cilindraje", e)),
                            getTagValue("clienteId", e)
                    );
                    vehiculos.add(v);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return vehiculos;
    }

    public static void guardarVehiculos(List<Vehiculo> vehiculos) {
        try {
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.newDocument();

            Element root = doc.createElement("vehiculos");
            doc.appendChild(root);

            for (Vehiculo v : vehiculos) {
                Element vehiculo = doc.createElement("vehiculo");

                appendElement(doc, vehiculo, "placa", v.getPlaca());
                appendElement(doc, vehiculo, "marca", v.getMarca());
                appendElement(doc, vehiculo, "color", v.getColor());
                appendElement(doc, vehiculo, "estilo", v.getEstilo());
                appendElement(doc, vehiculo, "anio", String.valueOf(v.getAnio()));
                appendElement(doc, vehiculo, "vin", v.getVin());
                appendElement(doc, vehiculo, "cilindraje", String.valueOf(v.getCilindraje()));
                appendElement(doc, vehiculo, "clienteId", v.getClienteId());

                root.appendChild(vehiculo);
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
}