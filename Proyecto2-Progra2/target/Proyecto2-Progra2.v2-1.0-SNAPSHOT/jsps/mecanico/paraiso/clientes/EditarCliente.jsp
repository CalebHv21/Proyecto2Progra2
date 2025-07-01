<%-- 
    Document   : EditarCliente
    Created on : Jun 29, 2025, 10:14:17 PM
    Author     : sebas
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <html>
    <head>
    <title>${cliente != null ? 'Editar' : 'Registrar'} Cliente</title>
</head>
<body>
<h2>${cliente != null ? 'Editar' : 'Registrar'} Cliente</h2>
<form action="ClienteServlet" method="post">
    <input type="hidden" name="accion" value="${cliente != null ? 'editar' : 'registrar'}"/>
    <label>Cédula:</label>
    <input type="text" name="id" value="${cliente.id}" ${cliente != null ? 'readonly' : ''} required/><br/>

    <label>Nombre:</label>
    <input type="text" name="nombre" value="${cliente.nombre}" required/><br/>

    <label>Apellidos:</label>
    <input type="text" name="apellidos" value="${cliente.apellidos}" required/><br/>

    <label>Teléfonos:</label>
    <input type="text" name="telefono" value="${cliente.telefono}" required/><br/>

    <label>Dirección:</label>
    <input type="text" name="direccion" value="${cliente.direccion}" required/><br/>

    <label>Correo electrónico:</label>
    <input type="email" name="correo" value="${cliente.correo}" required/><br/>

    <input type="submit" value="${cliente != null ? 'Actualizar' : 'Registrar'}"/>
</form>
<p><a href="../../index.jsp">Volver</a></p>
</body>
</html>