package mecanico.paraiso.data;

import mecanico.paraiso.domain.Vehiculo;
import org.jdom2.*;
import org.jdom2.input.SAXBuilder;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;
import java.io.*;
import java.util.*;

public class VehiculoXmlData {
    private static final String XML_PATH = "src/main/java/filesXml/vehiculos.xml";

    public static List<Vehiculo> leerVehiculos() {
        List<Vehiculo> vehiculos = new ArrayList<>();
        try {
            File xmlFile = new File(XML_PATH);
            if (!xmlFile.exists()) {
                crearArchivoVacio();
                return vehiculos;
            }

            SAXBuilder saxBuilder = new SAXBuilder();
            Document document = saxBuilder.build(xmlFile);
            Element rootElement = document.getRootElement();

            List<Element> vehiculoElements = rootElement.getChildren("vehiculo");
            for (Element vehiculoElement : vehiculoElements) {
                try {
                    Vehiculo vehiculo = new Vehiculo(
                        getElementValue(vehiculoElement, "placa"),
                        getElementValue(vehiculoElement, "marca"),
                        getElementValue(vehiculoElement, "modelo"),
                        getElementValue(vehiculoElement, "color"),
                        getElementValue(vehiculoElement, "estilo"),
                        Integer.parseInt(getElementValue(vehiculoElement, "anio")),
                        getElementValue(vehiculoElement, "vin"),
                        Double.parseDouble(getElementValue(vehiculoElement, "cilindraje")),
                        getElementValue(vehiculoElement, "clienteId")
                    );
                    vehiculos.add(vehiculo);
                } catch (NumberFormatException e) {
                    System.err.println("Error parsing vehiculo data: " + e.getMessage());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return vehiculos;
    }

    public static void guardarVehiculos(List<Vehiculo> vehiculos) {
        try {
            File file = new File(XML_PATH);
            file.getParentFile().mkdirs();

            Element rootElement = new Element("vehiculos");
            Document document = new Document(rootElement);

            for (Vehiculo vehiculo : vehiculos) {
                Element vehiculoElement = new Element("vehiculo");
                
                vehiculoElement.addContent(new Element("placa").setText(vehiculo.getPlaca()));
                vehiculoElement.addContent(new Element("marca").setText(vehiculo.getMarca()));
                vehiculoElement.addContent(new Element("modelo").setText(vehiculo.getModelo() != null ? vehiculo.getModelo() : ""));
                vehiculoElement.addContent(new Element("color").setText(vehiculo.getColor()));
                vehiculoElement.addContent(new Element("estilo").setText(vehiculo.getEstilo()));
                vehiculoElement.addContent(new Element("anio").setText(String.valueOf(vehiculo.getAnno())));
                vehiculoElement.addContent(new Element("vin").setText(vehiculo.getVin()));
                vehiculoElement.addContent(new Element("cilindraje").setText(String.valueOf(vehiculo.getCilindraje())));
                vehiculoElement.addContent(new Element("clienteId").setText(vehiculo.getClienteId()));
                
                rootElement.addContent(vehiculoElement);
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
            
            Element rootElement = new Element("vehiculos");
            Document document = new Document(rootElement);
            
            XMLOutputter xmlOutputter = new XMLOutputter();
            xmlOutputter.setFormat(Format.getPrettyFormat());
            xmlOutputter.output(document, new FileWriter(XML_PATH));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void ordenarVehiculosPorPlaca(List<Vehiculo> vehiculos) {
        vehiculos.sort(Comparator.comparing(Vehiculo::getPlaca));
    }

    // Segundo criterio de ordenamiento
    public static void ordenarVehiculosPorMarcaYModelo(List<Vehiculo> vehiculos) {
        vehiculos.sort((v1, v2) -> {
            String marca1 = v1.getMarca() != null ? v1.getMarca() : "";
            String marca2 = v2.getMarca() != null ? v2.getMarca() : "";
            
            int comparacionMarca = marca1.compareToIgnoreCase(marca2);
            if (comparacionMarca == 0) {
                String modelo1 = v1.getModelo() != null ? v1.getModelo() : "";
                String modelo2 = v2.getModelo() != null ? v2.getModelo() : "";
                return modelo1.compareToIgnoreCase(modelo2);
            }
            return comparacionMarca;
        });
    }

    // Búsqueda binaria (ya implementada)
    public static Vehiculo buscarVehiculoPorPlaca(List<Vehiculo> vehiculos, String placa) {
        ordenarVehiculosPorPlaca(vehiculos);
        int left = 0, right = vehiculos.size() - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            Vehiculo v = vehiculos.get(mid);
            int cmp = v.getPlaca().compareToIgnoreCase(placa);
            if (cmp == 0) return v;
            if (cmp < 0) left = mid + 1;
            else right = mid - 1;
        }
        return null;
    }
}