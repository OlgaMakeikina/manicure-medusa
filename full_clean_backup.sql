--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13
-- Dumped by pg_dump version 15.13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS "medusa-backend";
--
-- Name: medusa-backend; Type: DATABASE; Schema: -; Owner: medusa_user
--

CREATE DATABASE "medusa-backend" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE "medusa-backend" OWNER TO medusa_user;

\encoding SQL_ASCII
\connect -reuse-previous=on "dbname='medusa-backend'"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: claim_reason_enum; Type: TYPE; Schema: public; Owner: medusa_user
--

CREATE TYPE public.claim_reason_enum AS ENUM (
    'missing_item',
    'wrong_item',
    'production_failure',
    'other'
);


ALTER TYPE public.claim_reason_enum OWNER TO medusa_user;

--
-- Name: order_claim_type_enum; Type: TYPE; Schema: public; Owner: medusa_user
--

CREATE TYPE public.order_claim_type_enum AS ENUM (
    'refund',
    'replace'
);


ALTER TYPE public.order_claim_type_enum OWNER TO medusa_user;

--
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: medusa_user
--

CREATE TYPE public.order_status_enum AS ENUM (
    'pending',
    'completed',
    'draft',
    'archived',
    'canceled',
    'requires_action'
);


ALTER TYPE public.order_status_enum OWNER TO medusa_user;

--
-- Name: return_status_enum; Type: TYPE; Schema: public; Owner: medusa_user
--

CREATE TYPE public.return_status_enum AS ENUM (
    'open',
    'requested',
    'received',
    'partially_received',
    'canceled'
);


ALTER TYPE public.return_status_enum OWNER TO medusa_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_holder; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.account_holder (
    id text NOT NULL,
    provider_id text NOT NULL,
    external_id text NOT NULL,
    email text,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.account_holder OWNER TO medusa_user;

--
-- Name: api_key; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.api_key (
    id text NOT NULL,
    token text NOT NULL,
    salt text NOT NULL,
    redacted text NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    last_used_at timestamp with time zone,
    created_by text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_by text,
    revoked_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT api_key_type_check CHECK ((type = ANY (ARRAY['publishable'::text, 'secret'::text])))
);


ALTER TABLE public.api_key OWNER TO medusa_user;

--
-- Name: application_method_buy_rules; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.application_method_buy_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_buy_rules OWNER TO medusa_user;

--
-- Name: application_method_target_rules; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.application_method_target_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_target_rules OWNER TO medusa_user;

--
-- Name: auth_identity; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.auth_identity (
    id text NOT NULL,
    app_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.auth_identity OWNER TO medusa_user;

--
-- Name: capture; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.capture (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb
);


ALTER TABLE public.capture OWNER TO medusa_user;

--
-- Name: cart; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.cart (
    id text NOT NULL,
    region_id text,
    customer_id text,
    sales_channel_id text,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone
);


ALTER TABLE public.cart OWNER TO medusa_user;

--
-- Name: cart_address; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.cart_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_address OWNER TO medusa_user;

--
-- Name: cart_line_item; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.cart_line_item (
    id text NOT NULL,
    cart_id text NOT NULL,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    quantity integer NOT NULL,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    product_type_id text,
    is_custom_price boolean DEFAULT false NOT NULL,
    is_giftcard boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE public.cart_line_item OWNER TO medusa_user;

--
-- Name: cart_line_item_adjustment; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.cart_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text,
    CONSTRAINT cart_line_item_adjustment_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_line_item_adjustment OWNER TO medusa_user;

--
-- Name: cart_line_item_tax_line; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.cart_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text
);


ALTER TABLE public.cart_line_item_tax_line OWNER TO medusa_user;

--
-- Name: cart_payment_collection; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.cart_payment_collection (
    cart_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_payment_collection OWNER TO medusa_user;

--
-- Name: cart_promotion; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.cart_promotion (
    cart_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_promotion OWNER TO medusa_user;

--
-- Name: cart_shipping_method; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.cart_shipping_method (
    id text NOT NULL,
    cart_id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT cart_shipping_method_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_shipping_method OWNER TO medusa_user;

--
-- Name: cart_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.cart_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_adjustment OWNER TO medusa_user;

--
-- Name: cart_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.cart_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_tax_line OWNER TO medusa_user;

--
-- Name: credit_line; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.credit_line (
    id text NOT NULL,
    cart_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.credit_line OWNER TO medusa_user;

--
-- Name: currency; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.currency (
    code text NOT NULL,
    symbol text NOT NULL,
    symbol_native text NOT NULL,
    decimal_digits integer DEFAULT 0 NOT NULL,
    rounding numeric DEFAULT 0 NOT NULL,
    raw_rounding jsonb NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.currency OWNER TO medusa_user;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.customer (
    id text NOT NULL,
    company_name text,
    first_name text,
    last_name text,
    email text,
    phone text,
    has_account boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.customer OWNER TO medusa_user;

--
-- Name: customer_account_holder; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.customer_account_holder (
    customer_id character varying(255) NOT NULL,
    account_holder_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_account_holder OWNER TO medusa_user;

--
-- Name: customer_address; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.customer_address (
    id text NOT NULL,
    customer_id text NOT NULL,
    address_name text,
    is_default_shipping boolean DEFAULT false NOT NULL,
    is_default_billing boolean DEFAULT false NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_address OWNER TO medusa_user;

--
-- Name: customer_group; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.customer_group (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    created_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group OWNER TO medusa_user;

--
-- Name: customer_group_customer; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.customer_group_customer (
    id text NOT NULL,
    customer_id text NOT NULL,
    customer_group_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group_customer OWNER TO medusa_user;

--
-- Name: fulfillment; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.fulfillment (
    id text NOT NULL,
    location_id text NOT NULL,
    packed_at timestamp with time zone,
    shipped_at timestamp with time zone,
    delivered_at timestamp with time zone,
    canceled_at timestamp with time zone,
    data jsonb,
    provider_id text,
    shipping_option_id text,
    metadata jsonb,
    delivery_address_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    marked_shipped_by text,
    created_by text,
    requires_shipping boolean DEFAULT true NOT NULL
);


ALTER TABLE public.fulfillment OWNER TO medusa_user;

--
-- Name: fulfillment_address; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.fulfillment_address (
    id text NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_address OWNER TO medusa_user;

--
-- Name: fulfillment_item; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.fulfillment_item (
    id text NOT NULL,
    title text NOT NULL,
    sku text NOT NULL,
    barcode text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    line_item_id text,
    inventory_item_id text,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_item OWNER TO medusa_user;

--
-- Name: fulfillment_label; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.fulfillment_label (
    id text NOT NULL,
    tracking_number text NOT NULL,
    tracking_url text NOT NULL,
    label_url text NOT NULL,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_label OWNER TO medusa_user;

--
-- Name: fulfillment_provider; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.fulfillment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_provider OWNER TO medusa_user;

--
-- Name: fulfillment_set; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.fulfillment_set (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_set OWNER TO medusa_user;

--
-- Name: geo_zone; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.geo_zone (
    id text NOT NULL,
    type text DEFAULT 'country'::text NOT NULL,
    country_code text NOT NULL,
    province_code text,
    city text,
    service_zone_id text NOT NULL,
    postal_expression jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT geo_zone_type_check CHECK ((type = ANY (ARRAY['country'::text, 'province'::text, 'city'::text, 'zip'::text])))
);


ALTER TABLE public.geo_zone OWNER TO medusa_user;

--
-- Name: image; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.image (
    id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    rank integer DEFAULT 0 NOT NULL,
    product_id text NOT NULL
);


ALTER TABLE public.image OWNER TO medusa_user;

--
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.inventory_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    sku text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    requires_shipping boolean DEFAULT true NOT NULL,
    description text,
    title text,
    thumbnail text,
    metadata jsonb
);


ALTER TABLE public.inventory_item OWNER TO medusa_user;

--
-- Name: inventory_level; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.inventory_level (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    inventory_item_id text NOT NULL,
    location_id text NOT NULL,
    stocked_quantity numeric DEFAULT 0 NOT NULL,
    reserved_quantity numeric DEFAULT 0 NOT NULL,
    incoming_quantity numeric DEFAULT 0 NOT NULL,
    metadata jsonb,
    raw_stocked_quantity jsonb,
    raw_reserved_quantity jsonb,
    raw_incoming_quantity jsonb
);


ALTER TABLE public.inventory_level OWNER TO medusa_user;

--
-- Name: invite; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.invite (
    id text NOT NULL,
    email text NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.invite OWNER TO medusa_user;

--
-- Name: link_module_migrations; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.link_module_migrations (
    id integer NOT NULL,
    table_name character varying(255) NOT NULL,
    link_descriptor jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.link_module_migrations OWNER TO medusa_user;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_user
--

CREATE SEQUENCE public.link_module_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.link_module_migrations_id_seq OWNER TO medusa_user;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_user
--

ALTER SEQUENCE public.link_module_migrations_id_seq OWNED BY public.link_module_migrations.id;


--
-- Name: location_fulfillment_provider; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.location_fulfillment_provider (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_provider OWNER TO medusa_user;

--
-- Name: location_fulfillment_set; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.location_fulfillment_set (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_set OWNER TO medusa_user;

--
-- Name: mikro_orm_migrations; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.mikro_orm_migrations (
    id integer NOT NULL,
    name character varying(255),
    executed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mikro_orm_migrations OWNER TO medusa_user;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_user
--

CREATE SEQUENCE public.mikro_orm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mikro_orm_migrations_id_seq OWNER TO medusa_user;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_user
--

ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNED BY public.mikro_orm_migrations.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.notification (
    id text NOT NULL,
    "to" text NOT NULL,
    channel text NOT NULL,
    template text NOT NULL,
    data jsonb,
    trigger_type text,
    resource_id text,
    resource_type text,
    receiver_id text,
    original_notification_id text,
    idempotency_key text,
    external_id text,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    CONSTRAINT notification_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'success'::text, 'failure'::text])))
);


ALTER TABLE public.notification OWNER TO medusa_user;

--
-- Name: notification_provider; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.notification_provider (
    id text NOT NULL,
    handle text NOT NULL,
    name text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    channels text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.notification_provider OWNER TO medusa_user;

--
-- Name: order; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public."order" (
    id text NOT NULL,
    region_id text,
    display_id integer,
    customer_id text,
    version integer DEFAULT 1 NOT NULL,
    sales_channel_id text,
    status public.order_status_enum DEFAULT 'pending'::public.order_status_enum NOT NULL,
    is_draft_order boolean DEFAULT false NOT NULL,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    no_notification boolean,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone
);


ALTER TABLE public."order" OWNER TO medusa_user;

--
-- Name: order_address; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_address OWNER TO medusa_user;

--
-- Name: order_cart; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_cart (
    order_id character varying(255) NOT NULL,
    cart_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_cart OWNER TO medusa_user;

--
-- Name: order_change; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_change (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    description text,
    status text DEFAULT 'pending'::text NOT NULL,
    internal_note text,
    created_by text,
    requested_by text,
    requested_at timestamp with time zone,
    confirmed_by text,
    confirmed_at timestamp with time zone,
    declined_by text,
    declined_reason text,
    metadata jsonb,
    declined_at timestamp with time zone,
    canceled_by text,
    canceled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    change_type text,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text,
    CONSTRAINT order_change_status_check CHECK ((status = ANY (ARRAY['confirmed'::text, 'declined'::text, 'requested'::text, 'pending'::text, 'canceled'::text])))
);


ALTER TABLE public.order_change OWNER TO medusa_user;

--
-- Name: order_change_action; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_change_action (
    id text NOT NULL,
    order_id text,
    version integer,
    ordering bigint NOT NULL,
    order_change_id text,
    reference text,
    reference_id text,
    action text NOT NULL,
    details jsonb,
    amount numeric,
    raw_amount jsonb,
    internal_note text,
    applied boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_change_action OWNER TO medusa_user;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE; Schema: public; Owner: medusa_user
--

CREATE SEQUENCE public.order_change_action_ordering_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_change_action_ordering_seq OWNER TO medusa_user;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_user
--

ALTER SEQUENCE public.order_change_action_ordering_seq OWNED BY public.order_change_action.ordering;


--
-- Name: order_claim; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_claim (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    type public.order_claim_type_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_claim OWNER TO medusa_user;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_user
--

CREATE SEQUENCE public.order_claim_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_claim_display_id_seq OWNER TO medusa_user;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_user
--

ALTER SEQUENCE public.order_claim_display_id_seq OWNED BY public.order_claim.display_id;


--
-- Name: order_claim_item; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_claim_item (
    id text NOT NULL,
    claim_id text NOT NULL,
    item_id text NOT NULL,
    is_additional_item boolean DEFAULT false NOT NULL,
    reason public.claim_reason_enum,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item OWNER TO medusa_user;

--
-- Name: order_claim_item_image; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_claim_item_image (
    id text NOT NULL,
    claim_item_id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item_image OWNER TO medusa_user;

--
-- Name: order_credit_line; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_credit_line (
    id text NOT NULL,
    order_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_credit_line OWNER TO medusa_user;

--
-- Name: order_display_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_user
--

CREATE SEQUENCE public.order_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_display_id_seq OWNER TO medusa_user;

--
-- Name: order_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_user
--

ALTER SEQUENCE public.order_display_id_seq OWNED BY public."order".display_id;


--
-- Name: order_exchange; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_exchange (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    no_notification boolean,
    allow_backorder boolean DEFAULT false NOT NULL,
    difference_due numeric,
    raw_difference_due jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_exchange OWNER TO medusa_user;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_user
--

CREATE SEQUENCE public.order_exchange_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_exchange_display_id_seq OWNER TO medusa_user;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_user
--

ALTER SEQUENCE public.order_exchange_display_id_seq OWNED BY public.order_exchange.display_id;


--
-- Name: order_exchange_item; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_exchange_item (
    id text NOT NULL,
    exchange_id text NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_exchange_item OWNER TO medusa_user;

--
-- Name: order_fulfillment; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_fulfillment (
    order_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_fulfillment OWNER TO medusa_user;

--
-- Name: order_item; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_item (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    fulfilled_quantity numeric NOT NULL,
    raw_fulfilled_quantity jsonb NOT NULL,
    shipped_quantity numeric NOT NULL,
    raw_shipped_quantity jsonb NOT NULL,
    return_requested_quantity numeric NOT NULL,
    raw_return_requested_quantity jsonb NOT NULL,
    return_received_quantity numeric NOT NULL,
    raw_return_received_quantity jsonb NOT NULL,
    return_dismissed_quantity numeric NOT NULL,
    raw_return_dismissed_quantity jsonb NOT NULL,
    written_off_quantity numeric NOT NULL,
    raw_written_off_quantity jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    delivered_quantity numeric DEFAULT 0 NOT NULL,
    raw_delivered_quantity jsonb NOT NULL,
    unit_price numeric,
    raw_unit_price jsonb,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb
);


ALTER TABLE public.order_item OWNER TO medusa_user;

--
-- Name: order_line_item; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_line_item (
    id text NOT NULL,
    totals_id text,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_price boolean DEFAULT false NOT NULL,
    product_type_id text,
    is_giftcard boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line_item OWNER TO medusa_user;

--
-- Name: order_line_item_adjustment; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_line_item_adjustment OWNER TO medusa_user;

--
-- Name: order_line_item_tax_line; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_line_item_tax_line OWNER TO medusa_user;

--
-- Name: order_payment_collection; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_payment_collection (
    order_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_payment_collection OWNER TO medusa_user;

--
-- Name: order_promotion; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_promotion (
    order_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_promotion OWNER TO medusa_user;

--
-- Name: order_shipping; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_shipping (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    shipping_method_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_shipping OWNER TO medusa_user;

--
-- Name: order_shipping_method; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_shipping_method (
    id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_amount boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_shipping_method OWNER TO medusa_user;

--
-- Name: order_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_adjustment OWNER TO medusa_user;

--
-- Name: order_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_tax_line OWNER TO medusa_user;

--
-- Name: order_summary; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_summary (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    totals jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_summary OWNER TO medusa_user;

--
-- Name: order_transaction; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.order_transaction (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    reference text,
    reference_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_transaction OWNER TO medusa_user;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.payment (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    provider_id text NOT NULL,
    data jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    captured_at timestamp with time zone,
    canceled_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    payment_session_id text NOT NULL,
    metadata jsonb
);


ALTER TABLE public.payment OWNER TO medusa_user;

--
-- Name: payment_collection; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.payment_collection (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    authorized_amount numeric,
    raw_authorized_amount jsonb,
    captured_amount numeric,
    raw_captured_amount jsonb,
    refunded_amount numeric,
    raw_refunded_amount jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone,
    status text DEFAULT 'not_paid'::text NOT NULL,
    metadata jsonb,
    CONSTRAINT payment_collection_status_check CHECK ((status = ANY (ARRAY['not_paid'::text, 'awaiting'::text, 'authorized'::text, 'partially_authorized'::text, 'canceled'::text, 'failed'::text, 'completed'::text])))
);


ALTER TABLE public.payment_collection OWNER TO medusa_user;

--
-- Name: payment_collection_payment_providers; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.payment_collection_payment_providers (
    payment_collection_id text NOT NULL,
    payment_provider_id text NOT NULL
);


ALTER TABLE public.payment_collection_payment_providers OWNER TO medusa_user;

--
-- Name: payment_provider; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.payment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.payment_provider OWNER TO medusa_user;

--
-- Name: payment_session; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.payment_session (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    context jsonb,
    status text DEFAULT 'pending'::text NOT NULL,
    authorized_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT payment_session_status_check CHECK ((status = ANY (ARRAY['authorized'::text, 'captured'::text, 'pending'::text, 'requires_more'::text, 'error'::text, 'canceled'::text])))
);


ALTER TABLE public.payment_session OWNER TO medusa_user;

--
-- Name: price; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.price (
    id text NOT NULL,
    title text,
    price_set_id text NOT NULL,
    currency_code text NOT NULL,
    raw_amount jsonb NOT NULL,
    rules_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    price_list_id text,
    amount numeric NOT NULL,
    min_quantity integer,
    max_quantity integer
);


ALTER TABLE public.price OWNER TO medusa_user;

--
-- Name: price_list; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.price_list (
    id text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    rules_count integer DEFAULT 0,
    title text NOT NULL,
    description text NOT NULL,
    type text DEFAULT 'sale'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT price_list_status_check CHECK ((status = ANY (ARRAY['active'::text, 'draft'::text]))),
    CONSTRAINT price_list_type_check CHECK ((type = ANY (ARRAY['sale'::text, 'override'::text])))
);


ALTER TABLE public.price_list OWNER TO medusa_user;

--
-- Name: price_list_rule; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.price_list_rule (
    id text NOT NULL,
    price_list_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    value jsonb,
    attribute text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.price_list_rule OWNER TO medusa_user;

--
-- Name: price_preference; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.price_preference (
    id text NOT NULL,
    attribute text NOT NULL,
    value text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_preference OWNER TO medusa_user;

--
-- Name: price_rule; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.price_rule (
    id text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    price_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    attribute text DEFAULT ''::text NOT NULL,
    operator text DEFAULT 'eq'::text NOT NULL,
    CONSTRAINT price_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text])))
);


ALTER TABLE public.price_rule OWNER TO medusa_user;

--
-- Name: price_set; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.price_set (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_set OWNER TO medusa_user;

--
-- Name: product; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    subtitle text,
    description text,
    is_giftcard boolean DEFAULT false NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    thumbnail text,
    weight text,
    length text,
    height text,
    width text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    collection_id text,
    type_id text,
    discountable boolean DEFAULT true NOT NULL,
    external_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    CONSTRAINT product_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'proposed'::text, 'published'::text, 'rejected'::text])))
);


ALTER TABLE public.product OWNER TO medusa_user;

--
-- Name: product_category; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_category (
    id text NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    handle text NOT NULL,
    mpath text NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    is_internal boolean DEFAULT false NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    parent_category_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb
);


ALTER TABLE public.product_category OWNER TO medusa_user;

--
-- Name: product_category_product; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_category_product (
    product_id text NOT NULL,
    product_category_id text NOT NULL
);


ALTER TABLE public.product_category_product OWNER TO medusa_user;

--
-- Name: product_collection; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_collection (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_collection OWNER TO medusa_user;

--
-- Name: product_option; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_option (
    id text NOT NULL,
    title text NOT NULL,
    product_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option OWNER TO medusa_user;

--
-- Name: product_option_value; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_option_value (
    id text NOT NULL,
    value text NOT NULL,
    option_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option_value OWNER TO medusa_user;

--
-- Name: product_sales_channel; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_sales_channel (
    product_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_sales_channel OWNER TO medusa_user;

--
-- Name: product_shipping_profile; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_shipping_profile (
    product_id character varying(255) NOT NULL,
    shipping_profile_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_shipping_profile OWNER TO medusa_user;

--
-- Name: product_tag; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_tag (
    id text NOT NULL,
    value text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_tag OWNER TO medusa_user;

--
-- Name: product_tags; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_tags (
    product_id text NOT NULL,
    product_tag_id text NOT NULL
);


ALTER TABLE public.product_tags OWNER TO medusa_user;

--
-- Name: product_type; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_type (
    id text NOT NULL,
    value text NOT NULL,
    metadata json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_type OWNER TO medusa_user;

--
-- Name: product_variant; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_variant (
    id text NOT NULL,
    title text NOT NULL,
    sku text,
    barcode text,
    ean text,
    upc text,
    allow_backorder boolean DEFAULT false NOT NULL,
    manage_inventory boolean DEFAULT true NOT NULL,
    hs_code text,
    origin_country text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    metadata jsonb,
    variant_rank integer DEFAULT 0,
    product_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant OWNER TO medusa_user;

--
-- Name: product_variant_inventory_item; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_variant_inventory_item (
    variant_id character varying(255) NOT NULL,
    inventory_item_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    required_quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_inventory_item OWNER TO medusa_user;

--
-- Name: product_variant_option; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_variant_option (
    variant_id text NOT NULL,
    option_value_id text NOT NULL
);


ALTER TABLE public.product_variant_option OWNER TO medusa_user;

--
-- Name: product_variant_price_set; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.product_variant_price_set (
    variant_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_price_set OWNER TO medusa_user;

--
-- Name: promotion; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.promotion (
    id text NOT NULL,
    code text NOT NULL,
    campaign_id text,
    is_automatic boolean DEFAULT false NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'draft'::text NOT NULL,
    CONSTRAINT promotion_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'inactive'::text]))),
    CONSTRAINT promotion_type_check CHECK ((type = ANY (ARRAY['standard'::text, 'buyget'::text])))
);


ALTER TABLE public.promotion OWNER TO medusa_user;

--
-- Name: promotion_application_method; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.promotion_application_method (
    id text NOT NULL,
    value numeric,
    raw_value jsonb,
    max_quantity integer,
    apply_to_quantity integer,
    buy_rules_min_quantity integer,
    type text NOT NULL,
    target_type text NOT NULL,
    allocation text,
    promotion_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_application_method_allocation_check CHECK ((allocation = ANY (ARRAY['each'::text, 'across'::text]))),
    CONSTRAINT promotion_application_method_target_type_check CHECK ((target_type = ANY (ARRAY['order'::text, 'shipping_methods'::text, 'items'::text]))),
    CONSTRAINT promotion_application_method_type_check CHECK ((type = ANY (ARRAY['fixed'::text, 'percentage'::text])))
);


ALTER TABLE public.promotion_application_method OWNER TO medusa_user;

--
-- Name: promotion_campaign; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.promotion_campaign (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    campaign_identifier text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_campaign OWNER TO medusa_user;

--
-- Name: promotion_campaign_budget; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.promotion_campaign_budget (
    id text NOT NULL,
    type text NOT NULL,
    campaign_id text NOT NULL,
    "limit" numeric,
    raw_limit jsonb,
    used numeric DEFAULT 0 NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_campaign_budget_type_check CHECK ((type = ANY (ARRAY['spend'::text, 'usage'::text])))
);


ALTER TABLE public.promotion_campaign_budget OWNER TO medusa_user;

--
-- Name: promotion_promotion_rule; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.promotion_promotion_rule (
    promotion_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.promotion_promotion_rule OWNER TO medusa_user;

--
-- Name: promotion_rule; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.promotion_rule (
    id text NOT NULL,
    description text,
    attribute text NOT NULL,
    operator text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text, 'ne'::text, 'in'::text])))
);


ALTER TABLE public.promotion_rule OWNER TO medusa_user;

--
-- Name: promotion_rule_value; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.promotion_rule_value (
    id text NOT NULL,
    promotion_rule_id text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_rule_value OWNER TO medusa_user;

--
-- Name: provider_identity; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.provider_identity (
    id text NOT NULL,
    entity_id text NOT NULL,
    provider text NOT NULL,
    auth_identity_id text NOT NULL,
    user_metadata jsonb,
    provider_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.provider_identity OWNER TO medusa_user;

--
-- Name: publishable_api_key_sales_channel; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.publishable_api_key_sales_channel (
    publishable_key_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.publishable_api_key_sales_channel OWNER TO medusa_user;

--
-- Name: refund; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.refund (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb,
    refund_reason_id text,
    note text
);


ALTER TABLE public.refund OWNER TO medusa_user;

--
-- Name: refund_reason; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.refund_reason (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.refund_reason OWNER TO medusa_user;

--
-- Name: region; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.region (
    id text NOT NULL,
    name text NOT NULL,
    currency_code text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    automatic_taxes boolean DEFAULT true NOT NULL
);


ALTER TABLE public.region OWNER TO medusa_user;

--
-- Name: region_country; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.region_country (
    iso_2 text NOT NULL,
    iso_3 text NOT NULL,
    num_code text NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    region_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_country OWNER TO medusa_user;

--
-- Name: region_payment_provider; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.region_payment_provider (
    region_id character varying(255) NOT NULL,
    payment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_payment_provider OWNER TO medusa_user;

--
-- Name: reservation_item; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.reservation_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    line_item_id text,
    location_id text NOT NULL,
    quantity numeric NOT NULL,
    external_id text,
    description text,
    created_by text,
    metadata jsonb,
    inventory_item_id text NOT NULL,
    allow_backorder boolean DEFAULT false,
    raw_quantity jsonb
);


ALTER TABLE public.reservation_item OWNER TO medusa_user;

--
-- Name: return; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.return (
    id text NOT NULL,
    order_id text NOT NULL,
    claim_id text,
    exchange_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    status public.return_status_enum DEFAULT 'open'::public.return_status_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    received_at timestamp with time zone,
    canceled_at timestamp with time zone,
    location_id text,
    requested_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.return OWNER TO medusa_user;

--
-- Name: return_display_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_user
--

CREATE SEQUENCE public.return_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.return_display_id_seq OWNER TO medusa_user;

--
-- Name: return_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_user
--

ALTER SEQUENCE public.return_display_id_seq OWNED BY public.return.display_id;


--
-- Name: return_fulfillment; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.return_fulfillment (
    return_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_fulfillment OWNER TO medusa_user;

--
-- Name: return_item; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.return_item (
    id text NOT NULL,
    return_id text NOT NULL,
    reason_id text,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    received_quantity numeric DEFAULT 0 NOT NULL,
    raw_received_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    damaged_quantity numeric DEFAULT 0 NOT NULL,
    raw_damaged_quantity jsonb NOT NULL
);


ALTER TABLE public.return_item OWNER TO medusa_user;

--
-- Name: return_reason; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.return_reason (
    id character varying NOT NULL,
    value character varying NOT NULL,
    label character varying NOT NULL,
    description character varying,
    metadata jsonb,
    parent_return_reason_id character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_reason OWNER TO medusa_user;

--
-- Name: sales_channel; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.sales_channel (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    is_disabled boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel OWNER TO medusa_user;

--
-- Name: sales_channel_stock_location; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.sales_channel_stock_location (
    sales_channel_id character varying(255) NOT NULL,
    stock_location_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel_stock_location OWNER TO medusa_user;

--
-- Name: script_migrations; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.script_migrations (
    id integer NOT NULL,
    script_name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    finished_at timestamp with time zone
);


ALTER TABLE public.script_migrations OWNER TO medusa_user;

--
-- Name: script_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_user
--

CREATE SEQUENCE public.script_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.script_migrations_id_seq OWNER TO medusa_user;

--
-- Name: script_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_user
--

ALTER SEQUENCE public.script_migrations_id_seq OWNED BY public.script_migrations.id;


--
-- Name: service_zone; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.service_zone (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    fulfillment_set_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.service_zone OWNER TO medusa_user;

--
-- Name: shipping_option; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.shipping_option (
    id text NOT NULL,
    name text NOT NULL,
    price_type text DEFAULT 'flat'::text NOT NULL,
    service_zone_id text NOT NULL,
    shipping_profile_id text,
    provider_id text,
    data jsonb,
    metadata jsonb,
    shipping_option_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_price_type_check CHECK ((price_type = ANY (ARRAY['calculated'::text, 'flat'::text])))
);


ALTER TABLE public.shipping_option OWNER TO medusa_user;

--
-- Name: shipping_option_price_set; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.shipping_option_price_set (
    shipping_option_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_price_set OWNER TO medusa_user;

--
-- Name: shipping_option_rule; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.shipping_option_rule (
    id text NOT NULL,
    attribute text NOT NULL,
    operator text NOT NULL,
    value jsonb,
    shipping_option_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_rule_operator_check CHECK ((operator = ANY (ARRAY['in'::text, 'eq'::text, 'ne'::text, 'gt'::text, 'gte'::text, 'lt'::text, 'lte'::text, 'nin'::text])))
);


ALTER TABLE public.shipping_option_rule OWNER TO medusa_user;

--
-- Name: shipping_option_type; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.shipping_option_type (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    code text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_type OWNER TO medusa_user;

--
-- Name: shipping_profile; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.shipping_profile (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_profile OWNER TO medusa_user;

--
-- Name: stock_location; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.stock_location (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    name text NOT NULL,
    address_id text,
    metadata jsonb
);


ALTER TABLE public.stock_location OWNER TO medusa_user;

--
-- Name: stock_location_address; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.stock_location_address (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    address_1 text NOT NULL,
    address_2 text,
    company text,
    city text,
    country_code text NOT NULL,
    phone text,
    province text,
    postal_code text,
    metadata jsonb
);


ALTER TABLE public.stock_location_address OWNER TO medusa_user;

--
-- Name: store; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.store (
    id text NOT NULL,
    name text DEFAULT 'Medusa Store'::text NOT NULL,
    default_sales_channel_id text,
    default_region_id text,
    default_location_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store OWNER TO medusa_user;

--
-- Name: store_currency; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.store_currency (
    id text NOT NULL,
    currency_code text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    store_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store_currency OWNER TO medusa_user;

--
-- Name: tax_provider; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.tax_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_provider OWNER TO medusa_user;

--
-- Name: tax_rate; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.tax_rate (
    id text NOT NULL,
    rate real,
    code text NOT NULL,
    name text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_combinable boolean DEFAULT false NOT NULL,
    tax_region_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate OWNER TO medusa_user;

--
-- Name: tax_rate_rule; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.tax_rate_rule (
    id text NOT NULL,
    tax_rate_id text NOT NULL,
    reference_id text NOT NULL,
    reference text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate_rule OWNER TO medusa_user;

--
-- Name: tax_region; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.tax_region (
    id text NOT NULL,
    provider_id text,
    country_code text NOT NULL,
    province_code text,
    parent_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone,
    CONSTRAINT "CK_tax_region_country_top_level" CHECK (((parent_id IS NULL) OR (province_code IS NOT NULL))),
    CONSTRAINT "CK_tax_region_provider_top_level" CHECK (((parent_id IS NULL) OR (provider_id IS NULL)))
);


ALTER TABLE public.tax_region OWNER TO medusa_user;

--
-- Name: user; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public."user" (
    id text NOT NULL,
    first_name text,
    last_name text,
    email text NOT NULL,
    avatar_url text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public."user" OWNER TO medusa_user;

--
-- Name: workflow_execution; Type: TABLE; Schema: public; Owner: medusa_user
--

CREATE TABLE public.workflow_execution (
    id character varying NOT NULL,
    workflow_id character varying NOT NULL,
    transaction_id character varying NOT NULL,
    execution jsonb,
    context jsonb,
    state character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    retention_time integer,
    run_id text DEFAULT '01JY1HD928WCP1B7R449HSJ4PF'::text NOT NULL
);


ALTER TABLE public.workflow_execution OWNER TO medusa_user;

--
-- Name: link_module_migrations id; Type: DEFAULT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.link_module_migrations ALTER COLUMN id SET DEFAULT nextval('public.link_module_migrations_id_seq'::regclass);


--
-- Name: mikro_orm_migrations id; Type: DEFAULT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.mikro_orm_migrations ALTER COLUMN id SET DEFAULT nextval('public.mikro_orm_migrations_id_seq'::regclass);


--
-- Name: order display_id; Type: DEFAULT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public."order" ALTER COLUMN display_id SET DEFAULT nextval('public.order_display_id_seq'::regclass);


--
-- Name: order_change_action ordering; Type: DEFAULT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_change_action ALTER COLUMN ordering SET DEFAULT nextval('public.order_change_action_ordering_seq'::regclass);


--
-- Name: order_claim display_id; Type: DEFAULT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_claim ALTER COLUMN display_id SET DEFAULT nextval('public.order_claim_display_id_seq'::regclass);


--
-- Name: order_exchange display_id; Type: DEFAULT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_exchange ALTER COLUMN display_id SET DEFAULT nextval('public.order_exchange_display_id_seq'::regclass);


--
-- Name: return display_id; Type: DEFAULT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.return ALTER COLUMN display_id SET DEFAULT nextval('public.return_display_id_seq'::regclass);


--
-- Name: script_migrations id; Type: DEFAULT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.script_migrations ALTER COLUMN id SET DEFAULT nextval('public.script_migrations_id_seq'::regclass);


--
-- Data for Name: account_holder; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.account_holder (id, provider_id, external_id, email, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: api_key; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.api_key (id, token, salt, redacted, title, type, last_used_at, created_by, created_at, revoked_by, revoked_at, updated_at, deleted_at) FROM stdin;
apk_01JY1HPQSP8AA155F7JEV5KEKJ	pk_8222f0fc611907b2d6ae8e29a9bd5de3b5170c42e639845f0a7178e3d8fc9684		pk_822***684	Frontend	publishable	\N	user_01JY1HHNM47KN5E6QPVPW34E53	2025-06-18 09:54:58.614-03	\N	\N	2025-06-18 09:54:58.614-03	\N
\.


--
-- Data for Name: application_method_buy_rules; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.application_method_buy_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: application_method_target_rules; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.application_method_target_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: auth_identity; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.auth_identity (id, app_metadata, created_at, updated_at, deleted_at) FROM stdin;
authid_01JY1HHNQATXT0FAQ62Y580AT9	{"user_id": "user_01JY1HHNM47KN5E6QPVPW34E53"}	2025-06-18 09:52:12.65-03	2025-06-18 09:52:12.665-03	\N
authid_01JY23QSP1W49PC4Z430SX16N3	{"user_id": "user_01JY23QSJ3GXYWBY9011T0XJHP"}	2025-06-18 15:10:07.681-03	2025-06-18 15:10:07.702-03	\N
\.


--
-- Data for Name: capture; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.capture (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata) FROM stdin;
\.


--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.cart (id, region_id, customer_id, sales_channel_id, email, currency_code, shipping_address_id, billing_address_id, metadata, created_at, updated_at, deleted_at, completed_at) FROM stdin;
\.


--
-- Data for Name: cart_address; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.cart_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_line_item; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.cart_line_item (id, cart_id, title, subtitle, thumbnail, quantity, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, product_type_id, is_custom_price, is_giftcard) FROM stdin;
\.


--
-- Data for Name: cart_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.cart_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- Data for Name: cart_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.cart_line_item_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- Data for Name: cart_payment_collection; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.cart_payment_collection (cart_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_promotion; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.cart_promotion (cart_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.cart_shipping_method (id, cart_id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.cart_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.cart_shipping_method_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: credit_line; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.credit_line (id, cart_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.currency (code, symbol, symbol_native, decimal_digits, rounding, raw_rounding, name, created_at, updated_at, deleted_at) FROM stdin;
usd	$	$	2	0	{"value": "0", "precision": 20}	US Dollar	2025-06-18 09:49:53.286-03	2025-06-18 09:49:53.286-03	\N
cad	CA$	$	2	0	{"value": "0", "precision": 20}	Canadian Dollar	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
eur	тВм	тВм	2	0	{"value": "0", "precision": 20}	Euro	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
aed	AED	╪п.╪е.тАП	2	0	{"value": "0", "precision": 20}	United Arab Emirates Dirham	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
afn	Af	╪Л	0	0	{"value": "0", "precision": 20}	Afghan Afghani	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
all	ALL	Lek	0	0	{"value": "0", "precision": 20}	Albanian Lek	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
amd	AMD	╒д╓А.	0	0	{"value": "0", "precision": 20}	Armenian Dram	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
ars	AR$	$	2	0	{"value": "0", "precision": 20}	Argentine Peso	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
aud	AU$	$	2	0	{"value": "0", "precision": 20}	Australian Dollar	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
azn	man.	╨╝╨░╨╜.	2	0	{"value": "0", "precision": 20}	Azerbaijani Manat	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
bam	KM	KM	2	0	{"value": "0", "precision": 20}	Bosnia-Herzegovina Convertible Mark	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
bdt	Tk	рз│	2	0	{"value": "0", "precision": 20}	Bangladeshi Taka	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
bgn	BGN	╨╗╨▓.	2	0	{"value": "0", "precision": 20}	Bulgarian Lev	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
bhd	BD	╪п.╪и.тАП	3	0	{"value": "0", "precision": 20}	Bahraini Dinar	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
bif	FBu	FBu	0	0	{"value": "0", "precision": 20}	Burundian Franc	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
bnd	BN$	$	2	0	{"value": "0", "precision": 20}	Brunei Dollar	2025-06-18 09:49:53.287-03	2025-06-18 09:49:53.287-03	\N
bob	Bs	Bs	2	0	{"value": "0", "precision": 20}	Bolivian Boliviano	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
brl	R$	R$	2	0	{"value": "0", "precision": 20}	Brazilian Real	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
bwp	BWP	P	2	0	{"value": "0", "precision": 20}	Botswanan Pula	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
byn	Br	╤А╤Г╨▒.	2	0	{"value": "0", "precision": 20}	Belarusian Ruble	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
bzd	BZ$	$	2	0	{"value": "0", "precision": 20}	Belize Dollar	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
cdf	CDF	FrCD	2	0	{"value": "0", "precision": 20}	Congolese Franc	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
chf	CHF	CHF	2	0.05	{"value": "0.05", "precision": 20}	Swiss Franc	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
clp	CL$	$	0	0	{"value": "0", "precision": 20}	Chilean Peso	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
cny	CN┬е	CN┬е	2	0	{"value": "0", "precision": 20}	Chinese Yuan	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
cop	CO$	$	0	0	{"value": "0", "precision": 20}	Colombian Peso	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
crc	тВб	тВб	0	0	{"value": "0", "precision": 20}	Costa Rican Col├│n	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
cve	CV$	CV$	2	0	{"value": "0", "precision": 20}	Cape Verdean Escudo	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
czk	K─Н	K─Н	2	0	{"value": "0", "precision": 20}	Czech Republic Koruna	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
djf	Fdj	Fdj	0	0	{"value": "0", "precision": 20}	Djiboutian Franc	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
dkk	Dkr	kr	2	0	{"value": "0", "precision": 20}	Danish Krone	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
dop	RD$	RD$	2	0	{"value": "0", "precision": 20}	Dominican Peso	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
dzd	DA	╪п.╪м.тАП	2	0	{"value": "0", "precision": 20}	Algerian Dinar	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
eek	Ekr	kr	2	0	{"value": "0", "precision": 20}	Estonian Kroon	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
egp	EGP	╪м.┘Е.тАП	2	0	{"value": "0", "precision": 20}	Egyptian Pound	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
ern	Nfk	Nfk	2	0	{"value": "0", "precision": 20}	Eritrean Nakfa	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
etb	Br	Br	2	0	{"value": "0", "precision": 20}	Ethiopian Birr	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
gbp	┬г	┬г	2	0	{"value": "0", "precision": 20}	British Pound Sterling	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
gel	GEL	GEL	2	0	{"value": "0", "precision": 20}	Georgian Lari	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
ghs	GHтВ╡	GHтВ╡	2	0	{"value": "0", "precision": 20}	Ghanaian Cedi	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
gnf	FG	FG	0	0	{"value": "0", "precision": 20}	Guinean Franc	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
gtq	GTQ	Q	2	0	{"value": "0", "precision": 20}	Guatemalan Quetzal	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
hkd	HK$	$	2	0	{"value": "0", "precision": 20}	Hong Kong Dollar	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
hnl	HNL	L	2	0	{"value": "0", "precision": 20}	Honduran Lempira	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
hrk	kn	kn	2	0	{"value": "0", "precision": 20}	Croatian Kuna	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
huf	Ft	Ft	0	0	{"value": "0", "precision": 20}	Hungarian Forint	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
idr	Rp	Rp	0	0	{"value": "0", "precision": 20}	Indonesian Rupiah	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
ils	тВк	тВк	2	0	{"value": "0", "precision": 20}	Israeli New Sheqel	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
inr	Rs	тВ╣	2	0	{"value": "0", "precision": 20}	Indian Rupee	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
iqd	IQD	╪п.╪╣.тАП	0	0	{"value": "0", "precision": 20}	Iraqi Dinar	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
irr	IRR	я╖╝	0	0	{"value": "0", "precision": 20}	Iranian Rial	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
isk	Ikr	kr	0	0	{"value": "0", "precision": 20}	Icelandic Kr├│na	2025-06-18 09:49:53.291-03	2025-06-18 09:49:53.291-03	\N
jmd	J$	$	2	0	{"value": "0", "precision": 20}	Jamaican Dollar	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
jod	JD	╪п.╪г.тАП	3	0	{"value": "0", "precision": 20}	Jordanian Dinar	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
jpy	┬е	я┐е	0	0	{"value": "0", "precision": 20}	Japanese Yen	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
kes	Ksh	Ksh	2	0	{"value": "0", "precision": 20}	Kenyan Shilling	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
khr	KHR	сЯЫ	2	0	{"value": "0", "precision": 20}	Cambodian Riel	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
kmf	CF	FC	0	0	{"value": "0", "precision": 20}	Comorian Franc	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
krw	тВй	тВй	0	0	{"value": "0", "precision": 20}	South Korean Won	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
kwd	KD	╪п.┘Г.тАП	3	0	{"value": "0", "precision": 20}	Kuwaiti Dinar	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
kzt	KZT	╤В╥г╨│.	2	0	{"value": "0", "precision": 20}	Kazakhstani Tenge	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
lbp	LB┬г	┘Д.┘Д.тАП	0	0	{"value": "0", "precision": 20}	Lebanese Pound	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
lkr	SLRs	SL Re	2	0	{"value": "0", "precision": 20}	Sri Lankan Rupee	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
ltl	Lt	Lt	2	0	{"value": "0", "precision": 20}	Lithuanian Litas	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
lvl	Ls	Ls	2	0	{"value": "0", "precision": 20}	Latvian Lats	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
lyd	LD	╪п.┘Д.тАП	3	0	{"value": "0", "precision": 20}	Libyan Dinar	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
mad	MAD	╪п.┘Е.тАП	2	0	{"value": "0", "precision": 20}	Moroccan Dirham	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
mdl	MDL	MDL	2	0	{"value": "0", "precision": 20}	Moldovan Leu	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
mga	MGA	MGA	0	0	{"value": "0", "precision": 20}	Malagasy Ariary	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
mkd	MKD	MKD	2	0	{"value": "0", "precision": 20}	Macedonian Denar	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
mmk	MMK	K	0	0	{"value": "0", "precision": 20}	Myanma Kyat	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
mnt	MNT	тВо	0	0	{"value": "0", "precision": 20}	Mongolian Tugrig	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
mop	MOP$	MOP$	2	0	{"value": "0", "precision": 20}	Macanese Pataca	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
mur	MURs	MURs	0	0	{"value": "0", "precision": 20}	Mauritian Rupee	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
mxn	MX$	$	2	0	{"value": "0", "precision": 20}	Mexican Peso	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
myr	RM	RM	2	0	{"value": "0", "precision": 20}	Malaysian Ringgit	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
mzn	MTn	MTn	2	0	{"value": "0", "precision": 20}	Mozambican Metical	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
nad	N$	N$	2	0	{"value": "0", "precision": 20}	Namibian Dollar	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
ngn	тВж	тВж	2	0	{"value": "0", "precision": 20}	Nigerian Naira	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
nio	C$	C$	2	0	{"value": "0", "precision": 20}	Nicaraguan C├│rdoba	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
nok	Nkr	kr	2	0	{"value": "0", "precision": 20}	Norwegian Krone	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
npr	NPRs	рдиреЗрд░реВ	2	0	{"value": "0", "precision": 20}	Nepalese Rupee	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
nzd	NZ$	$	2	0	{"value": "0", "precision": 20}	New Zealand Dollar	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
omr	OMR	╪▒.╪╣.тАП	3	0	{"value": "0", "precision": 20}	Omani Rial	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
pab	B/.	B/.	2	0	{"value": "0", "precision": 20}	Panamanian Balboa	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
pen	S/.	S/.	2	0	{"value": "0", "precision": 20}	Peruvian Nuevo Sol	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
php	тВ▒	тВ▒	2	0	{"value": "0", "precision": 20}	Philippine Peso	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
pkr	PKRs	тВи	0	0	{"value": "0", "precision": 20}	Pakistani Rupee	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
pln	z┼В	z┼В	2	0	{"value": "0", "precision": 20}	Polish Zloty	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
pyg	тВ▓	тВ▓	0	0	{"value": "0", "precision": 20}	Paraguayan Guarani	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
qar	QR	╪▒.┘В.тАП	2	0	{"value": "0", "precision": 20}	Qatari Rial	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
ron	RON	RON	2	0	{"value": "0", "precision": 20}	Romanian Leu	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
rsd	din.	╨┤╨╕╨╜.	0	0	{"value": "0", "precision": 20}	Serbian Dinar	2025-06-18 09:49:53.292-03	2025-06-18 09:49:53.292-03	\N
rub	RUB	тВ╜.	2	0	{"value": "0", "precision": 20}	Russian Ruble	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
rwf	RWF	FR	0	0	{"value": "0", "precision": 20}	Rwandan Franc	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
sar	SR	╪▒.╪│.тАП	2	0	{"value": "0", "precision": 20}	Saudi Riyal	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
sdg	SDG	SDG	2	0	{"value": "0", "precision": 20}	Sudanese Pound	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
sek	Skr	kr	2	0	{"value": "0", "precision": 20}	Swedish Krona	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
sgd	S$	$	2	0	{"value": "0", "precision": 20}	Singapore Dollar	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
sos	Ssh	Ssh	0	0	{"value": "0", "precision": 20}	Somali Shilling	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
syp	SY┬г	┘Д.╪│.тАП	0	0	{"value": "0", "precision": 20}	Syrian Pound	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
thb	р╕┐	р╕┐	2	0	{"value": "0", "precision": 20}	Thai Baht	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
tnd	DT	╪п.╪к.тАП	3	0	{"value": "0", "precision": 20}	Tunisian Dinar	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
top	T$	T$	2	0	{"value": "0", "precision": 20}	Tongan Pa╩╗anga	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
try	тВ║	тВ║	2	0	{"value": "0", "precision": 20}	Turkish Lira	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
ttd	TT$	$	2	0	{"value": "0", "precision": 20}	Trinidad and Tobago Dollar	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
twd	NT$	NT$	2	0	{"value": "0", "precision": 20}	New Taiwan Dollar	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
tzs	TSh	TSh	0	0	{"value": "0", "precision": 20}	Tanzanian Shilling	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
uah	тВ┤	тВ┤	2	0	{"value": "0", "precision": 20}	Ukrainian Hryvnia	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
ugx	USh	USh	0	0	{"value": "0", "precision": 20}	Ugandan Shilling	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
uyu	$U	$	2	0	{"value": "0", "precision": 20}	Uruguayan Peso	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
uzs	UZS	UZS	0	0	{"value": "0", "precision": 20}	Uzbekistan Som	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
vef	Bs.F.	Bs.F.	2	0	{"value": "0", "precision": 20}	Venezuelan Bol├нvar	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
vnd	тВл	тВл	0	0	{"value": "0", "precision": 20}	Vietnamese Dong	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
xaf	FCFA	FCFA	0	0	{"value": "0", "precision": 20}	CFA Franc BEAC	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
xof	CFA	CFA	0	0	{"value": "0", "precision": 20}	CFA Franc BCEAO	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
yer	YR	╪▒.┘К.тАП	0	0	{"value": "0", "precision": 20}	Yemeni Rial	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
zar	R	R	2	0	{"value": "0", "precision": 20}	South African Rand	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
zmk	ZK	ZK	0	0	{"value": "0", "precision": 20}	Zambian Kwacha	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
zwl	ZWL$	ZWL$	0	0	{"value": "0", "precision": 20}	Zimbabwean Dollar	2025-06-18 09:49:53.293-03	2025-06-18 09:49:53.293-03	\N
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.customer (id, company_name, first_name, last_name, email, phone, has_account, metadata, created_at, updated_at, deleted_at, created_by) FROM stdin;
\.


--
-- Data for Name: customer_account_holder; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.customer_account_holder (customer_id, account_holder_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_address; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.customer_address (id, customer_id, address_name, is_default_shipping, is_default_billing, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.customer_group (id, name, metadata, created_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group_customer; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.customer_group_customer (id, customer_id, customer_group_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.fulfillment (id, location_id, packed_at, shipped_at, delivered_at, canceled_at, data, provider_id, shipping_option_id, metadata, delivery_address_id, created_at, updated_at, deleted_at, marked_shipped_by, created_by, requires_shipping) FROM stdin;
\.


--
-- Data for Name: fulfillment_address; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.fulfillment_address (id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_item; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.fulfillment_item (id, title, sku, barcode, quantity, raw_quantity, line_item_id, inventory_item_id, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_label; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.fulfillment_label (id, tracking_number, tracking_url, label_url, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.fulfillment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
manual_manual	t	2025-06-18 09:49:53.626-03	2025-06-18 09:49:53.626-03	\N
\.


--
-- Data for Name: fulfillment_set; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.fulfillment_set (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: geo_zone; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.geo_zone (id, type, country_code, province_code, city, service_zone_id, postal_expression, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.image (id, url, metadata, created_at, updated_at, deleted_at, rank, product_id) FROM stdin;
img_01JY4C7DV0QT1BPTJTBNJKCT92	http://localhost:9000/static/1750346111501-blue.jpg	\N	2025-06-19 12:16:57.312-03	2025-06-19 12:16:57.312-03	\N	0	prod_01JY1KH3046A3505DCDG1H12T6
img_01JY4CNX6JXSDZMS7AMVKA0HQX	http://localhost:9000/static/1750346257570-blue.jpg	\N	2025-06-19 12:24:51.794-03	2025-06-19 12:24:51.794-03	\N	0	prod_blue_01
img_01JY4CTB8XMB2KZDKQ16XP8TXY	http://localhost:9000/static/1750346837215-blue.jpg	\N	2025-06-19 12:27:17.277-03	2025-06-19 12:27:17.277-03	\N	0	prod_blue_03
img_01JY4CTN6PMHQR01Z9V935ZWNC	http://localhost:9000/static/1750346813492-blue.jpg	\N	2025-06-19 12:27:27.447-03	2025-06-19 12:27:27.447-03	\N	0	prod_blue_02
img_01JY4CVPE5M8DVVECZ9NG0H063	http://localhost:9000/static/1750346881442-blue.jpg	\N	2025-06-19 12:28:01.478-03	2025-06-19 12:28:01.478-03	\N	0	prod_blue_04
img_01JY4CWAD2M4RG6C6EDM0HXRFN	http://localhost:9000/static/1750346901885-blue.jpg	\N	2025-06-19 12:28:21.922-03	2025-06-19 12:28:21.922-03	\N	0	prod_blue_05
img_01JY4CX3B3GWNN94G6AJ880VNM	http://localhost:9000/static/1750346927404-blue.jpg	\N	2025-06-19 12:28:47.459-03	2025-06-19 12:28:47.459-03	\N	0	prod_red_03
img_01JY4EXDJ4AN1STE33PP307A22	http://localhost:9000/static/1750349035057-blue.jpg	\N	2025-06-19 13:03:55.077-03	2025-06-19 13:03:55.077-03	\N	0	prod_01JY4EXDJ0HWQCX8AT1D1AD65W
img_01JY4FKVF9KBMR3TKM0DPZC1EA	http://localhost:9000/static/1750349770200-blue.jpg	\N	2025-06-19 13:16:10.219-03	2025-06-19 13:16:10.219-03	\N	0	prod_01JY4FKVF8FCC9EQQKEVXG22E8
img_01JY4FPBERABEMN4FKFSQKYDVN	http://localhost:9000/static/1750349852099-blue.jpg	\N	2025-06-19 13:17:32.123-03	2025-06-19 13:17:32.123-03	\N	0	prod_01JY4FPBEQ6MBXYGXHD5NJGJT4
img_01JY4FY2Q407DGRJGFA92X2TJ0	http://localhost:9000/static/1750350105251-blue.jpg	\N	2025-06-19 13:21:45.317-03	2025-06-19 13:21:45.317-03	\N	0	prod_01JY4FXGBET6NRGNZ82MQCGCQQ
img_01JY4G66FAES520JXEYGTABE9E	http://localhost:9000/static/1750350371278-blue.jpg	\N	2025-06-19 13:26:11.307-03	2025-06-19 13:26:11.307-03	\N	0	prod_01JY4G66F54B5TTD40JBZS9Z8Q
img_01JY4G93A3N4G6EVTXH6CKTB4E	http://localhost:9000/static/1750350466344-blue.jpg	\N	2025-06-19 13:27:46.372-03	2025-06-19 13:27:46.372-03	\N	0	prod_01JY4G93A2X0769VP0ZXW0C2GZ
img_01JY4GAA4F9DKZ053DYMXX2ANB	http://localhost:9000/static/1750350506109-blue.jpg	\N	2025-06-19 13:28:26.128-03	2025-06-19 13:28:26.128-03	\N	0	prod_01JY4GAA4EX5CQ1JB73DXNXGKJ
img_01JY4GB82ZASJ1GTCMTD6MVX5T	http://localhost:9000/static/1750350536771-blue.jpg	\N	2025-06-19 13:28:56.8-03	2025-06-19 13:28:56.8-03	\N	0	prod_01JY4GB82XBZQ5KH3E2C4SVQ2C
img_01JY4GC5QJ9SSWDQK60FCHD9E1	http://localhost:9000/static/1750350567137-blue.jpg	\N	2025-06-19 13:29:27.155-03	2025-06-19 13:29:27.155-03	\N	0	prod_01JY4GC5QHBK4Q7SHEGRYHX549
img_01JY4GD2QV00785ZS6YQNPPV5E	http://localhost:9000/static/1750350596836-blue.jpg	\N	2025-06-19 13:29:56.86-03	2025-06-19 13:29:56.86-03	\N	0	prod_01JY4GD2QSD476CYWMSGXZ60XH
img_01JY4GDWHQ1MF54RTRPG3T0325	http://localhost:9000/static/1750350623273-blue.jpg	\N	2025-06-19 13:30:23.287-03	2025-06-19 13:30:23.287-03	\N	0	prod_01JY4GDWHP9WN5NTHP7MD69QZS
img_01JY4GEPVFVZHA8SN810FS4F2J	http://localhost:9000/static/1750350650200-blue.jpg	\N	2025-06-19 13:30:50.224-03	2025-06-19 13:30:50.224-03	\N	0	prod_01JY4GEPVEE41QFNE7XE4854DH
img_01JY4GFNTXKQC7BJ4MVD8WRZCZ	http://localhost:9000/static/1750350681935-blue.jpg	\N	2025-06-19 13:31:21.95-03	2025-06-19 13:31:21.95-03	\N	0	prod_01JY4GFNTWRFQPJBV47TCHGWS5
img_01JY4GGJ1SQBVKZX42GBASSFBX	http://localhost:9000/static/1750350710824-blue.jpg	\N	2025-06-19 13:31:50.843-03	2025-06-19 13:31:50.843-03	\N	0	prod_01JY4GGJ1RMM7WEAH0EYNKGMRT
img_01JY4GJSA5FA10FFXC46ANM7NB	http://localhost:9000/static/1750350783782-blue.jpg	\N	2025-06-19 13:33:03.815-03	2025-06-19 13:33:03.815-03	\N	0	prod_01JY4GJSA30NVKJHFS5BGWFA6C
img_01JY4GKKBKNX23PBAGG3QFJRNA	http://localhost:9000/static/1750350810468-blue.jpg	\N	2025-06-19 13:33:30.484-03	2025-06-19 13:33:30.484-03	\N	0	prod_01JY4GKKBJ8AX2VKCV5A0A7B0H
img_01JY4GMJWN6BV8ZR8VQ5KAZGWB	http://localhost:9000/static/1750350842754-blue.jpg	\N	2025-06-19 13:34:02.774-03	2025-06-19 13:34:02.774-03	\N	0	prod_01JY4GMJWMF7KMPCYDXRZ1GFFE
img_01JY4GNBP250C6M2028B3DGKNT	http://localhost:9000/static/1750350868148-blue.jpg	\N	2025-06-19 13:34:28.162-03	2025-06-19 13:34:28.162-03	\N	0	prod_01JY4GNBP18P28KF7DS1FZSHQX
img_01JY4HDWG340X48Z28FGW0F87M	http://localhost:9000/static/1750351671792-red.jpg	\N	2025-06-19 13:47:51.812-03	2025-06-19 13:47:51.812-03	\N	0	prod_01JY4HDWFZ4GXN6Q1SW3HKG91X
img_01JY4HFCHDJ2JZBSKK5P2AQY2Q	http://localhost:9000/static/1750351720988-red.jpg	\N	2025-06-19 13:48:41.005-03	2025-06-19 13:48:41.005-03	\N	0	prod_01JY4HFCHCC4B2D855369Y2JW7
\.


--
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.inventory_item (id, created_at, updated_at, deleted_at, sku, origin_country, hs_code, mid_code, material, weight, length, height, width, requires_shipping, description, title, thumbnail, metadata) FROM stdin;
\.


--
-- Data for Name: inventory_level; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.inventory_level (id, created_at, updated_at, deleted_at, inventory_item_id, location_id, stocked_quantity, reserved_quantity, incoming_quantity, metadata, raw_stocked_quantity, raw_reserved_quantity, raw_incoming_quantity) FROM stdin;
\.


--
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.invite (id, email, accepted, token, expires_at, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: link_module_migrations; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.link_module_migrations (id, table_name, link_descriptor, created_at) FROM stdin;
1	cart_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "cart", "fromModule": "cart"}	2025-06-18 09:49:49.984805
2	cart_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "cart", "fromModule": "cart"}	2025-06-18 09:49:50.017291
3	location_fulfillment_provider	{"toModel": "fulfillment_provider", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-06-18 09:49:50.044312
4	location_fulfillment_set	{"toModel": "fulfillment_set", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-06-18 09:49:50.053951
5	order_cart	{"toModel": "cart", "toModule": "cart", "fromModel": "order", "fromModule": "order"}	2025-06-18 09:49:50.060471
6	order_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "order", "fromModule": "order"}	2025-06-18 09:49:50.061852
7	order_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "order", "fromModule": "order"}	2025-06-18 09:49:50.06589
8	order_promotion	{"toModel": "promotion", "toModule": "promotion", "fromModel": "order", "fromModule": "order"}	2025-06-18 09:49:50.070574
11	product_variant_inventory_item	{"toModel": "inventory", "toModule": "inventory", "fromModel": "variant", "fromModule": "product"}	2025-06-18 09:49:50.071474
10	product_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "product", "fromModule": "product"}	2025-06-18 09:49:50.071239
12	product_variant_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "variant", "fromModule": "product"}	2025-06-18 09:49:50.071666
9	return_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "return", "fromModule": "order"}	2025-06-18 09:49:50.070888
13	publishable_api_key_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "api_key", "fromModule": "api_key"}	2025-06-18 09:49:50.094029
14	region_payment_provider	{"toModel": "payment_provider", "toModule": "payment", "fromModel": "region", "fromModule": "region"}	2025-06-18 09:49:50.125289
15	sales_channel_stock_location	{"toModel": "location", "toModule": "stock_location", "fromModel": "sales_channel", "fromModule": "sales_channel"}	2025-06-18 09:49:50.149679
16	shipping_option_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "shipping_option", "fromModule": "fulfillment"}	2025-06-18 09:49:50.160024
17	product_shipping_profile	{"toModel": "shipping_profile", "toModule": "fulfillment", "fromModel": "product", "fromModule": "product"}	2025-06-18 09:49:50.179697
18	customer_account_holder	{"toModel": "account_holder", "toModule": "payment", "fromModel": "customer", "fromModule": "customer"}	2025-06-18 09:49:50.194491
\.


--
-- Data for Name: location_fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.location_fulfillment_provider (stock_location_id, fulfillment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: location_fulfillment_set; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.location_fulfillment_set (stock_location_id, fulfillment_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: mikro_orm_migrations; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.mikro_orm_migrations (id, name, executed_at) FROM stdin;
1	Migration20240307161216	2025-06-18 09:49:42.401005-03
2	Migration20241210073813	2025-06-18 09:49:42.401005-03
3	Migration20250106142624	2025-06-18 09:49:42.401005-03
4	Migration20250120110820	2025-06-18 09:49:42.401005-03
5	Migration20240307132720	2025-06-18 09:49:42.55792-03
6	Migration20240719123015	2025-06-18 09:49:42.55792-03
7	Migration20241213063611	2025-06-18 09:49:42.55792-03
8	InitialSetup20240401153642	2025-06-18 09:49:42.878412-03
9	Migration20240601111544	2025-06-18 09:49:42.878412-03
10	Migration202408271511	2025-06-18 09:49:42.878412-03
11	Migration20241122120331	2025-06-18 09:49:42.878412-03
12	Migration20241125090957	2025-06-18 09:49:42.878412-03
13	Migration20250411073236	2025-06-18 09:49:42.878412-03
14	Migration20250516081326	2025-06-18 09:49:42.878412-03
15	Migration20230929122253	2025-06-18 09:49:43.544387-03
16	Migration20240322094407	2025-06-18 09:49:43.544387-03
17	Migration20240322113359	2025-06-18 09:49:43.544387-03
18	Migration20240322120125	2025-06-18 09:49:43.544387-03
19	Migration20240626133555	2025-06-18 09:49:43.544387-03
20	Migration20240704094505	2025-06-18 09:49:43.544387-03
21	Migration20241127114534	2025-06-18 09:49:43.544387-03
22	Migration20241127223829	2025-06-18 09:49:43.544387-03
23	Migration20241128055359	2025-06-18 09:49:43.544387-03
24	Migration20241212190401	2025-06-18 09:49:43.544387-03
25	Migration20250408145122	2025-06-18 09:49:43.544387-03
26	Migration20250409122219	2025-06-18 09:49:43.544387-03
27	Migration20240227120221	2025-06-18 09:49:44.108976-03
28	Migration20240617102917	2025-06-18 09:49:44.108976-03
29	Migration20240624153824	2025-06-18 09:49:44.108976-03
30	Migration20241211061114	2025-06-18 09:49:44.108976-03
31	Migration20250113094144	2025-06-18 09:49:44.108976-03
32	Migration20250120110700	2025-06-18 09:49:44.108976-03
33	Migration20250226130616	2025-06-18 09:49:44.108976-03
34	Migration20240124154000	2025-06-18 09:49:44.594095-03
35	Migration20240524123112	2025-06-18 09:49:44.594095-03
36	Migration20240602110946	2025-06-18 09:49:44.594095-03
37	Migration20241211074630	2025-06-18 09:49:44.594095-03
38	Migration20240115152146	2025-06-18 09:49:44.812837-03
39	Migration20240222170223	2025-06-18 09:49:44.891393-03
40	Migration20240831125857	2025-06-18 09:49:44.891393-03
41	Migration20241106085918	2025-06-18 09:49:44.891393-03
42	Migration20241205095237	2025-06-18 09:49:44.891393-03
43	Migration20241216183049	2025-06-18 09:49:44.891393-03
44	Migration20241218091938	2025-06-18 09:49:44.891393-03
45	Migration20250120115059	2025-06-18 09:49:44.891393-03
46	Migration20250212131240	2025-06-18 09:49:44.891393-03
47	Migration20250326151602	2025-06-18 09:49:44.891393-03
48	Migration20240205173216	2025-06-18 09:49:45.33784-03
49	Migration20240624200006	2025-06-18 09:49:45.33784-03
50	Migration20250120110744	2025-06-18 09:49:45.33784-03
51	InitialSetup20240221144943	2025-06-18 09:49:45.472991-03
52	Migration20240604080145	2025-06-18 09:49:45.472991-03
53	Migration20241205122700	2025-06-18 09:49:45.472991-03
54	InitialSetup20240227075933	2025-06-18 09:49:45.581838-03
55	Migration20240621145944	2025-06-18 09:49:45.581838-03
56	Migration20241206083313	2025-06-18 09:49:45.581838-03
57	Migration20240227090331	2025-06-18 09:49:45.700419-03
58	Migration20240710135844	2025-06-18 09:49:45.700419-03
59	Migration20240924114005	2025-06-18 09:49:45.700419-03
60	Migration20241212052837	2025-06-18 09:49:45.700419-03
61	InitialSetup20240228133303	2025-06-18 09:49:45.923328-03
62	Migration20240624082354	2025-06-18 09:49:45.923328-03
63	Migration20240225134525	2025-06-18 09:49:46.002728-03
64	Migration20240806072619	2025-06-18 09:49:46.002728-03
65	Migration20241211151053	2025-06-18 09:49:46.002728-03
66	Migration20250115160517	2025-06-18 09:49:46.002728-03
67	Migration20250120110552	2025-06-18 09:49:46.002728-03
68	Migration20250123122334	2025-06-18 09:49:46.002728-03
69	Migration20250206105639	2025-06-18 09:49:46.002728-03
70	Migration20250207132723	2025-06-18 09:49:46.002728-03
71	Migration20240219102530	2025-06-18 09:49:46.342591-03
72	Migration20240604100512	2025-06-18 09:49:46.342591-03
73	Migration20240715102100	2025-06-18 09:49:46.342591-03
74	Migration20240715174100	2025-06-18 09:49:46.342591-03
75	Migration20240716081800	2025-06-18 09:49:46.342591-03
76	Migration20240801085921	2025-06-18 09:49:46.342591-03
77	Migration20240821164505	2025-06-18 09:49:46.342591-03
78	Migration20240821170920	2025-06-18 09:49:46.342591-03
79	Migration20240827133639	2025-06-18 09:49:46.342591-03
80	Migration20240902195921	2025-06-18 09:49:46.342591-03
81	Migration20240913092514	2025-06-18 09:49:46.342591-03
82	Migration20240930122627	2025-06-18 09:49:46.342591-03
83	Migration20241014142943	2025-06-18 09:49:46.342591-03
84	Migration20241106085223	2025-06-18 09:49:46.342591-03
85	Migration20241129124827	2025-06-18 09:49:46.342591-03
86	Migration20241217162224	2025-06-18 09:49:46.342591-03
87	Migration20250326151554	2025-06-18 09:49:46.342591-03
88	Migration20250522181137	2025-06-18 09:49:46.342591-03
89	Migration20240205025928	2025-06-18 09:49:47.214612-03
90	Migration20240529080336	2025-06-18 09:49:47.214612-03
91	Migration20241202100304	2025-06-18 09:49:47.214612-03
92	Migration20240214033943	2025-06-18 09:49:47.461956-03
93	Migration20240703095850	2025-06-18 09:49:47.461956-03
94	Migration20241202103352	2025-06-18 09:49:47.461956-03
95	Migration20240311145700_InitialSetupMigration	2025-06-18 09:49:47.610283-03
96	Migration20240821170957	2025-06-18 09:49:47.610283-03
97	Migration20240917161003	2025-06-18 09:49:47.610283-03
98	Migration20241217110416	2025-06-18 09:49:47.610283-03
99	Migration20250113122235	2025-06-18 09:49:47.610283-03
100	Migration20250120115002	2025-06-18 09:49:47.610283-03
101	Migration20240509083918_InitialSetupMigration	2025-06-18 09:49:48.165021-03
102	Migration20240628075401	2025-06-18 09:49:48.165021-03
103	Migration20240830094712	2025-06-18 09:49:48.165021-03
104	Migration20250120110514	2025-06-18 09:49:48.165021-03
105	Migration20231228143900	2025-06-18 09:49:48.537311-03
106	Migration20241206101446	2025-06-18 09:49:48.537311-03
107	Migration20250128174331	2025-06-18 09:49:48.537311-03
108	Migration20250505092459	2025-06-18 09:49:48.537311-03
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.notification (id, "to", channel, template, data, trigger_type, resource_id, resource_type, receiver_id, original_notification_id, idempotency_key, external_id, provider_id, created_at, updated_at, deleted_at, status) FROM stdin;
\.


--
-- Data for Name: notification_provider; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.notification_provider (id, handle, name, is_enabled, channels, created_at, updated_at, deleted_at) FROM stdin;
local	local	local	t	{feed}	2025-06-18 09:49:53.665-03	2025-06-18 09:49:53.665-03	\N
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public."order" (id, region_id, display_id, customer_id, version, sales_channel_id, status, is_draft_order, email, currency_code, shipping_address_id, billing_address_id, no_notification, metadata, created_at, updated_at, deleted_at, canceled_at) FROM stdin;
\.


--
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_cart; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_cart (order_id, cart_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_change; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_change (id, order_id, version, description, status, internal_note, created_by, requested_by, requested_at, confirmed_by, confirmed_at, declined_by, declined_reason, metadata, declined_at, canceled_by, canceled_at, created_at, updated_at, change_type, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_change_action; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_change_action (id, order_id, version, ordering, order_change_id, reference, reference_id, action, details, amount, raw_amount, internal_note, applied, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_claim; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_claim (id, order_id, return_id, order_version, display_id, type, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_claim_item; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_claim_item (id, claim_id, item_id, is_additional_item, reason, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_claim_item_image; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_claim_item_image (id, claim_item_id, url, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_credit_line; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_credit_line (id, order_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_exchange; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_exchange (id, order_id, return_id, order_version, display_id, no_notification, allow_backorder, difference_due, raw_difference_due, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_exchange_item; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_exchange_item (id, exchange_id, item_id, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_fulfillment; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_fulfillment (order_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_item (id, order_id, version, item_id, quantity, raw_quantity, fulfilled_quantity, raw_fulfilled_quantity, shipped_quantity, raw_shipped_quantity, return_requested_quantity, raw_return_requested_quantity, return_received_quantity, raw_return_received_quantity, return_dismissed_quantity, raw_return_dismissed_quantity, written_off_quantity, raw_written_off_quantity, metadata, created_at, updated_at, deleted_at, delivered_quantity, raw_delivered_quantity, unit_price, raw_unit_price, compare_at_unit_price, raw_compare_at_unit_price) FROM stdin;
\.


--
-- Data for Name: order_line_item; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_line_item (id, totals_id, title, subtitle, thumbnail, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, is_custom_price, product_type_id, is_giftcard) FROM stdin;
\.


--
-- Data for Name: order_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_line_item_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_payment_collection; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_payment_collection (order_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_promotion; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_promotion (order_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_shipping (id, order_id, version, shipping_method_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_shipping_method; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_shipping_method (id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at, is_custom_amount) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_shipping_method_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_summary; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_summary (id, order_id, version, totals, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_transaction; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.order_transaction (id, order_id, version, amount, raw_amount, currency_code, reference, reference_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.payment (id, amount, raw_amount, currency_code, provider_id, data, created_at, updated_at, deleted_at, captured_at, canceled_at, payment_collection_id, payment_session_id, metadata) FROM stdin;
\.


--
-- Data for Name: payment_collection; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.payment_collection (id, currency_code, amount, raw_amount, authorized_amount, raw_authorized_amount, captured_amount, raw_captured_amount, refunded_amount, raw_refunded_amount, created_at, updated_at, deleted_at, completed_at, status, metadata) FROM stdin;
\.


--
-- Data for Name: payment_collection_payment_providers; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.payment_collection_payment_providers (payment_collection_id, payment_provider_id) FROM stdin;
\.


--
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.payment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
pp_system_default	t	2025-06-18 09:49:53.362-03	2025-06-18 09:49:53.362-03	\N
\.


--
-- Data for Name: payment_session; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.payment_session (id, currency_code, amount, raw_amount, provider_id, data, context, status, authorized_at, payment_collection_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.price (id, title, price_set_id, currency_code, raw_amount, rules_count, created_at, updated_at, deleted_at, price_list_id, amount, min_quantity, max_quantity) FROM stdin;
price_01JY1KH336Q8GB69SAHRXQ5GZP	\N	pset_01JY1KH337RKAG1JVMBAABAFN7	rub	{"value": "890", "precision": 20}	0	2025-06-18 10:26:50.727-03	2025-06-18 10:26:50.727-03	\N	\N	890	\N	\N
price_variant_blue_02_rub	Default price	pset_variant_blue_02	rub	{"value": 89900, "precision": 2}	0	2025-06-18 21:06:51.112946-03	2025-06-18 21:06:51.112946-03	\N	\N	89900	\N	\N
price_variant_blue_03_rub	Default price	pset_variant_blue_03	rub	{"value": 79900, "precision": 2}	0	2025-06-18 21:06:51.118784-03	2025-06-18 21:06:51.118784-03	\N	\N	79900	\N	\N
price_variant_blue_04_rub	Default price	pset_variant_blue_04	rub	{"value": 84900, "precision": 2}	0	2025-06-18 21:06:51.121512-03	2025-06-18 21:06:51.121512-03	\N	\N	84900	\N	\N
price_variant_blue_05_rub	Default price	pset_variant_blue_05	rub	{"value": 99900, "precision": 2}	0	2025-06-18 21:06:51.124325-03	2025-06-18 21:06:51.124325-03	\N	\N	99900	\N	\N
price_variant_blue_01_rub	Default price	pset_variant_blue_01	rub	{"value": 89900, "precision": 2}	0	2025-06-18 21:06:51.12731-03	2025-06-18 21:06:51.12731-03	\N	\N	89900	\N	\N
price_01JY2SFFDNQ6ZT8C386D4XF84R	\N	pset_01JY2SFFDPKDGE0ZZGWRE28B4C	rub	{"value": "10000", "precision": 20}	0	2025-06-18 21:30:03.703-03	2025-06-18 21:30:03.703-03	\N	\N	10000	\N	\N
price_01JY4EXDMR1C6HYBFAQ8DEBXN5	\N	pset_01JY4EXDMSG98P5YVKNBPK15D0	rub	{"value": "10000", "precision": 20}	0	2025-06-19 13:03:55.161-03	2025-06-19 13:03:55.161-03	\N	\N	10000	\N	\N
price_01JY4FKVHJ4QW88TAGEDTWEEE9	\N	pset_01JY4FKVHJB457ACZTAVQCR0EK	rub	{"value": "10000", "precision": 20}	0	2025-06-19 13:16:10.291-03	2025-06-19 13:16:10.291-03	\N	\N	10000	\N	\N
price_01JY4FPBHEECVSEJ04VF46PN42	\N	pset_01JY4FPBHEYP1PAZE2FFRPKRCK	rub	{"value": "10000", "precision": 20}	0	2025-06-19 13:17:32.207-03	2025-06-19 13:17:32.207-03	\N	\N	10000	\N	\N
price_01JY4FXGD63YSSGWWZF87K8YEJ	\N	pset_01JY4FXGD6Q03M1BFDNNRQ3D0P	rub	{"value": "10000", "precision": 20}	0	2025-06-19 13:21:26.566-03	2025-06-19 13:21:26.566-03	\N	\N	10000	\N	\N
price_01JY4G49R1YCK0Y2JH2JQGVFMY	\N	pset_01JY4G49R1H9KKSRP99RYCJPNH	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:25:09.121-03	2025-06-19 13:25:09.121-03	\N	\N	100	\N	\N
price_01JY4G66HPP6CH06QEHEA72H6N	\N	pset_01JY4G66HPMP5M0Z0BMWMCPDRH	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:26:11.382-03	2025-06-19 13:26:11.382-03	\N	\N	100	\N	\N
price_01JY4G93CMM8RSCMM0RRQZHVJ4	\N	pset_01JY4G93CMAM9RNP83A1QA21AZ	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:27:46.452-03	2025-06-19 13:27:46.452-03	\N	\N	100	\N	\N
price_01JY4GAA6BXAVBPPPTG7NJFNTD	\N	pset_01JY4GAA6CP24SF1M8SSM9R3CG	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:28:26.188-03	2025-06-19 13:28:26.188-03	\N	\N	100	\N	\N
price_01JY4GB86J1TAJ7BFD7XNYTZ1P	\N	pset_01JY4GB86KJDTBSG4GKRDSFEJ6	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:28:56.915-03	2025-06-19 13:28:56.915-03	\N	\N	100	\N	\N
price_01JY4GC5S85TFCE1CK6NNJC6ZT	\N	pset_01JY4GC5S8BKKDGRY9FTNAMKNY	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:29:27.208-03	2025-06-19 13:29:27.208-03	\N	\N	100	\N	\N
price_01JY4GD2T7WPWHE7XKM6R4976T	\N	pset_01JY4GD2T8WCDTYAN98XK4P493	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:29:56.937-03	2025-06-19 13:29:56.937-03	\N	\N	100	\N	\N
price_01JY4GDWK9QG4E5GWE3ZDKPRMA	\N	pset_01JY4GDWK9DEG99C1S0GNSYCE5	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:30:23.337-03	2025-06-19 13:30:23.337-03	\N	\N	100	\N	\N
price_01JY4GEPYDWP6DSZW9QJTC2FM4	\N	pset_01JY4GEPYDWY4JA7VY3HQ0BR0V	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:30:50.318-03	2025-06-19 13:30:50.318-03	\N	\N	100	\N	\N
price_01JY4GFNW9D2BTG06XK4PVZJ3A	\N	pset_01JY4GFNW9APWZBPHYATRFGETY	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:31:21.993-03	2025-06-19 13:31:21.993-03	\N	\N	100	\N	\N
price_01JY4GGJ3MCEYPS4JVFZ7YXEEQ	\N	pset_01JY4GGJ3MEY9D484XRC8RW8WH	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:31:50.901-03	2025-06-19 13:31:50.901-03	\N	\N	100	\N	\N
price_01JY4GJSCQSX419Y2RPRRKKKAC	\N	pset_01JY4GJSCQVG92VA3HCZ8QT6KP	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:33:03.896-03	2025-06-19 13:33:03.896-03	\N	\N	100	\N	\N
price_01JY4GKKD81R8CSASG5Q1HS00G	\N	pset_01JY4GKKD8RVBYSAAT9HXHDMJW	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:33:30.536-03	2025-06-19 13:33:30.536-03	\N	\N	100	\N	\N
price_01JY4GMJZFM7BSZYHM1JKSZXPP	\N	pset_01JY4GMJZFA6BYG404B73AMCGA	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:34:02.864-03	2025-06-19 13:34:02.864-03	\N	\N	100	\N	\N
price_01JY4GNBQSX9TJYEV5BY3E3QNM	\N	pset_01JY4GNBQTVND94MZ53AJ8HC5H	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:34:28.218-03	2025-06-19 13:34:28.218-03	\N	\N	100	\N	\N
price_01JY4HDWJ0D2ZQZCP967RVCB8H	\N	pset_01JY4HDWJ0NR52GZN2ENFKTJYC	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:47:51.873-03	2025-06-19 13:47:51.873-03	\N	\N	100	\N	\N
price_01JY4HFCK3C23J3CG6ETWC7PJX	\N	pset_01JY4HFCK4D2GNTB3DVV9T6H51	rub	{"value": "100", "precision": 20}	0	2025-06-19 13:48:41.06-03	2025-06-19 13:48:41.06-03	\N	\N	100	\N	\N
\.


--
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.price_list (id, status, starts_at, ends_at, rules_count, title, description, type, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price_list_rule; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.price_list_rule (id, price_list_id, created_at, updated_at, deleted_at, value, attribute) FROM stdin;
\.


--
-- Data for Name: price_preference; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.price_preference (id, attribute, value, is_tax_inclusive, created_at, updated_at, deleted_at) FROM stdin;
prpref_01JY1HFKZ2BNC47VNBP267MZ16	currency_code	eur	f	2025-06-18 09:51:05.315-03	2025-06-18 09:51:05.315-03	\N
prpref_01JY1HY6BX3SFJBQEWX0X9EV5T	region_id	reg_01JY1HY6AZXH03A7EFXRBZEXTQ	f	2025-06-18 09:59:02.91-03	2025-06-18 09:59:02.91-03	\N
prpref_01JY1JVASKYRG0C62MBGXF4X3V	currency_code	rub	f	2025-06-18 10:14:57.715-03	2025-06-18 10:14:57.715-03	\N
\.


--
-- Data for Name: price_rule; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.price_rule (id, value, priority, price_id, created_at, updated_at, deleted_at, attribute, operator) FROM stdin;
\.


--
-- Data for Name: price_set; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.price_set (id, created_at, updated_at, deleted_at) FROM stdin;
pset_01JY1KH337RKAG1JVMBAABAFN7	2025-06-18 10:26:50.727-03	2025-06-18 10:26:50.727-03	\N
pset_variant_blue_01	2025-06-18 20:56:01.126454-03	2025-06-18 20:56:01.126454-03	\N
pset_variant_blue_02	2025-06-18 20:56:01.135536-03	2025-06-18 20:56:01.135536-03	\N
pset_variant_blue_03	2025-06-18 20:56:01.138942-03	2025-06-18 20:56:01.138942-03	\N
pset_variant_blue_04	2025-06-18 20:56:01.142723-03	2025-06-18 20:56:01.142723-03	\N
pset_variant_blue_05	2025-06-18 20:56:01.145297-03	2025-06-18 20:56:01.145297-03	\N
pset_01JY2SFFDPKDGE0ZZGWRE28B4C	2025-06-18 21:30:03.703-03	2025-06-18 21:30:03.703-03	\N
pset_01JY4EXDMSG98P5YVKNBPK15D0	2025-06-19 13:03:55.161-03	2025-06-19 13:03:55.161-03	\N
pset_01JY4FKVHJB457ACZTAVQCR0EK	2025-06-19 13:16:10.291-03	2025-06-19 13:16:10.291-03	\N
pset_01JY4FPBHEYP1PAZE2FFRPKRCK	2025-06-19 13:17:32.207-03	2025-06-19 13:17:32.207-03	\N
pset_01JY4FXGD6Q03M1BFDNNRQ3D0P	2025-06-19 13:21:26.566-03	2025-06-19 13:21:26.566-03	\N
pset_01JY4G49R1H9KKSRP99RYCJPNH	2025-06-19 13:25:09.121-03	2025-06-19 13:25:09.121-03	\N
pset_01JY4G66HPMP5M0Z0BMWMCPDRH	2025-06-19 13:26:11.382-03	2025-06-19 13:26:11.382-03	\N
pset_01JY4G93CMAM9RNP83A1QA21AZ	2025-06-19 13:27:46.452-03	2025-06-19 13:27:46.452-03	\N
pset_01JY4GAA6CP24SF1M8SSM9R3CG	2025-06-19 13:28:26.188-03	2025-06-19 13:28:26.188-03	\N
pset_01JY4GB86KJDTBSG4GKRDSFEJ6	2025-06-19 13:28:56.915-03	2025-06-19 13:28:56.915-03	\N
pset_01JY4GC5S8BKKDGRY9FTNAMKNY	2025-06-19 13:29:27.208-03	2025-06-19 13:29:27.208-03	\N
pset_01JY4GD2T8WCDTYAN98XK4P493	2025-06-19 13:29:56.937-03	2025-06-19 13:29:56.937-03	\N
pset_01JY4GDWK9DEG99C1S0GNSYCE5	2025-06-19 13:30:23.337-03	2025-06-19 13:30:23.337-03	\N
pset_01JY4GEPYDWY4JA7VY3HQ0BR0V	2025-06-19 13:30:50.318-03	2025-06-19 13:30:50.318-03	\N
pset_01JY4GFNW9APWZBPHYATRFGETY	2025-06-19 13:31:21.993-03	2025-06-19 13:31:21.993-03	\N
pset_01JY4GGJ3MEY9D484XRC8RW8WH	2025-06-19 13:31:50.901-03	2025-06-19 13:31:50.901-03	\N
pset_01JY4GJSCQVG92VA3HCZ8QT6KP	2025-06-19 13:33:03.896-03	2025-06-19 13:33:03.896-03	\N
pset_01JY4GKKD8RVBYSAAT9HXHDMJW	2025-06-19 13:33:30.536-03	2025-06-19 13:33:30.536-03	\N
pset_01JY4GMJZFA6BYG404B73AMCGA	2025-06-19 13:34:02.863-03	2025-06-19 13:34:02.863-03	\N
pset_01JY4GNBQTVND94MZ53AJ8HC5H	2025-06-19 13:34:28.218-03	2025-06-19 13:34:28.218-03	\N
pset_01JY4HDWJ0NR52GZN2ENFKTJYC	2025-06-19 13:47:51.872-03	2025-06-19 13:47:51.872-03	\N
pset_01JY4HFCK4D2GNTB3DVV9T6H51	2025-06-19 13:48:41.06-03	2025-06-19 13:48:41.06-03	\N
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product (id, title, handle, subtitle, description, is_giftcard, status, thumbnail, weight, length, height, width, origin_country, hs_code, mid_code, material, collection_id, type_id, discountable, external_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
prod_01JY4G66F54B5TTD40JBZS9Z8Q	╨б╨╕╨╜╨╕╨╣ 12	gel-polish-blue-12			f	published	http://localhost:9000/static/1750350371278-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:26:11.307-03	2025-06-19 13:26:11.307-03	\N	\N
prod_01JY4G93A2X0769VP0ZXW0C2GZ	╨б╨╕╨╜╨╕╨╣ 13	gel-polish-blue-13			f	published	http://localhost:9000/static/1750350466344-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:27:46.372-03	2025-06-19 13:27:46.372-03	\N	\N
prod_01JY4GAA4EX5CQ1JB73DXNXGKJ	╨б╨╕╨╜╨╕╨╣ 14	gel-polish-blue-14			f	published	http://localhost:9000/static/1750350506109-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:28:26.128-03	2025-06-19 13:28:26.128-03	\N	\N
prod_01JY4GB82XBZQ5KH3E2C4SVQ2C	╨б╨╕╨╜╨╕╨╣ 15	gel-polish-blue-15			f	published	http://localhost:9000/static/1750350536771-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:28:56.8-03	2025-06-19 13:28:56.8-03	\N	\N
prod_01JY4EXDJ0HWQCX8AT1D1AD65W	╨б╨╕╨╜╨╕╨╣ 08	gel-polish-blue-08			f	published	http://localhost:9000/static/1750349035057-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:03:55.077-03	2025-06-19 13:03:55.077-03	\N	\N
prod_01JY4FKVF8FCC9EQQKEVXG22E8	╨б╨╕╨╜╨╕╨╣ 09	gel-polish-blue-09			f	published	http://localhost:9000/static/1750349770200-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:16:10.218-03	2025-06-19 13:16:10.218-03	\N	\N
prod_01JY4FPBEQ6MBXYGXHD5NJGJT4	╨б╨╕╨╜╨╕╨╣ 10	gel-polish-blue-10			f	published	http://localhost:9000/static/1750349852099-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:17:32.121-03	2025-06-19 13:17:32.121-03	\N	\N
prod_pink_01	╨а╨╛╨╖╨╛╨▓╤Л╨╣ ╨╛╤В╤В╨╡╨╜╨╛╨║ тДЦ01	polish-pink-1	\N	╨б╤В╨╛╨╣╨║╨╕╨╣ ╨╗╨░╨║ ╨┤╨╗╤П ╨╜╨╛╨│╤В╨╡╨╣ pink ╤Ж╨▓╨╡╤В╨░	f	published	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-06-18 15:12:34.169535-03	2025-06-18 21:45:27.097-03	2025-06-18 21:45:27.094-03	{"colorHex": "#EC4899", "baseColor": "pink", "shadeNumber": "PINK-001"}
prod_pink_02	╨а╨╛╨╖╨╛╨▓╤Л╨╣ ╨╛╤В╤В╨╡╨╜╨╛╨║ тДЦ02	polish-pink-2	\N	╨б╤В╨╛╨╣╨║╨╕╨╣ ╨╗╨░╨║ ╨┤╨╗╤П ╨╜╨╛╨│╤В╨╡╨╣ pink ╤Ж╨▓╨╡╤В╨░	f	published	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-06-18 15:12:34.171712-03	2025-06-18 21:45:30.849-03	2025-06-18 21:45:30.848-03	{"colorHex": "#EC4899", "baseColor": "pink", "shadeNumber": "PINK-002"}
prod_red_01	╨Ъ╤А╨░╤Б╨╜╤Л╨╣ ╨╛╤В╤В╨╡╨╜╨╛╨║ тДЦ01	polish-red-1	\N	╨б╤В╨╛╨╣╨║╨╕╨╣ ╨╗╨░╨║ ╨┤╨╗╤П ╨╜╨╛╨│╤В╨╡╨╣ red ╤Ж╨▓╨╡╤В╨░	f	published	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-06-18 15:12:34.149024-03	2025-06-18 21:45:35.249-03	2025-06-18 21:45:35.249-03	{"colorHex": "#DC2626", "baseColor": "red", "shadeNumber": "RED-001"}
prod_red_02	╨Ъ╤А╨░╤Б╨╜╤Л╨╣ ╨╛╤В╤В╨╡╨╜╨╛╨║ тДЦ02	polish-red-2	\N	╨б╤В╨╛╨╣╨║╨╕╨╣ ╨╗╨░╨║ ╨┤╨╗╤П ╨╜╨╛╨│╤В╨╡╨╣ red ╤Ж╨▓╨╡╤В╨░	f	published	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-06-18 15:12:34.16515-03	2025-06-18 21:45:46.77-03	2025-06-18 21:45:46.769-03	{"colorHex": "#DC2626", "baseColor": "red", "shadeNumber": "RED-002"}
prod_01JY1KH3046A3505DCDG1H12T6	╨б╨╕╨╜╨╕╨╣ 01	gel-polish-blue-01	╨Ъ╨╗╨░╤Б╤Б╨╕╤З╨╡╤Б╨║╨╕╨╣ ╨║╤А╨░╤Б╨╜╤Л╨╣ ╨│╨╡╨╗╤М-╨╗╨░╨║	╨б╤В╨╛╨╣╨║╨╕╨╣ ╨│╨╡╨╗╤М-╨╗╨░╨║ ╨╜╨░╤Б╤Л╤Й╨╡╨╜╨╜╨╛╨│╨╛ ╨║╤А╨░╤Б╨╜╨╛╨│╨╛ ╤Ж╨▓╨╡╤В╨░. ╨Ф╨╡╤А╨╢╨╕╤В╤Б╤П ╨┤╨╛ 3 ╨╜╨╡╨┤╨╡╨╗╤М, ╨╜╨╡ ╤Б╨║╨░╨╗╤Л╨▓╨░╨╡╤В╤Б╤П.	f	published	http://localhost:9000/static/1750346111501-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-18 10:26:50.634-03	2025-06-19 13:18:09.03-03	\N	\N
prod_01JY4GC5QHBK4Q7SHEGRYHX549	╨б╨╕╨╜╨╕╨╣ 16	gel-polish-blue-16			f	published	http://localhost:9000/static/1750350567137-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:29:27.155-03	2025-06-19 13:29:27.155-03	\N	\N
prod_blue_01	╨б╨╕╨╜╨╕╨╣ 02	polish-blue-1	\N	╨б╤В╨╛╨╣╨║╨╕╨╣ ╨╗╨░╨║ ╨┤╨╗╤П ╨╜╨╛╨│╤В╨╡╨╣ blue ╤Ж╨▓╨╡╤В╨░	f	published	http://localhost:9000/static/1750346257570-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-18 15:12:34.173366-03	2025-06-19 13:19:11.001-03	\N	{"colorHex": "#2563EB", "baseColor": "blue", "shadeNumber": "BLUE-001"}
prod_01JY4GD2QSD476CYWMSGXZ60XH	╨б╨╕╨╜╨╕╨╣ 17	gel-polish-blue-17			f	published	http://localhost:9000/static/1750350596836-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:29:56.859-03	2025-06-19 13:29:56.859-03	\N	\N
prod_blue_02	╨б╨╕╨╜╨╕╨╣ 03	deep-blue	\N	╨Я╤А╨╛╤Д╨╡╤Б╤Б╨╕╨╛╨╜╨░╨╗╤М╨╜╤Л╨╣ ╨╗╨░╨║ ╨┤╨╗╤П ╨╜╨╛╨│╤В╨╡╨╣ ╨│╨╗╤Г╨▒╨╛╨║╨╕╨╣ ╤Б╨╕╨╜╨╕╨╣	f	published	http://localhost:9000/static/1750346813492-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-18 20:33:23.200225-03	2025-06-19 13:19:58.323-03	\N	\N
prod_01JY4GDWHP9WN5NTHP7MD69QZS	╨б╨╕╨╜╨╕╨╣ 18	gel-polish-blue-18			f	published	http://localhost:9000/static/1750350623273-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:30:23.287-03	2025-06-19 13:30:23.287-03	\N	\N
prod_01JY4GEPVEE41QFNE7XE4854DH	╨б╨╕╨╜╨╕╨╣ 19	gel-polish-blue-19			f	published	http://localhost:9000/static/1750350650200-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:30:50.224-03	2025-06-19 13:30:50.224-03	\N	\N
prod_01JY4GFNTWRFQPJBV47TCHGWS5	╨б╨╕╨╜╨╕╨╣ 20	gel-polish-blue-20			f	published	http://localhost:9000/static/1750350681935-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:31:21.95-03	2025-06-19 13:31:21.95-03	\N	\N
prod_blue_03	╨б╨╕╨╜╨╕╨╣ 04	sky-blue	\N	╨Я╤А╨╛╤Д╨╡╤Б╤Б╨╕╨╛╨╜╨░╨╗╤М╨╜╤Л╨╣ ╨╗╨░╨║ ╨┤╨╗╤П ╨╜╨╛╨│╤В╨╡╨╣ ╨╜╨╡╨▒╨╡╤Б╨╜╨╛ ╤Б╨╕╨╜╨╕╨╣	f	published	http://localhost:9000/static/1750346837215-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-18 20:33:23.205487-03	2025-06-19 13:20:12.156-03	\N	\N
prod_blue_04	╨б╨╕╨╜╨╕╨╣ 05	blue-glitter	\N	╨Я╤А╨╛╤Д╨╡╤Б╤Б╨╕╨╛╨╜╨░╨╗╤М╨╜╤Л╨╣ ╨╗╨░╨║ ╨┤╨╗╤П ╨╜╨╛╨│╤В╨╡╨╣ ╤Б╨╕╨╜╨╕╨╣ ╤Б ╨▒╨╗╤С╤Б╤В╨║╨░╨╝╨╕	f	published	http://localhost:9000/static/1750346881442-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-18 20:33:23.207187-03	2025-06-19 13:20:26.151-03	\N	\N
prod_blue_05	╨б╨╕╨╜╨╕╨╣ 06	ocean-blue	\N	╨Я╤А╨╛╤Д╨╡╤Б╤Б╨╕╨╛╨╜╨░╨╗╤М╨╜╤Л╨╣ ╨╗╨░╨║ ╨┤╨╗╤П ╨╜╨╛╨│╤В╨╡╨╣ ╨╝╨╛╤А╤Б╨║╨╛╨╣ ╤Б╨╕╨╜╨╕╨╣	f	published	http://localhost:9000/static/1750346901885-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-18 20:33:23.208679-03	2025-06-19 13:20:39.051-03	\N	\N
prod_01JY4GNBP18P28KF7DS1FZSHQX	╨б╨╕╨╜╨╕╨╣ 25	gel-polish-blue-25			f	published	http://localhost:9000/static/1750350868148-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:34:28.162-03	2025-06-19 13:34:28.162-03	\N	\N
prod_01JY4FXGBET6NRGNZ82MQCGCQQ	╨б╨╕╨╜╨╕╨╣ 11	gel-polish-blue-11			f	published	http://localhost:9000/static/1750350105251-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:21:26.512-03	2025-06-19 13:21:45.317-03	\N	\N
prod_red_03	╨б╨╕╨╜╨╕╨╣ 07	polish-red-3	\N	╨б╤В╨╛╨╣╨║╨╕╨╣ ╨╗╨░╨║ ╨┤╨╗╤П ╨╜╨╛╨│╤В╨╡╨╣ red ╤Ж╨▓╨╡╤В╨░	f	published	http://localhost:9000/static/1750346927404-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-18 15:12:34.16734-03	2025-06-19 13:24:30.95-03	\N	{"colorHex": "#DC2626", "baseColor": "red", "shadeNumber": "RED-003"}
prod_01JY4GGJ1RMM7WEAH0EYNKGMRT	╨б╨╕╨╜╨╕╨╣ 21	gel-polish-blue-21			f	published	http://localhost:9000/static/1750350710824-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:31:50.843-03	2025-06-19 13:31:50.843-03	\N	\N
prod_01JY4GJSA30NVKJHFS5BGWFA6C	╨б╨╕╨╜╨╕╨╣ 22	gel-polish-blue-22			f	published	http://localhost:9000/static/1750350783782-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:33:03.814-03	2025-06-19 13:33:03.814-03	\N	\N
prod_01JY4GKKBJ8AX2VKCV5A0A7B0H	╨б╨╕╨╜╨╕╨╣ 23	gel-polish-blue-23			f	published	http://localhost:9000/static/1750350810468-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:33:30.484-03	2025-06-19 13:33:30.484-03	\N	\N
prod_01JY4GMJWMF7KMPCYDXRZ1GFFE	╨б╨╕╨╜╨╕╨╣ 24	gel-polish-blue-24			f	published	http://localhost:9000/static/1750350842754-blue.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:34:02.774-03	2025-06-19 13:34:02.774-03	\N	\N
prod_01JY4HDWFZ4GXN6Q1SW3HKG91X	╨Ъ╤А╨░╤Б╨╜╤Л╨╣ 01	gel-polish-red-01			f	published	http://localhost:9000/static/1750351671792-red.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:47:51.812-03	2025-06-19 13:47:51.812-03	\N	\N
prod_01JY4HFCHCC4B2D855369Y2JW7	╨Ъ╤А╨░╤Б╨╜╤Л╨╣ 02	gel-polish-red-02			f	published	http://localhost:9000/static/1750351720988-red.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	ptyp_01JY1K33EGN2SA1D18D40KMWCX	t	\N	2025-06-19 13:48:41.005-03	2025-06-19 13:48:41.005-03	\N	\N
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_category (id, name, description, handle, mpath, is_active, is_internal, rank, parent_category_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
pcat_01JY1K8RAWPC6GR20GAQP179QS	╨Ы╨░╨║╨╕ ╨┤╨╗╤П ╨╜╨╛╨│╤В╨╡╨╣	╨ж╨▓╨╡╤В╨╜╤Л╨╡ ╨╗╨░╨║╨╕, ╨│╨╡╨╗╤М-╨╗╨░╨║╨╕ ╨╕ ╨╛╨▒╤Л╤З╨╜╤Л╨╡ ╨╗╨░╨║╨╕	nail-polish	pcat_01JY1K8RAWPC6GR20GAQP179QS	t	f	0	\N	2025-06-18 10:22:17.565-03	2025-06-18 10:22:17.565-03	\N	\N
pcat_01JY1K99CFRR6ZE3BXJYR2711H	╨Я╨╛╨║╤А╤Л╤В╨╕╤П	╨С╨░╨╖╤Л, ╤В╨╛╨┐╤Л, ╨╖╨░╨║╤А╨╡╨┐╨╕╤В╨╡╨╗╨╕	coatings	pcat_01JY1K99CFRR6ZE3BXJYR2711H	t	f	1	\N	2025-06-18 10:22:35.024-03	2025-06-18 10:22:35.024-03	\N	\N
pcat_01JY1K9WX8EPSNDJE538DQ2A27	╨Ш╨╜╤Б╤В╤А╤Г╨╝╨╡╨╜╤В╤Л	╨Я╨╕╨╗╨║╨╕, ╨║╤Г╤Б╨░╤З╨║╨╕, ╨┐╤Г╤И╨╡╤А╤Л, ╨║╨╕╤Б╤В╨╕	tools	pcat_01JY1K9WX8EPSNDJE538DQ2A27	t	f	2	\N	2025-06-18 10:22:55.017-03	2025-06-18 10:22:55.017-03	\N	\N
pcat_01JY1KAGB6C89C2E03RBK72XEK	╨а╨░╤Б╤Е╨╛╨┤╨╜╨╕╨║╨╕	╨б╨░╨╗╤Д╨╡╤В╨║╨╕, ╨▓╨░╤В╨╜╤Л╨╡ ╨┤╨╕╤Б╨║╨╕, ╨╢╨╕╨┤╨║╨╛╤Б╤В╨╕	supplies	pcat_01JY1KAGB6C89C2E03RBK72XEK	t	f	3	\N	2025-06-18 10:23:14.919-03	2025-06-18 10:23:14.919-03	\N	\N
pcat_01JY1KBZCSGBSCJMFWK0H9SX65	╨У╨╡╨╗╤М-╨╗╨░╨║╨╕		gel-polish	pcat_01JY1K8RAWPC6GR20GAQP179QS.pcat_01JY1KBZCSGBSCJMFWK0H9SX65	t	f	0	pcat_01JY1K8RAWPC6GR20GAQP179QS	2025-06-18 10:24:03.098-03	2025-06-18 10:24:03.098-03	\N	\N
\.


--
-- Data for Name: product_category_product; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_category_product (product_id, product_category_id) FROM stdin;
prod_01JY1KH3046A3505DCDG1H12T6	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_blue_01	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_blue_02	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_blue_03	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_blue_04	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_blue_05	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4EXDJ0HWQCX8AT1D1AD65W	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4FKVF8FCC9EQQKEVXG22E8	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4FPBEQ6MBXYGXHD5NJGJT4	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4FXGBET6NRGNZ82MQCGCQQ	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_red_03	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4G66F54B5TTD40JBZS9Z8Q	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4G93A2X0769VP0ZXW0C2GZ	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4GAA4EX5CQ1JB73DXNXGKJ	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4GB82XBZQ5KH3E2C4SVQ2C	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4GC5QHBK4Q7SHEGRYHX549	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4GD2QSD476CYWMSGXZ60XH	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4GDWHP9WN5NTHP7MD69QZS	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4GEPVEE41QFNE7XE4854DH	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4GFNTWRFQPJBV47TCHGWS5	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4GGJ1RMM7WEAH0EYNKGMRT	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4GJSA30NVKJHFS5BGWFA6C	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4GKKBJ8AX2VKCV5A0A7B0H	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4GMJWMF7KMPCYDXRZ1GFFE	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4GNBP18P28KF7DS1FZSHQX	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4HDWFZ4GXN6Q1SW3HKG91X	pcat_01JY1K8RAWPC6GR20GAQP179QS
prod_01JY4HFCHCC4B2D855369Y2JW7	pcat_01JY1K8RAWPC6GR20GAQP179QS
\.


--
-- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_collection (id, title, handle, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_option; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_option (id, title, product_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
opt_01JY1KH307SPKN7V96PHJ85X26	Default option	prod_01JY1KH3046A3505DCDG1H12T6	\N	2025-06-18 10:26:50.634-03	2025-06-18 10:26:50.634-03	\N
opt_01JY2Q5AQ40QVSA3ZD6BE3QBCK	Blue	prod_blue_01	\N	2025-06-18 20:49:34.053-03	2025-06-18 20:50:26.457-03	2025-06-18 20:50:26.455-03
opt_01JY2SBPWTNHCFBT61V7KDSDSX	Default option	prod_blue_01	\N	2025-06-18 21:28:00.282-03	2025-06-18 21:28:00.282-03	\N
opt_01JY4EXDJ4K2D03K7T68X3YFE2	Default option	prod_01JY4EXDJ0HWQCX8AT1D1AD65W	\N	2025-06-19 13:03:55.077-03	2025-06-19 13:03:55.077-03	\N
opt_01JY4FKVF9RGZBMDNWBYZG8140	Default option	prod_01JY4FKVF8FCC9EQQKEVXG22E8	\N	2025-06-19 13:16:10.219-03	2025-06-19 13:16:10.219-03	\N
opt_01JY4FPBERNAFHT2TTE50ZEYMR	Default option	prod_01JY4FPBEQ6MBXYGXHD5NJGJT4	\N	2025-06-19 13:17:32.121-03	2025-06-19 13:17:32.121-03	\N
opt_01JY4FXGBFFMEV45CXN01E8788	Default option	prod_01JY4FXGBET6NRGNZ82MQCGCQQ	\N	2025-06-19 13:21:26.512-03	2025-06-19 13:21:26.512-03	\N
opt_01JY4G2R8VP707CRNYM32GZEHE	Blue	prod_red_03	\N	2025-06-19 13:24:18.459-03	2025-06-19 13:24:18.459-03	\N
opt_01JY4G66F651AZRTA3JRV772RG	Default option	prod_01JY4G66F54B5TTD40JBZS9Z8Q	\N	2025-06-19 13:26:11.307-03	2025-06-19 13:26:11.307-03	\N
opt_01JY4G93A3AEKWT0DP5A8H8YDQ	Default option	prod_01JY4G93A2X0769VP0ZXW0C2GZ	\N	2025-06-19 13:27:46.372-03	2025-06-19 13:27:46.372-03	\N
opt_01JY4GAA4EP97GPA317WD8PF0F	Default option	prod_01JY4GAA4EX5CQ1JB73DXNXGKJ	\N	2025-06-19 13:28:26.128-03	2025-06-19 13:28:26.128-03	\N
opt_01JY4GB82ZHNCJNCTTZQ9XFF9T	Default option	prod_01JY4GB82XBZQ5KH3E2C4SVQ2C	\N	2025-06-19 13:28:56.8-03	2025-06-19 13:28:56.8-03	\N
opt_01JY4GC5QJS40S8526SJTZJ7N0	Default option	prod_01JY4GC5QHBK4Q7SHEGRYHX549	\N	2025-06-19 13:29:27.155-03	2025-06-19 13:29:27.155-03	\N
opt_01JY4GD2QT6VYH94BG2X5JZBKQ	Default option	prod_01JY4GD2QSD476CYWMSGXZ60XH	\N	2025-06-19 13:29:56.859-03	2025-06-19 13:29:56.859-03	\N
opt_01JY4GDWHP84DA99YKMFZ8G69W	Default option	prod_01JY4GDWHP9WN5NTHP7MD69QZS	\N	2025-06-19 13:30:23.287-03	2025-06-19 13:30:23.287-03	\N
opt_01JY4GEPVF2P2WJ7BHA85W32M6	Default option	prod_01JY4GEPVEE41QFNE7XE4854DH	\N	2025-06-19 13:30:50.224-03	2025-06-19 13:30:50.224-03	\N
opt_01JY4GFNTXJQK0S67X34752RWK	Default option	prod_01JY4GFNTWRFQPJBV47TCHGWS5	\N	2025-06-19 13:31:21.95-03	2025-06-19 13:31:21.95-03	\N
opt_01JY4GGJ1SN4JR79PQ4K9027G9	Default option	prod_01JY4GGJ1RMM7WEAH0EYNKGMRT	\N	2025-06-19 13:31:50.843-03	2025-06-19 13:31:50.843-03	\N
opt_01JY4GJSA58SKEJBVE90YBNDQZ	Default option	prod_01JY4GJSA30NVKJHFS5BGWFA6C	\N	2025-06-19 13:33:03.814-03	2025-06-19 13:33:03.814-03	\N
opt_01JY4GKKBK6HBYZEE157G1RGPQ	Default option	prod_01JY4GKKBJ8AX2VKCV5A0A7B0H	\N	2025-06-19 13:33:30.484-03	2025-06-19 13:33:30.484-03	\N
opt_01JY4GMJWNG1EY9KQQDPX97E2R	Default option	prod_01JY4GMJWMF7KMPCYDXRZ1GFFE	\N	2025-06-19 13:34:02.774-03	2025-06-19 13:34:02.774-03	\N
opt_01JY4GNBP1T1FEMAS1Y0T1VTHN	Default option	prod_01JY4GNBP18P28KF7DS1FZSHQX	\N	2025-06-19 13:34:28.162-03	2025-06-19 13:34:28.162-03	\N
opt_01JY4HDWG3HHGBVC9J7XG5SM3B	Default option	prod_01JY4HDWFZ4GXN6Q1SW3HKG91X	\N	2025-06-19 13:47:51.812-03	2025-06-19 13:47:51.812-03	\N
opt_01JY4HFCHDQ4W082G9TE3KA8SD	Default option	prod_01JY4HFCHCC4B2D855369Y2JW7	\N	2025-06-19 13:48:41.005-03	2025-06-19 13:48:41.005-03	\N
\.


--
-- Data for Name: product_option_value; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_option_value (id, value, option_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
optval_01JY1KH3077NMWJMY8HRVK7482	Default option value	opt_01JY1KH307SPKN7V96PHJ85X26	\N	2025-06-18 10:26:50.634-03	2025-06-18 10:26:50.634-03	\N
optval_01JY2SCMYVRD4S0PK1M4FWWPEN	Default option value	opt_01JY2SBPWTNHCFBT61V7KDSDSX	\N	2025-06-18 21:28:31.049789-03	2025-06-18 21:28:31.049789-03	\N
optval_01JY4EXDJ36DH0BAKWDKVP0CP8	Default option value	opt_01JY4EXDJ4K2D03K7T68X3YFE2	\N	2025-06-19 13:03:55.077-03	2025-06-19 13:03:55.077-03	\N
optval_01JY4FKVF9W46G2ES9P145XKTN	Default option value	opt_01JY4FKVF9RGZBMDNWBYZG8140	\N	2025-06-19 13:16:10.219-03	2025-06-19 13:16:10.219-03	\N
optval_01JY4FPBERVWMTR2VRN5S9W1NZ	Default option value	opt_01JY4FPBERNAFHT2TTE50ZEYMR	\N	2025-06-19 13:17:32.121-03	2025-06-19 13:17:32.121-03	\N
optval_01JY4FXGBFPGPCW0S1CFBRFGS9	Default option value	opt_01JY4FXGBFFMEV45CXN01E8788	\N	2025-06-19 13:21:26.512-03	2025-06-19 13:21:26.512-03	\N
optval_01JY4G2R8TH0DNR0NJHGC8ENZF	Default option value	opt_01JY4G2R8VP707CRNYM32GZEHE	\N	2025-06-19 13:24:18.459-03	2025-06-19 13:24:18.459-03	\N
optval_01JY4G66F6TFAF8JXRJE8VYGF9	Default option value	opt_01JY4G66F651AZRTA3JRV772RG	\N	2025-06-19 13:26:11.307-03	2025-06-19 13:26:11.307-03	\N
optval_01JY4G93A3DEBA2N0VMWPE57TF	Default option value	opt_01JY4G93A3AEKWT0DP5A8H8YDQ	\N	2025-06-19 13:27:46.372-03	2025-06-19 13:27:46.372-03	\N
optval_01JY4GAA4E29R9WQFV4EHTX7JY	Default option value	opt_01JY4GAA4EP97GPA317WD8PF0F	\N	2025-06-19 13:28:26.128-03	2025-06-19 13:28:26.128-03	\N
optval_01JY4GB82YG9J9ESQ9PX62EXVC	Default option value	opt_01JY4GB82ZHNCJNCTTZQ9XFF9T	\N	2025-06-19 13:28:56.8-03	2025-06-19 13:28:56.8-03	\N
optval_01JY4GC5QJCVZ2JA5ZNE1YYNP7	Default option value	opt_01JY4GC5QJS40S8526SJTZJ7N0	\N	2025-06-19 13:29:27.155-03	2025-06-19 13:29:27.155-03	\N
optval_01JY4GD2QTYH44S8MX3Z4C2DAB	Default option value	opt_01JY4GD2QT6VYH94BG2X5JZBKQ	\N	2025-06-19 13:29:56.86-03	2025-06-19 13:29:56.86-03	\N
optval_01JY4GDWHPF85927VMXFVSBC0K	Default option value	opt_01JY4GDWHP84DA99YKMFZ8G69W	\N	2025-06-19 13:30:23.287-03	2025-06-19 13:30:23.287-03	\N
optval_01JY4GEPVE8C1BAFRM32P0T1K6	Default option value	opt_01JY4GEPVF2P2WJ7BHA85W32M6	\N	2025-06-19 13:30:50.224-03	2025-06-19 13:30:50.224-03	\N
optval_01JY4GFNTXJ50Z1Q742QFYYN63	Default option value	opt_01JY4GFNTXJQK0S67X34752RWK	\N	2025-06-19 13:31:21.95-03	2025-06-19 13:31:21.95-03	\N
optval_01JY4GGJ1STCQ0N8P59RHRSARH	Default option value	opt_01JY4GGJ1SN4JR79PQ4K9027G9	\N	2025-06-19 13:31:50.843-03	2025-06-19 13:31:50.843-03	\N
optval_01JY4GJSA4JXQYSQCQGK2JECAP	Default option value	opt_01JY4GJSA58SKEJBVE90YBNDQZ	\N	2025-06-19 13:33:03.814-03	2025-06-19 13:33:03.814-03	\N
optval_01JY4GKKBKTK36RTR8V9KNED6M	Default option value	opt_01JY4GKKBK6HBYZEE157G1RGPQ	\N	2025-06-19 13:33:30.484-03	2025-06-19 13:33:30.484-03	\N
optval_01JY4GMJWM8DB4AXBABB59ATGG	Default option value	opt_01JY4GMJWNG1EY9KQQDPX97E2R	\N	2025-06-19 13:34:02.774-03	2025-06-19 13:34:02.774-03	\N
optval_01JY4GNBP1QNGJ51YD9FTZ2CVX	Default option value	opt_01JY4GNBP1T1FEMAS1Y0T1VTHN	\N	2025-06-19 13:34:28.162-03	2025-06-19 13:34:28.162-03	\N
optval_01JY4HDWG2X38CRKZH6F8FAHNZ	Default option value	opt_01JY4HDWG3HHGBVC9J7XG5SM3B	\N	2025-06-19 13:47:51.812-03	2025-06-19 13:47:51.812-03	\N
optval_01JY4HFCHD841YB6TG5TRKJMNQ	Default option value	opt_01JY4HFCHDQ4W082G9TE3KA8SD	\N	2025-06-19 13:48:41.005-03	2025-06-19 13:48:41.005-03	\N
\.


--
-- Data for Name: product_sales_channel; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_sales_channel (product_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01JY1KH3046A3505DCDG1H12T6	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY1KH315FS2HGAXK1X52T4GT	2025-06-18 10:26:50.660581-03	2025-06-18 10:26:50.660581-03	\N
prod_red_03	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY23ZT3E15B5VC6PPT7Q5AK3	2025-06-18 15:14:30.254248-03	2025-06-18 15:14:30.254248-03	\N
prod_blue_01	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY2PM9261XAKZMXTTMNSGV5V	2025-06-18 20:40:15.301897-03	2025-06-18 20:40:15.301897-03	\N
prod_blue_02	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY2PN7RHGYPHF8WAPNZRBMH6	2025-06-18 20:40:46.737142-03	2025-06-18 20:40:46.737142-03	\N
prod_blue_03	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY2PNXSNSVD092FRDT66K84A	2025-06-18 20:41:09.30145-03	2025-06-18 20:41:09.30145-03	\N
prod_blue_04	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY2PPA1EQ2VC4EQYGCZQ1ZCZ	2025-06-18 20:41:21.838236-03	2025-06-18 20:41:21.838236-03	\N
prod_blue_05	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY2PY02MRH4F9W0JF7SX4BH6	2025-06-18 20:45:33.779489-03	2025-06-18 20:45:33.779489-03	\N
prod_01JY4EXDJ0HWQCX8AT1D1AD65W	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4EXDJWYQ820NTN7E09GHWT	2025-06-19 13:03:55.099291-03	2025-06-19 13:03:55.099291-03	\N
prod_01JY4FKVF8FCC9EQQKEVXG22E8	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4FKVFTQ9DK9KBXRXZYPMXA	2025-06-19 13:16:10.233974-03	2025-06-19 13:16:10.233974-03	\N
prod_01JY4FPBEQ6MBXYGXHD5NJGJT4	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4FPBFGYMPQHWRQ71TBXYVW	2025-06-19 13:17:32.140759-03	2025-06-19 13:17:32.140759-03	\N
prod_01JY4FXGBET6NRGNZ82MQCGCQQ	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4FXGC0MGBRGEZC4FQC50MF	2025-06-19 13:21:26.527869-03	2025-06-19 13:21:26.527869-03	\N
prod_01JY4G66F54B5TTD40JBZS9Z8Q	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4G66GBM466Y8SYC78J8M2M	2025-06-19 13:26:11.338591-03	2025-06-19 13:26:11.338591-03	\N
prod_01JY4G93A2X0769VP0ZXW0C2GZ	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4G93AT54ZRTQHBTBDC077K	2025-06-19 13:27:46.393702-03	2025-06-19 13:27:46.393702-03	\N
prod_01JY4GAA4EX5CQ1JB73DXNXGKJ	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4GAA4YZ5A01KXPA106N9A1	2025-06-19 13:28:26.14243-03	2025-06-19 13:28:26.14243-03	\N
prod_01JY4GB82XBZQ5KH3E2C4SVQ2C	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4GB83RAFDG1VQXNF5MPB28	2025-06-19 13:28:56.823744-03	2025-06-19 13:28:56.823744-03	\N
prod_01JY4GC5QHBK4Q7SHEGRYHX549	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4GC5R0RYQ5MM1W0QDAP32A	2025-06-19 13:29:27.168433-03	2025-06-19 13:29:27.168433-03	\N
prod_01JY4GD2QSD476CYWMSGXZ60XH	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4GD2RRBYD10PK0FXWGJRTE	2025-06-19 13:29:56.887877-03	2025-06-19 13:29:56.887877-03	\N
prod_01JY4GDWHP9WN5NTHP7MD69QZS	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4GDWJ6GDMTRGJZ256ZPZFM	2025-06-19 13:30:23.301965-03	2025-06-19 13:30:23.301965-03	\N
prod_01JY4GEPVEE41QFNE7XE4854DH	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4GEPW89QG91SXM9CZYDKDC	2025-06-19 13:30:50.244551-03	2025-06-19 13:30:50.244551-03	\N
prod_01JY4GFNTWRFQPJBV47TCHGWS5	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4GFNV6X1F9F7G6F2VG679A	2025-06-19 13:31:21.958825-03	2025-06-19 13:31:21.958825-03	\N
prod_01JY4GGJ1RMM7WEAH0EYNKGMRT	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4GGJ25KC2YN2S5SR6AH525	2025-06-19 13:31:50.853259-03	2025-06-19 13:31:50.853259-03	\N
prod_01JY4GJSA30NVKJHFS5BGWFA6C	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4GJSBB9F968WHVE6Z0JGHA	2025-06-19 13:33:03.839667-03	2025-06-19 13:33:03.839667-03	\N
prod_01JY4GKKBJ8AX2VKCV5A0A7B0H	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4GKKC3Z6A7C98S7T14CVWE	2025-06-19 13:33:30.499335-03	2025-06-19 13:33:30.499335-03	\N
prod_01JY4GMJWMF7KMPCYDXRZ1GFFE	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4GMJXD70YF5RVEW4GHXC7Y	2025-06-19 13:34:02.793646-03	2025-06-19 13:34:02.793646-03	\N
prod_01JY4GNBP18P28KF7DS1FZSHQX	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4GNBPG8WDZXJJTWGDYF9E0	2025-06-19 13:34:28.176186-03	2025-06-19 13:34:28.176186-03	\N
prod_01JY4HDWFZ4GXN6Q1SW3HKG91X	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4HDWGMEPM5QTVZFZG44FBC	2025-06-19 13:47:51.828762-03	2025-06-19 13:47:51.828762-03	\N
prod_01JY4HFCHCC4B2D855369Y2JW7	sc_01JY1HFKX850G8R56F4N9SDZM0	prodsc_01JY4HFCHVZPE6EC35PQF3SKJN	2025-06-19 13:48:41.019107-03	2025-06-19 13:48:41.019107-03	\N
\.


--
-- Data for Name: product_shipping_profile; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_shipping_profile (product_id, shipping_profile_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_tag; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_tag (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_tags (product_id, product_tag_id) FROM stdin;
\.


--
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_type (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
ptyp_01JY1K33EGN2SA1D18D40KMWCX	Nail Polish	\N	2025-06-18 10:19:12.337-03	2025-06-18 10:19:12.337-03	\N
ptyp_01JY1K3F82DN77GP86VHJ2ZSR1	Base Coat	\N	2025-06-18 10:19:24.418-03	2025-06-18 10:19:24.418-03	\N
ptyp_01JY1K3VZQ4J5YX0RFGJC4GDZE	Top Coat	\N	2025-06-18 10:19:37.463-03	2025-06-18 10:19:37.463-03	\N
ptyp_01JY1K461Y5G38F7WSSFE1W6FV	Tools	\N	2025-06-18 10:19:47.775-03	2025-06-18 10:19:47.775-03	\N
ptyp_01JY1K4EXZKXPEB2JP01PNAAGS	Supplies	\N	2025-06-18 10:19:56.863-03	2025-06-18 10:19:56.863-03	\N
\.


--
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_variant (id, title, sku, barcode, ean, upc, allow_backorder, manage_inventory, hs_code, origin_country, mid_code, material, weight, length, height, width, metadata, variant_rank, product_id, created_at, updated_at, deleted_at) FROM stdin;
variant_blue_02	15 ╨╝╨╗	DEEP-BLUE-15ML	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_blue_02	2025-06-18 20:52:53.683957-03	2025-06-18 20:52:53.683957-03	\N
variant_blue_03	15 ╨╝╨╗	SKY-BLUE-15ML	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_blue_03	2025-06-18 20:52:53.686239-03	2025-06-18 20:52:53.686239-03	\N
variant_blue_04	15 ╨╝╨╗	BLUE-GLITTER-15ML	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_blue_04	2025-06-18 20:52:53.689303-03	2025-06-18 20:52:53.689303-03	\N
variant_blue_05	15 ╨╝╨╗	OCEAN-BLUE-15ML	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_blue_05	2025-06-18 20:52:53.692131-03	2025-06-18 20:52:53.692131-03	\N
variant_blue_01	15 ╨╝╨╗	POLISH-BLUE-1-15ML	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_blue_01	2025-06-18 20:52:53.67216-03	2025-06-18 20:58:08.199-03	2025-06-18 20:58:08.197-03
variant_01JY4EXDKVDWCQZ0GCBY168JB1	Default variant	/BLUE08	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4EXDJ0HWQCX8AT1D1AD65W	2025-06-19 13:03:55.131-03	2025-06-19 13:03:55.131-03	\N
variant_01JY4FKVGNBBX604BH1H8ZTT0C	Default variant	/BLUE09	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4FKVF8FCC9EQQKEVXG22E8	2025-06-19 13:16:10.262-03	2025-06-19 13:16:10.262-03	\N
variant_01JY4FPBGMD3PTNQ7WD7GCA1CE	Default variant	/BLUE10	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4FPBEQ6MBXYGXHD5NJGJT4	2025-06-19 13:17:32.18-03	2025-06-19 13:17:32.18-03	\N
variant_01JY1KH3275517WN0Z422M2S1F	15ml	/BLUE01	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY1KH3046A3505DCDG1H12T6	2025-06-18 10:26:50.695-03	2025-06-18 10:26:50.695-03	\N
variant_01JY2SFFC09NB41SYF5A5P09XP	15ml	BLUE02	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_blue_01	2025-06-18 21:30:03.649-03	2025-06-18 21:30:03.649-03	\N
variant_01JY4FXGCG1MND4H62J1XCZ2VQ	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4FXGBET6NRGNZ82MQCGCQQ	2025-06-19 13:21:26.545-03	2025-06-19 13:21:26.545-03	\N
variant_01JY4G49Q7TS5DCTZ9R39X1697	╨б╨╕╨╜╨╕╨╣ 07	BLUE07	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_red_03	2025-06-19 13:25:09.095-03	2025-06-19 13:25:09.095-03	\N
variant_01JY4G66H0F9QRDMA4D9E7VZP9	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4G66F54B5TTD40JBZS9Z8Q	2025-06-19 13:26:11.36-03	2025-06-19 13:26:11.36-03	\N
variant_01JY4G93BTJYWM2B887BZZPMRC	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4G93A2X0769VP0ZXW0C2GZ	2025-06-19 13:27:46.426-03	2025-06-19 13:27:46.426-03	\N
variant_01JY4GAA5KC2NZ1HC1T08SVYW0	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4GAA4EX5CQ1JB73DXNXGKJ	2025-06-19 13:28:26.164-03	2025-06-19 13:28:26.164-03	\N
variant_01JY4GB85636PATJMDM6WHAPCN	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4GB82XBZQ5KH3E2C4SVQ2C	2025-06-19 13:28:56.87-03	2025-06-19 13:28:56.87-03	\N
variant_01JY4GC5RJNJY0S4T6FEN5TD4Y	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4GC5QHBK4Q7SHEGRYHX549	2025-06-19 13:29:27.187-03	2025-06-19 13:29:27.187-03	\N
variant_01JY4GD2SGAM1ZHQ0XDXNC090K	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4GD2QSD476CYWMSGXZ60XH	2025-06-19 13:29:56.913-03	2025-06-19 13:29:56.913-03	\N
variant_01JY4GDWJNZTE9GDDBWXST9HH1	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4GDWHP9WN5NTHP7MD69QZS	2025-06-19 13:30:23.317-03	2025-06-19 13:30:23.317-03	\N
variant_01JY4GEPX5J0ZA0GFFBWHYY9N7	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4GEPVEE41QFNE7XE4854DH	2025-06-19 13:30:50.278-03	2025-06-19 13:30:50.278-03	\N
variant_01JY4GFNVND8RHRZ2P20AB71VQ	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4GFNTWRFQPJBV47TCHGWS5	2025-06-19 13:31:21.974-03	2025-06-19 13:31:21.974-03	\N
variant_01JY4GGJ2RR1D5FBWQAFF0NWAR	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4GGJ1RMM7WEAH0EYNKGMRT	2025-06-19 13:31:50.873-03	2025-06-19 13:31:50.873-03	\N
variant_01JY4GJSC4XTC08QP2JAK77J81	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4GJSA30NVKJHFS5BGWFA6C	2025-06-19 13:33:03.876-03	2025-06-19 13:33:03.876-03	\N
variant_01JY4GKKCM687BJDHTAKX5522B	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4GKKBJ8AX2VKCV5A0A7B0H	2025-06-19 13:33:30.516-03	2025-06-19 13:33:30.516-03	\N
variant_01JY4GMJY7DS57HTASGK1X768C	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4GMJWMF7KMPCYDXRZ1GFFE	2025-06-19 13:34:02.824-03	2025-06-19 13:34:02.824-03	\N
variant_01JY4GNBQ3KVHZXFDM73S2XPVA	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4GNBP18P28KF7DS1FZSHQX	2025-06-19 13:34:28.195-03	2025-06-19 13:34:28.195-03	\N
variant_01JY4HDWH8MX5AR8AVCGHYQXDG	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4HDWFZ4GXN6Q1SW3HKG91X	2025-06-19 13:47:51.848-03	2025-06-19 13:47:51.848-03	\N
variant_01JY4HFCJBDCHW6VQTK0M0BWHB	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JY4HFCHCC4B2D855369Y2JW7	2025-06-19 13:48:41.035-03	2025-06-19 13:48:41.035-03	\N
\.


--
-- Data for Name: product_variant_inventory_item; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_variant_inventory_item (variant_id, inventory_item_id, id, required_quantity, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_variant_option; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_variant_option (variant_id, option_value_id) FROM stdin;
variant_01JY1KH3275517WN0Z422M2S1F	optval_01JY1KH3077NMWJMY8HRVK7482
variant_01JY2SFFC09NB41SYF5A5P09XP	optval_01JY2SCMYVRD4S0PK1M4FWWPEN
variant_01JY4EXDKVDWCQZ0GCBY168JB1	optval_01JY4EXDJ36DH0BAKWDKVP0CP8
variant_01JY4FKVGNBBX604BH1H8ZTT0C	optval_01JY4FKVF9W46G2ES9P145XKTN
variant_01JY4FPBGMD3PTNQ7WD7GCA1CE	optval_01JY4FPBERVWMTR2VRN5S9W1NZ
variant_01JY4FXGCG1MND4H62J1XCZ2VQ	optval_01JY4FXGBFPGPCW0S1CFBRFGS9
variant_01JY4G49Q7TS5DCTZ9R39X1697	optval_01JY4G2R8TH0DNR0NJHGC8ENZF
variant_01JY4G66H0F9QRDMA4D9E7VZP9	optval_01JY4G66F6TFAF8JXRJE8VYGF9
variant_01JY4G93BTJYWM2B887BZZPMRC	optval_01JY4G93A3DEBA2N0VMWPE57TF
variant_01JY4GAA5KC2NZ1HC1T08SVYW0	optval_01JY4GAA4E29R9WQFV4EHTX7JY
variant_01JY4GB85636PATJMDM6WHAPCN	optval_01JY4GB82YG9J9ESQ9PX62EXVC
variant_01JY4GC5RJNJY0S4T6FEN5TD4Y	optval_01JY4GC5QJCVZ2JA5ZNE1YYNP7
variant_01JY4GD2SGAM1ZHQ0XDXNC090K	optval_01JY4GD2QTYH44S8MX3Z4C2DAB
variant_01JY4GDWJNZTE9GDDBWXST9HH1	optval_01JY4GDWHPF85927VMXFVSBC0K
variant_01JY4GEPX5J0ZA0GFFBWHYY9N7	optval_01JY4GEPVE8C1BAFRM32P0T1K6
variant_01JY4GFNVND8RHRZ2P20AB71VQ	optval_01JY4GFNTXJ50Z1Q742QFYYN63
variant_01JY4GGJ2RR1D5FBWQAFF0NWAR	optval_01JY4GGJ1STCQ0N8P59RHRSARH
variant_01JY4GJSC4XTC08QP2JAK77J81	optval_01JY4GJSA4JXQYSQCQGK2JECAP
variant_01JY4GKKCM687BJDHTAKX5522B	optval_01JY4GKKBKTK36RTR8V9KNED6M
variant_01JY4GMJY7DS57HTASGK1X768C	optval_01JY4GMJWM8DB4AXBABB59ATGG
variant_01JY4GNBQ3KVHZXFDM73S2XPVA	optval_01JY4GNBP1QNGJ51YD9FTZ2CVX
variant_01JY4HDWH8MX5AR8AVCGHYQXDG	optval_01JY4HDWG2X38CRKZH6F8FAHNZ
variant_01JY4HFCJBDCHW6VQTK0M0BWHB	optval_01JY4HFCHD841YB6TG5TRKJMNQ
\.


--
-- Data for Name: product_variant_price_set; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.product_variant_price_set (variant_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
variant_01JY1KH3275517WN0Z422M2S1F	pset_01JY1KH337RKAG1JVMBAABAFN7	pvps_01JY1KH33X1SZAW163VXGERCM5	2025-06-18 10:26:50.749-03	2025-06-18 10:26:50.749-03	\N
variant_blue_02	pset_variant_blue_02	pvps_variant_blue_02	2025-06-18 21:06:39.505091-03	2025-06-18 21:06:39.505091-03	\N
variant_blue_03	pset_variant_blue_03	pvps_variant_blue_03	2025-06-18 21:06:39.513848-03	2025-06-18 21:06:39.513848-03	\N
variant_blue_04	pset_variant_blue_04	pvps_variant_blue_04	2025-06-18 21:06:39.518568-03	2025-06-18 21:06:39.518568-03	\N
variant_blue_05	pset_variant_blue_05	pvps_variant_blue_05	2025-06-18 21:06:39.52235-03	2025-06-18 21:06:39.52235-03	\N
variant_blue_01	pset_variant_blue_01	pvps_variant_blue_01	2025-06-18 21:06:39.5263-03	2025-06-18 21:06:39.5263-03	\N
variant_01JY2SFFC09NB41SYF5A5P09XP	pset_01JY2SFFDPKDGE0ZZGWRE28B4C	pvps_01JY2SFFEQXF8TX9NE42RE1HV9	2025-06-18 21:30:03.735029-03	2025-06-18 21:30:03.735029-03	\N
variant_01JY4EXDKVDWCQZ0GCBY168JB1	pset_01JY4EXDMSG98P5YVKNBPK15D0	pvps_01JY4EXDNDV31KTDNRRWTFPP66	2025-06-19 13:03:55.180816-03	2025-06-19 13:03:55.180816-03	\N
variant_01JY4FKVGNBBX604BH1H8ZTT0C	pset_01JY4FKVHJB457ACZTAVQCR0EK	pvps_01JY4FKVJ3999NV01CM71JDG9H	2025-06-19 13:16:10.306754-03	2025-06-19 13:16:10.306754-03	\N
variant_01JY4FPBGMD3PTNQ7WD7GCA1CE	pset_01JY4FPBHEYP1PAZE2FFRPKRCK	pvps_01JY4FPBHTRPPQ0HHNQGG7QE9F	2025-06-19 13:17:32.218209-03	2025-06-19 13:17:32.218209-03	\N
variant_01JY4FXGCG1MND4H62J1XCZ2VQ	pset_01JY4FXGD6Q03M1BFDNNRQ3D0P	pvps_01JY4FXGDSACA0DG073YWPWM8V	2025-06-19 13:21:26.585294-03	2025-06-19 13:21:26.585294-03	\N
variant_01JY4G49Q7TS5DCTZ9R39X1697	pset_01JY4G49R1H9KKSRP99RYCJPNH	pvps_01JY4G49RJBV4K884CP5VDHBTG	2025-06-19 13:25:09.138369-03	2025-06-19 13:25:09.138369-03	\N
variant_01JY4G66H0F9QRDMA4D9E7VZP9	pset_01JY4G66HPMP5M0Z0BMWMCPDRH	pvps_01JY4G66J6FGDRJ9VX1KV24GZM	2025-06-19 13:26:11.398536-03	2025-06-19 13:26:11.398536-03	\N
variant_01JY4G93BTJYWM2B887BZZPMRC	pset_01JY4G93CMAM9RNP83A1QA21AZ	pvps_01JY4G93DAE5NQZTTPDATY931E	2025-06-19 13:27:46.474029-03	2025-06-19 13:27:46.474029-03	\N
variant_01JY4GAA5KC2NZ1HC1T08SVYW0	pset_01JY4GAA6CP24SF1M8SSM9R3CG	pvps_01JY4GAA71MKDGXRBM00JPG78K	2025-06-19 13:28:26.208102-03	2025-06-19 13:28:26.208102-03	\N
variant_01JY4GB85636PATJMDM6WHAPCN	pset_01JY4GB86KJDTBSG4GKRDSFEJ6	pvps_01JY4GB87C27QJ0P56TK8DG3KK	2025-06-19 13:28:56.937414-03	2025-06-19 13:28:56.937414-03	\N
variant_01JY4GC5RJNJY0S4T6FEN5TD4Y	pset_01JY4GC5S8BKKDGRY9FTNAMKNY	pvps_01JY4GC5SP7PEMAYGJ77NNYACB	2025-06-19 13:29:27.221954-03	2025-06-19 13:29:27.221954-03	\N
variant_01JY4GD2SGAM1ZHQ0XDXNC090K	pset_01JY4GD2T8WCDTYAN98XK4P493	pvps_01JY4GD2TX19YTYA2NP518FGPH	2025-06-19 13:29:56.957087-03	2025-06-19 13:29:56.957087-03	\N
variant_01JY4GDWJNZTE9GDDBWXST9HH1	pset_01JY4GDWK9DEG99C1S0GNSYCE5	pvps_01JY4GDWKSGSTXXG3HT8XTSZCY	2025-06-19 13:30:23.353304-03	2025-06-19 13:30:23.353304-03	\N
variant_01JY4GEPX5J0ZA0GFFBWHYY9N7	pset_01JY4GEPYDWY4JA7VY3HQ0BR0V	pvps_01JY4GEPYYJ74T4YV0BD9X3SGT	2025-06-19 13:30:50.334079-03	2025-06-19 13:30:50.334079-03	\N
variant_01JY4GFNVND8RHRZ2P20AB71VQ	pset_01JY4GFNW9APWZBPHYATRFGETY	pvps_01JY4GFNWN1RAQEXQ4Z53NHEY0	2025-06-19 13:31:22.005009-03	2025-06-19 13:31:22.005009-03	\N
variant_01JY4GGJ2RR1D5FBWQAFF0NWAR	pset_01JY4GGJ3MEY9D484XRC8RW8WH	pvps_01JY4GGJ43ECVS735VTRCE136R	2025-06-19 13:31:50.915551-03	2025-06-19 13:31:50.915551-03	\N
variant_01JY4GJSC4XTC08QP2JAK77J81	pset_01JY4GJSCQVG92VA3HCZ8QT6KP	pvps_01JY4GJSD9HC46CWQA13JQQ8RB	2025-06-19 13:33:03.913735-03	2025-06-19 13:33:03.913735-03	\N
variant_01JY4GKKCM687BJDHTAKX5522B	pset_01JY4GKKD8RVBYSAAT9HXHDMJW	pvps_01JY4GKKDRSW61D2KW1J15EV29	2025-06-19 13:33:30.552791-03	2025-06-19 13:33:30.552791-03	\N
variant_01JY4GMJY7DS57HTASGK1X768C	pset_01JY4GMJZFA6BYG404B73AMCGA	pvps_01JY4GMJZZPP9N888FWNQYV0PW	2025-06-19 13:34:02.879481-03	2025-06-19 13:34:02.879481-03	\N
variant_01JY4GNBQ3KVHZXFDM73S2XPVA	pset_01JY4GNBQTVND94MZ53AJ8HC5H	pvps_01JY4GNBR7EHNC5R77EG0QFCMV	2025-06-19 13:34:28.231554-03	2025-06-19 13:34:28.231554-03	\N
variant_01JY4HDWH8MX5AR8AVCGHYQXDG	pset_01JY4HDWJ0NR52GZN2ENFKTJYC	pvps_01JY4HDWJGXF9J80YQSPMCXJT9	2025-06-19 13:47:51.88806-03	2025-06-19 13:47:51.88806-03	\N
variant_01JY4HFCJBDCHW6VQTK0M0BWHB	pset_01JY4HFCK4D2GNTB3DVV9T6H51	pvps_01JY4HFCKKJSMXRJRY99352RT1	2025-06-19 13:48:41.075635-03	2025-06-19 13:48:41.075635-03	\N
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.promotion (id, code, campaign_id, is_automatic, type, created_at, updated_at, deleted_at, status) FROM stdin;
\.


--
-- Data for Name: promotion_application_method; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.promotion_application_method (id, value, raw_value, max_quantity, apply_to_quantity, buy_rules_min_quantity, type, target_type, allocation, promotion_id, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_campaign; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.promotion_campaign (id, name, description, campaign_identifier, starts_at, ends_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_campaign_budget; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.promotion_campaign_budget (id, type, campaign_id, "limit", raw_limit, used, raw_used, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_promotion_rule; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.promotion_promotion_rule (promotion_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: promotion_rule; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.promotion_rule (id, description, attribute, operator, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_rule_value; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.promotion_rule_value (id, promotion_rule_id, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: provider_identity; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.provider_identity (id, entity_id, provider, auth_identity_id, user_metadata, provider_metadata, created_at, updated_at, deleted_at) FROM stdin;
01JY1HHNQ9M9P8B25M2WK9VK44	admin@manicure.com	emailpass	authid_01JY1HHNQATXT0FAQ62Y580AT9	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAYX3lDAxUQsXnS8K3cyR1JUWJXZ4OJu8DyPSiu0ldbIyANfKJkaCHxICg6VjM4Jjzufa90iYWqqKk+9er+sd6qDvhnw5zWkLVoXzO7eFmJwb"}	2025-06-18 09:52:12.65-03	2025-06-18 09:52:12.65-03	\N
01JY23QSP00RDPF42CV2SR2PZX	admin@test.com	emailpass	authid_01JY23QSP1W49PC4Z430SX16N3	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAbBZjjWLLNnvWwnhwHXNHg+eIAZNmO46DtvvJVpH2+7Vn78Q1sSxefU/25HCL8uL9dwaqlknKMSEBx161r1U5LCSfC+W4ddxIJ1+9KetntyI"}	2025-06-18 15:10:07.682-03	2025-06-18 15:10:07.682-03	\N
\.


--
-- Data for Name: publishable_api_key_sales_channel; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.publishable_api_key_sales_channel (publishable_key_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
apk_01JY1HPQSP8AA155F7JEV5KEKJ	sc_01JY1HFKX850G8R56F4N9SDZM0	pksc_01JY1HPZDNVWNW4DZ3A7W450FQ	2025-06-18 09:55:06.420663-03	2025-06-18 09:55:06.420663-03	\N
\.


--
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.refund (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata, refund_reason_id, note) FROM stdin;
\.


--
-- Data for Name: refund_reason; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.refund_reason (id, label, description, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.region (id, name, currency_code, metadata, created_at, updated_at, deleted_at, automatic_taxes) FROM stdin;
reg_01JY1HY6AZXH03A7EFXRBZEXTQ	Russia	rub	\N	2025-06-18 09:59:02.893-03	2025-06-18 10:32:43.84-03	\N	f
\.


--
-- Data for Name: region_country; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.region_country (iso_2, iso_3, num_code, name, display_name, region_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
af	afg	004	AFGHANISTAN	Afghanistan	\N	\N	2025-06-18 09:49:53.141-03	2025-06-18 09:49:53.141-03	\N
al	alb	008	ALBANIA	Albania	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
dz	dza	012	ALGERIA	Algeria	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
as	asm	016	AMERICAN SAMOA	American Samoa	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
ad	and	020	ANDORRA	Andorra	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
ao	ago	024	ANGOLA	Angola	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
ai	aia	660	ANGUILLA	Anguilla	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
aq	ata	010	ANTARCTICA	Antarctica	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
ag	atg	028	ANTIGUA AND BARBUDA	Antigua and Barbuda	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
ar	arg	032	ARGENTINA	Argentina	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
am	arm	051	ARMENIA	Armenia	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
aw	abw	533	ARUBA	Aruba	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
au	aus	036	AUSTRALIA	Australia	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
at	aut	040	AUSTRIA	Austria	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
az	aze	031	AZERBAIJAN	Azerbaijan	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
bs	bhs	044	BAHAMAS	Bahamas	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
bh	bhr	048	BAHRAIN	Bahrain	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
bd	bgd	050	BANGLADESH	Bangladesh	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
bb	brb	052	BARBADOS	Barbados	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
by	blr	112	BELARUS	Belarus	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
be	bel	056	BELGIUM	Belgium	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
bz	blz	084	BELIZE	Belize	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
bj	ben	204	BENIN	Benin	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
bm	bmu	060	BERMUDA	Bermuda	\N	\N	2025-06-18 09:49:53.142-03	2025-06-18 09:49:53.142-03	\N
bt	btn	064	BHUTAN	Bhutan	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
bo	bol	068	BOLIVIA	Bolivia	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
bq	bes	535	BONAIRE, SINT EUSTATIUS AND SABA	Bonaire, Sint Eustatius and Saba	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
ba	bih	070	BOSNIA AND HERZEGOVINA	Bosnia and Herzegovina	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
bw	bwa	072	BOTSWANA	Botswana	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
bv	bvd	074	BOUVET ISLAND	Bouvet Island	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
br	bra	076	BRAZIL	Brazil	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
io	iot	086	BRITISH INDIAN OCEAN TERRITORY	British Indian Ocean Territory	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
bn	brn	096	BRUNEI DARUSSALAM	Brunei Darussalam	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
bg	bgr	100	BULGARIA	Bulgaria	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
bf	bfa	854	BURKINA FASO	Burkina Faso	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
bi	bdi	108	BURUNDI	Burundi	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
kh	khm	116	CAMBODIA	Cambodia	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cm	cmr	120	CAMEROON	Cameroon	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
ca	can	124	CANADA	Canada	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cv	cpv	132	CAPE VERDE	Cape Verde	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
ky	cym	136	CAYMAN ISLANDS	Cayman Islands	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cf	caf	140	CENTRAL AFRICAN REPUBLIC	Central African Republic	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
td	tcd	148	CHAD	Chad	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cl	chl	152	CHILE	Chile	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cn	chn	156	CHINA	China	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cx	cxr	162	CHRISTMAS ISLAND	Christmas Island	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cc	cck	166	COCOS (KEELING) ISLANDS	Cocos (Keeling) Islands	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
co	col	170	COLOMBIA	Colombia	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
km	com	174	COMOROS	Comoros	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cg	cog	178	CONGO	Congo	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cd	cod	180	CONGO, THE DEMOCRATIC REPUBLIC OF THE	Congo, the Democratic Republic of the	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
ck	cok	184	COOK ISLANDS	Cook Islands	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cr	cri	188	COSTA RICA	Costa Rica	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
ci	civ	384	COTE D'IVOIRE	Cote D'Ivoire	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
hr	hrv	191	CROATIA	Croatia	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cu	cub	192	CUBA	Cuba	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cw	cuw	531	CURA├ЗAO	Cura├зao	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cy	cyp	196	CYPRUS	Cyprus	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
cz	cze	203	CZECH REPUBLIC	Czech Republic	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
dk	dnk	208	DENMARK	Denmark	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
dj	dji	262	DJIBOUTI	Djibouti	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
dm	dma	212	DOMINICA	Dominica	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
do	dom	214	DOMINICAN REPUBLIC	Dominican Republic	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
ec	ecu	218	ECUADOR	Ecuador	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
eg	egy	818	EGYPT	Egypt	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
sv	slv	222	EL SALVADOR	El Salvador	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gq	gnq	226	EQUATORIAL GUINEA	Equatorial Guinea	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
er	eri	232	ERITREA	Eritrea	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
ee	est	233	ESTONIA	Estonia	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
et	eth	231	ETHIOPIA	Ethiopia	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
fk	flk	238	FALKLAND ISLANDS (MALVINAS)	Falkland Islands (Malvinas)	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
fo	fro	234	FAROE ISLANDS	Faroe Islands	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
fj	fji	242	FIJI	Fiji	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
fi	fin	246	FINLAND	Finland	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
fr	fra	250	FRANCE	France	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gf	guf	254	FRENCH GUIANA	French Guiana	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
pf	pyf	258	FRENCH POLYNESIA	French Polynesia	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
tf	atf	260	FRENCH SOUTHERN TERRITORIES	French Southern Territories	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
ga	gab	266	GABON	Gabon	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gm	gmb	270	GAMBIA	Gambia	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
ge	geo	268	GEORGIA	Georgia	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
de	deu	276	GERMANY	Germany	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gh	gha	288	GHANA	Ghana	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gi	gib	292	GIBRALTAR	Gibraltar	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gr	grc	300	GREECE	Greece	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gl	grl	304	GREENLAND	Greenland	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gd	grd	308	GRENADA	Grenada	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gp	glp	312	GUADELOUPE	Guadeloupe	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gu	gum	316	GUAM	Guam	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gt	gtm	320	GUATEMALA	Guatemala	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gg	ggy	831	GUERNSEY	Guernsey	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gn	gin	324	GUINEA	Guinea	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gw	gnb	624	GUINEA-BISSAU	Guinea-Bissau	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
gy	guy	328	GUYANA	Guyana	\N	\N	2025-06-18 09:49:53.143-03	2025-06-18 09:49:53.143-03	\N
ht	hti	332	HAITI	Haiti	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
hm	hmd	334	HEARD ISLAND AND MCDONALD ISLANDS	Heard Island And Mcdonald Islands	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
va	vat	336	HOLY SEE (VATICAN CITY STATE)	Holy See (Vatican City State)	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
hn	hnd	340	HONDURAS	Honduras	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
hk	hkg	344	HONG KONG	Hong Kong	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
hu	hun	348	HUNGARY	Hungary	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
is	isl	352	ICELAND	Iceland	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
in	ind	356	INDIA	India	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
id	idn	360	INDONESIA	Indonesia	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
ir	irn	364	IRAN, ISLAMIC REPUBLIC OF	Iran, Islamic Republic of	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
iq	irq	368	IRAQ	Iraq	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
ie	irl	372	IRELAND	Ireland	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
im	imn	833	ISLE OF MAN	Isle Of Man	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
il	isr	376	ISRAEL	Israel	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
it	ita	380	ITALY	Italy	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
jm	jam	388	JAMAICA	Jamaica	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
jp	jpn	392	JAPAN	Japan	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
je	jey	832	JERSEY	Jersey	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
jo	jor	400	JORDAN	Jordan	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
kz	kaz	398	KAZAKHSTAN	Kazakhstan	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
ke	ken	404	KENYA	Kenya	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
ki	kir	296	KIRIBATI	Kiribati	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
kp	prk	408	KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF	Korea, Democratic People's Republic of	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
kr	kor	410	KOREA, REPUBLIC OF	Korea, Republic of	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
xk	xkx	900	KOSOVO	Kosovo	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
kw	kwt	414	KUWAIT	Kuwait	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
kg	kgz	417	KYRGYZSTAN	Kyrgyzstan	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
la	lao	418	LAO PEOPLE'S DEMOCRATIC REPUBLIC	Lao People's Democratic Republic	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
lv	lva	428	LATVIA	Latvia	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
lb	lbn	422	LEBANON	Lebanon	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
ls	lso	426	LESOTHO	Lesotho	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
lr	lbr	430	LIBERIA	Liberia	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
ly	lby	434	LIBYA	Libya	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
li	lie	438	LIECHTENSTEIN	Liechtenstein	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
lt	ltu	440	LITHUANIA	Lithuania	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
lu	lux	442	LUXEMBOURG	Luxembourg	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mo	mac	446	MACAO	Macao	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mg	mdg	450	MADAGASCAR	Madagascar	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mw	mwi	454	MALAWI	Malawi	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
my	mys	458	MALAYSIA	Malaysia	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mv	mdv	462	MALDIVES	Maldives	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
ml	mli	466	MALI	Mali	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mt	mlt	470	MALTA	Malta	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mh	mhl	584	MARSHALL ISLANDS	Marshall Islands	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mq	mtq	474	MARTINIQUE	Martinique	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mr	mrt	478	MAURITANIA	Mauritania	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mu	mus	480	MAURITIUS	Mauritius	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
yt	myt	175	MAYOTTE	Mayotte	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mx	mex	484	MEXICO	Mexico	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
fm	fsm	583	MICRONESIA, FEDERATED STATES OF	Micronesia, Federated States of	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
md	mda	498	MOLDOVA, REPUBLIC OF	Moldova, Republic of	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mc	mco	492	MONACO	Monaco	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mn	mng	496	MONGOLIA	Mongolia	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
me	mne	499	MONTENEGRO	Montenegro	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
ms	msr	500	MONTSERRAT	Montserrat	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
ma	mar	504	MOROCCO	Morocco	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mz	moz	508	MOZAMBIQUE	Mozambique	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mm	mmr	104	MYANMAR	Myanmar	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
na	nam	516	NAMIBIA	Namibia	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
nr	nru	520	NAURU	Nauru	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
np	npl	524	NEPAL	Nepal	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
nl	nld	528	NETHERLANDS	Netherlands	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
nc	ncl	540	NEW CALEDONIA	New Caledonia	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
nz	nzl	554	NEW ZEALAND	New Zealand	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
ni	nic	558	NICARAGUA	Nicaragua	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
ne	ner	562	NIGER	Niger	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
ng	nga	566	NIGERIA	Nigeria	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
nu	niu	570	NIUE	Niue	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
nf	nfk	574	NORFOLK ISLAND	Norfolk Island	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mk	mkd	807	NORTH MACEDONIA	North Macedonia	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
mp	mnp	580	NORTHERN MARIANA ISLANDS	Northern Mariana Islands	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
no	nor	578	NORWAY	Norway	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
om	omn	512	OMAN	Oman	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
pk	pak	586	PAKISTAN	Pakistan	\N	\N	2025-06-18 09:49:53.144-03	2025-06-18 09:49:53.144-03	\N
pw	plw	585	PALAU	Palau	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
ps	pse	275	PALESTINIAN TERRITORY, OCCUPIED	Palestinian Territory, Occupied	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
pa	pan	591	PANAMA	Panama	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
pg	png	598	PAPUA NEW GUINEA	Papua New Guinea	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
py	pry	600	PARAGUAY	Paraguay	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
pe	per	604	PERU	Peru	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
ph	phl	608	PHILIPPINES	Philippines	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
pn	pcn	612	PITCAIRN	Pitcairn	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
pl	pol	616	POLAND	Poland	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
pt	prt	620	PORTUGAL	Portugal	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
pr	pri	630	PUERTO RICO	Puerto Rico	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
qa	qat	634	QATAR	Qatar	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
re	reu	638	REUNION	Reunion	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
ro	rom	642	ROMANIA	Romania	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
rw	rwa	646	RWANDA	Rwanda	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
bl	blm	652	SAINT BARTH├ЙLEMY	Saint Barth├йlemy	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sh	shn	654	SAINT HELENA	Saint Helena	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
kn	kna	659	SAINT KITTS AND NEVIS	Saint Kitts and Nevis	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
lc	lca	662	SAINT LUCIA	Saint Lucia	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
mf	maf	663	SAINT MARTIN (FRENCH PART)	Saint Martin (French part)	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
pm	spm	666	SAINT PIERRE AND MIQUELON	Saint Pierre and Miquelon	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
vc	vct	670	SAINT VINCENT AND THE GRENADINES	Saint Vincent and the Grenadines	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
ws	wsm	882	SAMOA	Samoa	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sm	smr	674	SAN MARINO	San Marino	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
st	stp	678	SAO TOME AND PRINCIPE	Sao Tome and Principe	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sa	sau	682	SAUDI ARABIA	Saudi Arabia	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sn	sen	686	SENEGAL	Senegal	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
rs	srb	688	SERBIA	Serbia	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sc	syc	690	SEYCHELLES	Seychelles	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sl	sle	694	SIERRA LEONE	Sierra Leone	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sg	sgp	702	SINGAPORE	Singapore	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sx	sxm	534	SINT MAARTEN	Sint Maarten	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sk	svk	703	SLOVAKIA	Slovakia	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
si	svn	705	SLOVENIA	Slovenia	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sb	slb	090	SOLOMON ISLANDS	Solomon Islands	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
so	som	706	SOMALIA	Somalia	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
za	zaf	710	SOUTH AFRICA	South Africa	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
gs	sgs	239	SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS	South Georgia and the South Sandwich Islands	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
ss	ssd	728	SOUTH SUDAN	South Sudan	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
es	esp	724	SPAIN	Spain	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
lk	lka	144	SRI LANKA	Sri Lanka	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sd	sdn	729	SUDAN	Sudan	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sr	sur	740	SURINAME	Suriname	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sj	sjm	744	SVALBARD AND JAN MAYEN	Svalbard and Jan Mayen	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sz	swz	748	SWAZILAND	Swaziland	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
se	swe	752	SWEDEN	Sweden	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
ch	che	756	SWITZERLAND	Switzerland	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
sy	syr	760	SYRIAN ARAB REPUBLIC	Syrian Arab Republic	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
tw	twn	158	TAIWAN, PROVINCE OF CHINA	Taiwan, Province of China	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
tj	tjk	762	TAJIKISTAN	Tajikistan	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
tz	tza	834	TANZANIA, UNITED REPUBLIC OF	Tanzania, United Republic of	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
th	tha	764	THAILAND	Thailand	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
tl	tls	626	TIMOR LESTE	Timor Leste	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
tg	tgo	768	TOGO	Togo	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
tk	tkl	772	TOKELAU	Tokelau	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
to	ton	776	TONGA	Tonga	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
tt	tto	780	TRINIDAD AND TOBAGO	Trinidad and Tobago	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
tn	tun	788	TUNISIA	Tunisia	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
tr	tur	792	TURKEY	Turkey	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
tm	tkm	795	TURKMENISTAN	Turkmenistan	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
tc	tca	796	TURKS AND CAICOS ISLANDS	Turks and Caicos Islands	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
tv	tuv	798	TUVALU	Tuvalu	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
ug	uga	800	UGANDA	Uganda	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
ua	ukr	804	UKRAINE	Ukraine	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
ae	are	784	UNITED ARAB EMIRATES	United Arab Emirates	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
gb	gbr	826	UNITED KINGDOM	United Kingdom	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
us	usa	840	UNITED STATES	United States	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
um	umi	581	UNITED STATES MINOR OUTLYING ISLANDS	United States Minor Outlying Islands	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
uy	ury	858	URUGUAY	Uruguay	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
uz	uzb	860	UZBEKISTAN	Uzbekistan	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
vu	vut	548	VANUATU	Vanuatu	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
ve	ven	862	VENEZUELA	Venezuela	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
vn	vnm	704	VIET NAM	Viet Nam	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
vg	vgb	092	VIRGIN ISLANDS, BRITISH	Virgin Islands, British	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
vi	vir	850	VIRGIN ISLANDS, U.S.	Virgin Islands, U.S.	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
wf	wlf	876	WALLIS AND FUTUNA	Wallis and Futuna	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
eh	esh	732	WESTERN SAHARA	Western Sahara	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
ye	yem	887	YEMEN	Yemen	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
zm	zmb	894	ZAMBIA	Zambia	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
zw	zwe	716	ZIMBABWE	Zimbabwe	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
ax	ala	248	├ЕLAND ISLANDS	├Еland Islands	\N	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:49:53.145-03	\N
ru	rus	643	RUSSIAN FEDERATION	Russian Federation	reg_01JY1HY6AZXH03A7EFXRBZEXTQ	\N	2025-06-18 09:49:53.145-03	2025-06-18 09:59:02.894-03	\N
\.


--
-- Data for Name: region_payment_provider; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.region_payment_provider (region_id, payment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
reg_01JY1HY6AZXH03A7EFXRBZEXTQ	pp_system_default	regpp_01JY1HY6C66RJZ97R0XSWZQCSE	2025-06-18 09:59:02.918225-03	2025-06-18 09:59:02.918225-03	\N
\.


--
-- Data for Name: reservation_item; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.reservation_item (id, created_at, updated_at, deleted_at, line_item_id, location_id, quantity, external_id, description, created_by, metadata, inventory_item_id, allow_backorder, raw_quantity) FROM stdin;
\.


--
-- Data for Name: return; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.return (id, order_id, claim_id, exchange_id, order_version, display_id, status, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, received_at, canceled_at, location_id, requested_at, created_by) FROM stdin;
\.


--
-- Data for Name: return_fulfillment; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.return_fulfillment (return_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: return_item; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.return_item (id, return_id, reason_id, item_id, quantity, raw_quantity, received_quantity, raw_received_quantity, note, metadata, created_at, updated_at, deleted_at, damaged_quantity, raw_damaged_quantity) FROM stdin;
\.


--
-- Data for Name: return_reason; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.return_reason (id, value, label, description, metadata, parent_return_reason_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: sales_channel; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.sales_channel (id, name, description, is_disabled, metadata, created_at, updated_at, deleted_at) FROM stdin;
sc_01JY1HFKX850G8R56F4N9SDZM0	Default Sales Channel	Created by Medusa	f	\N	2025-06-18 09:51:05.256-03	2025-06-18 09:51:05.256-03	\N
\.


--
-- Data for Name: sales_channel_stock_location; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.sales_channel_stock_location (sales_channel_id, stock_location_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: script_migrations; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.script_migrations (id, script_name, created_at, finished_at) FROM stdin;
1	migrate-product-shipping-profile.js	2025-06-18 09:49:55.453478-03	2025-06-18 09:49:55.486544-03
2	migrate-tax-region-provider.js	2025-06-18 09:49:55.489686-03	2025-06-18 09:49:55.508776-03
\.


--
-- Data for Name: service_zone; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.service_zone (id, name, metadata, fulfillment_set_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: shipping_option; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.shipping_option (id, name, price_type, service_zone_id, shipping_profile_id, provider_id, data, metadata, shipping_option_type_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: shipping_option_price_set; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.shipping_option_price_set (shipping_option_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: shipping_option_rule; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.shipping_option_rule (id, attribute, operator, value, shipping_option_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: shipping_option_type; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.shipping_option_type (id, label, description, code, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: shipping_profile; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.shipping_profile (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
sp_01JY1HDFRPMPSSWCHKRS8X5KM3	Default Shipping Profile	default	\N	2025-06-18 09:49:55.48-03	2025-06-18 09:49:55.48-03	\N
\.


--
-- Data for Name: stock_location; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.stock_location (id, created_at, updated_at, deleted_at, name, address_id, metadata) FROM stdin;
\.


--
-- Data for Name: stock_location_address; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.stock_location_address (id, created_at, updated_at, deleted_at, address_1, address_2, company, city, country_code, phone, province, postal_code, metadata) FROM stdin;
\.


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.store (id, name, default_sales_channel_id, default_region_id, default_location_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
store_01JY1HFKXZZN6DEKRZ8SCPJJYB	Medusa Store	sc_01JY1HFKX850G8R56F4N9SDZM0	reg_01JY1HY6AZXH03A7EFXRBZEXTQ	\N	\N	2025-06-18 09:51:05.275849-03	2025-06-18 09:51:05.275849-03	\N
\.


--
-- Data for Name: store_currency; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.store_currency (id, currency_code, is_default, store_id, created_at, updated_at, deleted_at) FROM stdin;
stocur_01JY1JVARYQ5WQS811SG3HM8AJ	eur	f	store_01JY1HFKXZZN6DEKRZ8SCPJJYB	2025-06-18 10:14:57.68569-03	2025-06-18 10:14:57.68569-03	\N
stocur_01JY1JVARYAKP90JCNQ7TWWBWD	rub	t	store_01JY1HFKXZZN6DEKRZ8SCPJJYB	2025-06-18 10:14:57.68569-03	2025-06-18 10:14:57.68569-03	\N
\.


--
-- Data for Name: tax_provider; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.tax_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
tp_system	t	2025-06-18 09:49:53.253-03	2025-06-18 09:49:53.253-03	\N
\.


--
-- Data for Name: tax_rate; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.tax_rate (id, rate, code, name, is_default, is_combinable, tax_region_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_rate_rule; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.tax_rate_rule (id, tax_rate_id, reference_id, reference, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_region; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.tax_region (id, provider_id, country_code, province_code, parent_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public."user" (id, first_name, last_name, email, avatar_url, metadata, created_at, updated_at, deleted_at) FROM stdin;
user_01JY1HHNM47KN5E6QPVPW34E53			admin@manicure.com	\N	\N	2025-06-18 09:52:12.548-03	2025-06-18 12:26:08.293-03	\N
user_01JY23QSJ3GXYWBY9011T0XJHP	\N	\N	admin@test.com	\N	\N	2025-06-18 15:10:07.555-03	2025-06-18 15:10:07.555-03	\N
\.


--
-- Data for Name: workflow_execution; Type: TABLE DATA; Schema: public; Owner: medusa_user
--

COPY public.workflow_execution (id, workflow_id, transaction_id, execution, context, state, created_at, updated_at, deleted_at, retention_time, run_id) FROM stdin;
\.


--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_user
--

SELECT pg_catalog.setval('public.link_module_migrations_id_seq', 18, true);


--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_user
--

SELECT pg_catalog.setval('public.mikro_orm_migrations_id_seq', 108, true);


--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_user
--

SELECT pg_catalog.setval('public.order_change_action_ordering_seq', 1, false);


--
-- Name: order_claim_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_user
--

SELECT pg_catalog.setval('public.order_claim_display_id_seq', 1, false);


--
-- Name: order_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_user
--

SELECT pg_catalog.setval('public.order_display_id_seq', 1, false);


--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_user
--

SELECT pg_catalog.setval('public.order_exchange_display_id_seq', 1, false);


--
-- Name: return_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_user
--

SELECT pg_catalog.setval('public.return_display_id_seq', 1, false);


--
-- Name: script_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_user
--

SELECT pg_catalog.setval('public.script_migrations_id_seq', 2, true);


--
-- Name: account_holder account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.account_holder
    ADD CONSTRAINT account_holder_pkey PRIMARY KEY (id);


--
-- Name: api_key api_key_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.api_key
    ADD CONSTRAINT api_key_pkey PRIMARY KEY (id);


--
-- Name: application_method_buy_rules application_method_buy_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: application_method_target_rules application_method_target_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: auth_identity auth_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.auth_identity
    ADD CONSTRAINT auth_identity_pkey PRIMARY KEY (id);


--
-- Name: capture capture_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_pkey PRIMARY KEY (id);


--
-- Name: cart_address cart_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_address
    ADD CONSTRAINT cart_address_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item cart_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: cart_payment_collection cart_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_payment_collection
    ADD CONSTRAINT cart_payment_collection_pkey PRIMARY KEY (cart_id, payment_collection_id);


--
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- Name: cart_promotion cart_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_promotion
    ADD CONSTRAINT cart_promotion_pkey PRIMARY KEY (cart_id, promotion_id);


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method cart_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: credit_line credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_pkey PRIMARY KEY (id);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (code);


--
-- Name: customer_account_holder customer_account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.customer_account_holder
    ADD CONSTRAINT customer_account_holder_pkey PRIMARY KEY (customer_id, account_holder_id);


--
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (id);


--
-- Name: customer_group_customer customer_group_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_pkey PRIMARY KEY (id);


--
-- Name: customer_group customer_group_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.customer_group
    ADD CONSTRAINT customer_group_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_address fulfillment_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.fulfillment_address
    ADD CONSTRAINT fulfillment_address_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_item fulfillment_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_label fulfillment_label_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_pkey PRIMARY KEY (id);


--
-- Name: fulfillment fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_provider fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.fulfillment_provider
    ADD CONSTRAINT fulfillment_provider_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_set fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.fulfillment_set
    ADD CONSTRAINT fulfillment_set_pkey PRIMARY KEY (id);


--
-- Name: geo_zone geo_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_pkey PRIMARY KEY (id);


--
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: inventory_item inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_pkey PRIMARY KEY (id);


--
-- Name: inventory_level inventory_level_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_pkey PRIMARY KEY (id);


--
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_table_name_key; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_table_name_key UNIQUE (table_name);


--
-- Name: location_fulfillment_provider location_fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.location_fulfillment_provider
    ADD CONSTRAINT location_fulfillment_provider_pkey PRIMARY KEY (stock_location_id, fulfillment_provider_id);


--
-- Name: location_fulfillment_set location_fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.location_fulfillment_set
    ADD CONSTRAINT location_fulfillment_set_pkey PRIMARY KEY (stock_location_id, fulfillment_set_id);


--
-- Name: mikro_orm_migrations mikro_orm_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.mikro_orm_migrations
    ADD CONSTRAINT mikro_orm_migrations_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_provider notification_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.notification_provider
    ADD CONSTRAINT notification_provider_pkey PRIMARY KEY (id);


--
-- Name: order_address order_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_address
    ADD CONSTRAINT order_address_pkey PRIMARY KEY (id);


--
-- Name: order_cart order_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_cart
    ADD CONSTRAINT order_cart_pkey PRIMARY KEY (order_id, cart_id);


--
-- Name: order_change_action order_change_action_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_pkey PRIMARY KEY (id);


--
-- Name: order_change order_change_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item_image order_claim_item_image_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_claim_item_image
    ADD CONSTRAINT order_claim_item_image_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item order_claim_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_claim_item
    ADD CONSTRAINT order_claim_item_pkey PRIMARY KEY (id);


--
-- Name: order_claim order_claim_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_claim
    ADD CONSTRAINT order_claim_pkey PRIMARY KEY (id);


--
-- Name: order_credit_line order_credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_pkey PRIMARY KEY (id);


--
-- Name: order_exchange_item order_exchange_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_exchange_item
    ADD CONSTRAINT order_exchange_item_pkey PRIMARY KEY (id);


--
-- Name: order_exchange order_exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_exchange
    ADD CONSTRAINT order_exchange_pkey PRIMARY KEY (id);


--
-- Name: order_fulfillment order_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_fulfillment
    ADD CONSTRAINT order_fulfillment_pkey PRIMARY KEY (order_id, fulfillment_id);


--
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_adjustment order_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_line_item order_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_tax_line order_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_payment_collection order_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_payment_collection
    ADD CONSTRAINT order_payment_collection_pkey PRIMARY KEY (order_id, payment_collection_id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: order_promotion order_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_promotion
    ADD CONSTRAINT order_promotion_pkey PRIMARY KEY (order_id, promotion_id);


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method order_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_shipping_method
    ADD CONSTRAINT order_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_shipping order_shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_pkey PRIMARY KEY (id);


--
-- Name: order_summary order_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_pkey PRIMARY KEY (id);


--
-- Name: order_transaction order_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_pkey PRIMARY KEY (id);


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_pkey PRIMARY KEY (payment_collection_id, payment_provider_id);


--
-- Name: payment_collection payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.payment_collection
    ADD CONSTRAINT payment_collection_pkey PRIMARY KEY (id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.payment_provider
    ADD CONSTRAINT payment_provider_pkey PRIMARY KEY (id);


--
-- Name: payment_session payment_session_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_pkey PRIMARY KEY (id);


--
-- Name: price_list price_list_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.price_list
    ADD CONSTRAINT price_list_pkey PRIMARY KEY (id);


--
-- Name: price_list_rule price_list_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_pkey PRIMARY KEY (id);


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);


--
-- Name: price_preference price_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.price_preference
    ADD CONSTRAINT price_preference_pkey PRIMARY KEY (id);


--
-- Name: price_rule price_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_pkey PRIMARY KEY (id);


--
-- Name: price_set price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.price_set
    ADD CONSTRAINT price_set_pkey PRIMARY KEY (id);


--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- Name: product_category_product product_category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_pkey PRIMARY KEY (product_id, product_category_id);


--
-- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_pkey PRIMARY KEY (id);


--
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (id);


--
-- Name: product_option_value product_option_value_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product_sales_channel product_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_sales_channel
    ADD CONSTRAINT product_sales_channel_pkey PRIMARY KEY (product_id, sales_channel_id);


--
-- Name: product_shipping_profile product_shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_shipping_profile
    ADD CONSTRAINT product_shipping_profile_pkey PRIMARY KEY (product_id, shipping_profile_id);


--
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (id);


--
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, product_tag_id);


--
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (id);


--
-- Name: product_variant_inventory_item product_variant_inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_variant_inventory_item
    ADD CONSTRAINT product_variant_inventory_item_pkey PRIMARY KEY (variant_id, inventory_item_id);


--
-- Name: product_variant_option product_variant_option_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- Name: product_variant product_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_pkey PRIMARY KEY (id);


--
-- Name: product_variant_price_set product_variant_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_variant_price_set
    ADD CONSTRAINT product_variant_price_set_pkey PRIMARY KEY (variant_id, price_set_id);


--
-- Name: promotion_application_method promotion_application_method_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign_budget promotion_campaign_budget_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign promotion_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.promotion_campaign
    ADD CONSTRAINT promotion_campaign_pkey PRIMARY KEY (id);


--
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- Name: promotion_promotion_rule promotion_promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_pkey PRIMARY KEY (promotion_id, promotion_rule_id);


--
-- Name: promotion_rule promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.promotion_rule
    ADD CONSTRAINT promotion_rule_pkey PRIMARY KEY (id);


--
-- Name: promotion_rule_value promotion_rule_value_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_pkey PRIMARY KEY (id);


--
-- Name: provider_identity provider_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_pkey PRIMARY KEY (id);


--
-- Name: publishable_api_key_sales_channel publishable_api_key_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.publishable_api_key_sales_channel
    ADD CONSTRAINT publishable_api_key_sales_channel_pkey PRIMARY KEY (publishable_key_id, sales_channel_id);


--
-- Name: refund refund_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_pkey PRIMARY KEY (id);


--
-- Name: refund_reason refund_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.refund_reason
    ADD CONSTRAINT refund_reason_pkey PRIMARY KEY (id);


--
-- Name: region_country region_country_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_pkey PRIMARY KEY (iso_2);


--
-- Name: region_payment_provider region_payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.region_payment_provider
    ADD CONSTRAINT region_payment_provider_pkey PRIMARY KEY (region_id, payment_provider_id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: reservation_item reservation_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_pkey PRIMARY KEY (id);


--
-- Name: return_fulfillment return_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.return_fulfillment
    ADD CONSTRAINT return_fulfillment_pkey PRIMARY KEY (return_id, fulfillment_id);


--
-- Name: return_item return_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.return_item
    ADD CONSTRAINT return_item_pkey PRIMARY KEY (id);


--
-- Name: return return_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.return
    ADD CONSTRAINT return_pkey PRIMARY KEY (id);


--
-- Name: return_reason return_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_pkey PRIMARY KEY (id);


--
-- Name: sales_channel sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.sales_channel
    ADD CONSTRAINT sales_channel_pkey PRIMARY KEY (id);


--
-- Name: sales_channel_stock_location sales_channel_stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.sales_channel_stock_location
    ADD CONSTRAINT sales_channel_stock_location_pkey PRIMARY KEY (sales_channel_id, stock_location_id);


--
-- Name: script_migrations script_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.script_migrations
    ADD CONSTRAINT script_migrations_pkey PRIMARY KEY (id);


--
-- Name: service_zone service_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_pkey PRIMARY KEY (id);


--
-- Name: shipping_option shipping_option_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_price_set shipping_option_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.shipping_option_price_set
    ADD CONSTRAINT shipping_option_price_set_pkey PRIMARY KEY (shipping_option_id, price_set_id);


--
-- Name: shipping_option_rule shipping_option_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_type shipping_option_type_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.shipping_option_type
    ADD CONSTRAINT shipping_option_type_pkey PRIMARY KEY (id);


--
-- Name: shipping_profile shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.shipping_profile
    ADD CONSTRAINT shipping_profile_pkey PRIMARY KEY (id);


--
-- Name: stock_location_address stock_location_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.stock_location_address
    ADD CONSTRAINT stock_location_address_pkey PRIMARY KEY (id);


--
-- Name: stock_location stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_pkey PRIMARY KEY (id);


--
-- Name: store_currency store_currency_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_pkey PRIMARY KEY (id);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- Name: tax_provider tax_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.tax_provider
    ADD CONSTRAINT tax_provider_pkey PRIMARY KEY (id);


--
-- Name: tax_rate tax_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT tax_rate_pkey PRIMARY KEY (id);


--
-- Name: tax_rate_rule tax_rate_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT tax_rate_rule_pkey PRIMARY KEY (id);


--
-- Name: tax_region tax_region_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT tax_region_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: workflow_execution workflow_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.workflow_execution
    ADD CONSTRAINT workflow_execution_pkey PRIMARY KEY (workflow_id, transaction_id, run_id);


--
-- Name: IDX_account_holder_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_account_holder_deleted_at" ON public.account_holder USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_account_holder_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_account_holder_id_5cb3a0c0" ON public.customer_account_holder USING btree (account_holder_id);


--
-- Name: IDX_account_holder_provider_id_external_id_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_account_holder_provider_id_external_id_unique" ON public.account_holder USING btree (provider_id, external_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_adjustment_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_api_key_deleted_at" ON public.api_key USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_token_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON public.api_key USING btree (token);


--
-- Name: IDX_api_key_type; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_api_key_type" ON public.api_key USING btree (type);


--
-- Name: IDX_application_method_allocation; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_application_method_allocation" ON public.promotion_application_method USING btree (allocation);


--
-- Name: IDX_application_method_target_type; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_application_method_target_type" ON public.promotion_application_method USING btree (target_type);


--
-- Name: IDX_application_method_type; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_application_method_type" ON public.promotion_application_method USING btree (type);


--
-- Name: IDX_auth_identity_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_auth_identity_deleted_at" ON public.auth_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_campaign_budget_type; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_campaign_budget_type" ON public.promotion_campaign_budget USING btree (type);


--
-- Name: IDX_capture_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_capture_deleted_at" ON public.capture USING btree (deleted_at);


--
-- Name: IDX_capture_payment_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_capture_payment_id" ON public.capture USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_address_deleted_at" ON public.cart_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_billing_address_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_billing_address_id" ON public.cart USING btree (billing_address_id) WHERE ((deleted_at IS NULL) AND (billing_address_id IS NOT NULL));


--
-- Name: IDX_cart_credit_line_reference_reference_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_credit_line_reference_reference_id" ON public.credit_line USING btree (reference, reference_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_currency_code; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_currency_code" ON public.cart USING btree (currency_code);


--
-- Name: IDX_cart_customer_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_customer_id" ON public.cart USING btree (customer_id) WHERE ((deleted_at IS NULL) AND (customer_id IS NOT NULL));


--
-- Name: IDX_cart_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_deleted_at" ON public.cart USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_id_-4a39f6c9" ON public.cart_payment_collection USING btree (cart_id);


--
-- Name: IDX_cart_id_-71069c16; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_id_-71069c16" ON public.order_cart USING btree (cart_id);


--
-- Name: IDX_cart_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_id_-a9d4a70b" ON public.cart_promotion USING btree (cart_id);


--
-- Name: IDX_cart_line_item_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_line_item_adjustment_deleted_at" ON public.cart_line_item_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_line_item_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_cart_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_line_item_deleted_at" ON public.cart_line_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_line_item_tax_line_deleted_at" ON public.cart_line_item_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_line_item_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_region_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_region_id" ON public.cart USING btree (region_id) WHERE ((deleted_at IS NULL) AND (region_id IS NOT NULL));


--
-- Name: IDX_cart_sales_channel_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_sales_channel_id" ON public.cart USING btree (sales_channel_id) WHERE ((deleted_at IS NULL) AND (sales_channel_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_address_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_shipping_address_id" ON public.cart USING btree (shipping_address_id) WHERE ((deleted_at IS NULL) AND (shipping_address_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_method_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_deleted_at" ON public.cart_shipping_method_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_shipping_method_deleted_at" ON public.cart_shipping_method USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_deleted_at" ON public.cart_shipping_method_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_category_handle_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_category_handle_unique" ON public.product_category USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_collection_handle_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_collection_handle_unique" ON public.product_collection USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_cart_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_credit_line_cart_id" ON public.credit_line USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_credit_line_deleted_at" ON public.credit_line USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_customer_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_customer_address_customer_id" ON public.customer_address USING btree (customer_id);


--
-- Name: IDX_customer_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_customer_address_deleted_at" ON public.customer_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_unique_customer_billing; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_billing" ON public.customer_address USING btree (customer_id) WHERE (is_default_billing = true);


--
-- Name: IDX_customer_address_unique_customer_shipping; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_shipping" ON public.customer_address USING btree (customer_id) WHERE (is_default_shipping = true);


--
-- Name: IDX_customer_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_customer_deleted_at" ON public.customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_email_has_account_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_customer_email_has_account_unique" ON public.customer USING btree (email, has_account) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_group_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_customer_group_customer_customer_group_id" ON public.customer_group_customer USING btree (customer_group_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_customer_group_customer_customer_id" ON public.customer_group_customer USING btree (customer_id);


--
-- Name: IDX_customer_group_customer_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_customer_group_customer_deleted_at" ON public.customer_group_customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_customer_group_deleted_at" ON public.customer_group USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_name; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_customer_group_name" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_name_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_customer_group_name_unique" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_customer_id_5cb3a0c0" ON public.customer_account_holder USING btree (customer_id);


--
-- Name: IDX_deleted_at_-1d67bae40; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-1e5992737; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_-1e5992737" ON public.location_fulfillment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-31ea43a; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_-31ea43a" ON public.return_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-4a39f6c9; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_-4a39f6c9" ON public.cart_payment_collection USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71069c16; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_-71069c16" ON public.order_cart USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71518339; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_-71518339" ON public.order_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-a9d4a70b; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_-a9d4a70b" ON public.cart_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e88adb96; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_-e88adb96" ON public.location_fulfillment_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e8d2543e; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_-e8d2543e" ON public.order_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17a262437; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_17a262437" ON public.product_shipping_profile USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17b4c4e35; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_17b4c4e35" ON public.product_variant_inventory_item USING btree (deleted_at);


--
-- Name: IDX_deleted_at_1c934dab0; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_1c934dab0" ON public.region_payment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_20b454295; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_20b454295" ON public.product_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_26d06f470; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_26d06f470" ON public.sales_channel_stock_location USING btree (deleted_at);


--
-- Name: IDX_deleted_at_52b23597; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_52b23597" ON public.product_variant_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_5cb3a0c0; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_5cb3a0c0" ON public.customer_account_holder USING btree (deleted_at);


--
-- Name: IDX_deleted_at_ba32fa9c; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_ba32fa9c" ON public.shipping_option_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_f42b9949; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_deleted_at_f42b9949" ON public.order_payment_collection USING btree (deleted_at);


--
-- Name: IDX_fulfillment_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_address_deleted_at" ON public.fulfillment_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_deleted_at" ON public.fulfillment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_id_-31ea43a; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_id_-31ea43a" ON public.return_fulfillment USING btree (fulfillment_id);


--
-- Name: IDX_fulfillment_id_-e8d2543e; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_id_-e8d2543e" ON public.order_fulfillment USING btree (fulfillment_id);


--
-- Name: IDX_fulfillment_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_item_deleted_at" ON public.fulfillment_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_item_fulfillment_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_item_fulfillment_id" ON public.fulfillment_item USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_inventory_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_item_inventory_item_id" ON public.fulfillment_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_line_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_item_line_item_id" ON public.fulfillment_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_label_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_label_deleted_at" ON public.fulfillment_label USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_label_fulfillment_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_label_fulfillment_id" ON public.fulfillment_label USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_location_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_location_id" ON public.fulfillment USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_provider_deleted_at" ON public.fulfillment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_id_-1e5992737; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_provider_id_-1e5992737" ON public.location_fulfillment_provider USING btree (fulfillment_provider_id);


--
-- Name: IDX_fulfillment_set_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_set_deleted_at" ON public.fulfillment_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_set_id_-e88adb96; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_set_id_-e88adb96" ON public.location_fulfillment_set USING btree (fulfillment_set_id);


--
-- Name: IDX_fulfillment_set_name_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_fulfillment_set_name_unique" ON public.fulfillment_set USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_shipping_option_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_fulfillment_shipping_option_id" ON public.fulfillment USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_city; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_geo_zone_city" ON public.geo_zone USING btree (city) WHERE ((deleted_at IS NULL) AND (city IS NOT NULL));


--
-- Name: IDX_geo_zone_country_code; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_geo_zone_country_code" ON public.geo_zone USING btree (country_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_geo_zone_deleted_at" ON public.geo_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_geo_zone_province_code; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_geo_zone_province_code" ON public.geo_zone USING btree (province_code) WHERE ((deleted_at IS NULL) AND (province_code IS NOT NULL));


--
-- Name: IDX_geo_zone_service_zone_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_geo_zone_service_zone_id" ON public.geo_zone USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_id_-1d67bae40; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (id);


--
-- Name: IDX_id_-1e5992737; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_-1e5992737" ON public.location_fulfillment_provider USING btree (id);


--
-- Name: IDX_id_-31ea43a; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_-31ea43a" ON public.return_fulfillment USING btree (id);


--
-- Name: IDX_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_-4a39f6c9" ON public.cart_payment_collection USING btree (id);


--
-- Name: IDX_id_-71069c16; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_-71069c16" ON public.order_cart USING btree (id);


--
-- Name: IDX_id_-71518339; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_-71518339" ON public.order_promotion USING btree (id);


--
-- Name: IDX_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_-a9d4a70b" ON public.cart_promotion USING btree (id);


--
-- Name: IDX_id_-e88adb96; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_-e88adb96" ON public.location_fulfillment_set USING btree (id);


--
-- Name: IDX_id_-e8d2543e; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_-e8d2543e" ON public.order_fulfillment USING btree (id);


--
-- Name: IDX_id_17a262437; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_17a262437" ON public.product_shipping_profile USING btree (id);


--
-- Name: IDX_id_17b4c4e35; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (id);


--
-- Name: IDX_id_1c934dab0; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_1c934dab0" ON public.region_payment_provider USING btree (id);


--
-- Name: IDX_id_20b454295; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_20b454295" ON public.product_sales_channel USING btree (id);


--
-- Name: IDX_id_26d06f470; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_26d06f470" ON public.sales_channel_stock_location USING btree (id);


--
-- Name: IDX_id_52b23597; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_52b23597" ON public.product_variant_price_set USING btree (id);


--
-- Name: IDX_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_5cb3a0c0" ON public.customer_account_holder USING btree (id);


--
-- Name: IDX_id_ba32fa9c; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_ba32fa9c" ON public.shipping_option_price_set USING btree (id);


--
-- Name: IDX_id_f42b9949; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_id_f42b9949" ON public.order_payment_collection USING btree (id);


--
-- Name: IDX_image_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_image_deleted_at" ON public.image USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_image_product_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_image_product_id" ON public.image USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_inventory_item_deleted_at" ON public.inventory_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_item_id_17b4c4e35; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_inventory_item_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (inventory_item_id);


--
-- Name: IDX_inventory_item_sku; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_inventory_item_sku" ON public.inventory_item USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_inventory_level_deleted_at" ON public.inventory_level USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_level_inventory_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_inventory_level_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_item_location; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_inventory_level_item_location" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_inventory_level_location_id" ON public.inventory_level USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id_inventory_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_inventory_level_location_id_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_invite_deleted_at" ON public.invite USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_invite_email_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_invite_email_unique" ON public.invite USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_token; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_invite_token" ON public.invite USING btree (token) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_line_item_adjustment_promotion_id" ON public.cart_line_item_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_line_item_cart_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_product_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_line_item_product_id" ON public.cart_line_item USING btree (product_id) WHERE ((deleted_at IS NULL) AND (product_id IS NOT NULL));


--
-- Name: IDX_line_item_product_type_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_line_item_product_type_id" ON public.cart_line_item USING btree (product_type_id) WHERE ((deleted_at IS NULL) AND (product_type_id IS NOT NULL));


--
-- Name: IDX_line_item_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_line_item_tax_line_tax_rate_id" ON public.cart_line_item_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_line_item_variant_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_line_item_variant_id" ON public.cart_line_item USING btree (variant_id) WHERE ((deleted_at IS NULL) AND (variant_id IS NOT NULL));


--
-- Name: IDX_notification_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_notification_deleted_at" ON public.notification USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_idempotency_key_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_notification_idempotency_key_unique" ON public.notification USING btree (idempotency_key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_notification_provider_deleted_at" ON public.notification_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_notification_provider_id" ON public.notification USING btree (provider_id);


--
-- Name: IDX_notification_receiver_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_notification_receiver_id" ON public.notification USING btree (receiver_id);


--
-- Name: IDX_option_product_id_title_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_option_product_id_title_unique" ON public.product_option USING btree (product_id, title) WHERE (deleted_at IS NULL);


--
-- Name: IDX_option_value_option_id_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_option_value_option_id_unique" ON public.product_option_value USING btree (option_id, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_address_customer_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_address_customer_id" ON public.order_address USING btree (customer_id);


--
-- Name: IDX_order_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_address_deleted_at" ON public.order_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_billing_address_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_billing_address_id" ON public."order" USING btree (billing_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_claim_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_action_claim_id" ON public.order_change_action USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_action_deleted_at" ON public.order_change_action USING btree (deleted_at);


--
-- Name: IDX_order_change_action_exchange_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_action_exchange_id" ON public.order_change_action USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_order_change_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_action_order_change_id" ON public.order_change_action USING btree (order_change_id);


--
-- Name: IDX_order_change_action_order_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_action_order_id" ON public.order_change_action USING btree (order_id);


--
-- Name: IDX_order_change_action_ordering; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_action_ordering" ON public.order_change_action USING btree (ordering);


--
-- Name: IDX_order_change_action_return_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_action_return_id" ON public.order_change_action USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_change_type; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_change_type" ON public.order_change USING btree (change_type);


--
-- Name: IDX_order_change_claim_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_claim_id" ON public.order_change USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_deleted_at" ON public.order_change USING btree (deleted_at);


--
-- Name: IDX_order_change_exchange_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_exchange_id" ON public.order_change USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_order_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_order_id" ON public.order_change USING btree (order_id);


--
-- Name: IDX_order_change_order_id_version; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_order_id_version" ON public.order_change USING btree (order_id, version);


--
-- Name: IDX_order_change_return_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_return_id" ON public.order_change USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_status; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_change_status" ON public.order_change USING btree (status);


--
-- Name: IDX_order_claim_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_claim_deleted_at" ON public.order_claim USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_display_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_claim_display_id" ON public.order_claim USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_claim_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_claim_item_claim_id" ON public.order_claim_item USING btree (claim_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_claim_item_deleted_at" ON public.order_claim_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_image_claim_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_claim_item_image_claim_item_id" ON public.order_claim_item_image USING btree (claim_item_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_image_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_claim_item_image_deleted_at" ON public.order_claim_item_image USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_claim_item_item_id" ON public.order_claim_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_order_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_claim_order_id" ON public.order_claim USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_return_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_claim_return_id" ON public.order_claim USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_credit_line_deleted_at" ON public.order_credit_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_credit_line_order_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_credit_line_order_id" ON public.order_credit_line USING btree (order_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_currency_code; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_currency_code" ON public."order" USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_customer_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_customer_id" ON public."order" USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_deleted_at" ON public."order" USING btree (deleted_at);


--
-- Name: IDX_order_display_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_display_id" ON public."order" USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_exchange_deleted_at" ON public.order_exchange USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_display_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_exchange_display_id" ON public.order_exchange USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_exchange_item_deleted_at" ON public.order_exchange_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_exchange_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_exchange_item_exchange_id" ON public.order_exchange_item USING btree (exchange_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_exchange_item_item_id" ON public.order_exchange_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_order_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_exchange_order_id" ON public.order_exchange USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_return_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_exchange_return_id" ON public.order_exchange USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_id_-71069c16; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_id_-71069c16" ON public.order_cart USING btree (order_id);


--
-- Name: IDX_order_id_-71518339; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_id_-71518339" ON public.order_promotion USING btree (order_id);


--
-- Name: IDX_order_id_-e8d2543e; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_id_-e8d2543e" ON public.order_fulfillment USING btree (order_id);


--
-- Name: IDX_order_id_f42b9949; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_id_f42b9949" ON public.order_payment_collection USING btree (order_id);


--
-- Name: IDX_order_is_draft_order; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_is_draft_order" ON public."order" USING btree (is_draft_order) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_item_deleted_at" ON public.order_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_item_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_item_item_id" ON public.order_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_item_order_id" ON public.order_item USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id_version; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_item_order_id_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_line_item_adjustment_item_id" ON public.order_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_product_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_line_item_product_id" ON public.order_line_item USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_line_item_tax_line_item_id" ON public.order_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_variant_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_line_item_variant_id" ON public.order_line_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_region_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_region_id" ON public."order" USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_address_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_shipping_address_id" ON public."order" USING btree (shipping_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_claim_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_shipping_claim_id" ON public.order_shipping USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_shipping_deleted_at" ON public.order_shipping USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_shipping_exchange_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_shipping_exchange_id" ON public.order_shipping USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_shipping_item_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_shipping_method_adjustment_shipping_method_id" ON public.order_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_shipping_option_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_shipping_method_shipping_option_id" ON public.order_shipping_method USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_shipping_method_tax_line_shipping_method_id" ON public.order_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_shipping_order_id" ON public.order_shipping USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id_version; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_shipping_order_id_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_return_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_shipping_return_id" ON public.order_shipping USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_summary_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_summary_deleted_at" ON public.order_summary USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_summary_order_id_version; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_summary_order_id_version" ON public.order_summary USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_claim_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_transaction_claim_id" ON public.order_transaction USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_currency_code; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_transaction_currency_code" ON public.order_transaction USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_exchange_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_transaction_exchange_id" ON public.order_transaction USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_order_id_version; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_transaction_order_id_version" ON public.order_transaction USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_reference_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_transaction_reference_id" ON public.order_transaction USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_return_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_order_transaction_return_id" ON public.order_transaction USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_payment_collection_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_payment_collection_deleted_at" ON public.payment_collection USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_collection_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_payment_collection_id_-4a39f6c9" ON public.cart_payment_collection USING btree (payment_collection_id);


--
-- Name: IDX_payment_collection_id_f42b9949; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_payment_collection_id_f42b9949" ON public.order_payment_collection USING btree (payment_collection_id);


--
-- Name: IDX_payment_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_payment_deleted_at" ON public.payment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_payment_collection_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_payment_payment_collection_id" ON public.payment USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_payment_session_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_payment_payment_session_id" ON public.payment USING btree (payment_session_id);


--
-- Name: IDX_payment_payment_session_id_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_payment_payment_session_id_unique" ON public.payment USING btree (payment_session_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_payment_provider_deleted_at" ON public.payment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_payment_provider_id" ON public.payment USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id_1c934dab0; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_payment_provider_id_1c934dab0" ON public.region_payment_provider USING btree (payment_provider_id);


--
-- Name: IDX_payment_session_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_payment_session_deleted_at" ON public.payment_session USING btree (deleted_at);


--
-- Name: IDX_payment_session_payment_collection_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_payment_session_payment_collection_id" ON public.payment_session USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_currency_code; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_currency_code" ON public.price USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_deleted_at" ON public.price USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_list_deleted_at" ON public.price_list USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_attribute; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_list_rule_attribute" ON public.price_list_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_list_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_list_rule_deleted_at" ON public.price_list_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_price_list_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_list_rule_price_list_id" ON public.price_list_rule USING btree (price_list_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_preference_attribute_value; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_price_preference_attribute_value" ON public.price_preference USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_preference_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_preference_deleted_at" ON public.price_preference USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_price_list_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_price_list_id" ON public.price USING btree (price_list_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_price_set_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_price_set_id" ON public.price USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_rule_attribute" ON public.price_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute_value; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_rule_attribute_value" ON public.price_rule USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_rule_deleted_at" ON public.price_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_rule_operator; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_rule_operator" ON public.price_rule USING btree (operator);


--
-- Name: IDX_price_rule_operator_value; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_rule_operator_value" ON public.price_rule USING btree (operator, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_rule_price_id" ON public.price_rule USING btree (price_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id_attribute_operator_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_price_rule_price_id_attribute_operator_unique" ON public.price_rule USING btree (price_id, attribute, operator) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_set_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_set_deleted_at" ON public.price_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_set_id_52b23597; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_set_id_52b23597" ON public.product_variant_price_set USING btree (price_set_id);


--
-- Name: IDX_price_set_id_ba32fa9c; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_price_set_id_ba32fa9c" ON public.shipping_option_price_set USING btree (price_set_id);


--
-- Name: IDX_product_category_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_category_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_category_parent_category_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_category_parent_category_id" ON public.product_category USING btree (parent_category_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_category_path; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_category_path" ON public.product_category USING btree (mpath) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_collection_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_collection_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_collection_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_collection_id" ON public.product USING btree (collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_deleted_at" ON public.product USING btree (deleted_at);


--
-- Name: IDX_product_handle_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_product_handle_unique" ON public.product USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_id_17a262437; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_id_17a262437" ON public.product_shipping_profile USING btree (product_id);


--
-- Name: IDX_product_id_20b454295; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_id_20b454295" ON public.product_sales_channel USING btree (product_id);


--
-- Name: IDX_product_image_url; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_image_url" ON public.image USING btree (url) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_option_deleted_at" ON public.product_option USING btree (deleted_at);


--
-- Name: IDX_product_option_product_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_option_product_id" ON public.product_option USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_value_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_option_value_deleted_at" ON public.product_option_value USING btree (deleted_at);


--
-- Name: IDX_product_option_value_option_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_option_value_option_id" ON public.product_option_value USING btree (option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_tag_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_tag_deleted_at" ON public.product_tag USING btree (deleted_at);


--
-- Name: IDX_product_type_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_type_deleted_at" ON public.product_type USING btree (deleted_at);


--
-- Name: IDX_product_type_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_type_id" ON public.product USING btree (type_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_barcode_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_product_variant_barcode_unique" ON public.product_variant USING btree (barcode) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_variant_deleted_at" ON public.product_variant USING btree (deleted_at);


--
-- Name: IDX_product_variant_ean_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_product_variant_ean_unique" ON public.product_variant USING btree (ean) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_id_product_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_variant_id_product_id" ON public.product_variant USING btree (id, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_product_variant_product_id" ON public.product_variant USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_sku_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_product_variant_sku_unique" ON public.product_variant USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_upc_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_product_variant_upc_unique" ON public.product_variant USING btree (upc) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_currency_code; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_application_method_currency_code" ON public.promotion_application_method USING btree (currency_code) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_promotion_application_method_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_application_method_deleted_at" ON public.promotion_application_method USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_promotion_id_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_promotion_application_method_promotion_id_unique" ON public.promotion_application_method USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_campaign_id_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_budget_campaign_id_unique" ON public.promotion_campaign_budget USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_campaign_budget_deleted_at" ON public.promotion_campaign_budget USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_campaign_identifier_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_campaign_identifier_unique" ON public.promotion_campaign USING btree (campaign_identifier) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_campaign_deleted_at" ON public.promotion_campaign USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_campaign_id" ON public.promotion USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_deleted_at" ON public.promotion USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_id_-71518339; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_id_-71518339" ON public.order_promotion USING btree (promotion_id);


--
-- Name: IDX_promotion_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_id_-a9d4a70b" ON public.cart_promotion USING btree (promotion_id);


--
-- Name: IDX_promotion_rule_attribute; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_rule_attribute" ON public.promotion_rule USING btree (attribute);


--
-- Name: IDX_promotion_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_rule_deleted_at" ON public.promotion_rule USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_operator; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_rule_operator" ON public.promotion_rule USING btree (operator);


--
-- Name: IDX_promotion_rule_value_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_rule_value_deleted_at" ON public.promotion_rule_value USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_promotion_rule_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_rule_value_promotion_rule_id" ON public.promotion_rule_value USING btree (promotion_rule_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_status; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_status" ON public.promotion USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_type; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_promotion_type" ON public.promotion USING btree (type);


--
-- Name: IDX_provider_identity_auth_identity_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_provider_identity_auth_identity_id" ON public.provider_identity USING btree (auth_identity_id);


--
-- Name: IDX_provider_identity_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_provider_identity_deleted_at" ON public.provider_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_provider_identity_provider_entity_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_provider_identity_provider_entity_id" ON public.provider_identity USING btree (entity_id, provider);


--
-- Name: IDX_publishable_key_id_-1d67bae40; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_publishable_key_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (publishable_key_id);


--
-- Name: IDX_refund_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_refund_deleted_at" ON public.refund USING btree (deleted_at);


--
-- Name: IDX_refund_payment_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_refund_payment_id" ON public.refund USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_reason_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_refund_reason_deleted_at" ON public.refund_reason USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_refund_reason_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_refund_refund_reason_id" ON public.refund USING btree (refund_reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_region_country_deleted_at" ON public.region_country USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_region_country_region_id" ON public.region_country USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id_iso_2_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON public.region_country USING btree (region_id, iso_2);


--
-- Name: IDX_region_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_region_deleted_at" ON public.region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_region_id_1c934dab0; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_region_id_1c934dab0" ON public.region_payment_provider USING btree (region_id);


--
-- Name: IDX_reservation_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_reservation_item_deleted_at" ON public.reservation_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_reservation_item_inventory_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_reservation_item_inventory_item_id" ON public.reservation_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_line_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_reservation_item_line_item_id" ON public.reservation_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_location_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_reservation_item_location_id" ON public.reservation_item USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_claim_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_return_claim_id" ON public.return USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_display_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_return_display_id" ON public.return USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_exchange_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_return_exchange_id" ON public.return USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_id_-31ea43a; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_return_id_-31ea43a" ON public.return_fulfillment USING btree (return_id);


--
-- Name: IDX_return_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_return_item_deleted_at" ON public.return_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_return_item_item_id" ON public.return_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_reason_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_return_item_reason_id" ON public.return_item USING btree (reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_return_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_return_item_return_id" ON public.return_item USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_order_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_return_order_id" ON public.return USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_reason_value; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_return_reason_value" ON public.return_reason USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_sales_channel_deleted_at" ON public.sales_channel USING btree (deleted_at);


--
-- Name: IDX_sales_channel_id_-1d67bae40; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_sales_channel_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (sales_channel_id);


--
-- Name: IDX_sales_channel_id_20b454295; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_sales_channel_id_20b454295" ON public.product_sales_channel USING btree (sales_channel_id);


--
-- Name: IDX_sales_channel_id_26d06f470; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_sales_channel_id_26d06f470" ON public.sales_channel_stock_location USING btree (sales_channel_id);


--
-- Name: IDX_service_zone_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_service_zone_deleted_at" ON public.service_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_service_zone_fulfillment_set_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_service_zone_fulfillment_set_id" ON public.service_zone USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_service_zone_name_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_service_zone_name_unique" ON public.service_zone USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_method_adjustment_promotion_id" ON public.cart_shipping_method_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_option_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_method_option_id" ON public.cart_shipping_method USING btree (shipping_option_id) WHERE ((deleted_at IS NULL) AND (shipping_option_id IS NOT NULL));


--
-- Name: IDX_shipping_method_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_method_tax_line_tax_rate_id" ON public.cart_shipping_method_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_shipping_option_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_option_deleted_at" ON public.shipping_option USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_id_ba32fa9c; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_option_id_ba32fa9c" ON public.shipping_option_price_set USING btree (shipping_option_id);


--
-- Name: IDX_shipping_option_provider_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_option_provider_id" ON public.shipping_option USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_option_rule_deleted_at" ON public.shipping_option_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_rule_shipping_option_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_option_rule_shipping_option_id" ON public.shipping_option_rule USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_service_zone_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_option_service_zone_id" ON public.shipping_option USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_shipping_profile_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_option_shipping_profile_id" ON public.shipping_option USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_type_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_option_type_deleted_at" ON public.shipping_option_type USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_profile_deleted_at" ON public.shipping_profile USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_id_17a262437; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_shipping_profile_id_17a262437" ON public.product_shipping_profile USING btree (shipping_profile_id);


--
-- Name: IDX_shipping_profile_name_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_shipping_profile_name_unique" ON public.shipping_profile USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_single_default_region; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_single_default_region" ON public.tax_rate USING btree (tax_region_id) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- Name: IDX_stock_location_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_stock_location_address_deleted_at" ON public.stock_location_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_address_id_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_stock_location_address_id_unique" ON public.stock_location USING btree (address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_stock_location_deleted_at" ON public.stock_location USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_id_-1e5992737; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_stock_location_id_-1e5992737" ON public.location_fulfillment_provider USING btree (stock_location_id);


--
-- Name: IDX_stock_location_id_-e88adb96; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_stock_location_id_-e88adb96" ON public.location_fulfillment_set USING btree (stock_location_id);


--
-- Name: IDX_stock_location_id_26d06f470; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_stock_location_id_26d06f470" ON public.sales_channel_stock_location USING btree (stock_location_id);


--
-- Name: IDX_store_currency_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_store_currency_deleted_at" ON public.store_currency USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_store_currency_store_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_store_currency_store_id" ON public.store_currency USING btree (store_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_store_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_store_deleted_at" ON public.store USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tag_value_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_tag_value_unique" ON public.product_tag USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_line_item_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_provider_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_tax_provider_deleted_at" ON public.tax_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_tax_rate_deleted_at" ON public.tax_rate USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_tax_rate_rule_deleted_at" ON public.tax_rate_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_reference_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_tax_rate_rule_reference_id" ON public.tax_rate_rule USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_tax_rate_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_tax_rate_rule_tax_rate_id" ON public.tax_rate_rule USING btree (tax_rate_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_unique_rate_reference; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_tax_rate_rule_unique_rate_reference" ON public.tax_rate_rule USING btree (tax_rate_id, reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_tax_region_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_tax_rate_tax_region_id" ON public.tax_rate USING btree (tax_region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_tax_region_deleted_at" ON public.tax_region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_region_parent_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_tax_region_parent_id" ON public.tax_region USING btree (parent_id);


--
-- Name: IDX_tax_region_provider_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_tax_region_provider_id" ON public.tax_region USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_unique_country_nullable_province; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_nullable_province" ON public.tax_region USING btree (country_code) WHERE ((province_code IS NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_tax_region_unique_country_province; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_province" ON public.tax_region USING btree (country_code, province_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_type_value_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_type_value_unique" ON public.product_type USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_unique_promotion_code; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_unique_promotion_code" ON public.promotion USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_user_deleted_at" ON public."user" USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_user_email_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_user_email_unique" ON public."user" USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_variant_id_17b4c4e35; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_variant_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (variant_id);


--
-- Name: IDX_variant_id_52b23597; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_variant_id_52b23597" ON public.product_variant_price_set USING btree (variant_id);


--
-- Name: IDX_workflow_execution_deleted_at; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_workflow_execution_deleted_at" ON public.workflow_execution USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_workflow_execution_id" ON public.workflow_execution USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_state; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_workflow_execution_state" ON public.workflow_execution USING btree (state) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_transaction_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_workflow_execution_transaction_id" ON public.workflow_execution USING btree (transaction_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE INDEX "IDX_workflow_execution_workflow_id" ON public.workflow_execution USING btree (workflow_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id_transaction_id_run_id_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX "IDX_workflow_execution_workflow_id_transaction_id_run_id_unique" ON public.workflow_execution USING btree (workflow_id, transaction_id, run_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_script_name_unique; Type: INDEX; Schema: public; Owner: medusa_user
--

CREATE UNIQUE INDEX idx_script_name_unique ON public.script_migrations USING btree (script_name);


--
-- Name: tax_rate_rule FK_tax_rate_rule_tax_rate_id; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY (tax_rate_id) REFERENCES public.tax_rate(id) ON DELETE CASCADE;


--
-- Name: tax_rate FK_tax_rate_tax_region_id; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY (tax_region_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY (parent_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY (provider_id) REFERENCES public.tax_provider(id) ON DELETE SET NULL;


--
-- Name: application_method_buy_rules application_method_buy_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_buy_rules application_method_buy_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: capture capture_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item cart_line_item_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method cart_shipping_method_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: credit_line credit_line_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE;


--
-- Name: customer_address customer_address_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_group_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_group_id_foreign FOREIGN KEY (customer_group_id) REFERENCES public.customer_group(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_delivery_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_delivery_address_id_foreign FOREIGN KEY (delivery_address_id) REFERENCES public.fulfillment_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment_item fulfillment_item_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment_label fulfillment_label_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment fulfillment_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: geo_zone geo_zone_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: image image_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventory_level inventory_level_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: notification notification_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.notification_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: order order_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change_action order_change_action_order_change_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_order_change_id_foreign FOREIGN KEY (order_change_id) REFERENCES public.order_change(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change order_change_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_credit_line order_credit_line_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE;


--
-- Name: order_item order_item_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_adjustment order_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_tax_line order_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item order_line_item_totals_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_totals_id_foreign FOREIGN KEY (totals_id) REFERENCES public.order_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order order_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping order_shipping_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_summary order_summary_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_transaction order_transaction_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_col_aa276_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_col_aa276_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_pro_2d555_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_pro_2d555_foreign FOREIGN KEY (payment_provider_id) REFERENCES public.payment_provider(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment payment_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_session payment_session_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_list_rule price_list_rule_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES public.price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_rule price_rule_price_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_price_id_foreign FOREIGN KEY (price_id) REFERENCES public.price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category product_category_parent_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_parent_category_id_foreign FOREIGN KEY (parent_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_category_id_foreign FOREIGN KEY (product_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_option product_option_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_option_value product_option_value_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_option_id_foreign FOREIGN KEY (option_id) REFERENCES public.product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_tag_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_tag_id_foreign FOREIGN KEY (product_tag_id) REFERENCES public.product_tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_type_id_foreign FOREIGN KEY (type_id) REFERENCES public.product_type(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_variant_option product_variant_option_option_value_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_option_value_id_foreign FOREIGN KEY (option_value_id) REFERENCES public.product_option_value(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant_option product_variant_option_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_variant_id_foreign FOREIGN KEY (variant_id) REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant product_variant_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_application_method promotion_application_method_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion promotion_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_rule_value promotion_rule_value_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: provider_identity provider_identity_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refund refund_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: region_country region_country_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.region(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reservation_item reservation_item_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: return_reason return_reason_parent_return_reason_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_parent_return_reason_id_foreign FOREIGN KEY (parent_return_reason_id) REFERENCES public.return_reason(id);


--
-- Name: service_zone service_zone_fulfillment_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_fulfillment_set_id_foreign FOREIGN KEY (fulfillment_set_id) REFERENCES public.fulfillment_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shipping_option_rule shipping_option_rule_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_option_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_option_type_id_foreign FOREIGN KEY (shipping_option_type_id) REFERENCES public.shipping_option_type(id) ON UPDATE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_profile_id_foreign FOREIGN KEY (shipping_profile_id) REFERENCES public.shipping_profile(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stock_location stock_location_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_address_id_foreign FOREIGN KEY (address_id) REFERENCES public.stock_location_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: store_currency store_currency_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_user
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.store(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

