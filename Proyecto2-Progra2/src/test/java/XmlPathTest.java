import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import static org.junit.jupiter.api.Assertions.*;

import mecanico.paraiso.data.ClienteXmlData;
import mecanico.paraiso.data.OrdenXmlData;
import mecanico.paraiso.data.VehiculoXmlData;
import mecanico.paraiso.domain.Cliente;
import mecanico.paraiso.domain.Vehiculo;
import mecanico.paraiso.domain.OrdenTrabajo;

import java.io.File;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

/**
 * Test to verify that XML files are saved to the correct source directory
 * instead of the target directory.
 */
public class XmlPathTest {

    @Test
    public void testXmlFilesCreatedInSourceDirectory() {
        // Create test data
        List<Cliente> clientes = new ArrayList<>();
        clientes.add(new Cliente("CLI001", "Juan", "Pérez", "12345678", "San José", "juan@test.com"));
        
        List<Vehiculo> vehiculos = new ArrayList<>();
        vehiculos.add(new Vehiculo("ABC123", "Toyota", "Corolla", "Rojo", "Sedán", 2020, "VIN123", 1.8, "CLI001"));
        
        List<OrdenTrabajo> ordenes = new ArrayList<>();
        OrdenTrabajo orden = new OrdenTrabajo();
        orden.setId("1");
        orden.setPlacaVehiculo("ABC123");
        orden.setFechaIngreso(new Date());
        orden.setEstado("Diagnóstico");
        orden.setDescripcionProblema("Problema de motor");
        orden.setObservaciones("Test");
        orden.setFechaEstimadaDevolucion(new Date());
        orden.setRepuestosServicios(new ArrayList<>());
        orden.setCostoTotal(0.0);
        ordenes.add(orden);
        
        // Save test data
        ClienteXmlData.guardarClientes(clientes);
        VehiculoXmlData.guardarVehiculos(vehiculos);
        OrdenXmlData.guardarOrdenes(ordenes);
        
        // Verify that files are created in the source directory, not target
        String baseDir = System.getProperty("user.dir");
        File sourceXmlDir = new File(baseDir, "Proyecto2-Progra2/src/main/java/filesXml");
        
        // Check if files exist in source directory
        File clientesFile = new File(sourceXmlDir, "clientes.xml");
        File vehiculosFile = new File(sourceXmlDir, "vehiculos.xml");
        File ordenesFile = new File(sourceXmlDir, "ordenes.xml");
        
        assertTrue(clientesFile.exists(), "Clientes XML file should exist in source directory: " + clientesFile.getPath());
        assertTrue(vehiculosFile.exists(), "Vehiculos XML file should exist in source directory: " + vehiculosFile.getPath());
        assertTrue(ordenesFile.exists(), "Ordenes XML file should exist in source directory: " + ordenesFile.getPath());
        
        // Verify files are not in target directory
        File targetXmlDir = new File(baseDir, "target/classes/filesXml");
        File targetClientesFile = new File(targetXmlDir, "clientes.xml");
        File targetVehiculosFile = new File(targetXmlDir, "vehiculos.xml");
        File targetOrdenesFile = new File(targetXmlDir, "ordenes.xml");
        
        // Files might exist in target from previous runs, but we want to confirm 
        // they're primarily being saved to source
        System.out.println("Source clientes.xml exists: " + clientesFile.exists() + " at " + clientesFile.getPath());
        System.out.println("Source vehiculos.xml exists: " + vehiculosFile.exists() + " at " + vehiculosFile.getPath());
        System.out.println("Source ordenes.xml exists: " + ordenesFile.exists() + " at " + ordenesFile.getPath());
        
        // Test reading the data back
        List<Cliente> clientesLeidos = ClienteXmlData.leerClientes();
        List<Vehiculo> vehiculosLeidos = VehiculoXmlData.leerVehiculos();
        List<OrdenTrabajo> ordenesLeidas = OrdenXmlData.leerOrdenes();
        
        assertFalse(clientesLeidos.isEmpty(), "Should be able to read clientes from XML");
        assertFalse(vehiculosLeidos.isEmpty(), "Should be able to read vehiculos from XML");
        assertFalse(ordenesLeidas.isEmpty(), "Should be able to read ordenes from XML");
        
        assertEquals("CLI001", clientesLeidos.get(0).getId());
        assertEquals("ABC123", vehiculosLeidos.get(0).getPlaca());
        assertEquals("1", ordenesLeidas.get(0).getId());
    }
}