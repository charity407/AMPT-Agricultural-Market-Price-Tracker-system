<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<header class="site-header" role="banner">
  <nav class="navbar" aria-label="Primary navigation">

    <div class="navbar__brand">
      <span class="navbar__logo" aria-hidden="true">⬡</span>
      <span class="navbar__name">AgroMarket</span>
      <span class="navbar__tagline">Price Intelligence</span>
    </div>

    <button class="navbar__hamburger" id="navToggle" aria-expanded="false" aria-controls="navMenu">
      <span class="bar"></span><span class="bar"></span><span class="bar"></span>
    </button>

    <ul class="navbar__menu" id="navMenu" role="list">
      <li><a href="${pageContext.request.contextPath}/jsp/dashboard.jsp" class="navbar__link">Dashboard</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/prices/list.jsp" class="navbar__link">Prices</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/admin/users.jsp" class="navbar__link">Admin</a></li>
    </ul>

    <div class="navbar__user" id="navbarUser" aria-live="polite">
      <span class="badge badge--admin" id="userRoleBadge">
        <%= session.getAttribute("userRole") != null ? session.getAttribute("userRole") : "GUEST" %>
      </span>
      <span class="navbar__username" id="navbarUsername">
        <%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "Not Logged In" %>
      </span>
    </div>

  </nav>
</header>