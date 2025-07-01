/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mecanico.paraiso.domain;

import java.util.Comparator;
import java.util.List;

public class Vehiculo {
    private String placa; // única
    private String marca;
    private String modelo; // Agregar modelo
    private String color;
    private String estilo;
    private int anno; // Mantener anno como estaba
    private String vin;
    private double cilindraje;
    private String clienteId; // referencia al propietario
    
    // Propiedades derivadas para compatibilidad con JSP
    private String nombrePropietario; // Se llenará desde Cliente
    private String telefonoPropietario; // Se llenará desde Cliente

    public Vehiculo() {}

    public Vehiculo(String placa, String marca, String modelo, String color, String estilo, 
                   int anno, String vin, double cilindraje, String clienteId) {
        this.placa = placa;
        this.marca = marca;
        this.modelo = modelo;
        this.color = color;
        this.estilo = estilo;
        this.anno = anno;
        this.vin = vin;
        this.cilindraje = cilindraje;
        this.clienteId = clienteId;
    }

    // Getters y Setters
    public String getPlaca() { return placa; }
    public void setPlaca(String placa) { this.placa = placa; }

    public String getMarca() { return marca; }
    public void setMarca(String marca) { this.marca = marca; }

    public String getModelo() { return modelo; }
    public void setModelo(String modelo) { this.modelo = modelo; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public String getEstilo() { return estilo; }
    public void setEstilo(String estilo) { this.estilo = estilo; }

    public int getAnno() { return anno; }
    public void setAnno(int anno) { this.anno = anno; }

    public String getVin() { return vin; }
    public void setVin(String vin) { this.vin = vin; }

    public double getCilindraje() { return cilindraje; }
    public void setCilindraje(double cilindraje) { this.cilindraje = cilindraje; }

    public String getClienteId() { return clienteId; }
    public void setClienteId(String clienteId) { this.clienteId = clienteId; }

    // Propiedades para JSP
    public String getNombrePropietario() { return nombrePropietario; }
    public void setNombrePropietario(String nombrePropietario) { this.nombrePropietario = nombrePropietario; }

    public String getTelefonoPropietario() { return telefonoPropietario; }
    public void setTelefonoPropietario(String telefonoPropietario) { this.telefonoPropietario = telefonoPropietario; }

    public static void ordenarVehiculosPorPlaca(List<Vehiculo> vehiculos) {
        vehiculos.sort(Comparator.comparing(Vehiculo::getPlaca));
    }

    public static Vehiculo buscarVehiculoPorPlaca(List<Vehiculo> vehiculos, String placa) {
        ordenarVehiculosPorPlaca(vehiculos);
        int left = 0, right = vehiculos.size() - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            Vehiculo v = vehiculos.get(mid);
            int cmp = v.getPlaca().compareToIgnoreCase(placa);
            if (cmp == 0) return v;
            if (cmp < 0) left = mid + 1;
            else right = mid - 1;
        }
        return null;
    }
}