<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>My Alerts</title>
</head>
<body>
<h1>Price Alerts</h1>
<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>
<form action="${pageContext.request.contextPath}/alerts" method="post">
    <input type="hidden" name="action" value="create" />
    Product ID: <input type="number" name="productId" required><br>
    Market ID: <input type="number" name="marketId" required><br>
    Threshold Price: <input type="number" step="0.01" name="thresholdPrice" required><br>
    Direction: <select name="alertDirection"><option value="above">Above</option><option value="below">Below</option></select><br>
    <button type="submit">Create Alert</button>
</form>
<h2>Active alerts</h2>
<table border="1">
    <thead>
    <tr><th>Product</th><th>Market</th><th>Threshold</th><th>Direction</th><th>Date</th></tr>
    </thead>
    <tbody>
    <c:forEach var="alert" items="${alerts}">
        <tr>
            <td>${alert.productName}</td>
            <td>${alert.marketName}</td>
            <td>${alert.thresholdPrice}</td>
            <td>${alert.alertDirection}</td>
            <td>${alert.createdDate}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<p><a href="${pageContext.request.contextPath}/prices/list">Back to prices</a></p>
</body>
</html>
