package edu.netcracker.backend.controller;

import com.google.gson.Gson;
import edu.netcracker.backend.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

@RestController
public class AdminController {

    private AdminService adminService;

    @Autowired
    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    @GetMapping("/api/v1/admin/costs/{carrierId}")
//    @PreAuthorize("hasRole('ADMIN')")
    public String getCostsPerCarrier(@PathVariable Long carrierId,
                                     @RequestParam("from") @DateTimeFormat(pattern="yyyy-MM-dd") Date from,
                                     @RequestParam("to") @DateTimeFormat(pattern="yyyy-MM-dd") Date to) {
        return new Gson().toJson(adminService.getCostsPerPeriodPerCarrier(carrierId,
                convertToLocalDateViaInstant(from),
                convertToLocalDateViaInstant(to)));
    }

    @GetMapping("/api/v1/admin/costs")
//    @PreAuthorize("hasRole('ADMIN')")
    public String getCostsPerPeriodPerCarrier(@RequestParam("from") @DateTimeFormat(pattern="yyyy-MM-dd") Date from,
                                              @RequestParam("to") @DateTimeFormat(pattern="yyyy-MM-dd") Date to) {
        return new Gson().toJson(adminService.getCostsPerPeriod(convertToLocalDateViaInstant(from),
                convertToLocalDateViaInstant(to)));
    }

    private LocalDate convertToLocalDateViaInstant(Date dateToConvert) {
        return dateToConvert.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
    }

}