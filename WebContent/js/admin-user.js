// Security Check: Kick non-admins out immediately
const currentUserRole = sessionStorage.getItem('userRole') || 'GUEST';
if (currentUserRole !== 'ADMIN') {
  alert('Access Denied: Administrator privileges required.');
  window.location.href = '../dashboard.jsp';
}

// Mock User Data
const mockUsers = [
  { id: 1, name: 'Charity Wanjiku', email: 'admin@agromarket.ke', role: 'ADMIN', region: 'All', status: 'ACTIVE', joined: '2026-01-10' },
  { id: 2, name: 'Jason Mageto', email: 'jason.m@example.com', role: 'MARKET_AGENT', region: 'Nairobi', status: 'ACTIVE', joined: '2026-02-15' },
  { id: 3, name: 'Lewis Njega', email: 'lewis.n@example.com', role: 'FARMER', region: 'Rift Valley', status: 'PENDING', joined: '2026-03-01' },
  { id: 4, name: 'Lucy Ann', email: 'lucy@example.com', role: 'TRADER', region: 'Coast', status: 'INACTIVE', joined: '2026-02-28' }
];

document.addEventListener('DOMContentLoaded', () => {
  loadUsers();
  setupUserModal();
});

function loadUsers() {
  const tableBody = document.getElementById('userTableBody');
  if (!tableBody) return;
  tableBody.innerHTML = '';

  mockUsers.forEach(user => {
    const roleClass = `badge--${user.role.toLowerCase().replace('_', '-')}`;
    const statusClass = `badge--${user.status.toLowerCase()}`;
    
    const toggleBtn = user.status === 'ACTIVE' 
      ? `<button class="btn btn--sm btn--danger" onclick="toggleStatus(${user.id}, 'deactivate')">Deactivate</button>`
      : `<button class="btn btn--sm btn--primary" onclick="toggleStatus(${user.id}, 'activate')">Activate</button>`;

    const row = document.createElement('tr');
    row.innerHTML = `
      <td><strong>${user.name}</strong></td>
      <td>${user.email}</td>
      <td><span class="badge ${roleClass}">${user.role}</span></td>
      <td>${user.region}</td>
      <td><span class="badge ${statusClass}">${user.status}</span></td>
      <td>${user.joined}</td>
      <td class="align-right" style="white-space: nowrap;">
        <button class="btn btn--sm btn--secondary" onclick="editUser(${user.id})">Edit</button>
        ${toggleBtn}
      </td>
    `;
    tableBody.appendChild(row);
  });
}

function setupUserModal() {
  const backdrop = document.getElementById('modalBackdrop');
  const closeBtn = document.getElementById('modalClose');
  const cancelBtn = document.getElementById('modalCancel');
  const addBtn = document.getElementById('addUserBtn');

  const hideModal = () => backdrop.hidden = true;
  if(closeBtn) closeBtn.addEventListener('click', hideModal);
  if(cancelBtn) cancelBtn.addEventListener('click', hideModal);

  if(addBtn) {
    addBtn.addEventListener('click', () => {
      document.getElementById('modalTitle').textContent = 'Add New User';
      document.getElementById('modalBody').innerHTML = `
        <form style="display: flex; flex-direction: column; gap: 1rem;">
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
      `;
      backdrop.hidden = false;
    });
  }
}

function editUser(id) {
  alert(`Will open edit modal for User ID: ${id} when backend is connected.`);
}

function toggleStatus(id, action) {
  alert(`Simulating API call to ${action} User ID: ${id}`);
}