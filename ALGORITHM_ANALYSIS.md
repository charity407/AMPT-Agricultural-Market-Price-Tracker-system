# Algorithm & Sorting Analysis — AgriPrice KE

Comprehensive analysis of algorithms, sorting, filtering, and data processing techniques used in the AgriPrice Agricultural Market Price Tracker system.

---

## Summary

The codebase **primarily uses SQL-level sorting and filtering** rather than in-memory algorithms. There are **no complex algorithmic implementations** (e.g., binary search, tree structures, custom sorting algorithms), but the system effectively uses:

- ✅ **SQL ORDER BY** - Database-level sorting
- ✅ **SQL WHERE clauses** - Database-level filtering
- ✅ **String parsing** - Array splitting for comma-separated values
- ✅ **List iteration** - Loop-based data processing

---

## Algorithms & Data Processing Found

### 1. **SQL Sorting (Database Level)**

#### Location: **Multiple Servlets & Utils**

**A. Price Trend Sorting** - `PriceTrendServlet.java` (Line 51)
```java
String sql = """
    SELECT price_date, unit_price
    FROM price_entries
    WHERE product_id = ? AND market_id = ?
    AND price_date >= CURRENT_DATE - INTERVAL '%d days'
    ORDER BY price_date  ← CHRONOLOGICAL SORT
    """.formatted(days);
```
**Purpose**: Sorts price history by date for trend visualization
**Algorithm Type**: Database ORDER BY (ascending timestamp)
**Complexity**: O(n log n) in database, efficient for large datasets

---

**B. Price Comparison Reverse Sort** - `PriceCompareServlet.java` (Line 53)
```java
String sql = """
    SELECT pe.unit_price, m.market_name, pe.price_date
    FROM price_entries pe
    WHERE pe.product_id = ? AND pe.market_id = ?
    ORDER BY pe.price_date DESC  ← REVERSE CHRONOLOGICAL SORT
    LIMIT 1
    """;
```
**Purpose**: Gets the **latest** price for each market
**Algorithm Type**: DESC sort + LIMIT (gets top result)
**Optimization**: LIMIT 1 stops after first result (efficient)

---

**C. Product List Sorting** - `ProductServlet.java`
```java
sql.append(" ORDER BY product_name");  // Alphabetical sort
```
**Purpose**: Displays products in alphabetical order
**Algorithm Type**: String sort (case-insensitive)

---

**D. Market List Sorting** - `MarketServlet.java`
```java
sql.append(" ORDER BY market_name");  // Alphabetical sort
```
**Purpose**: Displays markets in alphabetical order

---

**E. Region List Sorting** - `RegionServlet.java`
```java
String sql = "SELECT * FROM regions" +
    (countryFilter != null ? " WHERE country=?" : "") +
    " ORDER BY region_name";  // Alphabetical sort
```
**Purpose**: Lists regions alphabetically, optionally filtered by country

---

**F. Category & Product Dropdown Sorting** - `DropdownHelper.java` (Lines 123, 208, 323)
```java
sql.append(" ORDER BY c.category_name, p.product_name");
// Multi-level sort: Categories first, then products within each category
```
**Purpose**: Hierarchical sorting for dropdown menus
**Algorithm Type**: Multi-key sort (primary: category name, secondary: product name)

---

**G. Market & Region Dropdown Sorting** - `DropdownHelper.java` (Lines 170, 376)
```java
sql.append(" ORDER BY r.region_name, m.market_name");
// Multi-level sort: Regions first, then markets within each region
```
**Purpose**: Hierarchical sorting for regional market dropdowns

---

**H. User List Sorting** - `UserManagementServlet.java`
```java
String sql = "SELECT user_id, full_name, email_address, role, account_status
             FROM users ORDER BY user_id";
```
**Purpose**: Lists users sorted by ID

---

**I. Report Data Sorting** - `ReportServlet.java` (Line 51)
```java
sql.append(" ORDER BY pe.price_date DESC");
// Reverse chronological - most recent entries first
```
**Purpose**: Recent price entries appear first in reports

---

**J. Alert Sorting** - `AlertServlet.java`
```java
sql.append("ORDER BY pa.created_date DESC");
// Most recent alerts first
```
**Purpose**: Latest alerts displayed first

---

### 2. **String Parsing Algorithm** - `PriceCompareServlet.java` (Lines 41-45)

**Task**: Parse comma-separated market IDs from query parameter

```java
String[] marketIdStrings = marketIdsParam.split(",");  // Split string
List<Integer> marketIds = new ArrayList<>();
for (String id : marketIdStrings) {
    marketIds.add(Integer.parseInt(id.trim()));  // Convert & trim
}
```

**Algorithm Type**: String tokenization + type conversion
**Time Complexity**: O(n) where n = number of market IDs
**Purpose**: Convert `"1,2,3,4"` into `[1, 2, 3, 4]`

---

### 3. **Filtering Algorithm** - Multiple Servlets

**A. Category Filter** - `DropdownHelper.java` (Line 122)
```java
Integer catFilter = getIntParam(ex, "cat");
if (catFilter != null) sql.append(" AND p.category_id = ?");
```
**Algorithm Type**: Conditional WHERE clause filtering
**Purpose**: Filter products by category ID

---

**B. Region Filter** - `DropdownHelper.java` (Line 169)
```java
Integer regionFilter = getIntParam(ex, "region");
if (regionFilter != null) sql.append(" AND m.region_id = ?");
```
**Algorithm Type**: Conditional WHERE clause filtering
**Purpose**: Filter markets by region ID

---

**C. Country Filter** - `RegionServlet.java`
```java
String sql = "SELECT * FROM regions" +
    (countryFilter != null ? " WHERE country=?" : "") +
    " ORDER BY region_name";
```
**Algorithm Type**: Dynamic SQL with optional WHERE
**Purpose**: Filter regions by country

---

**D. Status Filter** - `MarketServlet.java`
```java
String statusFilter = "ACTIVE";  // default
// ... later ...
if (regionFilter != null) sql.append(" AND region_id=...
```
**Purpose**: Only show active markets

---

### 4. **Date Range Filtering** - `PriceTrendServlet.java` (Line 50)

```java
String sql = """
    ...
    WHERE product_id = ? AND market_id = ?
    AND price_date >= CURRENT_DATE - INTERVAL '%d days'  ← DATE RANGE FILTER
    ORDER BY price_date
    """.formatted(days);
```

**Algorithm Type**: Date-based range filtering
**Purpose**: Get prices from the last N days (30, 90, 180, etc.)
**Complexity**: O(n) scan with date condition

---

### 5. **Loop-Based Data Processing** - Multiple Servlets

**Pattern**: Iterate ResultSet and build List

```java
List<String[]> trendData = new ArrayList<>();
while (rs.next()) {
    trendData.add(new String[] {
        rs.getString("price_date"),
        rs.getString("unit_price")
    });
}
```

**Algorithm Type**: Sequential traversal + collection building
**Time Complexity**: O(n) where n = number of database rows
**Purpose**: Convert database rows to Java objects for JSP rendering

---

## Summary Table

| Feature | Servlet/File | Algorithm Type | Complexity | Purpose |
|---------|--------------|---|---|---|
| **Price Trends** | PriceTrendServlet | SQL ORDER BY | O(n log n) | Sort prices chronologically |
| **Price Comparison** | PriceCompareServlet | SQL ORDER BY DESC + LIMIT | O(n) | Get latest prices per market |
| **Product List** | ProductServlet | SQL ORDER BY | O(n log n) | Alphabetical product list |
| **Market List** | MarketServlet | SQL ORDER BY | O(n log n) | Alphabetical market list |
| **Dropdowns** | DropdownHelper | Multi-key ORDER BY | O(n log n) | Hierarchical category/product sort |
| **Filtering** | Multiple | SQL WHERE | O(n) | Filter by category/region/status |
| **Date Range** | PriceTrendServlet | Date comparison | O(n) | Get prices within date range |
| **String Parsing** | PriceCompareServlet | String.split() | O(n) | Parse comma-separated IDs |
| **Data Processing** | Multiple | Loop iteration | O(n) | Convert DB rows to objects |

---

## 🏆 Algorithm Observations

### ✅ Strengths
1. **Database-Optimized**: All sorting/filtering done at database level (efficient)
2. **No N+1 Queries**: Uses single queries with JOINs where needed
3. **Parameterized Queries**: Prevents SQL injection
4. **Proper Indexing Candidates**: ORDER BY fields should be indexed
5. **LIMIT Optimization**: Uses LIMIT 1 to stop early when fetching latest records

### ⚠️ Areas for Improvement

1. **String Splitting in Java**
   ```java
   // Current: Splits in Java (Line 41, PriceCompareServlet)
   String[] marketIdStrings = marketIdsParam.split(",");

   // Better: Use SQL IN clause for multiple markets
   // Example: WHERE market_id IN (1, 2, 3, 4)
   ```

2. **Manual Loop Processing**
   ```java
   // Current: Manual loop to build ArrayList
   List<Integer> marketIds = new ArrayList<>();
   for (String id : marketIdStrings) {
       marketIds.add(Integer.parseInt(id.trim()));
   }

   // Better: Use Java Streams (Java 8+)
   List<Integer> marketIds = Arrays.stream(marketIdStrings)
       .map(String::trim)
       .map(Integer::parseInt)
       .collect(Collectors.toList());
   ```

3. **Nested Loop in Price Comparison**
   ```java
   // Current: Loop over marketIds, execute query for each
   for (int marketId : marketIds) {
       // Execute separate query for each market
   }
   // Complexity: O(k * q) where k = markets, q = query time

   // Better: Single query with JOIN or IN clause
   // SELECT ... WHERE product_id = ? AND market_id IN (...)
   ```

---

## 🔧 Code Quality Assessment

| Metric | Rating | Notes |
|--------|--------|-------|
| **Algorithm Complexity** | ⭐⭐⭐⭐ | Simple, straightforward (no complex algorithms needed) |
| **Database Optimization** | ⭐⭐⭐⭐ | Good use of SQL ORDER BY, filtering at database level |
| **Code Readability** | ⭐⭐⭐⭐ | Clear intent, well-organized |
| **Performance** | ⭐⭐⭐ | Good, but minor optimizations possible |
| **Scalability** | ⭐⭐⭐ | Should handle typical agricultural market data volumes |

---

## 📊 Potential Optimizations for Future Enhancement

### 1. **Batch Query for Price Comparison**
Instead of looping per market, fetch all prices in one query:

```java
// Before: O(k) queries
for (int marketId : marketIds) {
    // Execute query
}

// After: O(1) query
String sql = """
    SELECT m.market_name, pe.unit_price, pe.price_date
    FROM price_entries pe
    JOIN markets m ON pe.market_id = m.market_id
    WHERE pe.product_id = ? AND pe.market_id IN (...)
    AND pe.price_date = (
        SELECT MAX(price_date) FROM price_entries
        WHERE product_id = ? AND market_id = pe.market_id
    )
    """;
```

### 2. **Stream API for Data Processing**
Modernize collection processing with Java 8+ Streams:

```java
// Before: Manual loop
for (String id : marketIdStrings) {
    marketIds.add(Integer.parseInt(id.trim()));
}

// After: Streams
List<Integer> marketIds = Arrays.stream(marketIdStrings)
    .map(String::trim)
    .map(Integer::parseInt)
    .collect(Collectors.toList());
```

### 3. **Database Indexes**
Ensure these columns are indexed for performance:

```sql
CREATE INDEX idx_price_entries_date ON price_entries(price_date DESC);
CREATE INDEX idx_products_name ON products(product_name);
CREATE INDEX idx_markets_name ON markets(market_name);
CREATE INDEX idx_regions_name ON regions(region_name);
CREATE INDEX idx_markets_region ON markets(region_id);
CREATE INDEX idx_products_category ON products(category_id);
```

---

## Conclusion

The AgriPrice KE codebase does **not use complex algorithms** by design — it's appropriate for an agricultural price tracking system where data volumes are moderate and queries are straightforward. The system effectively delegates sorting and filtering to the PostgreSQL database, which is the right architectural decision.

**No sorting algorithm implementations** (QuickSort, MergeSort, etc.) are used because:
1. Database is more efficient for sorting
2. Data volumes don't require client-side optimization
3. Keeps code simple and maintainable

The codebase is **well-structured for its purpose** and would benefit from minor optimizations (Stream API, batch queries) as it grows.

---

*Analysis Date: March 29, 2026*
*Codebase: AgriPrice KE v1.0*
*Java Version: 17 (Jakarta EE)*
