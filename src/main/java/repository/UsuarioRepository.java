package aquagest.repository;

import aquagest.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/*
 * Repository encargado del acceso
 * a datos de usuarios.
 */

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    // Buscar usuario por teléfono
    Usuario findByTelefono(String telefono);

}