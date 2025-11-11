package model;

public class Member {
    protected int id;
    protected String username;
    protected String password;
    protected String role; // "customer", "sales_staff", "warehouse_staff", "manager"

    public Member() {}

    public Member(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role = role;
    }

    public Member(int id, String username, String password, String role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isCustomer() {
        return "customer".equals(role);
    }

    public boolean isSalesStaff() {
        return "sales_staff".equals(role);
    }

    public boolean isWarehouseStaff() {
        return "warehouse_staff".equals(role);
    }

    public boolean isManager() {
        return "manager".equals(role);
    }
}


