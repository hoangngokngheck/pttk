<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat, model.TableBookingInfo, model.Member" %>
<%
    Member member = (Member) session.getAttribute("member");
    List<TableBookingInfo> bookings = (List<TableBookingInfo>) request.getAttribute("bookings");
    String keyword = (String) request.getAttribute("keyword");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tra cứu bàn đã đặt</title>
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
            max-width: 1400px;
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
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-form {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .search-input {
            flex: 1;
            min-width: 250px;
            padding: 12px 20px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        .search-input:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn {
            padding: 12px 24px;
            background: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: bold;
            font-size: 16px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn:hover {
            background: #218838;
            transform: translateY(-2px);
        }

        .btn-primary {
            background: #667eea;
        }

        .btn-primary:hover {
            background: #5568d3;
        }

        .btn-secondary {
            background: #6c757d;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .info-box {
            background: #e3f2fd;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            color: #1565c0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .table-container {
            overflow-x: auto;
            margin-top: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        th {
            padding: 15px;
            text-align: left;
            font-weight: bold;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }

        tbody tr:hover {
            background: #f8f9fa;
        }

        .badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .badge-reserved {
            background: #ffc107;
            color: #333;
        }

        .badge-occupied {
            background: #dc3545;
            color: white;
        }

        .badge-pending {
            background: #17a2b8;
            color: white;
        }

        .badge-confirmed {
            background: #28a745;
            color: white;
        }

        .badge-processing {
            background: #fd7e14;
            color: white;
        }

        .no-results {
            text-align: center;
            padding: 50px;
            color: #999;
        }

        .no-results img {
            width: 150px;
            opacity: 0.5;
            margin-bottom: 20px;
        }

        .stats {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .stat-card {
            flex: 1;
            min-width: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }

        .stat-number {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 14px;
            opacity: 0.9;
        }

        .customer-info {
            display: flex;
            flex-direction: column;
            gap: 3px;
        }

        .customer-name {
            font-weight: bold;
            color: #333;
        }

        .customer-detail {
            font-size: 13px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔍 Tra cứu bàn đã đặt</h1>
            <div>
                <a href="index.jsp" class="btn btn-secondary">← Trang chủ</a>
            </div>
        </div>

        <!-- Form tìm kiếm -->
        <form action="table" method="get" class="search-form">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="search-input" 
                   placeholder="Nhập tên khách hàng hoặc số điện thoại..."
                   value="<%= keyword != null ? keyword : "" %>">
            <button type="submit" class="btn btn-primary">🔍 Tìm kiếm</button>
            <a href="table?action=search" class="btn btn-secondary">🔄 Xem tất cả</a>
        </form>

        <!-- Thông tin tìm kiếm -->
        <% if (keyword != null && !keyword.isEmpty()) { %>
            <div class="info-box">
                ℹ️ Tìm thấy <strong><%= bookings != null ? bookings.size() : 0 %></strong> kết quả cho từ khóa: "<strong><%= keyword %></strong>"
            </div>
        <% } %>

        <!-- Thống kê -->
        <% if (bookings != null && !bookings.isEmpty()) { %>
            <div class="stats">
                <div class="stat-card">
                    <div class="stat-number"><%= bookings.size() %></div>
                    <div class="stat-label">Tổng số booking</div>
                </div>
            </div>
        <% } %>

        <!-- Bảng kết quả -->
        <% if (bookings != null && !bookings.isEmpty()) { %>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Bàn số</th>
                            <th>Vị trí</th>
                            <th>Sức chứa</th>
                            <th>Khách hàng</th>
                            <th>Liên hệ</th>
                            <th>Ngày đặt</th>
                            <th>Trạng thái bàn</th>
                            <th>Trạng thái order</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (TableBookingInfo booking : bookings) { %>
                            <tr>
                                <td><strong>Bàn <%= booking.getTableId() %></strong></td>
                                <td><%= booking.getLocation() %></td>
                                <td>👥 <%= booking.getCapacity() %> người</td>
                                <td>
                                    <div class="customer-info">
                                        <span class="customer-name"><%= booking.getCustomerName() != null && !booking.getCustomerName().isEmpty() 
                                            ? booking.getCustomerName() : "Khách hàng" %></span>
                                        <span class="customer-detail">ID: <%= booking.getCustomerId() %></span>
                                    </div>
                                </td>
                                <td>
                                    <div class="customer-info">
                                        <% if (booking.getCustomerPhone() != null && !booking.getCustomerPhone().isEmpty()) { %>
                                            <span class="customer-detail">📞 <%= booking.getCustomerPhone() %></span>
                                        <% } %>
                                        <% if (booking.getCustomerEmail() != null && !booking.getCustomerEmail().isEmpty()) { %>
                                            <span class="customer-detail">✉️ <%= booking.getCustomerEmail() %></span>
                                        <% } %>
                                    </div>
                                </td>
                                <td><%= sdf.format(booking.getOrderDate()) %></td>
                                <td>
                                    <span class="badge badge-<%= booking.getTableStatus() %>">
                                        <%= booking.getTableStatus().equals("reserved") ? "Đã đặt" : 
                                            booking.getTableStatus().equals("occupied") ? "Đang dùng" : 
                                            booking.getTableStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge badge-<%= booking.getOrderStatus() %>">
                                        <%= booking.getOrderStatus().equals("pending") ? "Chờ xác nhận" : 
                                            booking.getOrderStatus().equals("confirmed") ? "Đã xác nhận" : 
                                            booking.getOrderStatus().equals("processing") ? "Đang xử lý" : 
                                            booking.getOrderStatus() %>
                                    </span>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } else { %>
            <div class="no-results">
                <p style="font-size: 48px;">🔍</p>
                <h3 style="color: #666; margin-bottom: 10px;">Không tìm thấy kết quả</h3>
                <p>
                    <% if (keyword != null && !keyword.isEmpty()) { %>
                        Không có bàn nào được đặt bởi khách hàng có tên hoặc số điện thoại chứa "<%= keyword %>"
                    <% } else { %>
                        Hiện tại chưa có bàn nào được đặt
                    <% } %>
                </p>
            </div>
        <% } %>
    </div>
</body>
</html>

