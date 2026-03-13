// Mock Data based on your Kenya-specific market sources
const mockMarkets = [
  { id: 1, name: 'Wakulima Market', town: 'Nairobi', region: 'Central Kenya', days: 'Mon-Sat', status: 'ACTIVE' },
  { id: 2, name: 'Gikomba Market', town: 'Nairobi', region: 'Central Kenya', days: 'Mon-Sun', status: 'ACTIVE' },
  { id: 3, name: 'Mombasa Central', town: 'Mombasa', region: 'Coastal Kenya', days: 'Mon-Sat', status: 'ACTIVE' },
  { id: 4, name: 'Kisumu Main', town: 'Kisumu', region: 'Western Kenya', days: 'Mon-Sat', status: 'INACTIVE' },
  { id: 5, name: 'Nakuru Wholesale', town: 'Nakuru', region: 'Rift Valley', days: 'Mon-Fri', status: 'ACTIVE' }
];
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
  loadMarkets();
  setupMarketModal();
});

function loadMarkets() {
  const tableBody = document.getElementById('marketTableBody');
  tableBody.innerHTML = '';

  mockMarkets.forEach(market => {
    const statusClass = market.status === 'ACTIVE' ? 'badge--active' : 'badge--inactive';
    
    const row = document.createElement('tr');
    row.innerHTML = `
      <td><strong>${market.name}</strong></td>
      <td>${market.town}</td>
      <td><span class="badge" style="background: var(--c-mist); color: var(--c-ink);">${market.region}</span></td>
      <td>${market.days}</td>
      <td><span class="badge ${statusClass}">${market.status}</span></td>
      <td class="align-right">
        <button class="btn btn--sm btn--secondary" onclick="editMarket(${market.id})">Edit</button>
      </td>
    `;
    tableBody.appendChild(row);
  });
}

function setupMarketModal() {
  const backdrop = document.getElementById('modalBackdrop');
  const closeBtn = document.getElementById('modalClose');
  const cancelBtn = document.getElementById('modalCancel');
  const addBtn = document.getElementById('addMarketBtn');

  const hideModal = () => backdrop.hidden = true;

  closeBtn.addEventListener('click', hideModal);
  cancelBtn.addEventListener('click', hideModal);

  addBtn.addEventListener('click', () => {
    document.getElementById('modalTitle').textContent = 'Register New Market';
    document.getElementById('modalBody').innerHTML = `
      <form style="display: flex; flex-direction: column; gap: 1rem;">
        <div>
          <label class="form-label">Market Name</label>
          <input type="text" class="form-input" placeholder="e.g., Kangundo Road Market" required>
        </div>
        <div>
          <label class="form-label">Town/City</label>
          <input type="text" class="form-input" required>
        </div>
        <div>
          <label class="form-label">Geographic Region</label>
          <select class="form-select">
            <option>Central Kenya</option>
            <option>Rift Valley</option>
            <option>Western Kenya</option>
            <option>Eastern Kenya</option>
            <option>Coastal Kenya</option>
          </select>
        </div>
        <div>
          <label class="form-label">Operating Days</label>
          <input type="text" class="form-input" placeholder="e.g., Mon-Sat" required>
        </div>
      </form>
    `;
    backdrop.hidden = false;
  });
}

function editMarket(id) {
  alert(`This will open the edit modal for market ID: ${id} when connected to the backend.`);
}