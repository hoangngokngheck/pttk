<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.DishCategory, model.Dish" %>
<%
    String mode = (String) request.getAttribute("mode"); // "create" | "update"
    Dish dish = (Dish) request.getAttribute("dish");
    List<DishCategory> categories = (List<DishCategory>) request.getAttribute("categories");
    boolean isUpdate = "update".equals(mode);
    
    // Lấy kết quả cập nhật từ session (theo UML: outUpdateResult)
    String updateResult = (String) session.getAttribute("updateResult");
    if (updateResult != null) {
        session.removeAttribute("updateResult"); // Xóa sau khi hiển thị
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= isUpdate ? "Sửa món ăn" : "Thêm món ăn" %></title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 24px; 
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        .search-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 30px;
            border: 1px solid #dee2e6;
        }
        .search-section h3 {
            margin-top: 0;
            color: #495057;
        }
        form { 
            max-width: 100%; 
        }
        .form-group {
            margin-bottom: 20px;
        }
        label { 
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #495057;
        }
        input[type="text"], 
        input[type="number"],
        textarea,
        select { 
            width: 100%; 
            padding: 10px; 
            margin: 6px 0; 
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        button { 
            padding: 10px 20px; 
            border: none; 
            background: #007bff; 
            color: #fff; 
            border-radius: 4px; 
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
        }
        button:hover {
            background: #0056b3;
        }
        .btn-secondary {
            background: #6c757d;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        a { 
            text-decoration: none; 
            color: #007bff;
        }
        a:hover {
            text-decoration: underline;
        }
        .update-result {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .update-result.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .update-result.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .search-results {
            margin-top: 15px;
            padding: 15px;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 5px;
        }
        .search-results h4 {
            margin-top: 0;
            color: #495057;
        }
        .dish-item {
            padding: 10px;
            border-bottom: 1px solid #dee2e6;
        }
        .dish-item:last-child {
            border-bottom: none;
        }
        .dish-item strong {
            color: #007bff;
        }
    </style>
</head>
<body>
<div class="container">
    <h2><%= isUpdate ? "Sửa món ăn" : "Thêm món ăn" %></h2>

    <!-- Hiển thị kết quả cập nhật (theo UML: outUpdateResult) -->
    <% if (updateResult != null) { %>
        <div class="update-result <%= updateResult.contains("thành công") ? "success" : "error" %>">
            <strong>Kết quả:</strong> <%= updateResult %>
        </div>
    <% } %>

    <!-- Chức năng tìm kiếm món ăn (theo UML: subSearchDish) -->
    <div class="search-section">
        <h3>Tìm kiếm món ăn</h3>
        <form action="dish" method="get" id="searchForm">
            <input type="hidden" name="action" value="search">
            <div class="form-group">
                <label for="searchName">Tên món ăn (theo UML: inDishName):</label>
                <input type="text" id="searchName" name="name" 
                       placeholder="Nhập tên món ăn để tìm kiếm..." 
                       value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>">
            </div>
            <button type="submit">Tìm kiếm</button>
            <a href="dish" class="btn-secondary" style="display: inline-block; padding: 10px 20px; background: #6c757d; color: white; border-radius: 4px;">Xem tất cả</a>
        </form>

        <!-- Hiển thị kết quả tìm kiếm (theo UML: outDishList) -->
        <% 
            String searchResult = (String) request.getAttribute("searchResult");
            String searchName = (String) request.getAttribute("searchName");
            List<Dish> searchResults = (List<Dish>) request.getAttribute("dishes");
            if (searchResult != null && searchName != null && !searchName.isEmpty()) {
        %>
            <div class="search-results">
                <h4><%= searchResult %></h4>
                <% if (searchResults != null && !searchResults.isEmpty()) { %>
                    <% for (Dish d : searchResults) { %>
                        <div class="dish-item">
                            <strong><%= d.getName() %></strong> - 
                            <%= String.format("%,d", d.getPrice()) %> VNĐ
                            <% if (d.getDescription() != null && !d.getDescription().isEmpty()) { %>
                                - <%= d.getDescription() %>
                            <% } %>
                            <a href="dish?action=edit&id=<%= d.getDishId() %>" style="float: right; color: #007bff;">Sửa</a>
                        </div>
                    <% } %>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Form thêm/sửa món ăn -->
    <form action="dish" method="post">
        <input type="hidden" name="action" value="<%= isUpdate ? "update" : "create" %>"/>
        <% if (isUpdate) { %>
        <input type="hidden" name="id" value="<%= dish != null ? dish.getDishId() : 0 %>"/>
        <% } %>

        <div class="form-group">
            <label for="name">Tên món:</label>
            <input type="text" id="name" name="name" required 
                   value="<%= isUpdate && dish != null ? dish.getName() : "" %>"/>
        </div>

        <div class="form-group">
            <label for="price">Giá (VNĐ):</label>
            <input type="number" id="price" name="price" required min="0" placeholder="VD: 45000"
                   value="<%= isUpdate && dish != null ? dish.getPrice() : "" %>"/>
        </div>

        <div class="form-group">
            <label for="categoryId">Danh mục:</label>
            <select id="categoryId" name="categoryId">
                <option value="">-- Chọn danh mục (tùy chọn) --</option>
                <% if (categories != null) { 
                    int currentCategoryId = (dish != null && dish.getCategory() != null) ? 
                        dish.getCategory().getCategoryId() : 0;
                    for (DishCategory cat : categories) { 
                %>
                    <option value="<%= cat.getCategoryId() %>" 
                            <%= cat.getCategoryId() == currentCategoryId ? "selected" : "" %>>
                        <%= cat.getCategoryName() %>
                    </option>
                <% } } %>
            </select>
        </div>

        <div class="form-group">
            <label for="description">Mô tả:</label>
            <textarea id="description" name="description" rows="3"><%= isUpdate && dish != null ? dish.getDescription() : "" %></textarea>
        </div>

        <button type="submit"><%= isUpdate ? "Cập nhật" : "Thêm mới" %></button>
        <a href="dish" style="display: inline-block; padding: 10px 20px; background: #6c757d; color: white; border-radius: 4px;">Hủy</a>
    </form>
</div>
</body>
</html>
