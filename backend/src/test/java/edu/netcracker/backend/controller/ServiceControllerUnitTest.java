package edu.netcracker.backend.controller;

import edu.netcracker.backend.controller.exception.RequestException;
import edu.netcracker.backend.message.response.ServiceCRUDDTO;
import edu.netcracker.backend.model.ServiceDescr;
import edu.netcracker.backend.model.User;
import edu.netcracker.backend.security.SecurityContext;
import edu.netcracker.backend.service.ServiceService;
import edu.netcracker.backend.service.StatisticsService;
import edu.netcracker.backend.utils.ServiceStatus;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import static org.mockito.Mockito.when;

@RunWith(MockitoJUnitRunner.class)
public class ServiceControllerUnitTest {
    @Mock
    StatisticsService statisticsService;

    @Mock
    SecurityContext securityContext;

    @Mock
    ServiceService serviceService;

    List<ServiceCRUDDTO> ret;


    @Before
    public void initialize()
    {
        ServiceDescr serviceDescr = new ServiceDescr();
        serviceDescr.setServiceId(2L);
        serviceDescr.setServiceName("quis turpis eget");
        serviceDescr.setServiceDescription("amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt");
        serviceDescr.setServiceStatus(2);
        serviceDescr.setCreationDate(
                LocalDate.parse(
                        "2015-11-16",
                        DateTimeFormatter.ofPattern("yyyy-MM-dd")
                ).atStartOfDay());
        ServiceCRUDDTO testService = ServiceCRUDDTO.form(serviceDescr, null);
        List<ServiceCRUDDTO> ret = new ArrayList<>();
        ret.add(testService);
    }


    @Test
    public void shouldPassServices() throws Exception {
        when(serviceService.getServicesForApprover(1, 10, ServiceStatus.OPEN.toString(), 3))
                .thenReturn(ret);

        User usr = new User();
        usr.setUserId(3);
        when(securityContext.getUser()).thenReturn(usr);

        ServiceController controller = new ServiceController(statisticsService, securityContext, serviceService);

        Assert.assertEquals(controller.getServicesForApprover(1, 10, ServiceStatus.OPEN.toString()), ret);
    }

    @Test(expected = RequestException.class)
    public void shouldRejectIllegalStatus() throws Exception {
        String illegalStatus = ServiceStatus.DRAFT.toString();

        ServiceController controller = new ServiceController(statisticsService, securityContext, serviceService);

        controller.getServicesForApprover(1, 10, illegalStatus);
    }
}
