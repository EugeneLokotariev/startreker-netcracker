package edu.netcracker.backend.controller;

import edu.netcracker.backend.message.request.MandatoryTimeInterval;
import edu.netcracker.backend.message.request.OptionalTimeInterval;
import edu.netcracker.backend.message.response.CarrierStatisticsResponse;
import edu.netcracker.backend.message.request.ServiceCreateForm;
import edu.netcracker.backend.message.response.ServiceDTO;
import edu.netcracker.backend.message.response.ServiceDistributionElement;
import edu.netcracker.backend.security.SecurityContext;
import edu.netcracker.backend.service.StatisticsService;
import edu.netcracker.backend.model.ServiceDescr;
import edu.netcracker.backend.service.ServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
public class ServiceController {

    private final StatisticsService statisticsService;
    private final SecurityContext securityContext;

    private final StatisticsDAO statisticsDAO;
    private final ServiceService serviceService;

    @Autowired
    public ServiceController(StatisticsService statisticsService,
                             SecurityContext securityContext,
                             ServiceService serviceService) {
        this.statisticsService = statisticsService;
        this.securityContext = securityContext;
        this.serviceService = serviceService;
    }

    @GetMapping("api/v1/service/distribution")
    @PreAuthorize("hasAuthority('ROLE_ADMIN')")
    public List<ServiceDistributionElement> getServiceStatistics() {
        return statisticsService.getServiceStatistics();
    }

    @GetMapping(value = "api/v1/service/sales")
    @PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public CarrierStatisticsResponse getServicesSalesStatistics(OptionalTimeInterval timeInterval) {
        return timeInterval != null && timeInterval.isProvided()
                ? statisticsService.getServicesSalesStatistics(
                securityContext.getUser().getUserId(),
                timeInterval.getFrom(),
                timeInterval.getTo())

                : statisticsService.getServicesSalesStatistics(securityContext.getUser().getUserId());
    }

    @GetMapping(value = "api/v1/service/sales/per_week")
    @PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public List<CarrierStatisticsResponse> getServicesSalesStatisticsByWeek(
            @Valid MandatoryTimeInterval timeInterval) {
        return statisticsService.getServicesSalesStatisticsByWeek(
                securityContext.getUser().getUserId(),
                timeInterval.getFrom(),
                timeInterval.getTo());
    }

    @GetMapping(value = "api/v1/service/sales/per_month")
    @PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public List<CarrierStatisticsResponse> getServicesSalesStatisticsByMonth(
            @Valid MandatoryTimeInterval timeInterval) {
        return statisticsService.getServicesSalesStatisticsByMonth(
                securityContext.getUser().getUserId(),
                timeInterval.getFrom(),
                timeInterval.getTo());
    }

    @GetMapping("api/v1/carrier/service")
    //@PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public List<ServiceDescr> getAllServices(){
        return serviceService.getServicesOfCarrier();
    }

    @GetMapping("api/v1/carrier/service/pagin")
    //@PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public List<ServiceDescr> getPaginServices(@RequestParam("from") Integer from, @RequestParam("number") Integer number){
        return serviceService.getPaginServicesOfCarrier(from, number);
    }

    @DeleteMapping("api/v1/carrier/service/{servId}")
    //@PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public ServiceDescr deleteService(@PathVariable Long servId){
        return serviceService.deleteService(servId);
    }

    @PutMapping("api/v1/carrier/service")
    //@PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public ServiceDescr updateService(@Valid @RequestBody ServiceDescr serviceDescr){
        return serviceService.updateService(serviceDescr);
    }

    @PostMapping("api/v1/carrier/service")
    //@PreAuthorize("hasAuthority('ROLE_CARRIER')")
    public ServiceDTO addService(@Valid @RequestBody ServiceCreateForm serviceCreateForm){
        return serviceService.addService(serviceCreateForm);
    }
}
