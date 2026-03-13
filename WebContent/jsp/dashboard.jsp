<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="description" content="Agricultural Market Price Tracker — Real-time crop and commodity prices" />
  <title>AgroMarket — Price Tracker</title>
  <link rel="stylesheet" href="style.css" />
  <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=IBM+Plex+Mono:wght@400;600&family=Source+Serif+4:ital,wght@0,300;0,400;0,600;1,300&display=swap" rel="stylesheet" />
  <style>
    /* Quick inline CSS to make the sidebar collapse work */
    .sidebar { transition: width 0.3s ease, padding 0.3s ease; overflow: hidden; }
    .sidebar.is-collapsed { width: 0; padding-left: 0; padding-right: 0; border: none; opacity: 0; }
  </style>
</head>
<body>

  <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>AgroMarket — Price Tracker</title>
  <link rel="stylesheet" href="../css/style.css" />
</head>
<body>

  <jsp:include page="navbar.jsp" />

  <main class="layout" id="mainContent">
    ```
*You must do this exact same replacement for `admin/users.jsp`, `admin/products.jsp`, and `admin/markets.jsp`.*

### Step 3: Create `error.jsp`
Your M5 task list explicitly makes you responsible for `error.jsp`. If the Java backend crashes, or someone tries to visit a page that doesn't exist, the server needs a clean, branded page to show them instead of a raw stack trace.

Create `error.jsp` in the `jsp/` folder and paste this code:

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" isErrorPage="true" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>System Error — AgroMarket</title>
  <link rel="stylesheet" href="../css/style.css" />
  <style>
    .error-layout { display: flex; align-items: center; justify-content: center; min-height: 100dvh; background: var(--c-surface-alt); text-align: center; padding: var(--sp-4); }
    .error-card { background: var(--c-white); padding: var(--sp-8); border-radius: var(--radius-lg); box-shadow: var(--shadow-lg); border-top: 4px solid var(--c-danger); max-width: 30rem; }
  </style>
</head>
<body class="error-layout">
  <div class="error-card">
    <h1 style="color: var(--c-danger); margin-bottom: var(--sp-2);">⚠️ System Error</h1>
    <p style="margin-bottom: var(--sp-4); color: var(--c-text-muted);">We encountered an unexpected problem while processing your request.</p>
    
    <div style="background: var(--c-mist); padding: var(--sp-3); border-radius: var(--radius-sm); margin-bottom: var(--sp-6); font-family: var(--f-mono); font-size: var(--fs-sm); text-align: left; overflow-x: auto;">
      <strong>Error Details:</strong> <br>
      <%= exception != null ? exception.getMessage() : "Unknown Server Error. Please contact an Administrator." %>
    </div>
    
    <a href="dashboard.jsp" class="btn btn--primary">Return to Dashboard</a>
  </div>
</body>
</html>

  <main class="layout" id="mainContent">

    <button class="btn btn--secondary" id="sidebarToggleBtn" type="button" aria-label="Toggle Filters" 
            style="position: absolute; left: var(--sp-4); z-index: 10; padding: 0.25rem 0.5rem; font-size: 1.2rem; margin-top: -0.5rem;">
      «
    </button>

    <aside class="sidebar" id="mainSidebar" aria-label="Filters and quick stats">
      <section class="sidebar__block">
        <h2 class="sidebar__heading">Market Filters</h2>
        <label class="form-label" for="regionSelect">Region</label>
        <select class="form-select" id="regionSelect" name="region">
          <option value="">All Regions</option>
        </select>

        <label class="form-label" for="commoditySelect">Commodity</label>
        <select class="form-select" id="commoditySelect" name="commodity">
          <option value="">All Commodities</option>
        </select>

        <button class="btn btn--primary btn--full" id="applyFilters" type="button" style="margin-top: 1rem;">Apply Filters</button>
      </section>

      <section class="sidebar__block">
        <h2 class="sidebar__heading">Quick Stats</h2>
        <ul class="stat-list" id="quickStats" aria-live="polite">
          <li class="stat-list__item">
            <span class="stat-list__label">Markets Active</span>
            <span class="stat-list__value" data-stat="activeMarkets">—</span>
          </li>
          <li class="stat-list__item">
            <span class="stat-list__label">Commodities</span>
            <span class="stat-list__value" data-stat="totalCommodities">—</span>
          </li>
        </ul>
      </section>
    </aside>

    <div class="content-area">

      <section class="content-section" id="dashboard">
        <div class="section-header">
          <div>
            <h1 class="section-header__title" id="dashboardHeading">Market Dashboard</h1>
            <p class="section-header__sub" id="dashboardDateLine">Loading latest data…</p>
          </div>
        </div>

        <div id="adminQuickLinks" class="alert-strip" style="display: flex; gap: var(--sp-3); align-items: center; background: var(--c-surface-alt); border-color: var(--c-border); margin-bottom: var(--sp-6);">
          <strong style="color: var(--c-field);">Admin Quick Links:</strong>
          <a href="products.html" class="btn btn--sm btn--secondary">Manage Products</a>
          <a href="markets.html" class="btn btn--sm btn--secondary">Manage Markets</a>
        </div>

      </section>

      <section class="content-section" id="prices">
        <div class="section-header">
          <div>
            <h2 class="section-header__title">Live Price Board</h2>
            <p class="section-header__sub">All prices shown in KES per kg unless stated</p>
          </div>
          <div class="table-toolbar">
            <button class="btn btn--secondary" id="refreshDashboard" type="button">↻ Refresh Data</button>
          </div>
        </div>

        <div class="table-state" id="priceTableLoading">
          <div class="skeleton-row"></div><div class="skeleton-row"></div><div class="skeleton-row"></div>
        </div>

        <div class="table-wrap" id="priceTableWrap" hidden>
          <table class="data-table" id="priceTable">
            <thead>
              <tr>
                <th scope="col">Commodity</th>
                <th scope="col">Market</th>
                <th scope="col">Region</th>
                <th scope="col" class="align-right">Price (KES)</th>
                <th scope="col" class="align-right">7d Change</th>
                <th scope="col">Updated</th>
                <th scope="col">Source</th>
              </tr>
            </thead>
            <tbody id="priceTableBody">
              </tbody>
          </table>
        </div>
      </section>

    

    </div></main>

  <div class="modal-backdrop" id="modalBackdrop" hidden>
    <div class="modal">
      <div class="modal__header">
        <h3 class="modal__title" id="modalTitle">Modal</h3>
        <button class="modal__close" id="modalClose">✕</button>
      </div>
      <div class="modal__body" id="modalBody"></div>
      <div class="modal__footer" id="modalFooter">
        <button class="btn btn--ghost" id="modalCancel">Cancel</button>
        <button class="btn btn--primary" id="modalConfirm">Confirm</button>
      </div>
    </div>
  </div>

  <div class="toast-container" id="toastContainer"></div>

  <footer class="site-footer">
    <p>© <span id="footerYear"></span> AgroMarket Price Intelligence</p>
    <p class="site-footer__status">API Status: <span class="status-dot status-dot--ok">●</span></p>
  </footer>

  <script src="main.js" defer></script>
  
  <script>
    document.addEventListener('DOMContentLoaded', () => {
      const sidebar = document.getElementById('mainSidebar');
      const toggleBtn = document.getElementById('sidebarToggleBtn');

      if(toggleBtn && sidebar) {
        toggleBtn.addEventListener('click', () => {
          const isCollapsed = sidebar.classList.toggle('is-collapsed');
          
          // Change the icon based on the state
          toggleBtn.textContent = isCollapsed ? '»' : '«';
          
          // Move the button slightly when collapsed so it stays visible
          toggleBtn.style.left = isCollapsed ? '0' : 'var(--sp-4)';
        });
      }
    });
  </script>
</body>
</html>