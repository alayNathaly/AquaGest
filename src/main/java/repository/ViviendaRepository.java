package aquagest.repository;

import aquagest.model.Vivienda;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ViviendaRepository extends JpaRepository<Vivienda, Long> {

    long countByEstadoCuenta(String estadoPago);

}