<%@ page import="com.model.Rental" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<html>
<head>
    <title>Lịch sử thuê xe</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .car_info_section {
            padding-top: 30px;
            padding-bottom: 30px;
        }

        .img-box img {
            max-width: 100%;
            height: auto;
            border-radius: 8px; /* Bo góc ảnh */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Tạo bóng đổ */
        }

        .detail-box {
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            background-color: #f8f9fa; /* Màu nền nhạt */
        }

        .detail-box p strong {
            font-weight: 600; /* In đậm label */
        }

        .form-group label {
            font-weight: 500;
        }
    </style>
    <title>Thuê xe đi</title>

    <!-- slider stylesheet -->
    <link rel="stylesheet" type="text/css"
          href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/vn.js"></script>
    <!-- bootstrap core css -->
    <link rel="stylesheet" type="text/css" href="/css/bootstrap.css"/>

    <!-- fonts style -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:400,700|Poppins:400,600,700&display=swap"
          rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="/css/style.css" rel="stylesheet"/>
    <!-- responsive style -->
    <link href="/css/responsive.css" rel="stylesheet"/>
    <style>
        .table-responsive {
            overflow-x: auto;
        }
    </style>
</head>
<body class="sub_page">
<div class="hero_area">
    <!-- header section strats -->
    <header class="header_section">
        <div class="container-fluid">
            <nav class="navbar navbar-expand-lg custom_nav-container">
                <a class="navbar-brand" href="/home">
            <span>
              Thuê xe đi
            </span>
                </a>

                <div class="navbar-collapse" id="">
                    <div class="user_option">
                        <sec:authorize access="!isAuthenticated()">
                            <a href="/login">Login</a>
                        </sec:authorize>
                        <sec:authorize access="isAuthenticated()">
                            <a href="/my-rentals" style="color: white">Xin chào, <sec:authentication property="principal.username"/></a>
                            <a href="/logout"> | Logout</a>
                        </sec:authorize>
                    </div>
                    <div class="custom_menu-btn">
                        <button onclick="openNav()">
                            <span class="s-1"> </span>
                            <span class="s-2"> </span>
                            <span class="s-3"> </span>
                        </button>
                    </div>
                    <div id="myNav" class="overlay">
                        <div class="overlay-content">
                            <a href="/home">Home</a>
                            <a href="blog.html">Blog</a>
                            <a href="contact.html">Contact Us</a>
                            <sec:authorize access="!isAuthenticated()">
                                <a href="/login">Login</a>
                            </sec:authorize>
                            <sec:authorize access="isAuthenticated()">
                                <a href="/logout">Logout</a>
                            </sec:authorize>
                        </div>
                    </div>
                </div>            </nav>
        </div>
    </header>
    <!-- end header section -->
    <!-- slider section -->
    <section class="slider_section position-relative">
        <div class="slider_container" style="max-height: 200px; overflow: hidden;">
            <div class="img-box">
                <img src="/images/hero-img.jpg" alt="" style="object-fit: cover; width: 100%; height: 100%;">
            </div>
            <div class="detail_container">
                <div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
                </div>
            </div>
        </div>
    </section>  <!-- end slider section -->
</div>
<!-- book section -->
<section class="book_section">
    <div class="form_container">
        <form action="/search">
            <div class="form-row">
                <div class="col-lg-8">
                    <div class="form-row">
                        <div class="col-md-4">
                            <label>Category</label>
                            <select class="form-control" name="category">
                                <option value="">Tất cả</option> <%-- Thêm option "Tất cả" --%>
                                <c:forEach items="${allVehicleTypes}" var="vehicleType">
                                    <option value="${vehicleType.name}" ${param.category == vehicleType.name ? 'selected':''}>${vehicleType.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label>Pick Up Date</label>
                            <input type="date" name="pickupDate" class="form-control" placeholder="07/09/2020">
                        </div>
                        <div class="col-md-4">
                            <label>Return Date</label>
                            <input type="date" name="returnDate" class="form-control" placeholder="07/09/2020">
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="btn-container">
                        <button type="submit" class="">
                            Search
                        </button>
                    </div>
                </div>
            </div>

        </form>
    </div>
    <div class="img-box">
        <img src="images/book-car.png" alt="">
    </div>
</section>

<div class="container">
    <h1 class="mt-4">Lịch sử thuê xe của tôi</h1>

    <c:if test="${not empty message}">
        <div class="alert alert-${message.contains('thành công') ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
                ${message}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </c:if>

    <form action="/my-rentals" method="get" class="mb-3">
        <div class="form-row">
            <div class="col-md-3">
                <label for="status">Lọc theo trạng thái:</label>
                <select name="status" id="status" class="form-control">
                    <option value="">Tất cả</option>
                    <c:forEach var="status" items="<%= Rental.TrangThai.values() %>">
                        <option value="${status}" ${param.status == status ? 'selected' : ''}>${status}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3 align-self-end">
                <button type="submit" class="btn btn-primary">Lọc</button>
            </div>
        </div>
    </form>


    <c:if test="${not empty rentals}">
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <thead>
                <tr>
                    <th>ID thuê</th>
                    <th>Xe</th>
                    <th>Ngày bắt đầu</th>
                    <th>Ngày kết thúc</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="rental" items="${rentals}">
                    <tr>
                        <td>${rental.id}</td>
                        <td>${rental.vehicle.company} - ${rental.vehicle.bienSo}</td>
                        <td>${formatter.format(rental.startDate)}</td>
                        <td>${formatter.format(rental.endDate)}</td>
                        <td><fmt:formatNumber value="${rental.total}" pattern="#,###" /> VNĐ</td>
                        <td>${rental.status}</td>
                        <td>
                            <c:if test="${rental.status == 'choDuyet'}">
                                <form method="post" action="/rentals/${rental.id}/cancel">
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('Bạn có chắc chắn muốn hủy lịch thuê này?')">Hủy</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>    <c:if test="${empty rentals}">
        <p>Bạn chưa có lịch sử thuê xe.</p>
    </c:if>
</div>
<br/>
<br/>
<br/>
<footer class="container-fluid footer_section">
    <p>
        Copyright &copy; 2020 All Rights Reserved. Design by
        <a href="https://html.design/">Free Html Templates</a> Distributed by <a href="https://themewagon.com">ThemeWagon</a>
    </p>
</footer>
</body>
</html>
<script src="/js/jquery-3.4.1.min.js"></script>
<script src="/js/bootstrap.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js">
</script>
<script src="/js/custom.js"></script>