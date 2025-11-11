<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.Table, model.Member" %>
<%
    Member member = (Member) session.getAttribute("member");
    List<Table> tables = (List<Table>) request.getAttribute("tables");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách bàn đã đặt</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            padding: 30px;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        .header-actions {
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
        }

        .btn:hover {
            background: #0056b3;
        }

        .btn-success {
            background: #28a745;
        }

        .btn-success:hover {
            background: #218838;
        }

        .btn-danger {
            background: #dc3545;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .table-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .table-card {
            background: #f8f9fa;
            border: 2px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
        }

        .table-card.reserved {
            border-color: #ffc107;
            background: #fff3cd;
        }

        .table-card.occupied {
            border-color: #dc3545;
            background: #f8d7da;
        }

        .table-id {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .table-info {
            margin: 10px 0;
            color: #666;
        }

        .table-status {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            margin: 10px 0;
        }

        .status-reserved {
            background: #ffc107;
            color: #333;
        }

        .status-occupied {
            background: #dc3545;
            color: white;
        }

        .no-tables {
            text-align: center;
            padding: 40px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Danh sách bàn đã đặt</h2>

        <div class="header-actions">
            <div>
                <a href="index.jsp" class="btn">← Về trang chủ</a>
                <% if (member != null) { %>
                    <span style="margin-left: 15px; color: #666;">Xin chào, <%= member.getUsername() %></span>
                    <a href="auth?action=logout" class="btn btn-danger" style="margin-left: 10px;">Đăng xuất</a>
                <% } %>
            </div>
            <a href="table?action=book" class="btn btn-success">+ Đặt bàn mới</a>
        </div>

        <% if (tables != null && !tables.isEmpty()) { %>
            <div class="table-grid">
                <% for (Table table : tables) { %>
                    <div class="table-card <%= table.getStatus() %>">
                        <div class="table-id">Bàn <%= table.getTableId() %></div>
                        <div class="table-info">
                            <strong>Vị trí:</strong> <%= table.getLocation() %><br>
                            <strong>Sức chứa:</strong> <%= table.getCapacity() %> người
                        </div>
                        <div class="table-status status-<%= table.getStatus() %>">
                            <%= table.getStatus().equals("reserved") ? "Đã đặt" : 
                                table.getStatus().equals("occupied") ? "Đang dùng" : table.getStatus() %>
                        </div>
                        <% if (table.isReserved() || table.isOccupied()) { %>
                            <a href="order?tableId=<%= table.getTableId() %>" class="btn" style="margin-top: 10px;">
                                Đặt món cho bàn này
                            </a>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="no-tables">
                <p>Bạn chưa đặt bàn nào.</p>
                <a href="table?action=book" class="btn btn-success" style="margin-top: 20px;">Đặt bàn ngay</a>
            </div>
        <% } %>
    </div>
</body>
</html>
