/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mecanico.paraiso.data;

import mecanico.paraiso.domain.OrdenTrabajo;
import mecanico.paraiso.domain.RepuestoServicio;
import org.jdom2.*;
import org.jdom2.input.SAXBuilder;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

public class OrdenXmlData {
    private static final String XML_PATH = "C:\\Users\\sebas\\OneDrive\\Escritorio\\Progra 2(2)\\New folder\\Proyecto2-Progra2.v2\\src\\main\\java\\filesXml\\ordenes.xml";
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    public static List<OrdenTrabajo> leerOrdenes() {
        List<OrdenTrabajo> ordenes = new ArrayList<>();
        try {
            File xmlFile = new File(XML_PATH);
            if (!xmlFile.exists()) {
                crearArchivoVacio();
                return ordenes;
            }

            SAXBuilder saxBuilder = new SAXBuilder();
            Document document = saxBuilder.build(xmlFile);
            Element rootElement = document.getRootElement();

            List<Element> ordenElements = rootElement.getChildren("orden");
            for (Element ordenElement : ordenElements) {
                try {
                    OrdenTrabajo orden = new OrdenTrabajo();
                    orden.setId(getElementValue(ordenElement, "id"));
                    orden.setPlacaVehiculo(getElementValue(ordenElement, "placaVehiculo"));
                    orden.setFechaIngreso(sdf.parse(getElementValue(ordenElement, "fechaIngreso")));
                    orden.setEstado(getElementValue(ordenElement, "estado"));
                    orden.setDescripcionProblema(getElementValue(ordenElement, "descripcionProblema"));
                    orden.setObservaciones(getElementValue(ordenElement, "observaciones"));
                    orden.setFechaEstimadaDevolucion(sdf.parse(getElementValue(ordenElement, "fechaEstimadaDevolucion")));

                    // Leer repuestos y servicios anidados
                    List<RepuestoServicio> repuestosServicios = new ArrayList<>();
                    Element repuestosElement = ordenElement.getChild("repuestosServicios");
                    if (repuestosElement != null) {
                        List<Element> repuestoElements = repuestosElement.getChildren("repuestoServicio");
                        for (Element repuestoElement : repuestoElements) {
                            try {
                                RepuestoServicio repuesto = new RepuestoServicio(
                                    getElementValue(repuestoElement, "nombre"),
                                    Integer.parseInt(getElementValue(repuestoElement, "cantidad")),
                                    Double.parseDouble(getElementValue(repuestoElement, "precio")),
                                    Boolean.parseBoolean(getElementValue(repuestoElement, "fuePedido")),
                                    Boolean.parseBoolean(getElementValue(repuestoElement, "esManoObra"))
                                );
                                repuestosServicios.add(repuesto);
                            } catch (NumberFormatException e) {
                                System.err.println("Error parsing repuesto data: " + e.getMessage());
                            }
                        }
                    }
                    orden.setRepuestosServicios(repuestosServicios);

                    String costoTotalStr = getElementValue(ordenElement, "costoTotal");
                    orden.setCostoTotal(costoTotalStr.isEmpty() ? 0.0 : Double.parseDouble(costoTotalStr));
                    
                    ordenes.add(orden);
                } catch (Exception e) {
                    System.err.println("Error parsing orden data: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ordenes;
    }

    public static void guardarOrdenes(List<OrdenTrabajo> ordenes) {
        try {
            // Crear directorio si no existe
            File file = new File(XML_PATH);
            file.getParentFile().mkdirs();

            Element rootElement = new Element("ordenes");
            Document document = new Document(rootElement);

            for (OrdenTrabajo orden : ordenes) {
                Element ordenElement = new Element("orden");
                
                ordenElement.addContent(new Element("id").setText(orden.getId()));
                ordenElement.addContent(new Element("placaVehiculo").setText(orden.getPlacaVehiculo()));
                ordenElement.addContent(new Element("fechaIngreso").setText(sdf.format(orden.getFechaIngreso())));
                ordenElement.addContent(new Element("estado").setText(orden.getEstado()));
                ordenElement.addContent(new Element("descripcionProblema").setText(orden.getDescripcionProblema()));
                ordenElement.addContent(new Element("observaciones").setText(orden.getObservaciones() != null ? orden.getObservaciones() : ""));
                ordenElement.addContent(new Element("fechaEstimadaDevolucion").setText(sdf.format(orden.getFechaEstimadaDevolucion())));

                // Repuestos y servicios anidados
                Element repuestosServiciosElement = new Element("repuestosServicios");
                for (RepuestoServicio repuesto : orden.getRepuestosServicios()) {
                    Element repuestoElement = new Element("repuestoServicio");
                    
                    repuestoElement.addContent(new Element("nombre").setText(repuesto.getNombre()));
                    repuestoElement.addContent(new Element("cantidad").setText(String.valueOf(repuesto.getCantidad())));
                    repuestoElement.addContent(new Element("precio").setText(String.valueOf(repuesto.getPrecio())));
                    repuestoElement.addContent(new Element("fuePedido").setText(String.valueOf(repuesto.isFuePedido())));
                    repuestoElement.addContent(new Element("esManoObra").setText(String.valueOf(repuesto.isEsManoObra())));
                    
                    repuestosServiciosElement.addContent(repuestoElement);
                }
                ordenElement.addContent(repuestosServiciosElement);

                ordenElement.addContent(new Element("costoTotal").setText(String.valueOf(orden.getCostoTotal())));
                
                rootElement.addContent(ordenElement);
            }

            XMLOutputter xmlOutputter = new XMLOutputter();
            xmlOutputter.setFormat(Format.getPrettyFormat());
            xmlOutputter.output(document, new FileWriter(XML_PATH));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String getElementValue(Element parent, String elementName) {
        Element element = parent.getChild(elementName);
        return element != null ? element.getText() : "";
    }

    private static void crearArchivoVacio() {
        try {
            File file = new File(XML_PATH);
            file.getParentFile().mkdirs();
            
            Element rootElement = new Element("ordenes");
            Document document = new Document(rootElement);
            
            XMLOutputter xmlOutputter = new XMLOutputter();
            xmlOutputter.setFormat(Format.getPrettyFormat());
            xmlOutputter.output(document, new FileWriter(XML_PATH));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String generarNuevoIdOrden() {
        List<OrdenTrabajo> ordenes = leerOrdenes();
        int maxId = 0;

        for (OrdenTrabajo orden : ordenes) {
            try {
                int currentId = Integer.parseInt(orden.getId());
                if (currentId > maxId) {
                    maxId = currentId;
                }
            } catch (NumberFormatException e) {
                // Skip IDs that are not numeric
            }
        }

        return String.valueOf(maxId + 1);
    }
}
