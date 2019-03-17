package edu.netcracker.backend.model.state.trip;

import edu.netcracker.backend.model.Trip;
import edu.netcracker.backend.model.User;
import org.springframework.stereotype.Component;

@Component
public class Removed extends TripState {

    private final String stringValue = "Removed";

    private final static int databaseValue = 7;

    @Override
    public boolean isStateChangeAllowed(Trip trip, User requestUser, TripState tripState) {
        return requestUser.equals(trip.getApprover()) && !(tripState.getClass()
                                                                    .equals(Removed.class));
    }

    @Override
    public int getDatabaseValue() {
        return databaseValue;
    }

    @Override
    public String getStringValue() {
        return stringValue;
    }
}
