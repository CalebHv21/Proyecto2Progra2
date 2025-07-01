<%-- 
    Document   : ListarOrdenes
    Created on : Jun 29, 2025, 10:18:02 PM
    Author     : sebas
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="mecanico.paraiso.domain.OrdenTrabajo"%>
<%@page import="mecanico.paraiso.domain.RepuestoServicio"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lista de Órdenes de Trabajo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container-fluid mt-4">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h3 class="card-title mb-0">Órdenes de Trabajo</h3>
                            <a href="orden?accion=registrar" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Nueva Orden
                            </a>
                        </div>
                        <div class="card-body">
                            <%
                                List<OrdenTrabajo> ordenes = (List<OrdenTrabajo>) request.getAttribute("ordenes");
                                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                DecimalFormat df = new DecimalFormat("#,##0.00");
                            %>
                            
                            <% if (ordenes == null || ordenes.isEmpty()) { %>
                                <div class="alert alert-info text-center" role="alert">
                                    <i class="fas fa-info-circle"></i> No hay órdenes de trabajo registradas.
                                </div>
                            <% } else { %>
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Placa Vehículo</th>
                                                <th>Fecha Ingreso</th>
                                                <th>Estado</th>
                                                <th>Descripción</th>
                                                <th>Fecha Est. Devolución</th>
                                                <th>Costo Total</th>
                                                <th>Repuestos/Servicios</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (OrdenTrabajo orden : ordenes) { %>
                                                <tr>
                                                    <td><strong>#<%= orden.getId() %></strong></td>
                                                    <td><%= orden.getPlacaVehiculo() %></td>
                                                    <td><%= sdf.format(orden.getFechaIngreso()) %></td>
                                                    <td>
                                                        <%
                                                            String badgeClass = "";
                                                            switch (orden.getEstado()) {
                                                                case "Diagnóstico":
                                                                    badgeClass = "bg-warning text-dark";
                                                                    break;
                                                                case "En reparación":
                                                                    badgeClass = "bg-info text-dark";
                                                                    break;
                                                                case "Listo para entrega":
                                                                    badgeClass = "bg-success";
                                                                    break;
                                                                default:
                                                                    badgeClass = "bg-secondary";
                                                            }
                                                        %>
                                                        <span class="badge <%= badgeClass %>"><%= orden.getEstado() %></span>
                                                    </td>
                                                    <td>
                                                        <span title="<%= orden.getDescripcionProblema() %>">
                                                            <%= orden.getDescripcionProblema().length() > 50 ? 
                                                                orden.getDescripcionProblema().substring(0, 50) + "..." : 
                                                                orden.getDescripcionProblema() %>
                                                        </span>
                                                    </td>
                                                    <td><%= sdf.format(orden.getFechaEstimadaDevolucion()) %></td>
                                                    <td class="text-end">
                                                        <strong>$<%= df.format(orden.getCostoTotal()) %></strong>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge bg-primary">
                                                            <%= orden.getRepuestosServicios().size() %> items
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="orden?accion=editar&id=<%= orden.getId() %>" 
                                                               class="btn btn-outline-primary btn-sm" title="Editar">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <a href="orden?accion=agregarRepuestoServicio&id=<%= orden.getId() %>" 
                                                               class="btn btn-outline-success btn-sm" title="Agregar Repuesto/Servicio">
                                                                <i class="fas fa-plus"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-outline-info btn-sm" 
                                                                    data-bs-toggle="modal" data-bs-target="#detalleModal<%= orden.getId() %>" 
                                                                    title="Ver Detalles">
                                                                <i class="fas fa-eye"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modales para ver detalles de cada orden -->
        <% if (ordenes != null) { %>
            <% for (OrdenTrabajo orden : ordenes) { %>
                <div class="modal fade" id="detalleModal<%= orden.getId() %>" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Detalle de Orden #<%= orden.getId() %></h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6><strong>Información General</strong></h6>
                                        <p><strong>Placa:</strong> <%= orden.getPlacaVehiculo() %></p>
                                        <p><strong>Fecha Ingreso:</strong> <%= sdf.format(orden.getFechaIngreso()) %></p>
                                        <p><strong>Estado:</strong> <span class="badge <%= 
                                            orden.getEstado().equals("Diagnóstico") ? "bg-warning text-dark" :
                                            orden.getEstado().equals("En reparación") ? "bg-info text-dark" :
                                            orden.getEstado().equals("Listo para entrega") ? "bg-success" : "bg-secondary"
                                        %>"><%= orden.getEstado() %></span></p>
                                        <p><strong>Fecha Est. Devolución:</strong> <%= sdf.format(orden.getFechaEstimadaDevolucion()) %></p>
                                    </div>
                                    <div class="col-md-6">
                                        <h6><strong>Descripción del Problema</strong></h6>
                                        <p><%= orden.getDescripcionProblema() %></p>
                                        <% if (orden.getObservaciones() != null && !orden.getObservaciones().trim().isEmpty()) { %>
                                            <h6><strong>Observaciones</strong></h6>
                                            <p><%= orden.getObservaciones() %></p>
                                        <% } %>
                                    </div>
                                </div>
                                
                                <hr>
                                
                                <h6><strong>Repuestos y Servicios</strong></h6>
                                <% if (orden.getRepuestosServicios().isEmpty()) { %>
                                    <p class="text-muted">No hay repuestos o servicios agregados.</p>
                                <% } else { %>
                                    <div class="table-responsive">
                                        <table class="table table-sm">
                                            <thead>
                                                <tr>
                                                    <th>Nombre</th>
                                                    <th>Cantidad</th>
                                                    <th>Precio Unit.</th>
                                                    <th>Subtotal</th>
                                                    <th>Tipo</th>
                                                    <th>Estado</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for (RepuestoServicio rs : orden.getRepuestosServicios()) { %>
                                                    <tr>
                                                        <td><%= rs.getNombre() %></td>
                                                        <td><%= rs.getCantidad() %></td>
                                                        <td class="text-end">$<%= df.format(rs.getPrecio()) %></td>
                                                        <td class="text-end"><strong>$<%= df.format(rs.getCantidad() * rs.getPrecio()) %></strong></td>
                                                        <td>
                                                            <span class="badge <%= rs.isEsManoObra() ? "bg-info" : "bg-secondary" %>">
                                                                <%= rs.isEsManoObra() ? "Mano de Obra" : "Repuesto" %>
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span class="badge <%= rs.isFuePedido() ? "bg-success" : "bg-warning text-dark" %>">
                                                                <%= rs.isFuePedido() ? "Pedido" : "Pendiente" %>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                <% } %>
                                            </tbody>
                                            <tfoot>
                                                <tr class="table-dark">
                                                    <th colspan="3">TOTAL</th>
                                                    <th class="text-end">$<%= df.format(orden.getCostoTotal()) %></th>
                                                    <th colspan="2"></th>
                                                </tr>
                                            </tfoot>
                                        </table>
                                    </div>
                                <% } %>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                                <a href="orden?accion=editar&id=<%= orden.getId() %>" class="btn btn-primary">Editar</a>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>