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

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
    private static final String LEASE_EXPIRATION_DATE_COLUMN = "expiration_date";
    private static final String STUDENT_TABLE_NAME = "person";
    private static final String STUDENT_PERSON_ID_COLUMN = "person_id";

    private Connection connection;
    private PreparedStatement findInstrumentByType;

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

        return instruments; // Return empty list if nothing found
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