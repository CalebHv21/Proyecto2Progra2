package mecanico.paraiso.data;

import mecanico.paraiso.domain.Cliente;
import org.jdom2.*;
import org.jdom2.input.SAXBuilder;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;
import java.io.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

/**
 *
 * @author sebas
 */
public class ClienteXmlData {

    private static final String rutaArchivo = getXmlFilePath("clientes.xml");

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

    public static List<Cliente> leerClientes() {
        List<Cliente> clientes = new ArrayList<>();
        try {
            File xmlFile = new File(rutaArchivo);
            if (!xmlFile.exists()) {
                // Si no existe, crear el archivo con estructura básica
                crearArchivoVacio();
                return clientes;
            }

            SAXBuilder saxBuilder = new SAXBuilder();
            Document document = saxBuilder.build(xmlFile);
            Element rootElement = document.getRootElement();

            List<Element> clienteElements = rootElement.getChildren("cliente");
            for (Element clienteElement : clienteElements) {
                Cliente cliente = new Cliente(
                        getElementValue(clienteElement, "id"),
                        getElementValue(clienteElement, "nombre"),
                        getElementValue(clienteElement, "apellidos"),
                        getElementValue(clienteElement, "telefono"),
                        getElementValue(clienteElement, "direccion"),
                        getElementValue(clienteElement, "correo")
                );
                clientes.add(cliente);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return clientes;
    }

    public static void guardarClientes(List<Cliente> clientes) {
        try {
            // Crear directorio si no existe
            File file = new File(rutaArchivo);
            file.getParentFile().mkdirs();

            Element rootElement = new Element("clientes");
            Document document = new Document(rootElement);

            for (Cliente cliente : clientes) {
                Element clienteElement = new Element("cliente");

                clienteElement.addContent(new Element("id").setText(cliente.getId()));
                clienteElement.addContent(new Element("nombre").setText(cliente.getNombre()));
                clienteElement.addContent(new Element("apellidos").setText(cliente.getApellidos()));
                clienteElement.addContent(new Element("telefono").setText(cliente.getTelefono()));
                clienteElement.addContent(new Element("direccion").setText(cliente.getDireccion()));
                clienteElement.addContent(new Element("correo").setText(cliente.getCorreo()));

                rootElement.addContent(clienteElement);
            }

            XMLOutputter xmlOutputter = new XMLOutputter();
            xmlOutputter.setFormat(Format.getPrettyFormat());
            xmlOutputter.output(document, new FileWriter(rutaArchivo));

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
            File file = new File(rutaArchivo);
            file.getParentFile().mkdirs();

            Element rootElement = new Element("clientes");
            Document document = new Document(rootElement);

            XMLOutputter xmlOutputter = new XMLOutputter();
            xmlOutputter.setFormat(Format.getPrettyFormat());
            xmlOutputter.output(document, new FileWriter(rutaArchivo));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Cliente buscarClientePorId(List<Cliente> clientes, String id) {
        for (Cliente cliente : clientes) {
            if (cliente.getId().equals(id)) {
                return cliente;
            }
        }
        return null;
    }

    // Primer criterio de ordenamiento (ya existía)
    public static void ordenarClientesPorId(List<Cliente> clientes) {
        clientes.sort(Comparator.comparing(Cliente::getId));
    }

    // Segundo criterio de ordenamiento
    public static void ordenarClientesPorNombre(List<Cliente> clientes) {
        clientes.sort((c1, c2) -> {
            String nombre1 = c1.getNombre() != null ? c1.getNombre() : "";
            String nombre2 = c2.getNombre() != null ? c2.getNombre() : "";
            return nombre1.compareToIgnoreCase(nombre2);
        });
    }

    public static String generarNuevoIdCliente() {
        List<Cliente> clientes = leerClientes();
        if (clientes.isEmpty()) {
            return "CLI001";
        }

        int maxNum = 0;
        for (Cliente cliente : clientes) {
            String id = cliente.getId();
            if (id.startsWith("CLI")) {
                try {
                    int num = Integer.parseInt(id.substring(3));
                    if (num > maxNum) {
                        maxNum = num;
                    }
                } catch (NumberFormatException e) {
                    // Ignorar IDs que no sigan el patrón
                }
            }
        }

        return String.format("CLI%03d", maxNum + 1);
    }
}