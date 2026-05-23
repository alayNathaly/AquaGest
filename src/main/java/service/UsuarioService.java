package aquagest.service;

import aquagest.model.Usuario;
import aquagest.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/*
 * Service encargado de la lógica de negocio
 * relacionada con usuarios.
 */

@Service
public class UsuarioService {

    // Inyección del repository
    @Autowired
    private UsuarioRepository usuarioRepository;

    // Guarda un usuario en la base de datos
    public Usuario guardarUsuario(Usuario usuario) {

        return usuarioRepository.save(usuario);

    }

    // Obtiene todos los usuarios registrados
    public List<Usuario> obtenerUsuarios() {

        return usuarioRepository.findAll();

    }

    // Busca un usuario por número de teléfono
    public Usuario buscarPorTelefono(String telefono) {

        return usuarioRepository.findByTelefono(telefono);

    }

}