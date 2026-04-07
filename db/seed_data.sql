-- Seed data for AMPT database
-- Run after database_setup_fixed.sql
-- Order: regions → product_categories → products → markets

-- ============================================================
-- REGIONS (Kenya's major agricultural regions)
-- ============================================================
INSERT INTO public.regions (region_name, country, region_code) VALUES
  ('Nairobi',          'Kenya', 'NBI'),
  ('Central',          'Kenya', 'CEN'),
  ('Coast',            'Kenya', 'CST'),
  ('Eastern',          'Kenya', 'EST'),
  ('North Eastern',    'Kenya', 'NEA'),
  ('Nyanza',           'Kenya', 'NYA'),
  ('Rift Valley',      'Kenya', 'RFV'),
  ('Western',          'Kenya', 'WST')
ON CONFLICT (region_code) DO NOTHING;

-- ============================================================
-- PRODUCT CATEGORIES
-- ============================================================
INSERT INTO public.product_categories (category_name, category_type, eac_code) VALUES
  ('Cereals & Grains',    'CROP',      'EAC-CER'),
  ('Legumes & Pulses',    'CROP',      'EAC-LEG'),
  ('Vegetables',          'CROP',      'EAC-VEG'),
  ('Fruits',              'CROP',      'EAC-FRT'),
  ('Root Crops & Tubers', 'CROP',      'EAC-ROT'),
  ('Livestock',           'LIVESTOCK', 'EAC-LVS'),
  ('Dairy',               'LIVESTOCK', 'EAC-DAI'),
  ('Poultry',             'LIVESTOCK', 'EAC-POL'),
  ('Cash Crops',          'CASH',      'EAC-CSH')
ON CONFLICT DO NOTHING;

-- ============================================================
-- PRODUCTS
-- ============================================================
INSERT INTO public.products (product_name, local_name, standard_unit, category_id, is_active)
SELECT 'Maize (White)',    'Mahindi',       '90kg bag',  c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Cereals & Grains'
UNION ALL
SELECT 'Maize (Yellow)',   'Mahindi ya Njano','90kg bag', c.category_id, true FROM public.product_categories c WHERE c.category_name = 'Cereals & Grains'
UNION ALL
SELECT 'Wheat',            'Ngano',         '90kg bag',  c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Cereals & Grains'
UNION ALL
SELECT 'Rice (Pishori)',   'Mchele',        '50kg bag',  c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Cereals & Grains'
UNION ALL
SELECT 'Sorghum',          'Mtama',         '90kg bag',  c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Cereals & Grains'
UNION ALL
SELECT 'Millet (Finger)',  'Wimbi',         '50kg bag',  c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Cereals & Grains'
UNION ALL
SELECT 'Beans (Dry)',      'Maharagwe',     'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Legumes & Pulses'
UNION ALL
SELECT 'Green Grams',      'Ndengu',        'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Legumes & Pulses'
UNION ALL
SELECT 'Cowpeas',          'Kunde',         'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Legumes & Pulses'
UNION ALL
SELECT 'Pigeon Peas',      'Mbaazi',        'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Legumes & Pulses'
UNION ALL
SELECT 'Tomatoes',         'Nyanya',        'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Vegetables'
UNION ALL
SELECT 'Kale (Sukuma Wiki)','Sukuma Wiki',  'bundle',    c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Vegetables'
UNION ALL
SELECT 'Onions',           'Vitunguu',      'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Vegetables'
UNION ALL
SELECT 'Cabbage',          'Kabichi',       'head',      c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Vegetables'
UNION ALL
SELECT 'Spinach',          'Mchicha',       'bundle',    c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Vegetables'
UNION ALL
SELECT 'Carrots',          'Karoti',        'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Vegetables'
UNION ALL
SELECT 'Irish Potatoes',   'Viazi Mviringo','50kg bag',  c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Root Crops & Tubers'
UNION ALL
SELECT 'Sweet Potatoes',   'Viazi Vitamu',  'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Root Crops & Tubers'
UNION ALL
SELECT 'Cassava',          'Muhogo',        'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Root Crops & Tubers'
UNION ALL
SELECT 'Yams',             'Mianga',        'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Root Crops & Tubers'
UNION ALL
SELECT 'Bananas (Eating)', 'Ndizi',         'bunch',     c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Fruits'
UNION ALL
SELECT 'Bananas (Cooking)','Matoke',        'bunch',     c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Fruits'
UNION ALL
SELECT 'Mangoes',          'Embe',          'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Fruits'
UNION ALL
SELECT 'Avocados',         'Parachichi',    'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Fruits'
UNION ALL
SELECT 'Pineapples',       'Nanasi',        'piece',     c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Fruits'
UNION ALL
SELECT 'Passion Fruit',    'Pasheni',       'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Fruits'
UNION ALL
SELECT 'Cattle (Beef)',    'Ng''ombe',      'head',      c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Livestock'
UNION ALL
SELECT 'Goats',            'Mbuzi',         'head',      c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Livestock'
UNION ALL
SELECT 'Sheep',            'Kondoo',        'head',      c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Livestock'
UNION ALL
SELECT 'Milk (Fresh)',     'Maziwa',        'litre',     c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Dairy'
UNION ALL
SELECT 'Eggs (Tray)',      'Mayai',         'tray (30)', c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Poultry'
UNION ALL
SELECT 'Chicken (Live)',   'Kuku',          'piece',     c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Poultry'
UNION ALL
SELECT 'Tea (Green Leaf)', 'Chai',          'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Cash Crops'
UNION ALL
SELECT 'Coffee (Cherry)',  'Kahawa',        'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Cash Crops'
UNION ALL
SELECT 'Sunflower Seeds',  'Alizeti',       'kg',        c.category_id, true  FROM public.product_categories c WHERE c.category_name = 'Cash Crops';

-- ============================================================
-- MARKETS (major markets per region)
-- ============================================================
INSERT INTO public.markets (market_name, town, operating_days, operating_hours, status, region_id)
SELECT 'Wakulima Market',       'Nairobi',      'Mon-Sat', '06:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'NBI'
UNION ALL
SELECT 'City Market Nairobi',   'Nairobi',      'Mon-Sun', '07:00-19:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'NBI'
UNION ALL
SELECT 'Kangemi Market',        'Nairobi',      'Mon-Sun', '06:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'NBI'
UNION ALL
SELECT 'Githurai Market',       'Nairobi',      'Mon-Sun', '06:00-19:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'NBI'
UNION ALL
SELECT 'Limuru Market',         'Limuru',       'Mon-Sat', '07:00-17:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'CEN'
UNION ALL
SELECT 'Thika Market',          'Thika',        'Mon-Sat', '06:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'CEN'
UNION ALL
SELECT 'Muranga Market',        'Murang''a',    'Tue,Fri',  '07:00-17:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'CEN'
UNION ALL
SELECT 'Nyeri Market',          'Nyeri',        'Mon-Sat', '07:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'CEN'
UNION ALL
SELECT 'Mombasa Kongowea Market','Mombasa',     'Mon-Sun', '06:00-20:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'CST'
UNION ALL
SELECT 'Kilifi Market',         'Kilifi',       'Mon-Sat', '07:00-17:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'CST'
UNION ALL
SELECT 'Malindi Market',        'Malindi',      'Mon-Sat', '07:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'CST'
UNION ALL
SELECT 'Machakos Market',       'Machakos',     'Mon-Sat', '07:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'EST'
UNION ALL
SELECT 'Meru Market',           'Meru',         'Mon-Sat', '07:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'EST'
UNION ALL
SELECT 'Embu Market',           'Embu',         'Mon-Sat', '07:00-17:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'EST'
UNION ALL
SELECT 'Kitui Market',          'Kitui',        'Wed,Sat',  '07:00-17:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'EST'
UNION ALL
SELECT 'Garissa Market',        'Garissa',      'Mon-Sat', '07:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'NEA'
UNION ALL
SELECT 'Wajir Market',          'Wajir',        'Mon-Sat', '08:00-17:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'NEA'
UNION ALL
SELECT 'Kisumu Jubilee Market', 'Kisumu',       'Mon-Sat', '06:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'NYA'
UNION ALL
SELECT 'Migori Market',         'Migori',       'Mon-Sat', '07:00-17:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'NYA'
UNION ALL
SELECT 'Homa Bay Market',       'Homa Bay',     'Mon-Sat', '07:00-17:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'NYA'
UNION ALL
SELECT 'Kisii Market',          'Kisii',        'Mon-Sat', '07:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'NYA'
UNION ALL
SELECT 'Nakuru Marikiti Market','Nakuru',       'Mon-Sat', '06:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'RFV'
UNION ALL
SELECT 'Eldoret Market',        'Eldoret',      'Mon-Sat', '06:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'RFV'
UNION ALL
SELECT 'Kericho Market',        'Kericho',      'Mon-Sat', '07:00-17:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'RFV'
UNION ALL
SELECT 'Kitale Market',         'Kitale',       'Mon-Sat', '06:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'RFV'
UNION ALL
SELECT 'Narok Market',          'Narok',        'Mon-Sat', '07:00-17:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'RFV'
UNION ALL
SELECT 'Kakamega Market',       'Kakamega',     'Mon-Sat', '07:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'WST'
UNION ALL
SELECT 'Bungoma Market',        'Bungoma',      'Mon-Sat', '07:00-17:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'WST'
UNION ALL
SELECT 'Busia Market',          'Busia',        'Mon-Sun', '07:00-18:00', 'ACTIVE', r.region_id FROM public.regions r WHERE r.region_code = 'WST';
