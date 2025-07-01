<%@page import="java.util.List"%>
<%@page import="mecanico.paraiso.domain.Cliente"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Listar Clientes</title>
    </head>
    <body>
        <h1>Lista de Clientes</h1>
        
        <% 
            List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
            if (clientes != null && !clientes.isEmpty()) {
        %>
        <table border="1">
            <thead>
                <tr>
                    <th>Cédula</th>
                    <th>Nombre</th>
                    <th>Apellidos</th>
                    <th>Teléfono</th>
                    <th>Dirección</th>
                    <th>Correo</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% for (Cliente cliente : clientes) { %>
                <tr>
                    <td><%= cliente.getId() %></td>
                    <td><%= cliente.getNombre() %></td>
                    <td><%= cliente.getApellidos() %></td>
                    <td><%= cliente.getTelefono() %></td>
                    <td><%= cliente.getDireccion() %></td>
                    <td><%= cliente.getCorreo() %></td>
                    <td>
                        <a href="cliente?accion=editar&id=<%= cliente.getId() %>">Editar</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p>No hay clientes registrados.</p>
        <% } %>
        
        <p><a href="cliente?accion=registrar">Registrar Nuevo Cliente</a></p>
        <p><a href="${pageContext.request.contextPath}/index.jsp">Volver al Inicio</a></p>
    </body>
</html>