package aquagest.model;

// Importaciones necesarias para JPA
import jakarta.persistence.*;

/*
 * Entidad Usuario
 * Representa los usuarios del sistema.
 */

@Entity
@Table(name = "usuarios")
public class Usuario {

    // ID único autogenerado
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Nombre completo
    @Column(nullable = false)
    private String nombre;

    // Número de teléfono único
    @Column(nullable = false, unique = true)
    private String telefono;

    // Contraseña del usuario
    @Column(nullable = false)
    private String password;

    // Rol del usuario
    // Ejemplo: OPERADOR, RESIDENTE, COMITE
    @Column(nullable = false)
    private String rol;

    // Constructor vacío requerido por JPA
    public Usuario() {
    }

    // Constructor con parámetros
    public Usuario(String nombre, String telefono, String password, String rol) {

        this.nombre = nombre;
        this.telefono = telefono;
        this.password = password;
        this.rol = rol;

    }

    // ===== GETTERS Y SETTERS =====

    public Long getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

}