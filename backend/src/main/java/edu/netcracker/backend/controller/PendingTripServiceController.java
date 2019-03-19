package edu.netcracker.backend.controller;

import edu.netcracker.backend.controller.exception.RequestException;
import edu.netcracker.backend.message.request.ServicePendingActivationDto;
import edu.netcracker.backend.message.request.TripPendingActivationDto;
import edu.netcracker.backend.service.IPendingSrvc;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/approver")
@Slf4j(topic = "log")
public class PendingTripServiceController {

    private IPendingSrvc<ServicePendingActivationDto> pendingServicesSrvc;

    private IPendingSrvc<TripPendingActivationDto> pendingTripsSrvc;

    @RequestMapping(value = "/all-pending-services", method = RequestMethod.GET)
    public List<ServicePendingActivationDto> getAllServices() {

        log.debug("PendingTripServiceController.getAllServices() was invoked");

        return pendingServicesSrvc.getPendingEntries();
    }

    @RequestMapping(value = "/all-pending-trips", method = RequestMethod.GET)
    public List<TripPendingActivationDto> getAllTrips() {

        log.debug("PendingTripServiceController.getAllTrips() was invoked");

        return pendingTripsSrvc.getPendingEntries();
    }

    @RequestMapping(value = "/all-pending-services-paging", method = RequestMethod.GET)
    public List<ServicePendingActivationDto> getServicesLimitOffset(@RequestParam("limit") Number limit, @RequestParam("offset") Number offset) {

        log.debug("PendingTripServiceController.getServicesLimitOffset(Number limit, Number offset) was invoked with parameters limit = {}, offset = {}", limit, offset);

        if ((0 > limit.intValue()) || (0 > offset.intValue())) {
            log.debug("PendingTripServiceController.getServicesLimitOffset(Number limit, Number offset) - request arguments are wrong. Bad request will be sent to the user");
            throw new RequestException("Limit or offset is less than zero", HttpStatus.BAD_REQUEST);
        } else {
            log.debug("PendingTripServiceController.getServicesLimitOffset(Number limit, Number offset) was invoked with parameters limit = {}, offset = {} - service invoking", limit, offset);
            return pendingServicesSrvc.getPendingWithOffsetAndLimit(limit, offset);
        }
    }

    @RequestMapping(value = "/all-pending-trips-paging", method = RequestMethod.GET)
    public List<TripPendingActivationDto> getTripsLimitOffset(@RequestParam("limit") Number limit, @RequestParam("offset") Number offset) {

        log.debug("PendingTripServiceController.getTripsLimitOffset(Number limit, Number offset) was invoked with parameters limit = {}, offset = {}", limit, offset);

        if ((0 > limit.intValue()) || (0 > offset.intValue())) {
            log.debug("PendingTripServiceController.getTripsLimitOffset(Number limit, Number offset) - request arguments are wrong. Bad request will be sent to the user");
            throw new RequestException("Limit or offset is less than zero", HttpStatus.BAD_REQUEST);
        } else {
            log.debug("PendingTripServiceController.getTripsLimitOffset(Number limit, Number offset) was invoked with parameters limit = {}, offset = {} - service invoking", limit, offset);
            return pendingTripsSrvc.getPendingWithOffsetAndLimit(limit, offset);
        }
    }

    @Autowired
    public void setPendingServicesSrvc(IPendingSrvc<ServicePendingActivationDto> pendingServicesSrvc) {
        this.pendingServicesSrvc = pendingServicesSrvc;
    }

    @Autowired
    public void setPendingTripsSrvc(IPendingSrvc<TripPendingActivationDto> pendingTripsSrvc) {
        this.pendingTripsSrvc = pendingTripsSrvc;
    }
}
