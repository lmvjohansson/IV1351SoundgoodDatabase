package model;

import java.time.LocalDateTime;

public class Lease {
    private int studentId;
    private int instrumentId;
    private String deliveryAddress;
    private LocalDateTime startDate;
    private LocalDateTime expirationDate;

    public Lease(int studentId, int instrumentId, String deliveryAddress, LocalDateTime startDate, LocalDateTime expirationDate) {
        this.studentId = studentId;
        this.instrumentId = instrumentId;
        this.deliveryAddress = deliveryAddress;
        this.startDate = startDate;
        this.expirationDate = expirationDate;
    }

    public Lease(StudentAndInstrumentDTO dto) {
        this.studentId = dto.getStudentId();
        this.instrumentId = dto.getInstrumentId();
        this.deliveryAddress = dto.getDeliveryAddress();
        this.startDate = LocalDateTime.now();
        this.expirationDate = this.startDate.plusMonths(12);
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

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public LocalDateTime getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(LocalDateTime expirationDate) {
        this.expirationDate = expirationDate;
    }

    public void terminateRental() {
        this.expirationDate = LocalDateTime.now();
    }
}
