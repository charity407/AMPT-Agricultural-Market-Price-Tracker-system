<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Enter Price — AgriPrice KE</title>
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
        <li><a href="${pageContext.request.contextPath}/prices/entry" class="navbar__link is-active">New Entry</a></li>
        <li><a href="${pageContext.request.contextPath}/alerts" class="navbar__link">Alerts</a></li>
        <li><a href="${pageContext.request.contextPath}/logout" class="navbar__link">Sign Out</a></li>
      </ul>
    </nav>
  </header>

  <main class="layout" style="display: block; max-width: 38rem; margin-top: var(--sp-6);">
    <section class="content-section">
      <div class="section-header">
        <div>
          <h1 class="section-header__title">Enter Price</h1>
          <p class="section-header__sub">Record today's market price for a product</p>
        </div>
      </div>

      <c:if test="${not empty error}">
        <div class="alert alert--error">&#10007; ${error}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/prices/entry" method="post"
            style="display: flex; flex-direction: column; gap: 1.1rem;">

        <div>
          <label class="form-label" for="productId">Product</label>
          <select id="productId" name="productId" class="form-select" required>
            <option value="">— Select a product —</option>
            <c:choose>
              <c:when test="${not empty products}">
                <c:forEach var="p" items="${products}">
                  <option value="${p[0]}">${p[1]}</option>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <option value="" disabled>No products loaded</option>
              </c:otherwise>
            </c:choose>
          </select>
        </div>

        <div>
          <label class="form-label" for="marketId">Market</label>
          <select id="marketId" name="marketId" class="form-select" required>
            <option value="">— Select a market —</option>
            <c:choose>
              <c:when test="${not empty markets}">
                <c:forEach var="m" items="${markets}">
                  <option value="${m[0]}">${m[1]}</option>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <option value="" disabled>No markets loaded</option>
              </c:otherwise>
            </c:choose>
          </select>
        </div>

        <div>
          <label class="form-label" for="price">Unit Price (KES)</label>
          <input type="number" id="price" name="price" class="form-input"
            step="0.01" min="0" placeholder="e.g. 4500.00" required />
        </div>

        <div>
          <label class="form-label" for="priceDate">Date</label>
          <input type="date" id="priceDate" name="priceDate" class="form-input" required />
        </div>

        <div style="display: flex; gap: 0.75rem; justify-content: flex-end; padding-top: 0.5rem;
                    border-top: 1px solid var(--c-border); margin-top: 0.5rem;">
          <a href="${pageContext.request.contextPath}/prices/list" class="btn btn--ghost">Cancel</a>
          <button type="submit" class="btn btn--primary">Save Price</button>
        </div>
      </form>
    </section>
  </main>

  <footer class="site-footer">
    <p>© <span id="footerYear">2026</span> AgriPrice KE — Agricultural Market Price Intelligence</p>
    <p class="site-footer__status">Status: <span class="status-dot status-dot--ok">●</span> Online</p>
  </footer>

  <script>
    document.getElementById('footerYear').textContent = new Date().getFullYear();
    // Default date to today
    const dateInput = document.getElementById('priceDate');
    if (!dateInput.value) {
      dateInput.value = new Date().toISOString().split('T')[0];
    }
  </script>
</body>
</html>
