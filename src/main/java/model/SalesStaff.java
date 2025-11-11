package model;

public class SalesStaff extends Member {
    private String fullName;
    private String email;
    private String phone;

    public SalesStaff() {
        super.setRole("sales_staff");
    }

    public SalesStaff(String username, String password) {
        super(username, password, "sales_staff");
    }

    public SalesStaff(int id, String username, String password, String fullName, String email, String phone) {
        super(id, username, password, "sales_staff");
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
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
}


