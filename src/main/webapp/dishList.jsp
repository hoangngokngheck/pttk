<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.Member" %>
<%
    Member member = (Member) session.getAttribute("member");
    boolean isManager = member != null && member.isManager();
%>

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

    <div class="mb-3">
        <a href="index.jsp" class="btn btn-secondary">← Về trang chủ</a>
        <% if (member != null) { %>
            <span class="ms-3">Xin chào, <%= member.getUsername() %></span>
            <a href="auth?action=logout" class="btn btn-danger ms-2">Đăng xuất</a>
        <% } else { %>
            <a href="auth" class="btn btn-primary ms-2">Đăng nhập</a>
        <% } %>
        <% if (isManager) { %>
            <a href="dish?action=add" class="btn btn-success ms-2">+ Thêm món ăn</a>
        <% } %>
    </div>

    <!-- Form tìm kiếm -->
    <div class="mb-3">
        <form action="dish" method="get" class="d-inline-flex">
            <input type="hidden" name="action" value="search">
            <input type="text" name="name" class="form-control me-2" 
                   placeholder="Tìm kiếm món ăn theo tên..." 
                   value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>">
            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
        </form>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <% if (request.getAttribute("searchResult") != null) { %>
        <div class="alert alert-info" role="alert">
            <%= request.getAttribute("searchResult") %>
        </div>
    <% } %>

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
                <td>${dish.dishId}</td>
                <td>${dish.name}</td>
                <td>
                    <fmt:setLocale value="vi_VN"/>
                    <fmt:formatNumber value="${dish.price}" type="number" groupingUsed="true"/> VNĐ
                </td>
                <td>${dish.description}</td>
                <td>
                    <% if (isManager) { %>
                        <a href="dish?action=edit&id=${dish.dishId}" class="btn btn-warning btn-sm">Sửa</a>
                        <a href="dish?action=delete&id=${dish.dishId}" class="btn btn-danger btn-sm"
                           onclick="return confirm('Bạn có chắc chắn muốn xóa món này không?')">Xóa</a>
                    <% } else { %>
                        <span class="text-muted">Chỉ Manager mới có quyền chỉnh sửa</span>
                    <% } %>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
