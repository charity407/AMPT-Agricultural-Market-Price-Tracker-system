<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>My Profile — AgroMarket</title>
  <link rel="stylesheet" href="../../css/style.css"/>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=IBM+Plex+Mono:wght@400;600&family=Source+Serif+4:ital,wght@0,300;0,400;0,600;1,300&display=swap" rel="stylesheet"/>
  <style>
    .profile-wrap { max-width:680px; margin:40px auto; padding:0 16px; }
    .profile-card {
      background:#fff; border-radius:10px; padding:32px;
      box-shadow:0 2px 10px rgba(0,0,0,0.08); margin-bottom:24px;
      border-top:3px solid #2e7d32;
    }
    .profile-card h2 {
      font-size:1rem; font-weight:700; color:#2e7d32;
      margin-bottom:20px; border-bottom:1px solid #e8f5e9; padding-bottom:10px;
    }
    .info-row { display:flex; gap:12px; margin-bottom:10px; font-size:0.9rem; }
    .info-row .lbl { color:#888; width:140px; flex-shrink:0; }
    .info-row .val { color:#333; font-weight:500; }
    .form-row { margin-bottom:16px; }
    .form-row label { display:block; font-size:0.85rem; font-weight:600; color:#555; margin-bottom:5px; }
    .form-row input {
      width:100%; padding:9px 12px; border:1px solid #ddd;
      border-radius:6px; font-size:0.95rem; box-sizing:border-box;
    }
    .form-row input:focus { outline:none; border-color:#2e7d32; }
    .btn-save {
      background:#2e7d32; color:#fff; border:none; padding:10px 24px;
      border-radius:6px; cursor:pointer; font-size:0.9rem; font-weight:600;
    }
    .btn-save:hover { background:#1b5e20; }
    .alert { padding:10px 14px; border-radius:6px; font-size:0.875rem; margin-bottom:16px; }
    .alert-success { background:#f0fdf4; border:1px solid #86efac; color:#166534; }
    .alert-error   { background:#fef2f2; border:1px solid #fca5a5; color:#b91c1c; }
    .badge { display:inline-block; padding:2px 10px; border-radius:99px; font-size:0.75rem; font-weight:600; }
    .badge-active   { background:#dcfce7; color:#166534; }
    .badge-pending  { background:#fef9c3; color:#854d0e; }
    .badge-inactive { background:#fee2e2; color:#991b1b; }
  </style>
</head>
<body>

        .hero {
            background: linear-gradient(135deg, #2e7d32 0%, #1b5e20 100%);
            color: #dfe8e0; text-align: center; padding: 60px 24px;
        }
        .hero h1 { font-size: 2.4rem; margin-bottom: 10px; }
        .hero p  { font-size: 1.05rem; opacity: 0.85; max-width: 520px; margin: 0 auto; }

<div class="profile-wrap">

  <%-- Success / error from ProfileServlet --%>
  <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success"><%= request.getAttribute("success") %></div>
  <% } %>
  <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error"><%= request.getAttribute("error") %></div>
  <% } %>

  <%-- Account Info (read-only) --%>
  <div class="profile-card">
    <h2>Account Information</h2>
    <div class="info-row">
      <span class="lbl">Full Name</span>
      <span class="val"><%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %></span>
    </div>
    <div class="info-row">
      <span class="lbl">Email</span>
      <span class="val"><%= request.getAttribute("emailAddress") != null ? request.getAttribute("emailAddress") : "" %></span>
    </div>
    <div class="info-row">
      <span class="lbl">Phone</span>
      <span class="val"><%= request.getAttribute("phoneNumber") != null ? request.getAttribute("phoneNumber") : "—" %></span>
    </div>
    <div class="info-row">
      <span class="lbl">Role</span>
      <span class="val"><%= request.getAttribute("role") != null ? request.getAttribute("role") : "" %></span>
    </div>
    <div class="info-row">
      <span class="lbl">Status</span>
      <span class="val">
        <%
          String status = (String) request.getAttribute("accountStatus");
          String cls = "ACTIVE".equals(status) ? "badge-active" :
                       "PENDING".equals(status) ? "badge-pending" : "badge-inactive";
        %>
        <span class="badge <%= cls %>"><%= status != null ? status : "" %></span>
      </span>
    </div>
    <div class="info-row">
      <span class="lbl">Registered</span>
      <span class="val"><%= request.getAttribute("registrationDate") != null ? request.getAttribute("registrationDate") : "" %></span>
    </div>
  </div>

  <%-- Update Name & Phone --%>
  <div class="profile-card">
    <h2>Update Profile</h2>
    <form method="POST" action="${pageContext.request.contextPath}/profile">
      <input type="hidden" name="action" value="updateProfile"/>
      <div class="form-row">
        <label for="fullName">Full Name</label>
        <input type="text" id="fullName" name="fullName"
               value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>"
               required/>
      </div>
      <div class="form-row">
        <label for="phoneNumber">Phone Number</label>
        <input type="text" id="phoneNumber" name="phoneNumber"
               value="<%= request.getAttribute("phoneNumber") != null ? request.getAttribute("phoneNumber") : "" %>"
               placeholder="e.g. 0712345678"/>
      </div>
      <button class="btn-save" type="submit">Save Changes</button>
    </form>
  </div>

  <%-- Change Password --%>
  <div class="profile-card">
    <h2>Change Password</h2>
    <form method="POST" action="${pageContext.request.contextPath}/profile">
      <input type="hidden" name="action" value="changePassword"/>
      <div class="form-row">
        <label for="oldPassword">Current Password</label>
        <input type="password" id="oldPassword" name="oldPassword" required placeholder="Enter current password"/>
      </div>
      <div class="form-row">
        <label for="newPassword">New Password</label>
        <input type="password" id="newPassword" name="newPassword" required placeholder="Minimum 8 characters"/>
      </div>
      <div class="form-row">
        <label for="confirmPassword">Confirm New Password</label>
        <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Re-type new password"/>
      </div>
      <button class="btn-save" type="submit">Change Password</button>
    </form>
  </div>

  <%-- Logout --%>
  <div style="text-align:center; margin-bottom:40px;">
    <a href="${pageContext.request.contextPath}/logout"
       style="color:#b91c1c; font-size:0.9rem; text-decoration:none; font-weight:500;">
      🚪 Log Out
    </a>
  </div>

</div>
</body>
</html>
