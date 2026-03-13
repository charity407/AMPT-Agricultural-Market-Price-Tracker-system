// Mock Data based on your Domain Model requirements
const mockProducts = [
  { id: 1, name: 'Maize (White)', category: 'CEREALS', unit: '90 kg bag', status: 'ACTIVE' },
  { id: 2, name: 'Beans (Rosecoco)', category: 'PULSES', unit: '90 kg bag', status: 'ACTIVE' },
  { id: 3, name: 'Tomatoes', category: 'HORTICULTURE', unit: 'Crate (64kg)', status: 'ACTIVE' },
  { id: 4, name: 'Live Goat', category: 'LIVESTOCK', unit: 'Head', status: 'ACTIVE' }
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
  loadProducts();
  setupProductModal();
});

function loadProducts() {
  const tableBody = document.getElementById('productTableBody');
  tableBody.innerHTML = '';

  mockProducts.forEach(prod => {
    const statusClass = prod.status === 'ACTIVE' ? 'badge--active' : 'badge--inactive';
    
    const row = document.createElement('tr');
    row.innerHTML = `
      <td><strong>${prod.name}</strong></td>
      <td><span class="badge" style="background: var(--c-mist); color: var(--c-ink);">${prod.category}</span></td>
      <td>${prod.unit}</td>
      <td><span class="badge ${statusClass}">${prod.status}</span></td>
      <td class="align-right">
        <button class="btn btn--sm btn--secondary" onclick="editProduct(${prod.id})">Edit</button>
      </td>
    `;
    tableBody.appendChild(row);
  });
}

function setupProductModal() {
  const backdrop = document.getElementById('modalBackdrop');
  const closeBtn = document.getElementById('modalClose');
  const cancelBtn = document.getElementById('modalCancel');
  const addBtn = document.getElementById('addProductBtn');

  const hideModal = () => backdrop.hidden = true;

  closeBtn.addEventListener('click', hideModal);
  cancelBtn.addEventListener('click', hideModal);

  addBtn.addEventListener('click', () => {
    document.getElementById('modalTitle').textContent = 'Add New Commodity';
    document.getElementById('modalBody').innerHTML = `
      <form style="display: flex; flex-direction: column; gap: 1rem;">
        <div>
          <label class="form-label">Product Name (e.g., Maize)</label>
          <input type="text" class="form-input" required>
        </div>
        <div>
          <label class="form-label">Category</label>
          <select class="form-select">
            <option>CEREALS</option>
            <option>PULSES</option>
            <option>HORTICULTURE</option>
            <option>LIVESTOCK</option>
          </select>
        </div>
        <div>
          <label class="form-label">Standard Unit</label>
          <input type="text" class="form-input" placeholder="e.g., 90 kg bag, Head, kg" required>
        </div>
      </form>
    `;
    backdrop.hidden = false;
  });
}

function editProduct(id) {
  alert(`This will open the edit modal for product ID: ${id} when the Java backend is ready.`);
}