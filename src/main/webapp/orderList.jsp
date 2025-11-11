<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.Dish, model.Member" %>
<%
    Member member = (Member) session.getAttribute("member");
    List<Dish> dishList = (List<Dish>) request.getAttribute("dishList");
    Integer currentTableId = (Integer) request.getAttribute("currentTableId");
    Integer currentOrderId = (Integer) request.getAttribute("currentOrderId");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt món</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            padding: 40px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        h1 {
            color: #333;
        }

        .user-info {
            background: #e3f2fd;
            padding: 10px 20px;
            border-radius: 8px;
            color: #1976d2;
            font-weight: bold;
        }

        .table-info {
            background: #d4edda;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            color: #155724;
            text-align: center;
            font-weight: bold;
        }

        .dish-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .dish-card {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s;
        }

        .dish-card:hover {
            border-color: #28a745;
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .dish-name {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .dish-price {
            font-size: 24px;
            color: #28a745;
            font-weight: bold;
            margin: 10px 0;
        }

        .dish-desc {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
            min-height: 40px;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s;
            text-align: center;
        }

        .btn:hover {
            background: #218838;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #6c757d;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .btn-logout {
            background: #dc3545;
        }

        .btn-logout:hover {
            background: #c82333;
        }

        .no-dishes {
            text-align: center;
            padding: 50px;
            color: #999;
        }

        .actions {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🍽️ Đặt món</h1>
            <div class="user-info">
                👤 <%= member.getUsername() %>
            </div>
        </div>

        <% if (currentTableId != null) { %>
            <div class="table-info">
                ✓ Bạn đang ngồi bàn số <%= currentTableId %> - Chọn món bạn muốn đặt!
            </div>
        <% } %>

        <div class="actions">
            <a href="index.jsp" class="btn btn-secondary">← Trang chủ</a>
            <a href="table?action=search" class="btn" style="background: #17a2b8;">🔍 Tra cứu bàn</a>
            <a href="auth?action=logout" class="btn btn-logout">Đăng xuất</a>
        </div>

        <% if (dishList != null && !dishList.isEmpty()) { %>
            <div class="dish-grid">
                <% for (Dish dish : dishList) { %>
                    <div class="dish-card">
                        <div class="dish-name"><%= dish.getName() %></div>
                        <div class="dish-price"><%= String.format("%,d", dish.getPrice()) %>đ</div>
                        <div class="dish-desc">
                            <%= dish.getDescription() != null && !dish.getDescription().isEmpty() 
                                ? dish.getDescription() : "Món ngon đặc biệt" %>
                        </div>
                        <a href="order?dishId=<%= dish.getDishId() %>" class="btn" style="width: 100%;">
                            + Đặt món
                        </a>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="no-dishes">
                <p>Hiện tại chưa có món ăn nào</p>
            </div>
        <% } %>
    </div>
</body>
</html>
