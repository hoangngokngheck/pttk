<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String mode = (String) request.getAttribute("mode"); // "create" | "update"
    model.Dish dish = (model.Dish) request.getAttribute("dish");
    boolean isUpdate = "update".equals(mode);
%>
<html>
<head>
    <title><%= isUpdate ? "Sửa món ăn" : "Thêm món ăn" %></title>
    <style>
        body { font-family: Arial; margin: 24px; }
        form { max-width: 420px; }
        input, textarea { width:100%; padding:8px; margin:6px 0; }
        button { padding:8px 12px; border:none; background:#007bff; color:#fff; border-radius:4px; cursor:pointer; }
        a { text-decoration:none; margin-left:8px; }
    </style>
</head>
<body>
<h2><%= isUpdate ? "Sửa món ăn" : "Thêm món ăn" %></h2>

<form action="dish" method="post">
    <input type="hidden" name="action" value="<%= isUpdate ? "update" : "create" %>"/>
    <% if (isUpdate) { %>
    <input type="hidden" name="id" value="<%= dish != null ? dish.getId() : 0 %>"/>
    <% } %>

    <label>Tên món:</label>
    <input type="text" name="name" required value="<%= isUpdate && dish != null ? dish.getName() : "" %>"/>

    <label>Giá (VNĐ):</label>
    <input type="number" name="price" required min="0" placeholder="VD: 45000"
           value="<%= isUpdate && dish != null ? dish.getPrice() : "" %>"/>

    <label>Mô tả:</label>
    <textarea name="description" rows="3"><%= isUpdate && dish != null ? dish.getDescription() : "" %></textarea>

    <button type="submit"><%= isUpdate ? "Cập nhật" : "Thêm mới" %></button>
    <a href="dish">Hủy</a>
</form>
</body>
</html>
