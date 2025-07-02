<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mecánico Paraíso - Sistema de Gestión</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <!-- Header principal -->
        <div class="text-center mb-5">
            <h1 class="display-4">
                <i class="fas fa-wrench text-primary"></i> 
                Mecánico Paraíso
            </h1>
            <p class="lead text-muted">Sistema de Gestión de Taller Mecánico</p>
        </div>

        <!-- Cards de navegación -->
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="row g-4">
                    <!-- Gestión de Clientes -->
                    <div class="col-md-4">
                        <div class="card text-center h-100 shadow-sm">
                            <div class="card-body d-flex flex-column">
                                <i class="fas fa-users fa-3x text-primary mb-3"></i>
                                <h5 class="card-title">Gestión de Clientes</h5>
                                <p class="card-text text-muted">Registrar y administrar información de clientes</p>
                                <div class="mt-auto">
                                    <a href="cliente" class="btn btn-primary">
                                        <i class="fas fa-arrow-right"></i> Acceder
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Gestión de Vehículos -->
                    <div class="col-md-4">
                        <div class="card text-center h-100 shadow-sm">
                            <div class="card-body d-flex flex-column">
                                <i class="fas fa-car fa-3x text-success mb-3"></i>
                                <h5 class="card-title">Gestión de Vehículos</h5>
                                <p class="card-text text-muted">Administrar vehículos y sus propietarios</p>
                                <div class="mt-auto">
                                    <a href="vehiculo" class="btn btn-success">
                                        <i class="fas fa-arrow-right"></i> Acceder
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Órdenes de Trabajo -->
                    <div class="col-md-4">
                        <div class="card text-center h-100 shadow-sm">
                            <div class="card-body d-flex flex-column">
                                <i class="fas fa-clipboard-list fa-3x text-warning mb-3"></i>
                                <h5 class="card-title">Órdenes de Trabajo</h5>
                                <p class="card-text text-muted">Crear y gestionar órdenes de servicio</p>
                                <div class="mt-auto">
                                    <a href="orden" class="btn btn-warning text-dark">
                                        <i class="fas fa-arrow-right"></i> Acceder
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Información adicional -->
                <div class="row mt-5">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body text-center">
                                <h6 class="card-subtitle mb-2 text-muted">
                                    <i class="fas fa-info-circle"></i> Sistema de Gestión
                                </h6>
                                <p class="card-text small">
                                    Administra clientes, vehículos y órdenes de trabajo de manera integrada
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>