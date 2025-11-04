<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách món ăn</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-4">

    <h2 class="fw-bold mb-3">Danh sách món ăn</h2>

    <a href="dish?action=add" class="btn btn-success mb-3">+ Thêm món ăn</a>

    <table class="table table-bordered bg-white">
        <thead class="table-light">
        <tr>
            <th>ID</th>
            <th>Tên món</th>
            <th>Giá (VNĐ)</th>
            <th>Mô tả</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="dish" items="${dishes}">
            <tr>
                <td>${dish.id}</td>
                <td>${dish.name}</td>
                <td>
                    <fmt:setLocale value="vi_VN"/>
                    <fmt:formatNumber value="${dish.price}" type="number" groupingUsed="true"/> VNĐ
                </td>
                <td>${dish.description}</td>
                <td>
                    <a href="dish?action=edit&id=${dish.id}" class="btn btn-warning btn-sm">Sửa</a>
                    <a href="dish?action=delete&id=${dish.id}" class="btn btn-danger btn-sm"
                       onclick="return confirm('Bạn có chắc chắn muốn xóa món này không?')">Xóa</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
