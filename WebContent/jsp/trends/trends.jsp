<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
          

<h2>Price Trend</h2>

<canvas id="chart"></canvas>

<script>

const data={
labels:[
"D1","D2","D3","D4","D5","D6","D7",
"D8","D9","D10","D11","D12","D13","D14"
],

datasets:[{
label:"Price",
data:[45,47,44,50,52,49,53,55,54,56,58,57,60,62],
borderColor:"green",
fill:false
}]
};

new Chart(document.getElementById("chart"),{
type:"line",
data:data
});

</script>

</body>
</html>
