--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pgsql
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

--
-- Name: geos_id_seq; Type: SEQUENCE; Schema: public; Owner: foodgenome
--

CREATE SEQUENCE geos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.geos_id_seq OWNER TO foodgenome;

--
-- Name: geos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: foodgenome
--

SELECT pg_catalog.setval('geos_id_seq', 1, false);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: geos; Type: TABLE; Schema: public; Owner: foodgenome; Tablespace: 
--

CREATE TABLE geos (
    id integer DEFAULT nextval('geos_id_seq'::regclass) NOT NULL,
    lat double precision DEFAULT 0,
    lon double precision DEFAULT 0,
    "user" integer DEFAULT 0,
    created_at timestamp without time zone
);


ALTER TABLE public.geos OWNER TO foodgenome;

--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: foodgenome
--

CREATE SEQUENCE notes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.notes_id_seq OWNER TO foodgenome;

--
-- Name: notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: foodgenome
--

SELECT pg_catalog.setval('notes_id_seq', 27, true);


--
-- Name: notes; Type: TABLE; Schema: public; Owner: foodgenome; Tablespace: 
--

CREATE TABLE notes (
    id integer DEFAULT nextval('notes_id_seq'::regclass) NOT NULL,
    "type" character varying(50) NOT NULL,
    uuid text,
    title text,
    link text,
    description text,
    tagstring text,
    depiction text,
    "location" text,
    lat double precision DEFAULT 0,
    lon double precision DEFAULT 0,
    radius double precision DEFAULT 1,
    begins timestamp without time zone,
    ends timestamp without time zone,
    permissions integer DEFAULT 1,
    kind character varying(50) DEFAULT ''::character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    owner_id integer,
    "login" character varying(50),
    email character varying(50),
    firstname character varying(50),
    lastname character varying(50),
    crypted_password character varying(50),
    salt character varying(50),
    remember_token character varying(50),
    remember_token_expires_at timestamp without time zone,
    provenance text
);


ALTER TABLE public.notes OWNER TO foodgenome;

--
-- Name: relations_id_seq; Type: SEQUENCE; Schema: public; Owner: foodgenome
--

CREATE SEQUENCE relations_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.relations_id_seq OWNER TO foodgenome;

--
-- Name: relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: foodgenome
--

SELECT pg_catalog.setval('relations_id_seq', 23, true);


--
-- Name: relations; Type: TABLE; Schema: public; Owner: foodgenome; Tablespace: 
--

CREATE TABLE relations (
    id integer DEFAULT nextval('relations_id_seq'::regclass) NOT NULL,
    kind character varying(50) DEFAULT ''::character varying,
    value text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    note_id integer,
    sibling_id integer
);


ALTER TABLE public.relations OWNER TO foodgenome;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: foodgenome; Tablespace: 
--

CREATE TABLE sessions (
    session_id character varying(32) NOT NULL,
    data text DEFAULT 'BAh7AA== '::text,
    created_at timestamp without time zone
);


ALTER TABLE public.sessions OWNER TO foodgenome;

--
-- Data for Name: geos; Type: TABLE DATA; Schema: public; Owner: foodgenome
--

COPY geos (id, lat, lon, "user", created_at) FROM stdin;
\.


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: foodgenome
--

COPY notes (id, "type", uuid, title, link, description, tagstring, depiction, "location", lat, lon, radius, begins, ends, permissions, kind, created_at, updated_at, owner_id, "login", email, firstname, lastname, crypted_password, salt, remember_token, remember_token_expires_at, provenance) FROM stdin;
1	User	twitter25801810	snittbiggler	\N		\N	\N		0	0	1	\N	\N	0	user	2009-03-22 03:08:06	2009-03-22 03:08:06	\N	twitter25801810	unknown@unknown.com			81ad53b6b77e74f077e0fa3966d847b5e6c9175d	cfbb3ca2ede9be477bf4ff02eca4f06594d42ecd	\N	\N	\N
5	User	twitter812567	anselm	\N	ruler of the unknown world	\N	\N	San Carlos de Bariloche, R&#237;o N	0	0	1	\N	\N	0	user	2009-03-22 03:08:06	2009-03-22 03:08:06	\N	twitter812567	unknown@unknown.com			65ecb3fc04c9182dbea8afa104d5753e0a59baf2	97af5a9bf2ed65f4d6c76df7abc02e7d981dc62a	\N	\N	\N
17	User	twitter1109551	paigedestroy	\N	IXD, UX, Strategy. ART//LOVE	\N	\N	the peoples republic of portla	0	0	1	\N	\N	0	user	2009-03-22 03:08:06	2009-03-22 03:08:06	\N	twitter1109551	unknown@unknown.com			669c0680e6b0d25fceec4359382567ca522e01e8	095c12768188b48a8fefe737822be7ade7bb4402	\N	\N	\N
20	Post	twitter_1367228958	 #love avocado	\N	\N	\N	\N	\N	0	0	1	\N	\N	0	post	2009-03-22 03:08:06	2009-03-22 03:08:06	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
2	Post	twitter_1369866812	 HELLO	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:08	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	Post	twitter_1369863236	 parsnip, thyme, garlic	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:09	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
4	Post	twitter_1369857352	 lemon, marmalade	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:09	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
6	Post	twitter_1369838760	 chicken, carrots, potato, onion	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
7	Post	twitter_1369836701	 bacon	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:11	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
8	Post	twitter_1369831440	 honey, mustard, pistachio	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:11	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
9	Post	twitter_1369824867	 chocolate, squash, daisy	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:12	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
10	Post	twitter_1369799536	 lime, coconut, salt, rum	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:12	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
11	Post	twitter_1369791302	 paprika	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:13	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
12	Post	twitter_1369779946	 butter	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:14	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
13	Post	twitter_1369774700	 dragonfruit, rum, pepper	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:14	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
14	Post	twitter_1369772843	 watermelon, lemon, eggplant	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:15	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
15	Post	twitter_1369768439	 bacon	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
16	Post	twitter_1369742337	 avocado	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
18	Post	twitter_1367591480	 I can't write you cause you're not following me.	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:17	17	\N	\N	\N	\N	\N	\N	\N	\N	\N
19	Post	twitter_1367582214	 how's it going? You are being built as I speak, does it hurt?	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:08:17	17	\N	\N	\N	\N	\N	\N	\N	\N	\N
21	Post	twitter_1312668089	 I LOVE YOU I FUCKING FUCKING LOVE YOU	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:08:06	2009-03-22 03:10:55	17	\N	\N	\N	\N	\N	\N	\N	\N	\N
22	Post	twitter_1369893193	 beets, ants, lemon	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:15:01	2009-03-22 03:15:02	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
23	User	twitter311893	reidab	\N	Designer, developer, photographer, type nut, and generally nice guy. Fights for truth, justice, and web standards.	\N	\N	Portland,OR	0	0	1	\N	\N	0	user	2009-03-22 03:21:00	2009-03-22 03:21:00	\N	twitter311893	unknown@unknown.com			70219be399d1b69217c83313f9ef9655da2d8987	85f97db1a4dc5dc220328265de5f98297232160a	\N	\N	\N
24	Post	twitter_1369902371	 eggs, sausage	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 03:21:00	2009-03-22 03:21:01	23	\N	\N	\N	\N	\N	\N	\N	\N	\N
25	Post	twitter_1373179247	 cilantro , basil, pepper	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 18:36:00	2009-03-22 18:36:01	5	\N	\N	\N	\N	\N	\N	\N	\N	\N
26	User	twitter8247922	edbice	\N	proximity globalization and the war on imagination	\N	\N	iPhone: 39.953644,-75.837036	0	0	1	\N	\N	0	user	2009-03-22 19:21:01	2009-03-22 19:21:01	\N	twitter8247922	unknown@unknown.com			5f28e981662b1ff6c9ab35145fbb39096bc8852d	675c122954ced78229ce48d826e089575c53e511	\N	\N	\N
27	Post	twitter_1373374691	 peas corn quinoa tortillas	\N	\N	\N	\N	\N	0	0	1	\N	\N	1	post	2009-03-22 19:21:01	2009-03-22 19:21:03	26	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: relations; Type: TABLE DATA; Schema: public; Owner: foodgenome
--

COPY relations (id, kind, value, created_at, updated_at, note_id, sibling_id) FROM stdin;
1	owner	1	2009-03-22 03:08:06	2009-03-22 03:08:06	2	\N
2	owner	1	2009-03-22 03:08:06	2009-03-22 03:08:06	3	\N
3	owner	1	2009-03-22 03:08:06	2009-03-22 03:08:06	4	\N
4	owner	5	2009-03-22 03:08:06	2009-03-22 03:08:06	6	\N
5	owner	5	2009-03-22 03:08:06	2009-03-22 03:08:06	7	\N
6	owner	5	2009-03-22 03:08:06	2009-03-22 03:08:06	8	\N
7	owner	5	2009-03-22 03:08:06	2009-03-22 03:08:06	9	\N
8	owner	5	2009-03-22 03:08:06	2009-03-22 03:08:06	10	\N
9	owner	5	2009-03-22 03:08:06	2009-03-22 03:08:06	11	\N
10	owner	5	2009-03-22 03:08:06	2009-03-22 03:08:06	12	\N
11	owner	5	2009-03-22 03:08:06	2009-03-22 03:08:06	13	\N
12	owner	5	2009-03-22 03:08:06	2009-03-22 03:08:06	14	\N
13	owner	5	2009-03-22 03:08:06	2009-03-22 03:08:06	15	\N
14	owner	5	2009-03-22 03:08:06	2009-03-22 03:08:06	16	\N
15	owner	17	2009-03-22 03:08:06	2009-03-22 03:08:06	18	\N
16	owner	17	2009-03-22 03:08:06	2009-03-22 03:08:06	19	\N
17	owner	5	2009-03-22 03:08:06	2009-03-22 03:08:06	20	\N
18	tag	love	2009-03-22 03:08:06	2009-03-22 03:08:06	20	\N
19	owner	17	2009-03-22 03:08:06	2009-03-22 03:08:06	21	\N
20	owner	5	2009-03-22 03:15:01	2009-03-22 03:15:01	22	\N
21	owner	23	2009-03-22 03:21:00	2009-03-22 03:21:00	24	\N
22	owner	5	2009-03-22 18:36:00	2009-03-22 18:36:00	25	\N
23	owner	26	2009-03-22 19:21:01	2009-03-22 19:21:01	27	\N
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: foodgenome
--

COPY sessions (session_id, data, created_at) FROM stdin;
\.


--
-- Name: geos_pkey; Type: CONSTRAINT; Schema: public; Owner: foodgenome; Tablespace: 
--

ALTER TABLE ONLY geos
    ADD CONSTRAINT geos_pkey PRIMARY KEY (id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: foodgenome; Tablespace: 
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: relations_pkey; Type: CONSTRAINT; Schema: public; Owner: foodgenome; Tablespace: 
--

ALTER TABLE ONLY relations
    ADD CONSTRAINT relations_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: foodgenome; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (session_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: pgsql
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM pgsql;
GRANT ALL ON SCHEMA public TO pgsql;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

