package DTO;

import model.Lease;

import java.time.LocalDate;

public class LeaseDTO {
	private final int studentId;
	private final int instrumentId;
	private final LocalDate startDate;
	private final LocalDate expirationDate;
	private final String deliveryAddress;

	public LeaseDTO(int studentId, int instrumentId, LocalDate startDate, LocalDate expirationDate, String deliveryAddress) {
		this.studentId = studentId;
		this.instrumentId = instrumentId;
		this.startDate = startDate;
		this.expirationDate = expirationDate;
		this.deliveryAddress = deliveryAddress;
	}

	public LeaseDTO(Lease lease) {
		this.studentId = lease.getStudentId();
		this.instrumentId = lease.getInstrumentId();
		this.startDate = lease.getStartDate();
		this.expirationDate = lease.getExpirationDate();
		this.deliveryAddress = lease.getDeliveryAddress();
	}

	public int getStudentId() {
		return studentId;
	}
	public int getInstrumentId() {
		return instrumentId;
	}
	public LocalDate getStartDate() {
		return startDate;
	}
	public LocalDate getExpirationDate() {
		return expirationDate;
	}
	public String getDeliveryAddress() {
		return deliveryAddress;
	}

}
