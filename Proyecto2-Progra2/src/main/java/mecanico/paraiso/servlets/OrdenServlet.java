package mecanico.paraiso.servlets;

import mecanico.paraiso.domain.*;
import mecanico.paraiso.data.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/OrdenServlet")
public class OrdenServlet extends HttpServlet {
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if ("editar".equals(accion)) {
            String id = request.getParameter("id");
            List<OrdenTrabajo> ordenes = OrdenXML.leerOrdenes();
            OrdenTrabajo orden = null;
            for (OrdenTrabajo o : ordenes) {
                if (o.getId().equals(id)) {
                    orden = o;
                    break;
                }
            }
            List<Vehiculo> vehiculos = VehiculoXML.leerVehiculos();
            request.setAttribute("vehiculos", vehiculos);
            request.setAttribute("orden", orden);
            request.getRequestDispatcher("jsp.mecanino.paraiso/ordenes/formOrden.jsp").forward(request, response);
        } else if ("agregarRepuestoServicio".equals(accion)) {
            String id = request.getParameter("id");
            List<OrdenTrabajo> ordenes = OrdenXML.leerOrdenes();
            OrdenTrabajo orden = null;
            for (OrdenTrabajo o : ordenes) {
                if (o.getId().equals(id)) {
                    orden = o;
                    break;
                }
            }
            request.setAttribute("orden", orden);
            request.getRequestDispatcher("jsp/ordenes/agregarRepuestoServicio.jsp").forward(request, response);
        } else {
            List<OrdenTrabajo> ordenes = OrdenXML.leerOrdenes();
            request.setAttribute("ordenes", ordenes);
            request.getRequestDispatcher("jsp/ordenes/listarOrdenes.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        List<OrdenTrabajo> ordenes = OrdenXML.leerOrdenes();

        if ("registrar".equals(accion) || "editar".equals(accion)) {
            String id = request.getParameter("id");
            String placaVehiculo = request.getParameter("placaVehiculo");
            String fechaIngresoStr = request.getParameter("fechaIngreso");
            String estado = request.getParameter("estado");
            String descripcionProblema = request.getParameter("descripcionProblema");
            String observaciones = request.getParameter("observaciones");
            String fechaEstimadaDevolucionStr = request.getParameter("fechaEstimadaDevolucion");

            //Validación
            if (placaVehiculo == null || fechaIngresoStr == null || estado == null || descripcionProblema == null || fechaEstimadaDevolucionStr == null ||
                    placaVehiculo.isEmpty() || fechaIngresoStr.isEmpty() || estado.isEmpty() || descripcionProblema.isEmpty() || fechaEstimadaDevolucionStr.isEmpty()) {
                List<Vehiculo> vehiculos = VehiculoXML.leerVehiculos();
                request.setAttribute("vehiculos", vehiculos);
                request.setAttribute("error", "Todos los campos obligatorios.");
                request.getRequestDispatcher("jsp/ordenes/formOrden.jsp").forward(request, response);
                return;
            }

            try {
                Date fechaIngreso = sdf.parse(fechaIngresoStr);
                Date fechaEstimadaDevolucion = sdf.parse(fechaEstimadaDevolucionStr);

                if ("registrar".equals(accion)) {
                    String nuevoId = OrdenXML.generarNuevoIdOrden();
                    OrdenTrabajo nueva = new OrdenTrabajo();
                    nueva.setId(nuevoId);
                    nueva.setPlacaVehiculo(placaVehiculo);
                    nueva.setFechaIngreso(fechaIngreso);
                    nueva.setEstado(estado);
                    nueva.setDescripcionProblema(descripcionProblema);
                    nueva.setObservaciones(observaciones);
                    nueva.setFechaEstimadaDevolucion(fechaEstimadaDevolucion);
                    nueva.setRepuestosServicios(new ArrayList<>());
                    nueva.setCostoTotal(0.0);
                    ordenes.add(nueva);

                } else { //editar
                    for (OrdenTrabajo o : ordenes) {
                        if (o.getId().equals(id)) {
                            o.setEstado(estado);
                            o.setDescripcionProblema(descripcionProblema);
                            o.setObservaciones(observaciones);
                            o.setFechaEstimadaDevolucion(fechaEstimadaDevolucion);
                            break;
                        }
                    }
                }

                OrdenXML.guardarOrdenes(ordenes);
                response.sendRedirect("OrdenServlet");

            } catch (Exception e) {
                List<Vehiculo> vehiculos = VehiculoXML.leerVehiculos();
                request.setAttribute("vehiculos", vehiculos);
                request.setAttribute("error", "Fechas inválidas.");
                request.getRequestDispatcher("jsp/ordenes/formOrden.jsp").forward(request, response);
            }
        } else if ("agregarRepuestoServicio".equals(accion)) {
            String idOrden = request.getParameter("idOrden");
            String nombre = request.getParameter("nombre");
            String cantidadStr = request.getParameter("cantidad");
            String precioStr = request.getParameter("precio");
            boolean fuePedido = "true".equals(request.getParameter("fuePedido"));
            boolean esManoObra = "true".equals(request.getParameter("esManoObra"));

            //Validación
            if (nombre == null || cantidadStr == null || precioStr == null ||
                    nombre.isEmpty() || cantidadStr.isEmpty() || precioStr.isEmpty()) {
                OrdenTrabajo orden = null;
                for (OrdenTrabajo o : ordenes) if (o.getId().equals(idOrden)) orden = o;
                request.setAttribute("orden", orden);
                request.setAttribute("error", "Todos los campos son obligatorios.");
                request.getRequestDispatcher("jsp/ordenes/agregarRepuestoServicio.jsp").forward(request, response);
                return;
            }

            int cantidad;
            double precio;
            try {
                cantidad = Integer.parseInt(cantidadStr);
                precio = Double.parseDouble(precioStr);
            } catch (NumberFormatException e) {
                OrdenTrabajo orden = null;
                for (OrdenTrabajo o : ordenes) if (o.getId().equals(idOrden)) orden = o;
                request.setAttribute("orden", orden);
                request.setAttribute("error", "Cantidad y precio deben ser válidos.");
                request.getRequestDispatcher("jsp/ordenes/agregarRepuestoServicio.jsp").forward(request, response);
                return;
            }

            for (OrdenTrabajo o : ordenes) {
                if (o.getId().equals(idOrden)) {
                    // Solo se puede agregar si está "En reparación"
                    if (!"En reparación".equals(o.getEstado())) {
                        request.setAttribute("orden", o);
                        request.setAttribute("error", "Solo se pueden agregar detalles mientras la orden está en 'En reparación'.");
                        request.getRequestDispatcher("jsp/ordenes/agregarRepuestoServicio.jsp").forward(request, response);
                        return;
                    }
                    RepuestoServicio rs = new RepuestoServicio(nombre, cantidad, precio, fuePedido, esManoObra);
                    o.getRepuestosServicios().add(rs);
                    // Actualizar costo total
                    double total = o.getCostoTotal() + (cantidad * precio);
                    o.setCostoTotal(total);
                    break;
                }
            }
            OrdenXML.guardarOrdenes(ordenes);
            response.sendRedirect("OrdenServlet?accion=agregarRepuestoServicio&id=" + idOrden);
        }
    }
}