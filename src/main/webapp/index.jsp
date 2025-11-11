<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Member" %>
<%
    Member member = (Member) session.getAttribute("member");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Hệ thống quản lý nhà hàng</title>
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
            padding: 40px;
        }

        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }

        .user-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .user-info span {
            font-weight: bold;
            color: #667eea;
        }

        .menu {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }

        .menu-item {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            text-decoration: none;
            transition: transform 0.2s;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .menu-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
        }

        .menu-item h2 {
            margin-bottom: 10px;
            color: white;
        }

        .menu-item p {
            opacity: 0.9;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin: 5px;
        }

        .btn:hover {
            background: #218838;
        }

        .btn-logout {
            background: #dc3545;
        }

        .btn-logout:hover {
            background: #c82333;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Hệ thống quản lý nhà hàng</h1>

        <div class="user-info">
            <% if (member != null) { %>
                <div>
                    <span>Xin chào, <%= member.getUsername() %></span>
                    <span style="margin-left: 20px; color: #666;">Vai trò: 
                        <%= member.isCustomer() ? "Khách hàng" : 
                            member.isManager() ? "Quản lý" : 
                            member.isSalesStaff() ? "Nhân viên bán hàng" : 
                            member.isWarehouseStaff() ? "Nhân viên kho" : "Người dùng" %>
                    </span>
                </div>
                <div>
                    <a href="auth?action=logout" class="btn btn-logout">Đăng xuất</a>
                </div>
            <% } else { %>
                <div>
                    <span>Chưa đăng nhập</span>
                </div>
                <div>
                    <a href="auth" class="btn">Đăng nhập</a>
                    <a href="auth?action=register" class="btn">Đăng ký</a>
                </div>
            <% } %>
        </div>

        <div class="menu">
            <% if (member != null && member.isCustomer()) { %>
            <a href="table" class="menu-item">
                <h2>🪑 Đặt bàn</h2>
                <p>Đặt bàn trước khi đặt món trực tuyến</p>
            </a>
            <% } %>
            
            <a href="order" class="menu-item">
                <h2>🍽️ Đặt món</h2>
                <p>Xem danh sách món ăn và đặt món trực tuyến</p>
            </a>

            <a href="dish" class="menu-item">
                <h2>📋 Danh sách món</h2>
                <p>Xem danh sách tất cả món ăn</p>
            </a>

            <% if (member != null) { %>
            <a href="table?action=search" class="menu-item">
                <h2>🔍 Tra cứu bàn</h2>
                <p>Tìm kiếm bàn đã đặt theo tên hoặc SĐT</p>
            </a>
            <% } %>

            <% if (member != null && member.isManager()) { %>
            <a href="dish?action=add" class="menu-item">
                <h2>➕ Thêm món</h2>
                <p>Thêm món ăn mới vào menu</p>
            </a>
            <% } %>

            <% if (member == null) { %>
            <a href="auth" class="menu-item">
                <h2>🔐 Đăng nhập</h2>
                <p>Đăng nhập vào hệ thống</p>
            </a>
            <% } %>
        </div>
    </div>
</body>
</html>
