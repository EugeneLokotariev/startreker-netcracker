package edu.netcracker.backend.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;

@Getter
@Setter
public class PlanetsResponse {

    @JsonProperty
    List<String> planets;
    @JsonProperty
    Map<String, List<String>> spaceports;

}
