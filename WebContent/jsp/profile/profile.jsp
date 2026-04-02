<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>My Profile — AgriPrice KE</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=IBM+Plex+Mono:wght@400;600&family=Source+Serif+4:ital,wght@0,300;0,400;0,600;1,300&display=swap" rel="stylesheet" />
  <style>
    .profile-container {
      max-width: 600px;
      margin: 2rem auto;
      padding: 2rem;
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .form-group {
      margin-bottom: 1.5rem;
    }
    .form-label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 500;
      color: #333;
    }
    .form-input {
      width: 100%;
      padding: 0.75rem;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 1rem;
      box-sizing: border-box;
    }
    .form-input:focus {
      outline: none;
      border-color: #4CAF50;
      box-shadow: 0 0 5px rgba(76, 175, 80, 0.3);
    }
    .form-readonly {
      background-color: #f5f5f5;
      cursor: not-allowed;
    }
    .alert {
      padding: 1rem;
      margin-bottom: 1.5rem;
      border-radius: 4px;
      font-size: 0.95rem;
    }
    .alert-success {
      background-color: #d4edda;
      color: #155724;
      border: 1px solid #c3e6cb;
    }
    .alert-error {
      background-color: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
    }
    .btn-group {
      display: flex;
      gap: 1rem;
      margin-top: 2rem;
    }
    .btn {
      padding: 0.75rem 1.5rem;
      border: none;
      border-radius: 4px;
      font-size: 1rem;
      cursor: pointer;
      transition: background-color 0.3s;
    }
    .btn-primary {
      background-color: #4CAF50;
      color: white;
      flex: 1;
    }
    .btn-primary:hover {
      background-color: #45a049;
    }
    .btn-secondary {
      background-color: #ddd;
      color: #333;
      flex: 1;
    }
    .btn-secondary:hover {
      background-color: #ccc;
    }
    .profile-header {
      display: flex;
      align-items: center;
      gap: 1rem;
      margin-bottom: 2rem;
      padding-bottom: 1.5rem;
      border-bottom: 1px solid #eee;
    }
    .profile-avatar {
      width: 80px;
      height: 80px;
      border-radius: 50%;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 2rem;
      font-weight: bold;
    }
    .profile-info {
      flex: 1;
    }
    .profile-info h2 {
      margin: 0 0 0.5rem 0;
      color: #333;
    }
    .profile-role {
      display: inline-block;
      padding: 0.25rem 0.75rem;
      background-color: #e7f3fe;
      color: #0066cc;
      border-radius: 20px;
      font-size: 0.85rem;
      font-weight: 500;
    }
  </style>
</head>
<body>

  <header class="site-header" role="banner">
    <nav class="navbar">
      <div class="navbar__brand">
        <span class="navbar__logo">⬡</span>
        <span class="navbar__name">AgriPrice KE</span>
        <span class="navbar__tagline">Market Price Tracker</span>
      </div>
      <ul class="navbar__menu is-open" style="flex-direction: row; background: transparent; order: 0;">
        <li><a href="${pageContext.request.contextPath}/dashboard.jsp" class="navbar__link">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/prices/list" class="navbar__link">Prices</a></li>
        <li><a href="${pageContext.request.contextPath}/alerts" class="navbar__link">Alerts</a></li>
        <li><a href="${pageContext.request.contextPath}/profile" class="navbar__link is-active">Profile</a></li>
        <li><a href="${pageContext.request.contextPath}/logout" class="navbar__link">Sign Out</a></li>
      </ul>
    </nav>
  </header>

  <div class="profile-container">
    <div class="profile-header">
      <div class="profile-avatar">
        <% String name = (String) request.getAttribute("fullName");
           if (name != null && !name.isEmpty()) {
               out.print(name.charAt(0));
           } else {
               out.print("U");
           }
        %>
      </div>
      <div class="profile-info">
        <h2><%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "User" %></h2>
        <span class="profile-role"><%= request.getAttribute("role") != null ? request.getAttribute("role") : "Member" %></span>
      </div>
    </div>

    <% String success = request.getParameter("success");
       if (success != null && !success.isEmpty()) { %>
      <div class="alert alert-success">✓ <%= success %></div>
    <% } %>

    <% String error = (String) request.getAttribute("error");
       if (error != null && !error.isEmpty()) { %>
      <div class="alert alert-error">✗ <%= error %></div>
    <% } %>

    <% String paramError = request.getParameter("error");
       if (paramError != null && !paramError.isEmpty()) { %>
      <div class="alert alert-error">✗ <%= paramError %></div>
    <% } %>

    <form method="post">
      <div class="form-group">
        <label class="form-label">User ID</label>
        <input type="text" class="form-input form-readonly" value="<%= request.getAttribute("userId") %>" readonly />
      </div>

      <div class="form-group">
        <label class="form-label">Full Name *</label>
        <input type="text" name="fullName" class="form-input" value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>" required />
      </div>

      <div class="form-group">
        <label class="form-label">Email Address</label>
        <input type="email" name="email" class="form-input" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" />
      </div>

      <div class="form-group">
        <label class="form-label">Phone Number</label>
        <input type="tel" name="phone" class="form-input" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" />
      </div>

      <div class="form-group">
        <label class="form-label">Role</label>
        <input type="text" class="form-input form-readonly" value="<%= request.getAttribute("role") %>" readonly />
      </div>

      <div class="form-group">
        <label class="form-label">Account Status</label>
        <input type="text" class="form-input form-readonly" value="<%= request.getAttribute("status") %>" readonly />
      </div>

      <div class="btn-group">
        <button type="submit" class="btn btn-primary">Save Changes</button>
        <a href="<%= request.getContextPath() %>/dashboard.jsp" class="btn btn-secondary" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">Back to Dashboard</a>
      </div>
    </form>
  </div>
</body>
</html>
