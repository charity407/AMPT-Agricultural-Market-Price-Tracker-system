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
# Build WAR file
mvn clean package

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

If all ✅, your system is **ready to use**!

---

## Common Issues

| Issue | Fix |
|-------|-----|
| **"Connection refused"** | Start PostgreSQL: `pg_ctl start` |
| **"Maven not found"** | Install Maven or use system package manager |
| **"Port 8080 in use"** | Change port or kill other process: `lsof -i :8080` |
| **"Database not found"** | Run schema setup: `psql -f sql/schema.sql` |

---

For detailed setup, see **README.md**.  
For testing, see **TEST.md**.

---

*Last Updated: March 29, 2026*
