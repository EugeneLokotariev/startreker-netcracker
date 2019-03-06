package edu.netcracker.backend.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class ServiceDTO {

    @JsonProperty("service_id")
    private Long id;

    @JsonProperty("service_name")
    private String name;

    @JsonProperty("service_price")
    private Number price;
}
