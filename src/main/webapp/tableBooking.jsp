<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.Table, model.Member" %>
<%
    Member member = (Member) session.getAttribute("member");
    List<Table> availableTables = (List<Table>) request.getAttribute("availableTables");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt bàn</title>
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
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            padding: 40px;
        }

        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 10px;
        }

        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }

        .table-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }

        .table-card {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border: 3px solid #28a745;
            border-radius: 12px;
            padding: 25px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .table-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 20px rgba(40, 167, 69, 0.4);
        }

        .table-card.selected {
            background: linear-gradient(135deg, #28a745 0%, #218838 100%);
            color: white;
            transform: translateY(-8px) scale(1.05);
        }

        .table-number {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .table-info {
            font-size: 14px;
            margin: 5px 0;
        }

        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: all 0.3s;
        }

        .btn:hover {
            background: #218838;
            transform: translateY(-2px);
        }

        .btn:disabled {
            background: #6c757d;
            cursor: not-allowed;
            opacity: 0.6;
        }

        .btn-secondary {
            background: #6c757d;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .actions {
            text-align: center;
            margin-top: 30px;
        }

        .no-tables {
            text-align: center;
            padding: 50px;
            color: #999;
            font-size: 18px;
        }

        .selected-info {
            margin-top: 20px;
            padding: 15px;
            background: #d4edda;
            border-radius: 8px;
            color: #155724;
            font-weight: bold;
            text-align: center;
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🪑 Đặt bàn</h1>
        <p class="subtitle">Chọn bàn bạn muốn ngồi, sau đó bạn có thể đặt món ngay!</p>

        <% if (error != null) { %>
            <div class="error">❌ <%= error %></div>
        <% } %>

        <% if (availableTables != null && !availableTables.isEmpty()) { %>
            <form method="post" action="table" id="bookingForm">
                <input type="hidden" name="tableId" id="selectedTableId">

                <div class="table-grid">
                    <% for (Table table : availableTables) { %>
                        <div class="table-card" onclick="selectTable(<%= table.getTableId() %>)">
                            <div class="table-number">Bàn <%= table.getTableId() %></div>
                            <div class="table-info">📍 <%= table.getLocation() %></div>
                            <div class="table-info">👥 <%= table.getCapacity() %> người</div>
                        </div>
                    <% } %>
                </div>

                <div id="selectedInfo" class="selected-info"></div>

                <div class="actions">
                    <button type="submit" class="btn" id="submitBtn" disabled>
                        ✓ Xác nhận đặt bàn
                    </button>
                    <a href="table?action=search" class="btn" style="background: #17a2b8;">🔍 Tra cứu bàn</a>
                    <a href="index.jsp" class="btn btn-secondary">← Quay lại</a>
                </div>
            </form>
        <% } else { %>
            <div class="no-tables">
                <p>😔 Hiện tại không có bàn trống</p>
                <p style="margin-top: 20px;">
                    <a href="index.jsp" class="btn">← Quay lại trang chủ</a>
                </p>
            </div>
        <% } %>
    </div>

    <script>
        let selectedTableId = null;

        function selectTable(tableId) {
            // Bỏ chọn tất cả các bàn
            document.querySelectorAll('.table-card').forEach(card => {
                card.classList.remove('selected');
            });

            // Chọn bàn mới
            event.target.closest('.table-card').classList.add('selected');
            selectedTableId = tableId;
            
            // Cập nhật form
            document.getElementById('selectedTableId').value = tableId;
            document.getElementById('submitBtn').disabled = false;
            
            // Hiển thị thông báo
            const info = document.getElementById('selectedInfo');
            info.style.display = 'block';
            info.textContent = '✓ Đã chọn bàn số ' + tableId;
        }

        // Validate form trước khi submit
        document.getElementById('bookingForm').onsubmit = function(e) {
            if (!selectedTableId) {
                e.preventDefault();
                alert('Vui lòng chọn một bàn!');
                return false;
            }
            return true;
        };
    </script>
</body>
</html>
