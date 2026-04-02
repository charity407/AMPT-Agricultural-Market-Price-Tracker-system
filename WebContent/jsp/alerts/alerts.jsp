<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Price Alerts — AgriPrice KE</title>
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
        <li><a href="${pageContext.request.contextPath}/alerts" class="navbar__link is-active">My Alerts</a></li>
        <li><a href="${pageContext.request.contextPath}/reports" class="navbar__link">Reports</a></li>
        <li><a href="${pageContext.request.contextPath}/profile" class="navbar__link">Profile</a></li>
      </ul>
    </nav>
  </header>

  <main class="layout" style="display: block; max-width: 65rem; margin-top: var(--sp-6);">
    <section class="content-section">
      <div class="section-header">
        <div>
          <h1 class="section-header__title">Price Alerts</h1>
          <p class="section-header__sub">Get notified when prices cross your threshold</p>
        </div>
        <button class="btn btn--primary" id="addAlertBtn" type="button">+ New Alert</button>
      </div>

      <c:if test="${not empty param.success}">
        <div style="background:#d4edda;color:#155724;padding:1rem;margin-bottom:1rem;border-radius:4px;">
          ✓ ${param.success}
        </div>
      </c:if>
      <c:if test="${not empty param.error}">
        <div style="background:#f8d7da;color:#721c24;padding:1rem;margin-bottom:1rem;border-radius:4px;">
          ✗ ${param.error}
        </div>
      </c:if>
      <c:if test="${not empty error}">
        <div style="background:#f8d7da;color:#721c24;padding:1rem;margin-bottom:1rem;border-radius:4px;">
          ✗ ${error}
        </div>
      </c:if>

      <div class="table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th scope="col">Product</th>
              <th scope="col">Market</th>
              <th scope="col">Threshold (KES)</th>
              <th scope="col">Direction</th>
              <th scope="col">Created</th>
              <th scope="col" class="align-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty alerts}">
                <c:forEach var="alert" items="${alerts}">
                  <tr>
                    <td><strong>${alert.productName}</strong></td>
                    <td>${alert.marketName}</td>
                    <td>
                      <span style="font-family: monospace; font-weight: 600;">
                        KES <c:out value="${alert.thresholdPrice}" />
                      </span>
                    </td>
                    <td>
                      <span class="badge"
                        style="background:${alert.alertDirection == 'above' ? '#fff3cd' : '#d4edda'};
                               color:${alert.alertDirection == 'above' ? '#856404' : '#155724'};">
                        ${alert.alertDirection == 'above' ? '↑ Above' : '↓ Below'}
                      </span>
                    </td>
                    <td style="color:#666;">${alert.createdDate}</td>
                    <td class="align-right">
                      <form method="post" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="alertId" value="${alert.alertId}">
                        <button type="submit" class="btn btn--sm btn--ghost"
                          onclick="return confirm('Delete this alert?')">Delete</button>
                      </form>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="6" style="text-align:center;padding:2rem;color:#999;">
                    No active alerts — create one to get started
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </section>
  </main>

  <!-- Create Alert Modal -->
  <div class="modal-backdrop" id="modalBackdrop" hidden>
    <div class="modal">
      <div class="modal__header">
        <h3 class="modal__title">Create Price Alert</h3>
        <button class="modal__close" id="modalClose">✕</button>
      </div>
      <form method="post" class="modal__body" style="display:flex;flex-direction:column;gap:1rem;">
        <input type="hidden" name="action" value="create">
        <div>
          <label class="form-label">Product</label>
          <select name="productId" class="form-select" required>
            <option value="">Select a product</option>
            <c:forEach var="p" items="${products}">
              <option value="${p.productId}">${p.productName}</option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label class="form-label">Market</label>
          <select name="marketId" class="form-select" required>
            <option value="">Select a market</option>
            <c:forEach var="m" items="${markets}">
              <option value="${m.marketId}">${m.marketName}</option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label class="form-label">Threshold Price (KES)</label>
          <input type="number" name="thresholdPrice" class="form-input"
            step="0.01" min="0" placeholder="e.g. 5000" required>
        </div>
        <div>
          <label class="form-label">Alert When Price Is</label>
          <select name="alertDirection" class="form-select" required>
            <option value="above">↑ Above threshold</option>
            <option value="below">↓ Below threshold</option>
          </select>
        </div>
        <div class="modal__footer">
          <button type="button" class="btn btn--ghost" id="modalCancel">Cancel</button>
          <button type="submit" class="btn btn--primary">Create Alert</button>
        </div>
      </form>
    </div>
  </div>

  <footer class="site-footer">
    <p>© <span id="footerYear">2026</span> AgroMarket Price Intelligence</p>
    <p class="site-footer__status">API Status: <span class="status-dot status-dot--ok">●</span></p>
  </footer>

  <script>
    document.getElementById('footerYear').textContent = new Date().getFullYear();
    const backdrop = document.getElementById('modalBackdrop');
    document.getElementById('addAlertBtn').addEventListener('click', () => backdrop.hidden = false);
    document.getElementById('modalClose').addEventListener('click', () => backdrop.hidden = true);
    document.getElementById('modalCancel').addEventListener('click', () => backdrop.hidden = true);
  </script>
</body>
</html>
