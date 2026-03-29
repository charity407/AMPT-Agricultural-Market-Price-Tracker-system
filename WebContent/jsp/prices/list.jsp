<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Price List</title>
</head>
<body>
<h1>Price List</h1>
<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>
<c:if test="${not empty success}">
    <p style="color:green">${success}</p>
</c:if>
<p><a href="${pageContext.request.contextPath}/prices/entry">New entry</a></p>
<table border="1">
    <thead>
    <tr>
        <th>Product</th>
        <th>Unit Price</th>
        <th>Market</th>
        <th>Region</th>
        <th>Date</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="row" items="${priceList}">
        <tr>
            <td>${row[0]}</td>
            <td>${row[1]}</td>
            <td>${row[2]}</td>
            <td>${row[3]}</td>
            <td>${row[4]}</td>
            <td><a href="${pageContext.request.contextPath}/prices/edit?id=${row[0]}">Edit</a></td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<p><a href="${pageContext.request.contextPath}/prices/compare?productId=1&marketIds=1,2">Compare sample</a></p>
<p><a href="${pageContext.request.contextPath}/prices/trends?productId=1&marketId=1&days=30">Trend sample</a></p>
</body>
</html>
