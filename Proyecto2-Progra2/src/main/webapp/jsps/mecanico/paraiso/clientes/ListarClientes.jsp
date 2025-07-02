<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="mecanico.paraiso.domain.Cliente"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lista de Clientes</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container-fluid mt-4">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h3 class="card-title mb-0">Clientes Registrados</h3>
                            <a href="cliente?accion=registrar" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Nuevo Cliente
                            </a>
                        </div>
                        <div class="card-body">
                            <%
                                List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
                            %>
                            
                            <% if (clientes == null || clientes.isEmpty()) { %>
                                <div class="alert alert-info text-center" role="alert">
                                    <i class="fas fa-info-circle"></i> No hay clientes registrados.
                                    <br>
                                    <a href="cliente?accion=registrar" class="btn btn-primary mt-2">
                                        <i class="fas fa-plus"></i> Registrar Primer Cliente
                                    </a>
                                </div>
                            <% } else { %>
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>Cédula</th>
                                                <th>Nombre Completo</th>
                                                <th>Teléfono</th>
                                                <th>Correo</th>
                                                <th>Dirección</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (Cliente cliente : clientes) { %>
                                                <tr>
                                                    <td><strong><%= cliente.getId() %></strong></td>
                                                    <td><%= cliente.getNombre() %> <%= cliente.getApellidos() %></td>
                                                    <td><%= cliente.getTelefono() %></td>
                                                    <td><%= cliente.getCorreo() %></td>
                                                    <td>
                                                        <%= cliente.getDireccion().length() > 30 ? 
                                                            cliente.getDireccion().substring(0, 30) + "..." : 
                                                            cliente.getDireccion() %>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="cliente?accion=editar&id=<%= cliente.getId() %>" 
                                                               class="btn btn-outline-primary btn-sm">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-outline-info btn-sm" 
                                                                    data-bs-toggle="modal" data-bs-target="#modal<%= cliente.getId() %>">
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
        <% if (clientes != null) { %>
            <% for (Cliente cliente : clientes) { %>
                <div class="modal fade" id="modal<%= cliente.getId() %>" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Detalles del Cliente</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <p><strong>Cédula:</strong> <%= cliente.getId() %></p>
                                <p><strong>Nombre:</strong> <%= cliente.getNombre() %> <%= cliente.getApellidos() %></p>
                                <p><strong>Teléfono:</strong> <%= cliente.getTelefono() %></p>
                                <p><strong>Correo:</strong> <%= cliente.getCorreo() %></p>
                                <p><strong>Dirección:</strong> <%= cliente.getDireccion() %></p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                                <a href="cliente?accion=editar&id=<%= cliente.getId() %>" class="btn btn-primary">Editar</a>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>