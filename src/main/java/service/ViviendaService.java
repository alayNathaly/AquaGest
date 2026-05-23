package aquagest.service;

import aquagest.repository.ViviendaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/*
 * Service de Vivienda
 * Maneja lógica del dashboard
 */

@Service
public class ViviendaService {

    // Inyección del repository
    @Autowired
    private ViviendaRepository viviendaRepository;

    // Obtener total de viviendas
    public long totalViviendas() {

        return viviendaRepository.count();

    }

    // Obtener viviendas al día
    public long pagosAlDia() {

        return viviendaRepository.countByEstadoCuenta("AL_DIA");

    }

    // Obtener viviendas morosas
    public long morosos() {

        return viviendaRepository.countByEstadoCuenta("MOROSO");

    }

}