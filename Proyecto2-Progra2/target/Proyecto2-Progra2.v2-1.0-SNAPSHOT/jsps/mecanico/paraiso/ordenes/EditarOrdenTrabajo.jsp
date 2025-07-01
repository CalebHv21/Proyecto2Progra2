<%-- 
    Document   : EditarOrdenTrabajo
    Created on : Jun 29, 2025, 10:17:28 PM
    Author     : sebas
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>${vehiculo != null ? 'Editar' : 'Registrar'} Vehículo</title>
</head>
<body>
<h2>${vehiculo != null ? 'Editar' : 'Registrar'} Vehículo</h2>
<form action="VehiculoServlet" method="post">
    <input type="hidden" name="accion" value="${vehiculo != null ? 'editar' : 'registrar'}"/>
    <label>Placa:</label>
    <input type="text" name="placa" value="${vehiculo.placa}" ${vehiculo != null ? 'readonly' : ''} required/><br/>

    <label>Marca:</label>
    <input type="text" name="marca" value="${vehiculo.marca}" required/><br/>

    <label>Color:</label>
    <input type="text" name="color" value="${vehiculo.color}" required/><br/>

    <label>Estilo:</label>
    <input type="text" name="estilo" value="${vehiculo.estilo}" required/><br/>

    <label>Año:</label>
    <input type="number" name="anno" value="${vehiculo.anno}" min="1900" max="2100" required/><br/>

    <label>VIN:</label>
    <input type="text" name="vin" value="${vehiculo.vin}" required/><br/>

    <label>Cilindraje:</label>
    <input type="number" name="cilindraje" value="${vehiculo.cilindraje}" step="0.1" required/><br/>

    <label>Cliente:</label>
    <select name="clienteId" required>
        <option value="">Seleccione</option>
        <c:forEach var="cli" items="${clientes}">
            <option value="${cli.id}" ${vehiculo != null && vehiculo.clienteId == cli.id ? 'selected' : '' }>
                    ${cli.nombre} ${cli.apellidos} (${cli.id})
            </option>
        </c:forEach>
    </select><br/>

    <input type="submit" value="${vehiculo != null ? 'Actualizar' : 'Registrar'}"/>
</form>
<p><a href="../../index.jsp">Volver</a></p>
</body>
</html>

