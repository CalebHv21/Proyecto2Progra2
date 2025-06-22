package domain;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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


    public OrdenTrabajo() {}

    public OrdenTrabajo(String id, String placaVehiculo, Date fechaIngreso, String estado, String descripcionProblema, String observaciones, Date fechaEstimadaDevolucion, List<RepuestoServicio> repuestosServicios, double costoTotal) {
        this.id = id;
        this.placaVehiculo = placaVehiculo;
        this.fechaIngreso = fechaIngreso;
        this.estado = estado;
        this.descripcionProblema = descripcionProblema;
        this.observaciones = observaciones;
        this.fechaEstimadaDevolucion = fechaEstimadaDevolucion;
        this.repuestosServicios = repuestosServicios;
        this.costoTotal = costoTotal;
    }

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
        this.repuestosServicios = repuestosServicios;
    }

    public double getCostoTotal() {
        return costoTotal;
    }

    public void setCostoTotal(double costoTotal) {
        this.costoTotal = costoTotal;
    }

    // Métodos para agregar repuestos/servicios, calcular costo total, etc.
}