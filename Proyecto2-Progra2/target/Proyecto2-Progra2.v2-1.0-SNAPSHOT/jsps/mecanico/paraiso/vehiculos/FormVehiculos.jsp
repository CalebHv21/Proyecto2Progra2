<%-- 
    Document   : FormVehiculos
    Created on : Jun 29, 2025, 10:18:23 PM
    Author     : sebas
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>${vehiculo != null ? 'Editar' : 'Registrar'} Vehículo</title>
</head>
<body>
<h2>${vehiculo != null ? 'Editar' : 'Registrar'} Vehículo</h2>

<c:if test="${not empty error}">
    <div style="color: red;">
        ${error}
    </div>
</c:if>

<form action="vehiculo" method="post">
    <input type="hidden" name="accion" value="${vehiculo != null ? 'editar' : 'registrar'}"/>
    <label>Placa:</label>
    <input type="text" name="placa" value="${vehiculo.placa}" <c:if test="${vehiculo != null}">readonly</c:if> required/><br/>

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
            <option value="${cli.id}" <c:if test="${vehiculo != null && vehiculo.clienteId == cli.id}">selected</c:if>>
                ${cli.nombre} ${cli.apellidos} (${cli.id})
            </option>
        </c:forEach>
    </select><br/>

    <input type="submit" value="${vehiculo != null ? 'Actualizar' : 'Registrar'}"/>
</form>
<p><a href="../../index.jsp">Volver</a></p>
</body>
</html>