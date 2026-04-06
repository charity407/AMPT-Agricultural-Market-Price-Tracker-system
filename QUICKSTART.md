# Quick Start — AgriPrice KE

Get the system running in 5 minutes.

---

## Prerequisites

- **Java**: JDK 17+
- **Maven**: 3.9.0+
- **PostgreSQL**: 14+ running
- **Tomcat**: 10.0+ (optional, use Maven if not available)

Check versions:
```bash
java -version
mvn -v
psql --version
```

---

## Setup (One Time)

### 1. Configure Database

```bash
# Create db.properties file
cp src/com/agriprice/utils/db.properties.example src/com/agriprice/utils/db.properties
```

Edit `db.properties`:
```properties
db.url=jdbc:postgresql://localhost:5432/agri_price_tracker
db.username=postgres
db.password=your_password
db.driver=org.postgresql.Driver
```

### 2. Create Database

```bash
# Create schema
psql -U postgres -f sql/schema.sql

# Load sample data
psql -U postgres -d agri_price_tracker -f sql/sample_data.sql
```

Verify:
```bash
psql -U postgres -d agri_price_tracker -c "SELECT COUNT(*) FROM users;"
```

---

## Build & Run

### Option A: Maven (Recommended)

```bash
# Build WAR file (includes JSP admin pages as of March 2026)
mvn clean package

# Verify build includes JSP files
unzip -l target/agri-price-tracker.war | grep ".jsp"
# Should show jsp/admin/products.jsp, jsp/admin/markets.jsp, etc.

# Deploy to Tomcat
cp target/agri-price-tracker.war $CATALINA_HOME/webapps/

# Start Tomcat
$CATALINA_HOME/bin/startup.sh
```

### Option B: Maven Embedded Server

```bash
mvn clean install
mvn tomcat7:run
```

---

## Access the Application

Open browser and go to:

```
http://localhost:8080/agri-price-tracker/
```

You should see the **AgriPrice KE homepage**.

---

## Test Login

Use these test credentials:

| Email | Password | Role |
|-------|----------|------|
| farmer_001@example.com | Farmer@123 | Farmer |
| agent_nairobi@example.com | Agent@123 | Market Agent |
| admin@example.com | Admin@123 | Admin |

---

## Verify Installation

✅ Homepage loads
✅ Can login with test credentials
✅ Dashboard displays
✅ Can view prices
✅ **Admin pages load** (NEW):
   - Products admin: `/admin/products` (requires admin role)
   - Markets admin: `/admin/markets` (requires admin role)

If all ✅, your system is **ready to use**!

### Admin Access (March 2026 Update)

Login with admin credentials, then visit:
- **Products**: http://localhost:8080/agri-price-tracker/admin/products
- **Markets**: http://localhost:8080/agri-price-tracker/admin/markets

Both pages now have full backend integration with dynamic database queries.

---

## Common Issues

| Issue | Fix |
|-------|-----|
| **"Connection refused"** | Start PostgreSQL: `pg_ctl start` |
| **"Maven not found"** | Install Maven or use system package manager |
| **"Port 8080 in use"** | Change port or kill other process: `lsof -i :8080` |
| **"Database not found"** | Run schema setup: `psql -f sql/schema.sql` |

---

## Live Demo Testing

Use this section when demonstrating the system to an audience. Follow the steps in order — each step builds on the previous one.

### Pre-Demo Checklist (run before the demo starts)

```bash
# 1. Confirm PostgreSQL is running
sudo systemctl status postgresql

# 2. Confirm Tomcat is running and the app is deployed
sudo systemctl status tomcat10
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/agri-price-tracker/
# Expected: 200 or 302

# 3. Check Tomcat logs are clean (no errors)
sudo tail -20 /var/log/tomcat10/catalina.out

# 4. Verify sample data is loaded
psql -U postgres -d agri_price_tracker -c "SELECT COUNT(*) FROM users; SELECT COUNT(*) FROM products; SELECT COUNT(*) FROM markets;"
# Expected: all counts > 0

# 5. Open the app in browser before the demo
# http://localhost:8080/agri-price-tracker/
```

---

### Demo Flow (in this order)

#### 1. Show the login page
- Open: `http://localhost:8080/agri-price-tracker/`
- Point out: redirect from `login.html` to the login servlet

#### 2. Log in as Admin
- Email: `admin@example.com`
- Password: `Admin@123`
- Show the admin dashboard

#### 3. Admin — Manage Products
- Visit: `http://localhost:8080/agri-price-tracker/admin/products`
- Show the product list loaded from the database
- Add a new product:
  - Name: `Demo Maize`
  - Category: `CEREALS`
  - Unit: `50kg bag`
- Verify it appears in the list immediately

#### 4. Admin — Manage Markets
- Visit: `http://localhost:8080/agri-price-tracker/admin/markets`
- Show existing markets
- Add a new market if needed for the demo

#### 5. Admin — Manage Users
- Visit: `http://localhost:8080/agri-price-tracker/admin/users`
- Show the user list with roles

#### 6. Log out, then log in as Market Agent
- Visit: `http://localhost:8080/agri-price-tracker/logout`
- Email: `agent_nairobi@example.com`
- Password: `Agent@123`

#### 7. Market Agent — Enter a Price
- Visit: `http://localhost:8080/agri-price-tracker/prices/entry`
- Select a market, product, and today's date
- Enter price: `4500`
- Submit — confirm success message

#### 8. Market Agent — View Price List
- Visit: `http://localhost:8080/agri-price-tracker/prices/list`
- Show the entry just created at the top

#### 9. Market Agent — Edit a Price
- Visit: `http://localhost:8080/agri-price-tracker/prices/edit`
- Change the price from `4500` to `4800`
- Verify the update is reflected

#### 10. Log out, then log in as Farmer
- Visit: `http://localhost:8080/agri-price-tracker/logout`
- Email: `farmer_001@example.com`
- Password: `Farmer@123`

#### 11. Farmer — Compare Prices
- Visit: `http://localhost:8080/agri-price-tracker/prices/compare`
- Show price differences across markets

#### 12. Farmer — View Price Trends
- Visit: `http://localhost:8080/agri-price-tracker/prices/trends`
- Select a product and date range
- Show the trend chart

#### 13. Farmer — Set a Price Alert
- Visit: `http://localhost:8080/agri-price-tracker/alerts`
- Create a new alert:
  - Product: `Tomatoes`
  - Threshold: `5000 KES`
  - Type: Price drops below
- Verify alert appears in the list

#### 14. View a Report
- Visit: `http://localhost:8080/agri-price-tracker/reports`
- Generate a weekly summary report
- Show the output

#### 15. Show session security
- Visit: `http://localhost:8080/agri-price-tracker/logout`
- Try to access `http://localhost:8080/agri-price-tracker/admin/products`
- Show it redirects to login (access denied without session)

---

### Live Database Verification (open a terminal alongside the browser)

Run these during the demo to show data persisting in real time:

```bash
# Connect to the database
psql -U postgres -d agri_price_tracker

# Watch prices as they are entered
SELECT p.price, pr.product_name, m.market_name, p.entry_date
FROM prices p
JOIN products pr ON p.product_id = pr.product_id
JOIN markets m ON p.market_id = m.market_id
ORDER BY p.entry_date DESC LIMIT 5;

# Show active alerts
SELECT u.full_name, pa.threshold_price, pa.alert_type, pa.status
FROM price_alerts pa
JOIN users u ON pa.user_id = u.user_id
ORDER BY pa.created_at DESC LIMIT 5;

# Confirm passwords are hashed (not plain text)
SELECT username, LEFT(password_hash, 20) || '...' AS password_preview FROM users LIMIT 3;
```

---

### If Something Goes Wrong During the Demo

```bash
# Restart Tomcat quickly
sudo systemctl restart tomcat10

# Check what error occurred
sudo tail -30 /var/log/tomcat10/catalina.out

# Restart PostgreSQL if DB connection fails
sudo systemctl restart postgresql

# Verify the app is back up
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/agri-price-tracker/
# Expected: 200 or 302
```

---

For detailed setup, see **README.md**.  
For full test cases, see **TEST.md**.

---

*Last Updated: April 1, 2026* (Added live demo testing section)
