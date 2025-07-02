<%-- 
    Document   : AgregarRepuestos
    Created on : Jul 2, 2025, 6:18:15 AM
    Author     : CalebHv21
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Agregar Repuestos/Servicios - Orden #${orden.id}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-4">
            <div class="row justify-content-center">
                <div class="col-md-10">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title mb-0">
                                Gestionar Repuestos/Servicios - Orden #${orden.id}
                            </h3>
                            <small class="text-muted">Vehículo: ${orden.placaVehiculo} | Estado: ${orden.estado}</small>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" role="alert">
                                    <strong>Error:</strong> ${error}
                                </div>
                            </c:if>

                            <!-- Formulario para agregar repuesto/servicio -->
                            <div class="row">
                                <div class="col-md-5">
                                    <h5>Agregar Nuevo Item</h5>
                                    <form action="orden" method="post">
                                        <input type="hidden" name="accion" value="agregarRepuestoServicio"/>
                                        <input type="hidden" name="idOrden" value="${orden.id}"/>

                                        <div class="mb-3">
                                            <label for="nombre" class="form-label">Nombre *</label>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="nombre" 
                                                   name="nombre" 
                                                   required 
                                                   maxlength="100"
                                                   placeholder="Ej: Filtro de aceite, Cambio de aceite"/>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="cantidad" class="form-label">Cantidad *</label>
                                                    <input type="number" 
                                                           class="form-control" 
                                                           id="cantidad" 
                                                           name="cantidad" 
                                                           min="1" 
                                                           max="100"
                                                           value="1" 
                                                           required/>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="precio" class="form-label">Precio Unitario *</label>
                                                    <div class="input-group">
                                                        <span class="input-group-text">$</span>
                                                        <input type="number" 
                                                               class="form-control" 
                                                               id="precio" 
                                                               name="precio" 
                                                               min="0" 
                                                               step="0.01" 
                                                               required/>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="esManoObra" class="form-label">Tipo *</label>
                                            <select class="form-select" id="esManoObra" name="esManoObra" required>
                                                <option value="">Seleccione el tipo</option>
                                                <option value="false">Repuesto</option>
                                                <option value="true">Servicio (Mano de obra)</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <div class="form-check">
                                                <input class="form-check-input" 
                                                       type="checkbox" 
                                                       id="fuePedido" 
                                                       name="fuePedido" 
                                                       value="true"/>
                                                <label class="form-check-label" for="fuePedido">
                                                    ¿Ya fue pedido/solicitado?
                                                </label>
                                            </div>
                                        </div>

                                        <div class="d-grid">
                                            <button type="submit" class="btn btn-success">
                                                <i class="fas fa-plus"></i> Agregar Item
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- Lista de repuestos/servicios -->
                                <div class="col-md-7">
                                    <h5>Items Agregados (${orden.repuestosServicios.size()})</h5>
                                    
                                    <c:choose>
                                        <c:when test="${empty orden.repuestosServicios}">
                                            <div class="alert alert-info text-center">
                                                <i class="fas fa-info-circle"></i> No hay repuestos o servicios agregados.
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table table-striped table-sm">
                                                    <thead class="table-dark">
                                                        <tr>
                                                            <th>Nombre</th>
                                                            <th>Cant.</th>
                                                            <th>Precio Unit.</th>
                                                            <th>Subtotal</th>
                                                            <th>Tipo</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <%
                                                            DecimalFormat df = new DecimalFormat("#,##0.00");
                                                        %>
                                                        <c:forEach var="rs" items="${orden.repuestosServicios}">
                                                            <tr>
                                                                <td>
                                                                    <strong>${rs.nombre}</strong>
                                                                    <c:if test="${rs.fuePedido}">
                                                                        <br><small class="text-success">
                                                                            <i class="fas fa-check-circle"></i> Pedido
                                                                        </small>
                                                                    </c:if>
                                                                    <c:if test="${!rs.fuePedido}">
                                                                        <br><small class="text-warning">
                                                                            <i class="fas fa-clock"></i> Pendiente
                                                                        </small>
                                                                    </c:if>
                                                                </td>
                                                                <td>${rs.cantidad}</td>
                                                                <td class="text-end">$<%= df.format(Double.parseDouble(pageContext.getAttribute("rs") != null ? ((mecanico.paraiso.domain.RepuestoServicio)pageContext.getAttribute("rs")).getPrecio() + "" : "0")) %></td>
                                                                <td class="text-end">
                                                                    <strong>$<%= df.format(Double.parseDouble(pageContext.getAttribute("rs") != null ? ((mecanico.paraiso.domain.RepuestoServicio)pageContext.getAttribute("rs")).getCantidad() * ((mecanico.paraiso.domain.RepuestoServicio)pageContext.getAttribute("rs")).getPrecio() + "" : "0")) %></strong>
                                                                </td>
                                                                <td>
                                                                    <span class="badge ${rs.esManoObra ? 'bg-info' : 'bg-secondary'}">
                                                                        ${rs.esManoObra ? 'Servicio' : 'Repuesto'}
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr class="table-success">
                                                            <th colspan="3">TOTAL</th>
                                                            <th class="text-end">
                                                                $<%= df.format(Double.parseDouble(request.getAttribute("orden") != null ? ((mecanico.paraiso.domain.OrdenTrabajo)request.getAttribute("orden")).getCostoTotal() + "" : "0")) %>
                                                            </th>
                                                            <th></th>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer text-center">
                            <a href="orden?accion=editar&id=${orden.id}" class="btn btn-primary me-2">
                                <i class="fas fa-edit"></i> Editar Orden
                            </a>
                            <a href="orden" class="btn btn-secondary me-2">
                                <i class="fas fa-list"></i> Lista de Órdenes
                            </a>
                            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary">
                                <i class="fas fa-home"></i> Menú Principal
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>