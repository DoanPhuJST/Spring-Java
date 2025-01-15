<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>

<head>
    <!-- Basic -->
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <!-- Mobile Metas -->
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <!-- Site Metas -->
    <meta name="keywords" content=""/>
    <meta name="description" content=""/>
    <meta name="author" content=""/>

    <title>Thuê xe đi</title>

    <!-- slider stylesheet -->
    <link rel="stylesheet" type="text/css"
          href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"/>

    <!-- bootstrap core css -->
    <link rel="stylesheet" type="text/css" href="css/bootstrap.css"/>

    <!-- fonts style -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:400,700|Poppins:400,600,700&display=swap"
          rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/style.css" rel="stylesheet"/>
    <!-- responsive style -->
    <link href="css/responsive.css" rel="stylesheet"/>
    <style>
        .rent_section .rent_container .box .img-box img {
            max-height: 200px; /* Điều chỉnh chiều cao tối đa của ảnh */
            width: 100%;
            object-fit: cover; /* Đảm bảo ảnh không bị méo */
        }
    </style>
</head>

<body>
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
                </div>
            </nav>
        </div>
    </header>
    <!-- end header section -->
    <!-- slider section -->
    <section class=" slider_section position-relative">
        <div class="slider_container">
            <div class="img-box">
                <img src="/images/hero-img.jpg" alt="">
            </div>
            <div class="detail_container">
                <div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
                    <div class="carousel-inner">
                        <div class="carousel-item active">
                            <div class="detail-box">
                                <h1>
                                    Rent Car <br>
                                    Experts <br>
                                    Service
                                </h1>
                                <a href="">
                                    Contact Us
                                </a>
                            </div>
                        </div>
                        <div class="carousel-item">
                            <div class="detail-box">
                                <h1>
                                    Rent Car <br>
                                    Experts <br>
                                    Service
                                </h1>
                                <a href="">
                                    Contact Us
                                </a>
                            </div>
                        </div>
                        <div class="carousel-item">
                            <div class="detail-box">
                                <h1>
                                    Rent Car <br>
                                    Experts <br>
                                    Service
                                </h1>
                                <a href="">
                                    Contact Us
                                </a>
                            </div>
                        </div>
                    </div>
                    <a class="carousel-control-prev" href="#carouselExampleControls" role="button" data-slide="prev">
                        <span class="sr-only">Previous</span>
                    </a>
                    <a class="carousel-control-next" href="#carouselExampleControls" role="button" data-slide="next">
                        <span class="sr-only">Next</span>
                    </a>
                </div>

            </div>
        </div>
    </section>
    <!-- end slider section -->
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
        <img src="/images/book-car.png" alt="">
    </div>
</section>

<!-- end book section -->

<section class="rent_section layout_padding">
    <c:forEach var="vehicleType" items="${allVehicleTypes}">
        <div class="container">
            <h1 style="color: white">${vehicleType.name}</h1> <%-- Hiển thị tên loại xe --%>
            <div class="rent_container">
                <c:forEach var="vehicle" items="${topVehiclesByType[vehicleType]}">
                    <div class="box">
                        <div class="img-box">
                            <img src="${vehicle.image}" alt="${vehicle.company} ${vehicle.bienSo}">
                        </div>
                        <div>
                            <a href="/vehicle/${vehicle.id}">
                                <h4>${vehicle.bienSo}</h4>
                            </a>
                        </div>
                        <div class="price">
                            <a href="/vehicle/${vehicle.id}">
                                Giá ${vehicle.price} VND/day
                            </a>
                        </div>
                        <br>
                    </div>
                </c:forEach>
            </div>
            <div>
                <a href="/category/${vehicleType.id}"> <%-- Link "See More" cho từng loại --%>
                    Xem thêm ${vehicleType.name}
                </a>
            </div>
        </div>
        <hr style="background: white">
    </c:forEach>

</section>

<!-- blog section -->

<section class="car_section layout_padding2-top layout_padding-bottom">
    <div class="container">
        <div class="heading_container">
            <h2>
                Better Way For Find Your Favourite Cars
            </h2>
            <p>
                It is a long established fact that a reader will be distracted by the readable
            </p>
        </div>
        <div class="car_container">
            <div class="box">
                <div class="img-box">
                    <img src="images/c-1.png" alt="">
                </div>
                <div class="detail-box">
                    <h5>
                        Choose Your Car
                    </h5>
                    <p>
                        It is a long established fact that a reader will be distracted by the readable content of a page
                        when
                    </p>
                    <a href="">
                        Read More
                    </a>
                </div>
            </div>
            <div class="box">
                <div class="img-box">
                    <img src="images/c-2.png" alt="">
                </div>
                <div class="detail-box">
                    <h5>
                        Get Your Car
                    </h5>
                    <p>
                        It is a long established fact that a reader will be distracted by the readable content of a page
                        when
                    </p>
                    <a href="">
                        Read More
                    </a>
                </div>
            </div>
            <div class="box">
                <div class="img-box">
                    <img src="images/c-3.png" alt="">
                </div>
                <div class="detail-box">
                    <h5>
                        Contact Your Dealer
                    </h5>
                    <p>
                        It is a long established fact that a reader will be distracted by the readable content of a page
                        when
                    </p>
                    <a href="">
                        Read More
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- blog car section -->


<!-- footer section -->
<footer class="container-fluid footer_section">
    <p>
        Copyright &copy; 2020 All Rights Reserved. Design by
        <a href="https://html.design/">Free Html Templates</a> Distributed by <a href="https://themewagon.com">ThemeWagon</a>
    </p>
</footer>
<!-- footer section -->

<script src="js/jquery-3.4.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js">
</script>
<script src="js/custom.js"></script>


</body>

</html>