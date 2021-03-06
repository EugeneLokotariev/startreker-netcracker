package edu.netcracker.backend.controller;

import edu.netcracker.backend.message.response.HistoryDTO.HistoryServiceDTO;
import edu.netcracker.backend.message.response.HistoryDTO.HistoryTicketDTO;
import edu.netcracker.backend.service.PurchaseHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@RequestMapping("api/v1/history")
@RestController
public class PurchaseHistoryController {

    private PurchaseHistoryService phs;

    @Autowired
    PurchaseHistoryController(PurchaseHistoryService phs) {
        this.phs = phs;
    }

    @PreAuthorize("hasAuthority('ROLE_USER')")
    @GetMapping("/user/ticket")
    public List<HistoryTicketDTO> getPurchaseHistory(@RequestParam("limit") Number limit,
                                                     @RequestParam("offset") Number offset,
                                                     @RequestParam(name = "start-date", required = false)
                                                             String startDate,
                                                     @RequestParam(name = "end-date", required = false) String endDate,
                                                     HttpServletResponse response) {

        response.addHeader("X-Total-Count",
                           phs.countTicketByUser(startDate, endDate)
                              .toString());
        return phs.getPurchaseHistory(limit, offset, startDate, endDate);
    }

    @PreAuthorize("hasAuthority('ROLE_USER')")
    @GetMapping("/ticket/{id}/service")
    public List<HistoryServiceDTO> getServiceNamesByTicket(@PathVariable("id") Number id) {
        return phs.getServiceNamesByTicket(id);
    }
}
