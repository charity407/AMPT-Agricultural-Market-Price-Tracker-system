<%@ page language="java" contentType="text/html; charset=UTF-8" isErrorPage="true" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>System Error — AgroMarket</title>
  <link rel="stylesheet" href="../css/style.css" />
  <style>
    .error-layout { display: flex; align-items: center; justify-content: center; min-height: 100dvh; background: var(--c-surface-alt); text-align: center; padding: var(--sp-4); }
    .error-card { background: var(--c-white); padding: var(--sp-8); border-radius: var(--radius-lg); box-shadow: var(--shadow-lg); border-top: 4px solid var(--c-danger); max-width: 30rem; }
  </style>
</head>
<body class="error-layout">
  <main class="error-card">
    <h1 style="color: var(--c-danger); margin-bottom: var(--sp-2);">⚠️ System Error</h1>
    <p style="margin-bottom: var(--sp-4); color: var(--c-text-muted);">We encountered an unexpected problem while processing your request.</p>
    
    <div style="background: var(--c-mist); padding: var(--sp-3); border-radius: var(--radius-sm); margin-bottom: var(--sp-6); font-family: var(--f-mono); font-size: var(--fs-sm); text-align: left; overflow-x: auto;">
      <strong>Error Details:</strong> <br>
      <%= exception != null ? exception.getMessage() : "Unknown Server Error. Please contact an Administrator." %>
    </div>
    
    <a href="dashboard.jsp" class="btn btn--primary">Return to Dashboard</a>
  </main>
</body>
</html>