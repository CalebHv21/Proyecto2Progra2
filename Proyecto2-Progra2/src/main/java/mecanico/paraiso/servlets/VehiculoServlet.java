package mecanico.paraiso.servlets;

import mecanico.paraiso.domain.Vehiculo;
import mecanico.paraiso.domain.Cliente;
import mecanico.paraiso.data.VehiculoXML;
import mecanico.paraiso.data.ClienteXML;
import jakarta.servlet.ServletException;          
import jakarta.servlet.annotation.WebServlet;     
import jakarta.servlet.http.*;              
import java.io.IOException;
import java.util.List;

@WebServlet(name = "vehiculo", urlPatterns = {"/vehiculo"})
public class VehiculoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        List<Cliente> clientes = ClienteXML.leerClientes();
        request.setAttribute("clientes", clientes);

        if ("editar".equals(accion)) {
            String placa = request.getParameter("placa");
            List<Vehiculo> vehiculos = VehiculoXML.leerVehiculos();
            Vehiculo vehiculo = VehiculoXML.buscarVehiculoPorPlaca(vehiculos, placa);
            request.setAttribute("vehiculo", vehiculo);
            request.getRequestDispatcher("jsp/vehiculos/formVehiculo.jsp").forward(request, response);
        } else {
            List<Vehiculo> vehiculos = VehiculoXML.leerVehiculos();
            VehiculoXML.ordenarVehiculosPorPlaca(vehiculos);
            request.setAttribute("vehiculos", vehiculos);
            request.getRequestDispatcher("jsp/vehiculos/listarVehiculos.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        List<Vehiculo> vehiculos = VehiculoXML.leerVehiculos();

        String placa = request.getParameter("placa");
        String marca = request.getParameter("marca");
        String color = request.getParameter("color");
        String estilo = request.getParameter("estilo");
        String annoStr = request.getParameter("anno");
        String vin = request.getParameter("vin");
        String cilindrajeStr = request.getParameter("cilindraje");
        String clienteId = request.getParameter("clienteId");

        // Validaciones básicas
        if (placa == null || marca == null || color == null || estilo == null || annoStr == null || vin == null || cilindrajeStr == null || clienteId == null
                || placa.isEmpty() || marca.isEmpty() || color.isEmpty() || estilo.isEmpty() || annoStr.isEmpty() || vin.isEmpty() || cilindrajeStr.isEmpty() || clienteId.isEmpty()) {
            request.setAttribute("error", "Todos los campos son obligatorios.");
            List<Cliente> clientes = ClienteXML.leerClientes();
            request.setAttribute("clientes", clientes);
            request.getRequestDispatcher("jsp/vehiculos/formVehiculo.jsp").forward(request, response);
            return;
        }

        int anno;
        double cilindraje;
        try {
            anno = Integer.parseInt(annoStr);
            cilindraje = Double.parseDouble(cilindrajeStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Año y cilindraje deben ser valores válidos.");
            List<Cliente> clientes = ClienteXML.leerClientes();
            request.setAttribute("clientes", clientes);
            request.getRequestDispatcher("jsp/vehiculos/formVehiculo.jsp").forward(request, response);
            return;
        }

        if ("registrar".equals(accion)) {
            if (VehiculoXML.buscarVehiculoPorPlaca(vehiculos, placa) != null) {
                request.setAttribute("error", "Ya existe un vehículo con esa placa.");
                List<Cliente> clientes = ClienteXML.leerClientes();
                request.setAttribute("clientes", clientes);
                request.getRequestDispatcher("jsp/vehiculos/formVehiculo.jsp").forward(request, response);
                return;
            }
            Vehiculo nuevo = new Vehiculo(placa, marca, color, estilo, anno, vin, cilindraje, clienteId);
            vehiculos.add(nuevo);
        } else if ("editar".equals(accion)) {
            Vehiculo vehiculo = VehiculoXML.buscarVehiculoPorPlaca(vehiculos, placa);
            if (vehiculo != null) {
                vehiculo.setMarca(marca);
                vehiculo.setColor(color);
                vehiculo.setEstilo(estilo);
                vehiculo.setAnno(anno);
                vehiculo.setVin(vin);
                vehiculo.setCilindraje(cilindraje);
                vehiculo.setClienteId(clienteId);
            }
        }
        VehiculoXML.guardarVehiculos(vehiculos);
        response.sendRedirect("vehiculo");  // ✅ También corregido: "vehiculo" en lugar de "VehiculoServlet"
    }
}