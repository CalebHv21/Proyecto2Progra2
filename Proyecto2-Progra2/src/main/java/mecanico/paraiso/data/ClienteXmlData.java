package mecanico.paraiso.data;

import mecanico.paraiso.domain.Cliente;
import org.jdom2.*;
import org.jdom2.input.SAXBuilder;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;
import java.io.*;
import java.util.*;

/**
 *
 * @author sebas
 */
public class ClienteXmlData {

    private static final String rutaArchivo = "C:\\Users\\sebas\\OneDrive\\Escritorio\\Progra2\\Proyecto2-Progra2\\Proyecto-2-de-Progra-2\\Proyecto2-Progra2\\src\\main\\java\\filesXml\\clientes.xml";

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

    public static void ordenarClientesPorId(List<Cliente> clientes) {
        clientes.sort(Comparator.comparing(Cliente::getId));
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
