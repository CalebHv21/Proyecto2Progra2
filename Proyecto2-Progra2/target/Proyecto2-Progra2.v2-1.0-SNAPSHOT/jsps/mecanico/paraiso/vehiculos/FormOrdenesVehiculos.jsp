<%-- 
    Document   : FormOrdenesVehiculos
    Created on : Jun 29, 2025, 10:18:12 PM
    Author     : sebas
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="mecanico.paraiso.domain.OrdenTrabajo"%>
<%@page import="mecanico.paraiso.domain.Vehiculo"%>
<%@page import="mecanico.paraiso.domain.RepuestoServicio"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestión de Órdenes por Vehículo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .card-vehicle {
                transition: transform 0.2s;
            }
            .card-vehicle:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }
            .status-badge {
                font-size: 0.75rem;
            }
            .vehicle-info {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            .order-summary {
                border-left: 4px solid #007bff;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid mt-4">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="card-title mb-0">
                                    <i class="fas fa-car"></i> Gestión de Órdenes por Vehículo
                                </h3>
                                <small class="text-muted">Vista integrada de vehículos y sus órdenes de trabajo</small>
                            </div>
                            <div>
                                <a href="orden?accion=registrar" class="btn btn-primary me-2">
                                    <i class="fas fa-plus"></i> Nueva Orden
                                </a>
                                <a href="vehiculo?accion=registrar" class="btn btn-success">
                                    <i class="fas fa-car-side"></i> Nuevo Vehículo
                                </a>
                            </div>
                        </div>
                        <div class="card-body">
                            <%
                                List<Vehiculo> vehiculos = (List<Vehiculo>) request.getAttribute("vehiculos");
                                List<OrdenTrabajo> ordenes = (List<OrdenTrabajo>) request.getAttribute("ordenes");
                                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                DecimalFormat df = new DecimalFormat("#,##0.00");
                                
                                // Crear un mapa para agrupar órdenes por vehículo
                                Map<String, List<OrdenTrabajo>> ordenesPorVehiculo = new HashMap<>();
                                if (ordenes != null) {
                                    for (OrdenTrabajo orden : ordenes) {
                                        String placa = orden.getPlacaVehiculo();
                                        if (!ordenesPorVehiculo.containsKey(placa)) {
                                            ordenesPorVehiculo.put(placa, new ArrayList<>());
                                        }
                                        ordenesPorVehiculo.get(placa).add(orden);
                                    }
                                }
                            %>
                            
                            <% if (vehiculos == null || vehiculos.isEmpty()) { %>
                                <div class="alert alert-info text-center" role="alert">
                                    <i class="fas fa-info-circle fa-2x mb-3"></i>
                                    <h5>No hay vehículos registrados</h5>
                                    <p>Para comenzar a gestionar órdenes de trabajo, primero debe registrar vehículos.</p>
                                    <a href="vehiculo?accion=registrar" class="btn btn-success">
                                        <i class="fas fa-car-side"></i> Registrar Primer Vehículo
                                    </a>
                                </div>
                            <% } else { %>
                                <!-- Filtros y búsqueda -->
                                <div class="row mb-4">
                                    <div class="col-md-4">
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-search"></i></span>
                                            <input type="text" class="form-control" id="searchVehicle" 
                                                   placeholder="Buscar por placa, marca o propietario...">
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" id="filterEstado">
                                            <option value="">Todos los estados</option>
                                            <option value="sin-ordenes">Sin órdenes</option>
                                            <option value="Diagnóstico">Con órdenes en Diagnóstico</option>
                                            <option value="En reparación">Con órdenes en Reparación</option>
                                            <option value="Listo para entrega">Listo para Entrega</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" id="filterMarca">
                                            <option value="">Todas las marcas</option>
                                            <%
                                                List<String> marcas = new ArrayList<>();
                                                for (Vehiculo v : vehiculos) {
                                                    if (!marcas.contains(v.getMarca())) {
                                                        marcas.add(v.getMarca());
                                                    }
                                                }
                                                for (String marca : marcas) {
                                            %>
                                                <option value="<%= marca %>"><%= marca %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="button" class="btn btn-outline-secondary w-100" onclick="clearFilters()">
                                            <i class="fas fa-times"></i> Limpiar
                                        </button>
                                    </div>
                                </div>

                                <!-- Grid de vehículos con sus órdenes -->
                                <div class="row" id="vehiculosContainer">
                                    <% for (Vehiculo vehiculo : vehiculos) { %>
                                        <%
                                            List<OrdenTrabajo> ordenesVehiculo = ordenesPorVehiculo.get(vehiculo.getPlaca());
                                            if (ordenesVehiculo == null) ordenesVehiculo = new ArrayList<>();
                                            
                                            // Calcular estadísticas
                                            int ordenesActivas = 0;
                                            double costoTotal = 0;
                                            String ultimoEstado = "Sin órdenes";
                                            
                                            for (OrdenTrabajo orden : ordenesVehiculo) {
                                                if (!"Listo para entrega".equals(orden.getEstado())) {
                                                    ordenesActivas++;
                                                }
                                                costoTotal += orden.getCostoTotal();
                                                ultimoEstado = orden.getEstado();
                                            }
                                        %>
                                        
                                        <div class="col-lg-6 col-xl-4 mb-4 vehicle-card" 
                                             data-placa="<%= vehiculo.getPlaca().toLowerCase() %>"
                                             data-marca="<%= vehiculo.getMarca().toLowerCase() %>"
                                             data-propietario="<%= vehiculo.getNombrePropietario().toLowerCase() %>"
                                             data-estado="<%= ordenesVehiculo.isEmpty() ? "sin-ordenes" : ultimoEstado %>">
                                            <div class="card card-vehicle h-100">
                                                <!-- Header del vehículo -->
                                                <div class="card-header vehicle-info">
                                                    <div class="d-flex justify-content-between align-items-start">
                                                        <div>
                                                            <h5 class="mb-1">
                                                                <i class="fas fa-car"></i> <%= vehiculo.getPlaca() %>
                                                            </h5>
                                                            <p class="mb-0 small">
                                                                <%= vehiculo.getMarca() %> <%= vehiculo.getModelo() %> (<%= vehiculo.getAnno() %>)
                                                            </p>
                                                        </div>
                                                        <div class="text-end">
                                                            <span class="badge bg-light text-dark">
                                                                <%= ordenesVehiculo.size() %> orden<%= ordenesVehiculo.size() != 1 ? "es" : "" %>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="card-body">
                                                    <!-- Información del propietario -->
                                                    <div class="mb-3">
                                                        <small class="text-muted">Propietario:</small>
                                                        <p class="mb-1"><strong><%= vehiculo.getNombrePropietario() %></strong></p>
                                                        <p class="mb-0 small text-muted">
                                                            <i class="fas fa-phone"></i> <%= vehiculo.getTelefonoPropietario() %>
                                                        </p>
                                                    </div>

                                                    <!-- Resumen de órdenes -->
                                                    <% if (ordenesVehiculo.isEmpty()) { %>
                                                        <div class="alert alert-light text-center py-2" role="alert">
                                                            <i class="fas fa-info-circle"></i> Sin órdenes registradas
                                                        </div>
                                                    <% } else { %>
                                                        <div class="order-summary p-2 mb-3 bg-light rounded">
                                                            <div class="row text-center">
                                                                <div class="col-4">
                                                                    <small class="text-muted d-block">Activas</small>
                                                                    <strong class="text-warning"><%= ordenesActivas %></strong>
                                                                </div>
                                                                <div class="col-4">
                                                                    <small class="text-muted d-block">Total</small>
                                                                    <strong class="text-primary"><%= ordenesVehiculo.size() %></strong>
                                                                </div>
                                                                <div class="col-4">
                                                                    <small class="text-muted d-block">Costo</small>
                                                                    <strong class="text-success">$<%= df.format(costoTotal) %></strong>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Lista de órdenes recientes -->
                                                        <div class="mb-3">
                                                            <small class="text-muted">Órdenes recientes:</small>
                                                            <% 
                                                                int maxMostrar = Math.min(3, ordenesVehiculo.size());
                                                                for (int i = ordenesVehiculo.size() - 1; i >= ordenesVehiculo.size() - maxMostrar; i--) {
                                                                    OrdenTrabajo orden = ordenesVehiculo.get(i);
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
                                                                <div class="d-flex justify-content-between align-items-center py-1 border-bottom">
                                                                    <div>
                                                                        <small><strong>#<%= orden.getId() %></strong></small>
                                                                        <br>
                                                                        <small class="text-muted"><%= sdf.format(orden.getFechaIngreso()) %></small>
                                                                    </div>
                                                                    <div class="text-end">
                                                                        <span class="badge status-badge <%= badgeClass %>"><%= orden.getEstado() %></span>
                                                                        <br>
                                                                        <small class="text-success">$<%= df.format(orden.getCostoTotal()) %></small>
                                                                    </div>
                                                                </div>
                                                            <% } %>
                                                            
                                                            <% if (ordenesVehiculo.size() > 3) { %>
                                                                <div class="text-center mt-2">
                                                                    <small class="text-muted">... y <%= ordenesVehiculo.size() - 3 %> más</small>
                                                                </div>
                                                            <% } %>
                                                        </div>
                                                    <% } %>
                                                </div>

                                                <!-- Footer con acciones -->
                                                <div class="card-footer bg-transparent">
                                                    <div class="d-grid gap-2">
                                                        <div class="btn-group" role="group">
                                                            <a href="orden?accion=registrar&placa=<%= vehiculo.getPlaca() %>" 
                                                               class="btn btn-outline-primary btn-sm">
                                                                <i class="fas fa-plus"></i> Nueva Orden
                                                            </a>
                                                            <button type="button" class="btn btn-outline-info btn-sm" 
                                                                    data-bs-toggle="modal" data-bs-target="#modalVehiculo<%= vehiculo.getPlaca().replaceAll("[^a-zA-Z0-9]", "") %>">
                                                                <i class="fas fa-eye"></i> Ver Todo
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Modal para ver detalles completos del vehículo -->
                                        <div class="modal fade" id="modalVehiculo<%= vehiculo.getPlaca().replaceAll("[^a-zA-Z0-9]", "") %>" tabindex="-1">
                                            <div class="modal-dialog modal-xl">
                                                <div class="modal-content">
                                                    <div class="modal-header vehicle-info">
                                                        <h5 class="modal-title">
                                                            <i class="fas fa-car"></i> Detalles: <%= vehiculo.getPlaca() %> - <%= vehiculo.getMarca() %> <%= vehiculo.getModelo() %>
                                                        </h5>
                                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <div class="row">
                                                            <!-- Información del vehículo -->
                                                            <div class="col-md-4">
                                                                <h6><strong>Información del Vehículo</strong></h6>
                                                                <table class="table table-sm">
                                                                    <tr><td><strong>Placa:</strong></td><td><%= vehiculo.getPlaca() %></td></tr>
                                                                    <tr><td><strong>Marca:</strong></td><td><%= vehiculo.getMarca() %></td></tr>
                                                                    <tr><td><strong>Modelo:</strong></td><td><%= vehiculo.getModelo() %></td></tr>
                                                                    <tr><td><strong>Año:</strong></td><td><%= vehiculo.getAnno() %></td></tr>
                                                                    <tr><td><strong>Color:</strong></td><td><%= vehiculo.getColor() %></td></tr>
                                                                </table>

                                                                <h6><strong>Propietario</strong></h6>
                                                                <table class="table table-sm">
                                                                    <tr><td><strong>Nombre:</strong></td><td><%= vehiculo.getNombrePropietario() %></td></tr>
                                                                    <tr><td><strong>Teléfono:</strong></td><td><%= vehiculo.getTelefonoPropietario() %></td></tr>
                                                                </table>
                                                            </div>

                                                            <!-- Historial de órdenes -->
                                                            <div class="col-md-8">
                                                                <h6><strong>Historial de Órdenes (<%= ordenesVehiculo.size() %>)</strong></h6>
                                                                <% if (ordenesVehiculo.isEmpty()) { %>
                                                                    <div class="alert alert-info">
                                                                        <i class="fas fa-info-circle"></i> No hay órdenes registradas para este vehículo.
                                                                    </div>
                                                                <% } else { %>
                                                                    <div class="table-responsive">
                                                                        <table class="table table-striped table-sm">
                                                                            <thead class="table-dark">
                                                                                <tr>
                                                                                    <th>ID</th>
                                                                                    <th>Fecha</th>
                                                                                    <th>Estado</th>
                                                                                    <th>Descripción</th>
                                                                                    <th>Costo</th>
                                                                                    <th>Acciones</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <% for (OrdenTrabajo orden : ordenesVehiculo) { %>
                                                                                    <tr>
                                                                                        <td><strong>#<%= orden.getId() %></strong></td>
                                                                                        <td><%= sdf.format(orden.getFechaIngreso()) %></td>
                                                                                        <td>
                                                                                            <span class="badge status-badge <%= 
                                                                                                orden.getEstado().equals("Diagnóstico") ? "bg-warning text-dark" :
                                                                                                orden.getEstado().equals("En reparación") ? "bg-info text-dark" :
                                                                                                orden.getEstado().equals("Listo para entrega") ? "bg-success" : "bg-secondary"
                                                                                            %>"><%= orden.getEstado() %></span>
                                                                                        </td>
                                                                                        <td>
                                                                                            <span title="<%= orden.getDescripcionProblema() %>">
                                                                                                <%= orden.getDescripcionProblema().length() > 30 ? 
                                                                                                    orden.getDescripcionProblema().substring(0, 30) + "..." : 
                                                                                                    orden.getDescripcionProblema() %>
                                                                                            </span>
                                                                                        </td>
                                                                                        <td class="text-end">$<%= df.format(orden.getCostoTotal()) %></td>
                                                                                        <td>
                                                                                            <div class="btn-group" role="group">
                                                                                                <a href="orden?accion=editar&id=<%= orden.getId() %>" 
                                                                                                   class="btn btn-outline-primary btn-sm" title="Editar">
                                                                                                    <i class="fas fa-edit"></i>
                                                                                                </a>
                                                                                                <a href="orden?accion=agregarRepuestoServicio&id=<%= orden.getId() %>" 
                                                                                                   class="btn btn-outline-success btn-sm" title="Agregar">
                                                                                                    <i class="fas fa-plus"></i>
                                                                                                </a>
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
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                                                        <a href="orden?accion=registrar&placa=<%= vehiculo.getPlaca() %>" class="btn btn-primary">
                                                            <i class="fas fa-plus"></i> Nueva Orden
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    <% } %>
                                </div>

                                <!-- Mensaje cuando no hay resultados de filtro -->
                                <div id="noResults" class="alert alert-warning text-center" style="display: none;">
                                    <i class="fas fa-search"></i> No se encontraron vehículos que coincidan con los filtros aplicados.
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // Funciones de filtrado
            function filterVehicles() {
                const searchTerm = document.getElementById('searchVehicle').value.toLowerCase();
                const estadoFilter = document.getElementById('filterEstado').value;
                const marcaFilter = document.getElementById('filterMarca').value.toLowerCase();
                
                const vehicles = document.querySelectorAll('.vehicle-card');
                let visibleCount = 0;
                
                vehicles.forEach(vehicle => {
                    const placa = vehicle.dataset.placa;
                    const marca = vehicle.dataset.marca;
                    const propietario = vehicle.dataset.propietario;
                    const estado = vehicle.dataset.estado;
                    
                    let matchesSearch = searchTerm === '' || 
                                      placa.includes(searchTerm) || 
                                      marca.includes(searchTerm) || 
                                      propietario.includes(searchTerm);
                    
                    let matchesEstado = estadoFilter === '' || estado === estadoFilter;
                    let matchesMarca = marcaFilter === '' || marca.includes(marcaFilter);
                    
                    if (matchesSearch && matchesEstado && matchesMarca) {
                        vehicle.style.display = 'block';
                        visibleCount++;
                    } else {
                        vehicle.style.display = 'none';
                    }
                });
                
                // Mostrar mensaje si no hay resultados
                document.getElementById('noResults').style.display = visibleCount === 0 ? 'block' : 'none';
            }
            
            function clearFilters() {
                document.getElementById('searchVehicle').value = '';
                document.getElementById('filterEstado').value = '';
                document.getElementById('filterMarca').value = '';
                filterVehicles();
            }
            
            // Event listeners
            document.getElementById('searchVehicle').addEventListener('input', filterVehicles);
            document.getElementById('filterEstado').addEventListener('change', filterVehicles);
            document.getElementById('filterMarca').addEventListener('change', filterVehicles);
            
            // Auto-refresh cada 30 segundos para órdenes activas
            setInterval(function() {
                // Solo refresh si hay órdenes activas
                const activeOrders = document.querySelectorAll('.badge.bg-warning, .badge.bg-info');
                if (activeOrders.length > 0) {
                    console.log('Auto-refreshing data...');
                    // Aquí podrías implementar AJAX para actualizar datos sin recargar la página
                }
            }, 30000);
        </script>
    </body>
</html>