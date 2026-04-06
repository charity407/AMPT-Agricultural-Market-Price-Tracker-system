# AgriPrice KE — Testing Guide

Complete guide for testing the Agricultural Market Price Tracker system. This document covers manual testing, setup validation, and test scenarios for all features.

---

## Table of Contents
- [Quick Start](#quick-start)
- [Environment Setup Verification](#environment-setup-verification)
- [Build & Deployment Testing](#build--deployment-testing)
- [Manual Testing Scenarios](#manual-testing-scenarios)
- [Test Credentials](#test-credentials)
- [Feature Test Cases](#feature-test-cases)
- [Database Testing](#database-testing)
- [Common Issues & Troubleshooting](#common-issues--troubleshooting)

---

## Quick Start

### Prerequisites
- **Java**: JDK 17+
- **Maven**: 3.9.0+
- **Tomcat**: 10.0+
- **PostgreSQL**: 14+ or Neon cloud DB
- **Browser**: Chrome, Firefox, Safari, or Edge (latest)

### Build & Run in 5 Steps

```bash
# 1. Clone the repository
git clone https://github.com/charity407/AMPT-Agricultural-Market-Price-Tracker-system.git
cd AMPT-Agricultural-Market-Price-Tracker-system

# 2. Configure database (create db.properties from template)
cp src/com/agriprice/utils/db.properties.example src/com/agriprice/utils/db.properties
# Edit db.properties with your PostgreSQL credentials

# 3. Create database schema
psql -U postgres -f sql/schema.sql
psql -U postgres -d agri_price_tracker -f sql/sample_data.sql

# 4. Build the project
mvn clean package

# 5. Deploy to Tomcat
cp target/agri-price-tracker.war $CATALINA_HOME/webapps/
# Access at: http://localhost:8080/agri-price-tracker
```

---

## Environment Setup Verification

### 1. Java Version Check
```bash
java -version
# Expected: openjdk version "17" or higher
```

### 2. Maven Verification
```bash
mvn -v
# Expected: Maven 3.9.0 or higher
```

### 3. PostgreSQL Connection Test
```bash
psql -h localhost -U postgres -d agri_price_tracker -c "SELECT version();"
# Expected: PostgreSQL version output
```

### 4. Tomcat Status
```bash
# Check if Tomcat is running
curl -s http://localhost:8080 | grep -i tomcat
# Or visit http://localhost:8080 in browser
```

### 5. Build Compilation Test
```bash
mvn clean compile -q
# Expected: BUILD SUCCESS
```

---

## Build & Deployment Testing

### Compile-Only Test
```bash
mvn clean compile
# Expected: No compilation errors, BUILD SUCCESS
```

### Full Build Test (with WAR packaging)
```bash
mvn clean package
# Expected: agri-price-tracker.war created in target/
# Verify: ls -lh target/agri-price-tracker.war
```

### Verify WAR Contents ✅ UPDATED
```bash
# List all JSP files in WAR (added March 2026)
unzip -l target/agri-price-tracker.war | grep ".jsp"

# Expected output should include:
#   jsp/admin/products.jsp  ✅ NEW
#   jsp/admin/markets.jsp   ✅ NEW
#   jsp/prices/entry.jsp
#   jsp/prices/list.jsp
#   jsp/alerts/alerts.jsp
#   jsp/reports/summary.jsp
#   jsp/prices/edit.jsp
#   jsp/prices/compare.jsp
#   jsp/trends/trends.jsp

# Verify servlets are compiled
jar tf target/agri-price-tracker.war | grep "ProductServlet.class"
jar tf target/agri-price-tracker.war | grep "MarketServlet.class"
# Expected: Both should be present
```

### Deploy to Tomcat
```bash
# Manual deployment
cp target/agri-price-tracker.war $CATALINA_HOME/webapps/

# Verify deployment
curl -s http://localhost:8080/agri-price-tracker/index.html | head -20
# Expected: HTML homepage loads successfully
```

---

## Manual Testing Scenarios

### Test 1: Application Startup
**Steps:**
1. Start Tomcat: `$CATALINA_HOME/bin/startup.sh`
2. Open browser: `http://localhost:8080/agri-price-tracker`

**Expected Result:**
- ✅ Homepage (index.html) loads successfully
- ✅ CSS styling applied (colors, fonts visible)
- ✅ No console errors (F12 → Console tab)
- ✅ No 404 errors in server logs

**Server Log Check:**
```bash
tail -f $CATALINA_HOME/logs/catalina.out
# Should show: "INFO: Server startup in X ms"
```

---

### Test 2: Authentication Flow
**Steps:**
1. Click "Register" on homepage
2. Fill registration form:
   - **Username**: `testuser_001`
   - **Email**: `testuser@example.com`
   - **Password**: `TestPass@123`
   - **Role**: Select "Farmer"
3. Submit form
4. Verify success message appears
5. Try login with same credentials
6. Verify dashboard loads

**Expected Results:**
- ✅ Registration succeeds with valid inputs
- ✅ Password properly hashed in database
- ✅ Login succeeds with correct credentials
- ✅ Session created (user info visible on dashboard)
- ✅ Logout works (redirects to login page)

**Database Verification:**
```sql
-- Check user was created with hashed password
SELECT id, username, email, role FROM users WHERE username = 'testuser_001';

-- Verify password is hashed (not plain text)
SELECT password_hash FROM users WHERE username = 'testuser_001';
-- Expected: SHA-256 hash (64 characters)
```

---

### Test 3: Product & Market Management (JSP Integration) ✅ NEW

**🔗 URL Paths:**
- Products: `http://localhost:8080/agri-price-tracker/admin/products`
- Markets: `http://localhost:8080/agri-price-tracker/admin/markets`

**Steps:**
1. Login as Admin (use test credentials below)
2. Navigate to `/admin/products`
3. Verify product list loads from database
4. Click "Add Product" button
5. Fill form:
   - **Product Name**: `Maize (Corn)`
   - **Category**: `CEREALS`
   - **Unit**: `50kg bag`
6. Submit form
7. Verify product appears in list (should see it immediately)
8. Repeat for Markets at `/admin/markets`

**Expected Results:**
- ✅ Products list displays data from database via ProductServlet
- ✅ Markets list displays data from database via MarketServlet
- ✅ Forms submit to backend servlet (POST request)
- ✅ New items appear in table immediately after add
- ✅ Data persists after refresh (database is source of truth)
- ✅ Session validation prevents unauthorized access
- ✅ Admin role required to access these pages

**Backend Verification (New March 2026):**
```sql
-- Verify servlet queries return data
SELECT COUNT(*) as total_products FROM products;
SELECT COUNT(*) as total_markets FROM markets;

-- Check for recent additions
SELECT product_id, product_name, is_active FROM products ORDER BY product_id DESC LIMIT 3;
SELECT market_id, market_name, status FROM markets ORDER BY market_id DESC LIMIT 3;
```

**Security Test:**
1. Try to access `/admin/products` without login
2. Should redirect to login page ✅
3. Login as non-admin user
4. Should see "Admin access required" error ✅

---

### Test 4: Price Entry & Management
**Steps:**
1. Login as Market Agent
2. Navigate to "Enter Prices" page
3. Select market, product, and date
4. Enter price: `3500` (KES)
5. Submit
6. Verify price appears in price list
7. Try to edit: click edit icon, change price to `3600`
8. Save and verify update

**Expected Results:**
- ✅ Price entry succeeds with valid data
- ✅ Price appears in real-time price list
- ✅ Edit functionality works
- ✅ Historical prices preserved
- ✅ Price comparison shows trend

**Database Verification:**
```sql
SELECT * FROM prices ORDER BY entry_date DESC LIMIT 5;
SELECT market_id, product_id, price, entry_date FROM prices;
```

---

### Test 5: Price Trends & Analytics
**Steps:**
1. Login as any user
2. Navigate to "Price Trends"
3. Select a product (e.g., Maize)
4. Select date range (last 7 days)
5. Verify chart displays price history
6. Hover over data points to see values

**Expected Results:**
- ✅ Chart renders with valid data
- ✅ Date range filtering works
- ✅ Multiple markets can be compared
- ✅ Trend direction indicated (up/down arrow)
- ✅ No JavaScript errors in console

---

### Test 6: Price Alerts
**Steps:**
1. Login as Consumer
2. Navigate to "Price Alerts"
3. Click "Create New Alert"
4. Set:
   - **Product**: Tomatoes
   - **Market**: Nairobi Central
   - **Alert Type**: Price drops below
   - **Threshold**: 5000 KES
5. Save alert
6. Verify alert appears in "My Alerts"
7. When price drops below threshold, verify email/notification

**Expected Results:**
- ✅ Alert created successfully
- ✅ Alert stored in database
- ✅ Alert triggers when condition met
- ✅ User notified (email or dashboard message)

**Database Verification:**
```sql
SELECT * FROM price_alerts WHERE user_id = [user_id];
SELECT COUNT(*) FROM price_alerts WHERE status = 'active';
```

---

### Test 7: Report Generation
**Steps:**
1. Login as Admin or Analyst
2. Navigate to "Reports" page
3. Select report type: "Weekly Price Summary"
4. Choose date range
5. Click "Generate Report"
6. Verify PDF/CSV downloads

**Expected Results:**
- ✅ Report generates within 5 seconds
- ✅ File downloads successfully
- ✅ Data in report matches database
- ✅ Formatting is correct (tables, charts if any)

---

### Test 8: Session Management
**Steps:**
1. Login successfully
2. Wait 30 minutes (or modify session timeout to test quicker)
3. Try to access protected page
4. Verify redirected to login

**Alternative Test:**
1. Open developer tools (F12)
2. Manually delete session cookie
3. Refresh page
4. Should redirect to login

**Expected Results:**
- ✅ Sessions timeout correctly
- ✅ Logout clears session
- ✅ Protected pages require authentication
- ✅ No sensitive data in cookies (encrypted/hashed)

---

## Test Credentials

### Admin Account
- **Username**: `admin`
- **Password**: `Admin@123`
- **Role**: Administrator
- **Access**: Full system access, user management

### Market Agent Account
- **Username**: `agent_nairobi`
- **Password**: `Agent@123`
- **Role**: Market Agent
- **Access**: Enter prices, view reports

### Farmer Account
- **Username**: `farmer_001`
- **Password**: `Farmer@123`
- **Role**: Farmer
- **Access**: View prices, set alerts, compare markets

### Consumer Account
- **Username**: `consumer_001`
- **Password**: `Consumer@123`
- **Role**: Consumer
- **Access**: View prices, trends, alerts

---

## Feature Test Cases

### Feature: User Registration
| Test ID | Step | Input | Expected | Pass? |
|---------|------|-------|----------|-------|
| REG-001 | Register with all fields | Valid data | User created, dashboard loads | ☐ |
| REG-002 | Register with weak password | `pass123` | Error message shown | ☐ |
| REG-003 | Register with duplicate username | Existing username | Error: "Username taken" | ☐ |
| REG-004 | Register with invalid email | `notanemail` | Error: "Invalid email" | ☐ |

### Feature: Price Entry
| Test ID | Step | Input | Expected | Pass? |
|---------|------|-------|----------|-------|
| PRICE-001 | Enter valid price | Market, Product, 5000 KES | Price saved, appears in list | ☐ |
| PRICE-002 | Enter negative price | -1000 | Error: "Must be positive" | ☐ |
| PRICE-003 | Enter price without market | Product, 5000 | Error: "Select market" | ☐ |
| PRICE-004 | Edit price | Change 5000 → 5500 | Updated price shown | ☐ |
| PRICE-005 | Delete price | Click delete button | Price removed from list | ☐ |

### Feature: Price Alerts
| Test ID | Step | Input | Expected | Pass? |
|---------|------|-------|----------|-------|
| ALERT-001 | Create alert | Valid product, threshold | Alert saved, appears in list | ☐ |
| ALERT-002 | Trigger alert | Drop price below threshold | User notified | ☐ |
| ALERT-003 | Delete alert | Click delete | Alert removed | ☐ |
| ALERT-004 | Edit alert threshold | Change 5000 → 4500 | Updated alert triggers correctly | ☐ |

---

## Database Testing

### Schema Validation
```bash
# Connect to database
psql -U postgres -d agri_price_tracker

# List all tables
\dt

# Expected tables:
# - users
# - products
# - markets
# - regions
# - categories
# - prices
# - price_alerts
```

### Data Integrity Tests

**1. Foreign Key Constraints**
```sql
-- Try to insert price with invalid product
INSERT INTO prices (product_id, market_id, price, entry_date)
VALUES (99999, 1, 5000, NOW());
-- Expected: FOREIGN KEY constraint violation
```

**2. Unique Constraints**
```sql
-- Verify username uniqueness
INSERT INTO users (username, email, password_hash)
VALUES ('admin', 'another@test.com', 'hash');
-- Expected: UNIQUE constraint violation
```

**3. Data Types**
```sql
-- Verify prices are numeric
SELECT price, TYPEOF(price) FROM prices LIMIT 1;
-- Expected: price | numeric/decimal
```

---

## Browser Compatibility Testing

Test on all major browsers:

| Browser | Version | Status | Notes |
|---------|---------|--------|-------|
| Chrome | Latest | ☐ | Test responsive design at 100% zoom |
| Firefox | Latest | ☐ | Check console for warnings |
| Safari | Latest | ☐ | Test on macOS if available |
| Edge | Latest | ☐ | Windows-based testing |
| Mobile (Chrome) | Latest | ☐ | Test on 375px width (mobile) |

### Mobile Responsiveness Test
```bash
# Test at different breakpoints
# 320px (mobile), 768px (tablet), 1024px (laptop)

# Open DevTools (F12) → Device Emulation
# Verify:
# - Navigation menu is responsive
# - Tables don't overflow
# - Forms are accessible
# - Buttons are clickable
```

---

## Performance Testing

### Page Load Time
```bash
# Measure homepage load time
curl -w "@curl-format.txt" -o /dev/null -s http://localhost:8080/agri-price-tracker/
# Expected: < 2 seconds

# Check with browser DevTools (F12 → Network)
# Expected: All resources loaded, no failed requests
```

### Database Query Performance
```sql
-- Check slow queries
SELECT * FROM prices WHERE market_id = 1
  AND entry_date BETWEEN '2026-03-01' AND '2026-03-29';
-- Expected: Returns in < 500ms
```

---

## Security Testing

### 1. SQL Injection Test
**Steps:**
1. Try to login with: `' OR '1'='1`
2. Try to search with: `'; DROP TABLE users; --`

**Expected Result:** ✅ No impact, parameterized queries prevent injection

### 2. Session Hijacking Test
**Steps:**
1. Login and get session ID from cookies
2. Open private/incognito window
3. Manually set session cookie
4. Try to access protected page

**Expected Result:** ✅ Session invalid, redirected to login

### 3. CSRF Protection Test
**Steps:**
1. Check if forms have CSRF tokens
2. Try to submit form without token (if token visible)

**Expected Result:** ✅ Request rejected, CSRF token required

### 4. Password Storage Test
```sql
-- Verify passwords are hashed, not plain text
SELECT id, username, password_hash FROM users LIMIT 1;
-- Expected: password_hash is 64-char hexadecimal (SHA-256), NOT plain text
```

---

## Common Issues & Troubleshooting

### Issue 1: "Database Connection Failed"
**Cause**: PostgreSQL not running or credentials wrong
**Solution**:
```bash
# Check if PostgreSQL is running
psql -U postgres -c "\l"
# Update db.properties with correct credentials
```

### Issue 2: "ClassNotFoundException: org.postgresql.Driver"
**Cause**: PostgreSQL JDBC driver not in classpath
**Solution**:
```bash
# Check pom.xml for PostgreSQL dependency
# Run: mvn clean dependency:resolve
# Rebuild: mvn clean package
```

### Issue 3: 404 Error on JSP pages
**Cause**: JSP files not deployed correctly
**Solution**:
```bash
# Verify WAR structure
jar tf target/agri-price-tracker.war | grep ".jsp"
# Redeploy: cp target/agri-price-tracker.war $CATALINA_HOME/webapps/
```

### Issue 4: "Port 8080 already in use"
**Cause**: Tomcat or another service using port 8080
**Solution**:
```bash
# Find process using port 8080
lsof -i :8080
# Kill process and restart Tomcat
```

### Issue 5: "Session not persisting after refresh"
**Cause**: Cookies disabled or session timeout too short
**Solution**:
```bash
# Check browser cookie settings (F12 → Application → Cookies)
# Increase session timeout in web.xml (default: 30 minutes)
```

---

## Test Execution Checklist

Use this checklist when running full test cycle:

### Pre-Deployment
- ☐ Compile: `mvn clean compile` passes
- ☐ Build: `mvn clean package` creates WAR
- ☐ Database: Schema created, sample data loaded
- ☐ Tomcat: Running on port 8080

### Smoke Test (5 min)
- ☐ Homepage loads
- ☐ Login works with test credentials
- ☐ Dashboard displays

### Functional Tests (30 min)
- ☐ User registration succeeds
- ☐ Product/market management works
- ☐ Price entry and edit works
- ☐ Price trends chart displays
- ☐ Alerts can be created
- ☐ Reports generate

### Security Tests (15 min)
- ☐ No SQL injection vulnerabilities
- ☐ Sessions timeout correctly
- ☐ Passwords are hashed
- ☐ Protected pages require login

### Browser Compatibility (10 min)
- ☐ Chrome latest version
- ☐ Firefox latest version
- ☐ Mobile responsiveness (375px)

### Performance (5 min)
- ☐ Homepage loads in < 2 seconds
- ☐ Database queries return in < 500ms
- ☐ No console errors

---

## Reporting Issues

When reporting a bug, include:
1. **Steps to reproduce**: Exact steps taken
2. **Expected result**: What should happen
3. **Actual result**: What actually happened
4. **Screenshots**: Visual evidence (if applicable)
5. **Environment**: Browser, OS, Java version, Tomcat version
6. **Logs**: Relevant error messages from catalina.out

### Example Bug Report Format
```
Title: Price entry fails for tomatoes in Nairobi market
Steps to Reproduce:
  1. Login as agent_nairobi
  2. Go to "Enter Prices"
  3. Select product: Tomatoes
  4. Enter price: 5000
  5. Click Save

Expected: Price saved, appears in price list
Actual: Error message "Unknown market ID" appears
Environment: Chrome 125, Tomcat 10.1.19, Java 17
Log Error: org.postgresql.util.PSQLException: ERROR: foreign key violation
```

---

## Backend-Frontend Integration Testing ✅ NEW

See [INTEGRATION_TEST.md](INTEGRATION_TEST.md) for comprehensive backend-frontend integration verification report.

**Integration Status (March 2026):**
- ✅ ProductServlet fully integrated with JSP
- ✅ MarketServlet fully integrated with JSP
- ✅ CategoryServlet implemented as HttpServlet
- ✅ RegionServlet implemented as HttpServlet
- ✅ All servlet-JSP pairs properly forwarding data
- ✅ Session management and access control working
- ✅ WAR build includes all JSP files

**Test the Integration:**
```bash
# 1. Build the project
mvn clean package

# 2. Deploy WAR file
cp target/agri-price-tracker.war $CATALINA_HOME/webapps/

# 3. Restart Tomcat
$CATALINA_HOME/bin/shutdown.sh
sleep 2
$CATALINA_HOME/bin/startup.sh

# 4. Test admin pages (requires admin login)
# Products: http://localhost:8080/agri-price-tracker/admin/products
# Markets:  http://localhost:8080/agri-price-tracker/admin/markets

# 5. Verify database queries are working
psql -U postgres -d agri_price_tracker -c "SELECT COUNT(*) FROM products;"
psql -U postgres -d agri_price_tracker -c "SELECT COUNT(*) FROM markets;"
```

---

## Next Steps

- [ ] Set up automated unit tests (JUnit 5)
- [ ] Add integration tests (TestNG)
- [ ] Configure CI/CD pipeline (GitHub Actions)
- [ ] Set up Selenium for UI automation (test JSP pages)
- [ ] Add performance testing with JMeter
- [ ] Implement monitoring (AppInsights, DataDog)
- [ ] Create JSP pages for Categories and Regions admin

---

*Last Updated: March 30, 2026*
*Test Guide Version: 1.1*
*Maintained by: QA Team (Member 7) + Integration by Member 4*
