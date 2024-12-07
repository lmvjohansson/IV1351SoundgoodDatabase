package DTO;

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
