<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Price List | AgriMarket Tracker</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f4f0;
            color: #333;
        }

        /* ── Navigation ── */
        nav {
            background: #2e7d32;
            padding: 0 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 56px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.25);
        }
        nav .brand {
            color: #fff;
            font-size: 1.2rem;
            font-weight: 700;
            text-decoration: none;
            letter-spacing: 0.5px;
        }
        nav ul {
            list-style: none;
            display: flex;
            gap: 4px;
        }
        nav ul li a {
            color: #c8e6c9;
            text-decoration: none;
            padding: 8px 14px;
            border-radius: 4px;
            font-size: 0.9rem;
            transition: background 0.2s, color 0.2s;
        }
        nav ul li a:hover,
        nav ul li a.active {
            background: #1b5e20;
            color: #fff;
        }

        /* ── Page Wrapper ── */
        .page-wrapper {
            max-width: 1100px;
            margin: 30px auto;
            padding: 0 16px;
        }

        .page-title {
            font-size: 1.6rem;
            color: #2e7d32;
            margin-bottom: 20px;
            font-weight: 700;
            border-left: 5px solid #66bb6a;
            padding-left: 12px;
        }

        /* ── Filter Card ── */
        .filter-card {
            background: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .filter-card h3 {
            font-size: 0.9rem;
            text-transform: uppercase;
            color: #777;
            letter-spacing: 1px;
            margin-bottom: 14px;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 12px;
            align-items: end;
        }

        .filter-grid .form-group {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .filter-grid label {
            font-size: 0.8rem;
            color: #555;
            font-weight: 600;
        }

        .filter-grid input,
        .filter-grid select {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 0.88rem;
            outline: none;
            transition: border-color 0.2s;
        }

        .filter-grid input:focus,
        .filter-grid select:focus {
            border-color: #2e7d32;
        }

        .search-bar {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .search-bar input {
            flex: 1;
            padding: 10px 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 0.9rem;
            outline: none;
            transition: border-color 0.2s;
        }

        .search-bar input:focus { border-color: #2e7d32; }

        .btn {
            padding: 9px 18px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.88rem;
            font-weight: 600;
            transition: background 0.2s;
        }

        .btn-primary { background: #2e7d32; color: #fff; }
        .btn-primary:hover { background: #1b5e20; }
        .btn-secondary { background: #e0e0e0; color: #333; }
        .btn-secondary:hover { background: #bdbdbd; }

        /* ── Table ── */
        .table-card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .table-header {
            padding: 14px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
        }

        .table-header span {
            font-size: 0.85rem;
            color: #777;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead th {
            background: #2e7d32;
            color: #fff;
            padding: 12px 16px;
            text-align: left;
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.4px;
        }

        tbody tr {
            border-bottom: 1px solid #f0f0f0;
            transition: background 0.15s;
        }

        tbody tr:hover { background: #f1f8e9; }

        tbody td {
            padding: 11px 16px;
            font-size: 0.88rem;
            color: #444;
        }

        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 0.78rem;
            font-weight: 600;
        }

        .badge-county {
            background: #e3f2fd;
            color: #1565c0;
        }

        .price-cell {
            font-weight: 700;
            color: #2e7d32;
        }

        .no-results {
            text-align: center;
            padding: 40px;
            color: #999;
            font-size: 0.95rem;
        }

        .result-count {
            font-size: 0.85rem;
            color: #666;
            margin-bottom: 8px;
        }
    </style>
</head>
<body>

<!-- Navigation -->
<nav>
    <a href="../index.jsp" class="brand">🌾 AgriMarket Tracker</a>
    <ul>
        <li><a href="list.jsp" class="active">Price List</a></li>
        <li><a href="compare.jsp">Compare</a></li>
        <li><a href="entry.jsp">Add Price</a></li>
        <li><a href="history.jsp">History</a></li>
        <li><a href="../trends/trends.jsp">Trends</a></li>
    </ul>
</nav>

<div class="page-wrapper">
    <h1 class="page-title">Agricultural Market Prices</h1>

    <!-- Search Bar -->
    <div class="search-bar">
        <input type="text" id="searchInput" placeholder="🔍  Search by product, market, or county..." oninput="applyFilters()">
        <button class="btn btn-secondary" onclick="clearAll()">Clear</button>
    </div>

    <!-- Filters -->
    <div class="filter-card">
        <h3>Filters</h3>
        <div class="filter-grid">
            <div class="form-group">
                <label for="filterProduct">Product</label>
                <select id="filterProduct" onchange="applyFilters()">
                    <option value="">All Products</option>
                    <option value="Maize">Maize</option>
                    <option value="Wheat">Wheat</option>
                    <option value="Rice">Rice</option>
                    <option value="Sorghum">Sorghum</option>
                    <option value="Beans">Beans</option>
                    <option value="Potatoes">Potatoes</option>
                    <option value="Tomatoes">Tomatoes</option>
                </select>
            </div>
            <div class="form-group">
                <label for="filterMarket">Market</label>
                <select id="filterMarket" onchange="applyFilters()">
                    <option value="">All Markets</option>
                    <option value="Nairobi Market">Nairobi Market</option>
                    <option value="Mombasa Market">Mombasa Market</option>
                    <option value="Kisumu Market">Kisumu Market</option>
                    <option value="Nakuru Market">Nakuru Market</option>
                    <option value="Eldoret Market">Eldoret Market</option>
                </select>
            </div>
            <div class="form-group">
                <label for="filterCounty">County</label>
                <select id="filterCounty" onchange="applyFilters()">
                    <option value="">All Counties</option>
                    <option value="Nairobi">Nairobi</option>
                    <option value="Mombasa">Mombasa</option>
                    <option value="Kisumu">Kisumu</option>
                    <option value="Nakuru">Nakuru</option>
                    <option value="Uasin Gishu">Uasin Gishu</option>
                </select>
            </div>
            <div class="form-group">
                <label for="filterDateFrom">Date From</label>
                <input type="date" id="filterDateFrom" onchange="applyFilters()">
            </div>
            <div class="form-group">
                <label for="filterDateTo">Date To</label>
                <input type="date" id="filterDateTo" onchange="applyFilters()">
            </div>
        </div>
    </div>

    <!-- Table -->
    <div class="table-card">
        <div class="table-header">
            <strong>Price Records</strong>
            <span id="resultCount">Showing 0 results</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Product</th>
                    <th>Market</th>
                    <th>County</th>
                    <th>Price (KES/kg)</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody id="priceTableBody">
                <!-- Rows injected by JavaScript -->
            </tbody>
        </table>
    </div>
</div>

<script>
    // ── Sample Data ──────────────────────────────────────────────
    const priceData = [
        { product: "Maize",    market: "Nairobi Market",  county: "Nairobi",     price: 45,  date: "2025-05-01" },
        { product: "Wheat",    market: "Nakuru Market",   county: "Nakuru",      price: 62,  date: "2025-05-02" },
        { product: "Rice",     market: "Mombasa Market",  county: "Mombasa",     price: 120, date: "2025-05-03" },
        { product: "Sorghum",  market: "Kisumu Market",   county: "Kisumu",      price: 38,  date: "2025-05-04" },
        { product: "Beans",    market: "Eldoret Market",  county: "Uasin Gishu", price: 95,  date: "2025-05-05" },
        { product: "Maize",    market: "Kisumu Market",   county: "Kisumu",      price: 42,  date: "2025-05-06" },
        { product: "Potatoes", market: "Nakuru Market",   county: "Nakuru",      price: 30,  date: "2025-05-07" },
        { product: "Tomatoes", market: "Nairobi Market",  county: "Nairobi",     price: 55,  date: "2025-05-08" },
        { product: "Wheat",    market: "Eldoret Market",  county: "Uasin Gishu", price: 58,  date: "2025-05-09" },
        { product: "Rice",     market: "Nairobi Market",  county: "Nairobi",     price: 115, date: "2025-05-10" },
        { product: "Maize",    market: "Mombasa Market",  county: "Mombasa",     price: 50,  date: "2025-05-11" },
        { product: "Beans",    market: "Kisumu Market",   county: "Kisumu",      price: 90,  date: "2025-05-12" },
        { product: "Sorghum",  market: "Nakuru Market",   county: "Nakuru",      price: 35,  date: "2025-05-13" },
        { product: "Potatoes", market: "Nairobi Market",  county: "Nairobi",     price: 28,  date: "2025-05-14" },
        { product: "Tomatoes", market: "Mombasa Market",  county: "Mombasa",     price: 60,  date: "2025-05-15" },
    ];

    function applyFilters() {
        const search      = document.getElementById('searchInput').value.toLowerCase().trim();
        const product     = document.getElementById('filterProduct').value;
        const market      = document.getElementById('filterMarket').value;
        const county      = document.getElementById('filterCounty').value;
        const dateFrom    = document.getElementById('filterDateFrom').value;
        const dateTo      = document.getElementById('filterDateTo').value;

        const filtered = priceData.filter(row => {
            const matchSearch  = !search || [row.product, row.market, row.county].some(v => v.toLowerCase().includes(search));
            const matchProduct = !product || row.product === product;
            const matchMarket  = !market  || row.market  === market;
            const matchCounty  = !county  || row.county  === county;
            const matchFrom    = !dateFrom || row.date >= dateFrom;
            const matchTo      = !dateTo   || row.date <= dateTo;
            return matchSearch && matchProduct && matchMarket && matchCounty && matchFrom && matchTo;
        });

        renderTable(filtered);
    }

    function renderTable(data) {
        const tbody = document.getElementById('priceTableBody');
        const countEl = document.getElementById('resultCount');
        countEl.textContent = `Showing ${data.length} result${data.length !== 1 ? 's' : ''}`;

        if (data.length === 0) {
            tbody.innerHTML = `<tr><td colspan="6" class="no-results">No records found matching your filters.</td></tr>`;
            return;
        }

        tbody.innerHTML = data.map((row, i) => `
            <tr>
                <td>${i + 1}</td>
                <td><strong>${row.product}</strong></td>
                <td>${row.market}</td>
                <td><span class="badge badge-county">${row.county}</span></td>
                <td class="price-cell">KES ${row.price.toFixed(2)}</td>
                <td>${formatDate(row.date)}</td>
            </tr>
        `).join('');
    }

    function formatDate(dateStr) {
        const d = new Date(dateStr);
        return d.toLocaleDateString('en-KE', { year: 'numeric', month: 'short', day: '2-digit' });
    }

    function clearAll() {
        document.getElementById('searchInput').value = '';
        document.getElementById('filterProduct').value = '';
        document.getElementById('filterMarket').value = '';
        document.getElementById('filterCounty').value = '';
        document.getElementById('filterDateFrom').value = '';
        document.getElementById('filterDateTo').value = '';
        applyFilters();
    }

    // Initial render
    applyFilters();
</script>
</body>
</html>