<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard</title>

<style>
body{
font-family:Arial;
background:#f5f5f5;
padding:20px;
}

.navbar{
background:#2c3e50;
padding:12px;
margin-bottom:20px;
}

.navbar a{
color:white;
margin-right:15px;
text-decoration:none;
font-weight:bold;
}

.container{
display:flex;
flex-wrap:wrap;
gap:20px;
}

.card{
background:white;
padding:20px;
width:220px;
border-radius:8px;
box-shadow:0 2px 6px rgba(0,0,0,.1);
text-align:center;
cursor:pointer;
transition:.2s;
}

.card:hover{
transform:translateY(-3px);
}

.card h3{
margin:10px 0;
}

.card p{
color:#777;
}

a{
text-decoration:none;
color:black;
}
</style>

</head>
<body>

<!-- NAVBAR -->
<div class="navbar">
<a href="../prices/list.jsp">Prices</a>
<a href="../prices/entry.jsp">Add Price</a>
<a href="../prices/compare.jsp">Compare</a>
<a href="../trends/trends.jsp">Trends</a>
<a href="../alerts/alerts.jsp">Alerts</a>
<a href="../profile/profile.jsp">Profile</a>
</div>

<h2>Admin Dashboard</h2>

<div class="container">

<a href="../prices/list.jsp">
<div class="card">
<h3>Price List</h3>
<p>View all market prices</p>
</div>
</a>

<a href="../prices/entry.jsp">
<div class="card">
<h3>Add Price</h3>
<p>Enter new product price</p>
</div>
</a>

<a href="../prices/compare.jsp">
<div class="card">
<h3>Compare Prices</h3>
<p>Compare markets</p>
</div>
</a>

<a href="../trends/trends.jsp">
<div class="card">
<h3>Trends</h3>
<p>View price trend chart</p>
</div>
</a>

<a href="../alerts/alerts.jsp">
<div class="card">
<h3>Alerts</h3>
<p>Create price alerts</p>
</div>
</a>

<a href="../profile/profile.jsp">
<div class="card">
<h3>Profile</h3>
<p>Manage user profile</p>
</div>
</a>

</div>

</body>
</html>

