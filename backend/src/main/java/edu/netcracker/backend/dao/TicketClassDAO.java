package edu.netcracker.backend.dao;

import edu.netcracker.backend.model.TicketClass;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface TicketClassDAO extends CrudDAO<TicketClass> {
    void save(TicketClass ticketClass);

    Optional<TicketClass> find(Number id);

    Optional<TicketClass> findTicketClassBelongToCarrier(Number ticketClassId, Number carrierId);

    List<TicketClass> findByTripId(Number id);

    List<TicketClass> findTicketClassWithItemNumber(Number BundleId, Number TripId);

    void delete(TicketClass ticketClass);

    List<TicketClass> getAllTicketClassesRelatedToCarrier(Number carrierId);

    Optional<TicketClass> getTicketClassByDiscount(Number userId, Number discountId);

    void create(TicketClass ticketClass);

    void update(TicketClass ticketClass);

    Map<Long, List<TicketClass>> getAllTicketClassesBelongToTrips(List<Number> tripIds);

    Long getTicketClassId(String className, Long tripId);

    TicketClass getTicketClassByNameAndTripId(Long tripId, String name);

    void deleteTicketClassById(Long id);

    boolean exists(Long tripId, String className);
}
