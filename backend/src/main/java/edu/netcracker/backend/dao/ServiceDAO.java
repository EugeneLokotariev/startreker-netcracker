package edu.netcracker.backend.dao;


import edu.netcracker.backend.message.response.ServiceCRUDDTO;
import edu.netcracker.backend.model.ServiceDescr;
import edu.netcracker.backend.model.history.HistoryService;

import java.util.List;
import java.util.Map;
import java.util.Optional;


public interface ServiceDAO {

    void save(ServiceDescr service);

    void update(ServiceDescr service);

    Integer updateServiceByCarrier(ServiceDescr service);

    Optional<ServiceDescr> find(Number id);

    Optional<ServiceDescr> findByName(String name, Number id);

    List<ServiceCRUDDTO> findByCarrierId(Number id, Integer offset, Integer limit, Integer status);

    List<ServiceCRUDDTO> getServicesForApprover(Integer from, Integer number, Integer status);

    List<ServiceCRUDDTO> getServicesForApprover(Integer from, Integer number, Integer status, Integer approverId);

    Map<Long, List<ServiceDescr>> getAllServicesBelongToSuggestions(List<Number> suggestionIds);

    List<HistoryService> getServiceNamesByTicket(Number id);
}
