/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mecanico.paraiso.domain;

/**
 *
 * @author sebas
 */
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Comparator;

public class OrdenTrabajo {
    private String id; // generado dinámicamente
    private String placaVehiculo;
    private Date fechaIngreso;
    private String estado; // Diagnóstico, En reparación, Listo para entrega
    private String descripcionProblema;
    private String observaciones;
    private Date fechaEstimadaDevolucion;
    private List<RepuestoServicio> repuestosServicios = new ArrayList<>();
    private double costoTotal;

    // Constantes para estados válidos
    public static final String ESTADO_DIAGNOSTICO = "Diagnóstico";
    public static final String ESTADO_EN_REPARACION = "En reparación";
    public static final String ESTADO_LISTO = "Listo para entrega";
    public static final String ESTADO_ENTREGADO = "Entregado";

    public OrdenTrabajo() {}

    public OrdenTrabajo(String id, String placaVehiculo, Date fechaIngreso, String estado, String descripcionProblema, String observaciones, Date fechaEstimadaDevolucion, List<RepuestoServicio> repuestosServicios, double costoTotal) {
        this.id = id;
        this.placaVehiculo = placaVehiculo;
        this.fechaIngreso = fechaIngreso;
        this.estado = estado;
        this.descripcionProblema = descripcionProblema;
        this.observaciones = observaciones;
        this.fechaEstimadaDevolucion = fechaEstimadaDevolucion;
        this.repuestosServicios = repuestosServicios != null ? repuestosServicios : new ArrayList<>();
        this.costoTotal = costoTotal;
    }

    // Getters y Setters básicos
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPlacaVehiculo() {
        return placaVehiculo;
    }

    public void setPlacaVehiculo(String placaVehiculo) {
        this.placaVehiculo = placaVehiculo;
    }

    public Date getFechaIngreso() {
        return fechaIngreso;
    }

    public void setFechaIngreso(Date fechaIngreso) {
        this.fechaIngreso = fechaIngreso;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getDescripcionProblema() {
        return descripcionProblema;
    }

    public void setDescripcionProblema(String descripcionProblema) {
        this.descripcionProblema = descripcionProblema;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public Date getFechaEstimadaDevolucion() {
        return fechaEstimadaDevolucion;
    }

    public void setFechaEstimadaDevolucion(Date fechaEstimadaDevolucion) {
        this.fechaEstimadaDevolucion = fechaEstimadaDevolucion;
    }

    public List<RepuestoServicio> getRepuestosServicios() {
        return repuestosServicios;
    }

    public void setRepuestosServicios(List<RepuestoServicio> repuestosServicios) {
        this.repuestosServicios = repuestosServicios != null ? repuestosServicios : new ArrayList<>();
        calcularCostoTotal(); // Recalcular cuando se asigna nueva lista
    }

    public double getCostoTotal() {
        return costoTotal;
    }

    public void setCostoTotal(double costoTotal) {
        this.costoTotal = costoTotal;
    }

    // MÉTODOS DE LÓGICA DE NEGOCIO

    /**
     * Calcula automáticamente el costo total sumando todos los repuestos y servicios
     */
    public void calcularCostoTotal() {
        this.costoTotal = 0.0;
        for (RepuestoServicio item : repuestosServicios) {
            this.costoTotal += item.getCostoTotal();
        }
    }

    /**
     * Agrega un repuesto o servicio y recalcula el costo total automáticamente
     */
    public void agregarRepuestoServicio(RepuestoServicio item) {
        if (item != null) {
            this.repuestosServicios.add(item);
            calcularCostoTotal();
        }
    }

    /**
     * Remueve un repuesto o servicio y recalcula el costo total automáticamente
     */
    public void removerRepuestoServicio(RepuestoServicio item) {
        if (this.repuestosServicios.remove(item)) {
            calcularCostoTotal();
        }
    }

    /**
     * Valida si un estado es válido
     */
    public static boolean esEstadoValido(String estado) {
        return ESTADO_DIAGNOSTICO.equals(estado) || 
               ESTADO_EN_REPARACION.equals(estado) || 
               ESTADO_LISTO.equals(estado) ||
               ESTADO_ENTREGADO.equals(estado);
    }

    /**
     * Cambia el estado validando que sea correcto
     */
    public void cambiarEstado(String nuevoEstado) {
        if (esEstadoValido(nuevoEstado)) {
            this.estado = nuevoEstado;
        } else {
            throw new IllegalArgumentException("Estado no válido: " + nuevoEstado);
        }
    }

    /**
     * Verifica si la orden está vencida (pasó la fecha estimada)
     */
    public boolean estaVencida() {
        return fechaEstimadaDevolucion != null && 
               new Date().after(fechaEstimadaDevolucion);
    }

    /**
     * Calcula los días hasta la fecha estimada de devolución
     */
    public long diasHastaDevolucion() {
        if (fechaEstimadaDevolucion == null) return -1;
        long diff = fechaEstimadaDevolucion.getTime() - new Date().getTime();
        return diff / (24 * 60 * 60 * 1000);
    }

    /**
     * Obtiene el número total de items (repuestos + servicios)
     */
    public int getTotalItems() {
        int total = 0;
        for (RepuestoServicio item : repuestosServicios) {
            total += item.getCantidad();
        }
        return total;
    }

    /**
     * Obtiene solo los repuestos (no mano de obra)
     */
    public List<RepuestoServicio> getRepuestos() {
        List<RepuestoServicio> repuestos = new ArrayList<>();
        for (RepuestoServicio item : repuestosServicios) {
            if (!item.isEsManoObra()) {
                repuestos.add(item);
            }
        }
        return repuestos;
    }

    /**
     * Obtiene solo los servicios de mano de obra
     */
    public List<RepuestoServicio> getServicios() {
        List<RepuestoServicio> servicios = new ArrayList<>();
        for (RepuestoServicio item : repuestosServicios) {
            if (item.isEsManoObra()) {
                servicios.add(item);
            }
        }
        return servicios;
    }

    // MÉTODOS ESTÁTICOS DE BÚSQUEDA Y ORDENAMIENTO

    /**
     * Busca una orden de trabajo por ID
     */
    public static OrdenTrabajo buscarOrdenPorId(List<OrdenTrabajo> ordenes, String id) {
        for (OrdenTrabajo orden : ordenes) {
            if (orden.getId().equals(id)) {
                return orden;
            }
        }
        return null;
    }

    /**
     * Busca órdenes por placa del vehículo
     */
    public static List<OrdenTrabajo> buscarOrdenesPorPlaca(List<OrdenTrabajo> ordenes, String placa) {
        List<OrdenTrabajo> resultado = new ArrayList<>();
        for (OrdenTrabajo orden : ordenes) {
            if (orden.getPlacaVehiculo().equalsIgnoreCase(placa)) {
                resultado.add(orden);
            }
        }
        return resultado;
    }

    /**
     * Ordena las órdenes por fecha de ingreso (más recientes primero)
     */
    public static void ordenarOrdenesPorFecha(List<OrdenTrabajo> ordenes) {
        ordenes.sort((o1, o2) -> o2.getFechaIngreso().compareTo(o1.getFechaIngreso()));
    }

    /**
     * Ordena las órdenes por ID
     */
    public static void ordenarOrdenesPorId(List<OrdenTrabajo> ordenes) {
        ordenes.sort(Comparator.comparing(OrdenTrabajo::getId));
    }

    /**
     * Filtra órdenes por estado
     */
    public static List<OrdenTrabajo> filtrarPorEstado(List<OrdenTrabajo> ordenes, String estado) {
        List<OrdenTrabajo> resultado = new ArrayList<>();
        for (OrdenTrabajo orden : ordenes) {
            if (orden.getEstado().equals(estado)) {
                resultado.add(orden);
            }
        }
        return resultado;
    }

    @Override
    public String toString() {
        return String.format("OrdenTrabajo{id='%s', placa='%s', estado='%s', costoTotal=%.2f, items=%d}", 
                            id, placaVehiculo, estado, costoTotal, repuestosServicios.size());
    }
}