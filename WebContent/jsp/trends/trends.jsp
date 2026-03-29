<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Price Trends</title>
</head>
<body>
<h1>Price Trend (last ${days} days)</h1>
<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>
<table border="1">
    <thead>
    <tr><th>Date</th><th>Price</th></tr>
    </thead>
    <tbody>
    <c:forEach var="row" items="${trendData}">
        <tr>
            <td>${row[0]}</td>
            <td>${row[1]}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<p><a href="${pageContext.request.contextPath}/prices/list">Back</a></p>
</body>
</html>
