package dao;

import model.Order;
import model.OrderItem;
import model.Dish;
import dao.DishDAO;
import model.DBConnect;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // Thêm order và trả về id sinh ra
    public int addOrder(Order order) {
        String sql = "INSERT INTO orders (customerId, tableId, orderDate, status) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, order.getCustomerId());
            // tableId có thể NULL
            if (order.getTableId() > 0) {
                stmt.setInt(2, order.getTableId());
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }
            stmt.setTimestamp(3, Timestamp.valueOf(order.getOrderDate()));
            stmt.setString(4, order.getStatus());

            stmt.executeUpdate();

            // Lấy orderId tự sinh
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.out.println("Error addOrder: " + e.getMessage());
        }

        return -1;
    }

    // Lấy order theo id (kèm list món)
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE orderId = ?";
        Order order = null;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                order = new Order();
                order.setOrderId(orderId);
                order.setCustomerId(rs.getInt("customerId"));
                // tableId có thể NULL
                int tableId = rs.getInt("tableId");
                if (rs.wasNull()) {
                    order.setTableId(0); // 0 để đại diện cho NULL trong Java
                } else {
                    order.setTableId(tableId);
                }
                order.setOrderDate(rs.getTimestamp("orderDate").toLocalDateTime());
                order.setStatus(rs.getString("status"));
            }

        } catch (Exception e) {
            System.out.println("Error getOrderById: " + e.getMessage());
        }

        return order;
    }

    // Lấy order theo SDT khách hàng (giả sử customerId chính là SDT)
    public List<Order> getOrderByCustomerId(int customerId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE customerId = ? ORDER BY orderDate DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("orderId"));
                order.setCustomerId(customerId);
                // tableId có thể NULL
                int tableId = rs.getInt("tableId");
                if (rs.wasNull()) {
                    order.setTableId(0); // 0 để đại diện cho NULL trong Java
                } else {
                    order.setTableId(tableId);
                }
                order.setOrderDate(rs.getTimestamp("orderDate").toLocalDateTime());
                order.setStatus(rs.getString("status"));
                list.add(order);
            }

        } catch (Exception e) {
            System.out.println("Error getOrderByCustomerId: " + e.getMessage());
        }

        return list;
    }

}
