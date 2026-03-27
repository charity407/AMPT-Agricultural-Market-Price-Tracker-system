--
--

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    log_id integer NOT NULL,
    performed_by integer,
    action_type character varying(50),
    entity_type character varying(100),
    entity_id integer,
    change_details jsonb,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ip_address character varying(45)
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: audit_logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_logs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_log_id_seq OWNER TO postgres;

--
-- Name: audit_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_logs_log_id_seq OWNED BY public.audit_logs.log_id;


--
-- Name: market_agents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.market_agents (
    agent_id integer NOT NULL,
    verification_status character varying(50) DEFAULT 'PENDING'::character varying,
    verified_by integer,
    verification_date timestamp without time zone
);


ALTER TABLE public.market_agents OWNER TO postgres;

--
-- Name: markets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.markets (
    market_id integer NOT NULL,
    market_name character varying(255) NOT NULL,
    town character varying(100),
    latitude numeric(9,6),
    longitude numeric(9,6),
    operating_days character varying(100),
    operating_hours character varying(100),
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    region_id integer
);


ALTER TABLE public.markets OWNER TO postgres;

--
-- Name: markets_market_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.markets_market_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.markets_market_id_seq OWNER TO postgres;

--
-- Name: markets_market_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.markets_market_id_seq OWNED BY public.markets.market_id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    notification_id integer NOT NULL,
    user_id integer,
    alert_id integer,
    channel character varying(20),
    message_content text NOT NULL,
    delivery_status character varying(20) DEFAULT 'PENDING'::character varying,
    sent_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_notification_id_seq OWNER TO postgres;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_notification_id_seq OWNED BY public.notifications.notification_id;


--
-- Name: price_alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_alerts (
    alert_id integer NOT NULL,
    user_id integer,
    product_id integer,
    market_id integer,
    threshold_price numeric(12,2) NOT NULL,
    alert_direction character varying(10),
    is_active boolean DEFAULT true,
    created_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.price_alerts OWNER TO postgres;

--
-- Name: price_alerts_alert_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.price_alerts_alert_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.price_alerts_alert_id_seq OWNER TO postgres;

--
-- Name: price_alerts_alert_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.price_alerts_alert_id_seq OWNED BY public.price_alerts.alert_id;


--
-- Name: price_entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_entries (
    entry_id integer NOT NULL,
    product_id integer,
    market_id integer,
    agent_id integer,
    season_id integer,
    unit_price numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'KES'::character varying,
    price_date date NOT NULL,
    status character varying(20) DEFAULT 'CURRENT'::character varying,
    is_anomaly boolean DEFAULT false,
    corrected_by_id integer,
    notes text,
    submission_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.price_entries OWNER TO postgres;

--
-- Name: price_entries_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.price_entries_entry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.price_entries_entry_id_seq OWNER TO postgres;

--
-- Name: price_entries_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.price_entries_entry_id_seq OWNED BY public.price_entries.entry_id;


--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_categories (
    category_id integer NOT NULL,
    category_name character varying(100) NOT NULL,
    category_type character varying(50),
    eac_code character varying(50)
);


ALTER TABLE public.product_categories OWNER TO postgres;

--
-- Name: product_categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_categories_category_id_seq OWNER TO postgres;

--
-- Name: product_categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_categories_category_id_seq OWNED BY public.product_categories.category_id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name character varying(255) NOT NULL,
    local_name character varying(255),
    standard_unit character varying(50) NOT NULL,
    category_id integer,
    is_active boolean DEFAULT true
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_product_id_seq OWNER TO postgres;

--
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regions (
    region_id integer NOT NULL,
    region_name character varying(100) NOT NULL,
    country character varying(50) DEFAULT 'Kenya'::character varying,
    region_code character varying(10)
);


ALTER TABLE public.regions OWNER TO postgres;

--
-- Name: regions_region_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.regions_region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.regions_region_id_seq OWNER TO postgres;

--
-- Name: regions_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.regions_region_id_seq OWNED BY public.regions.region_id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reports (
    report_id integer NOT NULL,
    requested_by integer,
    report_type character varying(50),
    parameters jsonb,
    format character varying(10),
    status character varying(20) DEFAULT 'PENDING'::character varying,
    generated_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.reports OWNER TO postgres;

--
-- Name: reports_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reports_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reports_report_id_seq OWNER TO postgres;

--
-- Name: reports_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reports_report_id_seq OWNED BY public.reports.report_id;


--
-- Name: seasons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seasons (
    season_id integer NOT NULL,
    season_name character varying(100) NOT NULL,
    season_type character varying(20),
    start_date date NOT NULL,
    end_date date NOT NULL,
    year integer NOT NULL
);


ALTER TABLE public.seasons OWNER TO postgres;

--
-- Name: seasons_season_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seasons_season_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seasons_season_id_seq OWNER TO postgres;

--
-- Name: seasons_season_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seasons_season_id_seq OWNED BY public.seasons.season_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    email_address character varying(255) NOT NULL,
    password_hash text NOT NULL,
    role character varying(50) NOT NULL,
    phone_number character varying(20),
    preferred_language character varying(10) DEFAULT 'ENGLISH'::character varying,
    account_status character varying(50) DEFAULT 'ACTIVE'::character varying,
    is_verified boolean DEFAULT false,
    registration_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: audit_logs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN log_id SET DEFAULT nextval('public.audit_logs_log_id_seq'::regclass);


--
-- Name: markets market_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.markets ALTER COLUMN market_id SET DEFAULT nextval('public.markets_market_id_seq'::regclass);


--
-- Name: notifications notification_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN notification_id SET DEFAULT nextval('public.notifications_notification_id_seq'::regclass);


--
-- Name: price_alerts alert_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_alerts ALTER COLUMN alert_id SET DEFAULT nextval('public.price_alerts_alert_id_seq'::regclass);


--
-- Name: price_entries entry_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_entries ALTER COLUMN entry_id SET DEFAULT nextval('public.price_entries_entry_id_seq'::regclass);


--
-- Name: product_categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories ALTER COLUMN category_id SET DEFAULT nextval('public.product_categories_category_id_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- Name: regions region_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions ALTER COLUMN region_id SET DEFAULT nextval('public.regions_region_id_seq'::regclass);


--
-- Name: reports report_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports ALTER COLUMN report_id SET DEFAULT nextval('public.reports_report_id_seq'::regclass);


--
-- Name: seasons season_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seasons ALTER COLUMN season_id SET DEFAULT nextval('public.seasons_season_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (log_id);


--
-- Name: market_agents market_agents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.market_agents
    ADD CONSTRAINT market_agents_pkey PRIMARY KEY (agent_id);


--
-- Name: markets markets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.markets
    ADD CONSTRAINT markets_pkey PRIMARY KEY (market_id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- Name: price_alerts price_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_alerts
    ADD CONSTRAINT price_alerts_pkey PRIMARY KEY (alert_id);


--
-- Name: price_entries price_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_entries
    ADD CONSTRAINT price_entries_pkey PRIMARY KEY (entry_id);


--
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (category_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (region_id);


--
-- Name: regions regions_region_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_region_code_key UNIQUE (region_code);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (report_id);


--
-- Name: seasons seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (season_id);


--
-- Name: users users_email_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_address_key UNIQUE (email_address);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: idx_price_lookup; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_price_lookup ON public.price_entries USING btree (product_id, market_id, price_date);


--
-- Name: audit_logs audit_logs_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(user_id);


--
-- Name: market_agents market_agents_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.market_agents
    ADD CONSTRAINT market_agents_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.users(user_id);


--
-- Name: market_agents market_agents_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.market_agents
    ADD CONSTRAINT market_agents_verified_by_fkey FOREIGN KEY (verified_by) REFERENCES public.users(user_id);


--
-- Name: markets markets_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.markets
    ADD CONSTRAINT markets_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(region_id);


--
-- Name: notifications notifications_alert_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_alert_id_fkey FOREIGN KEY (alert_id) REFERENCES public.price_alerts(alert_id);


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: price_alerts price_alerts_market_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_alerts
    ADD CONSTRAINT price_alerts_market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(market_id);


--
-- Name: price_alerts price_alerts_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_alerts
    ADD CONSTRAINT price_alerts_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: price_alerts price_alerts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_alerts
    ADD CONSTRAINT price_alerts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: price_entries price_entries_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_entries
    ADD CONSTRAINT price_entries_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.market_agents(agent_id);


--
-- Name: price_entries price_entries_corrected_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_entries
    ADD CONSTRAINT price_entries_corrected_by_id_fkey FOREIGN KEY (corrected_by_id) REFERENCES public.price_entries(entry_id);


--
-- Name: price_entries price_entries_market_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_entries
    ADD CONSTRAINT price_entries_market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(market_id);


--
-- Name: price_entries price_entries_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_entries
    ADD CONSTRAINT price_entries_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: price_entries price_entries_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_entries
    ADD CONSTRAINT price_entries_season_id_fkey FOREIGN KEY (season_id) REFERENCES public.seasons(season_id);


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(category_id);


--
-- Name: reports reports_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--
-- Ensure unit prices are never zero or negative
ALTER TABLE public.price_entries 
ADD CONSTRAINT check_positive_price CHECK (unit_price > 0);

-- Ensure roles are restricted to our defined project roles
ALTER TABLE public.users 
ADD CONSTRAINT check_valid_role 
CHECK (role IN ('ADMIN', 'MARKET_AGENT', 'FARMER', 'TRADER', 'CONSUMER'));


-- Optimized index for time-series charts (Phase 5 Requirement)
CREATE INDEX idx_price_date_trend ON public.price_entries (price_date);



-- 1. CLEANUP & SCHEMA EXTENSION
CREATE TABLE IF NOT EXISTS counties (
    county_code INTEGER PRIMARY KEY,
    county_name VARCHAR(100) NOT NULL,
    region_id INTEGER REFERENCES regions(region_id)
);

-- Add county link to markets
ALTER TABLE markets ADD COLUMN IF NOT EXISTS county_code INTEGER REFERENCES counties(county_code);

-- 2. PERFORMANCE INDEXES (M1 WEEK 2 TASK)
-- ==========================================
CREATE INDEX IF NOT EXISTS idx_price_lookup ON price_entries (product_id, market_id, price_date);
CREATE INDEX IF NOT EXISTS idx_price_date_trend ON price_entries (price_date);

-- ==========================================
--  DATA VALIDATION CONSTRAINTS
-- ==========================================
ALTER TABLE price_entries ADD CONSTRAINT check_positive_price CHECK (unit_price > 0);
ALTER TABLE users ADD CONSTRAINT check_valid_role CHECK (role IN ('ADMIN', 'MARKET_AGENT', 'FARMER', 'TRADER', 'CONSUMER'));

--  MASTER DATA SEEDING (ORDER MATTERS)

-- Regions (The 8 Blocks)
INSERT INTO regions (region_name, region_code) VALUES
('Nairobi', 'NRB'), ('Central', 'CEN'), ('Coast', 'CST'), ('Eastern', 'EST'),
('North Eastern', 'NE'), ('Nyanza', 'NYZ'), ('Rift Valley', 'RV'), ('Western', 'WST')
ON CONFLICT DO NOTHING;

-- The 47 Counties (Linking to the Regions above)
INSERT INTO counties (county_code, county_name, region_id) VALUES
(1, 'Mombasa', 3), (12, 'Meru', 4), (13, 'Tharaka-Nithi', 4), (32, 'Nakuru', 7), (42, 'Kisumu', 6), (47, 'Nairobi', 1)
-- (Add the rest of the 47 here later)
ON CONFLICT DO NOTHING;

-- Product Categories
INSERT INTO product_categories (category_name, category_type, eac_code) VALUES
('Cereals', 'CROP', 'EAC-01'),
('Legumes', 'CROP', 'EAC-02'),
('Vegetables', 'PRODUCE', 'EAC-03'),
('Fruits', 'PRODUCE', 'EAC-04'),
('Livestock', 'LIVESTOCK', 'EAC-05'),
('Dairy', 'DAIRY', 'EAC-06')
ON CONFLICT DO NOTHING;

-- Products
INSERT INTO products (product_name, local_name, standard_unit, category_id) VALUES
('Maize (Dry)', 'Mahindi Kavu', '90kg Bag', 1),
('Beans (Rosecoco)', 'Nyayo', '90kg Bag', 2),
('Tomatoes', 'Nyanya', 'Crate (64kg)', 3),
('Cow Milk', 'Maziwa ya Ngombe', 'Litre', 6)
ON CONFLICT DO NOTHING;

-- Markets (Now linked to Counties)
INSERT INTO markets (market_name, town, region_id, county_code, latitude, longitude) VALUES
('Wakulima Market', 'Nairobi CBD', 1, 47, -1.2858, 36.8315),
('Kongowea Market', 'Mombasa', 3, 1, -4.0415, 39.6800),
('Marikiti Market', 'Mombasa', 3, 1, -4.0620, 39.6730)
ON CONFLICT DO NOTHING;





