package aquagest.model;

import jakarta.persistence.*;

@Entity
@Table(name = "vivienda")
public class Vivienda {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String direccion;

    private String estadoCuenta;

    // Constructor vacío
    public Vivienda() {
    }

    // Constructor con parámetros
    public Vivienda(String direccion, String estadoCuenta) {

        this.direccion = direccion;
        this.estadoCuenta = estadoCuenta;

    }

    // Getter ID
    public Long getId() {

        return id;

    }

    // Getter dirección
    public String getDireccion() {

        return direccion;

    }

    // Setter dirección
    public void setDireccion(String direccion) {

        this.direccion = direccion;

    }

    // Getter estadoPago
    public String getEstadoCuenta() {

        return estadoCuenta;

    }

    // Setter estadoPago
    public void setEstadoCuenta(String estadoCuenta) {

        this.estadoCuenta = estadoCuenta;

    }

}