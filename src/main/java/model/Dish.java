package model;

public class Dish {
    private int dishId; // Đổi từ id sang dishId theo UML
    private String name;
    private int price; // int để biểu diễn VND (có thể dùng BigDecimal nếu cần)
    private String description;
    private DishCategory category; // Thêm category theo UML

    public Dish() {}

    public Dish(int dishId, String name, int price, String description) {
        this.dishId = dishId;
        this.name = name;
        this.price = price;
        this.description = description;
    }

    public Dish(String name, int price, String description) {
        this.name = name;
        this.price = price;
        this.description = description;
    }

    public Dish(int dishId, String name, int price, String description, DishCategory category) {
        this.dishId = dishId;
        this.name = name;
        this.price = price;
        this.description = description;
        this.category = category;
    }

    // Getter/Setter cho dishId (thay vì id)
    public int getDishId() { 
        return dishId; 
    }
    
    public void setDishId(int dishId) { 
        this.dishId = dishId; 
    }

    // Giữ getId() để tương thích với code cũ (deprecated)
    @Deprecated
    public int getId() { 
        return dishId; 
    }
    
    @Deprecated
    public void setId(int id) { 
        this.dishId = id; 
    }

    public String getName() { 
        return name; 
    }
    
    public void setName(String name) { 
        this.name = name; 
    }

    public int getPrice() { 
        return price; 
    }
    
    public void setPrice(int price) { 
        this.price = price; 
    }

    public String getDescription() { 
        return description; 
    }
    
    public void setDescription(String description) { 
        this.description = description; 
    }

    public DishCategory getCategory() { 
        return category; 
    }
    
    public void setCategory(DishCategory category) { 
        this.category = category; 
    }
}
