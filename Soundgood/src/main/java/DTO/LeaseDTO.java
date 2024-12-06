package DTO;

public class LeaseDTO {
	private final int studentId;
	private final int instrumentId;
	private final LocalDateTime startDate;
	private final LocalDateTime expirationDate;

	public LeaseDTO(int studentId, int instrumentId, LocalDateTime startDate, LocalDateTime expirationDate) {
		this.studentId = studentId;
		this.instrumentId = instrumentId;
		this.startDate = startDate;
		this.expirationDate = expirationDate;
	}

	public int getStudentId() {
		return studentId;
	}
	public int getInstrumentId() {
		return instrumentId;
	}
	public LocalDateTime getStartDate() {
		return startDate;
	}
	public LocalDateTime getExpirationDate() {
		return expirationDate;
	}

}
