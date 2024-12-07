/*
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

package controller;

import DTO.InstrumentDTO;
import DTO.ResultDTO;
import integration.SoundgoodDAO;
import integration.SoundgoodDBException;
import model.LeaseException;

import java.util.ArrayList;

public class Controller {
    private final SoundgoodDAO soundgoodDb;

    /**
     * Creates a new instance, and retrieves a connection to the database.
     *
     * @throws SoundgoodDBException If unable to connect to the database.
     */
    public Controller() throws SoundgoodDBException {
        soundgoodDb = new SoundgoodDAO();
    }

    /**
     * Lists all instruments that are not currently rented out of the specified type.
     *
     * @return A list containing instruments. The list is empty if there are no
     *         available instruments.
     * @throws SoundgoodDBException If unable to retrieve accounts.
     */
    public ArrayList<InstrumentDTO> listInstruments(String instrumentType) throws SoundgoodDBException {
        try {
            return soundgoodDb.findInstrumentByType(instrumentType);
        } catch (Exception e) {
            throw new SoundgoodDBException("Unable to list instruments.", e);
        }
    }

    /**
     *
     * @param studentId
     * @param instrumentId
     * @return
     * @throws LeaseException
     */
    public ResultDTO createLease(int studentId, int instrumentId) throws LeaseException {
//        String failureMsg = "Could not create account for: " + holderName;
//
//        if (holderName == null) {
//            throw new LeaseException(failureMsg);
//        }
//
//        try {
//            bankDb.createAccount(new Account(holderName));
//        } catch (Exception e) {
//            throw new LeaseException(failureMsg, e);
//        }
    }

    /**
     *
     * @param studentId
     * @param instrumentId
     * @return
     * @throws LeaseException
     */
    public ResultDTO terminateRental(int studentId, int instrumentId) throws LeaseException {
//        String failureMsg = "Could not delete account: " + acctNo;
//
//        if (acctNo == null) {
//            throw new LeaseException(failureMsg);
//        }
//
//        try {
//            bankDb.deleteAccount(acctNo);
//        } catch (Exception e) {
//            throw new LeaseException(failureMsg, e);
//        }
    }

    private void commitOngoingTransaction(String failureMsg) throws LeaseException {
        try {
            soundgoodDb.commit();
        } catch (SoundgoodDBException sgdbe) {
            throw new LeaseException(failureMsg, sgdbe);
        }
    }
}
