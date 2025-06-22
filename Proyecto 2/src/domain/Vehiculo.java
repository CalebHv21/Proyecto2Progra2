package domain;

import java.util.Comparator;
import java.util.List;

public class Vehiculo {
    private String placa; // única
    private String marca;
    private String color;
    private String estilo;
    private int anio;
    private String vin;
    private double cilindraje;
    private String clienteId; // referencia al propietario

    // Constructor, getters, setters
    public Vehiculo() {}

    public Vehiculo(String placa, String marca, String color, String estilo, int anio, String vin, double cilindraje, String clienteId) {
        this.placa = placa;
        this.marca = marca;
        this.color = color;
        this.estilo = estilo;
        this.anio = anio;
        this.vin = vin;
        this.cilindraje = cilindraje;
        this.clienteId = clienteId;
    }

    public String getPlaca() {
        return placa;
    }

    public void setPlaca(String placa) {
        this.placa = placa;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getEstilo() {
        return estilo;
    }

    public void setEstilo(String estilo) {
        this.estilo = estilo;
    }

    public int getAnio() {
        return anio;
    }

    public void setAnio(int anio) {
        this.anio = anio;
    }

    public String getVin() {
        return vin;
    }

    public void setVin(String vin) {
        this.vin = vin;
    }

    public double getCilindraje() {
        return cilindraje;
    }

    public void setCilindraje(double cilindraje) {
        this.cilindraje = cilindraje;
    }

    public String getClienteId() {
        return clienteId;
    }

    public void setClienteId(String clienteId) {
        this.clienteId = clienteId;
    }

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