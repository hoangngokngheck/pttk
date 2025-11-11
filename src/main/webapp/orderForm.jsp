<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Dish" %>

<%
    Dish dish = (Dish) request.getAttribute("dish");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt món</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .form-container {
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 30px;
        }
        h2 {
            color: #333;
            margin-top: 0;
        }
        .dish-info {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .price {
            font-size: 18px;
            color: #007bff;
            font-weight: bold;
        }
        label {
            display: block;
            margin: 15px 0 5px 0;
            font-weight: bold;
        }
        input[type="number"] {
            width: 100px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 15px;
        }
        button:hover {
            background-color: #218838;
        }
        .btn-back {
            display: inline-block;
            margin-top: 10px;
            padding: 8px 15px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .btn-back:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>

<% if (dish != null) { %>

<div class="form-container">
    <h2>Đặt món: <%= dish.getName() %></h2>
    
    <div class="dish-info">
        <p><strong>Mô tả:</strong> <%= dish.getDescription() != null ? dish.getDescription() : "Không có mô tả" %></p>
        <p class="price">Giá: <%= String.format("%,d", dish.getPrice()) %> VNĐ</p>
    </div>

    <form action="order" method="post">
        <input type="hidden" name="dishId" value="<%= dish.getDishId() %>">
        <label for="quantity">Số lượng:</label>
        <input type="number" id="quantity" name="quantity" min="1" value="1" required>
        
        <br>
        <button type="submit">Xác nhận đặt món</button>
    </form>
    
    <a href="order" class="btn-back">← Quay lại danh sách món</a>
</div>

<% } else { %>

<div class="form-container">
    <h3>Không tìm thấy món ăn!</h3>
    <a href="order" class="btn-back">← Quay lại danh sách món</a>
</div>

<% } %>

</body>
</html>
