<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mecánico Paraíso - Sistema de Gestión</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="text-center mb-5">
            <h1 class="display-4">
                <i class="fas fa-wrench text-primary"></i> 
                Mecánico Paraíso
            </h1>
            <p class="lead">Sistema de Gestión de Taller Mecánico</p>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="row g-4">
                    <!-- Gestión de Clientes -->
                    <div class="col-md-4">
                        <div class="card text-center h-100">
                            <div class="card-body">
                                <i class="fas fa-users fa-3x text-primary mb-3"></i>
                                <h5 class="card-title">Clientes</h5>
                                <p class="card-text">Gestionar clientes</p>
                                <a href="cliente" class="btn btn-primary">Acceder</a>
                            </div>
                        </div>
                    </div>

                    <!-- Gestión de Vehículos -->
                    <div class="col-md-4">
                        <div class="card text-center h-100">
                            <div class="card-body">
                                <i class="fas fa-car fa-3x text-success mb-3"></i>
                                <h5 class="card-title">Vehículos</h5>
                                <p class="card-text">Gestionar vehículos</p>
                                <a href="vehiculo" class="btn btn-success">Acceder</a>
                            </div>
                        </div>
                    </div>

                    <!-- Órdenes de Trabajo -->
                    <div class="col-md-4">
                        <div class="card text-center h-100">
                            <div class="card-body">
                                <i class="fas fa-clipboard-list fa-3x text-warning mb-3"></i>
                                <h5 class="card-title">Órdenes</h5>
                                <p class="card-text">Gestionar órdenes</p>
                                <a href="orden" class="btn btn-warning">Acceder</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>