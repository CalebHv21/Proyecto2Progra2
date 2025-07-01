<%-- 
    Document   : AgregarRepuestos
    Created on : Jun 29, 2025, 10:17:06 PM
    Author     : sebas
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Agregar Repuesto/Servicio a Orden</title>
</head>
<body>
<h2>Agregar Repuesto/Servicio a Orden #${orden.id}</h2>
<form action="OrdenServlet" method="post">
    <input type="hidden" name="accion" value="agregarRepuestoServicio"/>
    <input type="hidden" name="idOrden" value="${orden.id}"/>

    <label>Nombre:</label>
    <input type="text" name="nombre" required/><br/>

    <label>Cantidad:</label>
    <input type="number" name="cantidad" min="1" value="1" required/><br/>

    <label>Precio unitario:</label>
    <input type="number" name="precio" min="0" step="0.01" required/><br/>

    <label>¿Fue pedido?:</label>
    <input type="checkbox" name="fuePedido" value="true"/><br/>

    <label>Tipo:</label>
    <select name="esManoObra" required>
        <option value="false">Repuesto</option>
        <option value="true">Mano de obra</option>
    </select><br/>

    <input type="submit" value="Agregar"/>
</form>

<h3>Repuestos y Servicios Agregados</h3>
<table border="1">
    <tr>
        <th>Nombre</th><th>Cantidad</th><th>Precio</th><th>¿Pedido?</th><th>Tipo</th>
    </tr>
    <c:forEach var="rs" items="${orden.repuestosServicios}">
        <tr>
            <td>${rs.nombre}</td>
            <td>${rs.cantidad}</td>
            <td>${rs.precio}</td>
            <td>${rs.fuePedido ? "Sí" : "No"}</td>
            <td>${rs.esManoObra ? "Mano de obra" : "Repuesto"}</td>
        </tr>
    </c:forEach>
</table>
<p><strong>Costo total acumulado:</strong> ₡${orden.costoTotal}</p>
<p><a href="../../index.jsp">Volver</a></p>
</body>
</html>

