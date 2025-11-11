-- ============================================
-- Script tạo database PTTK hoàn chỉnh
-- Bao gồm tất cả các bảng, foreign keys và dữ liệu mẫu
-- ============================================

-- Tạo database mới
DROP DATABASE IF EXISTS PTTK;
CREATE DATABASE PTTK CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE PTTK;

-- ============================================
-- 1. BẢNG members (Người dùng)
-- ============================================
CREATE TABLE members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('customer', 'sales_staff', 'warehouse_staff', 'manager') NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_username ON members(username);
CREATE INDEX idx_role ON members(role);

-- Dữ liệu mẫu cho members
INSERT INTO members (username, password, role, full_name, email, phone) VALUES
('manager', 'admin123', 'manager', 'Nguyễn Văn Quản Lý', 'manager@restaurant.com', '0123456789'),
('sales1', 'sales123', 'sales_staff', 'Trần Thị Bán Hàng', 'sales1@restaurant.com', '0123456790'),
('warehouse1', 'warehouse123', 'warehouse_staff', 'Lê Văn Kho', 'warehouse1@restaurant.com', '0123456791'),
('customer1', 'customer123', 'customer', 'Phạm Văn Khách', 'customer1@example.com', '0123456792'),
('customer2', 'customer123', 'customer', 'Hoàng Thị Khách', 'customer2@example.com', '0123456793'),
('customer3', 'customer123', 'customer', 'Vũ Văn Khách', 'customer3@example.com', '0123456794');

-- ============================================
-- 2. BẢNG dish_category (Danh mục món ăn)
-- ============================================
CREATE TABLE dish_category (
    categoryId INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dữ liệu mẫu cho dish_category
INSERT INTO dish_category (categoryName, description) VALUES
('Món chính', 'Các món ăn no như cơm, bún, phở'),
('Khai vị', 'Các món nhẹ dùng trước bữa ăn'),
('Tráng miệng', 'Món ngọt, hoa quả dùng sau bữa chính'),
('Đồ uống', 'Cà phê, nước ép, trà sữa'),
('Combo', 'Các combo món ăn');

-- ============================================
-- 3. BẢNG dish (Món ăn)
-- ============================================
CREATE TABLE dish (
    dishId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price INT NOT NULL,
    description TEXT,
    categoryId INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (categoryId) REFERENCES dish_category(categoryId) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_categoryId ON dish(categoryId);
CREATE INDEX idx_name ON dish(name);

-- Dữ liệu mẫu cho dish
INSERT INTO dish (name, price, description, categoryId) VALUES
('Phở Bò', 50000, 'Phở bò truyền thống', 1),
('Bún Bò Huế', 55000, 'Bún bò đặc sản Huế', 1),
('Cơm Gà', 60000, 'Cơm gà Hải Nam', 1),
('Bánh Mì Thịt Nướng', 35000, 'Bánh mì thịt nướng đặc biệt', 1),
('Gỏi Cuốn', 40000, 'Gỏi cuốn tôm thịt', 2),
('Nem Rán', 45000, 'Nem rán Hà Nội', 2),
('Chè Đậu Xanh', 25000, 'Chè đậu xanh mát lạnh', 3),
('Kem Dừa', 30000, 'Kem dừa tươi', 3),
('Cà Phê Đen', 20000, 'Cà phê đen đậm đà', 4),
('Nước Cam Ép', 35000, 'Nước cam ép tươi', 4),
('Trà Sữa', 40000, 'Trà sữa trân châu', 4),
('Combo 1 Người', 120000, 'Phở + Nước + Tráng miệng', 5),
('Combo 2 Người', 220000, '2 Phở + 2 Nước + Tráng miệng', 5);

-- ============================================
-- 4. BẢNG table (Bàn ăn)
-- ============================================
CREATE TABLE `table` (
    tableId INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(100) NOT NULL COMMENT 'Vị trí bàn (ví dụ: Tầng 1, Khu A)',
    capacity INT NOT NULL COMMENT 'Sức chứa (số người)',
    status VARCHAR(20) NOT NULL DEFAULT 'available' COMMENT 'Trạng thái: available, reserved, occupied, maintenance',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_status ON `table`(status);
CREATE INDEX idx_location ON `table`(location);

-- Dữ liệu mẫu cho table
INSERT INTO `table` (location, capacity, status) VALUES
('Tầng 1 - Khu A', 4, 'available'),
('Tầng 1 - Khu A', 4, 'available'),
('Tầng 1 - Khu B', 6, 'available'),
('Tầng 1 - Khu B', 6, 'available'),
('Tầng 2 - Khu VIP', 8, 'available'),
('Tầng 2 - Khu VIP', 10, 'available'),
('Tầng 1 - Khu C', 2, 'available'),
('Tầng 1 - Khu C', 2, 'available'),
('Tầng 2 - Khu thường', 4, 'available'),
('Tầng 2 - Khu thường', 4, 'available');

-- ============================================
-- 5. BẢNG orders (Đơn hàng)
-- ============================================
CREATE TABLE orders (
    orderId INT AUTO_INCREMENT PRIMARY KEY,
    customerId INT NOT NULL COMMENT 'ID khách hàng',
    tableId INT NULL DEFAULT NULL COMMENT 'ID bàn (NULL nếu là đơn hàng online không có bàn)',
    orderDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Ngày đặt hàng',
    status VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'Trạng thái: pending, confirmed, processing, completed, cancelled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customerId) REFERENCES members(id) ON DELETE CASCADE,
    FOREIGN KEY (tableId) REFERENCES `table`(tableId) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_customerId ON orders(customerId);
CREATE INDEX idx_tableId ON orders(tableId);
CREATE INDEX idx_status ON orders(status);
CREATE INDEX idx_orderDate ON orders(orderDate);

-- ============================================
-- 6. BẢNG order_items (Chi tiết đơn hàng)
-- ============================================
CREATE TABLE order_items (
    orderItemId INT AUTO_INCREMENT PRIMARY KEY,
    orderId INT NOT NULL,
    dishId INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price INT NOT NULL COMMENT 'Giá tại thời điểm đặt (để lưu lại giá cũ)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE,
    FOREIGN KEY (dishId) REFERENCES dish(dishId) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_orderId ON order_items(orderId);
CREATE INDEX idx_dishId ON order_items(dishId);

-- ============================================
-- KIỂM TRA KẾT QUẢ
-- ============================================
SELECT '=== KIỂM TRA DATABASE ===' AS check_result;

SELECT 'Bảng members:' AS table_name, COUNT(*) AS record_count FROM members;
SELECT 'Bảng dish_category:' AS table_name, COUNT(*) AS record_count FROM dish_category;
SELECT 'Bảng dish:' AS table_name, COUNT(*) AS record_count FROM dish;
SELECT 'Bảng table:' AS table_name, COUNT(*) AS record_count FROM `table`;
SELECT 'Bảng orders:' AS table_name, COUNT(*) AS record_count FROM orders;
SELECT 'Bảng order_items:' AS table_name, COUNT(*) AS record_count FROM order_items;

SELECT '';

-- Kiểm tra foreign keys
SELECT '=== FOREIGN KEYS ===' AS check_result;
SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA = 'PTTK'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, CONSTRAINT_NAME;

SELECT '';

SELECT '=== HOÀN TẤT ===' AS result;
SELECT 'Database PTTK đã được tạo thành công với đầy đủ dữ liệu mẫu!' AS message;

