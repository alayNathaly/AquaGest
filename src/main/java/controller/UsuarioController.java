package aquagest.controller;

import aquagest.model.Usuario;
import aquagest.service.UsuarioService;
import aquagest.service.ViviendaService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Controller
public class UsuarioController {

    // Service de usuarios
    @Autowired
    private UsuarioService usuarioService;

    // Service de viviendas
    @Autowired
    private ViviendaService viviendaService;

    // Página principal
    @GetMapping("/")
    public String inicio(Model model) {

        // Obtener usuarios
        List<Usuario> usuarios =
                usuarioService.obtenerUsuarios();

        // Enviar usuarios al frontend
        model.addAttribute("usuarios", usuarios);

        // Dashboard
        model.addAttribute("totalViviendas",
                viviendaService.totalViviendas());

        model.addAttribute("pagosAlDia",
                viviendaService.pagosAlDia());

        model.addAttribute("morosos",
                viviendaService.morosos());

        // Valor temporal
        model.addAttribute("nivelTanque", 62);

        return "index";
    }

    // Guardar usuario
    @PostMapping("/guardar")
    public String guardarUsuario(Usuario usuario) {

        // Contraseña temporal
        usuario.setPassword("1234");

        // Guardar usuario
        usuarioService.guardarUsuario(usuario);

        return "redirect:/";
    }

}