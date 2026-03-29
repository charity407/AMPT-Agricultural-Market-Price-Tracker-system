<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Price Entry</title>
</head>
<body>
<h1>Enter Price</h1>
<form action="${pageContext.request.contextPath}/prices/entry" method="post">
    Product ID: <input type="number" name="productId" required><br>
    Market ID: <input type="number" name="marketId" required><br>
    Unit Price: <input type="number" step="0.01" name="price" required><br>
    Date: <input type="date" name="priceDate" required><br>
    <button type="submit">Save</button>
</form>
<p><a href="${pageContext.request.contextPath}/prices/list">Back to list</a></p>
</body>
</html>
