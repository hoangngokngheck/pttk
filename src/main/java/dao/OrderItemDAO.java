package dao;

import model.OrderItem;
import model.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAO {

    // Thêm item vào order
    public void addOrderItem(OrderItem item) {
        String sql = "INSERT INTO order_items (orderId, dishId, quantity, price) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, item.getOrderId());
            stmt.setInt(2, item.getDishId());
            stmt.setInt(3, item.getQuantity());
            stmt.setInt(4, item.getPrice());

            stmt.executeUpdate();

        } catch (Exception e) {
            System.out.println("Error addOrderItem: " + e.getMessage());
        }
    }

    // Lấy tất cả items theo orderId
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE orderId = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderId(orderId);
                item.setDishId(rs.getInt("dishId"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getInt("price"));
                list.add(item);
            }

        } catch (Exception e) {
            System.out.println("Error getOrderItems: " + e.getMessage());
        }

        return list;
    }
}
