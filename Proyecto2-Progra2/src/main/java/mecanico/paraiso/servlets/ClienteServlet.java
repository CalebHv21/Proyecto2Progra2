/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package mecanico.paraiso.servlets;

import mecanico.paraiso.domain.Cliente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import mecanico.paraiso.data.ClienteXmlData;

@WebServlet(name = "cliente", urlPatterns = {"/cliente"})
public class ClienteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if ("editar".equals(accion)) {
            String id = request.getParameter("id");
            List<Cliente> clientes = ClienteXmlData.leerClientes();
            Cliente cliente = ClienteXmlData.buscarClientePorId(clientes, id);
            request.setAttribute("cliente", cliente);
            request.getRequestDispatcher("jsps/mecanico/paraiso/clientes/FormCliente.jsp").forward(request, response);
        } else {
            List<Cliente> clientes = ClienteXmlData.leerClientes();
            ClienteXmlData.ordenarClientesPorId(clientes);
            request.getRequestDispatcher("jsps/mecanico/paraiso/clientes/ListarClientes.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        List<Cliente> clientes = ClienteXmlData.leerClientes();

        String id = request.getParameter("id");
        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String correo = request.getParameter("correo");

        //Validación
        if (id == null || nombre == null || apellidos == null || telefono == null || direccion == null || correo == null
                || id.isEmpty() || nombre.isEmpty() || apellidos.isEmpty() || telefono.isEmpty() || direccion.isEmpty() || correo.isEmpty()) {
            request.setAttribute("error", "Todos los campos son obligatorios.");
            request.getRequestDispatcher("jsps/mecanico/paraiso/clientes/FormCliente.jsp").forward(request, response);
            return;
        }

        if ("registrar".equals(accion)) {
            //Evitar duplicados
            if (ClienteXmlData.buscarClientePorId(clientes, id) != null) {
                request.setAttribute("error", "Ya existe un cliente con esa cédula.");
                request.getRequestDispatcher("jsps/mecanico/paraiso/clientes/FormCliente.jsp").forward(request, response);
                return;
            }
            Cliente nuevo = new Cliente(id, nombre, apellidos, telefono, direccion, correo);
            clientes.add(nuevo);
        } else if ("editar".equals(accion)) {
            Cliente cliente = ClienteXmlData.buscarClientePorId(clientes, id);
            if (cliente != null) {
                cliente.setNombre(nombre);
                cliente.setApellidos(apellidos);
                cliente.setTelefono(telefono);
                cliente.setDireccion(direccion);
                cliente.setCorreo(correo);
            }
        }
        ClienteXmlData.guardarClientes(clientes);
        response.sendRedirect("cliente");
    }
}