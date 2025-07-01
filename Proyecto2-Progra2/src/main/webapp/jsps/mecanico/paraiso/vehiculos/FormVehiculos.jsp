<%-- 
    Document   : FormVehiculos
    Created on : Jun 29, 2025, 10:18:23 PM
    Author     : sebas
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${vehiculo != null ? 'Editar' : 'Registrar'} Vehículo - Mecánico Paraíso</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container mt-4">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white">
                            <h3 class="card-title mb-0">
                                <i class="fas fa-car"></i> 
                                ${vehiculo != null ? 'Editar' : 'Registrar'} Vehículo
                            </h3>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" role="alert">
                                    <i class="fas fa-exclamation-triangle"></i> ${error}
                                </div>
                            </c:if>

                            <form action="vehiculo" method="post" class="needs-validation" novalidate>
                                <input type="hidden" name="accion" value="${vehiculo != null ? 'editar' : 'registrar'}"/>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="placa" class="form-label">Placa *</label>
                                            <input type="text" class="form-control" id="placa" name="placa" 
                                                   value="${vehiculo.placa}" 
                                                   ${vehiculo != null ? 'readonly' : ''} 
                                                   required placeholder="ABC123">
                                            <div class="invalid-feedback">
                                                Por favor ingrese la placa del vehículo.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="marca" class="form-label">Marca *</label>
                                            <input type="text" class="form-control" id="marca" name="marca" 
                                                   value="${vehiculo.marca}" required placeholder="Toyota, Honda, etc.">
                                            <div class="invalid-feedback">
                                                Por favor ingrese la marca del vehículo.
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="modelo" class="form-label">Modelo *</label>
                                            <input type="text" class="form-control" id="modelo" name="modelo" 
                                                   value="${vehiculo.modelo}" required placeholder="Corolla, Civic, etc.">
                                            <div class="invalid-feedback">
                                                Por favor ingrese el modelo del vehículo.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="anno" class="form-label">Año *</label>
                                            <input type="number" class="form-control" id="anno" name="anno" 
                                                   value="${vehiculo.anno}" min="1900" max="2030" required>
                                            <div class="invalid-feedback">
                                                Por favor ingrese un año válido.
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="color" class="form-label">Color *</label>
                                            <input type="text" class="form-control" id="color" name="color" 
                                                   value="${vehiculo.color}" required placeholder="Blanco, Negro, etc.">
                                            <div class="invalid-feedback">
                                                Por favor ingrese el color del vehículo.
                                            </div>
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
                                            <div class="invalid-feedback">
                                                Por favor seleccione el estilo del vehículo.
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="vin" class="form-label">VIN *</label>
                                            <input type="text" class="form-control" id="vin" name="vin" 
                                                   value="${vehiculo.vin}" required 
                                                   placeholder="Número de identificación del vehículo">
                                            <div class="invalid-feedback">
                                                Por favor ingrese el VIN del vehículo.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="cilindraje" class="form-label">Cilindraje (L) *</label>
                                            <input type="number" class="form-control" id="cilindraje" name="cilindraje" 
                                                   value="${vehiculo.cilindraje}" step="0.1" min="0.1" max="10" required>
                                            <div class="invalid-feedback">
                                                Por favor ingrese el cilindraje del vehículo.
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="clienteId" class="form-label">Propietario *</label>
                                    <select class="form-select" id="clienteId" name="clienteId" required>
                                        <option value="">Seleccione el propietario</option>
                                        <c:forEach var="cli" items="${clientes}">
                                            <option value="${cli.id}" 
                                                    ${vehiculo != null && vehiculo.clienteId == cli.id ? 'selected' : ''}>
                                                ${cli.nombre} ${cli.apellidos} - ${cli.id}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback">
                                        Por favor seleccione el propietario del vehículo.
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <a href="vehiculo" class="btn btn-secondary">
                                        <i class="fas fa-arrow-left"></i> Cancelar
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Validación de formulario Bootstrap
            (function () {
                'use strict';
                window.addEventListener('load', function () {
                    var forms = document.getElementsByClassName('needs-validation');
                    var validation = Array.prototype.filter.call(forms, function (form) {
                        form.addEventListener('submit', function (event) {
                            if (form.checkValidity() === false) {
                                event.preventDefault();
                                event.stopPropagation();
                            }
                            form.classList.add('was-validated');
                        }, false);
                    });
                }, false);
            })();
        </script>
    </body>
</html>