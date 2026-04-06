<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Product Categories — AgroMarket Admin</title>
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
        <li><a href="${pageContext.request.contextPath}/admin/products" class="navbar__link">Products</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/categories" class="navbar__link is-active">Categories</a></li>
      </ul>
    </nav>
  </header>

  <main class="layout" style="display: block; max-width: 60rem; margin-top: var(--sp-6);">
    <section class="content-section">
      <div class="section-header">
        <div>
          <h1 class="section-header__title">Product Categories</h1>
          <p class="section-header__sub">Manage product categories used across the system</p>
        </div>
        <button class="btn btn--primary" id="addCategoryBtn" type="button">+ Add Category</button>
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
              <th scope="col">Category ID</th>
              <th scope="col">Category Name</th>
              <th scope="col" class="align-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty categories}">
                <c:forEach var="cat" items="${categories}">
                  <tr>
                    <td><strong>${cat[0]}</strong></td>
                    <td>${cat[1]}</td>
                    <td class="align-right">
                      <button class="btn btn--sm btn--ghost" onclick="alert('Edit functionality coming soon')">Edit</button>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="3" style="text-align: center; padding: 2rem; color: #999;">
                    No categories found
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </section>
  </main>

  <div class="modal-backdrop" id="modalBackdrop" hidden>
    <div class="modal">
      <div class="modal__header">
        <h3 class="modal__title">Add New Category</h3>
        <button class="modal__close" id="modalClose">✕</button>
      </div>
      <form method="post" class="modal__body">
        <input type="hidden" name="action" value="add">
        <div>
          <label class="form-label">Category Name</label>
          <input type="text" class="form-input" name="categoryName" placeholder="e.g., Cereals, Vegetables" required>
        </div>
        <div class="modal__footer">
          <button type="button" class="btn btn--ghost" id="modalCancel">Cancel</button>
          <button type="submit" class="btn btn--primary">Add Category</button>
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
    const addBtn = document.getElementById('addCategoryBtn');

    const hideModal = () => backdrop.hidden = true;

    closeBtn.addEventListener('click', hideModal);
    cancelBtn.addEventListener('click', hideModal);
    addBtn.addEventListener('click', () => {
      backdrop.hidden = false;
    });
  </script>
</body>
</html>
