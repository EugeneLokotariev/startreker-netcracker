package edu.netcracker.backend.message.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import edu.netcracker.backend.model.Discount;
import edu.netcracker.backend.validation.annotation.DateValidation;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.time.format.DateTimeFormatter;

@Getter
@Setter
@EqualsAndHashCode
public class DiscountDTO {

    @JsonProperty("discount_id")
    private Long discountId;

    @NotNull
    @JsonProperty("start_date")
    @DateValidation(message = "invalid date format", pattern = "dd-MM-yyyy")
    private String startDate;

    @NotNull
    @JsonProperty("finish_date")
    @DateValidation(message = "invalid date format", pattern = "dd-MM-yyyy")
    private String finishDate;

    @NotNull
    @JsonProperty("discount_rate")
    private Integer discountRate;

    @NotNull
    @JsonProperty("is_percent")
    private Boolean isPercent;

    @JsonProperty("is_expired")
    private Boolean isExpired;

    public static DiscountDTO toDiscountDTO(Discount discount, String datePattern) {
        if (discount == null) {
            return null;
        }

        DiscountDTO discountDTO = new DiscountDTO();
        discountDTO.setDiscountId(discount.getDiscountId());
        discountDTO.setDiscountRate(discount.getDiscountRate());
        discountDTO.setIsPercent(discount.getIsPercent());
        discountDTO.setIsExpired(discount.isExpired());
        discountDTO.setStartDate(discount.getStartDate().format(DateTimeFormatter.ofPattern(datePattern)));
        discountDTO.setFinishDate(discount.getFinishDate().format(DateTimeFormatter.ofPattern(datePattern)));

        return discountDTO;
    }
}
