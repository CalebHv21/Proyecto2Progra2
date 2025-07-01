<%-- 
    Document   : ListarClientes
    Created on : Jun 29, 2025, 10:16:48 PM
    Author     : sebas
--%>
<%@page import="mecanico.paraiso.domain.Cliente"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Listar Clientes</title>
    </head>
    <body>
        <h1>Información del cliente</h1>
        <%
            Cliente cliente = (Cliente) request.getAttribute("cliente");
            if (cliente != null) {
        %>
        <p>ID: <%= cliente.getId()%></p>
        <p>Nomnbre: <%= cliente.getNombre()%></p>
        <p>Apellidos: <%= cliente.getApellidos()%></p>
        <p>Telefono: <%= cliente.getTelefono()%></p>
        <p>Dirreccion: <%= cliente.getDireccion()%></p>
        <p>Correo: <%= cliente.getCorreo()%></p>
        <p>Vehiculos: <%= cliente.getVehiculos()%></p>



        <% } else { %>
        <p>No se ha encontrado informacion del cliente o no se ha especificado un cliente. </p>
        <% } %>
    </body>
</html>
