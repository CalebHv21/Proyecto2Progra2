/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package mecanico.paraiso.servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import mecanico.paraiso.data.ClienteXmlData;
import mecanico.paraiso.data.OrdenXmlData;
import mecanico.paraiso.data.VehiculoXmlData;
import mecanico.paraiso.domain.Cliente;
import mecanico.paraiso.domain.OrdenTrabajo;
import mecanico.paraiso.domain.Vehiculo;

/**
 *
 * @author sebas
 */
@WebServlet(name = "vehiculo", urlPatterns = {"/vehiculo"})
public class VehiculoServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if ("editar".equals(accion)) {
            String placa = request.getParameter("placa");
            List<Vehiculo> vehiculos = VehiculoXmlData.leerVehiculos();
            Vehiculo vehiculo = VehiculoXmlData.buscarVehiculoPorPlaca(vehiculos, placa);
            
            List<Cliente> clientes = ClienteXmlData.leerClientes();
            request.setAttribute("clientes", clientes);
            request.setAttribute("vehiculo", vehiculo);
            request.getRequestDispatcher("jsps/mecanico/paraiso/vehiculos/FormVehiculos.jsp").forward(request, response);
        } else if ("registrar".equals(accion)) {
            List<Cliente> clientes = ClienteXmlData.leerClientes();
            request.setAttribute("clientes", clientes);
            request.getRequestDispatcher("jsps/mecanico/paraiso/vehiculos/FormVehiculos.jsp").forward(request, response);
        } else if ("gestionOrdenes".equals(accion)) {
            // Nueva acción para el FormOrdenesVehiculos
            List<Vehiculo> vehiculos = VehiculoXmlData.leerVehiculos();
            List<OrdenTrabajo> ordenes = OrdenXmlData.leerOrdenes();
            List<Cliente> clientes = ClienteXmlData.leerClientes();
            
            // Enriquecer vehículos con datos del propietario
            for (Vehiculo vehiculo : vehiculos) {
                for (Cliente cliente : clientes) {
                    if (cliente.getId().equals(vehiculo.getClienteId())) {
                        vehiculo.setNombrePropietario(cliente.getNombre() + " " + cliente.getApellidos());
                        vehiculo.setTelefonoPropietario(cliente.getTelefono());
                        break;
                    }
                }
            }
            
            request.setAttribute("vehiculos", vehiculos);
            request.setAttribute("ordenes", ordenes);
            request.getRequestDispatcher("jsps/mecanico/paraiso/vehiculos/FormOrdenesVehiculos.jsp").forward(request, response);
        } else {
            List<Vehiculo> vehiculos = VehiculoXmlData.leerVehiculos();
            List<Cliente> clientes = ClienteXmlData.leerClientes();
            
            // Enriquecer vehículos con datos del propietario
            for (Vehiculo vehiculo : vehiculos) {
                for (Cliente cliente : clientes) {
                    if (cliente.getId().equals(vehiculo.getClienteId())) {
                        vehiculo.setNombrePropietario(cliente.getNombre() + " " + cliente.getApellidos());
                        vehiculo.setTelefonoPropietario(cliente.getTelefono());
                        break;
                    }
                }
            }
            
            VehiculoXmlData.ordenarVehiculosPorPlaca(vehiculos);
            request.setAttribute("vehiculos", vehiculos);
            request.getRequestDispatcher("jsps/mecanico/paraiso/vehiculos/ListarVehiculos.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        List<Vehiculo> vehiculos = VehiculoXmlData.leerVehiculos();

        String placa = request.getParameter("placa");
        String marca = request.getParameter("marca");
        String modelo = request.getParameter("modelo");
        String color = request.getParameter("color");
        String estilo = request.getParameter("estilo");
        String annoStr = request.getParameter("anno"); // Mantener anno
        String vin = request.getParameter("vin");
        String cilindrajeStr = request.getParameter("cilindraje");
        String clienteId = request.getParameter("clienteId");

        // Validaciones básicas
        if (placa == null || marca == null || modelo == null || color == null || estilo == null || 
            annoStr == null || vin == null || cilindrajeStr == null || clienteId == null ||
            placa.isEmpty() || marca.isEmpty() || modelo.isEmpty() || color.isEmpty() || 
            estilo.isEmpty() || annoStr.isEmpty() || vin.isEmpty() || cilindrajeStr.isEmpty() || clienteId.isEmpty()) {
            
            request.setAttribute("error", "Todos los campos son obligatorios.");
            List<Cliente> clientes = ClienteXmlData.leerClientes();
            request.setAttribute("clientes", clientes);
            request.getRequestDispatcher("jsps/mecanico/paraiso/vehiculos/FormVehiculos.jsp").forward(request, response);
            return;
        }

        int anno;
        double cilindraje;
        try {
            anno = Integer.parseInt(annoStr);
            cilindraje = Double.parseDouble(cilindrajeStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Año y cilindraje deben ser valores válidos.");
            List<Cliente> clientes = ClienteXmlData.leerClientes();
            request.setAttribute("clientes", clientes);
            request.getRequestDispatcher("jsps/mecanico/paraiso/vehiculos/FormVehiculos.jsp").forward(request, response);
            return;
        }

        if ("registrar".equals(accion)) {
            if (VehiculoXmlData.buscarVehiculoPorPlaca(vehiculos, placa) != null) {
                request.setAttribute("error", "Ya existe un vehículo con esa placa.");
                List<Cliente> clientes = ClienteXmlData.leerClientes();
                request.setAttribute("clientes", clientes);
                request.getRequestDispatcher("jsps/mecanico/paraiso/vehiculos/FormVehiculos.jsp").forward(request, response);
                return;
            }
            Vehiculo nuevo = new Vehiculo(placa, marca, modelo, color, estilo, anno, vin, cilindraje, clienteId);
            vehiculos.add(nuevo);
        } else if ("editar".equals(accion)) {
            Vehiculo vehiculo = VehiculoXmlData.buscarVehiculoPorPlaca(vehiculos, placa);
            if (vehiculo != null) {
                vehiculo.setMarca(marca);
                vehiculo.setModelo(modelo);
                vehiculo.setColor(color);
                vehiculo.setEstilo(estilo);
                vehiculo.setAnno(anno);
                vehiculo.setVin(vin);
                vehiculo.setCilindraje(cilindraje);
                vehiculo.setClienteId(clienteId);
            }
        }
        
        VehiculoXmlData.guardarVehiculos(vehiculos);
        response.sendRedirect("vehiculo");  
    }
}