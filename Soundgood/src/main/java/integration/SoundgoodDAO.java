/*
 * Parts of Leif's code has been used for this class
 *
 * The MIT License (MIT)
 * Copyright (c) 2020 Leif Lindbäck
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction,including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so,subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package integration;

import DTO.InstrumentDTO;
import DTO.LeaseDTO;
import DTO.StudentDTO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;


/**
 * Database access object to encapsulate all calls to the database.
 */
public class SoundgoodDAO {
    private static final String INSTRUMENT_TABLE_NAME = "instrument_inventory";
    private static final String INSTRUMENT_PK_COLUMN = "instrument_inventory_id";
    private static final String INSTRUMENT_TYPE_COLUMN = "instrument_type_id";
    private static final String INSTRUMENT_BRAND_COLUMN = "brand";
    private static final String INSTRUMENT_PRICE_COLUMN = "price";
    private static final String INSTRUMENT_TYPE_TABLE_NAME = "instrument_type";
    private static final String INSTRUMENT_TYPE_ID_COLUMN = "instrument_type_id";
    private static final String LEASE_TABLE_NAME = "lease";
    private static final String LEASE_PERSON_ID_COLUMN = "person_id";
    private static final String LEASE_INSTRUMENT_ID_COLUMN = "instrument_inventory_id";
    private static final String LEASE_START_DATE_COLUMN = "start_date";
    private static final String LEASE_EXPIRATION_DATE_COLUMN = "expiration_date";
    private static final String LEASE_DELIVERY_ADDRESS_COLUMN = "delivery_address";
    private static final String STUDENT_TABLE_NAME = "person";
    private static final String STUDENT_PERSON_ID_COLUMN = "person_id";
    private static final String STUDENT_PERSON_NUMBER_COLUMN = "person_number";
    private static final String STUDENT_NAME_COLUMN = "name";
    private static final String STUDENT_PHONE_NUMBER_COLUMN = "phone";
    private static final String STUDENT_ADDRESS_COLUMN = "address";
    private static final String STUDENT_EMAIL_COLUMN = "email";
    private static final String INSTRUCTOR_TABLE_NAME = "instructor";

    private Connection connection;
    private PreparedStatement findInstrumentByType;
    private PreparedStatement findInstrumentById;
    private PreparedStatement findStudentById;
    private PreparedStatement findLeaseByStudentId;
    private PreparedStatement createLeaseStmt;
    private PreparedStatement updateLeaseStmt;

    /**
     * Creates new database access object with connection to the database and prepared statements
     * @throws SoundgoodDBException if unable to connect to database or unable to parse prepared statements
     */
    public SoundgoodDAO() throws SoundgoodDBException {
        try {
            connectToSoundgoodDB();
            prepareStatements();
        } catch (ClassNotFoundException | SQLException exception) {
            throw new SoundgoodDBException("Could not connect to datasource.", exception);
        }
    }

    /**
     * Commits the current transaction
     * @throws SoundgoodDBException if unable to commit the current transaction
     */
    public void commit() throws SoundgoodDBException {
        try {
            connection.commit();
        } catch (SQLException e) {
            handleException("Failed to commit", e);
        }
    }

    /**
     * Method to find instruments by a given type that are not currently rented out
     * @param instrumentType
     * @return list of InstrumentDTOs representing the instruments
     * @throws SoundgoodDBException if unable to retrieve the instruments
     */
    public ArrayList<InstrumentDTO> findInstrumentByType(String instrumentType) throws SoundgoodDBException {
        PreparedStatement stmtToExecute = findInstrumentByType;
        String failureMsg = "Could not search for instruments.";
        ResultSet result = null;
        ArrayList<InstrumentDTO> instruments = new ArrayList<>();

        try {
            stmtToExecute.setString(1, instrumentType);
            stmtToExecute.setString(2, instrumentType);
            result = stmtToExecute.executeQuery();

            while (result.next()) {
                instruments.add(new InstrumentDTO(
                        result.getInt(INSTRUMENT_PK_COLUMN),
                        result.getString(INSTRUMENT_TYPE_TABLE_NAME),
                        result.getString(INSTRUMENT_BRAND_COLUMN),
                        result.getDouble(INSTRUMENT_PRICE_COLUMN)
                ));
            }

            connection.commit();
            return instruments;

        } catch (SQLException sqle) {
            handleException(failureMsg, sqle);
        } finally {
            closeResultSet(failureMsg, result);
        }

        return instruments;
    }

    /**
     * Method to find an instrument that is not rented out by using the instrument id
     * @param instrumentId
     * @return information about instrument in an InstrumentDTO
     * @throws SoundgoodDBException if unable to retrieve instrument
     */
    public InstrumentDTO findInstrumentById(String instrumentId) throws SoundgoodDBException {
        PreparedStatement stmtToExecute = findInstrumentById;
        String failureMsg = "Could not search for specified account.";
        ResultSet result = null;
        try {
            stmtToExecute.setString(1, instrumentId);
            result = stmtToExecute.executeQuery();
            if (result.next()) {
                return new InstrumentDTO(result.getInt(INSTRUMENT_PK_COLUMN),
                        result.getString(INSTRUMENT_TYPE_TABLE_NAME),
                        result.getString(INSTRUMENT_BRAND_COLUMN),
                        result.getDouble(INSTRUMENT_PRICE_COLUMN));
            }
        } catch (SQLException sqle) {
            handleException(failureMsg, sqle);
        } finally {
            closeResultSet(failureMsg, result);
        }
        return null;
    }

    /**
     * Method to find information about a student based on their person id
     * @param studentId
     * @return Information about student in a StudentDTO
     * @throws SoundgoodDBException if unable to retrieve student
     */
    public StudentDTO findStudentById(String studentId) throws SoundgoodDBException {
        PreparedStatement stmtToExecute = findStudentById;
        String failureMsg = "Could not search for specified account.";
        ResultSet result = null;
        try {
            stmtToExecute.setString(1, studentId);
            result = stmtToExecute.executeQuery();
            if (result.next()) {
                return new StudentDTO(result.getInt(STUDENT_PERSON_ID_COLUMN),
                        result.getInt(STUDENT_PERSON_NUMBER_COLUMN),
                        result.getString(STUDENT_NAME_COLUMN),
                        result.getString(STUDENT_ADDRESS_COLUMN),
                        result.getString(STUDENT_EMAIL_COLUMN),
                        result.getInt(STUDENT_PHONE_NUMBER_COLUMN));
            }
        } catch (SQLException sqle) {
            handleException(failureMsg, sqle);
        } finally {
            closeResultSet(failureMsg, result);
        }
        return null;
    }

    /**
     * Method to find all leases connected to a student
     * @param student DTO containing info on student
     * @return List of LeaseDTOs
     * @throws SoundgoodDBException if unable to retrieve leases
     */
    public ArrayList<LeaseDTO> findLeaseByStudent(StudentDTO student) throws SoundgoodDBException {
        PreparedStatement stmtToExecute = findLeaseByStudentId;
        String failureMsg = "Could not search for instruments.";
        ResultSet result = null;
        ArrayList<LeaseDTO> leases = new ArrayList<>();
        LocalDate startDate;
        LocalDate expirationDate;

        try {
            stmtToExecute.setString(1, student.getId());
            result = stmtToExecute.executeQuery();

            while (result.next()) {
                leases.add(new LeaseDTO(
                        result.getInt(LEASE_PERSON_ID_COLUMN),
                        result.getInt(LEASE_INSTRUMENT_ID_COLUMN),
                        result.getDate(LEASE_START_DATE_COLUMN).toLocalDate(),
                        result.getDate(LEASE_EXPIRATION_DATE_COLUMN).toLocalDate()
                        result.getString(LEASE_DELIVERY_ADDRESS_COLUMN),
                ));
            }
            return leases;

        } catch (SQLException sqle) {
            handleException(failureMsg, sqle);
        } finally {
            closeResultSet(failureMsg, result);
        }

        return leases;
    }

    /**
     * Creates a new lease in the database
     * @param lease LeaseDTO with information on new lease
     * @throws SoundgoodDBException if unable to create lease
     */
    public void createLease(LeaseDTO lease) throws SoundgoodDBException {
        String failureMsg = "Could not create the lease: " + lease;
        int updatedRows = 0;
        try {
            createLeaseStmt.setInt(1, lease.getStudentId());
            createLeaseStmt.setInt(2, lease.getInstrumentId());
            createLeaseStmt.setDate(3, lease.getStartDate());
            createLeaseStmt.setDate(4, lease.getExpirationDate());
            createLeaseStmt.setString(5, lease.getDeliveryAddress());
            updatedRows = createLeaseStmt.executeUpdate();
            if (updatedRows != 1) {
                handleException(failureMsg, null);
            }

            connection.commit();
        } catch (SQLException sqle) {
            handleException(failureMsg, sqle);
        }
    }

    /**
     * Updates existing lease with new information
     * @param lease LeaseDTO with information on lease
     * @throws SoundgoodDBException if unable to update lease
     */
    public void updateLease(LeaseDTO lease) throws SoundgoodDBException {
        String failureMsg = "Could not update the lease: " + lease;
        int updatedRows = 0;
        try {
            updateLeaseStmt.setInt(1, lease.getStudentId());
            updateLeaseStmt.setInt(2, lease.getInstrumentId());
            updateLeaseStmt.setDate(3, lease.getStartDate());
            updateLeaseStmt.setDate(4, lease.getExpirationDate());
            updateLeaseStmt.setString(5, lease.getDeliveryAddress());
            updatedRows = updateLeaseStmt.executeUpdate();
            if (updatedRows != 1) {
                handleException(failureMsg, null);
            }

            connection.commit();
        } catch (SQLException sqle) {
            handleException(failureMsg, sqle);
        }
    }

    private void connectToSoundgoodDB() throws ClassNotFoundException, SQLException {
        connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/soundgood",
                "postgres", "password");
        connection.setAutoCommit(false);
    }

    private void prepareStatements() throws SQLException {
        findInstrumentByType = connection.prepareStatement(
                " SELECT i." + INSTRUMENT_PK_COLUMN + ", ? as " + INSTRUMENT_TYPE_TABLE_NAME + " , i." + INSTRUMENT_BRAND_COLUMN + ", i." + INSTRUMENT_PRICE_COLUMN +
                        " FROM " + INSTRUMENT_TABLE_NAME + " i" + " WHERE i." + INSTRUMENT_TYPE_COLUMN + " = (SELECT " + INSTRUMENT_TYPE_ID_COLUMN +
                        " FROM " + INSTRUMENT_TYPE_TABLE_NAME + " WHERE instrument_type = ?)" + " AND i." + INSTRUMENT_PK_COLUMN + " NOT IN (SELECT " + LEASE_INSTRUMENT_ID_COLUMN +
                        " FROM " + LEASE_TABLE_NAME + " WHERE " + LEASE_EXPIRATION_DATE_COLUMN + " > CURRENT_DATE)"
        );
        findInstrumentById = connection.prepareStatement(
                "SELECT i." + INSTRUMENT_PK_COLUMN + ", it." + INSTRUMENT_TYPE_TABLE_NAME + " , i." + INSTRUMENT_BRAND_COLUMN + ", i." + INSTRUMENT_PRICE_COLUMN +
                        " FROM " + INSTRUMENT_TABLE_NAME + " i" +
                        " JOIN " + INSTRUMENT_TYPE_TABLE_NAME + " it ON i." + INSTRUMENT_TYPE_COLUMN + " = it." + INSTRUMENT_TYPE_ID_COLUMN +
                        " WHERE i." + INSTRUMENT_PK_COLUMN + " = ?" +
                        " AND i." + INSTRUMENT_PK_COLUMN + " NOT IN (SELECT " + LEASE_INSTRUMENT_ID_COLUMN +
                        " FROM " + LEASE_TABLE_NAME + " WHERE " + LEASE_EXPIRATION_DATE_COLUMN + " > CURRENT_DATE)" + " FOR NO KEY UPDATE"
        );
        findStudentById = connection.prepareStatement(
                "SELECT p." + STUDENT_PERSON_ID_COLUMN + ", p." + STUDENT_PHONE_NUMBER_COLUMN + ", p." + STUDENT_NAME_COLUMN + ", p." + STUDENT_ADDRESS_COLUMN +
                        ", p." + STUDENT_PHONE_NUMBER_COLUMN + ", p." + STUDENT_EMAIL_COLUMN +
                        " FROM " + STUDENT_TABLE_NAME + " p" +
                        " WHERE p." + STUDENT_PERSON_ID_COLUMN + " = ?" +
                        " AND p." + STUDENT_PERSON_ID_COLUMN + " NOT IN (SELECT " +
                        STUDENT_PERSON_ID_COLUMN + " FROM " + INSTRUCTOR_TABLE_NAME + ")" + " FOR NO KEY UPDATE"
        );
        findLeaseByStudentId = connection.prepareStatement(
                "SELECT " + LEASE_PERSON_ID_COLUMN +
                        ", " + LEASE_INSTRUMENT_ID_COLUMN +
                        ", " + LEASE_START_DATE_COLUMN +
                        ", " + LEASE_EXPIRATION_DATE_COLUMN +
                        ", " + LEASE_DELIVERY_ADDRESS_COLUMN +
                        " FROM " + LEASE_TABLE_NAME +
                        " WHERE " + LEASE_PERSON_ID_COLUMN + " = ?" +
                        " AND " + LEASE_EXPIRATION_DATE_COLUMN + " > CURRENT_DATE" + " FOR NO KEY UPDATE"
        );
        createLeaseStmt = connection.prepareStatement(
                "INSERT INTO " + LEASE_TABLE_NAME +
                        " (" + LEASE_PERSON_ID_COLUMN +
                        ", " + LEASE_INSTRUMENT_ID_COLUMN +
                        ", " + LEASE_START_DATE_COLUMN +
                        ", " + LEASE_EXPIRATION_DATE_COLUMN +
                        ", " + LEASE_DELIVERY_ADDRESS_COLUMN +
                        ") VALUES (?, ?, ?, ?, ?)"
        );
        updateLeaseStmt = connection.prepareStatement(
                "UPDATE " + LEASE_TABLE_NAME +
                        " SET " + LEASE_START_DATE_COLUMN + " = ?" +
                        ", " + LEASE_EXPIRATION_DATE_COLUMN + " = ?" +
                        ", " + LEASE_DELIVERY_ADDRESS_COLUMN + " = ?" +
                        " WHERE " + LEASE_PERSON_ID_COLUMN + " = ?" +
                        " AND " + LEASE_INSTRUMENT_ID_COLUMN + " = ?"
        );
    }

    private void handleException(String failureMsg, Exception cause) throws SoundgoodDBException {
        String completeFailureMsg = failureMsg;
        try {
            connection.rollback();
        } catch (SQLException rollbackExc) {
            completeFailureMsg = completeFailureMsg +
                    ". Also failed to rollback transaction because of: " + rollbackExc.getMessage();
        }
        if (cause != null) {
            throw new SoundgoodDBException(failureMsg, cause);
        } else {
            throw new SoundgoodDBException(failureMsg);
        }
    }

    private void closeResultSet(String failureMsg, ResultSet result) throws SoundgoodDBException {
        try {
            result.close();
        } catch (Exception e) {
            throw new SoundgoodDBException(failureMsg + " Could not close result set.", e);
        }
    }
}