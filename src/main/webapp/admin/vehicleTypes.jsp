<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="dashboard.jsp"/>
<main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Quản lý loại xe</h1>
        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#addModal">Thêm loại xe</button>
    </div>

    <div id="message-container"></div>

    <c:choose>
        <c:when test="${not empty vehicleTypes}">
            <div class="table-responsive">
                <table class="table table-bordered table-striped" id="vehicleTypeTable">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên loại xe</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="vehicleType" items="${vehicleTypes}">
                        <tr data-id="${vehicleType.id}" data-name="${vehicleType.name}">
                            <td>${vehicleType.id}</td>
                            <td>${vehicleType.name}</td>
                            <td>
                                <button type="button" class="btn btn-warning btn-sm btn-edit" data-toggle="modal"
                                        data-target="#editModal" data-id="${vehicleType.id}"
                                        data-name="${vehicleType.name}">Sửa
                                </button>
                                <button type="button" class="btn btn-danger btn-sm btn-delete" data-toggle="modal"
                                        data-target="#deleteModal" data-id="${vehicleType.id}">Xóa</button>
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
                                <a class="page-link" href="/admin/vehicleTypes?page=${currentPage - 1}&size=10" aria-label="Previous">
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
                            <a class="page-link" href="/admin/vehicleTypes?page=${i}&size=10">${i + 1}</a>
                        </li>
                    </c:forEach>
                    <c:choose>
                        <c:when test="${currentPage < totalPages - 1}">
                            <li class="page-item">
                                <a class="page-link" href="/admin/vehicleTypes?page=${currentPage + 1}&size=10" aria-label="Next">
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
            <p>Không có loại xe nào.</p>
        </c:otherwise>
    </c:choose>

    <%-- Modal thêm loại xe --%>
    <div class="modal fade" id="addModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm loại xe</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <form id="addForm">
                        <div class="form-group">
                            <label for="addName">Tên loại xe:</label>
                            <input type="text" class="form-control" id="addName" name="name" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-primary" id="btnAdd">Thêm</button>
                </div>
            </div>
        </div>
    </div>

    <%-- Modal sửa loại xe --%>
    <div class="modal fade" id="editModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Sửa loại xe</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <form id="editForm">
                        <input type="hidden" id="editId">
                        <div class="form-group">
                            <label for="editName">Tên loại xe:</label>
                            <input type="text" class="form-control" id="editName" name="name" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-primary" id="btnEdit">Lưu</button>
                </div>
            </div>
        </div>
    </div>

    <%-- Modal xóa loại xe --%>
    <div class="modal fade" id="deleteModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xóa loại xe</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    Bạn có chắc chắn muốn xóa loại xe <span id="deleteName"></span>?
                    <input type="hidden" id="deleteId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-danger" id="btnDelete">Xóa</button>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    $(document).ready(function () {
        function showMessage(message, type) {
            $("#message-container").html('<div class="alert alert-' + type + ' alert-dismissible fade show" role="alert">' +
                message +
                '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
                '<span aria-hidden="true">&times;</span>' +
                '</button>' +
                '</div>');
        }

        // Thêm loại xe (Sử dụng fetch)
        $("#btnAdd").click(function () {
            const formData = new FormData(document.getElementById('addForm'));

            fetch('/admin/vehicleTypes/add', {
                method: 'POST',
                body: new URLSearchParams(formData) // Chuyển FormData sang URLSearchParams
            })
                .then(response => {
                    if (!response.ok) {
                        return response.text().then(text => {throw new Error(text)}); // Xử lý lỗi
                    }
                    return response.text();
                })
                .then(data => {
                    $("#addModal").modal('hide');
                    $("#addForm")[0].reset();
                    showMessage(data, "success");
                    setTimeout(function(){
                        location.reload();
                    }, 1000)
                })
                .catch(error => {
                    showMessage(error.message, "danger");
                });
        });

        // Sửa loại xe (Sử dụng fetch)
        $(".btn-edit").click(function () {
            var id = $(this).data('id');
            var name = $(this).data('name');
            $("#editId").val(id);
            $("#editName").val(name);
        });

        $("#btnEdit").click(function () {
            const formData = new FormData(document.getElementById('editForm'));
            const id = $("#editId").val();

            fetch('/admin/vehicleTypes/' + id + '/edit', {
                method: 'POST',
                body: new URLSearchParams(formData)
            })
                .then(response => {
                    if (!response.ok) {
                        return response.text().then(text => {throw new Error(text)}); // Xử lý lỗi
                    }
                    return response.text();
                })
                .then(data => {
                    $("#editModal").modal('hide');
                    showMessage(data, "success");
                    setTimeout(function(){
                        location.reload();
                    }, 1000)
                })
                .catch(error => {
                    showMessage(error.message, "danger");
                });
        });

        // Xóa loại xe (Sử dụng fetch)
        $(".btn-delete").click(function () {
            var id = $(this).data('id');
            var name = $(this).data('name');
            $("#deleteId").val(id);
            $("#deleteName").text(name);
        });

        $("#btnDelete").click(function () {
            const id = $("#deleteId").val();

            fetch('/admin/vehicleTypes/' + id + '/delete', {
                method: 'POST'
            })
                .then(response => {
                    if (!response.ok) {
                        return response.text().then(text => {throw new Error(text)}); // Xử lý lỗi
                    }
                    return response.text();
                })
                .then(data => {
                    $("#deleteModal").modal('hide');
                    showMessage(data, "success");
                    setTimeout(function(){
                        location.reload();
                    }, 1000)
                })
                .catch(error => {
                    showMessage(error.message, "danger");
                });
        });

        $('#addModal').on('hidden.bs.modal', function () {
            $("#addForm")[0].reset();
        })
        $('#editModal').on('hidden.bs.modal', function () {
            $("#editForm")[0].reset();
        })
    });

</script>
</body>
</html>