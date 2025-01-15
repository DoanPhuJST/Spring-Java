<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="dashboard.jsp"/>
<main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Thống kê doanh thu theo tháng</h1>
    </div>
    <label for="yearSelect">Chọn năm:</label>
    <select id="yearSelect">
        <c:forEach var="i" begin="2020" end="<%= java.time.LocalDate.now().getYear() + 5 %>">
            <option value="${i}" ${i == java.time.LocalDate.now().getYear() ? 'selected' : ''}>${i}</option>
        </c:forEach>
    </select>
    <canvas id="myChart"></canvas>

</main>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    const ctx = document.getElementById('myChart').getContext('2d');
    let myChart;

    function fetchChartData(year) {
        fetch('/rentals/monthly-revenue/data?year=' + year)
            .then(response => response.json())
            .then(data => {
                const labels = data.map(item => "Tháng " + item.month);
                const revenues = data.map(item => item.revenue);

                if (myChart) {
                    myChart.destroy(); // Hủy biểu đồ cũ trước khi vẽ biểu đồ mới
                }

                myChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Doanh thu (VNĐ)',
                            data: revenues,
                            backgroundColor: 'rgba(54, 162, 235, 0.5)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            });
    }

    document.getElementById('yearSelect').addEventListener('change', function() {
        fetchChartData(this.value);
    });

    fetchChartData(document.getElementById('yearSelect').value); // Gọi khi trang được tải lần đầu
</script>
</body>
</html>