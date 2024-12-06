package DTO;

public class ResultDTO {
	private final boolean success;
	private final String message;
	private final LeaseDTO lease;

	public ResultDTO(boolean success, String message, LeaseDTO lease) {
		this.success = success;
		this.message = message;
		this.lease = lease;
	}

	public boolean isSuccess() {
		return success;
	}
	public String getMessage() {
		return message;
	}
	public LeaseDTO getLease() {
		return lease;
	}
}
