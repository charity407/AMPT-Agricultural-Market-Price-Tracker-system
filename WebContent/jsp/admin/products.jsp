<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Manage Products — AgroMarket Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=IBM+Plex+Mono:wght@400;600&family=Source+Serif+4:ital,wght@0,300;0,400;0,600;1,300&display=swap" rel="stylesheet" />
</head>
<body>

  <header class="site-header" role="banner">
    <nav class="navbar">
      <div class="navbar__brand">
        <span class="navbar__logo">⬡</span>
        <span class="navbar__name">AgroMarket</span>
        <span class="navbar__tagline">Admin Portal</span>
      </div>
      <ul class="navbar__menu is-open" style="flex-direction: row; background: transparent; order: 0;">
        <li><a href="${pageContext.request.contextPath}/" class="navbar__link">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/products" class="navbar__link is-active">Products</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/markets" class="navbar__link">Markets</a></li>
      </ul>
    </nav>
  </header>

  <main class="layout" style="display: block; max-width: 60rem; margin-top: var(--sp-6);">
    <section class="content-section">
      <div class="section-header">
        <div>
          <h1 class="section-header__title">Product Directory</h1>
          <p class="section-header__sub">Manage agricultural commodities, categories, and units</p>
        </div>
        <button class="btn btn--primary" id="addProductBtn" type="button">+ Add Product</button>
      </div>

      <c:if test="${not empty param.success}">
        <div style="background: #d4edda; color: #155724; padding: 1rem; margin-bottom: 1rem; border-radius: 4px;">
          ✓ ${param.success}
        </div>
      </c:if>

      <c:if test="${not empty param.error}">
        <div style="background: #f8d7da; color: #721c24; padding: 1rem; margin-bottom: 1rem; border-radius: 4px;">
          ✗ ${param.error}
        </div>
      </c:if>

      <div class="table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th scope="col">Product Name</th>
              <th scope="col">Category</th>
              <th scope="col">Unit</th>
              <th scope="col">Status</th>
              <th scope="col" class="align-right">Actions</th>
            </tr>
          </thead>
          <tbody id="productTableBody">
            <c:forEach var="prod" items="${productList}">
              <tr>
                <td><strong>${prod[1]}</strong></td>
                <td>${prod[2]}</td>
                <td>${prod[3]}</td>
                <td>
                  <span class="badge" style="background: ${prod[4] ? '#d4edda' : '#f8d7da'}; color: ${prod[4] ? '#155724' : '#721c24'};">
                    ${prod[4] ? 'ACTIVE' : 'INACTIVE'}
                  </span>
                </td>
                <td class="align-right">
                  <form method="post" style="display: inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="productId" value="${prod[0]}">
                    <button type="submit" class="btn btn--sm btn--ghost" onclick="return confirm('Delete this product?')">Delete</button>
                  </form>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </section>
  </main>

  <div class="modal-backdrop" id="modalBackdrop" hidden>
    <div class="modal">
      <div class="modal__header">
        <h3 class="modal__title">Add New Product</h3>
        <button class="modal__close" id="modalClose">✕</button>
      </div>
      <form method="post" class="modal__body">
        <input type="hidden" name="action" value="add">
        <div>
          <label class="form-label">Product Name</label>
          <input type="text" class="form-input" name="productName" required>
        </div>
        <div>
          <label class="form-label">Category</label>
          <select class="form-select" name="categoryId" required>
            <option value="">Select a category</option>
            <option value="1">CEREALS</option>
            <option value="2">PULSES</option>
            <option value="3">HORTICULTURE</option>
            <option value="4">LIVESTOCK</option>
          </select>
        </div>
        <div>
          <label class="form-label">Unit</label>
          <input type="text" class="form-input" name="unit" placeholder="e.g., 90 kg bag" required>
        </div>
        <div class="modal__footer">
          <button type="button" class="btn btn--ghost" id="modalCancel">Cancel</button>
          <button type="submit" class="btn btn--primary">Add Product</button>
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
    const closeBtn = document.getElementById('modalClose');
    const cancelBtn = document.getElementById('modalCancel');
    const addBtn = document.getElementById('addProductBtn');

    const hideModal = () => backdrop.hidden = true;

    closeBtn.addEventListener('click', hideModal);
    cancelBtn.addEventListener('click', hideModal);
    addBtn.addEventListener('click', () => {
      backdrop.hidden = false;
    });
  </script>
</body>
</html>
