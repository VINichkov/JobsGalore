--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.5
-- Dumped by pg_dump version 9.5.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: carearones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE carearones (
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

CREATE SEQUENCE carearones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: carearones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE carearones_id_seq OWNED BY carearones.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE clients (
    id integer NOT NULL,
    firstname character varying NOT NULL,
    lastname character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    phone character varying,
    password character varying,
    resp boolean DEFAULT false NOT NULL,
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
    birth date
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clients_id_seq OWNED BY clients.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE companies (
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
    fts tsvector
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE companies_id_seq OWNED BY companies.id;


--
-- Name: educations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE educations (
    id integer NOT NULL,
    education character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: educations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE educations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: educations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE educations_id_seq OWNED BY educations.id;


--
-- Name: experiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE experiences (
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

CREATE SEQUENCE experiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE experiences_id_seq OWNED BY experiences.id;


--
-- Name: industries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE industries (
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

CREATE SEQUENCE industries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE industries_id_seq OWNED BY industries.id;


--
-- Name: industrycompanies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE industrycompanies (
    id integer NOT NULL,
    industry_id integer,
    company_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: industrycompanies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE industrycompanies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industrycompanies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE industrycompanies_id_seq OWNED BY industrycompanies.id;


--
-- Name: industryexperiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE industryexperiences (
    id integer NOT NULL,
    industry_id integer,
    experience_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: industryexperiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE industryexperiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industryexperiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE industryexperiences_id_seq OWNED BY industryexperiences.id;


--
-- Name: industryjobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE industryjobs (
    id integer NOT NULL,
    industry_id integer,
    job_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: industryjobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE industryjobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industryjobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE industryjobs_id_seq OWNED BY industryjobs.id;


--
-- Name: industryresumes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE industryresumes (
    id integer NOT NULL,
    industry_id integer,
    resume_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: industryresumes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE industryresumes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industryresumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE industryresumes_id_seq OWNED BY industryresumes.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE jobs (
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
    fts tsvector
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobs_id_seq OWNED BY jobs.id;


--
-- Name: languageresumes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE languageresumes (
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

CREATE SEQUENCE languageresumes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: languageresumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE languageresumes_id_seq OWNED BY languageresumes.id;


--
-- Name: languages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE languages (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE languages_id_seq OWNED BY languages.id;


--
-- Name: levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE levels (
    id integer NOT NULL,
    name character varying NOT NULL,
    language boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE levels_id_seq OWNED BY levels.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE locations (
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

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: properts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE properts (
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

CREATE SEQUENCE properts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: properts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE properts_id_seq OWNED BY properts.id;


--
-- Name: responsibles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE responsibles (
    id integer NOT NULL,
    company_id integer,
    client_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: responsibles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE responsibles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: responsibles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE responsibles_id_seq OWNED BY responsibles.id;


--
-- Name: resumes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE resumes (
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
    location_id integer
);


--
-- Name: resumes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resumes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resumes_id_seq OWNED BY resumes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sizes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sizes (
    id integer NOT NULL,
    size character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sizes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sizes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sizes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sizes_id_seq OWNED BY sizes.id;


--
-- Name: skillsjobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skillsjobs (
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

CREATE SEQUENCE skillsjobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skillsjobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skillsjobs_id_seq OWNED BY skillsjobs.id;


--
-- Name: skillsresumes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skillsresumes (
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

CREATE SEQUENCE skillsresumes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skillsresumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skillsresumes_id_seq OWNED BY skillsresumes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY carearones ALTER COLUMN id SET DEFAULT nextval('carearones_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clients ALTER COLUMN id SET DEFAULT nextval('clients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY educations ALTER COLUMN id SET DEFAULT nextval('educations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY experiences ALTER COLUMN id SET DEFAULT nextval('experiences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY industries ALTER COLUMN id SET DEFAULT nextval('industries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY industrycompanies ALTER COLUMN id SET DEFAULT nextval('industrycompanies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY industryexperiences ALTER COLUMN id SET DEFAULT nextval('industryexperiences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY industryjobs ALTER COLUMN id SET DEFAULT nextval('industryjobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY industryresumes ALTER COLUMN id SET DEFAULT nextval('industryresumes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs ALTER COLUMN id SET DEFAULT nextval('jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY languageresumes ALTER COLUMN id SET DEFAULT nextval('languageresumes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY languages ALTER COLUMN id SET DEFAULT nextval('languages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY levels ALTER COLUMN id SET DEFAULT nextval('levels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY properts ALTER COLUMN id SET DEFAULT nextval('properts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY responsibles ALTER COLUMN id SET DEFAULT nextval('responsibles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resumes ALTER COLUMN id SET DEFAULT nextval('resumes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sizes ALTER COLUMN id SET DEFAULT nextval('sizes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skillsjobs ALTER COLUMN id SET DEFAULT nextval('skillsjobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skillsresumes ALTER COLUMN id SET DEFAULT nextval('skillsresumes_id_seq'::regclass);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: carearones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY carearones
    ADD CONSTRAINT carearones_pkey PRIMARY KEY (id);


--
-- Name: clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: educations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY educations
    ADD CONSTRAINT educations_pkey PRIMARY KEY (id);


--
-- Name: experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY experiences
    ADD CONSTRAINT experiences_pkey PRIMARY KEY (id);


--
-- Name: industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industries
    ADD CONSTRAINT industries_pkey PRIMARY KEY (id);


--
-- Name: industrycompanies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industrycompanies
    ADD CONSTRAINT industrycompanies_pkey PRIMARY KEY (id);


--
-- Name: industryexperiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industryexperiences
    ADD CONSTRAINT industryexperiences_pkey PRIMARY KEY (id);


--
-- Name: industryjobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industryjobs
    ADD CONSTRAINT industryjobs_pkey PRIMARY KEY (id);


--
-- Name: industryresumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industryresumes
    ADD CONSTRAINT industryresumes_pkey PRIMARY KEY (id);


--
-- Name: jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: languageresumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY languageresumes
    ADD CONSTRAINT languageresumes_pkey PRIMARY KEY (id);


--
-- Name: languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY levels
    ADD CONSTRAINT levels_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: properts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY properts
    ADD CONSTRAINT properts_pkey PRIMARY KEY (id);


--
-- Name: responsibles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY responsibles
    ADD CONSTRAINT responsibles_pkey PRIMARY KEY (id);


--
-- Name: resumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resumes
    ADD CONSTRAINT resumes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sizes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sizes
    ADD CONSTRAINT sizes_pkey PRIMARY KEY (id);


--
-- Name: skillsjobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skillsjobs
    ADD CONSTRAINT skillsjobs_pkey PRIMARY KEY (id);


--
-- Name: skillsresumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skillsresumes
    ADD CONSTRAINT skillsresumes_pkey PRIMARY KEY (id);


--
-- Name: index_clients_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clients_on_email ON clients USING btree (email);


--
-- Name: index_clients_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clients_on_location_id ON clients USING btree (location_id);


--
-- Name: index_clients_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clients_on_reset_password_token ON clients USING btree (reset_password_token);


--
-- Name: index_companies_on_fts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_fts ON companies USING gin (fts);


--
-- Name: index_companies_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_location_id ON companies USING btree (location_id);


--
-- Name: index_companies_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_name ON companies USING btree (name);


--
-- Name: index_companies_on_size_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_size_id ON companies USING btree (size_id);


--
-- Name: index_experiences_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_experiences_on_location_id ON experiences USING btree (location_id);


--
-- Name: index_experiences_on_resume_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_experiences_on_resume_id ON experiences USING btree (resume_id);


--
-- Name: index_industries_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industries_on_industry_id ON industries USING btree (industry_id);


--
-- Name: index_industries_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industries_on_name ON industries USING btree (name);


--
-- Name: index_industrycompanies_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industrycompanies_on_company_id ON industrycompanies USING btree (company_id);


--
-- Name: index_industrycompanies_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industrycompanies_on_industry_id ON industrycompanies USING btree (industry_id);


--
-- Name: index_industryexperiences_on_experience_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryexperiences_on_experience_id ON industryexperiences USING btree (experience_id);


--
-- Name: index_industryexperiences_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryexperiences_on_industry_id ON industryexperiences USING btree (industry_id);


--
-- Name: index_industryjobs_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryjobs_on_industry_id ON industryjobs USING btree (industry_id);


--
-- Name: index_industryjobs_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryjobs_on_job_id ON industryjobs USING btree (job_id);


--
-- Name: index_industryresumes_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryresumes_on_industry_id ON industryresumes USING btree (industry_id);


--
-- Name: index_industryresumes_on_resume_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryresumes_on_resume_id ON industryresumes USING btree (resume_id);


--
-- Name: index_jobs_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_company_id ON jobs USING btree (company_id);


--
-- Name: index_jobs_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_created_at ON jobs USING btree (created_at);


--
-- Name: index_jobs_on_education_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_education_id ON jobs USING btree (education_id);


--
-- Name: index_jobs_on_fts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_fts ON jobs USING gin (fts);


--
-- Name: index_jobs_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_location_id ON jobs USING btree (location_id);


--
-- Name: index_jobs_on_salarymax; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_salarymax ON jobs USING btree (salarymax);


--
-- Name: index_jobs_on_salarymin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_salarymin ON jobs USING btree (salarymin);


--
-- Name: index_jobs_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_updated_at ON jobs USING btree (updated_at);


--
-- Name: index_languageresumes_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_languageresumes_on_language_id ON languageresumes USING btree (language_id);


--
-- Name: index_languageresumes_on_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_languageresumes_on_level_id ON languageresumes USING btree (level_id);


--
-- Name: index_languageresumes_on_resume_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_languageresumes_on_resume_id ON languageresumes USING btree (resume_id);


--
-- Name: index_locations_on_fts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_fts ON locations USING gin (fts);


--
-- Name: index_locations_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_parent_id ON locations USING btree (parent_id);


--
-- Name: index_responsibles_on_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_responsibles_on_client_id ON responsibles USING btree (client_id);


--
-- Name: index_responsibles_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_responsibles_on_company_id ON responsibles USING btree (company_id);


--
-- Name: index_resumes_on_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_client_id ON resumes USING btree (client_id);


--
-- Name: index_resumes_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_created_at ON resumes USING btree (created_at);


--
-- Name: index_resumes_on_fts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_fts ON resumes USING gin (fts);


--
-- Name: index_resumes_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_location_id ON resumes USING btree (location_id);


--
-- Name: index_resumes_on_salary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_salary ON resumes USING btree (salary);


--
-- Name: index_resumes_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_updated_at ON resumes USING btree (updated_at);


--
-- Name: index_skillsjobs_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skillsjobs_on_job_id ON skillsjobs USING btree (job_id);


--
-- Name: index_skillsjobs_on_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skillsjobs_on_level_id ON skillsjobs USING btree (level_id);


--
-- Name: index_skillsjobs_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skillsjobs_on_name ON skillsjobs USING btree (name);


--
-- Name: index_skillsresumes_on_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skillsresumes_on_level_id ON skillsresumes USING btree (level_id);


--
-- Name: index_skillsresumes_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skillsresumes_on_name ON skillsresumes USING btree (name);


--
-- Name: index_skillsresumes_on_resume_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skillsresumes_on_resume_id ON skillsresumes USING btree (resume_id);


--
-- Name: tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON locations FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fts', 'pg_catalog.english', 'suburb', 'postcode', 'state');


--
-- Name: tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON companies FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fts', 'pg_catalog.english', 'name', 'description');


--
-- Name: tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON jobs FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fts', 'pg_catalog.english', 'title', 'description', 'career');


--
-- Name: tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON resumes FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fts', 'pg_catalog.english', 'desiredjobtitle', 'abouteme');


--
-- Name: fk_rails_032ff5b3d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industries
    ADD CONSTRAINT fk_rails_032ff5b3d0 FOREIGN KEY (industry_id) REFERENCES industries(id);


--
-- Name: fk_rails_1e99f51bd6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT fk_rails_1e99f51bd6 FOREIGN KEY (location_id) REFERENCES locations(id);


--
-- Name: fk_rails_2c54a51ad1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY responsibles
    ADD CONSTRAINT fk_rails_2c54a51ad1 FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: fk_rails_2d8974d3a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industrycompanies
    ADD CONSTRAINT fk_rails_2d8974d3a3 FOREIGN KEY (industry_id) REFERENCES industries(id);


--
-- Name: fk_rails_3cd5abca1e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skillsjobs
    ADD CONSTRAINT fk_rails_3cd5abca1e FOREIGN KEY (job_id) REFERENCES jobs(id);


--
-- Name: fk_rails_3fc928c70b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industryresumes
    ADD CONSTRAINT fk_rails_3fc928c70b FOREIGN KEY (industry_id) REFERENCES industries(id);


--
-- Name: fk_rails_493fe47dba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industryexperiences
    ADD CONSTRAINT fk_rails_493fe47dba FOREIGN KEY (experience_id) REFERENCES experiences(id);


--
-- Name: fk_rails_58be162534; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resumes
    ADD CONSTRAINT fk_rails_58be162534 FOREIGN KEY (client_id) REFERENCES clients(id);


--
-- Name: fk_rails_598396e933; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skillsresumes
    ADD CONSTRAINT fk_rails_598396e933 FOREIGN KEY (resume_id) REFERENCES resumes(id);


--
-- Name: fk_rails_5bc7cd63b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industryjobs
    ADD CONSTRAINT fk_rails_5bc7cd63b7 FOREIGN KEY (industry_id) REFERENCES industries(id);


--
-- Name: fk_rails_5c3982cde1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industryjobs
    ADD CONSTRAINT fk_rails_5c3982cde1 FOREIGN KEY (job_id) REFERENCES jobs(id);


--
-- Name: fk_rails_65e42eec04; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skillsjobs
    ADD CONSTRAINT fk_rails_65e42eec04 FOREIGN KEY (level_id) REFERENCES levels(id);


--
-- Name: fk_rails_7985a15ffb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY languageresumes
    ADD CONSTRAINT fk_rails_7985a15ffb FOREIGN KEY (resume_id) REFERENCES resumes(id);


--
-- Name: fk_rails_880df2fbb3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY responsibles
    ADD CONSTRAINT fk_rails_880df2fbb3 FOREIGN KEY (client_id) REFERENCES clients(id);


--
-- Name: fk_rails_91959a45b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY experiences
    ADD CONSTRAINT fk_rails_91959a45b5 FOREIGN KEY (location_id) REFERENCES locations(id);


--
-- Name: fk_rails_9a4dfd1104; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industrycompanies
    ADD CONSTRAINT fk_rails_9a4dfd1104 FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: fk_rails_9aea75896a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY languageresumes
    ADD CONSTRAINT fk_rails_9aea75896a FOREIGN KEY (language_id) REFERENCES languages(id);


--
-- Name: fk_rails_9b863559a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT fk_rails_9b863559a5 FOREIGN KEY (size_id) REFERENCES sizes(id);


--
-- Name: fk_rails_ae769b0e0b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clients
    ADD CONSTRAINT fk_rails_ae769b0e0b FOREIGN KEY (location_id) REFERENCES locations(id);


--
-- Name: fk_rails_b062765ade; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY experiences
    ADD CONSTRAINT fk_rails_b062765ade FOREIGN KEY (resume_id) REFERENCES resumes(id);


--
-- Name: fk_rails_b1f3718ea8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_rails_b1f3718ea8 FOREIGN KEY (education_id) REFERENCES educations(id);


--
-- Name: fk_rails_b34da78090; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_rails_b34da78090 FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: fk_rails_b4dfe111b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industryresumes
    ADD CONSTRAINT fk_rails_b4dfe111b6 FOREIGN KEY (resume_id) REFERENCES resumes(id);


--
-- Name: fk_rails_cf58b01b64; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industryexperiences
    ADD CONSTRAINT fk_rails_cf58b01b64 FOREIGN KEY (industry_id) REFERENCES industries(id);


--
-- Name: fk_rails_dfb2269fe4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY languageresumes
    ADD CONSTRAINT fk_rails_dfb2269fe4 FOREIGN KEY (level_id) REFERENCES levels(id);


--
-- Name: fk_rails_e1588fa548; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_rails_e1588fa548 FOREIGN KEY (location_id) REFERENCES locations(id);


--
-- Name: fk_rails_e57ac8f3e0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resumes
    ADD CONSTRAINT fk_rails_e57ac8f3e0 FOREIGN KEY (location_id) REFERENCES locations(id);


--
-- Name: fk_rails_f31c8994eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skillsresumes
    ADD CONSTRAINT fk_rails_f31c8994eb FOREIGN KEY (level_id) REFERENCES levels(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20161216140254'), ('20161216140255'), ('20161216144123'), ('20161216144836'), ('20161216144837'), ('20161216144838'), ('20161216144839'), ('20161216144840'), ('20161216144842'), ('20161216144843'), ('20161216152826'), ('20161216152951'), ('20161216152952'), ('20161216152953'), ('20161216153048'), ('20161220113257'), ('20161220114325'), ('20161220114429'), ('20161220114751'), ('20161221095015'), ('20170125130039'), ('20170228101552'), ('20170310100000'), ('20170330000001'), ('20170430102817'), ('20170430103528');


