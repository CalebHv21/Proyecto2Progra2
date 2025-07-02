<%-- 
    Document   : EditarCliente
    Created on : Jul 2, 2025, 5:49:24 AM
    Author     : CalebHv21
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${cliente != null ? 'Editar' : 'Registrar'} Cliente</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-4">
            <div class="row">
                <div class="col-md-8 offset-md-2">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-user-edit"></i>
                                ${cliente != null ? 'Editar' : 'Registrar'} Cliente
                            </h3>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" role="alert">
                                    <strong>Error:</strong> ${error}
                                </div>
                            </c:if>

                            <form action="cliente" method="post">
                                <input type="hidden" name="accion" value="${cliente != null ? 'editar' : 'registrar'}"/>
                                
                                <div class="mb-3">
                                    <label for="id" class="form-label">Cédula *</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="id" 
                                           name="id" 
                                           value="${cliente.id}" 
                                           ${cliente != null ? 'readonly' : ''} 
                                           required/>
                                    <c:if test="${cliente != null}">
                                        <div class="form-text">La cédula no se puede modificar</div>
                                    </c:if>
                                </div>

                                <div class="mb-3">
                                    <label for="nombre" class="form-label">Nombre *</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="nombre" 
                                           name="nombre" 
                                           value="${cliente.nombre}" 
                                           required/>
                                </div>

                                <div class="mb-3">
                                    <label for="apellidos" class="form-label">Apellidos *</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="apellidos" 
                                           name="apellidos" 
                                           value="${cliente.apellidos}" 
                                           required/>
                                </div>

                                <div class="mb-3">
                                    <label for="telefono" class="form-label">Teléfono *</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="telefono" 
                                           name="telefono" 
                                           value="${cliente.telefono}" 
                                           required/>
                                </div>

                                <div class="mb-3">
                                    <label for="direccion" class="form-label">Dirección *</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="direccion" 
                                           name="direccion" 
                                           value="${cliente.direccion}" 
                                           required/>
                                </div>

                                <div class="mb-3">
                                    <label for="correo" class="form-label">Correo Electrónico *</label>
                                    <input type="email" 
                                           class="form-control" 
                                           id="correo" 
                                           name="correo" 
                                           value="${cliente.correo}" 
                                           required/>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <a href="cliente" class="btn btn-secondary me-md-2">
                                        <i class="fas fa-times"></i> Cancelar
                                    </a>
                                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary me-md-2">
                                        <i class="fas fa-home"></i> Inicio
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i>
                                        ${cliente != null ? 'Actualizar' : 'Registrar'}
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