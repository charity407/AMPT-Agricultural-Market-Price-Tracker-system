<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AgriMarket Tracker</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f4f0; color: #333;
        }
        nav {
            background: #2e7d32; padding: 0 24px;
            display: flex; align-items: center; justify-content: space-between;
            height: 56px; box-shadow: 0 2px 6px rgba(0,0,0,0.25);
        }
        nav .brand { color: #fff; font-size: 1.2rem; font-weight: 700; text-decoration: none; }
        nav ul { list-style: none; display: flex; gap: 4px; }
        nav ul li a {
            color: #c8e6c9; text-decoration: none; padding: 8px 14px;
            border-radius: 4px; font-size: 0.9rem; transition: background 0.2s;
        }
        nav ul li a:hover { background: #1b5e20; color: #fff; }

        .hero {
            background: linear-gradient(135deg, #2e7d32 0%, #1b5e20 100%);
            color: #fff; text-align: center; padding: 60px 24px;
        }
        .hero h1 { font-size: 2.4rem; margin-bottom: 10px; }
        .hero p  { font-size: 1.05rem; opacity: 0.85; max-width: 520px; margin: 0 auto; }

        .page-wrapper { max-width: 1000px; margin: 40px auto; padding: 0 16px; }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }

        .nav-card {
            background: #fff; border-radius: 10px; padding: 28px 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.09); text-align: center;
            text-decoration: none; color: #333; transition: transform 0.2s, box-shadow 0.2s;
            border-top: 4px solid #66bb6a;
            display: flex; flex-direction: column; align-items: center; gap: 12px;
        }
        .nav-card:hover { transform: translateY(-4px); box-shadow: 0 6px 16px rgba(0,0,0,0.14); }
        .nav-card .icon { font-size: 2.4rem; }
        .nav-card h3 { font-size: 1rem; color: #2e7d32; }
        .nav-card p  { font-size: 0.82rem; color: #888; line-height: 1.4; }

        .section-title {
            font-size: 1.1rem; font-weight: 700; color: #2e7d32;
            margin: 36px 0 16px; border-left: 4px solid #66bb6a; padding-left: 10px;
        }
    </style>
</head>
<body>
<nav>
    <a href="index.jsp" class="brand">🌾 AgriMarket Tracker</a>
    <ul>
        <li><a href="prices/list.jsp">Price List</a></li>
        <li><a href="prices/compare.jsp">Compare</a></li>
        <li><a href="prices/entry.jsp">Add Price</a></li>
        <li><a href="prices/history.jsp">History</a></li>
        <li><a href="trends/trends.jsp">Trends</a></li>
      
        <li><a href="admin/admin.jsp" style="font-weight:bold; color:#ffeb3b;">Admin</a></li>
    </ul>
</nav>

<div class="hero">
    <h1>🌾 AgriMarket Price Tracker</h1>
    <p>Track, compare and analyse agricultural product prices across Kenya's markets in real time.</p>
</div>

<div class="page-wrapper">
    <p class="section-title">Quick Navigation</p>
    <div class="cards-grid">
        <a href="prices/list.jsp" class="nav-card">
            <div class="icon">📋</div>
            <h3>Price List</h3>
            <p>Browse all current market prices with powerful filters.</p>
        </a>
        <a href="prices/compare.jsp" class="nav-card">
            <div class="icon">⚖️</div>
            <h3>Compare Prices</h3>
            <p>Compare product prices across three markets side by side.</p>
        </a>
        <a href="prices/entry.jsp" class="nav-card">
            <div class="icon">➕</div>
            <h3>Enter Price</h3>
            <p>Record a new agricultural product price for any market.</p>
        </a>
        <a href="prices/history.jsp" class="nav-card">
            <div class="icon">🗂️</div>
            <h3>Price History</h3>
            <p>View historical records with pagination and sorting.</p>
        </a>
        <a href="trends/trends.jsp" class="nav-card">
            <div class="icon">📈</div>
            <h3>Trends</h3>
            <p>Visualise price trends and statistics with a line chart.</p>
        </a>
        
        <a href="admin/admin.jsp" class="nav-card">
            <div class="icon">🛠️</div>
            <h3>Admin</h3>
            <p>Access the administration panel to manage products, users and prices.</p>
        </a>
    </div>
</div>
</body>
</html>
