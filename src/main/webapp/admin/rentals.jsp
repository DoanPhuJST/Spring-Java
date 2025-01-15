<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="dashboard.jsp"/>
<main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Quản lý đơn thuê</h1>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-${message.contains('thành công') ? 'success' : 'danger'} alert-dismissible fade show"
             role="alert">
                ${message}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty rentals}">
            <div class="table-responsive">
                <table class="table table-bordered table-striped">
                    <thead>
                    <tr>
                        <th>ID thuê</th>
                        <th>Khách hàng</th>
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
                            <td>${rental.account.username}</td>
                            <td>${rental.startDate}</td>
                            <td>${rental.endDate}</td>
                            <td>${rental.vehicle.company} - ${rental.vehicle.bienSo}</td>
                            <td><fmt:formatNumber value="${rental.total}" pattern="#,###"/> VNĐ</td>
                            <td>${rental.status}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${rental.status == 'choDuyet'}">
                                        <form method="post" action="/admin/rentals/${rental.id}/approve"
                                              style="display:inline">
                                            <button type="submit" class="btn btn-success btn-sm">Duyệt</button>
                                        </form>
                                        <form method="post" action="/admin/rentals/${rental.id}/cancel"
                                              style="display:inline">
                                            <button type="submit" class="btn btn-danger btn-sm"
                                                    onclick="return confirm('Bạn có chắc chắn muốn hủy đơn thuê này?')">
                                                Hủy
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:when test="${rental.status == 'daDuyet'}">
                                        <span class="badge badge-success">Đã duyệt</span>
                                    </c:when>
                                    <c:when test="${rental.status == 'daHuy'}">
                                        <span class="badge badge-danger">Đã hủy</span>
                                    </c:when>
                                    <c:when test="${rental.status == 'dangThue'}">
                                        <span class="badge badge-info">Đang Thuê</span>
                                    </c:when>
                                    <c:when test="${rental.status == 'daTra'}">
                                        <span class="badge badge-info">Đã trả</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-secondary">Không xác định</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <c:choose>
                        <c:when test="${currentPage > 0}">
                            <li class="page-item">
                                <a class="page-link" href="/admin?page=${currentPage - 1}&size=${10}"
                                   aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item disabled">
                                <span class="page-link">&laquo;</span>
                            </li>
                        </c:otherwise>
                    </c:choose>
                    <c:forEach var="i" begin="0" end="${totalPages - 1}">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="/admin?page=${i}&size=${10}">${i + 1}</a>
                        </li>
                    </c:forEach>
                    <c:choose>
                        <c:when test="${currentPage < totalPages - 1}">
                            <li class="page-item">
                                <a class="page-link" href="/admin?page=${currentPage + 1}&size=${10}"
                                   aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item disabled">
                                <span class="page-link">&raquo;</span>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </nav>
        </c:when>
        <c:otherwise>
            <p>Không có đơn thuê nào.</p>
        </c:otherwise>
    </c:choose>
</main>
</div>
</body>
</html>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
