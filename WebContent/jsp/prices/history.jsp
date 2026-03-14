<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Price History | AgriMarket Tracker</title>
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
        nav ul li a:hover, nav ul li a.active { background: #1b5e20; color: #fff; }

        .page-wrapper { max-width: 1100px; margin: 30px auto; padding: 0 16px; }

        .page-title {
            font-size: 1.6rem; color: #2e7d32; margin-bottom: 20px;
            font-weight: 700; border-left: 5px solid #66bb6a; padding-left: 12px;
        }

        /* Filters */
        .filter-bar {
            background: #fff; border-radius: 8px; padding: 18px 20px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08); margin-bottom: 20px;
            display: flex; flex-wrap: wrap; gap: 14px; align-items: flex-end;
        }
        .filter-item { display: flex; flex-direction: column; gap: 4px; }
        .filter-item label { font-size: 0.8rem; color: #555; font-weight: 600; }
        .filter-item select, .filter-item input {
            padding: 8px 12px; border: 1px solid #ccc; border-radius: 5px;
            font-size: 0.88rem; outline: none;
        }
        .filter-item select:focus, .filter-item input:focus { border-color: #2e7d32; }

        .btn {
            padding: 8px 16px; border: none; border-radius: 6px;
            cursor: pointer; font-size: 0.88rem; font-weight: 600; transition: background 0.2s;
        }
        .btn-primary { background: #2e7d32; color: #fff; }
        .btn-primary:hover { background: #1b5e20; }
        .btn-secondary { background: #e0e0e0; color: #333; }
        .btn-secondary:hover { background: #bdbdbd; }

        /* Table */
        .table-card {
            background: #fff; border-radius: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.1); overflow: hidden;
        }

        .table-top {
            padding: 14px 20px; display: flex; justify-content: space-between;
            align-items: center; border-bottom: 1px solid #eee; flex-wrap: wrap; gap: 8px;
        }
        .table-top strong { font-size: 1rem; color: #333; }

        .per-page-select { display: flex; align-items: center; gap: 8px; font-size: 0.85rem; }
        .per-page-select select {
            padding: 5px 8px; border: 1px solid #ccc; border-radius: 4px; font-size: 0.85rem;
        }

        table { width: 100%; border-collapse: collapse; }
        thead th {
            background: #2e7d32; color: #fff; padding: 12px 16px;
            text-align: left; font-size: 0.85rem; font-weight: 600;
            cursor: pointer; user-select: none;
        }
        thead th:hover { background: #388e3c; }
        thead th .sort-icon { margin-left: 4px; opacity: 0.7; }

        tbody tr { border-bottom: 1px solid #f0f0f0; transition: background 0.15s; }
        tbody tr:hover { background: #f1f8e9; }
        tbody td { padding: 11px 16px; font-size: 0.88rem; color: #444; }
        .price-cell { font-weight: 700; color: #2e7d32; }
        .no-data { text-align: center; padding: 50px; color: #aaa; }

        /* Pagination */
        .pagination {
            padding: 16px 20px; display: flex; align-items: center;
            justify-content: space-between; border-top: 1px solid #eee;
            flex-wrap: wrap; gap: 10px;
        }
        .pagination-info { font-size: 0.85rem; color: #666; }
        .pagination-btns { display: flex; gap: 4px; }
        .page-btn {
            min-width: 34px; height: 34px; border: 1px solid #ddd;
            background: #fff; border-radius: 5px; cursor: pointer;
            font-size: 0.85rem; color: #444; transition: all 0.15s;
            display: flex; align-items: center; justify-content: center;
        }
        .page-btn:hover { background: #e8f5e9; border-color: #66bb6a; }
        .page-btn.active { background: #2e7d32; color: #fff; border-color: #2e7d32; }
        .page-btn:disabled { opacity: 0.4; cursor: default; }
    </style>
</head>
<body>

<nav>
    <a href="../index.jsp" class="brand">🌾 AgriMarket Tracker</a>
    <ul>
        <li><a href="list.jsp">Price List</a></li>
        <li><a href="compare.jsp">Compare</a></li>
        <li><a href="entry.jsp">Add Price</a></li>
        <li><a href="history.jsp" class="active">History</a></li>
        <li><a href="../trends/trends.jsp">Trends</a></li>
    </ul>
</nav>

<div class="page-wrapper">
    <h1 class="page-title">Price History</h1>

    <!-- Filter Bar -->
    <div class="filter-bar">
        <div class="filter-item">
            <label for="hFilterProduct">Product</label>
            <select id="hFilterProduct" onchange="applyAndRender()">
                <option value="">All Products</option>
                <option>Maize</option><option>Wheat</option><option>Rice</option>
                <option>Sorghum</option><option>Beans</option>
                <option>Potatoes</option><option>Tomatoes</option>
            </select>
        </div>
        <div class="filter-item">
            <label for="hFilterMarket">Market</label>
            <select id="hFilterMarket" onchange="applyAndRender()">
                <option value="">All Markets</option>
                <option>Nairobi Market</option><option>Mombasa Market</option>
                <option>Kisumu Market</option><option>Nakuru Market</option>
                <option>Eldoret Market</option>
            </select>
        </div>
        <div class="filter-item">
            <label for="hFromDate">From</label>
            <input type="date" id="hFromDate" onchange="applyAndRender()">
        </div>
        <div class="filter-item">
            <label for="hToDate">To</label>
            <input type="date" id="hToDate" onchange="applyAndRender()">
        </div>
        <button class="btn btn-secondary" onclick="clearFilters()">Clear</button>
    </div>

    <!-- Table -->
    <div class="table-card">
        <div class="table-top">
            <strong>Historical Price Records</strong>
            <div class="per-page-select">
                Rows per page:
                <select id="perPageSel" onchange="changePerPage()">
                    <option value="5">5</option>
                    <option value="10" selected>10</option>
                    <option value="20">20</option>
                    <option value="50">50</option>
                </select>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th onclick="sortBy('date')">Date <span class="sort-icon" id="sort-date">⇅</span></th>
                    <th onclick="sortBy('product')">Product <span class="sort-icon" id="sort-product">⇅</span></th>
                    <th onclick="sortBy('market')">Market <span class="sort-icon" id="sort-market">⇅</span></th>
                    <th onclick="sortBy('county')">County <span class="sort-icon" id="sort-county">⇅</span></th>
                    <th onclick="sortBy('price')">Price (KES/kg) <span class="sort-icon" id="sort-price">⇅</span></th>
                </tr>
            </thead>
            <tbody id="historyBody"></tbody>
        </table>

        <div class="pagination">
            <span class="pagination-info" id="pageInfo">Showing 0–0 of 0</span>
            <div class="pagination-btns" id="pageBtns"></div>
        </div>
    </div>
</div>

<script>
    // ── Large sample dataset ─────────────────────────────────────
    const historyData = [
        { date:"2025-01-05", product:"Maize",    market:"Nairobi Market",  county:"Nairobi",     price:40 },
        { date:"2025-01-08", product:"Wheat",    market:"Nakuru Market",   county:"Nakuru",      price:58 },
        { date:"2025-01-10", product:"Rice",     market:"Mombasa Market",  county:"Mombasa",     price:110 },
        { date:"2025-01-12", product:"Beans",    market:"Kisumu Market",   county:"Kisumu",      price:85 },
        { date:"2025-01-15", product:"Sorghum",  market:"Eldoret Market",  county:"Uasin Gishu", price:32 },
        { date:"2025-01-18", product:"Potatoes", market:"Nakuru Market",   county:"Nakuru",      price:22 },
        { date:"2025-01-20", product:"Tomatoes", market:"Nairobi Market",  county:"Nairobi",     price:48 },
        { date:"2025-02-02", product:"Maize",    market:"Mombasa Market",  county:"Mombasa",     price:44 },
        { date:"2025-02-05", product:"Wheat",    market:"Eldoret Market",  county:"Uasin Gishu", price:55 },
        { date:"2025-02-08", product:"Rice",     market:"Nairobi Market",  county:"Nairobi",     price:112 },
        { date:"2025-02-10", product:"Beans",    market:"Nakuru Market",   county:"Nakuru",      price:88 },
        { date:"2025-02-12", product:"Maize",    market:"Kisumu Market",   county:"Kisumu",      price:41 },
        { date:"2025-02-15", product:"Sorghum",  market:"Nairobi Market",  county:"Nairobi",     price:37 },
        { date:"2025-02-18", product:"Tomatoes", market:"Mombasa Market",  county:"Mombasa",     price:52 },
        { date:"2025-03-01", product:"Maize",    market:"Nairobi Market",  county:"Nairobi",     price:43 },
        { date:"2025-03-05", product:"Wheat",    market:"Nakuru Market",   county:"Nakuru",      price:60 },
        { date:"2025-03-08", product:"Rice",     market:"Kisumu Market",   county:"Kisumu",      price:116 },
        { date:"2025-03-10", product:"Beans",    market:"Eldoret Market",  county:"Uasin Gishu", price:92 },
        { date:"2025-03-12", product:"Potatoes", market:"Nairobi Market",  county:"Nairobi",     price:26 },
        { date:"2025-03-15", product:"Sorghum",  market:"Mombasa Market",  county:"Mombasa",     price:39 },
        { date:"2025-03-18", product:"Tomatoes", market:"Nakuru Market",   county:"Nakuru",      price:50 },
        { date:"2025-04-02", product:"Maize",    market:"Eldoret Market",  county:"Uasin Gishu", price:38 },
        { date:"2025-04-05", product:"Wheat",    market:"Nairobi Market",  county:"Nairobi",     price:63 },
        { date:"2025-04-08", product:"Rice",     market:"Mombasa Market",  county:"Mombasa",     price:118 },
        { date:"2025-04-10", product:"Beans",    market:"Kisumu Market",   county:"Kisumu",      price:91 },
        { date:"2025-04-12", product:"Maize",    market:"Nakuru Market",   county:"Nakuru",      price:42 },
        { date:"2025-04-15", product:"Sorghum",  market:"Kisumu Market",   county:"Kisumu",      price:35 },
        { date:"2025-04-18", product:"Potatoes", market:"Mombasa Market",  county:"Mombasa",     price:30 },
        { date:"2025-05-01", product:"Maize",    market:"Nairobi Market",  county:"Nairobi",     price:45 },
        { date:"2025-05-05", product:"Wheat",    market:"Nakuru Market",   county:"Nakuru",      price:62 },
        { date:"2025-05-08", product:"Rice",     market:"Mombasa Market",  county:"Mombasa",     price:120 },
        { date:"2025-05-10", product:"Tomatoes", market:"Kisumu Market",   county:"Kisumu",      price:54 },
        { date:"2025-05-12", product:"Beans",    market:"Eldoret Market",  county:"Uasin Gishu", price:95 },
        { date:"2025-05-15", product:"Potatoes", market:"Nairobi Market",  county:"Nairobi",     price:28 },
    ];

    let filtered   = [...historyData];
    let currentPage = 1;
    let perPage     = 10;
    let sortKey     = 'date';
    let sortAsc     = false;

    function applyAndRender() {
        const prod = document.getElementById('hFilterProduct').value;
        const mkt  = document.getElementById('hFilterMarket').value;
        const from = document.getElementById('hFromDate').value;
        const to   = document.getElementById('hToDate').value;

        filtered = historyData.filter(r => {
            return (!prod || r.product === prod)
                && (!mkt  || r.market  === mkt)
                && (!from || r.date >= from)
                && (!to   || r.date <= to);
        });

        // Sort
        filtered.sort((a, b) => {
            let va = a[sortKey], vb = b[sortKey];
            if (sortKey === 'price') { va = +va; vb = +vb; }
            if (va < vb) return sortAsc ? -1 : 1;
            if (va > vb) return sortAsc ? 1 : -1;
            return 0;
        });

        currentPage = 1;
        renderPage();
    }

    function renderPage() {
        const total  = filtered.length;
        const start  = (currentPage - 1) * perPage;
        const end    = Math.min(start + perPage, total);
        const slice  = filtered.slice(start, end);

        const tbody = document.getElementById('historyBody');
        if (slice.length === 0) {
            tbody.innerHTML = `<tr><td colspan="5" class="no-data">No records found.</td></tr>`;
        } else {
            tbody.innerHTML = slice.map(r => `
                <tr>
                    <td>${formatDate(r.date)}</td>
                    <td><strong>${r.product}</strong></td>
                    <td>${r.market}</td>
                    <td>${r.county}</td>
                    <td class="price-cell">KES ${r.price.toFixed(2)}</td>
                </tr>
            `).join('');
        }

        // Pagination info
        document.getElementById('pageInfo').textContent =
            total === 0 ? 'No results' : `Showing ${start+1}–${end} of ${total}`;

        // Page buttons
        const totalPages = Math.ceil(total / perPage);
        const btnsDiv = document.getElementById('pageBtns');
        let btns = '';

        btns += `<button class="page-btn" onclick="goPage(${currentPage-1})" ${currentPage===1?'disabled':''}>‹</button>`;
        for (let p = 1; p <= totalPages; p++) {
            if (totalPages > 7 && Math.abs(p - currentPage) > 2 && p !== 1 && p !== totalPages) {
                if (p === 2 || p === totalPages - 1) btns += `<button class="page-btn" disabled>…</button>`;
                continue;
            }
            btns += `<button class="page-btn ${p===currentPage?'active':''}" onclick="goPage(${p})">${p}</button>`;
        }
        btns += `<button class="page-btn" onclick="goPage(${currentPage+1})" ${currentPage===totalPages||totalPages===0?'disabled':''}>›</button>`;
        btnsDiv.innerHTML = btns;
    }

    function goPage(p) {
        const total = Math.ceil(filtered.length / perPage);
        if (p < 1 || p > total) return;
        currentPage = p;
        renderPage();
    }

    function changePerPage() {
        perPage = parseInt(document.getElementById('perPageSel').value);
        currentPage = 1;
        renderPage();
    }

    function sortBy(key) {
        if (sortKey === key) sortAsc = !sortAsc;
        else { sortKey = key; sortAsc = true; }
        ['date','product','market','county','price'].forEach(k => {
            document.getElementById('sort-' + k).textContent = '⇅';
        });
        document.getElementById('sort-' + key).textContent = sortAsc ? '▲' : '▼';
        applyAndRender();
    }

    function clearFilters() {
        document.getElementById('hFilterProduct').value = '';
        document.getElementById('hFilterMarket').value  = '';
        document.getElementById('hFromDate').value = '';
        document.getElementById('hToDate').value   = '';
        applyAndRender();
    }

    function formatDate(d) {
        const dt = new Date(d);
        return dt.toLocaleDateString('en-KE', { year:'numeric', month:'short', day:'2-digit' });
    }

    // Initial render
    applyAndRender();
</script>
</body>
</html>