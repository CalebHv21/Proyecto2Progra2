package appweb.servlets;

import domain.Cliente;
import xml.ClienteXML;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ClienteServlet")
public class ClienteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if ("editar".equals(accion)) {
            String id = request.getParameter("id");
            List<Cliente> clientes = ClienteXML.leerClientes();
            Cliente cliente = ClienteXML.buscarClientePorId(clientes, id);
            request.setAttribute("cliente", cliente);
            request.getRequestDispatcher("jsp/clientes/formCliente.jsp").forward(request, response);
        } else {
            List<Cliente> clientes = ClienteXML.leerClientes();
            ClienteXML.ordenarClientesPorId(clientes);
            request.setAttribute("clientes", clientes);
            request.getRequestDispatcher("jsp/clientes/listarClientes.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        List<Cliente> clientes = ClienteXML.leerClientes();

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
            request.getRequestDispatcher("jsp/clientes/formCliente.jsp").forward(request, response);
            return;
        }

        if ("registrar".equals(accion)) {
            //Evitar duplicados
            if (ClienteXML.buscarClientePorId(clientes, id) != null) {
                request.setAttribute("error", "Ya existe un cliente con esa cédula.");
                request.getRequestDispatcher("jsp/clientes/formCliente.jsp").forward(request, response);
                return;
            }
            Cliente nuevo = new Cliente(id, nombre, apellidos, telefono, direccion, correo);
            clientes.add(nuevo);
        } else if ("editar".equals(accion)) {
            Cliente cliente = ClienteXML.buscarClientePorId(clientes, id);
            if (cliente != null) {
                cliente.setNombre(nombre);
                cliente.setApellidos(apellidos);
                cliente.setTelefono(telefono);
                cliente.setDireccion(direccion);
                cliente.setCorreo(correo);
            }
        }
        ClienteXML.guardarClientes(clientes);
        response.sendRedirect("ClienteServlet");
    }
}