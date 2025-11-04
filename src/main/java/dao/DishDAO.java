package dao;

import model.DBConnect;
import model.Dish;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DishDAO {

    public List<Dish> findAll() {
        List<Dish> list = new ArrayList<>();
        String sql = "SELECT * FROM dish ORDER BY id DESC";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Dish(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("price"), // int
                        rs.getString("description")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Dish findById(int id) {
        String sql = "SELECT * FROM dish WHERE id=?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try(ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Dish(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getInt("price"),
                            rs.getString("description")
                    );
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public void create(Dish d) {
        String sql = "INSERT INTO dish(name, price, description) VALUES (?,?,?)";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, d.getName());
            ps.setInt(2, d.getPrice());
            ps.setString(3, d.getDescription());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void update(Dish d) {
        String sql = "UPDATE dish SET name=?, price=?, description=? WHERE id=?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, d.getName());
            ps.setInt(2, d.getPrice());
            ps.setString(3, d.getDescription());
            ps.setInt(4, d.getId());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void delete(int id) {
        String sql = "DELETE FROM dish WHERE id=?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}
