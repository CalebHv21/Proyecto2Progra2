<%-- 
    Document   : FormOrden
    Created on : Jul 2, 2025, 6:17:45 AM
    Author     : CalebHv21
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="mecanico.paraiso.domain.OrdenTrabajo"%>
<%@page import="mecanico.paraiso.domain.Vehiculo"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%= request.getAttribute("orden") != null ? "Editar" : "Nueva" %> Orden de Trabajo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-4">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title mb-0">
                                <% OrdenTrabajo orden = (OrdenTrabajo) request.getAttribute("orden"); %>
                                <%= (orden != null) ? "Editar" : "Nueva" %> Orden de Trabajo
                            </h3>
                        </div>
                        <div class="card-body">
                            <% String error = (String) request.getAttribute("error"); %>
                            <% if (error != null && !error.isEmpty()) { %>
                                <div class="alert alert-danger" role="alert">
                                    <strong>Error:</strong> <%= error %>
                                </div>
                            <% } %>

                            <form action="orden" method="post">
                                <input type="hidden" name="accion" value="<%= (orden != null) ? "editar" : "registrar" %>">
                                <% if (orden != null) { %>
                                    <input type="hidden" name="id" value="<%= orden.getId() %>">
                                <% } %>

                                <div class="mb-3">
                                    <label for="placaVehiculo" class="form-label">Vehículo *</label>
                                    <select class="form-select" id="placaVehiculo" name="placaVehiculo" required <%= (orden != null) ? "disabled" : "" %>>
                                        <option value="">Seleccione un vehículo</option>
                                        <%
                                            List<Vehiculo> vehiculos = (List<Vehiculo>) request.getAttribute("vehiculos");
                                            String placaSeleccionada = request.getParameter("placa");
                                            if (vehiculos != null) {
                                                for (Vehiculo vehiculo : vehiculos) {
                                                    boolean selected = false;
                                                    if (orden != null) {
                                                        selected = orden.getPlacaVehiculo().equals(vehiculo.getPlaca());
                                                    } else if (placaSeleccionada != null) {
                                                        selected = placaSeleccionada.equals(vehiculo.getPlaca());
                                                    }
                                        %>
                                            <option value="<%= vehiculo.getPlaca() %>" <%= selected ? "selected" : "" %>>
                                                <%= vehiculo.getPlaca() %> - <%= vehiculo.getMarca() %> <%= vehiculo.getModelo() %>
                                                <% if (vehiculo.getNombrePropietario() != null) { %>
                                                    (<%= vehiculo.getNombrePropietario() %>)
                                                <% } %>
                                            </option>
                                        <% 
                                                }
                                            }
                                        %>
                                    </select>
                                    <% if (orden != null) { %>
                                        <input type="hidden" name="placaVehiculo" value="<%= orden.getPlacaVehiculo() %>">
                                        <div class="form-text">El vehículo no se puede cambiar al editar</div>
                                    <% } %>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="fechaIngreso" class="form-label">Fecha de Ingreso *</label>
                                            <input type="date" 
                                                   class="form-control" 
                                                   id="fechaIngreso" 
                                                   name="fechaIngreso" 
                                                   value="<%= (orden != null) ? new SimpleDateFormat("yyyy-MM-dd").format(orden.getFechaIngreso()) : "" %>" 
                                                   <%= (orden != null) ? "readonly" : "required" %>>
                                            <% if (orden != null) { %>
                                                <div class="form-text">La fecha de ingreso no se puede modificar</div>
                                            <% } %>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="fechaEstimadaDevolucion" class="form-label">Fecha Estimada de Entrega *</label>
                                            <input type="date" 
                                                   class="form-control" 
                                                   id="fechaEstimadaDevolucion" 
                                                   name="fechaEstimadaDevolucion" 
                                                   value="<%= (orden != null) ? new SimpleDateFormat("yyyy-MM-dd").format(orden.getFechaEstimadaDevolucion()) : "" %>" 
                                                   required>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="estado" class="form-label">Estado *</label>
                                    <select class="form-select" id="estado" name="estado" required>
                                        <option value="">Seleccione un estado</option>
                                        <option value="Diagnóstico" <%= (orden != null && "Diagnóstico".equals(orden.getEstado())) ? "selected" : "" %>>Diagnóstico</option>
                                        <option value="En reparación" <%= (orden != null && "En reparación".equals(orden.getEstado())) ? "selected" : "" %>>En reparación</option>
                                        <option value="Listo para entrega" <%= (orden != null && "Listo para entrega".equals(orden.getEstado())) ? "selected" : "" %>>Listo para entrega</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="descripcionProblema" class="form-label">Descripción del Problema *</label>
                                    <textarea class="form-control" 
                                              id="descripcionProblema" 
                                              name="descripcionProblema" 
                                              rows="3" 
                                              required 
                                              maxlength="500"><%= (orden != null && orden.getDescripcionProblema() != null) ? orden.getDescripcionProblema() : "" %></textarea>
                                    <div class="form-text">Describa el problema o trabajo solicitado</div>
                                </div>

                                <div class="mb-3">
                                    <label for="observaciones" class="form-label">Observaciones</label>
                                    <textarea class="form-control" 
                                              id="observaciones" 
                                              name="observaciones" 
                                              rows="3" 
                                              maxlength="500"><%= (orden != null && orden.getObservaciones() != null) ? orden.getObservaciones() : "" %></textarea>
                                    <div class="form-text">Observaciones adicionales (opcional)</div>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <a href="orden" class="btn btn-secondary me-md-2">
                                        <i class="fas fa-arrow-left"></i> Volver a Lista
                                    </a>
                                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary me-md-2">
                                        <i class="fas fa-home"></i> Menú Principal
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i>
                                        <%= (orden != null) ? "Actualizar" : "Guardar" %>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>