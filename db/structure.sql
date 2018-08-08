SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: companies_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.companies_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      begin
        new.fts :=
            setweight(to_tsvector('pg_catalog.english', coalesce(new.name,'')), 'A') ||
            setweight(to_tsvector('pg_catalog.english', coalesce(new.description,'')), 'D');
        return new;
      end
      $$;


--
-- Name: jobs_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.jobs_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      begin
        new.fts :=
            setweight(to_tsvector('pg_catalog.english', coalesce(new.title,'')), 'A') ||
            setweight(to_tsvector('pg_catalog.english', coalesce(new.description,'')), 'D');
        return new;
      end
      $$;


--
-- Name: resumes_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.resumes_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
      new.fts :=
          setweight(to_tsvector('pg_catalog.english', coalesce(new.desiredjobtitle,'')), 'A') ||
          setweight(to_tsvector('pg_catalog.english', coalesce(new.abouteme,'')), 'D');
      return new;
    end
    $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: carearones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.carearones (
    id integer NOT NULL,
    title_job character varying,
    descriptions text,
    type character varying,
    category character varying,
    location character varying
);


--
-- Name: carearones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.carearones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: carearones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.carearones_id_seq OWNED BY public.carearones.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    firstname character varying NOT NULL,
    lastname character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    phone character varying,
    password character varying,
    photo_uid character varying,
    gender boolean,
    location_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    birth date,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    "character" character varying,
    send_email boolean DEFAULT true NOT NULL,
    company_id integer,
    provider character varying,
    uid character varying
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id integer NOT NULL,
    name character varying,
    size_id integer,
    location_id integer,
    site character varying,
    logo_uid character varying,
    recrutmentagency boolean,
    description character varying,
    realy boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fts tsvector,
    industry_id integer
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: educations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.educations (
    id integer NOT NULL,
    education character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: educations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.educations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: educations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.educations_id_seq OWNED BY public.educations.id;


--
-- Name: emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.emails (
    id integer NOT NULL,
    email character varying
);


--
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.emails_id_seq OWNED BY public.emails.id;


--
-- Name: experiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.experiences (
    id integer NOT NULL,
    employer character varying NOT NULL,
    location_id integer,
    site character varying,
    titlejob character varying NOT NULL,
    datestart date,
    dateend date,
    description character varying,
    resume_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.experiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.experiences_id_seq OWNED BY public.experiences.id;


--
-- Name: gateways; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gateways (
    id integer NOT NULL,
    company_id integer,
    client_id integer,
    location_id integer,
    industry_id integer,
    script character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    log character varying,
    hashtags character varying
);


--
-- Name: gateways_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gateways_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gateways_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gateways_id_seq OWNED BY public.gateways.id;


--
-- Name: industries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industries (
    id integer NOT NULL,
    name character varying NOT NULL,
    industry_id integer,
    level integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: industries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.industries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.industries_id_seq OWNED BY public.industries.id;


--
-- Name: industrycompanies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industrycompanies (
    id integer NOT NULL,
    industry_id integer,
    company_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: industrycompanies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.industrycompanies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industrycompanies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.industrycompanies_id_seq OWNED BY public.industrycompanies.id;


--
-- Name: industryexperiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industryexperiences (
    id integer NOT NULL,
    industry_id integer,
    experience_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: industryexperiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.industryexperiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industryexperiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.industryexperiences_id_seq OWNED BY public.industryexperiences.id;


--
-- Name: industryjobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industryjobs (
    id integer NOT NULL,
    industry_id integer,
    job_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: industryjobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.industryjobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industryjobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.industryjobs_id_seq OWNED BY public.industryjobs.id;


--
-- Name: industryresumes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industryresumes (
    id integer NOT NULL,
    industry_id integer,
    resume_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: industryresumes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.industryresumes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industryresumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.industryresumes_id_seq OWNED BY public.industryresumes.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id integer NOT NULL,
    title character varying,
    location_id integer,
    salarymin double precision,
    salarymax double precision,
    permanent boolean,
    casual boolean,
    temp boolean,
    contract boolean,
    fulltime boolean,
    parttime boolean,
    flextime boolean,
    remote boolean,
    description character varying,
    company_id integer,
    education_id integer,
    career character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fts tsvector,
    highlight date,
    top date,
    urgent date,
    client_id integer,
    close date,
    twitter character varying,
    industry_id integer,
    viewed json[] DEFAULT '{}'::json[]
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: languageresumes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.languageresumes (
    id integer NOT NULL,
    resume_id integer,
    language_id integer,
    level_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: languageresumes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.languageresumes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: languageresumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.languageresumes_id_seq OWNED BY public.languageresumes.id;


--
-- Name: languages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.languages (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.languages_id_seq OWNED BY public.languages.id;


--
-- Name: levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.levels (
    id integer NOT NULL,
    name character varying NOT NULL,
    language boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.levels_id_seq OWNED BY public.levels.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    postcode character varying,
    suburb character varying,
    state character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    parent_id integer,
    fts tsvector
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    params text,
    product_id integer,
    kind integer,
    kindpay integer,
    status character varying,
    transaction_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: properts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.properts (
    id integer NOT NULL,
    code character varying,
    name character varying,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: properts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.properts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: properts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.properts_id_seq OWNED BY public.properts.id;


--
-- Name: responsibles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.responsibles (
    id integer NOT NULL,
    company_id integer,
    client_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: responsibles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.responsibles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: responsibles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.responsibles_id_seq OWNED BY public.responsibles.id;


--
-- Name: resumes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resumes (
    id integer NOT NULL,
    desiredjobtitle character varying NOT NULL,
    salary double precision,
    permanent boolean,
    casual boolean,
    temp boolean,
    contract boolean,
    fulltime boolean,
    parttime boolean,
    flextime boolean,
    remote boolean,
    abouteme character varying,
    client_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fts tsvector,
    location_id integer,
    highlight date,
    top date,
    urgent date,
    industry_id integer,
    viewed json[] DEFAULT '{}'::json[]
);


--
-- Name: resumes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resumes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resumes_id_seq OWNED BY public.resumes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sizes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sizes (
    id integer NOT NULL,
    size character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sizes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sizes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sizes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sizes_id_seq OWNED BY public.sizes.id;


--
-- Name: skillsjobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skillsjobs (
    id integer NOT NULL,
    name character varying NOT NULL,
    level_id integer,
    job_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: skillsjobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.skillsjobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skillsjobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.skillsjobs_id_seq OWNED BY public.skillsjobs.id;


--
-- Name: skillsresumes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skillsresumes (
    id integer NOT NULL,
    name character varying NOT NULL,
    level_id integer,
    resume_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: skillsresumes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.skillsresumes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skillsresumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.skillsresumes_id_seq OWNED BY public.skillsresumes.id;


--
-- Name: temporaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.temporaries (
    id bigint NOT NULL,
    session character varying,
    object json[] DEFAULT '{}'::json[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: temporaries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.temporaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temporaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.temporaries_id_seq OWNED BY public.temporaries.id;


--
-- Name: carearones id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carearones ALTER COLUMN id SET DEFAULT nextval('public.carearones_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: educations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.educations ALTER COLUMN id SET DEFAULT nextval('public.educations_id_seq'::regclass);


--
-- Name: emails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emails ALTER COLUMN id SET DEFAULT nextval('public.emails_id_seq'::regclass);


--
-- Name: experiences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiences ALTER COLUMN id SET DEFAULT nextval('public.experiences_id_seq'::regclass);


--
-- Name: gateways id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gateways ALTER COLUMN id SET DEFAULT nextval('public.gateways_id_seq'::regclass);


--
-- Name: industries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industries ALTER COLUMN id SET DEFAULT nextval('public.industries_id_seq'::regclass);


--
-- Name: industrycompanies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industrycompanies ALTER COLUMN id SET DEFAULT nextval('public.industrycompanies_id_seq'::regclass);


--
-- Name: industryexperiences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryexperiences ALTER COLUMN id SET DEFAULT nextval('public.industryexperiences_id_seq'::regclass);


--
-- Name: industryjobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryjobs ALTER COLUMN id SET DEFAULT nextval('public.industryjobs_id_seq'::regclass);


--
-- Name: industryresumes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryresumes ALTER COLUMN id SET DEFAULT nextval('public.industryresumes_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: languageresumes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languageresumes ALTER COLUMN id SET DEFAULT nextval('public.languageresumes_id_seq'::regclass);


--
-- Name: languages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languages ALTER COLUMN id SET DEFAULT nextval('public.languages_id_seq'::regclass);


--
-- Name: levels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.levels ALTER COLUMN id SET DEFAULT nextval('public.levels_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: properts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.properts ALTER COLUMN id SET DEFAULT nextval('public.properts_id_seq'::regclass);


--
-- Name: responsibles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responsibles ALTER COLUMN id SET DEFAULT nextval('public.responsibles_id_seq'::regclass);


--
-- Name: resumes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes ALTER COLUMN id SET DEFAULT nextval('public.resumes_id_seq'::regclass);


--
-- Name: sizes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sizes ALTER COLUMN id SET DEFAULT nextval('public.sizes_id_seq'::regclass);


--
-- Name: skillsjobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skillsjobs ALTER COLUMN id SET DEFAULT nextval('public.skillsjobs_id_seq'::regclass);


--
-- Name: skillsresumes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skillsresumes ALTER COLUMN id SET DEFAULT nextval('public.skillsresumes_id_seq'::regclass);


--
-- Name: temporaries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporaries ALTER COLUMN id SET DEFAULT nextval('public.temporaries_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: carearones carearones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carearones
    ADD CONSTRAINT carearones_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: educations educations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.educations
    ADD CONSTRAINT educations_pkey PRIMARY KEY (id);


--
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (id);


--
-- Name: experiences experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiences
    ADD CONSTRAINT experiences_pkey PRIMARY KEY (id);


--
-- Name: gateways gateways_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gateways
    ADD CONSTRAINT gateways_pkey PRIMARY KEY (id);


--
-- Name: industries industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industries
    ADD CONSTRAINT industries_pkey PRIMARY KEY (id);


--
-- Name: industrycompanies industrycompanies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industrycompanies
    ADD CONSTRAINT industrycompanies_pkey PRIMARY KEY (id);


--
-- Name: industryexperiences industryexperiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryexperiences
    ADD CONSTRAINT industryexperiences_pkey PRIMARY KEY (id);


--
-- Name: industryjobs industryjobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryjobs
    ADD CONSTRAINT industryjobs_pkey PRIMARY KEY (id);


--
-- Name: industryresumes industryresumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryresumes
    ADD CONSTRAINT industryresumes_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: languageresumes languageresumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languageresumes
    ADD CONSTRAINT languageresumes_pkey PRIMARY KEY (id);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: levels levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.levels
    ADD CONSTRAINT levels_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: properts properts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.properts
    ADD CONSTRAINT properts_pkey PRIMARY KEY (id);


--
-- Name: responsibles responsibles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responsibles
    ADD CONSTRAINT responsibles_pkey PRIMARY KEY (id);


--
-- Name: resumes resumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT resumes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sizes sizes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sizes
    ADD CONSTRAINT sizes_pkey PRIMARY KEY (id);


--
-- Name: skillsjobs skillsjobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skillsjobs
    ADD CONSTRAINT skillsjobs_pkey PRIMARY KEY (id);


--
-- Name: skillsresumes skillsresumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skillsresumes
    ADD CONSTRAINT skillsresumes_pkey PRIMARY KEY (id);


--
-- Name: temporaries temporaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporaries
    ADD CONSTRAINT temporaries_pkey PRIMARY KEY (id);


--
-- Name: index_clients_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clients_on_company_id ON public.clients USING btree (company_id);


--
-- Name: index_clients_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clients_on_confirmation_token ON public.clients USING btree (confirmation_token);


--
-- Name: index_clients_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clients_on_email ON public.clients USING btree (email);


--
-- Name: index_clients_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clients_on_location_id ON public.clients USING btree (location_id);


--
-- Name: index_clients_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clients_on_reset_password_token ON public.clients USING btree (reset_password_token);


--
-- Name: index_clients_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clients_on_unlock_token ON public.clients USING btree (unlock_token);


--
-- Name: index_companies_on_fts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_fts ON public.companies USING gin (fts);


--
-- Name: index_companies_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_industry_id ON public.companies USING btree (industry_id);


--
-- Name: index_companies_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_location_id ON public.companies USING btree (location_id);


--
-- Name: index_companies_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_name ON public.companies USING btree (name);


--
-- Name: index_companies_on_size_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_size_id ON public.companies USING btree (size_id);


--
-- Name: index_experiences_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_experiences_on_location_id ON public.experiences USING btree (location_id);


--
-- Name: index_experiences_on_resume_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_experiences_on_resume_id ON public.experiences USING btree (resume_id);


--
-- Name: index_gateways_on_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gateways_on_client_id ON public.gateways USING btree (client_id);


--
-- Name: index_gateways_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gateways_on_company_id ON public.gateways USING btree (company_id);


--
-- Name: index_gateways_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gateways_on_industry_id ON public.gateways USING btree (industry_id);


--
-- Name: index_gateways_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gateways_on_location_id ON public.gateways USING btree (location_id);


--
-- Name: index_industries_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industries_on_industry_id ON public.industries USING btree (industry_id);


--
-- Name: index_industries_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industries_on_name ON public.industries USING btree (name);


--
-- Name: index_industrycompanies_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industrycompanies_on_company_id ON public.industrycompanies USING btree (company_id);


--
-- Name: index_industrycompanies_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industrycompanies_on_industry_id ON public.industrycompanies USING btree (industry_id);


--
-- Name: index_industryexperiences_on_experience_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryexperiences_on_experience_id ON public.industryexperiences USING btree (experience_id);


--
-- Name: index_industryexperiences_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryexperiences_on_industry_id ON public.industryexperiences USING btree (industry_id);


--
-- Name: index_industryjobs_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryjobs_on_industry_id ON public.industryjobs USING btree (industry_id);


--
-- Name: index_industryjobs_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryjobs_on_job_id ON public.industryjobs USING btree (job_id);


--
-- Name: index_industryresumes_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryresumes_on_industry_id ON public.industryresumes USING btree (industry_id);


--
-- Name: index_industryresumes_on_resume_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryresumes_on_resume_id ON public.industryresumes USING btree (resume_id);


--
-- Name: index_jobs_on_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_client_id ON public.jobs USING btree (client_id);


--
-- Name: index_jobs_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_company_id ON public.jobs USING btree (company_id);


--
-- Name: index_jobs_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_created_at ON public.jobs USING btree (created_at);


--
-- Name: index_jobs_on_education_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_education_id ON public.jobs USING btree (education_id);


--
-- Name: index_jobs_on_fts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_fts ON public.jobs USING gin (fts);


--
-- Name: index_jobs_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_industry_id ON public.jobs USING btree (industry_id);


--
-- Name: index_jobs_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_location_id ON public.jobs USING btree (location_id);


--
-- Name: index_jobs_on_salarymax; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_salarymax ON public.jobs USING btree (salarymax);


--
-- Name: index_jobs_on_salarymin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_salarymin ON public.jobs USING btree (salarymin);


--
-- Name: index_jobs_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_updated_at ON public.jobs USING btree (updated_at);


--
-- Name: index_languageresumes_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_languageresumes_on_language_id ON public.languageresumes USING btree (language_id);


--
-- Name: index_languageresumes_on_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_languageresumes_on_level_id ON public.languageresumes USING btree (level_id);


--
-- Name: index_languageresumes_on_resume_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_languageresumes_on_resume_id ON public.languageresumes USING btree (resume_id);


--
-- Name: index_locations_on_fts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_fts ON public.locations USING gin (fts);


--
-- Name: index_locations_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_parent_id ON public.locations USING btree (parent_id);


--
-- Name: index_responsibles_on_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_responsibles_on_client_id ON public.responsibles USING btree (client_id);


--
-- Name: index_responsibles_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_responsibles_on_company_id ON public.responsibles USING btree (company_id);


--
-- Name: index_resumes_on_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_client_id ON public.resumes USING btree (client_id);


--
-- Name: index_resumes_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_created_at ON public.resumes USING btree (created_at);


--
-- Name: index_resumes_on_fts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_fts ON public.resumes USING gin (fts);


--
-- Name: index_resumes_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_industry_id ON public.resumes USING btree (industry_id);


--
-- Name: index_resumes_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_location_id ON public.resumes USING btree (location_id);


--
-- Name: index_resumes_on_salary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_salary ON public.resumes USING btree (salary);


--
-- Name: index_resumes_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_updated_at ON public.resumes USING btree (updated_at);


--
-- Name: index_skillsjobs_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skillsjobs_on_job_id ON public.skillsjobs USING btree (job_id);


--
-- Name: index_skillsjobs_on_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skillsjobs_on_level_id ON public.skillsjobs USING btree (level_id);


--
-- Name: index_skillsjobs_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skillsjobs_on_name ON public.skillsjobs USING btree (name);


--
-- Name: index_skillsresumes_on_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skillsresumes_on_level_id ON public.skillsresumes USING btree (level_id);


--
-- Name: index_skillsresumes_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skillsresumes_on_name ON public.skillsresumes USING btree (name);


--
-- Name: index_skillsresumes_on_resume_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skillsresumes_on_resume_id ON public.skillsresumes USING btree (resume_id);


--
-- Name: locations tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.locations FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fts', 'pg_catalog.english', 'suburb', 'postcode', 'state');

ALTER TABLE public.locations DISABLE TRIGGER tsvectorupdate;


--
-- Name: companies tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.companies FOR EACH ROW EXECUTE PROCEDURE public.companies_trigger();


--
-- Name: jobs tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.jobs FOR EACH ROW EXECUTE PROCEDURE public.jobs_trigger();


--
-- Name: resumes tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.resumes FOR EACH ROW EXECUTE PROCEDURE public.resumes_trigger();


--
-- Name: resumes fk_rails_003565a9fb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT fk_rails_003565a9fb FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: industries fk_rails_032ff5b3d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industries
    ADD CONSTRAINT fk_rails_032ff5b3d0 FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: companies fk_rails_1e99f51bd6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT fk_rails_1e99f51bd6 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: responsibles fk_rails_2c54a51ad1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responsibles
    ADD CONSTRAINT fk_rails_2c54a51ad1 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: industrycompanies fk_rails_2d8974d3a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industrycompanies
    ADD CONSTRAINT fk_rails_2d8974d3a3 FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: gateways fk_rails_3476d36c73; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gateways
    ADD CONSTRAINT fk_rails_3476d36c73 FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: skillsjobs fk_rails_3cd5abca1e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skillsjobs
    ADD CONSTRAINT fk_rails_3cd5abca1e FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: industryresumes fk_rails_3fc928c70b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryresumes
    ADD CONSTRAINT fk_rails_3fc928c70b FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: industryexperiences fk_rails_493fe47dba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryexperiences
    ADD CONSTRAINT fk_rails_493fe47dba FOREIGN KEY (experience_id) REFERENCES public.experiences(id);


--
-- Name: resumes fk_rails_58be162534; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT fk_rails_58be162534 FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: skillsresumes fk_rails_598396e933; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skillsresumes
    ADD CONSTRAINT fk_rails_598396e933 FOREIGN KEY (resume_id) REFERENCES public.resumes(id);


--
-- Name: jobs fk_rails_5b8502059e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_5b8502059e FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: industryjobs fk_rails_5bc7cd63b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryjobs
    ADD CONSTRAINT fk_rails_5bc7cd63b7 FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: industryjobs fk_rails_5c3982cde1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryjobs
    ADD CONSTRAINT fk_rails_5c3982cde1 FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: skillsjobs fk_rails_65e42eec04; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skillsjobs
    ADD CONSTRAINT fk_rails_65e42eec04 FOREIGN KEY (level_id) REFERENCES public.levels(id);


--
-- Name: languageresumes fk_rails_7985a15ffb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languageresumes
    ADD CONSTRAINT fk_rails_7985a15ffb FOREIGN KEY (resume_id) REFERENCES public.resumes(id);


--
-- Name: companies fk_rails_81ca530391; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT fk_rails_81ca530391 FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: responsibles fk_rails_880df2fbb3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responsibles
    ADD CONSTRAINT fk_rails_880df2fbb3 FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: experiences fk_rails_91959a45b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiences
    ADD CONSTRAINT fk_rails_91959a45b5 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: gateways fk_rails_9650b12e65; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gateways
    ADD CONSTRAINT fk_rails_9650b12e65 FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: industrycompanies fk_rails_9a4dfd1104; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industrycompanies
    ADD CONSTRAINT fk_rails_9a4dfd1104 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: languageresumes fk_rails_9aea75896a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languageresumes
    ADD CONSTRAINT fk_rails_9aea75896a FOREIGN KEY (language_id) REFERENCES public.languages(id);


--
-- Name: companies fk_rails_9b863559a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT fk_rails_9b863559a5 FOREIGN KEY (size_id) REFERENCES public.sizes(id);


--
-- Name: clients fk_rails_ae769b0e0b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT fk_rails_ae769b0e0b FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: experiences fk_rails_b062765ade; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiences
    ADD CONSTRAINT fk_rails_b062765ade FOREIGN KEY (resume_id) REFERENCES public.resumes(id);


--
-- Name: gateways fk_rails_b0cc6672a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gateways
    ADD CONSTRAINT fk_rails_b0cc6672a9 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: jobs fk_rails_b1f3718ea8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_b1f3718ea8 FOREIGN KEY (education_id) REFERENCES public.educations(id);


--
-- Name: jobs fk_rails_b34da78090; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_b34da78090 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: industryresumes fk_rails_b4dfe111b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryresumes
    ADD CONSTRAINT fk_rails_b4dfe111b6 FOREIGN KEY (resume_id) REFERENCES public.resumes(id);


--
-- Name: industryexperiences fk_rails_cf58b01b64; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryexperiences
    ADD CONSTRAINT fk_rails_cf58b01b64 FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: gateways fk_rails_dec69062e5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gateways
    ADD CONSTRAINT fk_rails_dec69062e5 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: languageresumes fk_rails_dfb2269fe4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languageresumes
    ADD CONSTRAINT fk_rails_dfb2269fe4 FOREIGN KEY (level_id) REFERENCES public.levels(id);


--
-- Name: jobs fk_rails_e1588fa548; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_e1588fa548 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: resumes fk_rails_e57ac8f3e0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT fk_rails_e57ac8f3e0 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: skillsresumes fk_rails_f31c8994eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skillsresumes
    ADD CONSTRAINT fk_rails_f31c8994eb FOREIGN KEY (level_id) REFERENCES public.levels(id);


--
-- Name: jobs fk_rails_f3577d7dd3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_f3577d7dd3 FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20161216140254'),
('20161216140255'),
('20161216144123'),
('20161216144836'),
('20161216144837'),
('20161216144838'),
('20161216144839'),
('20161216144840'),
('20161216144842'),
('20161216144843'),
('20161216152826'),
('20161216152951'),
('20161216152952'),
('20161216152953'),
('20161216153048'),
('20161220113257'),
('20161220114325'),
('20161220114429'),
('20161220114751'),
('20161221095015'),
('20170125130039'),
('20170228101552'),
('20170310100000'),
('20170330000001'),
('20170430102817'),
('20170430103528'),
('20170621104707'),
('20170630083503'),
('20170703065606'),
('20170706115005'),
('20170909101238'),
('20170925080815'),
('20170925084348'),
('20170925090306'),
('20170925094404'),
('20171115064516'),
('20171115080406'),
('20171115095734'),
('20171116103057'),
('20171120104421'),
('20171227042835'),
('20171227043153'),
('20171228040745'),
('20180204105551'),
('20180218093045'),
('20180601064454'),
('20180717112526'),
('20180719095548'),
('20180720094458');


