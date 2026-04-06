<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Price Report — AgriPrice KE</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=IBM+Plex+Mono:wght@400;600&family=Source+Serif+4:ital,wght@0,300;0,400;0,600;1,300&display=swap" rel="stylesheet" />
</head>
<body>

  <header class="site-header" role="banner">
    <nav class="navbar">
      <div class="navbar__brand">
        <span class="navbar__logo">⬡</span>
        <span class="navbar__name">AgroMarket</span>
        <span class="navbar__tagline">Price Intelligence</span>
      </div>
      <ul class="navbar__menu is-open" style="flex-direction: row; background: transparent; order: 0;">
        <li><a href="${pageContext.request.contextPath}/prices/list" class="navbar__link">Prices</a></li>
        <li><a href="${pageContext.request.contextPath}/alerts" class="navbar__link">My Alerts</a></li>
        <li><a href="${pageContext.request.contextPath}/reports" class="navbar__link is-active">Reports</a></li>
        <li><a href="${pageContext.request.contextPath}/profile" class="navbar__link">Profile</a></li>
      </ul>
    </nav>
  </header>

  <main class="layout" style="display:block; max-width:70rem; margin-top:var(--sp-6);">

    <!-- Filter Form -->
    <section class="content-section" style="margin-bottom:1.5rem;">
      <h2 class="section-header__title" style="margin-bottom:1rem;">Price Summary Report</h2>
      <form method="get" style="display:flex; flex-wrap:wrap; gap:1rem; align-items:flex-end;">
        <div>
          <label class="form-label">Product</label>
          <select name="productId" class="form-select" style="min-width:180px;">
            <option value="">All Products</option>
            <c:forEach var="p" items="${products}">
              <option value="${p.productId}"
                ${filterProduct == p.productId.toString() ? 'selected' : ''}>
                ${p.productName}
              </option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label class="form-label">Market</label>
          <select name="marketId" class="form-select" style="min-width:180px;">
            <option value="">All Markets</option>
            <c:forEach var="m" items="${markets}">
              <option value="${m.marketId}"
                ${filterMarket == m.marketId.toString() ? 'selected' : ''}>
                ${m.marketName}
              </option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label class="form-label">From Date</label>
          <input type="date" name="fromDate" class="form-input" value="${filterFrom}" style="width:160px;">
        </div>
        <div>
          <label class="form-label">To Date</label>
          <input type="date" name="toDate" class="form-input" value="${filterTo}" style="width:160px;">
        </div>
        <div style="display:flex; gap:0.5rem;">
          <button type="submit" class="btn btn--primary">Generate</button>
          <a href="${pageContext.request.contextPath}/reports?type=csv&productId=${filterProduct}&marketId=${filterMarket}&fromDate=${filterFrom}&toDate=${filterTo}"
             class="btn btn--secondary">Download CSV</a>
        </div>
      </form>
    </section>

    <c:if test="${not empty error}">
      <div style="background:#f8d7da;color:#721c24;padding:1rem;margin-bottom:1rem;border-radius:4px;">
        ✗ ${error}
      </div>
    </c:if>

    <!-- Summary Table -->
    <section class="content-section">
      <div class="section-header" style="margin-bottom:1rem;">
        <p class="section-header__sub">
          Showing <strong>${summary.size()} result(s)</strong>
          <c:if test="${not empty filterFrom}"> from ${filterFrom}</c:if>
          <c:if test="${not empty filterTo}"> to ${filterTo}</c:if>
        </p>
      </div>

      <div class="table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th scope="col">Product</th>
              <th scope="col">Market</th>
              <th scope="col" style="text-align:right;">Entries</th>
              <th scope="col" style="text-align:right;">Avg Price (KES)</th>
              <th scope="col" style="text-align:right;">Min Price (KES)</th>
              <th scope="col" style="text-align:right;">Max Price (KES)</th>
              <th scope="col">Latest Date</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty summary}">
                <c:forEach var="row" items="${summary}">
                  <tr>
                    <td><strong>${row.productName}</strong></td>
                    <td>${row.marketName}</td>
                    <td style="text-align:right; font-family:monospace;">${row.totalEntries}</td>
                    <td style="text-align:right; font-family:monospace; font-weight:600;">
                      <fmt:formatNumber value="${row.avgPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                    </td>
                    <td style="text-align:right; font-family:monospace; color:#2e7d32;">
                      <fmt:formatNumber value="${row.minPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                    </td>
                    <td style="text-align:right; font-family:monospace; color:#c62828;">
                      <fmt:formatNumber value="${row.maxPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                    </td>
                    <td style="color:#666;">${row.latestDate}</td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="7" style="text-align:center;padding:2rem;color:#999;">
                    No price data found for the selected filters
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </section>
  </main>

  <footer class="site-footer">
    <p>© <span id="footerYear">2026</span> AgroMarket Price Intelligence</p>
    <p class="site-footer__status">API Status: <span class="status-dot status-dot--ok">●</span></p>
  </footer>

  <script>document.getElementById('footerYear').textContent = new Date().getFullYear();</script>
</body>
</html>
