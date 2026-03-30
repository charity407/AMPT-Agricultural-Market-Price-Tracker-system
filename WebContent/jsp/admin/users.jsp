<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>User Management — AgriPrice Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=IBM+Plex+Mono:wght@400;600&family=Source+Serif+4:ital,wght@0,300;0,400;0,600;1,300&display=swap" rel="stylesheet" />
  <style>
    .table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
    .table th { background: #f5f5f5; padding: 1rem; text-align: left; font-weight: 600; border-bottom: 2px solid #ddd; }
    .table td { padding: 0.75rem 1rem; border-bottom: 1px solid #eee; }
    .table tbody tr:hover { background: #f9f9f9; }
    .badge {
      display: inline-block;
      padding: 0.25rem 0.75rem;
      border-radius: 4px;
      font-size: 0.85rem;
      font-weight: 500;
    }
    .badge-admin { background: #ffe0e0; color: #c41e3a; }
    .badge-agent { background: #e0f0ff; color: #0066cc; }
    .badge-active { background: #e8f5e9; color: #2e7d32; }
    .badge-inactive { background: #ffebee; color: #c62828; }
    .btn-small {
      padding: 0.4rem 0.8rem;
      font-size: 0.85rem;
      margin-right: 0.5rem;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    .btn-edit { background: #2196F3; color: white; }
    .btn-edit:hover { background: #0b7dda; }
    .align-right { text-align: right; }
  </style>
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
        <li><a href="${pageContext.request.contextPath}/admin/users" class="navbar__link is-active">Users</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/products" class="navbar__link">Products</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/markets" class="navbar__link">Markets</a></li>
      </ul>
    </nav>
  </header>

  <main class="layout" style="display: block; max-width: 90%; margin: 2rem auto;">
    <section class="content-section">
      <div class="section-header">
        <div>
          <h1 class="section-header__title">User Management</h1>
          <p class="section-header__sub">Manage system users, roles, and permissions</p>
        </div>
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
        <table class="table data-table">
          <thead>
            <tr>
              <th>User ID</th>
              <th>Full Name</th>
              <th>Email Address</th>
              <th>Role</th>
              <th>Status</th>
              <th class="align-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty users}">
                <c:forEach var="user" items="${users}">
                  <tr>
                    <td><strong>${user.userId}</strong></td>
                    <td>${user.fullName}</td>
                    <td>${user.email}</td>
                    <td>
                      <c:choose>
                        <c:when test="${user.role == 'ADMIN'}">
                          <span class="badge badge-admin">ADMIN</span>
                        </c:when>
                        <c:when test="${user.role == 'MARKET_AGENT'}">
                          <span class="badge badge-agent">Market Agent</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-agent">${user.role}</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <span class="badge ${user.status == 'ACTIVE' ? 'badge-active' : 'badge-inactive'}">
                        ${user.status}
                      </span>
                    </td>
                    <td class="align-right">
                      <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${user.userId}" class="btn-small btn-edit">Edit</a>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="6" style="text-align: center; padding: 2rem; color: #999;">
                    No users found
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </section>
  </main>

  <footer class="site-footer">
    <p>© <span id="footerYear">2026</span> AgroMarket Price Intelligence</p>
    <p class="site-footer__status">API Status: <span class="status-dot status-dot--ok">●</span></p>
  </footer>

  <script>
    document.getElementById('footerYear').textContent = new Date().getFullYear();
  </script>
</body>
</html>
