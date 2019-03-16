package edu.netcracker.backend.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import edu.netcracker.backend.model.Spaceport;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.format.DateTimeFormatter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class SpaceportDTO {

    @JsonProperty("spaceport_id")
    private Long spaceportId;

    @JsonProperty("spaceport_name")
    private String spaceportName;

    @JsonProperty("creation_date")
    private String creationDate;

    @JsonProperty("planet")
    private PlanetDTO planetDTO;

    public static SpaceportDTO from(Spaceport spaceport) {
        if(spaceport == null) return null;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return new SpaceportDTO(spaceport.getSpaceportId(),
                                spaceport.getSpaceportName(),
                                spaceport.getCreationDate().format(formatter),
                                PlanetDTO.from(spaceport.getPlanet()));
    }
}
