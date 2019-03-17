package edu.netcracker.backend.model;

import edu.netcracker.backend.dao.annotations.Attribute;
import edu.netcracker.backend.dao.annotations.PrimaryKey;
import edu.netcracker.backend.dao.annotations.Table;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Table("ticket")
public class Ticket {
    @PrimaryKey("ticket_id")
    @EqualsAndHashCode.Include
    private Long ticketId;

    @Attribute("passenger_id")
    private Integer passengerId;

    @Attribute("class_id")
    private Long classId;

    @Attribute("seat")
    private Long seat;

    @Attribute("purchase_date")
    private LocalDateTime purchaseDate;

}
