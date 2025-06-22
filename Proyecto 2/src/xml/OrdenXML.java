package xml;

import domain.OrdenTrabajo;
import domain.RepuestoServicio;
import org.w3c.dom.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

public class OrdenXML {
    private static final String XML_PATH = "src/main/resources/data/ordenes.xml";
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    public static List<OrdenTrabajo> leerOrdenes() {
        List<OrdenTrabajo> ordenes = new ArrayList<>();
        try {
            File xmlFile = new File(XML_PATH);
            if (!xmlFile.exists()) return ordenes;

            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(xmlFile);

            NodeList nList = doc.getElementsByTagName("orden");
            for (int i = 0; i < nList.getLength(); i++) {
                Node n = nList.item(i);
                if (n.getNodeType() == Node.ELEMENT_NODE) {
                    Element e = (Element) n;
                    OrdenTrabajo o = new OrdenTrabajo();
                    o.setId(getTagValue("id", e));
                    o.setPlacaVehiculo(getTagValue("placaVehiculo", e));
                    o.setFechaIngreso(sdf.parse(getTagValue("fechaIngreso", e)));
                    o.setEstado(getTagValue("estado", e));
                    o.setDescripcionProblema(getTagValue("descripcionProblema", e));
                    o.setObservaciones(getTagValue("observaciones", e));
                    o.setFechaEstimadaDevolucion(sdf.parse(getTagValue("fechaEstimadaDevolucion", e)));

                    // Leer repuestosServicios anidados
                    List<RepuestoServicio> rsl = new ArrayList<>();
                    NodeList repNodos = e.getElementsByTagName("repuestoServicio");
                    for (int j = 0; j < repNodos.getLength(); j++) {
                        Node repNode = repNodos.item(j);
                        if (repNode.getNodeType() == Node.ELEMENT_NODE) {
                            Element repElem = (Element) repNode;
                            RepuestoServicio rs = new RepuestoServicio(
                                    getTagValue("nombre", repElem),
                                    Integer.parseInt(getTagValue("cantidad", repElem)),
                                    Double.parseDouble(getTagValue("precio", repElem)),
                                    Boolean.parseBoolean(getTagValue("fuePedido", repElem)),
                                    Boolean.parseBoolean(getTagValue("esManoObra", repElem))
                            );
                            rsl.add(rs);
                        }
                    }
                    o.setRepuestosServicios(rsl);

                    o.setCostoTotal(Double.parseDouble(getTagValue("costoTotal", e)));
                    ordenes.add(o);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ordenes;
    }

    public static void guardarOrdenes(List<OrdenTrabajo> ordenes) {
        try {
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.newDocument();

            Element root = doc.createElement("ordenes");
            doc.appendChild(root);

            for (OrdenTrabajo o : ordenes) {
                Element orden = doc.createElement("orden");

                appendElement(doc, orden, "id", o.getId());
                appendElement(doc, orden, "placaVehiculo", o.getPlacaVehiculo());
                appendElement(doc, orden, "fechaIngreso", sdf.format(o.getFechaIngreso()));
                appendElement(doc, orden, "estado", o.getEstado());
                appendElement(doc, orden, "descripcionProblema", o.getDescripcionProblema());
                appendElement(doc, orden, "observaciones", o.getObservaciones());
                appendElement(doc, orden, "fechaEstimadaDevolucion", sdf.format(o.getFechaEstimadaDevolucion()));

                // Repuestos y servicios anidados
                Element repuestosServicios = doc.createElement("repuestosServicios");
                for (RepuestoServicio rs : o.getRepuestosServicios()) {
                    Element rep = doc.createElement("repuestoServicio");
                    appendElement(doc, rep, "nombre", rs.getNombre());
                    appendElement(doc, rep, "cantidad", String.valueOf(rs.getCantidad()));
                    appendElement(doc, rep, "precio", String.valueOf(rs.getPrecio()));
                    appendElement(doc, rep, "fuePedido", String.valueOf(rs.isFuePedido()));
                    appendElement(doc, rep, "esManoObra", String.valueOf(rs.isEsManoObra()));
                    repuestosServicios.appendChild(rep);
                }
                orden.appendChild(repuestosServicios);

                appendElement(doc, orden, "costoTotal", String.valueOf(o.getCostoTotal()));

                root.appendChild(orden);
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
        e.appendChild(doc.createTextNode(val == null ? "" : val));
        parent.appendChild(e);
    }

    private static String getTagValue(String tag, Element elem) {
        NodeList nl = elem.getElementsByTagName(tag);
        if (nl.getLength() == 0) return "";
        return nl.item(0).getTextContent();
    }
}