<%-- 
    Document   : FormOrden
    Created on : Jun 29, 2025, 10:17:37 PM
    Author     : sebas
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
        <title>Gestión de Órdenes de Trabajo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-4">
            <div class="row">
                <div class="col-md-8 offset-md-2">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <% OrdenTrabajo orden = (OrdenTrabajo) request.getAttribute("orden"); %>
                                <%= (orden != null) ? "Editar Orden de Trabajo" : "Nueva Orden de Trabajo" %>
                            </h3>
                        </div>
                        <div class="card-body">
                            <% String error = (String) request.getAttribute("error"); %>
                            <% if (error != null && !error.isEmpty()) { %>
                                <div class="alert alert-danger" role="alert">
                                    <%= error %>
                                </div>
                            <% } %>

                            <form action="orden" method="post">
                                <input type="hidden" name="accion" value="<%= (orden != null) ? "editar" : "registrar" %>">
                                <% if (orden != null) { %>
                                    <input type="hidden" name="id" value="<%= orden.getId() %>">
                                <% } %>

                                <div class="mb-3">
                                    <label for="placaVehiculo" class="form-label">Vehículo (Placa) *</label>
                                    <select class="form-select" id="placaVehiculo" name="placaVehiculo" required <%= (orden != null) ? "disabled" : "" %>>
                                        <option value="">Seleccione un vehículo...</option>
                                        <%
                                            List<Vehiculo> vehiculos = (List<Vehiculo>) request.getAttribute("vehiculos");
                                            if (vehiculos != null) {
                                                for (Vehiculo vehiculo : vehiculos) {
                                                    boolean selected = (orden != null && orden.getPlacaVehiculo().equals(vehiculo.getPlaca()));
                                        %>
                                            <option value="<%= vehiculo.getPlaca() %>" <%= selected ? "selected" : "" %>>
                                                <%= vehiculo.getPlaca() %> - <%= vehiculo.getMarca() %> <%= vehiculo.getModelo() %> (<%= vehiculo.getNombrePropietario() %>)
                                            </option>
                                        <% 
                                                }
                                            }
                                        %>
                                    </select>
                                    <% if (orden != null) { %>
                                        <input type="hidden" name="placaVehiculo" value="<%= orden.getPlacaVehiculo() %>">
                                    <% } %>
                                </div>

                                <div class="mb-3">
                                    <label for="fechaIngreso" class="form-label">Fecha de Ingreso *</label>
                                    <input type="date" class="form-control" id="fechaIngreso" name="fechaIngreso" 
                                           value="<%= (orden != null) ? new SimpleDateFormat("yyyy-MM-dd").format(orden.getFechaIngreso()) : "" %>" 
                                           <%= (orden != null) ? "readonly" : "required" %>>
                                </div>

                                <div class="mb-3">
                                    <label for="estado" class="form-label">Estado *</label>
                                    <select class="form-select" id="estado" name="estado" required>
                                        <option value="">Seleccione un estado...</option>
                                        <option value="Diagnóstico" <%= (orden != null && "Diagnóstico".equals(orden.getEstado())) ? "selected" : "" %>>Diagnóstico</option>
                                        <option value="En reparación" <%= (orden != null && "En reparación".equals(orden.getEstado())) ? "selected" : "" %>>En reparación</option>
                                        <option value="Listo para entrega" <%= (orden != null && "Listo para entrega".equals(orden.getEstado())) ? "selected" : "" %>>Listo para entrega</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="descripcionProblema" class="form-label">Descripción del Problema *</label>
                                    <textarea class="form-control" id="descripcionProblema" name="descripcionProblema" rows="3" required><%= (orden != null && orden.getDescripcionProblema() != null) ? orden.getDescripcionProblema() : "" %></textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="observaciones" class="form-label">Observaciones</label>
                                    <textarea class="form-control" id="observaciones" name="observaciones" rows="3"><%= (orden != null && orden.getObservaciones() != null) ? orden.getObservaciones() : "" %></textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="fechaEstimadaDevolucion" class="form-label">Fecha Estimada de Devolución *</label>
                                    <input type="date" class="form-control" id="fechaEstimadaDevolucion" name="fechaEstimadaDevolucion" 
                                           value="<%= (orden != null) ? new SimpleDateFormat("yyyy-MM-dd").format(orden.getFechaEstimadaDevolucion()) : "" %>" required>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <a href="orden" class="btn btn-secondary me-md-2">Cancelar</a>
                                    <button type="submit" class="btn btn-primary">
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