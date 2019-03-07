package edu.netcracker.backend.controller;

import edu.netcracker.backend.message.request.MandatoryTimeInterval;
import edu.netcracker.backend.message.request.OptionalTimeInterval;
import edu.netcracker.backend.message.response.CarrierRevenueResponse;
import edu.netcracker.backend.message.response.CarrierViewsResponse;
import edu.netcracker.backend.message.response.TripDTO;
import edu.netcracker.backend.message.response.TripDistributionElement;
import edu.netcracker.backend.security.SecurityContext;
import edu.netcracker.backend.service.StatisticsService;
import edu.netcracker.backend.service.TripService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import javax.ws.rs.core.MediaType;
import java.util.List;

@RestController
public class TripController {

    private final StatisticsService statisticsService;
    private final SecurityContext securityContext;
    private final TripService tripService;

    @Autowired
    public TripController(StatisticsService statisticsService,
                          SecurityContext securityContext,
                          TripService tripService) {
        this.statisticsService = statisticsService;
        this.securityContext = securityContext;
        this.tripService = tripService;
    }

    @PatchMapping(value = "api/v1/trip/{id}", consumes = MediaType.APPLICATION_JSON)
    @PreAuthorize("hasAuthority('ROLE_CARRIER') or hasAuthority('ROLE_APPROVER')")
    public TripDTO update(@Valid @RequestBody TripDTO tripDTO, @PathVariable("id") Long id) {
        tripDTO.setTripId(id);
        return TripDTO.from(tripService.updateTrip(securityContext.getUser(), tripDTO));
    }

    @GetMapping("api/v1/trip/distribution")
    @PreAuthorize("hasAuthority('ROLE_ADMIN')")
    public List<TripDistributionElement> getTripsStatistics() {
        return statisticsService.getTripsStatistics();
    }

    @GetMapping(value = "api/v1/trip/sales")
    @PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public CarrierRevenueResponse getTripsSalesStatistics(OptionalTimeInterval timeInterval) {
        return timeInterval != null && timeInterval.isProvided()
                ? statisticsService.getTripsSalesStatistics(securityContext.getUser()
                                                                           .getUserId(),
                                                            timeInterval.getFrom(),
                                                            timeInterval.getTo())
                : statisticsService.getTripsSalesStatistics(securityContext.getUser()
                                                                           .getUserId());
    }

    @GetMapping(value = "api/v1/trip/sales/per_week")
    @PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public List<CarrierRevenueResponse> getTripsSalesStatisticsByWeek(@Valid MandatoryTimeInterval timeInterval) {
        return statisticsService.getTripSalesStatisticsByWeek(securityContext.getUser()
                                                                             .getUserId(),
                                                              timeInterval.getFrom(),
                                                              timeInterval.getTo());
    }

    @GetMapping(value = "api/v1/trip/sales/per_month")
    @PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public List<CarrierRevenueResponse> getTripsSalesStatisticsByMonth(@Valid MandatoryTimeInterval timeInterval) {
        return statisticsService.getTripSalesStatisticsByMonth(securityContext.getUser()
                                                                              .getUserId(),
                                                               timeInterval.getFrom(),
                                                               timeInterval.getTo());
    }

    @GetMapping(value = "api/v1/trip/views/per_week")
    @PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public List<CarrierViewsResponse> getTripsViewsStatisticsByWeek(@Valid MandatoryTimeInterval timeInterval) {
        return statisticsService.getTripsViewsStatisticsByWeek(securityContext.getUser()
                                                                              .getUserId(),
                                                               timeInterval.getFrom(),
                                                               timeInterval.getTo());
    }

    @GetMapping(value = "api/v1/trip/views/per_month")
    @PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public List<CarrierViewsResponse> getTripsViewsStatisticsByMonth(@Valid MandatoryTimeInterval timeInterval) {
        return statisticsService.getTripsViewsStatisticsByMonth(securityContext.getUser()
                                                                               .getUserId(),
                                                                timeInterval.getFrom(),
                                                                timeInterval.getTo());
    }

    @GetMapping(value = "api/v1/trip/{id}/views/per_week")
    @PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public List<CarrierViewsResponse> getTripsViewsStatisticsByTripByWeek(@Valid MandatoryTimeInterval timeInterval,
                                                                          @PathVariable("id") Long tripId) {
        return statisticsService.getTripsViewsStatisticsByTripByWeek(securityContext.getUser(),
                                                                     tripId,
                                                                     timeInterval.getFrom(),
                                                                     timeInterval.getTo());
    }

    @GetMapping(value = "api/v1/trip/{id}/views/per_month")
    @PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public List<CarrierViewsResponse> getTripsViewsStatisticsByTripByMonth(@Valid MandatoryTimeInterval timeInterval,
                                                                           @PathVariable("id") Long tripId) {
        return statisticsService.getTripsViewsStatisticsByTripByMonth(securityContext.getUser(),
                                                                      tripId,
                                                                      timeInterval.getFrom(),
                                                                      timeInterval.getTo());
    }
}