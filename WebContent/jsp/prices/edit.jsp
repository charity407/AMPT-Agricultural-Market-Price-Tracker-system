<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Edit Price</title>
</head>
<body>
<h1>Edit Price Entry</h1>
<form action="${pageContext.request.contextPath}/prices/edit" method="post">
    <input type="hidden" name="entryId" value="${entryId}" />
    Product: ${productName} <br>
    Market: ${marketName} <br>
    Price: <input type="number" step="0.01" name="unitPrice" value="${unitPrice}" required><br>
    Date: <input type="date" name="priceDate" value="${priceDate}" required><br>
    Notes: <textarea name="notes">${notes}</textarea><br>
    <button type="submit">Save</button>
</form>
<p><a href="${pageContext.request.contextPath}/prices/list">Back</a></p>
</body>
</html>
