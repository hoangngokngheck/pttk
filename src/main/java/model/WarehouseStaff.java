package model;

public class WarehouseStaff extends Member {
    private String fullName;
    private String email;
    private String phone;

    public WarehouseStaff() {
        super.setRole("warehouse_staff");
    }

    public WarehouseStaff(String username, String password) {
        super(username, password, "warehouse_staff");
    }

    public WarehouseStaff(int id, String username, String password, String fullName, String email, String phone) {
        super(id, username, password, "warehouse_staff");
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


