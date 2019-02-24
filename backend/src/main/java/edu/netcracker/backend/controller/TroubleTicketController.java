package edu.netcracker.backend.controller;

import edu.netcracker.backend.message.response.ReportStatisticsResponse;
import edu.netcracker.backend.service.ReportStatisticsBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TroubleTicketController {

    private ReportStatisticsBuilder reportStatisticsBuilder;

    @Autowired
    public TroubleTicketController(ReportStatisticsBuilder reportStatisticsBuilder) {
        this.reportStatisticsBuilder = reportStatisticsBuilder;
    }

    @PostMapping("/api/trouble/statistics")
    //TODO: Uncomment
    //@PreAuthorize("hasAuthority('ROLE_ADMIN')")
    public ReportStatisticsResponse getStatistics() {
        return fullStatBuilder()
                .build();
    }

    @PostMapping("/api/trouble/statistics/{id}")
    //TODO: Uncomment
    //@PreAuthorize("hasAuthority('ROLE_ADMIN')")
    public ReportStatisticsResponse getStatistics(@PathVariable Long id) {
        return fullStatBuilder()
                .forUser(id)
                .build();
    }

    private ReportStatisticsBuilder fullStatBuilder() {
        return reportStatisticsBuilder
                .addTotalAnsweredCount()
                .addTotalCount()
                .addTotalFinishedCount()
                .addTotalOpenedCount()
                .addTotalRatedCount()
                .addTotalReOpenedCount()
                .addTotalInProgressCount()
                .addAverageRate();
    }
}
