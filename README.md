
# 🌾 AgriPrice KE — Agricultural Market Price Tracker

> A web-based system to monitor and display real-time agricultural product prices across Kenyan markets.
> Built with plain Java Servlets + JSP + JDBC + PostgreSQL — no Spring Boot, no Hibernate.

**Institution:** Chuka University · 2025/2026
**Server:** Apache Tomcat 10 · **Database:** PostgreSQL 16 · **Build Tool:** Maven

---

## 📑 Table of Contents

- [🌾 AgriPrice KE — Agricultural Market Price Tracker](#-agriprice-ke--agricultural-market-price-tracker)
  - [📑 Table of Contents](#-table-of-contents)
  - [Project Overview](#project-overview)
  - [Tech Stack](#tech-stack)
  - [Database Schema](#database-schema)
  - [URL Mappings](#url-mappings)
  - [Design Files](#design-files)
    - [Design File Access](#design-file-access)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Verify your environment](#verify-your-environment)
    - [Setup steps](#setup-steps)
    - [Test login credentials](#test-login-credentials)

---

## Project Overview

AgriPrice KE allows farmers, traders, wholesalers, and consumers to track and compare
agricultural product prices across different Kenyan markets. Market agents enter prices,
and users can view trends, set alerts, compare markets, and download reports.

**User Roles:** Admin · Market Agent · Farmer · Trader/Wholesaler · Consumer

---

## Tech Stack

| Layer      | Technology                                  |
| ---------- | ------------------------------------------- |
| Frontend   | Plain HTML · CSS · Vanilla JavaScript · JSP |
| Backend    | Plain Java Servlets + JDBC (NO Spring Boot) |
| Database   | PostgreSQL 16                               |
| Server     | Apache Tomcat 10                            |
| Build      | Apache Maven 3                              |
| Charts     | Chart.js (CDN)                              |
| SMS Alerts | Africa's Talking API (optional)             |

---

## Database Schema

Seven tables in the following creation order (parent before child):

```
1. regions        → region_id, region_name, country
2. markets        → market_id, market_name, location, region_id (FK)
3. categories     → category_id, category_name
4. products       → product_id, product_name, unit, category_id (FK)
5. users          → user_id, full_name, email, password_hash, phone, role, is_active
6. price_entries  → entry_id, product_id (FK), market_id (FK), recorded_by (FK), price, price_date
7. price_alerts   → alert_id, user_id (FK), product_id (FK), market_id (FK), alert_type, threshold
```

Run scripts in this order:
```bash
psql -U postgres -d agri_price_tracker -f sql/schema.sql
psql -U postgres -d agri_price_tracker -f sql/sample_data.sql
```

---

## URL Mappings

All URL patterns are defined in `WebContent/WEB-INF/web.xml`.
**Check this file before creating a new Servlet to avoid duplicate URLs.**

| URL Pattern         | Servlet Class         | Methods   |
| ------------------- | --------------------- | --------- |
| `/login`            | LoginServlet          | GET, POST |
| `/register`         | RegisterServlet       | GET, POST |
| `/logout`           | LogoutServlet         | GET       |
| `/profile`          | ProfileServlet        | GET, POST |
| `/admin/users`      | UserManagementServlet | GET, POST |
| `/admin/categories` | CategoryServlet       | GET, POST |
| `/admin/products`   | ProductServlet        | GET, POST |
| `/admin/markets`    | MarketServlet         | GET, POST |
| `/admin/regions`    | RegionServlet         | GET, POST |
| `/prices/entry`     | PriceEntryServlet     | GET, POST |
| `/prices/list`      | PriceListServlet      | GET       |
| `/prices/edit`      | PriceEditServlet      | GET, POST |
| `/prices/compare`   | PriceCompareServlet   | GET       |
| `/prices/trends`    | PriceTrendServlet     | GET       |
| `/alerts`           | AlertServlet          | GET, POST |
| `/reports`          | ReportServlet         | GET       |

---

## Design Files

UI/UX design files, wireframes, mockups, and prototypes for AgriPrice KE. All design assets are centrally managed.

### Design File Access

- **Figma Design System**: [https://www.figma.com/design/ZkAIYImhF6poMwlFxfOEJM/Untitled?node-id=1-3&t=Nz2JfNdVM1Et12CH-1](https://www.figma.com/design/ZkAIYImhF6poMwlFxfOEJM/Untitled?node-id=1-3&t=Nz2JfNdVM1Et12CH-1)
- **PDF Exports**: Stored in `design/` folder, committed to Git for reference
- **Local PDF**: `design/Soko Intel design.pdf` (added from `/home/mukanga/Downloads/Soko Intel design.pdf`)
- **Prototype Link**: [https://www.figma.com/proto/ZkAIYImhF6poMwlFxfOEJM/Untitled?node-id=1-3&t=Nz2JfNdVM1Et12CH-1](https://www.figma.com/proto/ZkAIYImhF6poMwlFxfOEJM/Untitled?node-id=1-3&t=Nz2JfNdVM1Et12CH-1) _(interactive prototype for testing)_

---

## Getting Started

### Prerequisites
- Java 17+ (JDK)
- Apache Tomcat 10
- PostgreSQL 16
- Apache Maven 3.8+

### Verify your environment
```bash
java -version
mvn -version
psql --version
```

### Setup steps
1. Clone the repository
2. Create PostgreSQL database: `agri_price_tracker`
3. Run database setup: `psql -U postgres -d agri_price_tracker -f sql/schema.sql`
4. Load sample data: `psql -U postgres -d agri_price_tracker -f sql/sample_data.sql`
5. Configure database connection in `src/com/agriprice/utils/db.properties`
6. Build the project: `mvn clean compile`
7. Deploy to Tomcat: Copy `target/agri-price-tracker.war` to Tomcat's webapps folder
8. Start Tomcat and access at `http://localhost:8080/agri-price-tracker`

### Test login credentials
- **Admin:** admin@agriprice.ke / admin123
- **Market Agent:** agent@agriprice.ke / agent123
- **Farmer:** farmer@agriprice.ke / farmer123
