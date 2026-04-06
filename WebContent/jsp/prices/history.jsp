<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>Price History</title>
<style>
body{font-family:Arial;padding:20px}
table{width:100%;border-collapse:collapse}
th,td{padding:10px;border-bottom:1px solid #ddd}
</style>
</head>
<body>
     <style>
          .navbar{
          background:#2c3e50;
          padding:12px;
          }
          
          .navbar a{
          color:white;
          margin-right:15px;
          text-decoration:none;
          font-weight:bold;
          }
          
          .navbar a:hover{
          text-decoration:underline;
          }
          </style>
          
          <div class="navbar">
          
          <a href="../prices/list.jsp">Home</a>
          
          <a href="../prices/list.jsp">Prices</a>
          
          <a href="../prices/entry.jsp">Add Price</a>
          
          <a href="../prices/compare.jsp">Compare</a>
          
          <a href="../trends/trends.jsp">Trends</a>
          
          <a href="../alerts/alerts.jsp">Alerts</a>
          
          <a href="../profile/profile.jsp">Profile</a>
          
          </div>
          

<h2>Price History</h2>

<a href="list.jsp">Back to list</a>

<table>
<thead>
<tr>
<th>Date</th>
<th>Price</th>
</tr>
</thead>

<tbody id="history"></tbody>
</table>

<script>

const history=[
{date:"Day1",price:45},
{date:"Day2",price:50},
{date:"Day3",price:48},
{date:"Day4",price:52},
{date:"Day5",price:49}
];

history.forEach(h=>{
document.getElementById("history").innerHTML+=`
<tr>
<td>${h.date}</td>
<td>${h.price}</td>
</tr>
`;
})

</script>

</body>
</html>
