package edu.netcracker.backend.message.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ServiceCreateForm {

    @NotNull
    @JsonProperty("service_name")
    @Size(min = 3)
    private String serviceName;

    @JsonProperty("service_descr")
    @Size(min = 3)
    private String serviceDescription;

    @NotNull
    @JsonProperty("service_status")
    private Integer serviceStatus;
}
