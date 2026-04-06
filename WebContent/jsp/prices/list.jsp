<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Price List</title>

<style>
body{
font-family:Arial;
background:#f5f5f5;
padding:20px;
}

.card{
background:white;
padding:20px;
border-radius:8px;
box-shadow:0 2px 5px rgba(0,0,0,.1);
}

table{
width:100%;
border-collapse:collapse;
margin-top:15px;
}

th,td{
padding:10px;
border-bottom:1px solid #ddd;
text-align:left;
}

th{
background:#2c3e50;
color:white;
}

.btn{
padding:8px 14px;
border:none;
border-radius:5px;
cursor:pointer;
text-decoration:none;
display:inline-block;
}

.btn-primary{
background:#3498db;
color:white;
}

.btn-success{
background:#27ae60;
color:white;
}

.btn-secondary{
background:#7f8c8d;
color:white;
}

.filter{
margin-bottom:15px;
}
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
          


<h2>Price List</h2>

<div class="card">

<!-- FILTER FORM -->
<form action="PriceListServlet" method="get" class="filter">

<label>Product:</label>
<select id="productFilter">
<option value="">All</option>
</select>

<label>Market:</label>
<select id="marketFilter">
<option value="">All</option>
</select>

<button type="button" class="btn btn-primary" onclick="filterTable()">Filter</button>

<a href="../entry.jsp" class="btn btn-success">Add New</a>

<a href="ReportServlet" class="btn btn-secondary">Download CSV</a>

</form>

<div style="margin-bottom:15px">

     <a href="../prices/list.jsp">Home</a>
     
     <a href="../prices/entry.jsp">Add Price</a>
     
     <a href="../trends/trends.jsp">Trends</a>
     
     <a href="../alerts/alerts.jsp">Alerts</a>
     
     <a href="../profile/profile.jsp">Profile</a>
     
     </div>
     
<table>
<thead>
<tr>
<th>Product</th>
<th>Market</th>
<th>Price</th>
<th>Date</th>
<th>Action</th>
</tr>
</thead>

<tbody id="priceTable"></tbody>

</table>

</div>

<script>

// MOCK DATABASE
const prices = [
{product:"Maize",market:"Nairobi",price:45,date:"2025-05-01"},
{product:"Beans",market:"Kisii",price:60,date:"2025-05-01"},
{product:"Rice",market:"Mombasa",price:120,date:"2025-05-02"},
{product:"Maize",market:"Kisii",price:40,date:"2025-05-02"},
{product:"Beans",market:"Nairobi",price:65,date:"2025-05-03"},
{product:"Rice",market:"Nakuru",price:115,date:"2025-05-03"}
];

// populate dropdowns
const products=[...new Set(prices.map(p=>p.product))];
const markets=[...new Set(prices.map(p=>p.market))];

products.forEach(p=>{
productFilter.innerHTML+=`<option>${p}</option>`
});

markets.forEach(m=>{
marketFilter.innerHTML+=`<option>${m}</option>`
});

function renderTable(data){

const tbody=document.getElementById("priceTable");
tbody.innerHTML="";

data.forEach(p=>{

tbody.innerHTML+=`
<tr>
<td>${p.product}</td>
<td>${p.market}</td>
<td>${p.price}</td>
<td>${p.date}</td>
<td>
<a href="history.jsp" class="btn btn-primary">History</a>
<a href="compare.jsp" class="btn btn-success">Compare</a>
</td>
</tr>
`;

});

}

renderTable(prices);

// filter
function filterTable(){

const product=document.getElementById("productFilter").value;
const market=document.getElementById("marketFilter").value;

let filtered=prices.filter(p=>{
return (product=="" || p.product==product)
&& (market=="" || p.market==market)
});

renderTable(filtered);

}

</script>

</body>
</html>
