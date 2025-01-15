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

    <!DOCTYPE html>
    <html>
    <head>
        <title>${vehicle.company} - ${vehicle.bienSo}</title>
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
                    </div>
                </nav>
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

            </form>        </div>
        <div class="img-box">
            <img src="images/book-car.png" alt="">
        </div>
    </section>

    <!-- about section -->
    <div class="container">
        <h1>Thông tin xe</h1>
        <c:if test="${not empty message}">
            <div class="alert alert-${message.contains('thành công') ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
                    ${message}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        </c:if>

        <section class="car_info_section layout_padding2-top layout_padding-bottom">
            <div class="row">
                <div class="col-md-7">
                    <div class="img-box">
                        <img id="carImage" src="${vehicle.image}" alt="${vehicle.company} ${vehicle.bienSo}">
                    </div>
                </div>
                <div class="col-md-5">
                    <div class="detail-box">
                        <h2 id="carName">${vehicle.company} ${vehicle.bienSo}</h2>
                        <p id="carDescription">${vehicle.content}</p>
                        <p><strong>Giá thuê/ngày:</strong> <span id="carPrice">${vehicle.price}</span> VNĐ</p>
                        <p><strong>Tình trạng:</strong> <span id="carStatus">${vehicle.status}</span></p>

                        <form method="post" action="/rentals">
                            <input type="hidden" name="vehicleId" value="${vehicle.id}">
                            <div class="form-group">
                                <label for="startDate">Ngày thuê:</label>
                                <input type="text" class="form-control" id="startDate" name="startDate" required>
                            </div>
                            <div class="form-group">
                                <label for="endDate">Ngày trả:</label>
                                <input type="text" class="form-control" id="endDate" name="endDate" required>
                            </div>
                            <p><strong>Tổng tiền:</strong> <span id="totalPrice">0</span> VNĐ</p>
                            <button type="submit" class="btn btn-primary">Thuê ngay</button>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </div>
    <script>
        const startDateInput = document.getElementById('startDate');
        const endDateInput = document.getElementById('endDate');
        const vehicleId = ${vehicle.id};
        const carPrice = document.getElementById('carPrice');
        const totalPrice = document.getElementById('totalPrice');

        function fetchBookedDates() {
            fetch(`/api/rentals/${vehicleId}`)
                .then(response => response.json())
                .then(bookedDates => {
                    // Chuyển đổi dữ liệu sang mảng các đối tượng Date
                    const bookedDatesObjects = bookedDates.map(dateArray => {
                        return new Date(dateArray[0], dateArray[1] - 1, dateArray[2]); // Tháng trong JS bắt đầu từ 0
                    });

                    // Khởi tạo Flatpickr cho startDateInput
                    flatpickr(startDateInput, {
                        minDate: "today",
                        dateFormat: "Y-m-d",
                        locale: "vn",
                        disable: bookedDatesObjects, // Vô hiệu hóa các ngày đã đặt
                        onChange: function (selectedDates, dateStr, instance) {
                            if (selectedDates.length > 0) {
                                endDatePicker.set("minDate", selectedDates[0]);
                                calculateTotalPrice();
                            } else {
                                endDatePicker.clear();
                                totalPrice.textContent = "0";
                            }
                        }
                    });

                    // Khởi tạo Flatpickr cho endDateInput
                    const endDatePicker = flatpickr(endDateInput, {
                        dateFormat: "Y-m-d",
                        locale: "vn",
                        disable: bookedDatesObjects, // Vô hiệu hóa các ngày đã đặt
                        onChange: function (selectedDates, dateStr, instance) {
                            calculateTotalPrice();
                        }
                    });
                })
                .catch(error => {
                    console.error("Lỗi khi gọi API:", error);
                    alert("Đã có lỗi xảy ra khi lấy dữ liệu ngày đã đặt.");
                });
        }

        function calculateTotalPrice() {
            const pricePerDay = parseInt(carPrice.textContent.replace(/\./g, ''));
            const startDate = new Date(startDateInput.value);
            const endDate = new Date(endDateInput.value);

            if (isNaN(startDate) || isNaN(endDate)) {
                totalPrice.textContent = "0";
                return;
            }

            const timeDiff = Math.abs(endDate.getTime() - startDate.getTime());
            const daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));

            if (daysDiff <= 0) {
                alert("Ngày trả xe phải sau ngày thuê xe.");
                totalPrice.textContent = "0";
                endDateInput.value = ""; //reset giá trị ngày trả
                return;
            }

            const total = pricePerDay * daysDiff;
            totalPrice.textContent = total.toLocaleString('vi-VN');
        }

        fetchBookedDates();

    </script>

    <!-- end about section -->

    <!-- footer section -->
    <footer class="container-fluid footer_section">
        <p>
            Copyright &copy; 2020 All Rights Reserved. Design by
            <a href="https://html.design/">Free Html Templates</a> Distributed by <a href="https://themewagon.com">ThemeWagon</a>
        </p>
    </footer>
    <!-- footer section -->

    <script src="/js/jquery-3.4.1.min.js"></script>
    <script src="/js/bootstrap.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js">
    </script>
    <script src="/js/custom.js"></script>

    </body>

    </html>