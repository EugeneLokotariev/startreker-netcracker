package edu.netcracker.backend.dao.mapper;

import edu.netcracker.backend.model.Trip;
import edu.netcracker.backend.model.User;
import edu.netcracker.backend.model.state.trip.TripStateRegistry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
public class TripMapper implements RowMapper<Trip> {

    private final TripStateRegistry tripStateRegistry;

    @Autowired
    public TripMapper(TripStateRegistry tripStateRegistry) {
        this.tripStateRegistry = tripStateRegistry;
    }

    @Override
    public Trip mapRow(ResultSet rs, int rowNum) throws SQLException {
        Trip trip = new Trip();
        trip.setTripId(rs.getLong("trip_id"));
        trip.setTripState(tripStateRegistry.getState(rs.getInt("trip_status")));
        trip.setDepartureDate(rs.getTimestamp("departure_date")
                                .toLocalDateTime());
        trip.setArrivalDate(rs.getTimestamp("arrival_date")
                              .toLocalDateTime());
        trip.setCreationDate(rs.getTimestamp("creation_date")
                               .toLocalDateTime());
        trip.setTripPhoto(rs.getString("trip_photo"));

        trip.setOwner(mapUser(rs, "owner"));
        trip.setApprover(mapUser(rs, "approver"));

        return trip;
    }

    private User mapUser(ResultSet rs, String prefix) throws SQLException {
        User user = new User();

        user.setUserId(rs.getInt(prefix + "_id"));

        if (user.getUserId() == 0) {
            return null;
        }

        user.setUserPassword(rs.getString(prefix + "_password"));
        user.setUserIsActivated(rs.getBoolean(prefix + "_activated"));
        user.setRegistrationDate(rs.getTimestamp(prefix + "_date_created")
                                   .toLocalDateTime());
        user.setUserRefreshToken(rs.getString(prefix + "_token"));
        user.setUserEmail(rs.getString(prefix + "_email"));
        user.setUserTelephone(rs.getString(prefix + "_telephone"));

        return user;
    }
}
