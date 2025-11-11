package dao;

import model.Dish;
import model.DishCategory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DishDAO kế thừa từ DAO theo thiết kế UML
 */
public class DishDAO extends DAO {

    public DishDAO() {
        super();
    }

    public List<Dish> findAll() {
        List<Dish> list = new ArrayList<>();
        String sql = "SELECT d.*, dc.categoryId, dc.categoryName, dc.description as categoryDescription " +
                     "FROM dish d LEFT JOIN dish_category dc ON d.categoryId = dc.categoryId " +
                     "ORDER BY d.dishId DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Dish dish = createDishFromResultSet(rs);
                list.add(dish);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    /**
     * Lấy Dish theo ID - theo thiết kế UML
     * @param dishId ID của món ăn
     * @return Dish hoặc null nếu không tìm thấy
     */
    public Dish getDishById(int dishId) {
        String sql = "SELECT d.*, dc.categoryId, dc.categoryName, dc.description as categoryDescription " +
                     "FROM dish d LEFT JOIN dish_category dc ON d.categoryId = dc.categoryId " +
                     "WHERE d.dishId = ?";
        
        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            
            stmt.setInt(1, dishId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createDishFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách Dish theo tên - theo thiết kế UML
     * @param name Tên món ăn (có thể dùng LIKE để tìm kiếm)
     * @return List<Dish>
     */
    public List<Dish> getDishByName(String name) {
        List<Dish> list = new ArrayList<>();
        String sql = "SELECT d.*, dc.categoryId, dc.categoryName, dc.description as categoryDescription " +
                     "FROM dish d LEFT JOIN dish_category dc ON d.categoryId = dc.categoryId " +
                     "WHERE d.name LIKE ? ORDER BY d.name";
        
        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + name + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Dish dish = createDishFromResultSet(rs);
                list.add(dish);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void create(Dish d) {
        String sql = "INSERT INTO dish(name, price, description, categoryId) VALUES (?,?,?,?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, d.getName());
            ps.setInt(2, d.getPrice());
            ps.setString(3, d.getDescription());
            if (d.getCategory() != null) {
                ps.setInt(4, d.getCategory().getCategoryId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.executeUpdate();
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    /**
     * Cập nhật Dish - theo thiết kế UML: updateDish(dish : Dish) : boolean
     * @param d Dish cần cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateDish(Dish d) {
        String sql = "UPDATE dish SET name=?, price=?, description=?, categoryId=? WHERE dishId=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, d.getName());
            ps.setInt(2, d.getPrice());
            ps.setString(3, d.getDescription());
            if (d.getCategory() != null) {
                ps.setInt(4, d.getCategory().getCategoryId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setInt(5, d.getDishId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) { 
            e.printStackTrace();
            return false;
        }
    }

    public void delete(int dishId) {
        String sql = "DELETE FROM dish WHERE dishId=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, dishId);
            ps.executeUpdate();
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    /**
     * Helper method để tạo Dish từ ResultSet
     * Xử lý cả category nếu có
     */
    private Dish createDishFromResultSet(ResultSet rs) throws SQLException {
        Dish dish = new Dish();
        dish.setDishId(rs.getInt("dishId"));
        dish.setName(rs.getString("name"));
        dish.setPrice(rs.getInt("price"));
        dish.setDescription(rs.getString("description"));
        
        // Xử lý category nếu có
        try {
            int categoryId = rs.getInt("categoryId");
            if (!rs.wasNull() && categoryId > 0) {
                DishCategory category = new DishCategory();
                category.setCategoryId(categoryId);
                category.setCategoryName(rs.getString("categoryName"));
                category.setDescription(rs.getString("categoryDescription"));
                dish.setCategory(category);
            }
        } catch (SQLException e) {
            // Category không bắt buộc, bỏ qua nếu không có
        }
        
        return dish;
    }

    // Giữ lại method cũ để tương thích (deprecated)
    @Deprecated
    public Dish findById(int id) {
        return getDishById(id);
    }

    @Deprecated
    public void update(Dish d) {
        updateDish(d);
    }
}
