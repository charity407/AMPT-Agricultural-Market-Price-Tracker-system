<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Edit Price — AgriPrice KE</title>
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
        <li><a href="${pageContext.request.contextPath}/alerts" class="navbar__link">Alerts</a></li>
        <li><a href="${pageContext.request.contextPath}/logout" class="navbar__link">Sign Out</a></li>
      </ul>
    </nav>
  </header>

  <main class="layout" style="display: block; max-width: 38rem; margin-top: var(--sp-6);">
    <section class="content-section">
      <div class="section-header">
        <div>
          <h1 class="section-header__title">Edit Price Entry</h1>
          <p class="section-header__sub">Update the recorded price for this entry</p>
        </div>
      </div>

      <!-- Read-only context info -->
      <div style="background: var(--c-mist); border-radius: var(--radius); padding: 1rem 1.25rem;
                  margin-bottom: 1.5rem; display: flex; gap: 2rem; flex-wrap: wrap;">
        <div>
          <span class="form-label" style="margin-bottom: 0.2rem;">Product</span>
          <p style="font-weight: 600; color: var(--c-ink);">${productName}</p>
        </div>
        <div>
          <span class="form-label" style="margin-bottom: 0.2rem;">Market</span>
          <p style="font-weight: 600; color: var(--c-ink);">${marketName}</p>
        </div>
      </div>

      <form action="${pageContext.request.contextPath}/prices/edit" method="post"
            style="display: flex; flex-direction: column; gap: 1.1rem;">
        <input type="hidden" name="entryId" value="${entryId}" />

        <div>
          <label class="form-label" for="unitPrice">Unit Price (KES)</label>
          <input type="number" id="unitPrice" name="unitPrice" class="form-input"
            step="0.01" min="0" value="${unitPrice}" required />
        </div>

        <div>
          <label class="form-label" for="priceDate">Date</label>
          <input type="date" id="priceDate" name="priceDate" class="form-input"
            value="${priceDate}" required />
        </div>

        <div>
          <label class="form-label" for="notes">Notes <span style="font-weight:400;color:var(--c-ink-3);">(optional)</span></label>
          <textarea id="notes" name="notes" class="form-input" rows="3"
            style="resize: vertical;" placeholder="Any additional notes...">${notes}</textarea>
        </div>

        <div style="display: flex; gap: 0.75rem; justify-content: flex-end; padding-top: 0.5rem;
                    border-top: 1px solid var(--c-border); margin-top: 0.5rem;">
          <a href="${pageContext.request.contextPath}/prices/list" class="btn btn--ghost">Cancel</a>
          <button type="submit" class="btn btn--primary">Save Changes</button>
        </div>
      </form>
    </section>
  </main>

  <footer class="site-footer">
    <p>© <span id="footerYear">2026</span> AgriPrice KE — Agricultural Market Price Intelligence</p>
    <p class="site-footer__status">Status: <span class="status-dot status-dot--ok">●</span> Online</p>
  </footer>

  <script>document.getElementById('footerYear').textContent = new Date().getFullYear();</script>
</body>
</html>
