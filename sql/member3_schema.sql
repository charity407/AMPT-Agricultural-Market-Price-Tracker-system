-- ============================================================
-- AMPT Member 3 Schema — Products, Markets & Regions
-- Package: com.agriprice
-- Run: psql -U postgres -d ampt_db -f member3_schema.sql
-- ============================================================

-- REGIONS
CREATE TABLE IF NOT EXISTS regions (
    region_id   SERIAL PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL,
    country     CHAR(3)      NOT NULL DEFAULT 'KEN',
    region_code VARCHAR(10)  NOT NULL,
    CONSTRAINT uq_region_name_country UNIQUE (region_name, country),
    CONSTRAINT uq_region_code         UNIQUE (region_code),
    CONSTRAINT chk_region_code        CHECK  (region_code ~ '^[A-Za-z0-9_-]+$')
);

-- MARKETS
CREATE TABLE IF NOT EXISTS markets (
    market_id        SERIAL PRIMARY KEY,
    market_name      VARCHAR(150) NOT NULL,
    physical_address TEXT,
    town             VARCHAR(100) NOT NULL,
    country          CHAR(3)      NOT NULL DEFAULT 'KEN',
    latitude         DECIMAL(9,6) DEFAULT 0,
    longitude        DECIMAL(9,6) DEFAULT 0,
    operating_days   VARCHAR(50),
    operating_hours  VARCHAR(50),
    status           VARCHAR(10)  NOT NULL DEFAULT 'ACTIVE',
    date_registered  TIMESTAMP    NOT NULL DEFAULT NOW(),
    region_id        INT          NOT NULL REFERENCES regions(region_id),
    CONSTRAINT uq_market_name_region UNIQUE (market_name, region_id),
    CONSTRAINT chk_market_status     CHECK  (status IN ('ACTIVE','INACTIVE'))
);

-- PRODUCT CATEGORIES
CREATE TABLE IF NOT EXISTS product_categories (
    category_id   SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    category_type VARCHAR(20)  NOT NULL DEFAULT 'CROP',
    eac_code      VARCHAR(20),
    description   TEXT,
    CONSTRAINT chk_category_type CHECK (category_type IN ('CROP','LIVESTOCK','PRODUCE','OTHER'))
);

-- PRODUCTS
CREATE TABLE IF NOT EXISTS products (
    product_id    SERIAL PRIMARY KEY,
    product_name  VARCHAR(150) NOT NULL,
    local_name    VARCHAR(150),
    category_id   INT          NOT NULL REFERENCES product_categories(category_id),
    standard_unit VARCHAR(50)  NOT NULL,
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,
    date_added    TIMESTAMP    NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_product_name_category UNIQUE (product_name, category_id)
);

-- ============================================================
-- SEED DATA — 8 Kenyan Regions
-- ============================================================
INSERT INTO regions (region_name, country, region_code) VALUES
    ('Nairobi',        'KEN', 'NRB'),
    ('Rift Valley',    'KEN', 'RV'),
    ('Central',        'KEN', 'CTR'),
    ('Coast',          'KEN', 'CST'),
    ('Nyanza',         'KEN', 'NYZ'),
    ('Western',        'KEN', 'WST'),
    ('Eastern',        'KEN', 'EST'),
    ('North Eastern',  'KEN', 'NE')
ON CONFLICT DO NOTHING;

-- ============================================================
-- SEED DATA — 5 Major Markets
-- ============================================================
INSERT INTO markets (market_name, physical_address, town, latitude, longitude, operating_days, operating_hours, status, region_id)
SELECT 'Wakulima Market',        'Haile Selassie Ave',  'Nairobi', -1.2833, 36.8167, 'Mon-Sat', '05:00-18:00', 'ACTIVE', region_id FROM regions WHERE region_code='NRB'
ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name, physical_address, town, latitude, longitude, operating_days, operating_hours, status, region_id)
SELECT 'Gikomba Market',         'Gikomba Rd',          'Nairobi', -1.2897, 36.8451, 'Mon-Sun', '05:00-18:00', 'ACTIVE', region_id FROM regions WHERE region_code='NRB'
ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name, physical_address, town, latitude, longitude, operating_days, operating_hours, status, region_id)
SELECT 'Nakuru Municipal Market','Kenyatta Ave',         'Nakuru', -0.3031, 36.0800, 'Mon-Sat', '06:00-18:00', 'ACTIVE', region_id FROM regions WHERE region_code='RV'
ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name, physical_address, town, latitude, longitude, operating_days, operating_hours, status, region_id)
SELECT 'Kisumu Main Market',     'Oginga Odinga St',    'Kisumu', -0.0917, 34.7680, 'Mon-Sat', '06:00-18:00', 'ACTIVE', region_id FROM regions WHERE region_code='NYZ'
ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name, physical_address, town, latitude, longitude, operating_days, operating_hours, status, region_id)
SELECT 'Kongowea Market',        'Kongowea Junction',   'Mombasa', -4.0435, 39.6682, 'Mon-Sun', '05:00-19:00', 'ACTIVE', region_id FROM regions WHERE region_code='CST'
ON CONFLICT DO NOTHING;

-- ============================================================
-- SEED DATA — Product Categories
-- ============================================================
INSERT INTO product_categories (category_name, category_type, eac_code, description) VALUES
    ('Cereals & Grains',      'CROP',      '1001', 'Maize, wheat, rice, sorghum, millet'),
    ('Legumes & Pulses',      'CROP',      '0713', 'Beans, lentils, green grams, pigeon peas'),
    ('Vegetables',            'PRODUCE',   '0702', 'Tomatoes, kale, cabbage, onions, carrots'),
    ('Fruits',                'PRODUCE',   '0801', 'Bananas, mangoes, avocados, oranges'),
    ('Root Crops & Tubers',   'CROP',      '0714', 'Potatoes, sweet potatoes, cassava, arrow roots'),
    ('Dairy Products',        'LIVESTOCK', '0401', 'Fresh milk, fermented milk, ghee'),
    ('Livestock',             'LIVESTOCK', '0102', 'Cattle, goats, sheep, pigs, poultry'),
    ('Cash Crops',            'CROP',      '0901', 'Coffee, tea, pyrethrum, sunflower'),
    ('Spices & Herbs',        'PRODUCE',   '0910', 'Coriander, ginger, turmeric, chilli'),
    ('Fish & Seafood',        'OTHER',     '0302', 'Tilapia, Nile perch, dagaa, prawns')
ON CONFLICT DO NOTHING;

-- ============================================================
-- SEED DATA — 22 Products
-- ============================================================
INSERT INTO products (product_name, local_name, category_id, standard_unit) VALUES
    -- Cereals
    ('Maize (White)',         'Mahindi Mweupe',  (SELECT category_id FROM product_categories WHERE category_name='Cereals & Grains'),  '90 kg bag'),
    ('Maize (Yellow)',        'Mahindi ya Njano', (SELECT category_id FROM product_categories WHERE category_name='Cereals & Grains'), '90 kg bag'),
    ('Wheat',                 'Ngano',            (SELECT category_id FROM product_categories WHERE category_name='Cereals & Grains'), '90 kg bag'),
    ('Rice (Pishori)',        'Mchele wa Pishori',(SELECT category_id FROM product_categories WHERE category_name='Cereals & Grains'), 'kg'),
    ('Sorghum',               'Mtama',            (SELECT category_id FROM product_categories WHERE category_name='Cereals & Grains'), 'kg'),
    -- Legumes
    ('Beans (Rose Coco)',     'Maharagwe',        (SELECT category_id FROM product_categories WHERE category_name='Legumes & Pulses'), 'kg'),
    ('Green Grams',           'Ndengu',           (SELECT category_id FROM product_categories WHERE category_name='Legumes & Pulses'), 'kg'),
    ('Pigeon Peas',           'Mbaazi',           (SELECT category_id FROM product_categories WHERE category_name='Legumes & Pulses'), 'kg'),
    -- Vegetables
    ('Tomatoes',              'Nyanya',           (SELECT category_id FROM product_categories WHERE category_name='Vegetables'),       'crate (64 kg)'),
    ('Kale (Sukuma Wiki)',    'Sukuma Wiki',      (SELECT category_id FROM product_categories WHERE category_name='Vegetables'),       'bunch'),
    ('Cabbage',               'Kabichi',          (SELECT category_id FROM product_categories WHERE category_name='Vegetables'),       'head'),
    ('Onions (Bulb)',         'Vitunguu',         (SELECT category_id FROM product_categories WHERE category_name='Vegetables'),       'kg'),
    ('Carrots',               'Karoti',           (SELECT category_id FROM product_categories WHERE category_name='Vegetables'),       'kg'),
    -- Root Crops
    ('Potatoes (Irish)',      'Viazi',            (SELECT category_id FROM product_categories WHERE category_name='Root Crops & Tubers'), '110 kg bag'),
    ('Sweet Potatoes',        'Viazi Vitamu',     (SELECT category_id FROM product_categories WHERE category_name='Root Crops & Tubers'), 'kg'),
    ('Cassava (Dry)',         'Muhogo Mkavu',     (SELECT category_id FROM product_categories WHERE category_name='Root Crops & Tubers'), 'kg'),
    -- Dairy
    ('Milk (Fresh)',          'Maziwa',           (SELECT category_id FROM product_categories WHERE category_name='Dairy Products'),   'litre'),
    ('Ghee',                  'Siagi',            (SELECT category_id FROM product_categories WHERE category_name='Dairy Products'),   'kg'),
    -- Livestock
    ('Live Goat',             'Mbuzi',            (SELECT category_id FROM product_categories WHERE category_name='Livestock'),       'head'),
    ('Live Cattle (Steer)',   'Ng''ombe',          (SELECT category_id FROM product_categories WHERE category_name='Livestock'),       'head'),
    ('Chicken (Broiler)',     'Kuku wa Nyama',    (SELECT category_id FROM product_categories WHERE category_name='Livestock'),       'head'),
    -- Fish
    ('Tilapia (Fresh)',       'Samaki Safi',      (SELECT category_id FROM product_categories WHERE category_name='Fish & Seafood'),  'kg')
ON CONFLICT DO NOTHING;

-- ============================================================
-- Verify
-- ============================================================
SELECT 'Regions: '    || COUNT(*) FROM regions;
SELECT 'Markets: '    || COUNT(*) FROM markets;
SELECT 'Categories: ' || COUNT(*) FROM product_categories;
SELECT 'Products: '   || COUNT(*) FROM products;
