package edu.netcracker.backend.model.state.trip;

import edu.netcracker.backend.model.Trip;
import edu.netcracker.backend.model.User;
import edu.netcracker.backend.utils.AuthorityUtils;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;

@Component
public class Assigned extends TripState {

    private final static int databaseValue = 3;

    private static List<Integer> allowedStatesToSwitchFrom = Collections.singletonList(2);

    @Override
    public boolean isStateChangeAllowed(Trip trip, User requestUser, TripState tripState) {
        if (requestUser.getUserRoles()
                       .contains(AuthorityUtils.ROLE_APPROVER)
            && allowedStatesToSwitchFrom.contains(tripState.getDatabaseValue())) {
            trip.setApprover(requestUser);
            return true;
        }
        return false;
    }

    @Override
    public int getDatabaseValue() {
        return databaseValue;
    }
}
