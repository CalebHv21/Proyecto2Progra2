<%-- 
    Document   : ListarVehiculos
    Created on : Jun 29, 2025, 10:18:33 PM
    Author     : sebas
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Lista de Vehículos</title>
</head>
<body>
    <h2>Listado de Vehículos</h2>
    <p><a href="vehiculo?accion=registrar">Registrar nuevo vehículo</a></p>
    <table border="1" cellpadding="5" cellspacing="0">
        <thead>
            <tr>
                <th>Placa</th>
                <th>Marca</th>
                <th>Color</th>
                <th>Estilo</th>
                <th>Año</th>
                <th>VIN</th>
                <th>Cilindraje</th>
                <th>ID Cliente</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="vehiculo" items="${vehiculos}">
                <tr>
                    <td>${vehiculo.placa}</td>
                    <td>${vehiculo.marca}</td>
                    <td>${vehiculo.color}</td>
                    <td>${vehiculo.estilo}</td>
                    <td>${vehiculo.anno}</td>
                    <td>${vehiculo.vin}</td>
                    <td>${vehiculo.cilindraje}</td>
                    <td>${vehiculo.clienteId}</td>
                    <td>
                        <a href="vehiculo?accion=editar&placa=${vehiculo.placa}">Editar</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <p><a href="../../index.jsp">Volver</a></p>
</body>
</html>
