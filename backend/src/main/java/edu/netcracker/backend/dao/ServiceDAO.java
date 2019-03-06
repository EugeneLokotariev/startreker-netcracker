package edu.netcracker.backend.dao;


import java.util.List;
import java.util.Optional;

import edu.netcracker.backend.message.response.ServiceCRUDDTO;
import edu.netcracker.backend.model.ServiceDescr;


public interface ServiceDAO {
    void save(ServiceDescr service);

    void delete(Long id);

    void update(ServiceDescr service);

    Optional<ServiceDescr> find(Number id);

    Optional<ServiceDescr> findByName(String name, Number id);

    List<ServiceCRUDDTO> findAllByCarrierId(Number id);

    List<ServiceCRUDDTO> findPaginByCarrierId(Number id, Integer from, Integer amount);

    List<ServiceCRUDDTO> findByStatus(Number id, Integer status);

    List<ServiceCRUDDTO> getServicesForApprover(Integer from, Integer number, Integer status);

    List<ServiceCRUDDTO> getServicesForApprover(Integer from, Integer number, Integer status, Integer approverId);
}
