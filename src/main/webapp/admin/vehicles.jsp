<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="dashboard.jsp"/>
<main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-md-4">
  <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">Quản lý xe</h1>
    <a href="/admin/vehicles/add" class="btn btn-primary">Thêm xe</a>
  </div>

  <c:if test="${not empty message}">
    <div class="alert alert-${message.contains('thành công') ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
        ${message}
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
  </c:if>

  <c:choose>
    <c:when test="${not empty vehicles}">
      <div class="table-responsive">
        <table class="table table-bordered table-striped">
          <thead>
          <tr>
            <th>ID</th>
            <th>Biển số</th>
            <th>Hãng</th>
            <th>Giá</th>
            <th>Trạng thái</th>
            <th>Loại xe</th>
            <th>Hình ảnh</th>
            <th>Hành động</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="vehicle" items="${vehicles}">
            <tr>
              <td>${vehicle.id}</td>
              <td>${vehicle.bienSo}</td>
              <td>${vehicle.company}</td>
              <td><fmt:formatNumber value="${vehicle.price}" pattern="#,###" /> VNĐ</td>
              <td>${vehicle.status}</td>
              <td>${vehicle.vehicleType.name}</td>
              <td><img src="${vehicle.image}" alt="Hình ảnh xe" width="100"></td>
              <td>
                <a href="/admin/vehicles/${vehicle.id}/edit" class="btn btn-warning btn-sm">Sửa</a>
                <form method="post" action="/admin/vehicles/${vehicle.id}/delete" style="display:inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa xe này?')">
                  <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                </form>
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
                <a class="page-link" href="/admin/vehicles?page=${currentPage - 1}&size=10" aria-label="Previous">
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
              <a class="page-link" href="/admin/vehicles?page=${i}&size=10">${i + 1}</a>
            </li>
          </c:forEach>
          <c:choose>
            <c:when test="${currentPage < totalPages - 1}">
              <li class="page-item">
                <a class="page-link" href="/admin/vehicles?page=${currentPage + 1}&size=10" aria-label="Next">
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
      <p>Không có xe nào.</p>
    </c:otherwise>
  </c:choose>
</main>
</div>
<%-- ... (include scripts) ... --%>
</body>
</html>