package dao;

import model.*;
import java.sql.*;
import java.util.*;

public class DishCategoryDAO {

    public List<DishCategory> getAllCategories() {
        List<DishCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM dish_category ORDER BY categoryId";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DishCategory c = new DishCategory(
                        rs.getInt("categoryId"),
                        rs.getString("categoryName"),
                        rs.getString("description")
                );
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
