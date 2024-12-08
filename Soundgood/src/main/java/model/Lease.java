package model;

import DTO.InstrumentDTO;
import DTO.LeaseDTO;
import DTO.StudentDTO;

import java.time.LocalDate;

public class Lease {
    private int studentId;
    private int instrumentId;
    private LocalDate startDate;
    private LocalDate expirationDate;
    private String deliveryAddress;

    public Lease(int studentId, int instrumentId, LocalDate startDate, LocalDate expirationDate, String deliveryAddress) {
        this.studentId = studentId;
        this.instrumentId = instrumentId;
        this.startDate = startDate;
        this.expirationDate = expirationDate;
        this.deliveryAddress = deliveryAddress;
    }

    public Lease(StudentDTO student, InstrumentDTO instrument) {
        this.studentId = student.getId();
        this.instrumentId = instrument.getId();
        this.startDate = LocalDate.now();
        this.expirationDate = this.startDate.plusMonths(1);
        this.deliveryAddress = student.getAddress();
    }

    public Lease(LeaseDTO lease) {
        this.studentId = lease.getStudentId();
        this.instrumentId = lease.getInstrumentId();
        this.startDate = lease.getStartDate();
        this.expirationDate = lease.getExpirationDate();
        this.deliveryAddress = lease.getDeliveryAddress();
    }

    public void terminateRental() {
        this.expirationDate = LocalDate.now();
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getInstrumentId() {
        return instrumentId;
    }

    public void setInstrumentId(int instrumentId) {
        this.instrumentId = instrumentId;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(LocalDate expirationDate) {
        this.expirationDate = expirationDate;
    }
}
