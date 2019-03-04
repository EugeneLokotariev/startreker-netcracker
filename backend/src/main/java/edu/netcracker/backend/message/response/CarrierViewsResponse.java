package edu.netcracker.backend.message.response;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@EqualsAndHashCode
public class CarrierViewsResponse extends CarrierStatisticsResponse{

    private Long views;
}