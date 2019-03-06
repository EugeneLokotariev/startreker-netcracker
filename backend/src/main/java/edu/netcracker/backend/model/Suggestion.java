package edu.netcracker.backend.model;

import edu.netcracker.backend.dao.annotations.Attribute;
import edu.netcracker.backend.dao.annotations.PrimaryKey;
import edu.netcracker.backend.dao.annotations.Table;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Table("suggestion")
public class Suggestion {
    @PrimaryKey("suggestion_id")
    @EqualsAndHashCode.Include
    private Long suggestionId;

    @Attribute("discount_id")
    private Long discountId;

    @Attribute("class_id")
    private Long classId;

    private Discount discount;
}