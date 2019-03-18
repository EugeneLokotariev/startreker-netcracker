package edu.netcracker.backend.model;

import edu.netcracker.backend.dao.annotations.Attribute;
import edu.netcracker.backend.dao.annotations.PrimaryKey;
import edu.netcracker.backend.dao.annotations.Table;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Table("role_a")
public class Role {

    @PrimaryKey("role_id")
    @EqualsAndHashCode.Include
    private Integer roleId;
    @Attribute("role_name")
    private String roleName;
}
