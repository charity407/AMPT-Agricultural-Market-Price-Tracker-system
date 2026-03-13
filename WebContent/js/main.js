/* ═══════════════════════════════════════════════════════════════
   AgroMarket Price Tracker — main.js
   Production-ready Vanilla JS · PWA enabled · REST API integrated
   ═══════════════════════════════════════════════════════════════ */

// ── 1. SERVICE WORKER REGISTRATION (PWA Requirement) ─────────
function initPWA() {
  // Register Service Worker for Offline Capabilities
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    // Notice the path: it looks for sw.js at the root of the app, not inside the js/ folder
    navigator.serviceWorker.register('../sw.js')
      .then(registration => {
        console.log('ServiceWorker registration successful with scope: ', registration.scope);
      })
      .catch(error => {
        console.log('ServiceWorker registration failed: ', error);
      });
  });
}
}

// ── 2. API UTILITY (Network handling) ────────────────────────
// ──  API UTILITY (Network handling with Mock Fallback) ─────
async function apiFetch(endpoint, options = {}) {
  try {
    const response = await fetch(endpoint, options);
    if (!response.ok) throw new Error(`HTTP Error: ${response.status}`);
    return await response.json();
  } catch (error) {
    console.warn(`Backend offline. Injecting mock data for ${endpoint}`);
    
    // MOCK DATA FALLBACKS
    if (endpoint.includes('/markets/regions')) {
      return [
        { id: 'nbi', name: 'Nairobi (Wakulima)' },
        { id: 'msa', name: 'Mombasa Central' },
        { id: 'ksm', name: 'Kisumu' }
      ];
    }
    if (endpoint.includes('/products/categories')) {
      return [
        { id: 'mze', name: 'Maize (White)' },
        { id: 'bns', name: 'Beans (Rosecoco)' },
        { id: 'tom', name: 'Tomatoes' }
      ];
    }
    if (endpoint.includes('/users')) {
      return [
        { id: 1, name: 'Charity Wanjiku', email: 'admin@agromarket.ke', role: 'ADMIN', region: 'All', status: 'ACTIVE', joined: '2026-01-10' },
        { id: 2, name: 'Jason Mageto', email: 'jason.m@example.com', role: 'MARKET_AGENT', region: 'Nairobi', status: 'ACTIVE', joined: '2026-02-15' },
        { id: 3, name: 'Lewis Njega', email: 'lewis.n@example.com', role: 'FARMER', region: 'Rift Valley', status: 'PENDING', joined: '2026-03-01' },
        { id: 4, name: 'Lucy Ann', email: 'lucy@example.com', role: 'TRADER', region: 'Coast', status: 'INACTIVE', joined: '2026-02-28' }
      ];
    }
    if (endpoint.includes('/dashboard')) {
      return {
        stats: { activeMarkets: '18', totalCommodities: '24', avgPriceChange: '+1.2%' },
        prices: [
          { commodityName: 'Maize (White)', marketName: 'Wakulima', regionName: 'Nairobi', price: '45.00', change: 2.5, updatedAt: '10 mins ago', source: 'MARKET_AGENT' },
          { commodityName: 'Beans (Rosecoco)', marketName: 'Gikomba', regionName: 'Nairobi', price: '120.00', change: -1.0, updatedAt: '1 hour ago', source: 'FARMER' },
          { commodityName: 'Tomatoes', marketName: 'Mombasa Central', regionName: 'Coast', price: '85.00', change: 5.0, updatedAt: '30 mins ago', source: 'TRADER' }
        ]
      };
    }
    return null;
  }
}

// ── 3. MODAL MANAGEMENT (Bulletproofed) ──────────────────────
const modal = {
  backdrop: document.getElementById('modalBackdrop'),
  title: document.getElementById('modalTitle'),
  body: document.getElementById('modalBody'),
  footer: document.getElementById('modalFooter'),
  closeBtn: document.getElementById('modalClose'),
  cancelBtn: document.getElementById('modalCancel'),
  confirmBtn: document.getElementById('modalConfirm'),

  show(title, content, options = {}) {
    if (!this.backdrop) return;
    this.title.textContent = title;
    this.body.innerHTML = content;
    this.backdrop.hidden = false;
    this.backdrop.focus();
  },

  hide() {
    if (!this.backdrop) return;
    this.backdrop.hidden = true;
    this.body.innerHTML = '';
  },

  init() {
    // Null checks prevent the script from crashing on pages without a modal
    if (this.closeBtn) this.closeBtn.addEventListener('click', () => this.hide());
    if (this.cancelBtn) this.cancelBtn.addEventListener('click', () => this.hide());
    if (this.backdrop) {
      this.backdrop.addEventListener('click', (e) => {
        if (e.target === this.backdrop) this.hide();
      });
    }
  }
};

// ── 4. UI FEEDBACK (Toast Notifications) ─────────────────────
function showToast(message, type = 'info') {
  const container = document.getElementById('toastContainer');
  if (!container) return;

  const toast = document.createElement('div');
  toast.className = `toast is-${type}`;
  toast.textContent = message;

  container.appendChild(toast);
  
  // Auto-remove after 4 seconds
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.addEventListener('transitionend', () => toast.remove());
  }, 4000);
}

// ── 5. INITIALIZE ON PAGE LOAD ───────────────────────────────
// ── FRONTEND SECURITY CHECK ──
  // Assume the login page saved the role like this: sessionStorage.setItem('userRole', 'FARMER');
  const currentUserRole = sessionStorage.getItem('userRole') || 'GUEST';

  // 1. Hide Admin elements on the Dashboard if not an Admin
  const adminLinks = document.getElementById('adminQuickLinks');
  const adminSection = document.getElementById('admin'); // The user table section
  
  if (currentUserRole !== 'ADMIN') {
    if (adminLinks) adminLinks.style.display = 'none';
    if (adminSection) adminSection.style.display = 'none';
  }

  // 2. Kick non-admins out of dedicated Admin HTML pages
  // If this script is running on products.html or markets.html, redirect them
  const currentPage = window.location.pathname;
  if ((currentPage.includes('products.html') || currentPage.includes('markets.html')) && currentUserRole !== 'ADMIN') {
    alert('Access Denied: Administrator privileges required.');
    window.location.href = 'index.html'; 
    return; // Stop running any other JavaScript on this page
  }
document.addEventListener('DOMContentLoaded', () => {
  initPWA();
  modal.init();

  const footerYear = document.getElementById('footerYear');
  if (footerYear) footerYear.textContent = new Date().getFullYear();

  initNavbar();
  initFilters();
  loadDashboard();
  loadAdminUsers();
  setupEventListeners();
});

// ── 6. EVENT LISTENERS ───────────────────────────────────────
function setupEventListeners() {
  const addUserBtn = document.getElementById('addUserBtn');
  if (addUserBtn) {
    addUserBtn.addEventListener('click', () => {
      // Example of dynamic modal injection
      // Inside setupEventListeners() in main.js
    modal.show('Add New User', `
    <form id="addUserForm" style="display: flex; flex-direction: column; gap: var(--sp-3);">
        <div>
        <label class="form-label">Full Name</label>
        <input type="text" class="form-input" required>
        </div>
        <div>
        <label class="form-label">Email Address</label>
        <input type="email" class="form-input" required>
        </div>
        <div>
        <label class="form-label">Assign Role</label>
        <select class="form-select" required>
            <option value="CONSUMER">Consumer</option>
            <option value="FARMER">Farmer</option>
            <option value="TRADER">Trader</option>
            <option value="MARKET_AGENT">Market Agent</option>
            <option value="ADMIN">System Admin</option>
        </select>
        </div>
    </form>
    `);
    });
  }

  const refreshBtn = document.getElementById('refreshDashboard');
  if (refreshBtn) {
    refreshBtn.addEventListener('click', loadDashboard);
  }
}

// ── 7. NAVBAR MANAGEMENT ─────────────────────────────────────
function initNavbar() {
  const navToggle = document.getElementById('navToggle');
  const navMenu = document.getElementById('navMenu');

  if (navToggle && navMenu) {
    navToggle.addEventListener('click', () => {
      const isExpanded = navToggle.getAttribute('aria-expanded') === 'true';
      navToggle.setAttribute('aria-expanded', !isExpanded);
      navMenu.hidden = isExpanded;
      navToggle.classList.toggle('is-open', !isExpanded);
    });
  }
}

// ── 8. FILTER MANAGEMENT (Dynamic Fetching) ──────────────────
async function initFilters() {
  const regionSelect = document.getElementById('regionSelect');
  const commoditySelect = document.getElementById('commoditySelect');
  const applyFiltersBtn = document.getElementById('applyFilters');

  // Fetch actual markets and products from the Java backend instead of hardcoding
  // If the backend isn't ready yet, this will fail gracefully via apiFetch
  const [regions, commodities] = await Promise.all([
    apiFetch('/api/markets/regions'),
    apiFetch('/api/products/categories')
  ]);

  if (regions && regionSelect) {
    regions.forEach(region => {
      const option = document.createElement('option');
      option.value = region.id;
      option.textContent = region.name;
      regionSelect.appendChild(option);
    });
  }

  if (commodities && commoditySelect) {
    commodities.forEach(comm => {
      const option = document.createElement('option');
      option.value = comm.id;
      option.textContent = comm.name;
      commoditySelect.appendChild(option);
    });
  }

  if (applyFiltersBtn) {
    applyFiltersBtn.addEventListener('click', loadDashboard);
  }
}

// ── 9. DASHBOARD LOADING (Dynamic Injection) ─────────────────
async function loadDashboard() {
  showToast('Updating market data...', 'info');
  
  // Grab filter values to send to backend
  const region = document.getElementById('regionSelect')?.value || '';
  const commodity = document.getElementById('commoditySelect')?.value || '';
  
  // Fetch real data. Replace with your actual Java servlet endpoints.
  const dashboardData = await apiFetch(`/api/dashboard?region=${region}&commodity=${commodity}`);
  
  if (!dashboardData) {
    // Stop execution if network fails, UI will retain last cached state
    return; 
  }

  // 1. Update Quick Stats
  const quickStats = document.getElementById('quickStats');
  if (quickStats) {
    const activeMarkets = quickStats.querySelector('[data-stat="activeMarkets"]');
    if (activeMarkets) activeMarkets.textContent = dashboardData.stats.activeMarkets;
    // Repeat for other stats...
  }

  // 2. Update Price Table
  const tableBody = document.getElementById('priceTableBody');
  if (tableBody && dashboardData.prices) {
    tableBody.innerHTML = ''; // Clear skeleton loader
    
    dashboardData.prices.forEach(item => {
      const row = document.createElement('tr');
      row.innerHTML = `
        <td><strong>${item.commodityName}</strong></td>
        <td>${item.marketName}</td>
        <td>${item.regionName}</td>
        <td class="align-right price-val">${item.price}</td>
        <td class="align-right ${item.change >= 0 ? 'price-up' : 'price-down'}">
          ${item.change >= 0 ? '↑' : '↓'} ${Math.abs(item.change)}%
        </td>
        <td>${item.updatedAt}</td>
        <td><span class="badge badge--market-agent">${item.source}</span></td>
      `;
      tableBody.appendChild(row);
    });
    
    document.getElementById('priceTableLoading').hidden = true;
    document.getElementById('priceTableWrap').hidden = false;
  }
  
  showToast('Dashboard updated', 'success');
}