package edu.netcracker.backend.model;

import edu.netcracker.backend.dao.annotations.Attribute;
import edu.netcracker.backend.dao.annotations.PrimaryKey;
import edu.netcracker.backend.dao.annotations.Table;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Table("service")
public class ServiceDescr {
    @PrimaryKey("service_id")
    @EqualsAndHashCode.Include
    private Long serviceId;

    @Attribute("carrier_id")
    private Integer carrierId;

    @Attribute("approver_id")
    private Integer approverId;

    @Attribute("service_name")
    private String serviceName;

    @Attribute("service_description")
    private String serviceDescription;

    @Attribute("service_status")
    private Integer serviceStatus;

    @Attribute("creation_date")
    private LocalDateTime creationDate;
}
