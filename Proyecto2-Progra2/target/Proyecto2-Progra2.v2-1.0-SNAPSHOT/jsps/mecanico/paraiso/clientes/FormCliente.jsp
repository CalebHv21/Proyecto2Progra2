<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestión de Clientes</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-4">
            <div class="row">
                <div class="col-md-8 offset-md-2">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h3 class="card-title mb-0">
                                ${cliente != null ? 'Editar' : 'Registrar'} Cliente
                            </h3>
                            <div class="d-flex gap-2">
                                <a href="cliente" class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-list"></i> Lista de Clientes
                                </a>
                                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-home"></i> Menú Principal
                                </a>
                            </div>
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
                                           value="${cliente != null ? cliente.id : ''}" 
                                           ${cliente != null ? 'readonly' : ''} 
                                           required 
                                           maxlength="20"/>
                                </div>

                                <div class="mb-3">
                                    <label for="nombre" class="form-label">Nombre *</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="nombre" 
                                           name="nombre" 
                                           value="${cliente != null ? cliente.nombre : ''}" 
                                           required 
                                           maxlength="50"/>
                                </div>

                                <div class="mb-3">
                                    <label for="apellidos" class="form-label">Apellidos *</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="apellidos" 
                                           name="apellidos" 
                                           value="${cliente != null ? cliente.apellidos : ''}" 
                                           required 
                                           maxlength="50"/>
                                </div>

                                <div class="mb-3">
                                    <label for="telefono" class="form-label">Teléfono *</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="telefono" 
                                           name="telefono" 
                                           value="${cliente != null ? cliente.telefono : ''}" 
                                           required 
                                           maxlength="20"/>
                                </div>

                                <div class="mb-3">
                                    <label for="direccion" class="form-label">Dirección *</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="direccion" 
                                           name="direccion" 
                                           value="${cliente != null ? cliente.direccion : ''}" 
                                           required 
                                           maxlength="100"/>
                                </div>

                                <div class="mb-3">
                                    <label for="correo" class="form-label">Correo Electrónico *</label>
                                    <input type="email" 
                                           class="form-control" 
                                           id="correo" 
                                           name="correo" 
                                           value="${cliente != null ? cliente.correo : ''}" 
                                           required 
                                           maxlength="50"/>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <a href="cliente" class="btn btn-secondary me-md-2">
                                        <i class="fas fa-arrow-left"></i> Volver a Lista
                                    </a>
                                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary me-md-2">
                                        <i class="fas fa-home"></i> Menú Principal
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