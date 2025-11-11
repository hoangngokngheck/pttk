package dao;

import model.*;
import model.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {

    // Đăng nhập - trả về Member nếu thành công
    public Member login(String username, String password) {
        String sql = "SELECT * FROM members WHERE username = ? AND password = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String role = rs.getString("role");
                int id = rs.getInt("id");
                
                // Tạo đối tượng Member phù hợp với role
                return createMemberFromResultSet(rs, role, id);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    // Đăng ký Customer
    public boolean registerCustomer(Customer customer) {
        // Kiểm tra username đã tồn tại chưa
        if (isUsernameExists(customer.getUsername())) {
            return false;
        }
        
        String sql = "INSERT INTO members (username, password, role, full_name, email, phone, address) VALUES (?, ?, 'customer', ?, ?, ?, ?)";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, customer.getUsername());
            stmt.setString(2, customer.getPassword());
            stmt.setString(3, customer.getFullName());
            stmt.setString(4, customer.getEmail());
            stmt.setString(5, customer.getPhone());
            stmt.setString(6, customer.getAddress());
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    // Đăng ký Staff (Sales, Warehouse, Manager)
    public boolean registerStaff(Member staff, String fullName, String email, String phone) {
        // Kiểm tra username đã tồn tại chưa
        if (isUsernameExists(staff.getUsername())) {
            return false;
        }
        
        String sql = "INSERT INTO members (username, password, role, full_name, email, phone) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, staff.getUsername());
            stmt.setString(2, staff.getPassword());
            stmt.setString(3, staff.getRole());
            stmt.setString(4, fullName);
            stmt.setString(5, email);
            stmt.setString(6, phone);
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    // Kiểm tra username đã tồn tại chưa
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM members WHERE username = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    // Lấy Member theo ID
    public Member getMemberById(int id) {
        String sql = "SELECT * FROM members WHERE id = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String role = rs.getString("role");
                return createMemberFromResultSet(rs, role, id);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    // Tạo đối tượng Member từ ResultSet
    private Member createMemberFromResultSet(ResultSet rs, String role, int id) throws SQLException {
        String username = rs.getString("username");
        String password = rs.getString("password");
        String fullName = rs.getString("full_name");
        String email = rs.getString("email");
        String phone = rs.getString("phone");
        
        switch (role) {
            case "customer":
                Customer customer = new Customer(id, username, password, fullName, email, phone, rs.getString("address"));
                return customer;
                
            case "sales_staff":
                SalesStaff salesStaff = new SalesStaff(id, username, password, fullName, email, phone);
                return salesStaff;
                
            case "warehouse_staff":
                WarehouseStaff warehouseStaff = new WarehouseStaff(id, username, password, fullName, email, phone);
                return warehouseStaff;
                
            case "manager":
                Manager manager = new Manager(id, username, password, fullName, email, phone);
                return manager;
                
            default:
                return new Member(id, username, password, role);
        }
    }

    // Lấy tất cả members theo role
    public List<Member> getMembersByRole(String role) {
        List<Member> list = new ArrayList<>();
        String sql = "SELECT * FROM members WHERE role = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                int id = rs.getInt("id");
                Member member = createMemberFromResultSet(rs, role, id);
                list.add(member);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return list;
    }

    // Cập nhật thông tin member
    public boolean updateMember(Member member) {
        String sql = "UPDATE members SET username = ?, password = ?, full_name = ?, email = ?, phone = ? WHERE id = ?";
        
        // Nếu là customer, cập nhật cả address
        if (member instanceof Customer) {
            sql = "UPDATE members SET username = ?, password = ?, full_name = ?, email = ?, phone = ?, address = ? WHERE id = ?";
        }
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, member.getUsername());
            stmt.setString(2, member.getPassword());
            stmt.setString(3, getFullName(member));
            stmt.setString(4, getEmail(member));
            stmt.setString(5, getPhone(member));
            
            if (member instanceof Customer) {
                stmt.setString(6, ((Customer) member).getAddress());
                stmt.setInt(7, member.getId());
            } else {
                stmt.setInt(6, member.getId());
            }
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    // Helper methods để lấy thông tin từ các loại Member
    private String getFullName(Member member) {
        if (member instanceof Customer) {
            return ((Customer) member).getFullName();
        } else if (member instanceof SalesStaff) {
            return ((SalesStaff) member).getFullName();
        } else if (member instanceof WarehouseStaff) {
            return ((WarehouseStaff) member).getFullName();
        } else if (member instanceof Manager) {
            return ((Manager) member).getFullName();
        }
        return "";
    }

    private String getEmail(Member member) {
        if (member instanceof Customer) {
            return ((Customer) member).getEmail();
        } else if (member instanceof SalesStaff) {
            return ((SalesStaff) member).getEmail();
        } else if (member instanceof WarehouseStaff) {
            return ((WarehouseStaff) member).getEmail();
        } else if (member instanceof Manager) {
            return ((Manager) member).getEmail();
        }
        return "";
    }

    private String getPhone(Member member) {
        if (member instanceof Customer) {
            return ((Customer) member).getPhone();
        } else if (member instanceof SalesStaff) {
            return ((SalesStaff) member).getPhone();
        } else if (member instanceof WarehouseStaff) {
            return ((WarehouseStaff) member).getPhone();
        } else if (member instanceof Manager) {
            return ((Manager) member).getPhone();
        }
        return "";
    }
}


