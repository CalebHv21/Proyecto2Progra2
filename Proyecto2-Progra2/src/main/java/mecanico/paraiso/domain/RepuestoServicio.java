/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mecanico.paraiso.domain;

/**
 *
 * @author sebas
 */
public class RepuestoServicio {
    private String nombre;
    private int cantidad;
    private double precio;
    private boolean fuePedido;
    private boolean esManoObra; // true si es mano de obra, false si es repuesto

    public RepuestoServicio() {}

    public RepuestoServicio(String nombre, int cantidad, double precio, boolean fuePedido, boolean esManoObra) {
        this.nombre = nombre;
        this.cantidad = cantidad;
        this.precio = precio;
        this.fuePedido = fuePedido;
        this.esManoObra = esManoObra;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public boolean isEsManoObra() {
        return esManoObra;
    }

    public void setEsManoObra(boolean esManoObra) {
        this.esManoObra = esManoObra;
    }

    public boolean isFuePedido() {
        return fuePedido;
    }

    public void setFuePedido(boolean fuePedido) {
        this.fuePedido = fuePedido;
    }
}
