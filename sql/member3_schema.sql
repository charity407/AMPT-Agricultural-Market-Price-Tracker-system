-- ============================================================
-- AMPT Member 3 Schema v2 — Products, Markets & Regions
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
    ('Nairobi',       'KEN', 'NRB'),
    ('Rift Valley',   'KEN', 'RV'),
    ('Central',       'KEN', 'CTR'),
    ('Coast',         'KEN', 'CST'),
    ('Nyanza',        'KEN', 'NYZ'),
    ('Western',       'KEN', 'WST'),
    ('Eastern',       'KEN', 'EST'),
    ('North Eastern', 'KEN', 'NE')
ON CONFLICT DO NOTHING;

-- ============================================================
-- SEED DATA — 20 Markets (spread across all 8 regions)
-- ============================================================

-- Nairobi (4 markets)
INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Wakulima Market','Haile Selassie Ave','Nairobi',-1.2833,36.8167,'Mon-Sat','05:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='NRB' ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Gikomba Market','Gikomba Rd','Nairobi',-1.2897,36.8451,'Mon-Sun','05:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='NRB' ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'City Market','Muindi Mbingu St','Nairobi',-1.2841,36.8197,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='NRB' ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Kangemi Market','Kangemi','Nairobi',-1.2665,36.7340,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='NRB' ON CONFLICT DO NOTHING;

-- Rift Valley (3 markets)
INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Nakuru Municipal Market','Kenyatta Ave','Nakuru',-0.3031,36.0800,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='RV' ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Eldoret Main Market','Uganda Rd','Eldoret',0.5143,35.2698,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='RV' ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Kitale Market','Kenyatta St','Kitale',1.0154,35.0062,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='RV' ON CONFLICT DO NOTHING;

-- Nyanza (3 markets)
INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Kisumu Main Market','Oginga Odinga St','Kisumu',-0.0917,34.7680,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='NYZ' ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Kibuye Market','Kibuye Roundabout','Kisumu',-0.1022,34.7580,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='NYZ' ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Migori Market','Town Centre','Migori',-1.0634,34.4731,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='NYZ' ON CONFLICT DO NOTHING;

-- Coast (3 markets)
INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Kongowea Market','Kongowea Junction','Mombasa',-4.0435,39.6682,'Mon-Sun','05:00-19:00','ACTIVE',region_id FROM regions WHERE region_code='CST' ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Mwembe Tayari Market','Mwembe Tayari Rd','Mombasa',-4.0610,39.6643,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='CST' ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Malindi Market','Malindi Town','Malindi',-3.2175,40.1169,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='CST' ON CONFLICT DO NOTHING;

-- Central (2 markets)
INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Nyeri Municipal Market','Kimathi Way','Nyeri',-0.4167,36.9500,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='CTR' ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Thika Market','Commercial St','Thika',-1.0332,37.0694,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='CTR' ON CONFLICT DO NOTHING;

-- Western (2 markets)
INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Kakamega Market','Kakamega Town','Kakamega',0.2827,34.7519,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='WST' ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Bungoma Market','Moi Ave','Bungoma',0.5635,34.5606,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='WST' ON CONFLICT DO NOTHING;

-- Eastern (2 markets)
INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Machakos Market','Machakos Town','Machakos',-1.5177,37.2634,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='EST' ON CONFLICT DO NOTHING;

INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Meru Market','Kenyatta Hwy','Meru',0.0467,37.6490,'Mon-Sat','06:00-18:00','ACTIVE',region_id FROM regions WHERE region_code='EST' ON CONFLICT DO NOTHING;

-- North Eastern (1 market)
INSERT INTO markets (market_name,physical_address,town,latitude,longitude,operating_days,operating_hours,status,region_id)
SELECT 'Garissa Market','Garissa Town','Garissa',-0.4532,39.6461,'Mon-Sat','06:00-17:00','ACTIVE',region_id FROM regions WHERE region_code='NE' ON CONFLICT DO NOTHING;

-- ============================================================
-- SEED DATA — Product Categories
-- ============================================================
INSERT INTO product_categories (category_name, category_type, eac_code, description) VALUES
    ('Cereals & Grains',    'CROP',      '1001', 'Maize, wheat, rice, sorghum, millet'),
    ('Legumes & Pulses',    'CROP',      '0713', 'Beans, lentils, green grams, pigeon peas'),
    ('Vegetables',          'PRODUCE',   '0702', 'Tomatoes, kale, cabbage, onions, carrots'),
    ('Fruits',              'PRODUCE',   '0801', 'Bananas, mangoes, avocados, oranges'),
    ('Root Crops & Tubers', 'CROP',      '0714', 'Potatoes, sweet potatoes, cassava'),
    ('Dairy Products',      'LIVESTOCK', '0401', 'Fresh milk, fermented milk, ghee'),
    ('Livestock',           'LIVESTOCK', '0102', 'Cattle, goats, sheep, pigs, poultry'),
    ('Cash Crops',          'CROP',      '0901', 'Coffee, tea, pyrethrum, sunflower'),
    ('Spices & Herbs',      'PRODUCE',   '0910', 'Coriander, ginger, turmeric, chilli'),
    ('Fish & Seafood',      'OTHER',     '0302', 'Tilapia, Nile perch, dagaa, prawns')
ON CONFLICT DO NOTHING;

-- ============================================================
-- SEED DATA — 25 Products
-- ============================================================
INSERT INTO products (product_name, local_name, category_id, standard_unit) VALUES
    -- Cereals (5)
    ('Maize (White)',       'Mahindi Mweupe',   (SELECT category_id FROM product_categories WHERE category_name='Cereals & Grains'),  '90 kg bag'),
    ('Maize (Yellow)',      'Mahindi ya Njano', (SELECT category_id FROM product_categories WHERE category_name='Cereals & Grains'),  '90 kg bag'),
    ('Wheat',               'Ngano',            (SELECT category_id FROM product_categories WHERE category_name='Cereals & Grains'),  '90 kg bag'),
    ('Rice (Pishori)',      'Mchele wa Pishori',(SELECT category_id FROM product_categories WHERE category_name='Cereals & Grains'),  'kg'),
    ('Sorghum',             'Mtama',            (SELECT category_id FROM product_categories WHERE category_name='Cereals & Grains'),  'kg'),
    -- Legumes (4)
    ('Beans (Rose Coco)',   'Maharagwe',        (SELECT category_id FROM product_categories WHERE category_name='Legumes & Pulses'),  'kg'),
    ('Green Grams',         'Ndengu',           (SELECT category_id FROM product_categories WHERE category_name='Legumes & Pulses'),  'kg'),
    ('Pigeon Peas',         'Mbaazi',           (SELECT category_id FROM product_categories WHERE category_name='Legumes & Pulses'),  'kg'),
    ('Lentils',             'Dengu',            (SELECT category_id FROM product_categories WHERE category_name='Legumes & Pulses'),  'kg'),
    -- Vegetables (6)
    ('Tomatoes',            'Nyanya',           (SELECT category_id FROM product_categories WHERE category_name='Vegetables'),        'crate (64 kg)'),
    ('Kale (Sukuma Wiki)',  'Sukuma Wiki',      (SELECT category_id FROM product_categories WHERE category_name='Vegetables'),        'bunch'),
    ('Cabbage',             'Kabichi',          (SELECT category_id FROM product_categories WHERE category_name='Vegetables'),        'head'),
    ('Onions (Bulb)',       'Vitunguu',         (SELECT category_id FROM product_categories WHERE category_name='Vegetables'),        'kg'),
    ('Carrots',             'Karoti',           (SELECT category_id FROM product_categories WHERE category_name='Vegetables'),        'kg'),
    ('Spinach',             'Mchicha',          (SELECT category_id FROM product_categories WHERE category_name='Vegetables'),        'bunch'),
    -- Root Crops (3)
    ('Potatoes (Irish)',    'Viazi',            (SELECT category_id FROM product_categories WHERE category_name='Root Crops & Tubers'), '110 kg bag'),
    ('Sweet Potatoes',      'Viazi Vitamu',     (SELECT category_id FROM product_categories WHERE category_name='Root Crops & Tubers'), 'kg'),
    ('Cassava (Dry)',       'Muhogo Mkavu',     (SELECT category_id FROM product_categories WHERE category_name='Root Crops & Tubers'), 'kg'),
    -- Dairy (2)
    ('Milk (Fresh)',        'Maziwa',           (SELECT category_id FROM product_categories WHERE category_name='Dairy Products'),    'litre'),
    ('Ghee',               'Siagi',            (SELECT category_id FROM product_categories WHERE category_name='Dairy Products'),    'kg'),
    -- Livestock (3)
    ('Live Goat',           'Mbuzi',            (SELECT category_id FROM product_categories WHERE category_name='Livestock'),         'head'),
    ('Live Cattle (Steer)', 'Ng''ombe',          (SELECT category_id FROM product_categories WHERE category_name='Livestock'),         'head'),
    ('Chicken (Broiler)',   'Kuku wa Nyama',    (SELECT category_id FROM product_categories WHERE category_name='Livestock'),         'head'),
    -- Fish (1)
    ('Tilapia (Fresh)',     'Samaki Safi',      (SELECT category_id FROM product_categories WHERE category_name='Fish & Seafood'),    'kg'),
    -- Cash Crops (1)
    ('Coffee (Arabica)',    'Kahawa',           (SELECT category_id FROM product_categories WHERE category_name='Cash Crops'),        'kg')
ON CONFLICT DO NOTHING;

-- ============================================================
-- Verify counts
-- ============================================================
SELECT 'Regions: '    || COUNT(*) FROM regions;
SELECT 'Markets: '    || COUNT(*) FROM markets;
SELECT 'Categories: ' || COUNT(*) FROM product_categories;
SELECT 'Products: '   || COUNT(*) FROM products;
