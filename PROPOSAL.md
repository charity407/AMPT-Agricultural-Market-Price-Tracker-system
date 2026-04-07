# AMPT — Agricultural Market Price Tracker
## Project Proposal

---

# TITLE PAGE

**Project Title:** Agricultural Market Price Tracker (AMPT) — AgriPrice KE

**Institution:** Chuka University

**School:** School of Computing and Informatics

**Department:** Department of Computer Science

**Course Title:** Software Engineering Project / System Development

**Course Code:** [Course Code]

**Academic Year:** 2025 / 2026

**Submission Date:** April 2026

---

### Group Members

| # | Full Name | Registration No. | Role |
|---|-----------|-----------------|------|
| 1 | Charity Muigai | [Reg. No.] | Database Design & Setup |
| 2 | [Member 2 Full Name] | [Reg. No.] | Authentication & User Management |
| 3 | Levi Kisaka | [Reg. No.] | Backend Development & Products Module |
| 4 | Lewis Njega | [Reg. No.] | Price Management & UI Design |
| 5 | Lucy Ann Mwangi | [Reg. No.] | [Module / Role] |

**Supervisor:** [Supervisor Name]

---

---

# TABLE OF CONTENTS

- [TITLE PAGE](#title-page)
- [ABSTRACT](#abstract)
- [CHAPTER ONE: INTRODUCTION](#chapter-one-introduction)
  - [1.1 Background of the Study](#11-background-of-the-study)
  - [1.2 Problem Statement](#12-problem-statement)
  - [1.3 General Objective](#13-general-objective)
  - [1.4 Specific Objectives](#14-specific-objectives)
  - [1.5 Research Questions](#15-research-questions)
  - [1.6 Justification](#16-justification)
  - [1.7 Proposed Solution](#17-proposed-solution)
- [CHAPTER TWO: LITERATURE REVIEW](#chapter-two-literature-review)
  - [2.1 Introduction](#21-introduction)
  - [2.2 Review of Similar Systems](#22-review-of-similar-systems)
  - [2.3 Gaps Identified in Existing Systems](#23-gaps-identified-in-existing-systems)
  - [2.4 Summary](#24-summary)
- [CHAPTER THREE: METHODOLOGY](#chapter-three-methodology)
  - [3.1 Research Design](#31-research-design)
  - [3.2 System Development Methodology](#32-system-development-methodology)
  - [3.3 Data Collection Methods](#33-data-collection-methods)
  - [3.4 Tools and Technologies](#34-tools-and-technologies)
  - [3.5 Project Schedule](#35-project-schedule)
- [CHAPTER FOUR: REQUIREMENTS ANALYSIS](#chapter-four-requirements-analysis)
  - [4.1 Introduction](#41-introduction)
  - [4.2 Functional Requirements](#42-functional-requirements)
  - [4.3 Non-Functional Requirements](#43-non-functional-requirements)
  - [4.4 Domain Requirements](#44-domain-requirements)
  - [4.5 Domain Model](#45-domain-model)
  - [4.6 Use Cases](#46-use-cases)
  - [4.7 Use Case Diagrams](#47-use-case-diagrams)
- [CHAPTER FIVE: SYSTEM DESIGN SPECIFICATION](#chapter-five-system-design-specification)
  - [5.1 System Architecture](#51-system-architecture)
  - [5.2 Database Design](#52-database-design)
  - [5.3 Flowcharts and Activity Diagrams](#53-flowcharts-and-activity-diagrams)
  - [5.4 Interface Design Overview](#54-interface-design-overview)
- [CHAPTER SIX: SYSTEM IMPLEMENTATION AND TESTING](#chapter-six-system-implementation-and-testing)
  - [6.1 Implementation Language](#61-implementation-language)
  - [6.2 Key Language Features Used](#62-key-language-features-used)
  - [6.3 Search Algorithms Implemented](#63-search-algorithms-implemented)
  - [6.4 Testing Strategy](#64-testing-strategy)
  - [6.5 Source Code](#65-source-code)
- [CHAPTER SEVEN: CONCLUSION AND RECOMMENDATION](#chapter-seven-conclusion-and-recommendation)
  - [7.1 Conclusion](#71-conclusion)
  - [7.2 Recommendations](#72-recommendations)
- [REFERENCES](#references)

---

---

# ABSTRACT

Agriculture is the backbone of Kenya's economy, employing over 40% of the total population
and contributing approximately 26% of the Gross Domestic Product (GDP). Despite this
significance, smallholder farmers and market participants continue to operate with limited
access to real-time or near-real-time price information. The result is a persistent
information asymmetry that disadvantages farmers, enables price manipulation by
middlemen, and undermines food security planning by government agencies.

This project proposes and presents the **Agricultural Market Price Tracker (AMPT)** — a
web-based information system, branded *AgriPrice KE*, designed to monitor, record,
compare, and disseminate agricultural commodity prices across Kenyan markets. The system
is built using Java Servlets, JavaServer Pages (JSP), JDBC, and PostgreSQL, following the
Model-View-Controller (MVC) architectural pattern, hosted on Apache Tomcat 10.

AMPT supports multiple user roles — Administrators, Market Agents, Farmers, Traders, and
Consumers. Market agents record daily commodity prices at their respective markets. Farmers
and other stakeholders can query current prices, compare prices across markets, track price
trends over time, set configurable price alerts, and download summary reports. Administrators
manage the user base, product catalogue, market registry, and system configuration.

The system covers 8 Kenyan regions, 29+ markets, and a catalogue of 35+ agricultural
commodities spanning cereals, legumes, vegetables, fruits, root crops, livestock, dairy,
poultry, and cash crops. The system addresses critical gaps identified in existing solutions,
particularly the lack of a centralised, role-aware, and locally-contextualised platform for
Kenyan agricultural price intelligence.

---

---

# CHAPTER ONE: INTRODUCTION

## 1.1 Background of the Study

Kenya's agricultural sector plays a central role in the nation's socioeconomic fabric. The
sector supports livelihoods for millions of rural households and drives export earnings
through commodities such as tea, coffee, flowers, and horticultural produce. However,
despite this prominence, access to timely and accurate market price information remains a
critical challenge for the majority of agricultural stakeholders, particularly smallholder
farmers.

Market information systems have been studied extensively as tools for improving market
efficiency. The fundamental premise is straightforward: when farmers, traders, and
consumers have access to the same price information, markets function more competitively,
middlemen's price arbitrage is reduced, and farmers are empowered to make better-informed
selling decisions. Mobile technology and internet penetration in Kenya, now exceeding 22
million internet users (CA Kenya, 2024), creates a viable infrastructure for digital
market information delivery.

Historically, agricultural price dissemination in Kenya relied on radio broadcasts, printed
market bulletins, and informal word-of-mouth networks. These channels suffer from
significant time lags, geographic limitations, and lack of granularity. The Kenya Markets
Trust, the East Africa Grain Council, and the National Farmers' Information Service (NAFIS)
have made efforts to provide price data, but these remain fragmented, infrequently updated,
and not easily accessible to end users in real time.

The emergence of web-based systems and mobile applications has created new opportunities
to bridge this information gap. This project responds to that opportunity by developing AMPT
— a comprehensive, web-based price monitoring and dissemination system tailored to the
Kenyan agricultural context.

## 1.2 Problem Statement

Smallholder farmers and other agricultural market participants in Kenya consistently face
an information asymmetry regarding commodity prices. Farmers often sell produce at markets
without knowing prices at competing markets, while buyers exploit this ignorance to
negotiate unfairly low prices. The consequences include:

- **Income losses for farmers** who sell at below-market prices due to lack of comparative
  price knowledge.
- **Inefficient market allocation** where produce travels long distances unnecessarily
  because price signals are absent or distorted.
- **Food security risks** arising from poor production planning driven by price uncertainty.
- **Lack of accountability** in market pricing, enabling cartel behaviour and price fixing.
- **Inadequate policy data** for government agencies that need timely price trends to make
  subsidy, intervention, and food importation decisions.

Existing digital solutions (detailed in Chapter Two) either focus on a narrow set of
commodities, operate at a national aggregate level without market-level granularity, lack
role-based access for data entry integrity, or are not maintained with current data.

There is therefore a need for a dedicated, locally-contextualised, web-based system that
collects, stores, and presents agricultural market price data at the individual market
level, across the full breadth of Kenyan agricultural commodities, with appropriate access
controls and analytical features.

## 1.3 General Objective

To design and implement a web-based Agricultural Market Price Tracker (AMPT) system that
enables real-time collection, storage, comparison, and dissemination of agricultural
commodity prices across Kenyan markets, thereby reducing information asymmetry among
farmers, traders, and other market participants.

## 1.4 Specific Objectives

1. To analyse the existing information needs of agricultural market stakeholders in Kenya
   and identify functional requirements for a price tracking system.

2. To design a relational database schema capable of storing price data, market metadata,
   commodity catalogues, user accounts, and alert configurations for the Kenyan agricultural
   market context.

3. To implement a role-based web application using Java Servlets and JSP that supports
   price entry by market agents, price querying by farmers and consumers, and administration
   of the system by authorised administrators.

4. To implement price comparison, trend analysis, alert notification, and reporting features
   that enable data-driven decision making for agricultural market participants.

5. To implement and demonstrate standard search and sorting algorithms within the system to
   facilitate efficient retrieval and presentation of price data.

6. To test the system against defined functional and non-functional requirements to validate
   correctness, usability, and performance.

## 1.5 Research Questions

1. What are the primary information needs of smallholder farmers and market agents regarding
   agricultural commodity pricing in Kenya, and what features must a price tracking system
   possess to address those needs effectively?

2. How can a role-based web system be designed and implemented to ensure that price data
   entered by market agents is accurate, consistent, and free from unauthorised manipulation?

3. What database design and query optimisation strategies are most appropriate for storing
   and retrieving large volumes of time-series agricultural price data across multiple
   markets and commodities?

4. How effective are configurable price alert mechanisms in informing farmers of significant
   price movements, and what threshold parameters yield the most actionable notifications?

5. To what extent does access to historical price trend data and multi-market price
   comparisons influence the selling and buying decisions of agricultural market participants?

6. What algorithms and system architecture choices best balance response time performance
   and scalability for a multi-user agricultural price tracking web application?

## 1.6 Justification

**Economic Impact:** Price information asymmetry costs Kenyan smallholder farmers an
estimated 10–30% of potential income per season (World Bank, 2022). A system that reduces
this asymmetry directly translates to improved farm incomes and better living standards for
rural households.

**Policy Relevance:** Kenya's Big Four Agenda and the subsequent Bottom-Up Economic
Transformation Agenda (BETA) identify food security as a pillar. Accurate, real-time price
data enables evidence-based policy interventions, subsidies, and strategic food reserves
management.

**Academic Contribution:** This project demonstrates the application of core software
engineering principles — requirements analysis, object-oriented design, MVC architecture,
relational database design, and algorithm implementation — to a real-world, socially
significant problem domain.

**Technological Feasibility:** Kenya's growing internet penetration (>50% urban, >20%
rural) and the proliferation of Android smartphones at affordable price points make
web-based market information systems practically viable for the target users.

**Institutional Relevance:** Chuka University is located in a primarily agricultural
region (Tharaka-Nithi County). The institution and its surrounding community are direct
potential beneficiaries of such a system, giving this project immediate local relevance
beyond its academic value.

## 1.7 Proposed Solution

The proposed solution is **AgriPrice KE** — a web-based Agricultural Market Price Tracker
built on the following design principles:

- **Role-Based Access:** Five distinct user roles (Admin, Market Agent, Farmer, Trader,
  Consumer) with permissions tailored to each role's data access and entry needs.

- **Market-Level Granularity:** Prices are recorded and queried at the individual market
  level, linked to a geographic region hierarchy (Region → Market).

- **Comprehensive Commodity Catalogue:** 35+ commodities across 9 categories, covering the
  full breadth of Kenyan agricultural production.

- **Analytical Features:** Multi-market price comparison, time-series trend analysis,
  configurable price alerts, and downloadable reports.

- **Standard Technology Stack:** Java 17 Servlets + JSP (MVC), JDBC, PostgreSQL 16, Apache
  Tomcat 10 — no heavyweight frameworks — demonstrating foundational software engineering
  competencies.

- **Algorithm Demonstration:** Linear search, binary search, bubble sort, and quicksort
  implemented in Java within the application logic, with complexity analysis documented.

---

---

# CHAPTER TWO: LITERATURE REVIEW

## 2.1 Introduction

This chapter reviews existing agricultural market information systems, both globally and
within the East African context, with particular focus on their features, limitations, and
the gaps that motivate the development of AMPT. The review draws on deployed systems,
academic research, and reports from agricultural development organisations.

## 2.2 Review of Similar Systems

### 2.2.1 ESOKO (Ghana/Pan-Africa)

**Overview:** Esoko is a commercial platform operating in multiple African countries that
collects and distributes agricultural market prices via SMS, mobile app, and web interface.
Launched in Ghana in 2008, it expanded across sub-Saharan Africa.

**Features:** Price alerts via SMS, market surveys by field agents, bulk messaging to
farmers, price visualisation dashboards.

**Limitations for the Kenyan Context:**
- Commercial SaaS model with per-user licensing costs, making it inaccessible for
  small farmer cooperatives or county government deployment.
- Limited Kenyan market coverage — focuses more on West African markets.
- No open-source or self-hostable version for institutional customisation.
- SMS-centric design is not optimised for smartphones or web browsing.

### 2.2.2 NAFIS — National Farmers' Information Service (Kenya)

**Overview:** A Kenyan government portal (nafis.go.ke) managed by the Ministry of
Agriculture, providing extension information and some market pricing data.

**Features:** Crop husbandry guides, pest management information, some commodity price
listings.

**Limitations:**
- Price data is irregularly updated and often weeks behind current market conditions.
- No role-based access — no mechanism for market agents to directly input prices.
- No price trend visualisation or historical data exploration.
- No price alert or notification system.
- Interface is dated and not optimised for mobile devices.
- No multi-market comparison functionality.

### 2.2.3 East Africa Grain Council (EAGC) — Price Monitoring System

**Overview:** The EAGC operates a grain price monitoring network across East Africa,
publishing weekly price bulletins for maize, wheat, beans, and related commodities.

**Features:** Weekly price bulletins (PDF/web), regional price comparisons, seasonal
price trend reports.

**Limitations:**
- Restricted to grain commodities — does not cover vegetables, fruits, livestock, dairy,
  or poultry.
- Weekly publication cycle is too infrequent for market participants making daily decisions.
- No user accounts, no personalised alerts, no role-based data entry.
- Primarily designed for policy analysts and agribusiness, not individual farmers.

### 2.2.4 Reuters Market Light (India)

**Overview:** A mobile-based agricultural information service launched in India in 2007.
Provided localised, personalised market price SMS updates to farmers.

**Features:** Personalised SMS alerts, weather forecasts, crop advisory.

**Limitations:**
- Designed for the Indian context; commodities, units, and markets are not applicable
  to Kenya.
- Discontinued in 2015, demonstrating sustainability challenges for commercial models
  in emerging markets.
- SMS-only; no web dashboard for trend analysis or reporting.

### 2.2.5 Farmcrowdy Price Tracker (Nigeria)

**Overview:** A Nigerian agri-tech platform with a price component allowing users to
track commodity prices across Nigerian markets.

**Features:** Price listings, some trend data, mobile app.

**Limitations:**
- Nigeria-specific data — not applicable or deployable for Kenyan markets without
  substantial reconfiguration.
- No open architecture for institutional self-hosting.
- Limited analytical depth: no cross-market comparison, no configurable alerts.

### 2.2.6 Academic Systems and Prototypes

Several academic studies have proposed agricultural market information systems. Ochieng
et al. (2020) developed a mobile-based price notification system for maize farmers in
Western Kenya using Android and MySQL. Mutua & Mugo (2021) proposed a web-based system
using PHP/Laravel for horticultural price tracking in Central Kenya.

**Common limitations in academic prototypes:**
- Narrow commodity or geographic scope (single crop, single county).
- No role hierarchy — any user can enter any data.
- No trend analysis or alert features.
- Not deployed beyond the academic setting.

## 2.3 Gaps Identified in Existing Systems

The review reveals the following gaps that AMPT specifically addresses:

| Gap | AMPT Response |
|-----|--------------|
| Existing systems lack role-based data entry integrity | AMPT enforces a 5-role hierarchy; only verified Market Agents can enter price data |
| Price data is updated weekly at best (EAGC, NAFIS) | AMPT supports daily price entry per market per commodity |
| Commodity coverage is narrow (grains only, or single crop) | AMPT covers 35+ commodities across 9 categories |
| No multi-market price comparison in most systems | AMPT provides a dedicated comparison view across any selected markets |
| No configurable user-level price alerts in local systems | AMPT allows any user to set threshold alerts (ABOVE/BELOW) for any product-market combination |
| No time-series trend visualisation in NAFIS or EAGC bulletins | AMPT provides interactive Chart.js trend graphs over 30, 90, 180-day windows |
| Commercial systems have licensing barriers | AMPT is an open, institutionally deployable system built on open-source technologies |
| Academic prototypes lack production-grade features | AMPT includes audit logging (JSONB), anomaly detection flags, CSV report export, and session security |

## 2.4 Summary

The literature review confirms that while various agricultural market information systems
exist globally and in Africa, none fully addresses the combination of real-time data
entry by verified agents, comprehensive commodity coverage, multi-market comparison,
configurable alerts, and open deployability within the Kenyan agricultural context. AMPT
is positioned to bridge these gaps by combining well-established software engineering
patterns (MVC, relational database design, role-based access control) with locally
relevant data structures and features.

---

---

# CHAPTER THREE: METHODOLOGY

## 3.1 Research Design

This project follows an **applied research design**, combining primary data collection
(interviews and observation of market agents and farmers) with secondary research (review
of existing systems and literature) to inform system requirements. The research is both
qualitative (identifying user needs, workflows) and quantitative (evaluating system
performance against defined metrics).

## 3.2 System Development Methodology

AMPT is developed using the **Iterative and Incremental Development (IID)** model,
structured into four major phases aligned with the project timeline:

### Phase 1 — Requirements Analysis (Weeks 4–6)
Elicit, document, and validate functional and non-functional requirements using interviews,
use case modelling, and domain modelling.

### Phase 2 — System Design (Weeks 7–8)
Produce database schema (ERD), system architecture diagrams, MVC component design,
interface wireframes, and activity diagrams for core workflows.

### Phase 3 — Implementation and Testing (Weeks 9–12)
Iteratively implement system modules in Java (Servlets + JDBC), with each module tested
before integration. Unit testing, integration testing, and user acceptance testing (UAT).

### Phase 4 — Presentation and Finalisation (Week 13)
System demonstration, report finalisation, and code submission on CD.

**Rationale for IID:** Agricultural market systems involve evolving requirements as
stakeholder feedback is incorporated. IID allows for mid-development corrections without
the rigidity of the Waterfall model, while providing the structured deliverables required
for academic assessment.

## 3.3 Data Collection Methods

- **Interviews:** Semi-structured interviews with market agents, smallholder farmers,
  and agricultural extension officers to identify functional needs and workflows.
- **Document Analysis:** Review of NAFIS bulletins, EAGC price reports, and county
  agriculture department records to understand existing data structures and formats.
- **Observation:** Direct observation of price data collection workflows at Thika and
  Muranga markets (accessible from Chuka University catchment area).
- **Secondary Research:** Review of academic literature on agricultural market information
  systems in sub-Saharan Africa.

## 3.4 Tools and Technologies

### Development Environment

| Component | Technology | Version |
|-----------|-----------|---------|
| Programming Language | Java SE | 17 (LTS) |
| Web Layer | Jakarta Servlet API | 6.0.0 |
| View Layer | JavaServer Pages (JSP) + JSTL | 3.1.0 / 3.0.1 |
| Database | PostgreSQL | 16 |
| Database Connectivity | JDBC (Direct, no ORM) | via PostgreSQL Driver 42.7.1 |
| Application Server | Apache Tomcat | 10.1 |
| Build Tool | Apache Maven | 3.8+ |
| Frontend | HTML5, CSS3, Vanilla JavaScript | — |
| Data Visualisation | Chart.js | CDN |
| Logging | SLF4J + Logback | 2.0.12 / 1.5.3 |
| Version Control | Git / GitHub | — |
| IDE | Eclipse / IntelliJ IDEA / VS Code | — |

### Architectural Pattern

**Model-View-Controller (MVC):**
- **Model:** Java POJO classes (Product, Market, PriceEntry, PriceAlert, Region, Category)
  and utility classes (DBConnection, AlgorithmUtils).
- **View:** JSP pages with JSTL tags, rendering HTML responses from model attributes.
- **Controller:** Java Servlets handling HTTP GET and POST requests, coordinating DB
  queries via JDBC PreparedStatements and forwarding to JSP views.

### Security Approach
- SQL Injection prevention via `PreparedStatement` parameter binding.
- Session-based authentication (`HttpSession`) with role attribute enforcement.
- Role-based route protection (admin-only servlets check `userRole` session attribute).
- Soft deletes (`is_active` flag) to preserve referential integrity and audit trails.

## 3.5 Project Schedule

| Week(s) | Activity | Deliverable |
|---------|----------|-------------|
| 1–3 | Project setup, technology research, initial DB design | Schema, dev environment |
| 4–6 | Requirements analysis (OOA, use cases, domain model) | Chapter Four |
| 7–8 | System design (architecture, ERD, flowcharts) | Chapter Five |
| 9–12 | Implementation: Auth, Price CRUD, Alerts, Reports, Testing | Working system + Chapter Six |
| 13 | Final presentation and marking | Presentation + CD submission |

---

---

# CHAPTER FOUR: REQUIREMENTS ANALYSIS

## 4.1 Introduction

Requirements analysis was conducted using Object-Oriented Analysis (OOA) techniques,
including use case modelling, domain modelling, and stakeholder interviews. This chapter
presents the system's functional, non-functional, and domain requirements, followed by
a domain model and use case specifications.

## 4.2 Functional Requirements

### FR-01: User Registration and Authentication
- The system shall allow new users to self-register with a full name, email address,
  password, phone number, and role selection.
- The system shall authenticate registered users via email and password.
- Passwords shall be stored as hashed values (not plaintext).
- The system shall maintain user sessions and enforce login for all protected pages.
- The system shall provide a logout mechanism that invalidates the session.

### FR-02: Role-Based Access Control
- The system shall enforce five user roles: **Admin, Market Agent, Farmer, Trader,
  Consumer**.
- Admin users shall have access to all modules.
- Market Agents shall be able to enter and edit price data for their assigned markets.
- Farmers, Traders, and Consumers shall have read-only access to price data.
- The system shall redirect unauthorised access attempts to the login page.

### FR-03: Price Data Entry
- Market Agents shall be able to enter a price record specifying: product, market, unit
  price (KES), date, and optional notes.
- The system shall prevent duplicate price entries for the same product-market-date
  combination using a database unique constraint (UPSERT logic).
- The system shall display a confirmation or error message after each submission.

### FR-04: Price Listing and Search
- The system shall display all price entries in a tabular format with columns: Product,
  Unit Price, Market, Region, and Date.
- The system shall support filtering by crop name, market name, region, and date range.
- Filters shall use case-insensitive matching.

### FR-05: Price Editing
- Authorised users (Agent, Admin) shall be able to edit an existing price entry's unit
  price, date, and notes.
- The edit form shall be pre-populated with the existing values.

### FR-06: Multi-Market Price Comparison
- The system shall allow users to compare the price of a single commodity across multiple
  selected markets simultaneously.
- The comparison shall display the most recent recorded price for each market.

### FR-07: Price Trend Analysis
- The system shall display a time-series line chart of price history for a selected
  product-market combination.
- The user shall be able to select the time window: 30 days, 90 days, or 180 days.

### FR-08: Price Alerts
- Users shall be able to create a price alert by specifying: product, market (optional),
  alert direction (ABOVE/BELOW), and a threshold price.
- The system shall evaluate active alerts against current prices and flag triggered alerts.
- Users shall be able to view, edit, activate/deactivate, and delete their own alerts.

### FR-09: Reporting
- The system shall generate a summary report showing aggregate statistics (count, average,
  minimum, and maximum price) grouped by product and market.
- The system shall support CSV export of price data for download.

### FR-10: Product and Market Administration
- Admin users shall be able to add, view, and soft-delete products and markets.
- Admin users shall be able to manage product categories and geographic regions.

### FR-11: User Management
- Admin users shall be able to view all registered users and update their account status
  (Active/Suspended) and role.

### FR-12: Audit Logging
- The system shall record significant data changes (inserts, updates, deletes) in an
  audit log table with actor identity, action type, entity affected, and timestamp.

## 4.3 Non-Functional Requirements

### NFR-01: Performance
- The system shall respond to standard page requests (price listing, profile) within 3
  seconds under normal load (up to 50 concurrent users on a local server).
- Database queries for price listing shall use indexed columns to achieve sub-second
  query execution.

### NFR-02: Security
- All database interactions shall use `PreparedStatement` to prevent SQL injection.
- User passwords shall not be stored in plaintext.
- All application pages except the login and registration pages shall require an active
  authenticated session.

### NFR-03: Usability
- The system interface shall be responsive and usable on both desktop and mobile
  (smartphone) browsers.
- Form fields shall provide clear labels, placeholders, and validation feedback.
- Navigation shall be consistent across all pages via a persistent header navbar.

### NFR-04: Reliability
- The system shall use `try-with-resources` for all database connections to ensure
  connections are closed even on exception, preventing connection leaks.
- The system shall gracefully handle database unavailability with a user-friendly error
  message rather than a stack trace.

### NFR-05: Maintainability
- The system shall follow the MVC pattern to separate business logic, data access, and
  presentation concerns.
- All database credentials shall be stored in an external properties file (`db.properties`)
  not hardcoded in source code.

### NFR-06: Scalability
- The database schema shall use normalised relational tables to support extension to
  additional regions, commodities, and markets without schema changes.

## 4.4 Domain Requirements

- **Currency:** All prices shall be recorded in Kenyan Shillings (KES).
- **Units:** Each product shall have a standard unit (e.g., "90kg bag" for maize,
  "kg" for vegetables, "litre" for milk) consistent with Kenyan market conventions.
- **Date Format:** Price dates shall follow ISO 8601 (YYYY-MM-DD).
- **Market Status:** Only markets with `status = 'ACTIVE'` shall appear in price entry
  dropdowns.
- **Product Status:** Only products with `is_active = true` shall appear in dropdowns.
- **Commodity Categories:** Products shall be classified into one of nine EAC-aligned
  categories: Cereals & Grains, Legumes & Pulses, Vegetables, Fruits, Root Crops & Tubers,
  Livestock, Dairy, Poultry, and Cash Crops.

## 4.5 Domain Model

The core domain entities and their relationships are:

```
REGION
  - region_id (PK)
  - region_name
  - region_code
  - country
  |
  | 1..*
  v
MARKET
  - market_id (PK)
  - market_name
  - town
  - operating_days
  - operating_hours
  - status {ACTIVE, INACTIVE}
  - region_id (FK → REGION)

PRODUCT_CATEGORY
  - category_id (PK)
  - category_name
  - category_type {CROP, LIVESTOCK, CASH}
  |
  | 1..*
  v
PRODUCT
  - product_id (PK)
  - product_name
  - local_name
  - standard_unit
  - is_active
  - category_id (FK → PRODUCT_CATEGORY)

USER
  - user_id (PK)
  - full_name
  - email_address (UNIQUE)
  - password_hash
  - role {ADMIN, AGENT, FARMER, TRADER, CONSUMER}
  - phone_number
  - account_status {ACTIVE, SUSPENDED}

PRICE_ENTRY
  - entry_id (PK)
  - product_id (FK → PRODUCT)
  - market_id (FK → MARKET)
  - agent_id (FK → USER)
  - unit_price (KES)
  - price_date
  - status {CURRENT, HISTORICAL}
  - is_anomaly
  - notes
  - UNIQUE (product_id, market_id, price_date)

PRICE_ALERT
  - alert_id (PK)
  - user_id (FK → USER)
  - product_id (FK → PRODUCT)
  - market_id (FK → MARKET, nullable)
  - threshold_price
  - alert_direction {ABOVE, BELOW}
  - is_active
```

**Key Relationships:**
- One REGION has many MARKETs.
- One PRODUCT_CATEGORY has many PRODUCTs.
- One USER (Agent) records many PRICE_ENTRYs.
- One PRODUCT is subject of many PRICE_ENTRYs and PRICE_ALERTs.
- One MARKET is location of many PRICE_ENTRYs and PRICE_ALERTs.
- One USER creates many PRICE_ALERTs.

## 4.6 Use Cases

### UC-01: Login
- **Actor:** All Users
- **Precondition:** User has a registered account.
- **Main Flow:** User submits email and password → system validates against `users` table
  → session created with userId, userRole, userName → redirect to dashboard.
- **Alternative Flow:** Invalid credentials → error message displayed, no session created.

### UC-02: Register
- **Actor:** New User
- **Precondition:** User has no existing account with the email.
- **Main Flow:** User submits registration form → system validates email format, password
  length, role selection → checks email uniqueness → inserts user record → redirects to login.
- **Alternative Flow:** Email already exists → error message displayed.

### UC-03: Enter Price
- **Actor:** Market Agent
- **Precondition:** Agent is logged in. Product and market exist in the system.
- **Main Flow:** Agent selects product from dropdown, selects market, enters unit price and
  date → system validates inputs → inserts price entry → success message displayed.
- **Alternative Flow:** Duplicate entry for same product-market-date → UPSERT updates
  existing record.

### UC-04: View Price List
- **Actor:** Farmer, Trader, Consumer, Agent, Admin
- **Precondition:** User is logged in. At least one price entry exists.
- **Main Flow:** User navigates to Prices → system queries `price_entries` joined with
  `products`, `markets`, `regions` → displays paginated table.
- **Alternative Flow:** User applies filters (crop, market, region, date range) → system
  applies ILIKE WHERE clauses → filtered results displayed.

### UC-05: Compare Prices
- **Actor:** Farmer, Trader, Consumer
- **Precondition:** User is logged in. Same product has prices recorded at multiple markets.
- **Main Flow:** User selects a product and selects markets → system retrieves latest price
  per market → displays comparison table.

### UC-06: View Price Trends
- **Actor:** Farmer, Trader, Consumer, Agent
- **Precondition:** User is logged in. Historical price data exists for selected
  product-market pair.
- **Main Flow:** User selects product, market, and time window → system queries time-series
  data → renders Chart.js line graph.

### UC-07: Manage Price Alert
- **Actor:** Farmer, Trader, Consumer
- **Precondition:** User is logged in.
- **Main Flow:** User creates alert with product, market, direction, and threshold → system
  inserts into `price_alerts` → alert is evaluated on each price entry submission.
- **Alternative Flow:** User deactivates or deletes an existing alert.

### UC-08: Generate Report
- **Actor:** Admin, Agent
- **Precondition:** User is logged in with Admin or Agent role.
- **Main Flow:** User selects report type (Summary / CSV Export) and filters → system
  executes aggregate SQL query → renders report or initiates CSV file download.

### UC-09: Manage Products / Markets
- **Actor:** Admin
- **Precondition:** User is logged in as Admin.
- **Main Flow:** Admin navigates to admin panel → views product/market list → adds new
  record or deactivates (soft-deletes) an existing one.

## 4.7 Use Case Diagrams

```
                   ┌─────────────────────────────────────────────────────┐
                   │                  AMPT System                         │
                   │                                                       │
 ┌──────────┐      │  ○ Login               ○ Enter Price                 │
 │          │─────►│  ○ Register            ○ Edit Price                  │
 │  All     │      │  ○ View Profile        ○ View Price List             │
 │  Users   │      │  ○ View Trends         ○ Compare Prices              │
 └──────────┘      │  ○ Manage Alerts                                      │
                   │                                                       │
 ┌──────────┐      │  ○ Enter Price ─────────────────────── Agent Only    │
 │  Market  │─────►│  ○ Edit Price                                        │
 │  Agent   │      │  ○ Generate Report                                   │
 └──────────┘      │                                                       │
                   │  ○ Manage Products ───────────────── Admin Only      │
 ┌──────────┐      │  ○ Manage Markets                                    │
 │          │─────►│  ○ Manage Users                                      │
 │  Admin   │      │  ○ Manage Categories                                 │
 └──────────┘      │  ○ Manage Regions                                    │
                   │  ○ Generate Report                                   │
                   └─────────────────────────────────────────────────────┘
```

---

---

# CHAPTER FIVE: SYSTEM DESIGN SPECIFICATION

## 5.1 System Architecture

AMPT follows a three-tier web architecture implementing the **Model-View-Controller (MVC)**
pattern, deployed on Apache Tomcat 10.

```
┌────────────────────────────────────────────────────────────────┐
│                        TIER 1: CLIENT                          │
│              Web Browser (HTML5 + CSS3 + JavaScript)           │
│                    Chart.js (price visualisation)              │
└────────────────────────┬───────────────────────────────────────┘
                         │  HTTP/HTTPS Requests & Responses
┌────────────────────────▼───────────────────────────────────────┐
│                   TIER 2: APPLICATION                          │
│                  Apache Tomcat 10 (WAR)                        │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  CONTROLLER LAYER — Java Servlets (14 servlets)         │   │
│  │  LoginServlet  │ RegisterServlet  │ LogoutServlet        │   │
│  │  PriceEntryServlet  │ PriceListServlet │ PriceEditServlet │  │
│  │  PriceCompareServlet │ PriceTrendServlet                 │   │
│  │  AlertServlet │ AlertCheckServlet │ ReportServlet        │   │
│  │  ProductServlet │ MarketServlet │ UserMgmtServlet        │   │
│  └────────────────────────┬────────────────────────────────┘   │
│                           │ request.setAttribute / forward      │
│  ┌─────────────────────────▼──────────────────────────────┐    │
│  │  VIEW LAYER — JSP Pages (14 pages + JSTL)              │    │
│  │  login.html │ register.html │ dashboard.jsp            │    │
│  │  prices/list.jsp │ prices/entry.jsp │ prices/edit.jsp  │    │
│  │  prices/compare.jsp │ prices/trends.jsp                │    │
│  │  alerts/alerts.jsp │ reports/summary.jsp               │    │
│  │  admin/*.jsp │ profile/profile.jsp                     │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  MODEL LAYER — Java Classes                             │   │
│  │  Product │ Market │ Region │ Category                   │   │
│  │  PriceEntry │ PriceAlert │ User                        │   │
│  │  DBConnection (Utility) │ AlgorithmUtils (Utility)     │   │
│  └────────────────────────┬────────────────────────────────┘   │
└───────────────────────────┼────────────────────────────────────┘
                            │  JDBC (PostgreSQL Driver 42.7.1)
┌───────────────────────────▼────────────────────────────────────┐
│                   TIER 3: DATABASE                             │
│                   PostgreSQL 16                                 │
│                                                                  │
│  regions │ markets │ product_categories │ products             │
│  users │ price_entries │ price_alerts │ seasons               │
│  audit_logs │ notifications │ reports │ market_agents         │
└────────────────────────────────────────────────────────────────┘
```

**Request-Response Cycle:**
1. Browser sends HTTP GET/POST to a URL mapped to a Servlet.
2. Servlet authenticates the session (`HttpSession` check).
3. Servlet executes JDBC queries using `PreparedStatement`.
4. Servlet sets result data as request attributes.
5. Servlet forwards request to the corresponding JSP.
6. JSP renders HTML using JSTL `<c:forEach>`, `<c:if>` tags.
7. Rendered HTML returned to browser.

## 5.2 Database Design

### Entity-Relationship Overview

The AMPT database consists of 12 tables in PostgreSQL 16. The logical grouping is:

**Reference / Lookup Tables** (no foreign key dependencies):
- `regions` — Kenya's geographic regions
- `product_categories` — commodity classification
- `seasons` — agricultural season definitions

**Core Operational Tables:**
- `products` → depends on `product_categories`
- `markets` → depends on `regions`
- `users` → independent (authentication anchor)

**Transactional Tables:**
- `price_entries` → depends on `products`, `markets`, `users` (agent), `seasons`
- `price_alerts` → depends on `users`, `products`, `markets`
- `market_agents` → depends on `users`

**Audit / Notification Tables:**
- `audit_logs` → depends on `users`
- `notifications` → depends on `users`, `price_alerts`
- `reports` → depends on `users`

### Key Table Definitions

**`products`**
```sql
CREATE TABLE products (
    product_id     SERIAL PRIMARY KEY,
    product_name   VARCHAR(255) NOT NULL,
    local_name     VARCHAR(255),
    standard_unit  VARCHAR(50) NOT NULL,
    category_id    INTEGER REFERENCES product_categories(category_id),
    is_active      BOOLEAN DEFAULT TRUE
);
```

**`markets`**
```sql
CREATE TABLE markets (
    market_id       SERIAL PRIMARY KEY,
    market_name     VARCHAR(255) NOT NULL,
    town            VARCHAR(100),
    latitude        NUMERIC(9,6),
    longitude       NUMERIC(9,6),
    operating_days  VARCHAR(100),
    operating_hours VARCHAR(100),
    status          VARCHAR(20) DEFAULT 'ACTIVE',
    region_id       INTEGER REFERENCES regions(region_id)
);
```

**`price_entries`**
```sql
CREATE TABLE price_entries (
    entry_id             SERIAL PRIMARY KEY,
    product_id           INTEGER REFERENCES products(product_id),
    market_id            INTEGER REFERENCES markets(market_id),
    agent_id             INTEGER REFERENCES market_agents(agent_id),
    unit_price           NUMERIC(12,2) NOT NULL,
    currency             VARCHAR(3) DEFAULT 'KES',
    price_date           DATE NOT NULL,
    status               VARCHAR(20) DEFAULT 'CURRENT',
    is_anomaly           BOOLEAN DEFAULT FALSE,
    notes                TEXT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (product_id, market_id, price_date)
);
```

**`price_alerts`**
```sql
CREATE TABLE price_alerts (
    alert_id        SERIAL PRIMARY KEY,
    user_id         INTEGER REFERENCES users(user_id),
    product_id      INTEGER REFERENCES products(product_id),
    market_id       INTEGER REFERENCES markets(market_id),
    threshold_price NUMERIC(12,2) NOT NULL,
    alert_direction VARCHAR(10),   -- 'ABOVE' or 'BELOW'
    is_active       BOOLEAN DEFAULT TRUE,
    created_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Performance Index
```sql
CREATE INDEX idx_price_lookup
  ON price_entries (product_id, market_id, price_date);
```

This composite index accelerates the most frequent query patterns: filtering by product,
filtering by market, and ordering by date for trend analysis.

### Seed Data Summary

| Table | Records |
|-------|---------|
| `regions` | 8 (all Kenyan regions) |
| `product_categories` | 9 |
| `products` | 35 |
| `markets` | 29 (major markets per region) |

## 5.3 Flowcharts and Activity Diagrams

### Activity Diagram 1: Price Entry Workflow

```
        [Market Agent logs in]
                │
                ▼
       [Navigate to /prices/entry]
                │
                ▼
       [GET: Servlet loads products
        and markets from DB]
                │
                ▼
       [JSP renders entry form
        with populated dropdowns]
                │
                ▼
       [Agent selects product,
        market, enters price & date]
                │
                ▼
              [POST]
                │
                ▼
        ┌──────────────────┐
        │ Validate inputs  │
        │ (price > 0,      │
        │  date not null)  │
        └────────┬─────────┘
                 │
        ┌────────▼────────┐       ┌─────────────────────────┐
        │  Inputs valid?  │──No──►│ Set error attribute,    │
        └────────┬────────┘       │ re-render form with msg │
                 │ Yes            └─────────────────────────┘
                 ▼
        ┌─────────────────────────────────────────┐
        │  INSERT INTO price_entries              │
        │  ON CONFLICT (product_id, market_id,    │
        │  price_date) DO UPDATE SET unit_price   │
        └────────┬────────────────────────────────┘
                 │
        ┌────────▼────────┐       ┌─────────────────────────┐
        │  Insert/Update  │─Fail─►│ Set DB error attribute, │
        │  successful?    │       │ redirect to entry form  │
        └────────┬────────┘       └─────────────────────────┘
                 │ Yes
                 ▼
        [Redirect to /prices/list
         with ?success=Price+saved]
```

### Activity Diagram 2: User Authentication Workflow

```
        [User accesses any protected URL]
                │
                ▼
        ┌────────────────────┐
        │ Session has userId?│──No──► [Redirect to /login]
        └────────┬───────────┘                │
                 │ Yes                         ▼
                 ▼               [User submits email + password]
        [Servlet processes                     │
         request normally]                     ▼
                             ┌─────────────────────────────────┐
                             │ SELECT user from DB where       │
                             │ email = ? AND password = hash(?)│
                             └──────────────┬──────────────────┘
                                            │
                             ┌──────────────▼──────────────┐
                             │ User found and status=ACTIVE?│
                             └──────────────┬──────────────┘
                                  │ Yes     │ No
                                  ▼         ▼
                          [Set session]  [Set error:
                          [Redirect to   Invalid credentials]
                           /dashboard]  [Re-render login]
```

### Flowchart: Price Alert Check

```
   START
     │
     ▼
   SELECT all active price_alerts
     │
     ▼
   FOR EACH alert:
     │
     ▼
   SELECT latest price for
   alert.product_id, alert.market_id
     │
     ▼
   ┌──────────────────────────────┐
   │ direction = 'ABOVE'?        │
   │ current_price > threshold?  │──Yes──► [Trigger notification]
   └────────────┬────────────────┘
                │ No
                ▼
   ┌──────────────────────────────┐
   │ direction = 'BELOW'?        │
   │ current_price < threshold?  │──Yes──► [Trigger notification]
   └────────────┬────────────────┘
                │ No
                ▼
   [No action — condition not met]
     │
     ▼
   [Next alert]
     │
     ▼
   END
```

## 5.4 Interface Design Overview

The system interface follows a consistent design language across all pages:

- **Header/Navbar:** Persistent navigation bar with brand logo, system name, and role-aware
  navigation links. Active page highlighted.
- **Content Sections:** Cards with section headers (title + subtitle), action buttons
  aligned to the right of the header.
- **Data Tables:** Semantic `<table>` elements with `<thead>`/`<tbody>`, monospaced price
  values, badge-styled region labels, and row-level action buttons.
- **Forms:** Labelled inputs with placeholder text, grouped with consistent spacing,
  and submit/cancel button pairs aligned to the right.
- **Colour Palette:** Dark green primary (`#1a4731`), warm off-white background, muted
  grey secondary text — aligned with agricultural/natural branding.
- **Typography:** Playfair Display (headings), IBM Plex Mono (prices/data), Source Serif 4
  (body text).
- **Responsiveness:** Flexbox layout with mobile breakpoints for navbar collapse.

---

---

# CHAPTER SIX: SYSTEM IMPLEMENTATION AND TESTING

## 6.1 Implementation Language

AMPT is implemented in **Java SE 17** for the backend, with HTML5, CSS3, and vanilla
JavaScript for the frontend. Java was selected for the following reasons:

- **Platform Maturity:** Java has decades of enterprise web application history with
  Jakarta EE (formerly Java EE), providing well-specified APIs for servlet, JSP, and
  JDBC programming.
- **Type Safety:** Java's static typing reduces runtime errors in data handling code,
  particularly important for financial data (prices) where type errors can produce
  incorrect results.
- **Academic Alignment:** The course requires Java implementation. Java Servlets
  demonstrate fundamental HTTP request-response handling, session management, and
  server-side rendering without abstraction layers obscuring the underlying mechanics.
- **JDBC:** Direct database access with `PreparedStatement` provides transparent SQL
  execution, making query optimisation and security measures (parameter binding) explicit
  and auditable.

## 6.2 Key Language Features Used

| Feature | Usage in AMPT |
|---------|--------------|
| **Generics** (`List<String[]>`) | Type-safe collections for price list rows returned from JDBC `ResultSet` |
| **Try-with-resources** | Automatic `Connection`, `PreparedStatement`, `ResultSet` closing — prevents resource leaks |
| **`HttpSession`** | Session management for user authentication state across requests |
| **`PreparedStatement`** | Parameterised SQL queries preventing SQL injection |
| **`RequestDispatcher.forward()`** | MVC forwarding from Servlet controller to JSP view |
| **`@WebServlet` annotation** | Declarative URL pattern mapping without XML verbosity |
| **`BigDecimal`** | Precise arithmetic for financial price values, avoiding floating-point errors |
| **JSONB via JDBC** | Flexible audit log `change_details` stored as JSON in PostgreSQL |
| **`response.setContentType("text/csv")`** | Streaming CSV report download with appropriate MIME type |

## 6.3 Search Algorithms Implemented

AMPT includes an `AlgorithmUtils` class implementing standard algorithms in Java,
demonstrating core computer science concepts within the application domain.

### 6.3.1 Linear Search — `O(n)`

```java
public static int linearSearch(List<String> list, String target) {
    for (int i = 0; i < list.size(); i++) {
        if (list.get(i).equalsIgnoreCase(target)) {
            return i;
        }
    }
    return -1;
}
```
**Use:** Searching unsorted product name lists for a matching entry. Suitable for small
datasets where maintaining sort order is not warranted.

**Complexity:** Time O(n), Space O(1).

### 6.3.2 Binary Search — `O(log n)`

```java
public static int binarySearch(List<String> sortedList, String target) {
    int low = 0, high = sortedList.size() - 1;
    while (low <= high) {
        int mid = (low + high) / 2;
        int cmp = sortedList.get(mid).compareToIgnoreCase(target);
        if (cmp == 0) return mid;
        else if (cmp < 0) low = mid + 1;
        else high = mid - 1;
    }
    return -1;
}
```
**Use:** Searching sorted market name lists — applicable after an alphabetically sorted
market dropdown is loaded. Significantly faster than linear search for large market lists.

**Complexity:** Time O(log n), Space O(1). Prerequisite: sorted input list.

### 6.3.3 Bubble Sort — `O(n²)`

```java
public static void bubbleSort(List<Double> prices) {
    int n = prices.size();
    for (int i = 0; i < n - 1; i++) {
        boolean swapped = false;
        for (int j = 0; j < n - i - 1; j++) {
            if (prices.get(j) > prices.get(j + 1)) {
                double tmp = prices.get(j);
                prices.set(j, prices.get(j + 1));
                prices.set(j + 1, tmp);
                swapped = true;
            }
        }
        if (!swapped) break; // Early exit optimisation
    }
}
```
**Use:** Sorting small price arrays for anomaly detection (identifying outliers in a set
of recent prices for a commodity). The early-exit optimisation improves performance on
nearly-sorted data.

**Complexity:** Time O(n²) worst-case, O(n) best-case (nearly sorted). Space O(1).

### 6.3.4 Quick Sort — `O(n log n)` average

```java
public static void quickSort(List<Double> prices, int low, int high) {
    if (low < high) {
        int pi = partition(prices, low, high);
        quickSort(prices, low, pi - 1);
        quickSort(prices, pi + 1, high);
    }
}
private static int partition(List<Double> prices, int low, int high) {
    double pivot = prices.get(high);
    int i = low - 1;
    for (int j = low; j < high; j++) {
        if (prices.get(j) <= pivot) {
            i++;
            double tmp = prices.get(i);
            prices.set(i, prices.get(j));
            prices.set(j, tmp);
        }
    }
    double tmp = prices.get(i + 1);
    prices.set(i + 1, prices.get(high));
    prices.set(high, tmp);
    return i + 1;
}
```
**Use:** Sorting larger price datasets for trend analysis prior to percentile calculations.
Significantly outperforms bubble sort for datasets with more than ~20 entries.

**Complexity:** Time O(n log n) average, O(n²) worst-case (sorted input with last-element
pivot). Space O(log n) stack frames.

### 6.3.5 Min/Max Finder — `O(n)`

```java
public static double[] findMinMaxPrices(List<Double> prices) {
    double min = Double.MAX_VALUE, max = Double.MIN_VALUE;
    for (double p : prices) {
        if (p < min) min = p;
        if (p > max) max = p;
    }
    return new double[]{min, max};
}
```
**Use:** Computing the price range for report summary statistics. Single O(n) pass avoids
the overhead of sorting when only extremes are needed.

### 6.3.6 Database-Level Algorithms

Beyond in-memory algorithms, AMPT leverages PostgreSQL's query planner for large-scale
data operations:

- `ORDER BY price_date DESC` — B-tree index scan for trend data retrieval.
- `ILIKE '%pattern%'` — Case-insensitive pattern matching for search filters.
- `GROUP BY product_id, market_id` with `AVG()`, `MIN()`, `MAX()`, `COUNT()` — aggregate
  functions for report generation.
- `LIMIT 1` with `ORDER BY price_date DESC` — "latest price" retrieval using the
  composite index `idx_price_lookup`.
- `WHERE price_date >= CURRENT_DATE - INTERVAL 'N days'` — time-window filtering for
  trend queries.

## 6.4 Testing Strategy

### Unit Testing
Individual servlet methods and utility functions (AlgorithmUtils) are tested in isolation.
- `AlgorithmUtils.linearSearch()` — tested with found, not-found, and case-insensitive cases.
- `AlgorithmUtils.binarySearch()` — tested with sorted lists, empty lists, single element.
- `AlgorithmUtils.bubbleSort()` — verified against pre-sorted, reverse-sorted, and random arrays.

### Integration Testing
End-to-end workflows tested by running the system on Tomcat against a test PostgreSQL
database:
- Price entry → confirmation → appears in price list.
- Price filter by crop name → correct filtered results.
- Alert creation → alert triggered when price inserted above threshold.
- Admin product add → product appears in price entry dropdown.
- CSV report download → valid CSV file with correct headers and data.

### Security Testing
- SQL injection attempt: entering `'; DROP TABLE price_entries; --` into filter fields —
  verified safe due to `PreparedStatement` binding.
- Session bypass attempt: accessing `/admin/users` without login → verified redirect to
  `/login`.
- Role bypass attempt: logged in as FARMER, directly accessing `/prices/entry` via URL →
  verified servlet returns 403 or redirects based on role check.

### User Acceptance Testing (UAT)
Test scenarios documented in `TEST.md` covering:
- Login / logout flow.
- New user registration with valid and invalid inputs.
- Price entry, editing, and deletion.
- Price comparison and trend chart rendering.
- Alert creation and notification.
- Report generation and CSV download.
- Admin CRUD for products, markets, and users.

## 6.5 Source Code

The full system source code is submitted on a CD attached to this report. The CD contains:

```
CD_CONTENTS/
├── src/                    (Java Servlet and Model source files)
├── WebContent/             (JSP views, CSS, JavaScript)
│   ├── WEB-INF/web.xml     (Servlet URL mappings)
│   └── css/style.css       (Global stylesheet)
├── db/
│   ├── database_setup_fixed.sql   (Schema creation script)
│   └── seed_data.sql              (Reference data: regions, products, markets)
├── pom.xml                 (Maven build configuration)
└── QUICKSTART.md           (Setup and deployment instructions)
```

To run the system from the CD:
1. Install Java 17, PostgreSQL 16, Apache Maven 3.8+, and Apache Tomcat 10.
2. Create database: `createdb agri_price_tracker`
3. Run schema: `psql -U postgres -d agri_price_tracker -f db/database_setup_fixed.sql`
4. Run seed data: `psql -U postgres -d agri_price_tracker -f db/seed_data.sql`
5. Build: `mvn clean package`
6. Deploy: Copy `target/agri-price-tracker.war` to Tomcat `webapps/` directory.
7. Access: `http://localhost:8080/agri-price-tracker`

---

---

# CHAPTER SEVEN: CONCLUSION AND RECOMMENDATION

## 7.1 Conclusion

The Agricultural Market Price Tracker (AMPT) — AgriPrice KE — has been successfully
designed and implemented as a full-featured, role-based web application addressing the
critical problem of agricultural market price information asymmetry in Kenya.

The system achieves all stated specific objectives:

1. **Requirements Analysis:** A comprehensive set of 12 functional requirements and 6
   non-functional requirements was elicited through stakeholder analysis, literature
   review, and use case modelling using Object-Oriented Analysis techniques.

2. **Database Design:** A normalised relational schema of 12 tables was designed in
   PostgreSQL 16, covering the full domain: geographic regions, markets, commodity
   categories, products, user accounts, price entries, alerts, audit logs, and reports.
   The schema is seeded with data for 8 Kenyan regions, 35 agricultural commodities, and
   29 major markets.

3. **Implementation:** A role-based web application was implemented using Java 17
   Servlets + JSP (MVC), with 14 servlet controllers, 14 JSP views, and 6 model classes.
   Role-based access control, session management, and SQL injection prevention are fully
   implemented.

4. **Analytical Features:** Price comparison across markets, time-series trend
   visualisation using Chart.js, configurable price alerts, and CSV report export were
   successfully implemented and tested.

5. **Algorithm Implementation:** Linear search, binary search, bubble sort (with early-exit
   optimisation), quicksort, and min/max finding algorithms were implemented in Java within
   the `AlgorithmUtils` class, complementing database-level sorting and filtering.

6. **Testing:** The system was validated through unit, integration, security, and user
   acceptance testing, with all critical functional requirements verified.

The project also demonstrates practical competence in software engineering discipline:
version control with Git, collaborative development across multiple feature branches,
iterative development with code reviews, and structured documentation.

## 7.2 Recommendations

Based on the development experience and testing outcomes, the following recommendations
are made for future enhancement and deployment of AMPT:

### 7.2.1 SMS Alert Integration
The current alert system flags triggered alerts in the database but does not yet send
external notifications. Integration with **Africa's Talking SMS API** (already identified
in the system architecture) would deliver immediate value to farmers who may not check
the web interface daily. This represents the single highest-impact enhancement.

### 7.2.2 Mobile Application
A progressive web app (PWA) wrapper or native Android application would extend reach to
market agents operating in areas with limited laptop/desktop access. The existing REST-like
servlet endpoints could be adapted to return JSON responses for a mobile client.

### 7.2.3 Automated Data Collection
Partnering with county government agriculture departments and market management bodies to
automate price data submission (via integrated weighbridge systems, mobile data collection
forms, or APIs) would improve data freshness and reduce reliance on manual agent entry.

### 7.2.4 Anomaly Detection Enhancement
The `is_anomaly` flag exists in `price_entries` but anomaly detection logic is not yet
fully automated. Implementing a statistical anomaly detection algorithm (e.g., Z-score or
IQR-based outlier detection) that automatically flags prices deviating significantly from
the 30-day mean would improve data quality.

### 7.2.5 Multi-Language Support
Kenya's agricultural population is most comfortable in Kiswahili. Adding Kiswahili
localisation (the `preferred_language` field already exists in the `users` table) would
significantly expand accessibility for the target demographic.

### 7.2.6 Connection Pooling
The current implementation uses `DriverManager` for direct JDBC connections. For production
deployment with concurrent users, replacing this with a connection pool (HikariCP or
Apache DBCP) would substantially improve performance and resilience under load.

### 7.2.7 Cloud Deployment
Deploying AMPT to a cloud platform (AWS, Google Cloud, or a Kenyan provider such as
Safaricom Cloud) would make the system accessible nationwide, aligning with Kenya's Digital
Economy Blueprint objectives. The `db.properties` file already contains commented-out
configuration for cloud database connectivity.

---

---

# REFERENCES

1. Chuka University (2025). *Course Outline: Software Engineering / System Development*.
   Department of Computer Science, School of Computing and Informatics.

2. Communications Authority of Kenya (2024). *Sector Statistics Report Q2 2023/2024*.
   Nairobi: CA Kenya.

3. Eriksson, H. E., & Penker, M. (1998). *UML Toolkit*. New York: John Wiley & Sons.

4. Food and Agriculture Organization of the United Nations (2021). *Market Information
   Systems and Agricultural Commodities Markets*. FAO Agricultural Development Economics
   Working Paper 21-07. Rome: FAO.

5. Gamma, E., Helm, R., Johnson, R., & Vlissides, J. (1994). *Design Patterns: Elements
   of Reusable Object-Oriented Software*. Reading, MA: Addison-Wesley.

6. Horstmann, C. S. (2019). *Core Java, Volume II — Advanced Features* (11th ed.).
   Hoboken, NJ: Pearson Education.

7. Jensen, K. (2022). *Agricultural Market Information Systems in Sub-Saharan Africa:
   A Systematic Review*. Journal of Agricultural Informatics, 13(2), 1–18.

8. Kenya National Bureau of Statistics (2023). *Kenya Statistical Abstract 2023*.
   Nairobi: KNBS.

9. Larman, C. (2004). *Applying UML and Patterns: An Introduction to Object-Oriented
   Analysis and Design* (3rd ed.). Upper Saddle River, NJ: Prentice Hall.

10. Mwebaze, P., & Okello, J. (2020). Price Information Systems and Smallholder Market
    Participation in East Africa. *African Journal of Agricultural and Resource Economics*,
    15(3), 210–228.

11. Oracle Corporation (2024). *Java SE 17 Documentation*. Retrieved from
    https://docs.oracle.com/en/java/javase/17/

12. PostgreSQL Global Development Group (2024). *PostgreSQL 16 Documentation*. Retrieved
    from https://www.postgresql.org/docs/16/

13. Pressman, R. S., & Maxim, B. R. (2020). *Software Engineering: A Practitioner's
    Approach* (9th ed.). New York: McGraw-Hill Education.

14. Rumbaugh, J., Jacobson, I., & Booch, G. (2004). *The Unified Modeling Language
    Reference Manual* (2nd ed.). Boston: Addison-Wesley.

15. Sommerville, I. (2016). *Software Engineering* (10th ed.). Harlow: Pearson Education.

16. World Bank (2022). *Agriculture and Food: Kenya Overview*. Washington, DC: The
    World Bank Group.

---

*End of Proposal — AMPT Agricultural Market Price Tracker (AgriPrice KE)*
*Chuka University · Department of Computer Science · 2025/2026*
