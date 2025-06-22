package domain;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Cliente {
    private String id; // cédula, asumiendo que es única
    private String nombre;
    private String apellidos;
    private String telefono;
    private String direccion;
    private String correo;
    private List<Vehiculo> vehiculos = new ArrayList<>();

    // Constructor, getters, setters
    public Cliente() {}

    public Cliente(String id, String nombre, String apellidos, String telefono, String direccion, String correo) {
        this.id = id;
        this.nombre = nombre;
        this.apellidos = apellidos;
        this.telefono = telefono;
        this.direccion = direccion;
        this.correo = correo;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public List<Vehiculo> getVehiculos() {
        return vehiculos;
    }

    public void setVehiculos(List<Vehiculo> vehiculos) {
        this.vehiculos = vehiculos;
    }

    public static void ordenarClientesPorId(List<Cliente> clientes) {
        clientes.sort(Comparator.comparing(Cliente::getId));
    }

    public static Cliente buscarClientePorId(List<Cliente> clientes, String id) {
        ordenarClientesPorId(clientes);
        int left = 0, right = clientes.size() - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            Cliente c = clientes.get(mid);
            int cmp = c.getId().compareTo(id);
            if (cmp == 0) return c;
            if (cmp < 0) left = mid + 1;
            else right = mid - 1;
        }
        return null;
    }

}