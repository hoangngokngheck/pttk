package dao;

import model.Table;
import model.TableBookingInfo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TableDAO extends DAO {

    /**
     * Lấy tất cả bàn
     */
    public List<Table> findAll() {
        List<Table> list = new ArrayList<>();
        String sql = "SELECT * FROM `table` ORDER BY tableId";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(createTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy bàn theo ID
     */
    public Table getTableById(int tableId) {
        String sql = "SELECT * FROM `table` WHERE tableId = ?";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, tableId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return createTableFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách bàn trống (available)
     */
    public List<Table> getAvailableTables() {
        List<Table> list = new ArrayList<>();
        String sql = "SELECT * FROM `table` WHERE status = 'available' ORDER BY tableId";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(createTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy bàn đã đặt của customer
     */
    public List<Table> getTablesByCustomerId(int customerId) {
        List<Table> list = new ArrayList<>();
        String sql = "SELECT DISTINCT t.* " +
                     "FROM `table` t " +
                     "INNER JOIN orders o ON t.tableId = o.tableId " +
                     "WHERE o.customerId = ? " +
                     "AND o.status IN ('pending', 'confirmed', 'processing') " +
                     "ORDER BY o.orderDate DESC";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(createTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đặt bàn - tạo order và cập nhật trạng thái bàn
     */
    public int bookTable(int tableId, int customerId) {
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false);
            
            // 1. Tạo order
            String insertOrderSql = "INSERT INTO orders (customerId, tableId, orderDate, status) VALUES (?, ?, NOW(), 'pending')";
            PreparedStatement ps = con.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, customerId);
            ps.setInt(2, tableId);
            ps.executeUpdate();
            
            // 2. Lấy orderId
            ResultSet rs = ps.getGeneratedKeys();
            if (!rs.next()) {
                con.rollback();
                return -1;
            }
            int orderId = rs.getInt(1);
            ps.close();
            
            // 3. Cập nhật trạng thái bàn
            String updateTableSql = "UPDATE `table` SET status = 'reserved' WHERE tableId = ?";
            PreparedStatement updatePs = con.prepareStatement(updateTableSql);
            updatePs.setInt(1, tableId);
            int updated = updatePs.executeUpdate();
            updatePs.close();
            
            if (updated > 0) {
                con.commit();
                return orderId;
            } else {
                con.rollback();
                return -1;
            }
            
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            System.err.println("Error booking table: " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Cập nhật trạng thái bàn
     */
    public boolean updateTableStatus(int tableId, String status) {
        String sql = "UPDATE `table` SET status = ? WHERE tableId = ?";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, tableId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Tìm kiếm bàn đã đặt theo tên hoặc số điện thoại khách hàng
     */
    public List<TableBookingInfo> searchBookings(String keyword) {
        List<TableBookingInfo> list = new ArrayList<>();
        String sql = "SELECT t.tableId, t.location, t.capacity, t.status as tableStatus, " +
                     "       o.orderId, o.orderDate, o.status as orderStatus, " +
                     "       m.id as customerId, m.full_name, m.phone, m.email " +
                     "FROM `table` t " +
                     "INNER JOIN orders o ON t.tableId = o.tableId " +
                     "INNER JOIN members m ON o.customerId = m.id " +
                     "WHERE (m.full_name LIKE ? OR m.phone LIKE ?) " +
                     "  AND o.status IN ('pending', 'confirmed', 'processing') " +
                     "ORDER BY o.orderDate DESC";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                TableBookingInfo info = new TableBookingInfo();
                info.setTableId(rs.getInt("tableId"));
                info.setLocation(rs.getString("location"));
                info.setCapacity(rs.getInt("capacity"));
                info.setTableStatus(rs.getString("tableStatus"));
                
                info.setOrderId(rs.getInt("orderId"));
                info.setOrderDate(rs.getTimestamp("orderDate"));
                info.setOrderStatus(rs.getString("orderStatus"));
                
                info.setCustomerId(rs.getInt("customerId"));
                info.setCustomerName(rs.getString("full_name"));
                info.setCustomerPhone(rs.getString("phone"));
                info.setCustomerEmail(rs.getString("email"));
                
                list.add(info);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy tất cả bàn đã đặt (đang active)
     */
    public List<TableBookingInfo> getAllBookings() {
        List<TableBookingInfo> list = new ArrayList<>();
        String sql = "SELECT t.tableId, t.location, t.capacity, t.status as tableStatus, " +
                     "       o.orderId, o.orderDate, o.status as orderStatus, " +
                     "       m.id as customerId, m.full_name, m.phone, m.email " +
                     "FROM `table` t " +
                     "INNER JOIN orders o ON t.tableId = o.tableId " +
                     "INNER JOIN members m ON o.customerId = m.id " +
                     "WHERE o.status IN ('pending', 'confirmed', 'processing') " +
                     "ORDER BY o.orderDate DESC";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                TableBookingInfo info = new TableBookingInfo();
                info.setTableId(rs.getInt("tableId"));
                info.setLocation(rs.getString("location"));
                info.setCapacity(rs.getInt("capacity"));
                info.setTableStatus(rs.getString("tableStatus"));
                
                info.setOrderId(rs.getInt("orderId"));
                info.setOrderDate(rs.getTimestamp("orderDate"));
                info.setOrderStatus(rs.getString("orderStatus"));
                
                info.setCustomerId(rs.getInt("customerId"));
                info.setCustomerName(rs.getString("full_name"));
                info.setCustomerPhone(rs.getString("phone"));
                info.setCustomerEmail(rs.getString("email"));
                
                list.add(info);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Helper method: Tạo Table từ ResultSet
     */
    private Table createTableFromResultSet(ResultSet rs) throws SQLException {
        return new Table(
            rs.getInt("tableId"),
            rs.getString("location"),
            rs.getInt("capacity"),
            rs.getString("status")
        );
    }
}
