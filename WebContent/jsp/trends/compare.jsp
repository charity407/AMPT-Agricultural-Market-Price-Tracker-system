<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Price Comparison | AgriMarket Tracker</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f4f0;
            color: #333;
        }

        nav {
            background: #2e7d32;
            padding: 0 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 56px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.25);
        }
        nav .brand { color: #fff; font-size: 1.2rem; font-weight: 700; text-decoration: none; }
        nav ul { list-style: none; display: flex; gap: 4px; }
        nav ul li a {
            color: #c8e6c9; text-decoration: none; padding: 8px 14px;
            border-radius: 4px; font-size: 0.9rem; transition: background 0.2s;
        }
        nav ul li a:hover, nav ul li a.active { background: #1b5e20; color: #fff; }

        .page-wrapper { max-width: 1000px; margin: 30px auto; padding: 0 16px; }

        .page-title {
            font-size: 1.6rem; color: #2e7d32; margin-bottom: 6px;
            font-weight: 700; border-left: 5px solid #66bb6a; padding-left: 12px;
        }
        .page-subtitle { color: #777; font-size: 0.9rem; margin-bottom: 24px; padding-left: 17px; }

        /* Legend */
        .legend {
            display: flex;
            gap: 20px;
            margin-bottom: 16px;
            background: #fff;
            padding: 12px 20px;
            border-radius: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            flex-wrap: wrap;
        }
        .legend-item { display: flex; align-items: center; gap: 8px; font-size: 0.85rem; }
        .legend-dot {
            width: 14px; height: 14px; border-radius: 3px;
        }
        .dot-high { background: #ffcdd2; border: 2px solid #c62828; }
        .dot-low  { background: #c8e6c9; border: 2px solid #1b5e20; }
        .dot-mid  { background: #fff; border: 2px solid #ccc; }

        /* Table card */
        .table-card {
            background: #fff; border-radius: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.1); overflow: hidden;
        }

        table { width: 100%; border-collapse: collapse; }

        thead th {
            background: #2e7d32; color: #fff;
            padding: 13px 18px; text-align: center;
            font-size: 0.87rem; font-weight: 600;
        }
        thead th:first-child { text-align: left; }

        tbody tr { border-bottom: 1px solid #f0f0f0; transition: background 0.15s; }
        tbody tr:hover { background: #fafafa; }

        tbody td {
            padding: 12px 18px; font-size: 0.9rem;
            text-align: center; color: #444;
        }
        tbody td:first-child { text-align: left; font-weight: 700; color: #2e7d32; }

        /* Highlight classes */
        td.highest {
            background: #ffcdd2;
            color: #b71c1c;
            font-weight: 700;
        }
        td.lowest {
            background: #c8e6c9;
            color: #1b5e20;
            font-weight: 700;
        }
        td.highest::after { content: " ▲"; font-size: 0.75rem; }
        td.lowest::after  { content: " ▼"; font-size: 0.75rem; }

        /* Summary row */
        tfoot td {
            padding: 10px 18px; background: #f9fbe7;
            font-size: 0.82rem; color: #555; text-align: center;
            border-top: 2px solid #c5e1a5;
        }
        tfoot td:first-child { text-align: left; font-weight: 700; color: #333; }

        .filter-row {
            display: flex; gap: 12px; margin-bottom: 16px; flex-wrap: wrap;
        }
        .filter-row select {
            padding: 8px 12px; border: 1px solid #ccc; border-radius: 6px;
            font-size: 0.88rem; outline: none; background: #fff;
        }
        .filter-row select:focus { border-color: #2e7d32; }
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
        

<nav>
    <a href="../index.jsp" class="brand">🌾 AgriMarket Tracker</a>
    <ul>
        <li><a href="list.jsp">Price List</a></li>
        <li><a href="compare.jsp" class="active">Compare</a></li>
        <li><a href="entry.jsp">Add Price</a></li>
        <li><a href="history.jsp">History</a></li>
        <li><a href="../trends/trends.jsp">Trends</a></li>
    </ul>
</nav>

<div class="page-wrapper">
    <h1 class="page-title">Price Comparison</h1>
    <p class="page-subtitle">Compare prices across markets. Highest price highlighted in red, lowest in green.</p>

    <div class="filter-row">
        <select id="filterMarketA" onchange="buildTable()">
            <option value="Nairobi Market">Market A: Nairobi</option>
            <option value="Mombasa Market">Market A: Mombasa</option>
            <option value="Kisumu Market">Market A: Kisumu</option>
            <option value="Nakuru Market">Market A: Nakuru</option>
            <option value="Eldoret Market">Market A: Eldoret</option>
        </select>
        <select id="filterMarketB" onchange="buildTable()">
            <option value="Mombasa Market">Market B: Mombasa</option>
            <option value="Nairobi Market">Market B: Nairobi</option>
            <option value="Kisumu Market">Market B: Kisumu</option>
            <option value="Nakuru Market">Market B: Nakuru</option>
            <option value="Eldoret Market">Market B: Eldoret</option>
        </select>
        <select id="filterMarketC" onchange="buildTable()">
            <option value="Kisumu Market">Market C: Kisumu</option>
            <option value="Nairobi Market">Market C: Nairobi</option>
            <option value="Mombasa Market">Market C: Mombasa</option>
            <option value="Nakuru Market">Market C: Nakuru</option>
            <option value="Eldoret Market">Market C: Eldoret</option>
        </select>
    </div>

    <div class="legend">
        <div class="legend-item"><div class="legend-dot dot-high"></div> Highest Price</div>
        <div class="legend-item"><div class="legend-dot dot-low"></div> Lowest Price</div>
        <div class="legend-item"><div class="legend-dot dot-mid"></div> Mid Price</div>
    </div>

    <div class="table-card">
        <table id="compareTable">
            <thead>
                <tr>
                    <th>Product</th>
                    <th id="thA">Nairobi Market</th>
                    <th id="thB">Mombasa Market</th>
                    <th id="thC">Kisumu Market</th>
                </tr>
            </thead>
            <tbody id="compareBody"></tbody>
            <tfoot id="compareFoot"></tfoot>
        </table>
    </div>
</div>

<script>
    // Full price database keyed by market
    const marketPrices = {
        "Nairobi Market":  { Maize: 45, Wheat: 65, Rice: 115, Sorghum: 40, Beans: 100, Potatoes: 28, Tomatoes: 55 },
        "Mombasa Market":  { Maize: 50, Wheat: 70, Rice: 120, Sorghum: 45, Beans: 105, Potatoes: 32, Tomatoes: 60 },
        "Kisumu Market":   { Maize: 42, Wheat: 60, Rice: 118, Sorghum: 38, Beans: 90,  Potatoes: 26, Tomatoes: 50 },
        "Nakuru Market":   { Maize: 40, Wheat: 62, Rice: 112, Sorghum: 36, Beans: 88,  Potatoes: 24, Tomatoes: 48 },
        "Eldoret Market":  { Maize: 38, Wheat: 58, Rice: 110, Sorghum: 34, Beans: 95,  Potatoes: 22, Tomatoes: 45 },
    };

    const products = ["Maize", "Wheat", "Rice", "Sorghum", "Beans", "Potatoes", "Tomatoes"];

    function buildTable() {
        const mA = document.getElementById('filterMarketA').value;
        const mB = document.getElementById('filterMarketB').value;
        const mC = document.getElementById('filterMarketC').value;

        document.getElementById('thA').textContent = mA;
        document.getElementById('thB').textContent = mB;
        document.getElementById('thC').textContent = mC;

        const body = document.getElementById('compareBody');
        const foot = document.getElementById('compareFoot');
        let rows = '';
        let totalA = 0, totalB = 0, totalC = 0;

        products.forEach(prod => {
            const pA = marketPrices[mA][prod];
            const pB = marketPrices[mB][prod];
            const pC = marketPrices[mC][prod];
            totalA += pA; totalB += pB; totalC += pC;

            const vals = [pA, pB, pC];
            const maxVal = Math.max(...vals);
            const minVal = Math.min(...vals);

            function cls(v) {
                if (v === maxVal && v !== minVal) return 'highest';
                if (v === minVal && v !== maxVal) return 'lowest';
                return '';
            }

            rows += `<tr>
                <td>${prod}</td>
                <td class="${cls(pA)}">KES ${pA}</td>
                <td class="${cls(pB)}">KES ${pB}</td>
                <td class="${cls(pC)}">KES ${pC}</td>
            </tr>`;
        });

        body.innerHTML = rows;
        foot.innerHTML = `<tr>
            <td>Total (KES/kg)</td>
            <td>${totalA}</td>
            <td>${totalB}</td>
            <td>${totalC}</td>
        </tr>`;
    }

    buildTable();
</script>
</body>
</html>
