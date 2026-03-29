# Testing Guide — AgriPrice KE

Quick testing guide for AgriPrice KE system.

---

## Setup Test Environment

```bash
# 1. Prerequisites
java -version          # Require: JDK 17+
mvn -v                 # Require: Maven 3.9.0+
psql --version         # Require: PostgreSQL 14+

# 2. Build
mvn clean package

# 3. Start Tomcat
$CATALINA_HOME/bin/startup.sh

# 4. Access
# http://localhost:8080/agri-price-tracker/
```

---

## Smoke Test (5 min)

| Test | Steps | Expected |
|------|-------|----------|
| **Homepage** | Open http://localhost:8080/agri-price-tracker/ | Page loads, CSS styling applied |
| **Register** | Click "Register", fill form, submit | Account created, redirect to login |
| **Login** | Use test credentials, login | Dashboard loads |
| **Logout** | Click logout | Redirect to login page |

---

## Test Credentials

```
Email: farmer_001@example.com
Password: Farmer@123

Email: agent_nairobi@example.com
Password: Agent@123

Email: admin@example.com
Password: Admin@123
```

---

## Feature Tests

### Prices
- [ ] View current prices
- [ ] Filter by product and market
- [ ] Compare multiple markets
- [ ] Edit price (agent only)

### Trends
- [ ] View price chart
- [ ] Select date range
- [ ] Multiple markets comparison

### Alerts
- [ ] Create price alert
- [ ] Set threshold
- [ ] Delete alert

### Reports
- [ ] Generate weekly report
- [ ] Download as PDF/CSV
- [ ] Filter by date range

### Admin (Admin only)
- [ ] Add product
- [ ] Add market
- [ ] Manage users
- [ ] View activity logs

---

## Database Verification

```sql
-- Check database connection
psql -U postgres -d agri_price_tracker -c "SELECT version();"

-- Count tables
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'public';

-- Check sample data
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM markets;
SELECT COUNT(*) FROM prices;
```

---

## Common Test Cases

| Scenario | Test | Expected Result |
|----------|------|-----------------|
| **Invalid Login** | Try wrong password | Error message shown |
| **Empty Form** | Submit empty registration | Validation error |
| **Negative Price** | Enter -100 as price | Error: "Must be positive" |
| **Duplicate Email** | Register twice with same email | Error: "Email already exists" |
| **SQL Injection** | Enter `' OR '1'='1` in search | Query fails safely, no data leak |
| **Session Timeout** | Wait 30 min, access protected page | Redirect to login |

---

## Performance Tests

```bash
# Page load time
curl -w "@curl-format.txt" -o /dev/null -s http://localhost:8080/agri-price-tracker/
# Expected: < 2 seconds

# Database query test
psql -c "SELECT COUNT(*) FROM prices WHERE market_id = 1;"
# Expected: < 500ms
```

---

## Browser Compatibility

| Browser | Version | Status |
|---------|---------|--------|
| Chrome | Latest | ☐ Test |
| Firefox | Latest | ☐ Test |
| Safari | Latest | ☐ Test |
| Edge | Latest | ☐ Test |
| Mobile (Chrome) | Latest | ☐ Test |

---

## Security Tests

- [ ] Passwords are hashed (check DB)
- [ ] No sensitive data in cookies
- [ ] Login required for protected pages
- [ ] SQL injection prevention works
- [ ] CSRF protection in forms

---

## Final Checklist

- [ ] All features tested
- [ ] No errors in logs
- [ ] Database integrity verified
- [ ] Performance acceptable
- [ ] Browser compatibility checked
- [ ] Security tests passed

---

*Test Guide v1.0 — March 29, 2026*
