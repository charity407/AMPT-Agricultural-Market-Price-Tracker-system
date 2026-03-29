
# 🌾 AgriPrice KE — Agricultural Market Price Tracker

> A web-based system to monitor and display real-time agricultural product prices across Kenyan markets.
> Built with plain Java Servlets + JSP + JDBC + PostgreSQL — no Spring Boot, no Hibernate.

**Institution:** Chuka University · 2025/2026
**Team Size:** 7 Members
**Timeline:** March 9 – April 6, 2026 (4 Weeks)
**Server:** Apache Tomcat 10 · **Database:** PostgreSQL 16 · **Build Tool:** Maven

---

## 📑 Table of Contents

- [🌾 AgriPrice KE — Agricultural Market Price Tracker](#-agriprice-ke--agricultural-market-price-tracker)
  - [📑 Table of Contents](#-table-of-contents)
  - [Project Overview](#project-overview)
  - [Tech Stack](#tech-stack)
  - [Team Members \& Roles](#team-members--roles)
  - [File Structure](#file-structure)
  - [Design Files](#design-files)
    - [Design File Locations](#design-file-locations)
    - [Design File Access](#design-file-access)
    - [Design Ownership \& Modification Rules](#design-ownership--modification-rules)
    - [Wireframe \& Mockup Checklist](#wireframe--mockup-checklist)
  - [Where Each Member Stores Their Code](#where-each-member-stores-their-code)
    - [M1 — Database Admin](#m1--database-admin)
    - [M2 — Auth \& Users](#m2--auth--users)
    - [M3 — Products \& Markets](#m3--products--markets)
    - [M4 — PM + Prices \& Alerts Backend](#m4--pm--prices--alerts-backend)
    - [M5 — Core UI](#m5--core-ui)
    - [M6 — Feature Pages](#m6--feature-pages)
    - [M7 — QA \& Documentation](#m7--qa--documentation)
  - [Shared Files — Rules](#shared-files--rules)
  - [Database Schema](#database-schema)
  - [URL Mappings](#url-mappings)
  - [Session Attributes](#session-attributes)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Verify your environment](#verify-your-environment)
    - [Setup steps](#setup-steps)
    - [Test login credentials](#test-login-credentials)
  - [Git Workflow](#git-workflow)
    - [Branch naming guide](#branch-naming-guide)
  - [Naming Conventions](#naming-conventions)
  - [Golden Rules](#golden-rules)
  - [4-Week Timeline](#4-week-timeline)
  - [Deployment (Week 4)](#deployment-week-4)

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

## Team Members & Roles

| Member | Role                 | Key Responsibility                           |
| ------ | -------------------- | -------------------------------------------- |
| M1     | Database Admin (DBA) | schema.sql, DBConnection.java, sample data   |
| M2     | Auth & Users         | Login, Register, Session, User management    |
| M3     | Products & Markets   | Categories, Products, Markets, Regions       |
| M4     | PM + Prices Backend  | GitHub, Tomcat, Price & Alert Servlets       |
| M5     | Core UI              | style.css, login.html, dashboard.jsp, navbar |
| M6     | Feature Pages        | Price JSPs, trend chart, alerts page         |
| M7     | QA & Documentation   | Test cases, bug tracker, report, user manual |

---

## File Structure

```
agri-price-tracker/
│
├── pom.xml                                  [M4] Maven build file — dependencies
├── .gitignore                               [M4] Excludes db.properties + build output
├── README.md                                [M7] This file
│
├── sql/                                     [M1]
│   ├── schema.sql                           [M1] ⚠ CRITICAL — run first, creates all tables
│   └── sample_data.sql                      [M1] Test data — run after schema.sql
│
├── src/
│   └── com/
│       └── agriprice/
│           │
│           ├── utils/                       [M4]
│           │   ├── DBConnection.java        [M4] ⚠ Shared DB class — used by ALL members
│           │   ├── db.properties            [M4] ⚠ NOT in GitHub — share via WhatsApp
│           │   └── PasswordUtil.java        [M2] SHA-256 password hashing helper
│           │
│           ├── models/                      [ALL] One POJO class per database table
│           │   ├── User.java                [M2] → users table
│           │   ├── Product.java             [M3] → products table
│           │   ├── Category.java            [M3] → categories table
│           │   ├── Market.java              [M3] → markets table
│           │   ├── Region.java              [M3] → regions table
│           │   ├── PriceEntry.java          [M4] → price_entries table
│           │   └── PriceAlert.java          [M4] → price_alerts table
│           │
│           └── servlets/                    [ALL] One Servlet per feature area
│               │
│               ├── LoginServlet.java        [M2] POST /login
│               ├── RegisterServlet.java     [M2] POST /register
│               ├── LogoutServlet.java       [M2] GET  /logout
│               ├── UserManagementServlet.java [M2] GET+POST /admin/users
│               ├── ProfileServlet.java      [M2] GET+POST /profile
│               ├── SessionFilter.java       [M2] Blocks unauthenticated access
│               │
│               ├── CategoryServlet.java     [M3] GET+POST /admin/categories
│               ├── ProductServlet.java      [M3] GET+POST /admin/products
│               ├── MarketServlet.java       [M3] GET+POST /admin/markets
│               ├── RegionServlet.java       [M3] GET+POST /admin/regions
│               │
│               ├── PriceEntryServlet.java   [M4] GET+POST /prices/entry
│               ├── PriceListServlet.java    [M4] GET      /prices/list
│               ├── PriceEditServlet.java    [M4] GET+POST /prices/edit
│               ├── PriceCompareServlet.java [M4] GET      /prices/compare
│               ├── PriceTrendServlet.java   [M4] GET      /prices/trends
│               ├── AlertServlet.java        [M4] GET+POST /alerts
│               ├── AlertCheckServlet.java   [M4] Checks thresholds, triggers SMS
│               └── ReportServlet.java       [M4] GET      /reports (CSV export)
│
└── WebContent/
    │
    ├── login.html                           [M5] Public login page
    ├── register.html                        [M5] Public registration page
    │
    ├── WEB-INF/
    │   └── web.xml                          [M4] ⚠ Master URL map — check before adding Servlet
    │
    ├── css/
    │   └── style.css                        [M5] ⚠ Shared stylesheet — M5 owns, ask before editing
    │
    └── jsp/
        ├── dashboard.jsp                    [M5] Main dashboard after login
        ├── navbar.jsp                       [M5] Navigation bar — included by all pages
        ├── error.jsp                        [M5] Generic error page
        │
        ├── admin/                           [M5]
        │   ├── users.jsp                    [M5] Admin user management table
        │   ├── products.jsp                 [M5] Admin products management
        │   └── markets.jsp                  [M5] Admin markets management
        │
        ├── prices/                          [M6]
        │   ├── list.jsp                     [M6] Price list table with filters
        │   ├── entry.jsp                    [M6] Price entry form
        │   ├── compare.jsp                  [M6] Side-by-side market price comparison
        │   └── history.jsp                  [M6] Price history for a product
        │
        ├── trends/                          [M6]
        │   └── trends.jsp                   [M6] Line chart using Chart.js CDN
        │
        ├── alerts/                          [M6]
        │   └── alerts.jsp                   [M6] Price alert management page
        │
        └── profile/                         [M6]
            └── profile.jsp                  [M6] User profile and settings

docs/                                        [M7]
├── test_cases.md                            [M7] Full test case document
├── bug_tracker.md                           [M7] Running list of bugs and their status
├── user_manual.md                           [M7] How to use the system (end-user guide)
└── final_report.md                          [M7] Group project report
```

---

## Design Files

UI/UX design files, wireframes, mockups, and prototypes for AgriPrice KE. All design assets are centrally managed to ensure consistency across the application.

### Design File Locations

| Design Asset                | Location/Link                                        | Owner | Format         |
| --------------------------- | ---------------------------------------------------- | ----- | -------------- |
| **Desktop Wireframes**       | `design/wireframes/desktop/`                         | M5    | Figma / PDF    |
| **Mobile Wireframes**        | `design/wireframes/mobile/`                          | M5    | Figma / PDF    |
| **UI Component Library**     | `design/components/`                                 | M5    | Figma          |
| **Style Guide & Brand Kit**  | `design/brand-kit/agriprice-style-guide.pdf`         | M5    | PDF / Figma    |
| **Dashboard Mockup**         | `design/mockups/dashboard-admin.fig`                 | M5    | Figma          |
| **Login/Register Screens**   | `design/mockups/auth-screens.fig`                    | M5    | Figma          |
| **Price Entry Form**         | `design/mockups/price-entry.fig`                     | M6    | Figma          |
| **Price List & Filters**     | `design/mockups/price-list.fig`                      | M6    | Figma          |
| **Market Comparison View**   | `design/mockups/compare-markets.fig`                 | M6    | Figma          |
| **Trend Chart / Analytics**  | `design/mockups/trends-chart.fig`                    | M6    | Figma          |
| **Price Alerts Page**        | `design/mockups/alerts-management.fig`               | M6    | Figma          |
| **User Profile Page**        | `design/mockups/user-profile.fig`                    | M6    | Figma          |
| **Admin Management Pages**   | `design/mockups/admin-users-products-markets.fig`    | M5/M6 | Figma          |
| **Responsive Breakpoints**   | `design/responsive/breakpoints.md`                   | M5    | Markdown       |
| **Accessibility Guidelines** | `design/guidelines/accessibility.md`                 | M5    | Markdown       |

### Design File Access

- **Figma Design System**: [https://figma.com/...agriprice-ke](https://figma.com) _(shared with M5, M6, M7)_
- **PDF Exports**: Stored in `design/` folder, committed to Git for reference
- **Prototype Link**: [https://www.figma.com/proto/...](https://www.figma.com/proto/) _(interactive prototype for testing)_

### Design Ownership & Modification Rules

| Area                    | Owner | Can Modify                          | Rules                                                          |
| ----------------------- | ----- | ----------------------------------- | -------------------------------------------------------------- |
| **Color Palette**        | M5    | M5 only (discuss changes with M6/M7) | Consistent across all pages; update `style.css` immediately   |
| **Typography/Fonts**     | M5    | M5 only                             | Define once in `style.css`; all pages must inherit              |
| **Component Styles**     | M5    | M5 only                             | Buttons, forms, tables, modals — maintain library consistency  |
| **Page Layouts**         | M5/M6 | M5 (core UI), M6 (feature pages)   | Ask M5 before creating new layout patterns                     |
| **Responsive Design**     | M5    | M5 only                             | Ensure mobile-first; test at 320px, 768px, 1024px, 1440px     |
| **Ad-hoc Mockups**       | M6    | M6 (for feature pages)              | Keep in sync with M5's design system; request review before PR |

### Wireframe & Mockup Checklist

Before implementing any JSP/HTML page, ensure:

- ✅ Wireframe approved by project stakeholder
- ✅ Mockup created in Figma (linked in this table)
- ✅ Component styles defined in `style.css`
- ✅ Responsive breakpoints tested
- ✅ Accessibility standards met (WCAG 2.1 AA minimum)
- ✅ Design review completed by M5 (Core UI)
- ✅ Code review includes design compliance check

---

## Where Each Member Stores Their Code

### M1 — Database Admin
```
sql/schema.sql
sql/sample_data.sql
src/com/agriprice/utils/DBConnection.java
src/com/agriprice/utils/db.properties
```

### M2 — Auth & Users
```
src/com/agriprice/models/User.java
src/com/agriprice/utils/PasswordUtil.java
src/com/agriprice/servlets/LoginServlet.java
src/com/agriprice/servlets/RegisterServlet.java
src/com/agriprice/servlets/LogoutServlet.java
src/com/agriprice/servlets/UserManagementServlet.java
src/com/agriprice/servlets/ProfileServlet.java
src/com/agriprice/servlets/SessionFilter.java
```

### M3 — Products & Markets
```
src/com/agriprice/models/Product.java
src/com/agriprice/models/Category.java
src/com/agriprice/models/Market.java
src/com/agriprice/models/Region.java
src/com/agriprice/servlets/CategoryServlet.java
src/com/agriprice/servlets/ProductServlet.java
src/com/agriprice/servlets/MarketServlet.java
src/com/agriprice/servlets/RegionServlet.java
```

### M4 — PM + Prices & Alerts Backend
```
pom.xml
.gitignore
WebContent/WEB-INF/web.xml
src/com/agriprice/utils/DBConnection.java
src/com/agriprice/utils/db.properties
src/com/agriprice/models/PriceEntry.java
src/com/agriprice/models/PriceAlert.java
src/com/agriprice/servlets/PriceEntryServlet.java
src/com/agriprice/servlets/PriceListServlet.java
src/com/agriprice/servlets/PriceEditServlet.java
src/com/agriprice/servlets/PriceCompareServlet.java
src/com/agriprice/servlets/PriceTrendServlet.java
src/com/agriprice/servlets/AlertServlet.java
src/com/agriprice/servlets/AlertCheckServlet.java
src/com/agriprice/servlets/ReportServlet.java
```

### M5 — Core UI
```
WebContent/login.html
WebContent/register.html
WebContent/css/style.css
WebContent/jsp/dashboard.jsp
WebContent/jsp/navbar.jsp
WebContent/jsp/error.jsp
WebContent/jsp/admin/users.jsp
WebContent/jsp/admin/products.jsp
WebContent/jsp/admin/markets.jsp
```

### M6 — Feature Pages
```
WebContent/jsp/prices/list.jsp
WebContent/jsp/prices/entry.jsp
WebContent/jsp/prices/compare.jsp
WebContent/jsp/prices/history.jsp
WebContent/jsp/trends/trends.jsp
WebContent/jsp/alerts/alerts.jsp
WebContent/jsp/profile/profile.jsp
```

### M7 — QA & Documentation
```
README.md
docs/test_cases.md
docs/bug_tracker.md
docs/user_manual.md
docs/final_report.md
```

---

## Shared Files — Rules

These files are used by the whole team. **Do not edit them without permission from the owner.**

| File                              | Owner | Rule                                                             |
| --------------------------------- | ----- | ---------------------------------------------------------------- |
| `pom.xml`                         | M4    | Tell M4 before adding any new dependency                         |
| `WebContent/WEB-INF/web.xml`      | M4    | Check your URL is not already taken. Ask M4 to add your mapping. |
| `src/.../utils/DBConnection.java` | M4    | Never modify alone. If it breaks, everyone is blocked.           |
| `src/.../utils/db.properties`     | M4    | NOT on GitHub. Receive from M4 via WhatsApp. Keep local only.    |
| `WebContent/css/style.css`        | M5    | Ask M5 to add new styles — do not edit the shared CSS yourself.  |
| `WebContent/jsp/navbar.jsp`       | M5    | Included by every page — notify M5 before making any change.     |
| `.gitignore`                      | M4    | Excludes db.properties, *.class, target/, IDE files.             |
| `sql/schema.sql`                  | M1    | Request column/table changes from M1 — do not alter directly.    |

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

| URL Pattern         | Servlet Class         | Owner | Methods   |
| ------------------- | --------------------- | ----- | --------- |
| `/login`            | LoginServlet          | M2    | GET, POST |
| `/register`         | RegisterServlet       | M2    | GET, POST |
| `/logout`           | LogoutServlet         | M2    | GET       |
| `/profile`          | ProfileServlet        | M2    | GET, POST |
| `/admin/users`      | UserManagementServlet | M2    | GET, POST |
| `/admin/categories` | CategoryServlet       | M3    | GET, POST |
| `/admin/products`   | ProductServlet        | M3    | GET, POST |
| `/admin/markets`    | MarketServlet         | M3    | GET, POST |
| `/admin/regions`    | RegionServlet         | M3    | GET, POST |
| `/prices/entry`     | PriceEntryServlet     | M4    | GET, POST |
| `/prices/list`      | PriceListServlet      | M4    | GET       |
| `/prices/edit`      | PriceEditServlet      | M4    | GET, POST |
| `/prices/compare`   | PriceCompareServlet   | M4    | GET       |
| `/prices/trends`    | PriceTrendServlet     | M4    | GET       |
| `/alerts`           | AlertServlet          | M4    | GET, POST |
| `/reports`          | ReportServlet         | M4    | GET       |

---

## Session Attributes

Every member **must** use these exact session attribute names.
Wrong names will cause `NullPointerException` at runtime.

```java
// Set by LoginServlet (M2) after successful login:
session.setAttribute("userId",   user.getUserId());   // Integer
session.setAttribute("userRole", user.getRole());     // String: "ADMIN" | "AGENT" | "FARMER" | "TRADER" | "CONSUMER"
session.setAttribute("userName", user.getFullName()); // String

// Read in any Servlet:
int    userId   = (int)    session.getAttribute("userId");
String userRole = (String) session.getAttribute("userRole");
String userName = (String) session.getAttribute("userName");
```

---

## Getting Started

### Prerequisites
- JDK 17
- Apache Maven 3.x
- PostgreSQL 16
- Apache Tomcat 10
- Git 2.x

### Verify your environment
Open a new terminal and run:
```bash
java -version      # → openjdk 17.x
javac -version     # → javac 17.x
mvn -version       # → Apache Maven 3.x
git --version      # → git 2.x
psql --version     # → PostgreSQL 16.x
```

### Setup steps
```bash
# 1. Clone the repository
git clone https://github.com/REPO_OWNER/agri-price-tracker.git
cd agri-price-tracker

# 2. Create your working branch
git checkout -b feature/memberN-your-name

# 3. Get db.properties from M4 (via WhatsApp) and place it at:
#    src/com/agriprice/utils/db.properties

# 4. Create the database
psql -U postgres -c "CREATE DATABASE agri_price_tracker;"

# 5. Run schema and sample data (once M1 has pushed them)
psql -U postgres -d agri_price_tracker -f sql/schema.sql
psql -U postgres -d agri_price_tracker -f sql/sample_data.sql

# 6. Build the project
mvn compile

# 7. Deploy to Tomcat
mvn package
# Copy target/agri-price-tracker.war to Tomcat's webapps/ folder

# 8. Open in browser
# http://localhost:8080/agri-price-tracker/login
```

### Test login credentials
After running `sample_data.sql`, use these accounts:

| Email                 | Password    | Role     |
| --------------------- | ----------- | -------- |
| admin@agriprice.ke    | Password123 | ADMIN    |
| agent@agriprice.ke    | Password123 | AGENT    |
| farmer@agriprice.ke   | Password123 | FARMER   |
| trader@agriprice.ke   | Password123 | TRADER   |
| consumer@agriprice.ke | Password123 | CONSUMER |

---

## Git Workflow

```bash
# Every morning — pull latest before starting work
git checkout main
git pull origin main

# Create your branch (once per feature / week)
git checkout -b feature/memberN-description

# Commit your work (at least once every day — end of day)
git add .
git commit -m "feat: LoginServlet + User.java POJO"

# Push your branch
git push origin feature/memberN-description

# Open a Pull Request on GitHub → M4 (PM) reviews and merges into main
```

> ⚠ **Never push directly to `main`.** Always use a feature branch and open a Pull Request.
> ⚠ **Never commit `db.properties`.** It is in `.gitignore` for a reason — it contains your password.
> ⚠ **Never edit another member's files** without telling them first.

### Branch naming guide
```
feature/member1-database
feature/member2-auth
feature/member3-products
feature/member4-prices
feature/member5-core-ui
feature/member6-feature-pages
feature/member7-docs
fix/short-description-of-bug
```

---

## Naming Conventions

| Type          | Convention  | Example                               |
| ------------- | ----------- | ------------------------------------- |
| Java classes  | PascalCase  | `LoginServlet.java` `PriceEntry.java` |
| Java packages | lowercase   | `com.agriprice.servlets`              |
| JSP files     | lowercase   | `entry.jsp` `price-list.jsp`          |
| SQL files     | snake_case  | `schema.sql` `sample_data.sql`        |
| CSS classes   | kebab-case  | `.price-table` `.nav-bar`             |
| Git branches  | kebab-case  | `feature/member2-auth`                |
| Constants     | UPPER_SNAKE | `MAX_PRICE` `DEFAULT_ROLE`            |

---

## Golden Rules

1. **One connection class only** — always use `DBConnection.getConnection()`, never create your own `DriverManager` call.

2. **Session attribute names are fixed** — use `userId`, `userRole`, `userName` exactly. Wrong names cause null pointer errors.

3. **Check `web.xml` before every new Servlet** — confirm your URL pattern is not already mapped by another member.

4. **Never commit `db.properties`** — it is in `.gitignore`. Share it via WhatsApp only.

5. **Shared files need permission** — `style.css` (ask M5), `web.xml` (ask M4), `schema.sql` (ask M1), `DBConnection.java` (ask M4).

6. **One feature = one branch** — never work directly on `main`. Branch → Code → PR → Merge.

---

## 4-Week Timeline

| Week | Dates        | Focus                          | Milestone                                 |
| ---- | ------------ | ------------------------------ | ----------------------------------------- |
| W1   | Mar 9–15     | Setup, DB schema, config files | 🚀 Project Kickoff — repo + structure live |
| W2   | Mar 16–22    | Auth backend + static UI       | 🔑 Register → Login → Dashboard working    |
| W3   | Mar 23–29    | Price features, trends, alerts | 📊 All features connected end-to-end       |
| W4   | Mar 30–Apr 6 | Polish, deploy, presentation   | 🎓 Defence Day                             |

---

## Deployment (Week 4)

- **Database:** [Neon PostgreSQL](https://neon.tech) (free tier) — M1 migrates the schema
- **App server:** Railway.app or Oracle Cloud Always Free — M4 deploys the `.war` file
- **Only change needed:** update `db.properties` with the Neon JDBC URL

```properties
# Week 4 — switch to this
db.url=jdbc:postgresql://ep-xxxx.us-east-1.aws.neon.tech/agri_price_tracker?sslmode=require
db.username=your_neon_username
db.password=your_neon_password
```

---

*Last updated: March 2026 · AgriPrice KE Team · Chuka University*
