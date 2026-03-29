-- ========================================================
-- DROPDOWN QUERIES FOR M3 (PRODUCTS) & M6 (MARKET FILTERS)
-- ========================================================

-- 1. Get all active products for the 'Add Price' dropdown
-- This ensures agents only see products currently in trade.
SELECT product_id, product_name, local_name 
FROM products 
WHERE is_active = TRUE 
ORDER BY product_name ASC;

-- 2. Get all markets grouped by their town/county
-- This helps users filter prices by their specific location.
SELECT market_id, market_name, town 
FROM markets 
WHERE status = 'ACTIVE' 
ORDER BY town, market_name ASC;

-- 3. Get all Counties for the Regional Filter
-- Needed for the 'Search by County' feature.
SELECT county_code, county_name 
FROM counties 
ORDER BY county_name ASC;