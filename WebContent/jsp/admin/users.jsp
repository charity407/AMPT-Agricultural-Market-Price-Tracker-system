<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Manage Users — AgroMarket Admin</title>
  
  <link rel="stylesheet" href="../../css/style.css" />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=IBM+Plex+Mono:wght@400;600&family=Source+Serif+4:ital,wght@0,300;0,400;0,600;1,300&display=swap" rel="stylesheet" />
</head>
<body>

  <jsp:include page="../navbar.jsp" />

  <main class="layout" style="display: block; max-width: 70rem; margin-top: var(--sp-6);">
    <section class="content-section">
      <div class="section-header">
        <div>
          <h1 class="section-header__title">User Administration</h1>
          <p class="section-header__sub">Manage system access, roles, and account statuses</p>
        </div>
        <button class="btn btn--primary" id="addUserBtn" type="button">+ Add User</button>
      </div>

      <div class="table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th scope="col">Name</th>
              <th scope="col">Email</th>
              <th scope="col">Role</th>
              <th scope="col">Region</th>
              <th scope="col">Status</th>
              <th scope="col">Joined</th>
              <th scope="col" class="align-right">Actions</th>
            </tr>
          </thead>
          <tbody id="userTableBody">
            </tbody>
        </table>
      </div>
    </section>
  </main>

  <div class="modal-backdrop" id="modalBackdrop" hidden>
    <div class="modal">
      <div class="modal__header">
        <h3 class="modal__title" id="modalTitle">Modal</h3>
        <button class="modal__close" id="modalClose">✕</button>
      </div>
      <div class="modal__body" id="modalBody"></div>
      <div class="modal__footer">
        <button class="btn btn--ghost" id="modalCancel">Cancel</button>
        <button class="btn btn--primary" id="modalConfirm">Save User</button>
      </div>
    </div>
  </div>

  <script src="../../js/admin-users.js"></script>
</body>
</html>