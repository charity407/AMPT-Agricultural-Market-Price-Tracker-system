<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Price List — AgriPrice KE</title>
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
        <li><a href="${pageContext.request.contextPath}/prices/list" class="navbar__link is-active">Prices</a></li>
        <li><a href="${pageContext.request.contextPath}/prices/compare" class="navbar__link">Compare</a></li>
        <li><a href="${pageContext.request.contextPath}/prices/trends" class="navbar__link">Trends</a></li>
        <li><a href="${pageContext.request.contextPath}/alerts" class="navbar__link">Alerts</a></li>
        <li><a href="${pageContext.request.contextPath}/reports" class="navbar__link">Reports</a></li>
        <li><a href="${pageContext.request.contextPath}/logout" class="navbar__link">Sign Out</a></li>
      </ul>
    </nav>
  </header>

  <main class="layout" style="display: block; max-width: 70rem; margin-top: var(--sp-6);">

    <!-- Filter Form -->
    <section class="content-section" style="margin-bottom: 1.25rem; padding: var(--sp-4) var(--sp-6);">
      <form method="get" style="display: flex; flex-wrap: wrap; gap: 1rem; align-items: flex-end;">
        <div>
          <label class="form-label">Product</label>
          <input type="text" name="cropName" class="form-input" style="width: 160px;"
            placeholder="e.g. Maize" value="${param.cropName}" />
        </div>
        <div>
          <label class="form-label">Market</label>
          <input type="text" name="market" class="form-input" style="width: 160px;"
            placeholder="e.g. Nairobi" value="${param.market}" />
        </div>
        <div>
          <label class="form-label">Region</label>
          <input type="text" name="region" class="form-input" style="width: 140px;"
            placeholder="e.g. Central" value="${param.region}" />
        </div>
        <div>
          <label class="form-label">From Date</label>
          <input type="date" name="fromDate" class="form-input" style="width: 155px;"
            value="${param.fromDate}" />
        </div>
        <div>
          <label class="form-label">To Date</label>
          <input type="date" name="toDate" class="form-input" style="width: 155px;"
            value="${param.toDate}" />
        </div>
        <div style="display: flex; gap: 0.5rem;">
          <button type="submit" class="btn btn--primary">Filter</button>
          <a href="${pageContext.request.contextPath}/prices/list" class="btn btn--ghost">Clear</a>
        </div>
      </form>
    </section>

    <!-- Price Table -->
    <section class="content-section">
      <div class="section-header">
        <div>
          <h1 class="section-header__title">Price List</h1>
          <p class="section-header__sub">Current market prices across Kenya</p>
        </div>
        <a href="${pageContext.request.contextPath}/prices/entry" class="btn btn--primary">+ New Entry</a>
      </div>

      <c:if test="${not empty param.success}">
        <div class="alert alert--success">&#10003; ${param.success}</div>
      </c:if>
      <c:if test="${not empty param.error}">
        <div class="alert alert--error">&#10007; ${param.error}</div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert--error">&#10007; ${error}</div>
      </c:if>

      <div class="table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th scope="col">Product</th>
              <th scope="col" style="text-align: right;">Unit Price (KES)</th>
              <th scope="col">Market</th>
              <th scope="col">Region</th>
              <th scope="col">Date</th>
              <th scope="col" class="align-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty priceList}">
                <c:forEach var="row" items="${priceList}">
                  <tr>
                    <td><strong>${row[1]}</strong></td>
                    <td style="text-align: right; font-family: monospace; font-weight: 600;">
                      ${row[2]}
                    </td>
                    <td>${row[3]}</td>
                    <td>
                      <span class="badge" style="background: var(--c-mist); color: var(--c-ink);">${row[4]}</span>
                    </td>
                    <td style="color: var(--c-ink-3);">${row[5]}</td>
                    <td class="align-right">
                      <a href="${pageContext.request.contextPath}/prices/edit?id=${row[0]}"
                         class="btn btn--sm btn--secondary">Edit</a>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="6" style="text-align: center; padding: 2.5rem; color: var(--c-ink-3);">
                    No price entries found. <a href="${pageContext.request.contextPath}/prices/entry">Add the first one.</a>
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>

      <div style="margin-top: 1rem; display: flex; gap: 1rem;">
        <a href="${pageContext.request.contextPath}/prices/compare" class="btn btn--ghost btn--sm">⚖ Compare Prices</a>
        <a href="${pageContext.request.contextPath}/prices/trends" class="btn btn--ghost btn--sm">📈 View Trends</a>
      </div>
    </section>
  </main>

  <footer class="site-footer">
    <p>© <span id="footerYear">2026</span> AgriPrice KE — Agricultural Market Price Intelligence</p>
    <p class="site-footer__status">Status: <span class="status-dot status-dot--ok">●</span> Online</p>
  </footer>

  <script>document.getElementById('footerYear').textContent = new Date().getFullYear();</script>
</body>
</html>
