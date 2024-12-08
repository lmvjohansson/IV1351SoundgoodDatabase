package DTO;

public class StudentDTO {
	private final int id;
	private final String personNumber;
	private final String name;
	private final String address;
	private final String email;
	private final int phone;

	public StudentDTO(int id, String personNumber, String name, String address, String email, int phone) {
		this.id = id;
		this.personNumber = personNumber;
		this.name = name;
		this.address = address;
		this.email = email;
		this.phone = phone;
	}
	public int getId() {
		return id;
	}
	public String getPersonNumber() {
		return personNumber;
	}
	public String getName() {
		return name;
	}
	public String getAddress() {
		return address;
	}
	public String getEmail() {
		return email;
	}
	public int getPhone() {
		return phone;
	}
}
