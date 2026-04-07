<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Compare Prices — AgriPrice KE</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=IBM+Plex+Mono:wght@400;600&family=Source+Serif+4:ital,wght@0,300;0,400;0,600;1,300&display=swap" rel="stylesheet" />
</head>
<body>

  <header class="site-header" role="banner">
    <nav class="navbar">
      <div class="navbar__brand">
        <span class="navbar__logo">⬡</span>
        <span class="navbar__name">AgriPrice KE</span>
        <span class="navbar__tagline">Market Price Tracker</span>
      </div>
      <ul class="navbar__menu is-open" style="flex-direction: row; background: transparent; order: 0;">
        <li><a href="${pageContext.request.contextPath}/dashboard.jsp" class="navbar__link">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/prices/list" class="navbar__link">Prices</a></li>
        <li><a href="${pageContext.request.contextPath}/prices/compare" class="navbar__link is-active">Compare</a></li>
        <li><a href="${pageContext.request.contextPath}/prices/trends" class="navbar__link">Trends</a></li>
        <li><a href="${pageContext.request.contextPath}/alerts" class="navbar__link">Alerts</a></li>
        <li><a href="${pageContext.request.contextPath}/logout" class="navbar__link">Sign Out</a></li>
      </ul>
    </nav>
  </header>

  <main class="layout" style="display: block; max-width: 52rem; margin-top: var(--sp-6);">

    <!-- Selection Form -->
    <section class="content-section" style="margin-bottom: 1.25rem;">
      <div class="section-header">
        <div>
          <h1 class="section-header__title">Compare Prices</h1>
          <p class="section-header__sub">Select a product and markets to compare latest prices</p>
        </div>
      </div>

      <form method="get" action="${pageContext.request.contextPath}/prices/compare"
            style="display: flex; flex-wrap: wrap; gap: 1rem; align-items: flex-end;">
        <div>
          <label class="form-label" for="productId">Product</label>
          <select id="productId" name="productId" class="form-select" style="min-width: 200px;" required>
            <option value="">— Select product —</option>
            <c:forEach var="p" items="${products}">
              <option value="${p[0]}" ${param.productId == p[0] ? 'selected' : ''}>${p[1]}</option>
            </c:forEach>
          </select>
        </div>

        <div>
          <label class="form-label" for="marketIds">Markets <span style="font-weight:400;color:var(--c-ink-3);">(hold Ctrl/⌘ to select multiple)</span></label>
          <select id="marketIds" name="marketIds" class="form-select" style="min-width: 220px; height: 7rem;" multiple required>
            <c:forEach var="m" items="${markets}">
              <option value="${m[0]}">${m[1]}</option>
            </c:forEach>
          </select>
        </div>

        <div>
          <button type="submit" class="btn btn--primary">Compare</button>
        </div>
      </form>

      <script>
        // Convert multi-select to comma-separated value on submit
        document.querySelector('form').addEventListener('submit', function(e) {
          e.preventDefault();
          const sel = document.getElementById('marketIds');
          const selected = Array.from(sel.selectedOptions).map(o => o.value);
          if (!selected.length) { alert('Please select at least one market.'); return; }
          const productId = document.getElementById('productId').value;
          if (!productId) { alert('Please select a product.'); return; }
          const base = this.action;
          window.location.href = base + '?productId=' + encodeURIComponent(productId) + '&marketIds=' + encodeURIComponent(selected.join(','));
        });
      </script>
    </section>

    <!-- Results Table -->
    <c:if test="${not empty comparisonData}">
      <section class="content-section">
        <div class="section-header">
          <div>
            <h2 class="section-header__title" style="font-size: 1.15rem;">Comparison Results</h2>
            <p class="section-header__sub">Latest recorded price per market</p>
          </div>
        </div>

        <c:if test="${not empty error}">
          <div class="alert alert--error">&#10007; ${error}</div>
        </c:if>

        <div class="table-wrap">
          <table class="data-table">
            <thead>
              <tr>
                <th scope="col">Market</th>
                <th scope="col" style="text-align: right;">Unit Price (KES)</th>
                <th scope="col">Date</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="item" items="${comparisonData}">
                <tr>
                  <td><strong>${item[0]}</strong></td>
                  <td style="text-align: right; font-family: monospace; font-weight: 600;">${item[1]}</td>
                  <td style="color: var(--c-ink-3);">${item[2]}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </section>
    </c:if>

  </main>

  <footer class="site-footer">
    <p>© <span id="footerYear">2026</span> AgriPrice KE — Agricultural Market Price Intelligence</p>
    <p class="site-footer__status">Status: <span class="status-dot status-dot--ok">●</span> Online</p>
  </footer>

  <script>document.getElementById('footerYear').textContent = new Date().getFullYear();</script>
</body>
</html>
