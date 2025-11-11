package model;

import java.util.ArrayList;
import java.util.List;

public class DishCategory {
    private int categoryId;
    private String categoryName;
    private String description;
    private List<Dish> dishes; // Thêm dishes theo UML (composition relationship)

    public DishCategory() {
        this.dishes = new ArrayList<>();
    }

    public DishCategory(int categoryId, String categoryName, String description) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = description;
        this.dishes = new ArrayList<>();
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Dish> getDishes() {
        return dishes;
    }

    public void setDishes(List<Dish> dishes) {
        this.dishes = dishes;
    }

    public void addDish(Dish dish) {
        if (this.dishes == null) {
            this.dishes = new ArrayList<>();
        }
        this.dishes.add(dish);
    }

    public void removeDish(Dish dish) {
        if (this.dishes != null) {
            this.dishes.remove(dish);
        }
    }

    @Override
    public String toString() {
        return categoryName;
    }
}
