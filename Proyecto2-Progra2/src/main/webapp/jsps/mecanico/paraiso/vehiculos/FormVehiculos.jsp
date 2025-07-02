<%-- 
    Document   : FormVehiculos
    Created on : Jul 2, 2025, 6:05:45 AM
    Author     : CalebHv21
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${vehiculo != null ? 'Editar' : 'Registrar'} Vehículo</title>
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
                                ${vehiculo != null ? 'Editar' : 'Registrar'} Vehículo
                            </h3>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" role="alert">
                                    <strong>Error:</strong> ${error}
                                </div>
                            </c:if>

                            <form action="vehiculo" method="post">
                                <input type="hidden" name="accion" value="${vehiculo != null ? 'editar' : 'registrar'}"/>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="placa" class="form-label">Placa *</label>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="placa" 
                                                   name="placa" 
                                                   value="${vehiculo.placa}" 
                                                   ${vehiculo != null ? 'readonly' : ''} 
                                                   required 
                                                   maxlength="10"/>
                                            <c:if test="${vehiculo != null}">
                                                <div class="form-text">La placa no se puede modificar</div>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="marca" class="form-label">Marca *</label>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="marca" 
                                                   name="marca" 
                                                   value="${vehiculo.marca}" 
                                                   required 
                                                   maxlength="50"/>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="modelo" class="form-label">Modelo *</label>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="modelo" 
                                                   name="modelo" 
                                                   value="${vehiculo.modelo}" 
                                                   required 
                                                   maxlength="50"/>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="anno" class="form-label">Año *</label>
                                            <input type="number" 
                                                   class="form-control" 
                                                   id="anno" 
                                                   name="anno" 
                                                   value="${vehiculo.anno}" 
                                                   min="1900" 
                                                   max="2030" 
                                                   required/>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="color" class="form-label">Color *</label>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="color" 
                                                   name="color" 
                                                   value="${vehiculo.color}" 
                                                   required 
                                                   maxlength="30"/>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="estilo" class="form-label">Estilo *</label>
                                            <select class="form-select" id="estilo" name="estilo" required>
                                                <option value="">Seleccione el estilo</option>
                                                <option value="Sedán" ${vehiculo.estilo == 'Sedán' ? 'selected' : ''}>Sedán</option>
                                                <option value="Hatchback" ${vehiculo.estilo == 'Hatchback' ? 'selected' : ''}>Hatchback</option>
                                                <option value="SUV" ${vehiculo.estilo == 'SUV' ? 'selected' : ''}>SUV</option>
                                                <option value="Pickup" ${vehiculo.estilo == 'Pickup' ? 'selected' : ''}>Pickup</option>
                                                <option value="Convertible" ${vehiculo.estilo == 'Convertible' ? 'selected' : ''}>Convertible</option>
                                                <option value="Coupe" ${vehiculo.estilo == 'Coupe' ? 'selected' : ''}>Coupe</option>
                                                <option value="Wagon" ${vehiculo.estilo == 'Wagon' ? 'selected' : ''}>Wagon</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="vin" class="form-label">VIN *</label>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="vin" 
                                                   name="vin" 
                                                   value="${vehiculo.vin}" 
                                                   required 
                                                   maxlength="17"/>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="cilindraje" class="form-label">Cilindraje (L) *</label>
                                            <input type="number" 
                                                   class="form-control" 
                                                   id="cilindraje" 
                                                   name="cilindraje" 
                                                   value="${vehiculo.cilindraje}" 
                                                   step="0.1" 
                                                   min="0.1" 
                                                   max="10" 
                                                   required/>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="clienteId" class="form-label">ID del Propietario *</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="clienteId" 
                                           name="clienteId" 
                                           value="${vehiculo != null ? vehiculo.clienteId : ''}" 
                                           required 
                                           maxlength="20"/>
                                    <div class="form-text">Ingrese la cédula del cliente propietario</div>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <a href="vehiculo" class="btn btn-secondary me-md-2">
                                        <i class="fas fa-arrow-left"></i> Volver a Lista
                                    </a>
                                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary me-md-2">
                                        <i class="fas fa-home"></i> Menú Principal
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i>
                                        ${vehiculo != null ? 'Actualizar' : 'Registrar'}
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