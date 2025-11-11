package model;

public class Customer extends Member {
    private String fullName;
    private String email;
    private String phone;
    private String address;

    public Customer() {
        super.setRole("customer");
    }

    public Customer(String username, String password) {
        super(username, password, "customer");
    }

    public Customer(int id, String username, String password, String fullName, String email, String phone, String address) {
        super(id, username, password, "customer");
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}


