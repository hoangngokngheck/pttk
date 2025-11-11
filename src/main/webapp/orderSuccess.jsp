<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Dish" %>

<%
    String message = (String) request.getAttribute("message");
    Dish dish = (Dish) request.getAttribute("dish");
    Integer quantity = (Integer) request.getAttribute("quantity");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt món thành công</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .success-box {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 5px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .info-box {
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 20px;
            margin-bottom: 20px;
        }
        h2 {
            color: #155724;
            margin-top: 0;
        }
        .info-row {
            margin: 10px 0;
            padding: 8px;
            background-color: #f8f9fa;
            border-radius: 3px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 10px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="success-box">
    <h2>✓ <%= message != null ? message : "Đặt món thành công!" %></h2>
</div>

<% if (dish != null && quantity != null) { %>
<div class="info-box">
    <h3>Thông tin đơn hàng:</h3>
    <div class="info-row">
        <strong>Tên món:</strong> <%= dish.getName() %>
    </div>
    <div class="info-row">
        <strong>Số lượng:</strong> <%= quantity %>
    </div>
    <div class="info-row">
        <strong>Đơn giá:</strong> <%= String.format("%,d", dish.getPrice()) %> VNĐ
    </div>
    <div class="info-row">
        <strong>Thành tiền:</strong> <%= String.format("%,d", dish.getPrice() * quantity) %> VNĐ
    </div>
</div>
<% } %>

<%
    Integer currentTableId = (Integer) session.getAttribute("currentTableId");
    Integer currentOrderId = (Integer) session.getAttribute("currentOrderId");
%>

<% if (currentTableId != null && currentOrderId != null) { %>
    <a href="order" class="btn">Tiếp tục đặt món</a>
<% } else { %>
    <a href="table?action=book" class="btn">Đặt bàn để đặt món</a>
<% } %>
<a href="index.jsp" class="btn" style="background-color: #6c757d;">Về trang chủ</a>

</body>
</html>



