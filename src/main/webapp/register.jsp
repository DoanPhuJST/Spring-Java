<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Đăng ký</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color:cornflowerblue /* Màu nền nhạt */
        }

        .registration-form {
            max-width: 500px;
            margin: 50px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .error {
            color: red;
            font-size: small; /* kích thước chữ nhỏ hơn */
        }
        .form-group label{
            font-weight: 500;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="registration-form">
        <h2 class="text-center mb-4">Đăng ký</h2>
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <form:form modelAttribute="account" method="post">
            <div class="mb-3">
                <form:label path="username" class="form-label">Tên đăng nhập:</form:label>
                <form:input path="username" class="form-control"/>
                <form:errors path="username" cssClass="error"/>
                <c:if test="${not empty usernameError}">
                    <div class="error">${usernameError}</div>
                </c:if>
            </div>
            <div class="mb-3">
                <form:label path="password" class="form-label">Mật khẩu:</form:label>
                <form:password path="password" class="form-control"/>
                <form:errors path="password" cssClass="error"/>
            </div>
            <div class="mb-3">
                <form:label path="fullname" class="form-label">Họ và tên:</form:label>
                <form:input path="fullname" class="form-control"/>
                <form:errors path="fullname" cssClass="error"/>
            </div>
            <div class="mb-3">
                <form:label path="email" class="form-label">Email:</form:label>
                <form:input path="email" type="email" class="form-control"/>
                <form:errors path="email" cssClass="error"/>
                <c:if test="${not empty emailError}">
                    <div class="error">${emailError}</div>
                </c:if>
            </div>
            <div class="mb-3">
                <form:label path="phone" class="form-label">Số điện thoại:</form:label>
                <form:input path="phone" class="form-control"/>
                <form:errors path="phone" cssClass="error"/>
            </div>
            <div class="mb-3">
                <form:label path="license" class="form-label">Bằng lái xe:</form:label>
                <form:input path="license" class="form-control"/>
                <form:errors path="license" cssClass="error"/>
            </div>
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">Đăng ký</button>
            </div>
        </form:form>
        <a href="/login">Đăng nhập</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>