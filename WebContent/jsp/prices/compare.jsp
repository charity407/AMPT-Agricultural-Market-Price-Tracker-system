<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Price Comparison</title>
</head>
<body>
<h1>Price Comparison</h1>
<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>
<table border="1">
    <thead>
    <tr><th>Market</th><th>Latest Price</th><th>Date</th></tr>
    </thead>
    <tbody>
    <c:forEach var="item" items="${comparisonData}">
        <tr>
            <td>${item[0]}</td>
            <td>${item[1]}</td>
            <td>${item[2]}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<p><a href="${pageContext.request.contextPath}/prices/list">Back</a></p>
</body>
</html>
