<%-- 
    Document   : ListarVehiculos
    Created on : Jul 2, 2025, 6:04:39 AM
    Author     : CalebHv21
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lista de Vehículos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container-fluid mt-4">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h3 class="card-title mb-0">Vehículos Registrados</h3>
                            <a href="vehiculo?accion=registrar" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Nuevo Vehículo
                            </a>
                        </div>
                        <div class="card-body">
                            <c:if test="${empty vehiculos}">
                                <div class="alert alert-info text-center" role="alert">
                                    <i class="fas fa-info-circle"></i> No hay vehículos registrados.
                                    <br>
                                    <a href="vehiculo?accion=registrar" class="btn btn-primary mt-2">
                                        <i class="fas fa-plus"></i> Registrar Primer Vehículo
                                    </a>
                                </div>
                            </c:if>

                            <c:if test="${not empty vehiculos}">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>Placa</th>
                                                <th>Vehículo</th>
                                                <th>Color</th>
                                                <th>Año</th>
                                                <th>Propietario</th>
                                                <th>Teléfono</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="vehiculo" items="${vehiculos}">
                                                <tr>
                                                    <td><strong>${vehiculo.placa}</strong></td>
                                                    <td>
                                                        <strong>${vehiculo.marca}</strong>
                                                        <c:if test="${not empty vehiculo.modelo}">
                                                            <br><small class="text-muted">${vehiculo.modelo}</small>
                                                        </c:if>
                                                    </td>
                                                    <td>${vehiculo.color}</td>
                                                    <td>${vehiculo.anno}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty vehiculo.nombrePropietario}">
                                                                ${vehiculo.nombrePropietario}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <small class="text-muted">ID: ${vehiculo.clienteId}</small>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:if test="${not empty vehiculo.telefonoPropietario}">
                                                            ${vehiculo.telefonoPropietario}
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="vehiculo?accion=editar&placa=${vehiculo.placa}" 
                                                               class="btn btn-outline-primary btn-sm">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-outline-info btn-sm" 
                                                                    data-bs-toggle="modal" data-bs-target="#modal${vehiculo.placa.replaceAll('[^a-zA-Z0-9]', '')}">
                                                                <i class="fas fa-eye"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </div>
                        <div class="card-footer text-center">
                            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">
                                <i class="fas fa-home"></i> Menú Principal
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modales para ver detalles -->
        <c:forEach var="vehiculo" items="${vehiculos}">
            <div class="modal fade" id="modal${vehiculo.placa.replaceAll('[^a-zA-Z0-9]', '')}" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Detalles del Vehículo</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <p><strong>Placa:</strong> ${vehiculo.placa}</p>
                            <p><strong>Marca:</strong> ${vehiculo.marca}</p>
                            <p><strong>Modelo:</strong> ${vehiculo.modelo}</p>
                            <p><strong>Año:</strong> ${vehiculo.anno}</p>
                            <p><strong>Color:</strong> ${vehiculo.color}</p>
                            <p><strong>Estilo:</strong> ${vehiculo.estilo}</p>
                            <p><strong>Cilindraje:</strong> ${vehiculo.cilindraje}L</p>
                            <c:if test="${not empty vehiculo.vin}">
                                <p><strong>VIN:</strong> ${vehiculo.vin}</p>
                            </c:if>
                            <hr>
                            <p><strong>Propietario ID:</strong> ${vehiculo.clienteId}</p>
                            <c:if test="${not empty vehiculo.nombrePropietario}">
                                <p><strong>Nombre:</strong> ${vehiculo.nombrePropietario}</p>
                            </c:if>
                            <c:if test="${not empty vehiculo.telefonoPropietario}">
                                <p><strong>Teléfono:</strong> ${vehiculo.telefonoPropietario}</p>
                            </c:if>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <a href="vehiculo?accion=editar&placa=${vehiculo.placa}" class="btn btn-primary">Editar</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>