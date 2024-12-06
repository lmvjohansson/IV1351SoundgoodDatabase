package DTO;

public class InstrumentDTO {
	private final int id;
	private final String type;
	private final String brand;
	private final double price;

	public InstrumentDTO(int id, String type, String brand, double price) {
		this.id = id;
		this.type = type;
		this.brand = brand;
		this.price = price;
	}

	public int getId() {
		return id;
	}
	public String getType() {
		return type;
	}
	public String getBrand() {
		return brand;
	}
	public double getPrice() {
		return price;
	}
}
