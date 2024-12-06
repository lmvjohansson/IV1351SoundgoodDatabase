package DTO;

public class StudentAndInstrumentDTO {
	private final int studentId;
	private final int instrumentId;

	public StudentAndInstrumentDTO(int studentId, int instrumentId) {
		this.studentId = studentId;
		this.instrumentId = instrumentId;
	}

	public int getStudentId() {
		return studentId;
	}
	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}
}
