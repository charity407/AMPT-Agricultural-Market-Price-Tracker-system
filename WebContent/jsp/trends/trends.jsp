<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Price Trends | AgriMarket Tracker</title>
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

        .page-wrapper { max-width: 960px; margin: 30px auto; padding: 0 16px; }

        .page-title {
            font-size: 1.6rem; color: #2e7d32; margin-bottom: 24px;
            font-weight: 700; border-left: 5px solid #66bb6a; padding-left: 12px;
        }

        /* Product selector */
        .selector-bar {
            background: #fff; border-radius: 8px; padding: 16px 20px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08); margin-bottom: 20px;
            display: flex; gap: 16px; align-items: center; flex-wrap: wrap;
        }
        .selector-bar label { font-size: 0.88rem; font-weight: 600; color: #555; }
        .selector-bar select {
            padding: 8px 12px; border: 1px solid #ccc; border-radius: 6px;
            font-size: 0.88rem; outline: none;
        }
        .selector-bar select:focus { border-color: #2e7d32; }

        /* Stats cards */
        .stats-grid {
            display: grid; grid-template-columns: repeat(3, 1fr);
            gap: 16px; margin-bottom: 24px;
        }

        .stat-card {
            background: #fff; border-radius: 8px;
            padding: 20px 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.1);
            text-align: center; border-top: 4px solid transparent;
            transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-2px); }
        .stat-card.min  { border-top-color: #43a047; }
        .stat-card.max  { border-top-color: #e53935; }
        .stat-card.avg  { border-top-color: #fb8c00; }

        .stat-label {
            font-size: 0.78rem; text-transform: uppercase; letter-spacing: 1px;
            color: #888; margin-bottom: 10px; font-weight: 600;
        }
        .stat-value {
            font-size: 1.8rem; font-weight: 700; color: #222;
        }
        .stat-value span { font-size: 1rem; color: #888; font-weight: 400; }
        .stat-sub { font-size: 0.78rem; color: #aaa; margin-top: 4px; }

        /* Chart card */
        .chart-card {
            background: #fff; border-radius: 10px;
            padding: 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.1);
            margin-bottom: 24px;
        }
        .chart-card h2 {
            font-size: 1rem; color: #2e7d32; margin-bottom: 20px;
            padding-bottom: 10px; border-bottom: 1px solid #eee;
        }

        canvas {
            display: block; width: 100% !important;
        }

        /* Data table beneath chart */
        .data-table-card {
            background: #fff; border-radius: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08); overflow: hidden;
        }
        .data-table-card h3 {
            font-size: 0.95rem; padding: 14px 20px; border-bottom: 1px solid #eee;
            color: #333;
        }
        table { width: 100%; border-collapse: collapse; }
        thead th {
            background: #2e7d32; color: #fff; padding: 11px 16px;
            text-align: left; font-size: 0.84rem;
        }
        tbody tr { border-bottom: 1px solid #f5f5f5; }
        tbody tr:hover { background: #f1f8e9; }
        tbody td { padding: 10px 16px; font-size: 0.88rem; color: #444; }
        .price-cell { font-weight: 700; color: #2e7d32; }

        @media (max-width: 600px) {
            .stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<nav>
    <a href="../index.jsp" class="brand">🌾 AgriMarket Tracker</a>
    <ul>
        <li><a href="../prices/list.jsp">Price List</a></li>
        <li><a href="../prices/compare.jsp">Compare</a></li>
        <li><a href="../prices/entry.jsp">Add Price</a></li>
        <li><a href="../prices/history.jsp">History</a></li>
        <li><a href="trends.jsp" class="active">Trends</a></li>
    </ul>
</nav>

<div class="page-wrapper">
    <h1 class="page-title">Price Trends</h1>

    <!-- Product selector -->
    <div class="selector-bar">
        <label for="trendProduct">Select Product:</label>
        <select id="trendProduct" onchange="updateTrend()">
            <option value="Maize">Maize</option>
            <option value="Wheat">Wheat</option>
            <option value="Rice">Rice</option>
            <option value="Beans">Beans</option>
            <option value="Sorghum">Sorghum</option>
            <option value="Potatoes">Potatoes</option>
            <option value="Tomatoes">Tomatoes</option>
        </select>
        <label for="trendMarket">Market:</label>
        <select id="trendMarket" onchange="updateTrend()">
            <option value="Nairobi Market">Nairobi Market</option>
            <option value="Mombasa Market">Mombasa Market</option>
            <option value="Kisumu Market">Kisumu Market</option>
            <option value="Nakuru Market">Nakuru Market</option>
            <option value="Eldoret Market">Eldoret Market</option>
        </select>
    </div>

    <!-- Stats -->
    <div class="stats-grid">
        <div class="stat-card min">
            <div class="stat-label">Minimum Price</div>
            <div class="stat-value" id="statMin">—</div>
            <div class="stat-sub" id="statMinDate">—</div>
        </div>
        <div class="stat-card max">
            <div class="stat-label">Maximum Price</div>
            <div class="stat-value" id="statMax">—</div>
            <div class="stat-sub" id="statMaxDate">—</div>
        </div>
        <div class="stat-card avg">
            <div class="stat-label">Average Price</div>
            <div class="stat-value" id="statAvg">—</div>
            <div class="stat-sub">Over selected period</div>
        </div>
    </div>

    <!-- Chart -->
    <div class="chart-card">
        <h2 id="chartTitle">Price Trend Chart</h2>
        <canvas id="trendChart" height="320"></canvas>
    </div>

    <!-- Data table -->
    <div class="data-table-card">
        <h3>📋 Trend Data Points</h3>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Date</th>
                    <th>Price (KES/kg)</th>
                    <th>Change</th>
                </tr>
            </thead>
            <tbody id="trendTableBody"></tbody>
        </table>
    </div>
</div>

<script>
    // ── Full trend dataset ───────────────────────────────────────
    const trendDataset = {
        "Nairobi Market": {
            Maize:    [ {date:"May 1",  price:110}, {date:"May 5",  price:115}, {date:"May 10", price:120}, {date:"May 15", price:118} ],
            Wheat:    [ {date:"May 1",  price:58},  {date:"May 5",  price:62},  {date:"May 10", price:65},  {date:"May 15", price:63}  ],
            Rice:     [ {date:"May 1",  price:108}, {date:"May 5",  price:112}, {date:"May 10", price:115}, {date:"May 15", price:114} ],
            Beans:    [ {date:"May 1",  price:88},  {date:"May 5",  price:92},  {date:"May 10", price:100}, {date:"May 15", price:96}  ],
            Sorghum:  [ {date:"May 1",  price:33},  {date:"May 5",  price:36},  {date:"May 10", price:40},  {date:"May 15", price:38}  ],
            Potatoes: [ {date:"May 1",  price:24},  {date:"May 5",  price:26},  {date:"May 10", price:28},  {date:"May 15", price:27}  ],
            Tomatoes: [ {date:"May 1",  price:48},  {date:"May 5",  price:52},  {date:"May 10", price:55},  {date:"May 15", price:53}  ],
        },
        "Mombasa Market": {
            Maize:    [ {date:"May 1",  price:115}, {date:"May 5",  price:118}, {date:"May 10", price:122}, {date:"May 15", price:120} ],
            Wheat:    [ {date:"May 1",  price:62},  {date:"May 5",  price:66},  {date:"May 10", price:70},  {date:"May 15", price:68}  ],
            Rice:     [ {date:"May 1",  price:112}, {date:"May 5",  price:116}, {date:"May 10", price:120}, {date:"May 15", price:118} ],
            Beans:    [ {date:"May 1",  price:90},  {date:"May 5",  price:96},  {date:"May 10", price:105}, {date:"May 15", price:100} ],
            Sorghum:  [ {date:"May 1",  price:36},  {date:"May 5",  price:39},  {date:"May 10", price:43},  {date:"May 15", price:41}  ],
            Potatoes: [ {date:"May 1",  price:27},  {date:"May 5",  price:29},  {date:"May 10", price:32},  {date:"May 15", price:30}  ],
            Tomatoes: [ {date:"May 1",  price:52},  {date:"May 5",  price:56},  {date:"May 10", price:60},  {date:"May 15", price:58}  ],
        },
        "Kisumu Market": {
            Maize:    [ {date:"May 1",  price:105}, {date:"May 5",  price:110}, {date:"May 10", price:116}, {date:"May 15", price:113} ],
            Wheat:    [ {date:"May 1",  price:54},  {date:"May 5",  price:58},  {date:"May 10", price:62},  {date:"May 15", price:60}  ],
            Rice:     [ {date:"May 1",  price:105}, {date:"May 5",  price:110}, {date:"May 10", price:118}, {date:"May 15", price:115} ],
            Beans:    [ {date:"May 1",  price:82},  {date:"May 5",  price:86},  {date:"May 10", price:91},  {date:"May 15", price:89}  ],
            Sorghum:  [ {date:"May 1",  price:30},  {date:"May 5",  price:33},  {date:"May 10", price:37},  {date:"May 15", price:35}  ],
            Potatoes: [ {date:"May 1",  price:20},  {date:"May 5",  price:23},  {date:"May 10", price:26},  {date:"May 15", price:25}  ],
            Tomatoes: [ {date:"May 1",  price:44},  {date:"May 5",  price:48},  {date:"May 10", price:52},  {date:"May 15", price:50}  ],
        },
        "Nakuru Market": {
            Maize:    [ {date:"May 1",  price:100}, {date:"May 5",  price:106}, {date:"May 10", price:112}, {date:"May 15", price:110} ],
            Wheat:    [ {date:"May 1",  price:52},  {date:"May 5",  price:56},  {date:"May 10", price:60},  {date:"May 15", price:58}  ],
            Rice:     [ {date:"May 1",  price:102}, {date:"May 5",  price:107}, {date:"May 10", price:112}, {date:"May 15", price:110} ],
            Beans:    [ {date:"May 1",  price:80},  {date:"May 5",  price:84},  {date:"May 10", price:88},  {date:"May 15", price:86}  ],
            Sorghum:  [ {date:"May 1",  price:28},  {date:"May 5",  price:31},  {date:"May 10", price:35},  {date:"May 15", price:33}  ],
            Potatoes: [ {date:"May 1",  price:18},  {date:"May 5",  price:21},  {date:"May 10", price:24},  {date:"May 15", price:22}  ],
            Tomatoes: [ {date:"May 1",  price:42},  {date:"May 5",  price:46},  {date:"May 10", price:50},  {date:"May 15", price:48}  ],
        },
        "Eldoret Market": {
            Maize:    [ {date:"May 1",  price:98},  {date:"May 5",  price:104}, {date:"May 10", price:108}, {date:"May 15", price:106} ],
            Wheat:    [ {date:"May 1",  price:50},  {date:"May 5",  price:54},  {date:"May 10", price:58},  {date:"May 15", price:56}  ],
            Rice:     [ {date:"May 1",  price:100}, {date:"May 5",  price:105}, {date:"May 10", price:110}, {date:"May 15", price:108} ],
            Beans:    [ {date:"May 1",  price:78},  {date:"May 5",  price:82},  {date:"May 10", price:86},  {date:"May 15", price:84}  ],
            Sorghum:  [ {date:"May 1",  price:26},  {date:"May 5",  price:29},  {date:"May 10", price:33},  {date:"May 15", price:31}  ],
            Potatoes: [ {date:"May 1",  price:16},  {date:"May 5",  price:19},  {date:"May 10", price:22},  {date:"May 15", price:20}  ],
            Tomatoes: [ {date:"May 1",  price:40},  {date:"May 5",  price:44},  {date:"May 10", price:48},  {date:"May 15", price:46}  ],
        },
    };

    function updateTrend() {
        const product = document.getElementById('trendProduct').value;
        const market  = document.getElementById('trendMarket').value;
        const data    = trendDataset[market][product];

        const prices = data.map(d => d.price);
        const labels = data.map(d => d.date);

        const minVal  = Math.min(...prices);
        const maxVal  = Math.max(...prices);
        const avgVal  = (prices.reduce((a,b) => a + b, 0) / prices.length).toFixed(1);
        const minDate = data[prices.indexOf(minVal)].date;
        const maxDate = data[prices.indexOf(maxVal)].date;

        document.getElementById('statMin').innerHTML     = `KES ${minVal} <span>/kg</span>`;
        document.getElementById('statMax').innerHTML     = `KES ${maxVal} <span>/kg</span>`;
        document.getElementById('statAvg').innerHTML     = `KES ${avgVal} <span>/kg</span>`;
        document.getElementById('statMinDate').textContent = `Recorded: ${minDate}`;
        document.getElementById('statMaxDate').textContent = `Recorded: ${maxDate}`;

        document.getElementById('chartTitle').textContent =
            `${product} — ${market} Price Trend (May 2025)`;

        drawChart(labels, prices, minVal, maxVal);
        buildDataTable(data);
    }

    function drawChart(labels, prices, minVal, maxVal) {
        const canvas = document.getElementById('trendChart');
        const ctx    = canvas.getContext('2d');
        const dpr    = window.devicePixelRatio || 1;
        const cssW   = canvas.parentElement.clientWidth - 48;
        const cssH   = 320;

        canvas.width  = cssW * dpr;
        canvas.height = cssH * dpr;
        canvas.style.width  = cssW + 'px';
        canvas.style.height = cssH + 'px';
        ctx.scale(dpr, dpr);

        const W = cssW, H = cssH;
        const padL = 70, padR = 30, padT = 30, padB = 50;
        const plotW = W - padL - padR;
        const plotH = H - padT - padB;

        ctx.clearRect(0, 0, W, H);

        // Background
        ctx.fillStyle = '#fafafa';
        ctx.fillRect(0, 0, W, H);

        // Price range
        const pMin = Math.floor(minVal * 0.92);
        const pMax = Math.ceil(maxVal * 1.08);
        const pRange = pMax - pMin;

        // Helper: map price → y
        function py(p) { return padT + plotH - ((p - pMin) / pRange) * plotH; }
        // Helper: map index → x
        function px(i) { return padL + (i / (prices.length - 1)) * plotW; }

        // ── Grid lines ───────────────────────────────────────────
        const gridCount = 5;
        ctx.setLineDash([4, 4]);
        ctx.strokeStyle = '#e0e0e0';
        ctx.lineWidth = 1;

        for (let g = 0; g <= gridCount; g++) {
            const gVal = pMin + (pRange / gridCount) * g;
            const gy   = py(gVal);
            ctx.beginPath();
            ctx.moveTo(padL, gy);
            ctx.lineTo(padL + plotW, gy);
            ctx.stroke();

            // Y axis labels
            ctx.setLineDash([]);
            ctx.fillStyle = '#888';
            ctx.font = '11px Segoe UI';
            ctx.textAlign = 'right';
            ctx.fillText('KES ' + Math.round(gVal), padL - 8, gy + 4);
            ctx.setLineDash([4, 4]);
        }
        ctx.setLineDash([]);

        // ── Axes ─────────────────────────────────────────────────
        ctx.strokeStyle = '#ccc';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(padL, padT);
        ctx.lineTo(padL, padT + plotH);
        ctx.lineTo(padL + plotW, padT + plotH);
        ctx.stroke();

        // ── Filled area under line ───────────────────────────────
        ctx.beginPath();
        ctx.moveTo(px(0), py(prices[0]));
        for (let i = 1; i < prices.length; i++) ctx.lineTo(px(i), py(prices[i]));
        ctx.lineTo(px(prices.length - 1), padT + plotH);
        ctx.lineTo(px(0), padT + plotH);
        ctx.closePath();
        const grad = ctx.createLinearGradient(0, padT, 0, padT + plotH);
        grad.addColorStop(0, 'rgba(46,125,50,0.18)');
        grad.addColorStop(1, 'rgba(46,125,50,0.02)');
        ctx.fillStyle = grad;
        ctx.fill();

        // ── Trend line ───────────────────────────────────────────
        ctx.beginPath();
        ctx.moveTo(px(0), py(prices[0]));
        for (let i = 1; i < prices.length; i++) ctx.lineTo(px(i), py(prices[i]));
        ctx.strokeStyle = '#2e7d32';
        ctx.lineWidth = 2.5;
        ctx.lineJoin = 'round';
        ctx.stroke();

        // ── Average line ─────────────────────────────────────────
        const avg = prices.reduce((a,b) => a+b, 0) / prices.length;
        const avgY = py(avg);
        ctx.beginPath();
        ctx.moveTo(padL, avgY);
        ctx.lineTo(padL + plotW, avgY);
        ctx.setLineDash([6, 4]);
        ctx.strokeStyle = '#fb8c00';
        ctx.lineWidth = 1.5;
        ctx.stroke();
        ctx.setLineDash([]);
        ctx.fillStyle = '#fb8c00';
        ctx.font = 'bold 10px Segoe UI';
        ctx.textAlign = 'left';
        ctx.fillText('Avg: ' + avg.toFixed(1), padL + plotW + 2, avgY + 4);

        // ── Data points & labels ─────────────────────────────────
        prices.forEach((p, i) => {
            const x = px(i), y = py(p);

            // Glow for min/max
            if (p === maxVal || p === minVal) {
                ctx.beginPath();
                ctx.arc(x, y, 7, 0, Math.PI * 2);
                ctx.fillStyle = p === maxVal ? 'rgba(229,57,53,0.15)' : 'rgba(67,160,71,0.15)';
                ctx.fill();
            }

            // Circle
            ctx.beginPath();
            ctx.arc(x, y, 5, 0, Math.PI * 2);
            ctx.fillStyle = p === maxVal ? '#e53935' : p === minVal ? '#43a047' : '#2e7d32';
            ctx.fill();
            ctx.strokeStyle = '#fff';
            ctx.lineWidth = 2;
            ctx.stroke();

            // Price label
            ctx.fillStyle = '#333';
            ctx.font = 'bold 12px Segoe UI';
            ctx.textAlign = 'center';
            ctx.fillText('KES ' + p, x, y - 13);

            // X axis label
            ctx.fillStyle = '#666';
            ctx.font = '11px Segoe UI';
            ctx.fillText(labels[i], x, padT + plotH + 20);
        });

        // ── Legend ───────────────────────────────────────────────
        const legend = [
            { color: '#2e7d32', label: 'Price' },
            { color: '#e53935', label: 'Highest' },
            { color: '#43a047', label: 'Lowest' },
            { color: '#fb8c00', label: 'Average', dash: true },
        ];
        let lx = padL;
        legend.forEach(l => {
            ctx.beginPath();
            if (l.dash) ctx.setLineDash([5, 4]);
            ctx.moveTo(lx, padT - 12);
            ctx.lineTo(lx + 20, padT - 12);
            ctx.strokeStyle = l.color;
            ctx.lineWidth = 2;
            ctx.stroke();
            ctx.setLineDash([]);

            if (!l.dash) {
                ctx.beginPath();
                ctx.arc(lx + 10, padT - 12, 4, 0, Math.PI * 2);
                ctx.fillStyle = l.color;
                ctx.fill();
            }

            ctx.fillStyle = '#555';
            ctx.font = '11px Segoe UI';
            ctx.textAlign = 'left';
            ctx.fillText(l.label, lx + 24, padT - 8);
            lx += 80;
        });
    }

    function buildDataTable(data) {
        const tbody = document.getElementById('trendTableBody');
        tbody.innerHTML = data.map((d, i) => {
            const change = i === 0 ? '—' : (d.price - data[i-1].price >= 0
                ? `<span style="color:#e53935">+${(d.price - data[i-1].price).toFixed(1)}</span>`
                : `<span style="color:#43a047">${(d.price - data[i-1].price).toFixed(1)}</span>`);
            return `<tr>
                <td>${i + 1}</td>
                <td>${d.date}</td>
                <td class="price-cell">KES ${d.price.toFixed(2)}</td>
                <td>${change}</td>
            </tr>`;
        }).join('');
    }

    // Initial draw
    updateTrend();

    // Redraw on resize
    window.addEventListener('resize', updateTrend);
</script>
</body>
</html>