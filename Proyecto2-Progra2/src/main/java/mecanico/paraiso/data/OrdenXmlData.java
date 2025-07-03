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
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.*;

public class OrdenXmlData {
    private static final String XML_PATH = getXmlFilePath("ordenes.xml");
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * Utility method to get the absolute path to XML files in the source directory
     */
    private static String getXmlFilePath(String fileName) {
        try {
            // Get the current working directory
            String currentDir = System.getProperty("user.dir");
            Path currentPath = Paths.get(currentDir);
            
            // Try to find the project root by looking for pom.xml
            Path projectRoot = findProjectRoot(currentPath);
            
            if (projectRoot != null) {
                Path xmlDir = projectRoot.resolve("Proyecto2-Progra2/src/main/java/filesXml");
                return xmlDir.resolve(fileName).toString();
            } else {
                // Fallback to relative path if project root not found
                return "src/main/java/filesXml/" + fileName;
            }
        } catch (Exception e) {
            // Fallback to relative path in case of any error
            return "src/main/java/filesXml/" + fileName;
        }
    }
    
    /**
     * Find the project root directory by looking for pom.xml
     */
    private static Path findProjectRoot(Path startPath) {
        Path current = startPath;
        while (current != null) {
            // Check if this directory contains pom.xml
            if (current.resolve("pom.xml").toFile().exists()) {
                return current;
            }
            // Check if this directory contains Proyecto2-Progra2/pom.xml (in case we're in the parent)
            if (current.resolve("Proyecto2-Progra2/pom.xml").toFile().exists()) {
                return current;
            }
            current = current.getParent();
        }
        return null;
    }

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

    // Primer criterio de ordenamiento - por ID (implícito en el flujo actual)
    public static void ordenarOrdenesPorId(List<OrdenTrabajo> ordenes) {
        ordenes.sort((o1, o2) -> {
            try {
                int id1 = Integer.parseInt(o1.getId());
                int id2 = Integer.parseInt(o2.getId());
                return Integer.compare(id1, id2);
            } catch (NumberFormatException e) {
                return o1.getId().compareToIgnoreCase(o2.getId());
            }
        });
    }

    // Segundo criterio de ordenamiento - por fecha (más recientes primero)
    public static void ordenarOrdenesPorFecha(List<OrdenTrabajo> ordenes) {
        ordenes.sort((o1, o2) -> {
            if (o1.getFechaIngreso() == null && o2.getFechaIngreso() == null) return 0;
            if (o1.getFechaIngreso() == null) return 1;
            if (o2.getFechaIngreso() == null) return -1;
            // Ordenar por fecha descendente (más recientes primero)
            return o2.getFechaIngreso().compareTo(o1.getFechaIngreso());
        });
    }

    // Tercer criterio de ordenamiento - por estado y luego por fecha
    public static void ordenarOrdenesPorEstadoYFecha(List<OrdenTrabajo> ordenes) {
        ordenes.sort((o1, o2) -> {
            int prioridad1 = getPrioridadEstado(o1.getEstado());
            int prioridad2 = getPrioridadEstado(o2.getEstado());
            
            int comparacionEstado = Integer.compare(prioridad1, prioridad2);
            if (comparacionEstado == 0) {
                // Si tienen el mismo estado, ordenar por fecha
                if (o1.getFechaIngreso() == null && o2.getFechaIngreso() == null) return 0;
                if (o1.getFechaIngreso() == null) return 1;
                if (o2.getFechaIngreso() == null) return -1;
                return o1.getFechaIngreso().compareTo(o2.getFechaIngreso());
            }
            return comparacionEstado;
        });
    }

    // Método auxiliar para definir prioridad de estados
    private static int getPrioridadEstado(String estado) {
        if (estado == null) return 999;
        
        switch (estado) {
            case "Diagnóstico": return 1;
            case "En reparación": return 2;
            case "Listo para entrega": return 3;
            case "Entregado": return 4;
            default: return 5;
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