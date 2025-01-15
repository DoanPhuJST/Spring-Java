<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/static/css/admin.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> </head>

</head>
<body>
<nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
    <a class="navbar-brand" href="#">Admin Panel</a>
    <a style="float: right" class="navbar-brand" href="/logout">Logout</a>
    <%-- Các mục navbar khác nếu cần --%>
</nav>
<br>
<br>
<div class="container-fluid">
    <div class="row">
        <nav class="col-md-3 col-lg-2 d-md-block bg-light sidebar">
            <div class="sidebar-sticky pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="/admin">Quản lý đơn thuê</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/admin/vehicles">Quản lý xe</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/admin/vehicleTypes">Quản lý loại xe</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/rentals/monthly-revenue">Thống kê doanh thu</a>
                    </li>
                    <%-- Các mục sidebar khác --%>
                </ul>
            </div>
        </nav>

