<html>
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
          

<h2>Alerts</h2>

<input placeholder="Product">
<input placeholder="Price">
<button onclick="add()">Add Alert</button>

<table border="1" width="100%">
<thead>
<tr>
<th>Product</th>
<th>Price</th>
<th>Action</th>
</tr>
</thead>

<tbody id="alerts"></tbody>

</table>

<script>

function add(){
alerts.innerHTML+=`
<tr>
<td>Maize</td>
<td>40</td>
<td><button onclick="this.parentElement.parentElement.remove()">Delete</button></td>
</tr>
`;
}

</script>

</body>
</html>
