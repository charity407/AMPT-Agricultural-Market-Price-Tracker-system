<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Redirect to login if no session
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String role = (String) session.getAttribute("userRole");
    String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Dashboard — AgriPrice KE</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=IBM+Plex+Mono:wght@400;600&family=Source+Serif+4:ital,wght@0,300;0,400;0,600;1,300&display=swap" rel="stylesheet" />
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Source Serif 4', serif;
      background: #f5f7f5;
      color: #1a1a1a;
      min-height: 100vh;
    }

    /* ── Navbar ── */
    .navbar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      background: #1b5e20;
      color: #fff;
      padding: 0 2rem;
      height: 56px;
    }

    .navbar__brand {
      display: flex;
      align-items: center;
      gap: 0.6rem;
    }

    .navbar__logo { font-size: 1.4rem; }

    .navbar__name {
      font-family: 'Playfair Display', serif;
      font-size: 1.25rem;
      font-weight: 700;
      letter-spacing: 0.5px;
    }

    .navbar__tagline {
      font-family: 'IBM Plex Mono', monospace;
      font-size: 0.72rem;
      opacity: 0.75;
      margin-left: 0.3rem;
    }

    .navbar__right {
      display: flex;
      align-items: center;
      gap: 1.25rem;
      font-size: 0.9rem;
    }

    .navbar__user {
      font-family: 'IBM Plex Mono', monospace;
      font-size: 0.8rem;
      opacity: 0.85;
    }

    .navbar__logout {
      color: #a5d6a7;
      text-decoration: none;
      font-family: 'IBM Plex Mono', monospace;
      font-size: 0.8rem;
      padding: 0.3rem 0.75rem;
      border: 1px solid #a5d6a7;
      border-radius: 4px;
      transition: background 0.2s;
    }

    .navbar__logout:hover { background: rgba(255,255,255,0.12); }

    /* ── Main layout ── */
    .main {
      max-width: 1100px;
      margin: 2.5rem auto;
      padding: 0 1.5rem;
    }

    .welcome {
      margin-bottom: 2rem;
    }

    .welcome h1 {
      font-family: 'Playfair Display', serif;
      font-size: 2rem;
      font-weight: 700;
      color: #1b5e20;
    }

    .welcome p {
      color: #555;
      margin-top: 0.4rem;
      font-size: 1rem;
    }

    .role-badge {
      display: inline-block;
      font-family: 'IBM Plex Mono', monospace;
      font-size: 0.75rem;
      font-weight: 600;
      padding: 0.2rem 0.65rem;
      border-radius: 3px;
      margin-left: 0.6rem;
      vertical-align: middle;
    }

    .role-ADMIN   { background: #ffe0e0; color: #c41e3a; }
    .role-AGENT   { background: #e0f0ff; color: #0066cc; }
    .role-FARMER  { background: #e8f5e9; color: #2e7d32; }

    /* ── Section heading ── */
    .section-title {
      font-family: 'IBM Plex Mono', monospace;
      font-size: 0.78rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 1.5px;
      color: #888;
      margin-bottom: 1rem;
      border-bottom: 1px solid #e0e0e0;
      padding-bottom: 0.5rem;
    }

    /* ── Cards grid ── */
    .cards {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
      gap: 1.25rem;
      margin-bottom: 2.5rem;
    }

    .card {
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 1px 6px rgba(0,0,0,0.08);
      padding: 1.5rem 1.25rem;
      text-decoration: none;
      color: inherit;
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
      border-left: 4px solid #2e7d32;
      transition: box-shadow 0.2s, transform 0.15s;
    }

    .card:hover {
      box-shadow: 0 4px 16px rgba(0,0,0,0.13);
      transform: translateY(-2px);
    }

    .card__icon { font-size: 1.75rem; }

    .card__title {
      font-family: 'IBM Plex Mono', monospace;
      font-size: 0.9rem;
      font-weight: 600;
      color: #1b5e20;
    }

    .card__desc {
      font-size: 0.85rem;
      color: #777;
      line-height: 1.4;
    }

    .card--admin { border-left-color: #c41e3a; }
    .card--admin .card__title { color: #c41e3a; }

    /* ── Footer ── */
    .footer {
      text-align: center;
      padding: 2rem;
      font-size: 0.8rem;
      color: #aaa;
      font-family: 'IBM Plex Mono', monospace;
      border-top: 1px solid #e8e8e8;
      margin-top: 2rem;
    }
  </style>
</head>
<body>

  <nav class="navbar">
    <div class="navbar__brand">
      <span class="navbar__logo">⬡</span>
      <span class="navbar__name">AgriPrice KE</span>
      <span class="navbar__tagline">Market Price Tracker</span>
    </div>
    <div class="navbar__right">
      <span class="navbar__user">
        <%= userName %> &nbsp;|&nbsp; <%= role %>
      </span>
      <a href="${pageContext.request.contextPath}/logout" class="navbar__logout">Sign out</a>
    </div>
  </nav>

  <main class="main">

    <div class="welcome">
      <h1>
        Welcome, <%= userName %>
        <span class="role-badge role-<%= role %>"><%= role %></span>
      </h1>
      <p>Agricultural Market Price Tracker &mdash; select a section below to get started.</p>
    </div>

    <!-- ── Prices (all roles) ── -->
    <div class="section-title">Prices</div>
    <div class="cards">
      <a class="card" href="${pageContext.request.contextPath}/prices/list">
        <div class="card__icon">📋</div>
        <div class="card__title">Price List</div>
        <div class="card__desc">View all current market prices across regions.</div>
      </a>
      <a class="card" href="${pageContext.request.contextPath}/prices/compare">
        <div class="card__icon">⚖️</div>
        <div class="card__title">Compare Prices</div>
        <div class="card__desc">Compare a product's price across multiple markets.</div>
      </a>
      <a class="card" href="${pageContext.request.contextPath}/prices/trends">
        <div class="card__icon">📈</div>
        <div class="card__title">Price Trends</div>
        <div class="card__desc">View historical price trends over a date range.</div>
      </a>
      <% if ("AGENT".equals(role) || "ADMIN".equals(role)) { %>
      <a class="card" href="${pageContext.request.contextPath}/prices/entry">
        <div class="card__icon">➕</div>
        <div class="card__title">Enter Price</div>
        <div class="card__desc">Record today's market price for a product.</div>
      </a>
      <% } %>
    </div>

    <!-- ── Alerts & Reports ── -->
    <div class="section-title">Alerts &amp; Reports</div>
    <div class="cards">
      <a class="card" href="${pageContext.request.contextPath}/alerts">
        <div class="card__icon">🔔</div>
        <div class="card__title">Price Alerts</div>
        <div class="card__desc">Set alerts when prices cross your threshold.</div>
      </a>
      <a class="card" href="${pageContext.request.contextPath}/reports">
        <div class="card__icon">📊</div>
        <div class="card__title">Reports</div>
        <div class="card__desc">Generate weekly and monthly price summaries.</div>
      </a>
      <a class="card" href="${pageContext.request.contextPath}/profile">
        <div class="card__icon">👤</div>
        <div class="card__title">My Profile</div>
        <div class="card__desc">View and update your account details.</div>
      </a>
    </div>

    <!-- ── Admin section (admin only) ── -->
    <% if ("ADMIN".equals(role)) { %>
    <div class="section-title">Admin</div>
    <div class="cards">
      <a class="card card--admin" href="${pageContext.request.contextPath}/admin/users">
        <div class="card__icon">👥</div>
        <div class="card__title">Manage Users</div>
        <div class="card__desc">View, activate, or deactivate user accounts.</div>
      </a>
      <a class="card card--admin" href="${pageContext.request.contextPath}/admin/products">
        <div class="card__icon">🌾</div>
        <div class="card__title">Manage Products</div>
        <div class="card__desc">Add or remove agricultural commodities.</div>
      </a>
      <a class="card card--admin" href="${pageContext.request.contextPath}/admin/markets">
        <div class="card__icon">🏪</div>
        <div class="card__title">Manage Markets</div>
        <div class="card__desc">Add or update market locations.</div>
      </a>
      <a class="card card--admin" href="${pageContext.request.contextPath}/admin/categories">
        <div class="card__icon">🗂️</div>
        <div class="card__title">Categories</div>
        <div class="card__desc">Manage product categories.</div>
      </a>
      <a class="card card--admin" href="${pageContext.request.contextPath}/admin/regions">
        <div class="card__icon">🗺️</div>
        <div class="card__title">Regions</div>
        <div class="card__desc">Manage county and regional data.</div>
      </a>
    </div>
    <% } %>

  </main>

  <footer class="footer">
    &copy; 2026 AgriPrice KE &mdash; Agricultural Market Price Intelligence
  </footer>

</body>
</html>
