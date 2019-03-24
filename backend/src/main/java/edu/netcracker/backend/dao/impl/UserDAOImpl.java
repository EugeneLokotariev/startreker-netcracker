package edu.netcracker.backend.dao.impl;


import edu.netcracker.backend.dao.RoleDAO;
import edu.netcracker.backend.dao.UserDAO;
import edu.netcracker.backend.model.Role;
import edu.netcracker.backend.model.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Repository
@Slf4j
public class UserDAOImpl extends CrudDAOImpl<User> implements UserDAO {

    private final RoleDAO roleDAO;

    private final String findByUsernameSql = "SELECT * FROM USER_A WHERE user_name = ?";
    private final String findByEmailSql = "SELECT * FROM USER_A WHERE user_email = ?";
    private final String findAllRolesSql = "SELECT role_id FROM assigned_role WHERE user_id = ?";
    private final String removeAllUserRolesSql = "DELETE FROM assigned_role WHERE user_id = ?";
    private final String addRoleSql = "INSERT INTO assigned_role (user_id, role_id) VALUES (?, ?)";
    private final String removeRoleSql = "DELETE FROM assigned_role WHERE user_id = ? AND role_id = ?";

    private final String findByUsernameWithRoleSql = "SELECT DISTINCT * FROM USER_A "
                                                     + "  INNER JOIN assigned_role ON assigned_role.user_id = USER_A.user_id "
                                                     + "  INNER JOIN ROLE_A ON assigned_role.role_id = ROLE_A.role_id WHERE role_name = ? and user_name = ?;";

    private final String findByEmailWithRoleSql = "SELECT DISTINCT * FROM USER_A "
                                                  + "  INNER JOIN assigned_role ON assigned_role.user_id = USER_A.user_id "
                                                  + "  INNER JOIN ROLE_A ON assigned_role.role_id = ROLE_A.role_id WHERE role_name = ? and user_email = ?;";

    private final String findAllByRoleSql = "SELECT DISTINCT * FROM USER_A "
                                            + "  INNER JOIN assigned_role ON assigned_role.user_id = USER_A.user_id "
                                            + "  INNER JOIN ROLE_A ON assigned_role.role_id = ROLE_A.role_id WHERE role_name = ?";

    private final String findAllByRoleInRangeSql = "SELECT DISTINCT * FROM USER_A "
                                                   + "  INNER JOIN assigned_role ON assigned_role.user_id = USER_A.user_id "
                                                   + "  INNER JOIN ROLE_A ON assigned_role.role_id = ROLE_A.role_id WHERE role_name = ? AND USER_A.user_id BETWEEN ? AND ?";

    private final String findByRoleWithIdSql = "SELECT DISTINCT * FROM USER_A "
                                               + "  INNER JOIN assigned_role ON assigned_role.user_id = USER_A.user_id "
                                               + "  INNER JOIN ROLE_A ON assigned_role.role_id = ROLE_A.role_id WHERE role_name = ? AND USER_A.user_id = ?";

    private final String paginationSql = "SELECT * FROM USER_A "
                                         + "  INNER JOIN assigned_role ON assigned_role.user_id = USER_A.user_id "
                                         + "  INNER JOIN ROLE_A ON assigned_role.role_id = ROLE_A.role_id WHERE role_name = ?"
                                         + "ORDER BY USER_A.user_id ASC LIMIT ? OFFSET ?";

    private final String findPerPeriod = "SELECT * FROM user_a " + "WHERE user_created BETWEEN ? AND ?";

    private final String findPerPeriodByRole = "SELECT * FROM user_a "
                                               + "INNER JOIN assigned_role ON assigned_role.user_id = user_a.user_id "
                                               + "INNER JOIN role_a ON assigned_role.role_id = role_a.role_id "
                                               + "WHERE role_a.role_id = ? AND user_created BETWEEN ? AND ?";

    private final String USER_AMOUNT = "SELECT COUNT(user_a.user_id) FROM user_a\n"
                                        + "INNER JOIN assigned_role ON assigned_role.user_id = user_a.user_id\n"
                                        + "INNER JOIN role_a ON assigned_role.role_id = role_a.role_id \n"
                                        + "WHERE role_a.role_name = ?";

    @Autowired
    public UserDAOImpl(RoleDAO roleDAO) {
        this.roleDAO = roleDAO;
    }

    @Override
    public Optional<User> find(Number id) {
        Optional<User> userOpt = super.find(id);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            return attachRoles(user);
        }
        return Optional.empty();
    }

    public Optional<User> findByUsername(String userName) {
        try {
            User user = getJdbcTemplate().queryForObject(findByUsernameSql, new Object[]{userName}, getGenericMapper());
            return user != null ? attachRoles(user) : Optional.empty();
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    public Optional<User> findByEmail(String email) {
        try {
            User user = getJdbcTemplate().queryForObject(findByEmailSql, new Object[]{email}, getGenericMapper());
            return user != null ? attachRoles(user) : Optional.empty();
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<User> findByUsernameWithRole(String userName, Role role) {
        return executeSqlWithParam(findByUsernameWithRoleSql, new Object[]{role.getRoleName(), userName});
    }

    @Override
    public Optional<User> findByEmailWithRole(String email, Role role) {
        return executeSqlWithParam(findByEmailWithRoleSql, new Object[]{role.getRoleName(), email});
    }

    @Override
    public Optional<User> findByIdWithRole(Number id, Role role) {
        return executeSqlWithParam(findByRoleWithIdSql, new Object[]{role.getRoleName(), id});
    }

    @Override
    public List<User> findByRangeIdWithRole(Number startId, Number endId, Role role) {
        List<User> users = new ArrayList<>();

        users.addAll(getJdbcTemplate().query(findAllByRoleInRangeSql,
                                             new Object[]{role.getRoleName(), startId, endId},
                                             getGenericMapper()));

        attachRolesToUsers(users);

        return users;
    }

    @Override
    public List<User> findAllWithRole(Role role) {
        List<User> users = new ArrayList<>();

        users.addAll(getJdbcTemplate().query(findAllByRoleSql, new Object[]{role.getRoleName()}, getGenericMapper()));

        attachRolesToUsers(users);

        return users;
    }

    @Override
    public List<User> paginationWithRole(Integer from, Integer number, Role role) {
        List<User> users = new ArrayList<>();

        users.addAll(getJdbcTemplate().query(paginationSql,
                                             new Object[]{role.getRoleName(), number, from},
                                             getGenericMapper()));

        attachRolesToUsers(users);

        return users;
    }

    @Override
    public List<User> findPerPeriod(LocalDateTime from, LocalDateTime to) {
        List<User> users = new ArrayList<>();
        users.addAll(getJdbcTemplate().query(findPerPeriod, new Object[]{from, to}, getGenericMapper()));

        attachRolesToUsers(users);

        return users;
    }

    @Override
    public List<User> findPerPeriodByRole(Number id, LocalDateTime from, LocalDateTime to) {
        List<User> users = new ArrayList<>();

        users.addAll(getJdbcTemplate().query(findPerPeriodByRole, new Object[]{id, from, to}, getGenericMapper()));

        attachRolesToUsers(users);

        return users;
    }

    @Override
    public void save(User user) {
        super.save(user);
        updateRoles(user);
    }

    @Override
    public void delete(User user) {
        getJdbcTemplate().update(removeAllUserRolesSql, user.getUserId());
        super.delete(user);
    }

    @Override
    public Integer getUserAmount(Role role){
        log.debug("UserDAO.getUserAmount(Role role) was invoked with role={}", role.getRoleName());
        return getJdbcTemplate().queryForObject(USER_AMOUNT, new Object[]{role.getRoleName()}, Integer.class);
    }

    private Optional<User> executeSqlWithParam(String sql, Object[] params) {
        try {
            User user = getJdbcTemplate().queryForObject(sql, params, getGenericMapper());
            return user != null ? attachRoles(user) : Optional.empty();
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    public Optional<User> attachRoles(User user) {
        List<Long> rows = getJdbcTemplate().queryForList(findAllRolesSql, Long.class, user.getUserId());
        user.setUserRoles(roleDAO.findIn(rows));
        return Optional.of(user);
    }

    public void attachRolesToUsers(List<User> users) {
        Map<Integer, List<Role>> relatedRoles = roleDAO.findAllRolesForUsers(users.stream()
                                                                                  .map(User::getUserId)
                                                                                  .collect(Collectors.toList()));
        for (User user : users) {
            user.setUserRoles(relatedRoles.get(user.getUserId()));
        }
    }

    private void updateRoles(User user) {
        List<Integer> dbRoleIds = getJdbcTemplate().queryForList(findAllRolesSql, Integer.class, user.getUserId());
        List<Integer> userRoleIds = user.getUserRoles()
                                        .stream()
                                        .map(Role::getRoleId)
                                        .collect(Collectors.toList());
        for (Integer role_id : userRoleIds) {
            if (!dbRoleIds.contains(role_id)) {
                getJdbcTemplate().update(addRoleSql, user.getUserId(), role_id);
            }
        }
        for (Integer db_role : dbRoleIds) {
            if (!userRoleIds.contains(db_role)) {
                getJdbcTemplate().update(removeRoleSql, user.getUserId(), db_role);
            }
        }
    }
}
