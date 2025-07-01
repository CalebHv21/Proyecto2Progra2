<%-- 
    Document   : FormCliente
    Created on : Jun 29, 2025, 10:16:37 PM
    Author     : sebas
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${cliente != null ? 'Editar' : 'Registrar'} Cliente</title>
</head>
<body>
    <h2>${cliente != null ? 'Editar' : 'Registrar'} Cliente</h2>
    
    <!-- Mostrar mensajes de error si existen -->
    <c:if test="${not empty error}">
        <div style="color: red; background-color: #ffeeee; padding: 10px; border: 1px solid red; margin-bottom: 10px;">
            <strong>Error:</strong> ${error}
        </div>
    </c:if>
    
    <form action="ClienteServlet" method="post">
        <input type="hidden" name="accion" value="${cliente != null ? 'editar' : 'registrar'}"/>
        
        <table>
            <tr>
                <td><label for="id">Cédula:</label></td>
                <td>
                    <input type="text" 
                           id="id" 
                           name="id" 
                           value="${cliente != null ? cliente.id : ''}" 
                           ${cliente != null ? 'readonly' : ''} 
                           required 
                           maxlength="20"/>
                </td>
            </tr>
            <tr>
                <td><label for="nombre">Nombre:</label></td>
                <td>
                    <input type="text" 
                           id="nombre" 
                           name="nombre" 
                           value="${cliente != null ? cliente.nombre : ''}" 
                           required 
                           maxlength="50"/>
                </td>
            </tr>
            <tr>
                <td><label for="apellidos">Apellidos:</label></td>
                <td>
                    <input type="text" 
                           id="apellidos" 
                           name="apellidos" 
                           value="${cliente != null ? cliente.apellidos : ''}" 
                           required 
                           maxlength="50"/>
                </td>
            </tr>
            <tr>
                <td><label for="telefono">Teléfono:</label></td>
                <td>
                    <input type="text" 
                           id="telefono" 
                           name="telefono" 
                           value="${cliente != null ? cliente.telefono : ''}" 
                           required 
                           maxlength="20"/>
                </td>
            </tr>
            <tr>
                <td><label for="direccion">Dirección:</label></td>
                <td>
                    <input type="text" 
                           id="direccion" 
                           name="direccion" 
                           value="${cliente != null ? cliente.direccion : ''}" 
                           required 
                           maxlength="100"/>
                </td>
            </tr>
            <tr>
                <td><label for="correo">Correo electrónico:</label></td>
                <td>
                    <input type="email" 
                           id="correo" 
                           name="correo" 
                           value="${cliente != null ? cliente.correo : ''}" 
                           required 
                           maxlength="50"/>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center; padding-top: 20px;">
                    <input type="submit" value="${cliente != null ? 'Actualizar' : 'Registrar'}" style="padding: 10px 20px;"/>
                    <input type="button" value="Cancelar" onclick="window.location.href='ClienteServlet'" style="padding: 10px 20px; margin-left: 10px;"/>
                </td>
            </tr>
        </table>
    </form>
    
    <div style="margin-top: 20px;">
        <p><a href="ClienteServlet">← Volver a Lista de Clientes</a></p>
        <p><a href="${pageContext.request.contextPath}/index.jsp">← Volver al Inicio</a></p>
    </div>
</body>
</html>