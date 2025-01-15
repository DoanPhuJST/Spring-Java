<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="dashboard.jsp"/>
<main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-md-4">
  <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">Sửa xe</h1>
  </div>
  <c:if test="${not empty message}">
    <div class="alert alert-${message.contains('thành công') ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
        ${message}
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
  </c:if>
  <form:form modelAttribute="vehicle" method="post" enctype="multipart/form-data">
    <form:hidden path="id"/>
    <form:hidden path="image"/> <%-- Giữ lại đường dẫn ảnh cũ --%>

    <div class="form-group">
      <form:label path="bienSo">Biển số:</form:label>
      <form:input path="bienSo" class="form-control"/>
      <form:errors path="bienSo" cssClass="text-danger"/>
    </div>
    <div class="form-group">
      <form:label path="company">Hãng:</form:label>
      <form:input path="company" class="form-control"/>
      <form:errors path="company" cssClass="text-danger"/>
    </div>
    <div class="form-group">
      <form:label path="content">Mô tả:</form:label>
      <form:textarea path="content" class="form-control"/>
      <form:errors path="content" cssClass="text-danger"/>
    </div>
    <div class="form-group">
      <form:label path="price">Giá:</form:label>
      <form:input path="price" type="number" class="form-control"/>
      <form:errors path="price" cssClass="text-danger"/>
    </div>
    <div class="form-group">
      <form:label path="status">Trạng thái:</form:label>
      <form:select path="status" class="form-control">
        <form:option value="SAN_SANG">Sẵn sàng</form:option>
        <form:option value="DANG_THUE">Đang thuê</form:option>
        <form:option value="BAO_TRI">Bảo trì</form:option>
      </form:select>
      <form:errors path="status" cssClass="text-danger"/>
    </div>
    <div class="form-group">
      <label for="vehicleType">Loại xe:</label>
      <select class="form-control" id="vehicleType" name="vehicleType.id">
        <c:forEach items="${vehicleTypes}" var="vehicleType">
          <option value="${vehicleType.id}" ${vehicle.vehicleType.id == vehicleType.id ? 'selected' : ''}>${vehicleType.name}</option>
        </c:forEach>
      </select>
    </div>
    <div class="form-group">
      <label for="file">Hình ảnh mới (để trống nếu không thay đổi):</label>
      <input type="file" name="file" class="form-control-file">
    </div>
    <div class="form-group">
      <label>Hình ảnh hiện tại:</label><br>
      <c:if test="${not empty vehicle.image}">
        <img src="${vehicle.image}" alt="Hình ảnh xe" width="200">
      </c:if>
      <c:if test="${empty vehicle.image}">
        <p>Không có hình ảnh.</p>
      </c:if>
    </div>
    <button type="submit" class="btn btn-primary">Lưu</button>
    <a href="/admin/vehicles" class="btn btn-secondary">Hủy</a>
  </form:form>
</main>
<%-- ... (include scripts) ... --%>
</div>
</body>
</html>