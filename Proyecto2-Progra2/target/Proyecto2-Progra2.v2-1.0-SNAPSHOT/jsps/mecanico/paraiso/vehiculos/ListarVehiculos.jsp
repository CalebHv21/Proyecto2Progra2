<%-- 
    Document   : ListarVehiculos
    Created on : Jun 29, 2025, 10:18:33 PM
    Author     : sebas
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lista de Vehículos - Mecánico Paraíso</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container-fluid mt-4">
            <div class="row">
                <div class="col-12">
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="card-title mb-0">
                                    <i class="fas fa-car"></i> Listado de Vehículos
                                </h3>
                                <small>Gestión de vehículos registrados</small>
                            </div>
                            <div>
                                <a href="vehiculo?accion=registrar" class="btn btn-light me-2">
                                    <i class="fas fa-plus"></i> Nuevo Vehículo
                                </a>
                                <a href="vehiculo?accion=gestionOrdenes" class="btn btn-info">
                                    <i class="fas fa-tools"></i> Gestión Órdenes
                                </a>
                            </div>
                        </div>
                        <div class="card-body">
                            <c:if test="${empty vehiculos}">
                                <div class="alert alert-info text-center" role="alert">
                                    <i class="fas fa-info-circle fa-2x mb-3"></i>
                                    <h5>No hay vehículos registrados</h5>
                                    <p>Comience registrando el primer vehículo en el sistema.</p>
                                    <a href="vehiculo?accion=registrar" class="btn btn-primary">
                                        <i class="fas fa-car"></i> Registrar Primer Vehículo
                                    </a>
                                </div>
                            </c:if>

                            <c:if test="${not empty vehiculos}">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead class="table-dark">
                                            <tr>
                                                <th><i class="fas fa-hashtag"></i> Placa</th>
                                                <th><i class="fas fa-car"></i> Vehículo</th>
                                                <th><i class="fas fa-palette"></i> Color</th>
                                                <th><i class="fas fa-car-side"></i> Estilo</th>
                                                <th><i class="fas fa-calendar"></i> Año</th>
                                                <th><i class="fas fa-tachometer-alt"></i> Cilindraje</th>
                                                <th><i class="fas fa-user"></i> Propietario</th>
                                                <th><i class="fas fa-phone"></i> Teléfono</th>
                                                <th><i class="fas fa-cogs"></i> Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="vehiculo" items="${vehiculos}">
                                                <tr>
                                                    <td>
                                                        <strong class="text-primary">${vehiculo.placa}</strong>
                                                    </td>
                                                    <td>
                                                        <div>
                                                            <strong>${vehiculo.marca}</strong>
                                                            <c:if test="${not empty vehiculo.modelo}">
                                                                <br><small class="text-muted">${vehiculo.modelo}</small>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-secondary">${vehiculo.color}</span>
                                                    </td>
                                                    <td>${vehiculo.estilo}</td>
                                                    <td>${vehiculo.anno}</td>
                                                    <td>${vehiculo.cilindraje}L</td>
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
                                                            <a href="tel:${vehiculo.telefonoPropietario}" class="text-decoration-none">
                                                                <i class="fas fa-phone text-success"></i> ${vehiculo.telefonoPropietario}
                                                            </a>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="vehiculo?accion=editar&placa=${vehiculo.placa}" 
                                                               class="btn btn-outline-primary btn-sm" title="Editar">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <a href="orden?accion=registrar&placa=${vehiculo.placa}" 
                                                               class="btn btn-outline-success btn-sm" title="Nueva Orden">
                                                                <i class="fas fa-plus"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-outline-info btn-sm" 
                                                                    title="Ver Detalles" data-bs-toggle="modal" 
                                                                    data-bs-target="#modalDetalle${vehiculo.placa.replaceAll('[^a-zA-Z0-9]', '')}">
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
                    </div>
                </div>
            </div>
        </div>

        <!-- Modales de detalle -->
        <c:forEach var="vehiculo" items="${vehiculos}">
            <div class="modal fade" id="modalDetalle${vehiculo.placa.replaceAll('[^a-zA-Z0-9]', '')}" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title">
                                <i class="fas fa-car"></i> Detalles: ${vehiculo.placa}
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6><strong>Información del Vehículo</strong></h6>
                                    <table class="table table-sm">
                                        <tr><td><strong>Placa:</strong></td><td>${vehiculo.placa}</td></tr>
                                        <tr><td><strong>Marca:</strong></td><td>${vehiculo.marca}</td></tr>
                                        <tr><td><strong>Modelo:</strong></td><td>${vehiculo.modelo}</td></tr>
                                        <tr><td><strong>Año:</strong></td><td>${vehiculo.anno}</td></tr>
                                        <tr><td><strong>Color:</strong></td><td>${vehiculo.color}</td></tr>
                                        <tr><td><strong>Estilo:</strong></td><td>${vehiculo.estilo}</td></tr>
                                        <tr><td><strong>Cilindraje:</strong></td><td>${vehiculo.cilindraje}L</td></tr>
                                        <tr><td><strong>VIN:</strong></td><td><small>${vehiculo.vin}</small></td></tr>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <h6><strong>Información del Propietario</strong></h6>
                                    <table class="table table-sm">
                                        <tr><td><strong>ID Cliente:</strong></td><td>${vehiculo.clienteId}</td></tr>
                                        <c:if test="${not empty vehiculo.nombrePropietario}">
                                            <tr><td><strong>Nombre:</strong></td><td>${vehiculo.nombrePropietario}</td></tr>
                                        </c:if>
                                        <c:if test="${not empty vehiculo.telefonoPropietario}">
                                            <tr><td><strong>Teléfono:</strong></td><td>${vehiculo.telefonoPropietario}</td></tr>
                                        </c:if>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <a href="vehiculo?accion=editar&placa=${vehiculo.placa}" class="btn btn-primary">
                                <i class="fas fa-edit"></i> Editar
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>