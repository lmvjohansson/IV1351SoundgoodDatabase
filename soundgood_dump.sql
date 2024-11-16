--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

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

--
-- Name: check_lease_limit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_lease_limit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    lease_limit INT := 2;
BEGIN
    IF (
        SELECT COUNT(*)
        FROM lease
        WHERE person_id = NEW.person_id
          AND expiration_date >= CURRENT_DATE
    ) >= lease_limit THEN
        RAISE EXCEPTION 'Person with ID % already has the maximum allowed number of active leases (%)', NEW.person_id, lease_limit;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_lease_limit() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: contact_person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_person (
    person_id integer NOT NULL,
    name character varying(500) NOT NULL,
    relationship character varying(500) NOT NULL,
    phone character varying(500) NOT NULL,
    email character varying(500)
);


ALTER TABLE public.contact_person OWNER TO postgres;

--
-- Name: ensemble; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ensemble (
    ensemble_id integer NOT NULL,
    genre character varying(500) NOT NULL,
    min_participants integer NOT NULL,
    max_participants integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    pricing_scheme_id integer NOT NULL
);


ALTER TABLE public.ensemble OWNER TO postgres;

--
-- Name: ensemble_ensemble_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ensemble ALTER COLUMN ensemble_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ensemble_ensemble_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: group_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_lesson (
    group_lesson_id integer NOT NULL,
    min_participants integer NOT NULL,
    max_participants integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    pricing_scheme_id integer NOT NULL,
    instrument_level_id integer DEFAULT 1 NOT NULL,
    instrument_type_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.group_lesson OWNER TO postgres;

--
-- Name: group_lesson_group_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.group_lesson ALTER COLUMN group_lesson_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.group_lesson_group_lesson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: individual_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.individual_lesson (
    individual_lesson_id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    pricing_scheme_id integer NOT NULL,
    instrument_level_id integer DEFAULT 1 NOT NULL,
    instrument_type_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.individual_lesson OWNER TO postgres;

--
-- Name: individual_lesson_individual_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.individual_lesson ALTER COLUMN individual_lesson_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.individual_lesson_individual_lesson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instructor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor (
    instructor_id integer NOT NULL,
    can_teach_ensemble bit(1) NOT NULL,
    person_id integer NOT NULL
);


ALTER TABLE public.instructor OWNER TO postgres;

--
-- Name: instructor_availability; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor_availability (
    instructor_availability_id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    instructor_id integer NOT NULL
);


ALTER TABLE public.instructor_availability OWNER TO postgres;

--
-- Name: instructor_availability_instructor_availability_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.instructor_availability ALTER COLUMN instructor_availability_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instructor_availability_instructor_availability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instructor_instructor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.instructor ALTER COLUMN instructor_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instructor_instructor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument (
    instrument_id integer NOT NULL,
    instrument_type_id integer DEFAULT 1 NOT NULL,
    instrument_level_id integer DEFAULT 1 NOT NULL,
    person_id integer NOT NULL
);


ALTER TABLE public.instrument OWNER TO postgres;

--
-- Name: instrument_instrument_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.instrument ALTER COLUMN instrument_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instrument_instrument_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instrument_inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument_inventory (
    instrument_inventory_id integer NOT NULL,
    brand character varying(500),
    price numeric(10,2) NOT NULL,
    instrument_type_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.instrument_inventory OWNER TO postgres;

--
-- Name: instrument_inventory_instrument_inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.instrument_inventory ALTER COLUMN instrument_inventory_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instrument_inventory_instrument_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instrument_level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument_level (
    instrument_level_id integer NOT NULL,
    instrument_level character varying(500) NOT NULL
);


ALTER TABLE public.instrument_level OWNER TO postgres;

--
-- Name: instrument_level_instrument_level_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.instrument_level ALTER COLUMN instrument_level_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instrument_level_instrument_level_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instrument_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument_type (
    instrument_type_id integer NOT NULL,
    instrument_type character varying(500) NOT NULL
);


ALTER TABLE public.instrument_type OWNER TO postgres;

--
-- Name: instrument_type_instrument_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.instrument_type ALTER COLUMN instrument_type_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instrument_type_instrument_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: lease; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lease (
    person_id integer NOT NULL,
    instrument_inventory_id integer NOT NULL,
    expiration_date date NOT NULL,
    delivery_address character varying(500) NOT NULL
);


ALTER TABLE public.lease OWNER TO postgres;

--
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    person_id integer NOT NULL,
    person_number character varying(13) NOT NULL,
    name character varying(500) NOT NULL,
    address character varying(500) NOT NULL,
    phone character varying(500) NOT NULL,
    email character varying(500)
);


ALTER TABLE public.person OWNER TO postgres;

--
-- Name: person_ensemble; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_ensemble (
    person_id integer NOT NULL,
    ensemble_id integer NOT NULL
);


ALTER TABLE public.person_ensemble OWNER TO postgres;

--
-- Name: person_group_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_group_lesson (
    person_id integer NOT NULL,
    group_lesson_id integer NOT NULL
);


ALTER TABLE public.person_group_lesson OWNER TO postgres;

--
-- Name: person_individual_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_individual_lesson (
    person_id integer NOT NULL,
    individual_lesson_id integer NOT NULL
);


ALTER TABLE public.person_individual_lesson OWNER TO postgres;

--
-- Name: person_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.person ALTER COLUMN person_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.person_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: person_sibling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_sibling (
    person_id integer NOT NULL,
    sibling_id integer NOT NULL
);


ALTER TABLE public.person_sibling OWNER TO postgres;

--
-- Name: pricing_scheme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pricing_scheme (
    pricing_scheme_id integer NOT NULL,
    price numeric(10,2) NOT NULL,
    pay numeric(10,2) NOT NULL,
    price_valid_from timestamp without time zone NOT NULL,
    type_of_lesson_id integer DEFAULT 1 NOT NULL,
    instrument_level_id integer DEFAULT 1
);


ALTER TABLE public.pricing_scheme OWNER TO postgres;

--
-- Name: pricing_scheme_pricing_scheme_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pricing_scheme ALTER COLUMN pricing_scheme_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pricing_scheme_pricing_scheme_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: type_of_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type_of_lesson (
    type_of_lesson_id integer NOT NULL,
    type_of_lesson character varying(500) NOT NULL
);


ALTER TABLE public.type_of_lesson OWNER TO postgres;

--
-- Name: type_of_lesson_type_of_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.type_of_lesson ALTER COLUMN type_of_lesson_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.type_of_lesson_type_of_lesson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: contact_person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_person (person_id, name, relationship, phone, email) FROM stdin;
155	Emma Andersson	Mother	0723456789	emma.andersson@gmail.com
157	Peter Johansson	Father	0734567892	peter.johansson@gmail.com
158	Sofia Eriksson	Mother	0745678903	sofia.eriksson@gmail.com
161	Magnus Svensson	Father	0778901236	magnus.svensson@gmail.com
165	Christina Larsson	Mother	0712345681	christina.larsson@gmail.com
168	Anders Karlsson	Father	0745678904	anders.karlsson@gmail.com
171	Maria Andersson	Mother	0778901237	maria.andersson@gmail.com
172	Thomas Nilsson	Father	0789012348	thomas.nilsson@gmail.com
175	Karin Larsson	Mother	0712345682	karin.larsson@gmail.com
178	Robert Karlsson	Father	0745678905	robert.karlsson@gmail.com
179	Linda Persson	Mother	0756789016	linda.persson@gmail.com
186	Johan Svensson	Father	0723456784	johan.svensson@gmail.com
190	Lars Andersson	Father	0767890128	lars.andersson@gmail.com
194	Erik Larsson	Father	0701234572	erik.larsson@gmail.com
198	Anna Persson	Mother	0745678907	anna.persson@gmail.com
\.


--
-- Data for Name: ensemble; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ensemble (ensemble_id, genre, min_participants, max_participants, start_time, end_time, pricing_scheme_id) FROM stdin;
1	Jazz Band	5	25	2024-11-18 15:30:00	2024-11-18 17:00:00	20
2	Classical Orchestra	8	30	2024-11-19 15:30:00	2024-11-19 17:00:00	20
3	Rock Band	3	20	2024-11-20 15:30:00	2024-11-20 17:00:00	20
4	Chamber Music	4	22	2024-11-21 15:30:00	2024-11-21 17:00:00	20
5	String Orchestra	6	28	2024-11-22 15:30:00	2024-11-22 17:00:00	20
6	Brass Band	6	25	2024-12-02 15:30:00	2024-12-02 17:00:00	20
7	Folk Ensemble	4	20	2024-12-09 15:30:00	2024-12-09 17:00:00	20
8	Wind Orchestra	7	30	2024-12-16 15:30:00	2024-12-16 17:00:00	20
9	Jazz Combo	3	20	2025-01-13 15:30:00	2025-01-13 17:00:00	20
10	String Quartet	4	20	2025-01-14 15:30:00	2025-01-14 17:00:00	20
11	Contemporary Ensemble	5	25	2025-01-20 15:30:00	2025-01-20 17:00:00	20
12	World Music Ensemble	6	28	2025-01-27 15:30:00	2025-01-27 17:00:00	20
13	Chamber Orchestra	8	30	2025-02-03 15:30:00	2025-02-03 17:00:00	20
14	Pop Band	3	20	2025-02-10 15:30:00	2025-02-10 17:00:00	20
15	Percussion Ensemble	5	25	2025-02-17 15:30:00	2025-02-17 17:00:00	20
16	Jazz Band	5	25	2023-12-04 15:30:00	2023-12-04 17:00:00	19
17	Classical Orchestra	8	30	2023-12-11 15:30:00	2023-12-11 17:00:00	19
18	Rock Band	4	20	2023-12-18 15:30:00	2023-12-18 17:00:00	19
19	String Ensemble	6	28	2024-01-08 15:30:00	2024-01-08 17:00:00	19
20	Wind Orchestra	7	30	2024-01-15 15:30:00	2024-01-15 17:00:00	19
21	Brass Band	5	25	2024-01-22 15:30:00	2024-01-22 17:00:00	19
22	Chamber Orchestra	6	24	2024-01-29 15:30:00	2024-01-29 17:00:00	19
23	Folk Ensemble	4	20	2024-02-05 15:30:00	2024-02-05 17:00:00	19
24	Contemporary Jazz	5	22	2024-02-12 15:30:00	2024-02-12 17:00:00	19
25	String Quartet+	4	20	2024-02-19 15:30:00	2024-02-19 17:00:00	19
26	Percussion Ensemble	5	25	2024-02-26 15:30:00	2024-02-26 17:00:00	19
27	Symphony Orchestra	8	30	2024-03-04 15:30:00	2024-03-04 17:00:00	19
28	Blues Band	4	20	2024-03-11 15:30:00	2024-03-11 17:00:00	19
29	Chamber Music	5	22	2024-03-18 15:30:00	2024-03-18 17:00:00	19
30	World Music	6	28	2024-03-25 15:30:00	2024-03-25 17:00:00	19
31	Jazz Orchestra	7	30	2024-04-01 15:30:00	2024-04-01 17:00:00	19
32	Rock Orchestra	6	25	2024-04-08 15:30:00	2024-04-08 17:00:00	19
33	String Orchestra	5	24	2024-04-15 15:30:00	2024-04-15 17:00:00	19
34	Wind Band	6	26	2024-04-22 15:30:00	2024-04-22 17:00:00	19
35	Brass Ensemble	5	20	2024-04-29 15:30:00	2024-04-29 17:00:00	19
36	Chamber Choir	8	30	2024-05-06 15:30:00	2024-05-06 17:00:00	19
37	Folk Orchestra	6	28	2024-05-13 15:30:00	2024-05-13 17:00:00	19
38	Jazz Combo	3	20	2024-05-20 15:30:00	2024-05-20 17:00:00	19
39	String Collective	5	25	2024-05-27 15:30:00	2024-05-27 17:00:00	19
40	Symphonic Band	7	30	2024-09-02 15:30:00	2024-09-02 17:00:00	19
41	Latin Ensemble	4	20	2024-09-09 15:30:00	2024-09-09 17:00:00	19
42	Chamber Strings	5	22	2024-09-16 15:30:00	2024-09-16 17:00:00	19
43	Big Band	8	30	2024-09-23 15:30:00	2024-09-23 17:00:00	19
44	Rock Ensemble	4	20	2024-09-30 15:30:00	2024-09-30 17:00:00	19
45	World Orchestra	6	28	2024-10-07 15:30:00	2024-10-07 17:00:00	19
46	Jazz Band	5	25	2024-10-14 15:30:00	2024-10-14 17:00:00	19
47	Classical Quartet+	4	20	2024-10-21 15:30:00	2024-10-21 17:00:00	19
48	Pop Orchestra	6	26	2024-10-28 15:30:00	2024-10-28 17:00:00	19
49	Wind Ensemble	5	24	2024-11-04 15:30:00	2024-11-04 17:00:00	19
50	Blues Orchestra	7	30	2024-11-11 15:30:00	2024-11-11 17:00:00	19
51	Chamber Winds	5	22	2024-11-18 15:30:00	2024-11-18 17:00:00	19
52	Folk Strings	4	20	2024-11-25 15:30:00	2024-11-25 17:00:00	19
53	Percussion Orchestra	6	25	2024-11-26 15:30:00	2024-11-26 17:00:00	19
54	Jazz Orchestra	7	30	2024-11-27 15:30:00	2024-11-27 17:00:00	19
55	Rock Collective	5	24	2024-11-28 15:30:00	2024-11-28 17:00:00	19
\.


--
-- Data for Name: group_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_lesson (group_lesson_id, min_participants, max_participants, start_time, end_time, pricing_scheme_id, instrument_level_id, instrument_type_id) FROM stdin;
1	3	8	2024-11-19 13:00:00	2024-11-19 14:30:00	13	3	2
2	3	8	2024-11-21 10:00:00	2024-11-21 11:30:00	12	2	3
3	3	8	2024-11-26 14:00:00	2024-11-26 15:30:00	13	3	4
4	3	8	2024-11-28 11:00:00	2024-11-28 12:30:00	12	2	5
5	3	8	2024-12-03 13:00:00	2024-12-03 14:30:00	13	3	6
6	3	8	2024-12-05 10:00:00	2024-12-05 11:30:00	12	2	7
7	3	8	2024-12-10 14:00:00	2024-12-10 15:30:00	13	3	8
8	3	8	2024-12-12 11:00:00	2024-12-12 12:30:00	12	2	9
9	3	8	2025-01-14 13:00:00	2025-01-14 14:30:00	13	3	10
10	3	8	2025-01-16 10:00:00	2025-01-16 11:30:00	12	2	11
11	3	8	2025-01-21 14:00:00	2025-01-21 15:30:00	13	3	12
12	3	8	2025-02-04 13:00:00	2025-02-04 14:30:00	12	2	2
13	3	8	2025-02-06 10:00:00	2025-02-06 11:30:00	13	3	3
14	3	8	2025-02-11 14:00:00	2025-02-11 15:30:00	12	2	4
15	3	8	2025-02-13 11:00:00	2025-02-13 12:30:00	13	3	5
16	3	8	2023-12-04 13:00:00	2023-12-04 14:30:00	3	2	2
17	3	8	2023-12-11 10:00:00	2023-12-11 11:30:00	4	3	3
18	3	8	2023-12-18 14:00:00	2023-12-18 15:30:00	3	2	4
19	3	8	2024-01-08 11:00:00	2024-01-08 12:30:00	4	3	5
20	3	8	2024-01-15 13:00:00	2024-01-15 14:30:00	3	2	6
21	3	8	2024-01-22 10:00:00	2024-01-22 11:30:00	4	3	7
22	3	8	2024-01-29 14:00:00	2024-01-29 15:30:00	3	2	8
23	3	8	2024-02-05 11:00:00	2024-02-05 12:30:00	4	3	9
24	3	8	2024-02-12 13:00:00	2024-02-12 14:30:00	3	2	10
25	3	8	2024-02-19 10:00:00	2024-02-19 11:30:00	4	3	11
26	3	8	2024-03-04 14:00:00	2024-03-04 15:30:00	3	2	2
27	3	8	2024-03-11 11:00:00	2024-03-11 12:30:00	4	3	3
28	3	8	2024-03-18 13:00:00	2024-03-18 14:30:00	3	2	4
29	3	8	2024-03-25 10:00:00	2024-03-25 11:30:00	4	3	5
30	3	8	2024-04-01 14:00:00	2024-04-01 15:30:00	3	2	6
31	3	8	2024-04-08 11:00:00	2024-04-08 12:30:00	4	3	7
32	3	8	2024-04-15 13:00:00	2024-04-15 14:30:00	3	2	8
33	3	8	2024-04-22 10:00:00	2024-04-22 11:30:00	4	3	9
34	3	8	2024-05-06 14:00:00	2024-05-06 15:30:00	3	2	10
35	3	8	2024-05-13 11:00:00	2024-05-13 12:30:00	4	3	11
36	3	8	2024-09-02 13:00:00	2024-09-02 14:30:00	3	2	2
37	3	8	2024-09-09 10:00:00	2024-09-09 11:30:00	4	3	3
38	3	8	2024-09-16 14:00:00	2024-09-16 15:30:00	3	2	4
39	3	8	2024-09-23 11:00:00	2024-09-23 12:30:00	4	3	5
40	3	8	2024-09-30 13:00:00	2024-09-30 14:30:00	3	2	6
41	3	8	2024-10-07 10:00:00	2024-10-07 11:30:00	4	3	7
42	3	8	2024-10-14 14:00:00	2024-10-14 15:30:00	3	2	8
43	3	8	2024-10-21 11:00:00	2024-10-21 12:30:00	4	3	9
44	3	8	2024-10-28 13:00:00	2024-10-28 14:30:00	3	2	10
45	3	8	2024-11-04 10:00:00	2024-11-04 11:30:00	4	3	11
\.


--
-- Data for Name: individual_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.individual_lesson (individual_lesson_id, start_time, end_time, pricing_scheme_id, instrument_level_id, instrument_type_id) FROM stdin;
1	2024-11-18 09:00:00	2024-11-18 10:00:00	10	2	2
2	2024-11-18 10:00:00	2024-11-18 11:00:00	11	3	3
3	2024-11-18 13:00:00	2024-11-18 14:00:00	16	4	4
4	2024-11-19 09:00:00	2024-11-19 10:00:00	10	2	5
5	2024-11-19 10:00:00	2024-11-19 11:00:00	11	3	6
6	2024-11-19 13:00:00	2024-11-19 14:00:00	16	4	7
7	2024-11-20 09:00:00	2024-11-20 10:00:00	10	2	8
8	2024-11-20 10:00:00	2024-11-20 11:00:00	11	3	9
9	2024-11-20 13:00:00	2024-11-20 14:00:00	16	4	10
10	2024-11-21 09:00:00	2024-11-21 10:00:00	10	2	11
11	2024-12-02 09:00:00	2024-12-02 10:00:00	10	2	2
12	2024-12-02 10:00:00	2024-12-02 11:00:00	11	3	3
13	2024-12-02 13:00:00	2024-12-02 14:00:00	16	4	4
14	2024-12-03 09:00:00	2024-12-03 10:00:00	10	2	5
15	2024-12-03 10:00:00	2024-12-03 11:00:00	11	3	6
16	2024-12-03 13:00:00	2024-12-03 14:00:00	16	4	7
17	2024-12-04 09:00:00	2024-12-04 10:00:00	10	2	8
18	2024-12-04 10:00:00	2024-12-04 11:00:00	11	3	9
19	2024-12-04 13:00:00	2024-12-04 14:00:00	16	4	10
20	2024-12-05 09:00:00	2024-12-05 10:00:00	10	2	11
21	2025-01-13 09:00:00	2025-01-13 10:00:00	10	2	2
22	2025-01-13 10:00:00	2025-01-13 11:00:00	11	3	3
23	2025-01-13 13:00:00	2025-01-13 14:00:00	16	4	4
24	2025-01-14 09:00:00	2025-01-14 10:00:00	10	2	5
25	2025-01-14 10:00:00	2025-01-14 11:00:00	11	3	6
26	2025-01-14 13:00:00	2025-01-14 14:00:00	16	4	7
27	2025-02-03 09:00:00	2025-02-03 10:00:00	10	2	8
28	2025-02-03 10:00:00	2025-02-03 11:00:00	11	3	9
29	2025-02-03 13:00:00	2025-02-03 14:00:00	16	4	10
30	2025-02-04 09:00:00	2025-02-04 10:00:00	10	2	11
31	2023-12-04 09:00:00	2023-12-04 10:00:00	1	2	2
32	2023-12-04 10:00:00	2023-12-04 11:00:00	2	3	3
33	2023-12-04 13:00:00	2023-12-04 14:00:00	7	4	4
34	2023-12-05 09:00:00	2023-12-05 10:00:00	1	2	5
35	2023-12-05 10:00:00	2023-12-05 11:00:00	2	3	6
36	2023-12-11 13:00:00	2023-12-11 14:00:00	7	4	7
37	2023-12-11 09:00:00	2023-12-11 10:00:00	1	2	8
38	2023-12-12 10:00:00	2023-12-12 11:00:00	2	3	9
39	2023-12-12 13:00:00	2023-12-12 14:00:00	7	4	10
40	2023-12-18 09:00:00	2023-12-18 10:00:00	1	2	11
41	2024-01-08 09:00:00	2024-01-08 10:00:00	1	2	2
42	2024-01-08 10:00:00	2024-01-08 11:00:00	2	3	3
43	2024-01-09 13:00:00	2024-01-09 14:00:00	7	4	4
44	2024-01-15 09:00:00	2024-01-15 10:00:00	1	2	5
45	2024-01-15 10:00:00	2024-01-15 11:00:00	2	3	6
46	2024-01-16 13:00:00	2024-01-16 14:00:00	7	4	7
47	2024-01-22 09:00:00	2024-01-22 10:00:00	1	2	8
48	2024-01-22 10:00:00	2024-01-22 11:00:00	2	3	9
49	2024-02-05 13:00:00	2024-02-05 14:00:00	7	4	10
50	2024-02-05 09:00:00	2024-02-05 10:00:00	1	2	11
51	2024-02-06 09:00:00	2024-02-06 10:00:00	1	2	2
52	2024-02-12 10:00:00	2024-02-12 11:00:00	2	3	3
53	2024-02-12 13:00:00	2024-02-12 14:00:00	7	4	4
54	2024-02-13 09:00:00	2024-02-13 10:00:00	1	2	5
55	2024-02-19 10:00:00	2024-02-19 11:00:00	2	3	6
56	2024-03-04 13:00:00	2024-03-04 14:00:00	7	4	7
57	2024-03-04 09:00:00	2024-03-04 10:00:00	1	2	8
58	2024-03-05 10:00:00	2024-03-05 11:00:00	2	3	9
59	2024-03-11 13:00:00	2024-03-11 14:00:00	7	4	10
60	2024-03-11 09:00:00	2024-03-11 10:00:00	1	2	11
61	2024-04-01 09:00:00	2024-04-01 10:00:00	1	2	2
62	2024-04-01 10:00:00	2024-04-01 11:00:00	2	3	3
63	2024-04-02 13:00:00	2024-04-02 14:00:00	7	4	4
64	2024-04-08 09:00:00	2024-04-08 10:00:00	1	2	5
65	2024-04-08 10:00:00	2024-04-08 11:00:00	2	3	6
66	2024-05-06 13:00:00	2024-05-06 14:00:00	7	4	7
67	2024-05-06 09:00:00	2024-05-06 10:00:00	1	2	8
68	2024-05-07 10:00:00	2024-05-07 11:00:00	2	3	9
69	2024-05-13 13:00:00	2024-05-13 14:00:00	7	4	10
70	2024-05-13 09:00:00	2024-05-13 10:00:00	1	2	11
71	2024-09-02 09:00:00	2024-09-02 10:00:00	1	2	2
72	2024-09-02 10:00:00	2024-09-02 11:00:00	2	3	3
73	2024-09-03 13:00:00	2024-09-03 14:00:00	7	4	4
74	2024-09-09 09:00:00	2024-09-09 10:00:00	1	2	5
75	2024-09-09 10:00:00	2024-09-09 11:00:00	2	3	6
76	2024-10-07 13:00:00	2024-10-07 14:00:00	7	4	7
77	2024-10-07 09:00:00	2024-10-07 10:00:00	1	2	8
78	2024-10-08 10:00:00	2024-10-08 11:00:00	2	3	9
79	2024-10-14 13:00:00	2024-10-14 14:00:00	7	4	10
80	2024-10-14 09:00:00	2024-10-14 10:00:00	1	2	11
\.


--
-- Data for Name: instructor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instructor (instructor_id, can_teach_ensemble, person_id) FROM stdin;
1	1	101
2	1	102
3	1	103
4	0	104
5	0	105
6	1	106
7	1	107
8	1	108
9	0	109
10	1	110
11	1	111
12	0	112
13	0	113
14	1	114
15	1	115
16	1	116
17	1	117
18	0	118
19	1	119
20	0	120
\.


--
-- Data for Name: instructor_availability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instructor_availability (instructor_availability_id, start_time, end_time, instructor_id) FROM stdin;
22	2024-11-18 08:00:00	2024-11-18 17:00:00	1
23	2024-11-19 08:00:00	2024-11-19 17:00:00	1
24	2024-11-20 08:00:00	2024-11-20 17:00:00	1
25	2024-11-21 08:00:00	2024-11-21 17:00:00	1
26	2024-11-22 08:00:00	2024-11-22 17:00:00	1
27	2024-11-25 08:00:00	2024-11-25 17:00:00	1
28	2024-11-26 08:00:00	2024-11-26 17:00:00	1
29	2024-11-27 08:00:00	2024-11-27 17:00:00	1
30	2024-11-28 08:00:00	2024-11-28 17:00:00	1
31	2024-11-29 08:00:00	2024-11-29 17:00:00	1
32	2024-12-02 08:00:00	2024-12-02 17:00:00	1
33	2024-12-03 08:00:00	2024-12-03 17:00:00	1
34	2024-12-04 08:00:00	2024-12-04 17:00:00	1
35	2024-12-05 08:00:00	2024-12-05 17:00:00	1
36	2024-12-06 08:00:00	2024-12-06 17:00:00	1
37	2024-12-09 08:00:00	2024-12-09 17:00:00	1
38	2024-12-10 08:00:00	2024-12-10 17:00:00	1
39	2024-12-11 08:00:00	2024-12-11 17:00:00	1
40	2024-12-12 08:00:00	2024-12-12 17:00:00	1
41	2024-12-13 08:00:00	2024-12-13 17:00:00	1
42	2024-12-16 08:00:00	2024-12-16 17:00:00	1
43	2024-11-18 08:00:00	2024-11-18 17:00:00	2
44	2024-11-19 08:00:00	2024-11-19 17:00:00	2
45	2024-11-20 08:00:00	2024-11-20 17:00:00	2
46	2024-11-21 08:00:00	2024-11-21 17:00:00	2
47	2024-11-22 08:00:00	2024-11-22 17:00:00	2
48	2024-11-25 08:00:00	2024-11-25 17:00:00	2
49	2024-11-26 08:00:00	2024-11-26 17:00:00	2
50	2024-11-27 08:00:00	2024-11-27 17:00:00	2
51	2024-11-28 08:00:00	2024-11-28 17:00:00	2
52	2024-11-29 08:00:00	2024-11-29 17:00:00	2
53	2024-12-02 08:00:00	2024-12-02 17:00:00	2
54	2024-12-03 08:00:00	2024-12-03 17:00:00	2
55	2024-12-04 08:00:00	2024-12-04 17:00:00	2
56	2024-12-05 08:00:00	2024-12-05 17:00:00	2
57	2024-12-06 08:00:00	2024-12-06 17:00:00	2
58	2024-12-09 08:00:00	2024-12-09 17:00:00	2
59	2024-12-10 08:00:00	2024-12-10 17:00:00	2
60	2024-12-11 08:00:00	2024-12-11 17:00:00	2
61	2024-12-12 08:00:00	2024-12-12 17:00:00	2
62	2024-12-13 08:00:00	2024-12-13 17:00:00	2
63	2024-12-16 08:00:00	2024-12-16 17:00:00	2
64	2024-11-18 08:00:00	2024-11-18 17:00:00	3
65	2024-11-19 08:00:00	2024-11-19 17:00:00	3
66	2024-11-20 08:00:00	2024-11-20 17:00:00	3
67	2024-11-21 08:00:00	2024-11-21 17:00:00	3
68	2024-11-22 08:00:00	2024-11-22 17:00:00	3
69	2024-11-25 08:00:00	2024-11-25 17:00:00	3
70	2024-11-26 08:00:00	2024-11-26 17:00:00	3
71	2024-11-27 08:00:00	2024-11-27 17:00:00	3
72	2024-11-28 08:00:00	2024-11-28 17:00:00	4
73	2024-11-29 08:00:00	2024-11-29 17:00:00	4
74	2024-12-02 08:00:00	2024-12-02 17:00:00	4
75	2024-12-03 08:00:00	2024-12-03 17:00:00	4
76	2024-12-04 08:00:00	2024-12-04 17:00:00	4
77	2024-12-05 08:00:00	2024-12-05 17:00:00	4
78	2024-12-06 08:00:00	2024-12-06 17:00:00	4
79	2024-12-09 08:00:00	2024-12-09 17:00:00	4
80	2024-12-10 08:00:00	2024-12-10 17:00:00	4
81	2024-12-11 08:00:00	2024-12-11 17:00:00	4
82	2024-12-12 08:00:00	2024-12-12 17:00:00	4
83	2024-12-13 08:00:00	2024-12-13 17:00:00	4
84	2024-12-16 08:00:00	2024-12-16 17:00:00	4
85	2024-11-18 08:00:00	2024-11-18 17:00:00	5
86	2024-11-19 08:00:00	2024-11-19 17:00:00	5
87	2024-11-20 08:00:00	2024-11-20 17:00:00	5
88	2024-11-21 08:00:00	2024-11-21 17:00:00	5
89	2024-11-22 08:00:00	2024-11-22 17:00:00	5
90	2024-11-25 08:00:00	2024-11-25 17:00:00	5
91	2024-11-26 08:00:00	2024-11-26 17:00:00	5
92	2024-11-27 08:00:00	2024-11-27 17:00:00	5
93	2024-11-28 08:00:00	2024-11-28 17:00:00	5
94	2024-11-29 08:00:00	2024-11-29 17:00:00	5
95	2024-12-02 08:00:00	2024-12-02 17:00:00	5
96	2024-12-03 08:00:00	2024-12-03 17:00:00	5
97	2024-12-04 08:00:00	2024-12-04 17:00:00	6
98	2024-12-05 08:00:00	2024-12-05 17:00:00	6
99	2024-12-06 08:00:00	2024-12-06 17:00:00	6
100	2024-12-09 08:00:00	2024-12-09 17:00:00	6
101	2024-12-10 08:00:00	2024-12-10 17:00:00	6
102	2024-12-11 08:00:00	2024-12-11 17:00:00	6
103	2024-12-12 08:00:00	2024-12-12 17:00:00	6
104	2024-12-13 08:00:00	2024-12-13 17:00:00	6
105	2024-12-16 08:00:00	2024-12-16 17:00:00	6
106	2024-11-18 08:00:00	2024-11-18 17:00:00	7
107	2024-11-19 08:00:00	2024-11-19 17:00:00	8
108	2024-11-20 08:00:00	2024-11-20 17:00:00	7
109	2024-11-21 08:00:00	2024-11-21 17:00:00	8
110	2024-11-22 08:00:00	2024-11-22 17:00:00	7
111	2024-11-25 08:00:00	2024-11-25 17:00:00	8
112	2024-11-26 08:00:00	2024-11-26 17:00:00	7
113	2024-11-27 08:00:00	2024-11-27 17:00:00	8
114	2024-11-28 08:00:00	2024-11-28 17:00:00	7
115	2024-11-29 08:00:00	2024-11-29 17:00:00	8
116	2024-12-02 08:00:00	2024-12-02 17:00:00	7
117	2024-12-03 08:00:00	2024-12-03 17:00:00	8
118	2024-12-04 08:00:00	2024-12-04 17:00:00	7
119	2024-12-05 08:00:00	2024-12-05 17:00:00	8
120	2024-12-06 08:00:00	2024-12-06 17:00:00	7
121	2024-12-09 08:00:00	2024-12-09 17:00:00	8
122	2024-12-10 08:00:00	2024-12-10 17:00:00	7
123	2024-12-11 08:00:00	2024-12-11 17:00:00	8
124	2024-12-12 08:00:00	2024-12-12 17:00:00	7
125	2024-12-13 08:00:00	2024-12-13 17:00:00	8
126	2024-12-16 08:00:00	2024-12-16 17:00:00	7
127	2024-11-18 08:00:00	2024-11-18 17:00:00	9
128	2024-11-19 08:00:00	2024-11-19 17:00:00	9
129	2024-11-20 08:00:00	2024-11-20 17:00:00	9
130	2024-11-21 08:00:00	2024-11-21 17:00:00	9
131	2024-11-22 08:00:00	2024-11-22 17:00:00	9
132	2024-11-25 08:00:00	2024-11-25 17:00:00	9
133	2024-11-26 08:00:00	2024-11-26 17:00:00	9
134	2024-11-27 08:00:00	2024-11-27 17:00:00	9
135	2024-11-28 08:00:00	2024-11-28 17:00:00	9
136	2024-11-29 08:00:00	2024-11-29 17:00:00	9
137	2024-12-02 08:00:00	2024-12-02 17:00:00	9
138	2024-12-03 08:00:00	2024-12-03 17:00:00	9
139	2024-12-04 08:00:00	2024-12-04 17:00:00	9
140	2024-12-05 08:00:00	2024-12-05 17:00:00	9
141	2024-12-06 08:00:00	2024-12-06 17:00:00	9
142	2024-12-09 08:00:00	2024-12-09 17:00:00	9
143	2024-12-10 08:00:00	2024-12-10 17:00:00	9
144	2024-12-11 08:00:00	2024-12-11 17:00:00	9
145	2024-12-12 08:00:00	2024-12-12 17:00:00	9
146	2024-12-13 08:00:00	2024-12-13 17:00:00	9
147	2024-12-16 08:00:00	2024-12-16 17:00:00	9
148	2024-11-18 08:00:00	2024-11-18 17:00:00	10
149	2024-11-19 08:00:00	2024-11-19 17:00:00	10
150	2024-11-20 08:00:00	2024-11-20 17:00:00	10
151	2024-11-21 08:00:00	2024-11-21 17:00:00	10
152	2024-11-22 08:00:00	2024-11-22 17:00:00	10
153	2024-11-25 08:00:00	2024-11-25 17:00:00	10
154	2024-11-26 08:00:00	2024-11-26 17:00:00	10
155	2024-11-27 08:00:00	2024-11-27 17:00:00	10
156	2024-11-28 08:00:00	2024-11-28 17:00:00	10
157	2024-11-29 08:00:00	2024-11-29 17:00:00	10
158	2024-12-02 08:00:00	2024-12-02 17:00:00	10
159	2024-12-03 08:00:00	2024-12-03 17:00:00	10
160	2024-12-04 08:00:00	2024-12-04 17:00:00	10
161	2024-12-05 08:00:00	2024-12-05 17:00:00	10
162	2024-12-06 08:00:00	2024-12-06 17:00:00	10
163	2024-12-09 08:00:00	2024-12-09 17:00:00	11
164	2024-12-10 08:00:00	2024-12-10 17:00:00	11
165	2024-12-11 08:00:00	2024-12-11 17:00:00	11
166	2024-12-12 08:00:00	2024-12-12 17:00:00	11
167	2024-12-13 08:00:00	2024-12-13 17:00:00	11
168	2024-12-16 08:00:00	2024-12-16 17:00:00	11
169	2024-11-18 08:00:00	2024-11-18 17:00:00	12
170	2024-11-19 08:00:00	2024-11-19 17:00:00	13
171	2024-11-20 08:00:00	2024-11-20 17:00:00	12
172	2024-11-21 08:00:00	2024-11-21 17:00:00	13
173	2024-11-22 08:00:00	2024-11-22 17:00:00	12
174	2024-11-25 08:00:00	2024-11-25 17:00:00	13
175	2024-11-26 08:00:00	2024-11-26 17:00:00	12
176	2024-11-27 08:00:00	2024-11-27 17:00:00	13
177	2024-11-28 08:00:00	2024-11-28 17:00:00	12
178	2024-11-29 08:00:00	2024-11-29 17:00:00	13
179	2024-12-02 08:00:00	2024-12-02 17:00:00	12
180	2024-12-03 08:00:00	2024-12-03 17:00:00	13
181	2024-12-04 08:00:00	2024-12-04 17:00:00	12
182	2024-12-05 08:00:00	2024-12-05 17:00:00	13
183	2024-12-06 08:00:00	2024-12-06 17:00:00	12
184	2024-12-09 08:00:00	2024-12-09 17:00:00	13
185	2024-12-10 08:00:00	2024-12-10 17:00:00	12
186	2024-12-11 08:00:00	2024-12-11 17:00:00	13
187	2024-12-12 08:00:00	2024-12-12 17:00:00	12
188	2024-12-13 08:00:00	2024-12-13 17:00:00	13
189	2024-12-16 08:00:00	2024-12-16 17:00:00	12
190	2024-11-18 08:00:00	2024-11-18 17:00:00	14
191	2024-11-19 08:00:00	2024-11-19 17:00:00	14
192	2024-11-20 08:00:00	2024-11-20 17:00:00	14
193	2024-11-21 08:00:00	2024-11-21 17:00:00	14
194	2024-11-22 08:00:00	2024-11-22 17:00:00	14
195	2024-11-25 08:00:00	2024-11-25 17:00:00	14
196	2024-11-26 08:00:00	2024-11-26 17:00:00	14
197	2024-11-27 08:00:00	2024-11-27 17:00:00	14
198	2024-11-28 08:00:00	2024-11-28 17:00:00	14
199	2024-11-29 08:00:00	2024-11-29 17:00:00	14
200	2024-12-02 08:00:00	2024-12-02 17:00:00	14
201	2024-12-03 08:00:00	2024-12-03 17:00:00	14
202	2024-12-04 08:00:00	2024-12-04 17:00:00	14
203	2024-12-05 08:00:00	2024-12-05 17:00:00	14
204	2024-12-06 08:00:00	2024-12-06 17:00:00	14
205	2024-12-09 08:00:00	2024-12-09 17:00:00	14
206	2024-12-10 08:00:00	2024-12-10 17:00:00	14
207	2024-12-11 08:00:00	2024-12-11 17:00:00	14
208	2024-12-12 08:00:00	2024-12-12 17:00:00	14
209	2024-12-13 08:00:00	2024-12-13 17:00:00	14
210	2024-12-16 08:00:00	2024-12-16 17:00:00	14
211	2024-11-18 08:00:00	2024-11-18 17:00:00	15
212	2024-11-19 08:00:00	2024-11-19 17:00:00	15
213	2024-11-20 08:00:00	2024-11-20 17:00:00	15
214	2024-11-21 08:00:00	2024-11-21 17:00:00	15
215	2024-11-22 08:00:00	2024-11-22 17:00:00	15
216	2024-11-25 08:00:00	2024-11-25 17:00:00	15
217	2024-11-26 08:00:00	2024-11-26 17:00:00	15
218	2024-11-27 08:00:00	2024-11-27 17:00:00	15
219	2024-11-28 08:00:00	2024-11-28 17:00:00	15
220	2024-11-29 08:00:00	2024-11-29 17:00:00	15
221	2024-12-02 08:00:00	2024-12-02 17:00:00	15
222	2024-12-03 08:00:00	2024-12-03 17:00:00	15
223	2024-12-04 08:00:00	2024-12-04 17:00:00	15
224	2024-12-05 08:00:00	2024-12-05 17:00:00	15
225	2024-12-06 08:00:00	2024-12-06 17:00:00	15
226	2024-12-09 08:00:00	2024-12-09 17:00:00	15
227	2024-12-10 08:00:00	2024-12-10 17:00:00	15
228	2024-12-11 08:00:00	2024-12-11 17:00:00	15
229	2024-12-12 08:00:00	2024-12-12 17:00:00	15
230	2024-12-13 08:00:00	2024-12-13 17:00:00	15
231	2024-12-16 08:00:00	2024-12-16 17:00:00	15
232	2024-11-18 12:00:00	2024-11-18 17:00:00	16
233	2024-11-19 12:00:00	2024-11-19 17:00:00	16
234	2024-11-20 12:00:00	2024-11-20 17:00:00	16
235	2024-11-21 12:00:00	2024-11-21 17:00:00	16
236	2024-11-22 12:00:00	2024-11-22 17:00:00	16
237	2024-11-25 12:00:00	2024-11-25 17:00:00	16
238	2024-11-26 12:00:00	2024-11-26 17:00:00	16
239	2024-11-27 12:00:00	2024-11-27 17:00:00	16
240	2024-11-28 12:00:00	2024-11-28 17:00:00	16
241	2024-11-29 12:00:00	2024-11-29 17:00:00	16
242	2024-12-02 12:00:00	2024-12-02 17:00:00	16
243	2024-12-03 12:00:00	2024-12-03 17:00:00	17
244	2024-12-04 12:00:00	2024-12-04 17:00:00	17
245	2024-12-05 12:00:00	2024-12-05 17:00:00	17
246	2024-12-06 12:00:00	2024-12-06 17:00:00	17
247	2024-12-09 12:00:00	2024-12-09 17:00:00	17
248	2024-12-10 12:00:00	2024-12-10 17:00:00	17
249	2024-12-11 12:00:00	2024-12-11 17:00:00	17
250	2024-12-12 12:00:00	2024-12-12 17:00:00	17
251	2024-12-13 12:00:00	2024-12-13 17:00:00	17
252	2024-12-16 12:00:00	2024-12-16 17:00:00	17
253	2024-11-18 12:00:00	2024-11-18 17:00:00	18
254	2024-11-19 12:00:00	2024-11-19 17:00:00	18
255	2024-11-20 12:00:00	2024-11-20 17:00:00	18
256	2024-11-21 12:00:00	2024-11-21 17:00:00	18
257	2024-11-22 12:00:00	2024-11-22 17:00:00	18
258	2024-11-25 12:00:00	2024-11-25 17:00:00	18
259	2024-11-26 12:00:00	2024-11-26 17:00:00	18
260	2024-11-27 12:00:00	2024-11-27 17:00:00	18
261	2024-11-28 12:00:00	2024-11-28 17:00:00	18
262	2024-11-29 12:00:00	2024-11-29 17:00:00	18
263	2024-12-02 12:00:00	2024-12-02 17:00:00	18
264	2024-12-03 12:00:00	2024-12-03 17:00:00	18
265	2024-12-04 12:00:00	2024-12-04 17:00:00	18
266	2024-12-05 12:00:00	2024-12-05 17:00:00	18
267	2024-12-06 12:00:00	2024-12-06 17:00:00	18
268	2024-12-09 12:00:00	2024-12-09 17:00:00	18
269	2024-12-10 12:00:00	2024-12-10 17:00:00	18
270	2024-12-11 12:00:00	2024-12-11 17:00:00	18
271	2024-12-12 12:00:00	2024-12-12 17:00:00	18
272	2024-12-13 12:00:00	2024-12-13 17:00:00	18
273	2024-12-16 12:00:00	2024-12-16 17:00:00	18
274	2024-11-18 12:00:00	2024-11-18 17:00:00	19
275	2024-11-19 12:00:00	2024-11-19 17:00:00	19
276	2024-11-20 12:00:00	2024-11-20 17:00:00	19
277	2024-11-21 12:00:00	2024-11-21 17:00:00	19
278	2024-11-22 12:00:00	2024-11-22 17:00:00	19
279	2024-11-25 12:00:00	2024-11-25 17:00:00	19
280	2024-11-26 12:00:00	2024-11-26 17:00:00	19
281	2024-11-27 12:00:00	2024-11-27 17:00:00	19
282	2024-11-28 12:00:00	2024-11-28 17:00:00	19
283	2024-11-29 12:00:00	2024-11-29 17:00:00	19
284	2024-12-02 12:00:00	2024-12-02 17:00:00	19
285	2024-12-03 12:00:00	2024-12-03 17:00:00	19
286	2024-12-04 12:00:00	2024-12-04 17:00:00	20
287	2024-12-05 12:00:00	2024-12-05 17:00:00	20
288	2024-12-06 12:00:00	2024-12-06 17:00:00	20
289	2024-12-09 12:00:00	2024-12-09 17:00:00	20
290	2024-12-10 12:00:00	2024-12-10 17:00:00	20
291	2024-12-11 12:00:00	2024-12-11 17:00:00	20
292	2024-12-12 12:00:00	2024-12-12 17:00:00	20
293	2024-12-13 12:00:00	2024-12-13 17:00:00	20
294	2024-12-16 12:00:00	2024-12-16 17:00:00	20
\.


--
-- Data for Name: instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument (instrument_id, instrument_type_id, instrument_level_id, person_id) FROM stdin;
1	2	4	101
2	3	4	101
3	5	4	102
4	6	3	102
5	4	4	103
6	8	4	104
7	3	3	104
8	9	4	105
9	4	3	105
10	2	4	106
11	7	3	106
12	10	4	107
13	11	4	108
14	7	3	108
15	12	4	109
16	10	3	109
17	6	4	110
18	3	4	111
19	8	3	111
20	5	4	112
21	4	4	113
22	9	3	113
23	2	4	114
24	5	3	114
25	7	4	115
26	10	4	116
27	11	3	116
28	12	4	117
29	6	4	118
30	5	3	118
31	8	4	119
32	2	4	120
33	3	3	120
34	2	2	121
35	4	2	121
36	3	2	122
37	5	3	123
38	2	2	124
39	9	2	124
40	4	3	125
41	7	2	126
42	2	3	127
43	3	2	127
44	10	2	128
45	6	3	129
46	5	2	129
47	8	2	130
48	4	3	131
49	2	2	132
50	9	3	133
51	3	2	134
52	7	2	135
53	2	3	136
54	4	2	137
55	5	2	138
56	10	3	139
57	6	2	140
58	2	3	141
59	8	2	142
60	4	2	143
61	3	3	144
62	9	2	145
63	2	2	146
64	5	3	147
65	7	2	148
66	4	2	149
67	2	3	150
68	2	2	151
69	4	2	151
70	9	2	151
71	3	3	152
72	5	2	152
73	6	3	153
74	7	2	153
75	2	2	154
76	8	2	154
77	4	3	154
78	10	2	155
79	11	2	155
80	2	3	156
81	3	2	156
82	4	2	157
83	9	3	157
84	5	2	158
85	2	2	159
86	6	3	160
87	7	2	161
88	2	2	162
89	4	2	162
90	8	3	163
91	3	2	164
92	2	3	165
93	5	2	166
94	4	2	167
95	9	3	168
96	2	2	169
97	6	2	170
98	4	3	171
99	2	2	171
100	5	2	172
101	3	2	173
102	9	2	173
103	6	3	174
104	2	2	175
105	7	2	175
106	8	3	176
107	4	2	177
108	10	2	177
109	2	3	178
110	5	2	179
111	11	2	179
112	3	2	180
113	6	2	180
114	2	3	181
115	4	2	181
116	7	2	182
117	9	3	183
118	2	2	183
119	5	2	184
120	3	3	185
121	8	2	185
122	2	2	186
123	6	2	186
124	4	3	187
125	10	2	188
126	2	2	188
127	5	3	189
128	3	2	190
129	7	2	190
130	2	2	191
131	9	2	191
132	4	3	192
133	6	2	192
134	8	2	193
135	2	3	194
136	5	2	194
137	3	2	195
138	7	3	196
139	10	2	196
140	2	2	197
141	4	2	197
142	6	3	198
143	9	2	199
144	3	2	199
145	2	3	200
146	5	2	200
147	4	2	201
\.


--
-- Data for Name: instrument_inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument_inventory (instrument_inventory_id, brand, price, instrument_type_id) FROM stdin;
1	Yamaha	159.99	2
2	Roland	145.50	2
3	Steinway	199.99	2
4	Stradivarius	189.99	3
5	Mendini	129.99	3
6	Fender	179.99	4
7	Gibson	188.50	4
8	Ibanez	149.99	4
9	Pearl	167.50	9
10	Gemeinhardt	134.99	5
11	Armstrong	144.99	5
12	Buffet Crampon	178.99	6
13	Selmer	169.99	6
14	Bach	182.50	7
15	King	155.99	7
16	Cecilio	119.99	8
17	DW Drums	192.50	9
18	Tama	175.99	9
19	Jupiter	165.99	10
20	Yanagisawa	184.99	10
21	Conn	159.99	11
22	Getzen	147.50	11
23	Holton	177.99	12
24	Eastman	139.99	3
25	Martin	185.99	4
26	Yamaha	164.99	7
27	Pearl	172.50	9
28	Selmer	188.99	10
29	Bach	176.50	11
30	Conn-Selmer	193.99	12
\.


--
-- Data for Name: instrument_level; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument_level (instrument_level_id, instrument_level) FROM stdin;
1	Removed instrument level
2	Beginner
3	Intermediate
4	Advanced
\.


--
-- Data for Name: instrument_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument_type (instrument_type_id, instrument_type) FROM stdin;
1	Removed instrument type
2	Piano
3	Violin
4	Guitar
5	Flute
6	Clarinet
7	Trumpet
8	Cello
9	Drums
10	Saxophone
11	Trombone
12	French Horn
\.


--
-- Data for Name: lease; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lease (person_id, instrument_inventory_id, expiration_date, delivery_address) FROM stdin;
121	1	2024-12-15	Kungsgatan 25, 11456 Stockholm
122	5	2024-12-20	Drottninggatan 37, 75238 Uppsala
123	10	2024-11-30	Storgatan 19, 76291 Rimbo
124	2	2024-12-10	Vasagatan 51, 76164 Norrtalje
124	17	2024-12-10	Vasagatan 51, 76164 Norrtalje
125	6	2024-12-25	Birgersgatan 76, 72346 Vasteras
126	14	2024-11-25	Karlavagen 3, 70374 Orebro
127	2	2024-12-05	Sveavagen 59, 58273 Linkoping
128	19	2024-12-30	Gotgatan 31, 60223 Norrkoping
129	12	2024-12-15	Valhallavagen 88, 35234 Vaxjo
129	11	2024-12-15	Valhallavagen 88, 35234 Vaxjo
130	16	2024-12-20	Odengatan 42, 39231 Kalmar
131	8	2024-11-28	Kungsgatan 71, 11456 Stockholm
133	9	2024-12-22	Storgatan 47, 76291 Rimbo
154	3	2024-12-18	Gotgatan 31, 60223 Norrkoping
154	25	2024-12-18	Gotgatan 31, 60223 Norrkoping
139	20	2024-12-12	Valhallavagen 23, 35234 Vaxjo
140	13	2024-12-08	Odengatan 56, 39231 Kalmar
144	4	2024-12-25	Vasagatan 39, 76164 Norrtalje
145	18	2024-12-15	Kungsgatan 15, 11456 Stockholm
147	11	2024-12-30	Storgatan 7, 76291 Rimbo
148	26	2024-12-05	Vasagatan 45, 76164 Norrtalje
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person (person_id, person_number, name, address, phone, email) FROM stdin;
101	19750214-3344	Erik Andersson	Kungsgatan 15, 11456 Stockholm	0712345678	erik.andersson75@gmail.com
102	19820618-5566	Maria Nilsson	Drottninggatan 22, 75238 Uppsala	0723456789	maria.nilsson82@hotmail.com
103	19900325-7788	Karl Johansson	Storgatan 7, 76291 Rimbo	0734567890	karl.johansson90@yahoo.com
104	19851103-9900	Anna Eriksson	Vasagatan 45, 76164 Norrtalje	0745678901	anna.eriksson85@outlook.com
105	19780712-1122	Johan Larsson	Birgersgatan 33, 72346 Vasteras	0756789012	johan.larsson78@gmail.com
106	19930924-3344	Kristina Olsson	Karlavagen 18, 70374 Orebro	0767890123	kristina.olsson93@hotmail.com
107	19880506-5566	Per Svensson	Sveavagen 92, 58273 Linkoping	0778901234	per.svensson88@yahoo.com
108	19950817-7788	Eva Karlsson	Gotgatan 5, 60223 Norrkoping	0789012345	eva.karlsson95@outlook.com
109	19830228-9900	Lars Persson	Valhallavagen 66, 35234 Vaxjo	0790123456	lars.persson83@gmail.com
110	19910419-1122	Birgitta Gustafsson	Odengatan 27, 39231 Kalmar	0701234567	birgitta.gustafsson91@hotmail.com
111	19840730-3344	Nils Andersson	Kungsgatan 38, 11456 Stockholm	0712345679	nils.andersson84@yahoo.com
112	19920611-5566	Margareta Nilsson	Drottninggatan 14, 75238 Uppsala	0723456780	margareta.nilsson92@outlook.com
113	19870823-7788	Carl Johansson	Storgatan 55, 76291 Rimbo	0734567891	carl.johansson87@gmail.com
114	19940104-9900	Karin Eriksson	Vasagatan 73, 76164 Norrtalje	0745678902	karin.eriksson94@hotmail.com
115	19810316-1122	Mikael Larsson	Birgersgatan 9, 72346 Vasteras	0756789013	mikael.larsson81@yahoo.com
116	19960527-3344	Marie Olsson	Karlavagen 41, 70374 Orebro	0767890124	marie.olsson96@outlook.com
117	19890808-5566	Jan Svensson	Sveavagen 28, 58273 Linkoping	0778901235	jan.svensson89@gmail.com
118	19930219-7788	Elisabeth Karlsson	Gotgatan 63, 60223 Norrkoping	0789012346	elisabeth.karlsson93@hotmail.com
119	19860502-9900	Anders Persson	Valhallavagen 12, 35234 Vaxjo	0790123457	anders.persson86@yahoo.com
120	19910713-1122	Ingrid Gustafsson	Odengatan 84, 39231 Kalmar	0701234568	ingrid.gustafsson91@outlook.com
121	19841024-3344	Erik Larsson	Kungsgatan 25, 11456 Stockholm	0712345680	erik.larsson84@gmail.com
122	19920305-5566	Maria Olsson	Drottninggatan 37, 75238 Uppsala	0723456781	maria.olsson92@hotmail.com
123	19870616-7788	Karl Svensson	Storgatan 19, 76291 Rimbo	0734567892	karl.svensson87@yahoo.com
124	19940827-9900	Anna Karlsson	Vasagatan 51, 76164 Norrtalje	0745678903	anna.karlsson94@outlook.com
125	19811208-1122	Johan Persson	Birgersgatan 76, 72346 Vasteras	0756789014	johan.persson81@gmail.com
126	19960319-3344	Kristina Gustafsson	Karlavagen 3, 70374 Orebro	0767890125	kristina.gustafsson96@hotmail.com
127	19890530-5566	Per Andersson	Sveavagen 59, 58273 Linkoping	0778901236	per.andersson89@yahoo.com
128	19930811-7788	Eva Nilsson	Gotgatan 31, 60223 Norrkoping	0789012347	eva.nilsson93@outlook.com
129	19861122-9900	Lars Johansson	Valhallavagen 88, 35234 Vaxjo	0790123458	lars.johansson86@gmail.com
130	19910103-1122	Birgitta Eriksson	Odengatan 42, 39231 Kalmar	0701234569	birgitta.eriksson91@hotmail.com
131	19840414-3344	Nils Larsson	Kungsgatan 71, 11456 Stockholm	0712345681	nils.larsson84@yahoo.com
132	19920725-5566	Margareta Olsson	Drottninggatan 94, 75238 Uppsala	0723456782	margareta.olsson92@outlook.com
133	19871006-7788	Carl Svensson	Storgatan 47, 76291 Rimbo	0734567893	carl.svensson87@gmail.com
134	19940117-9900	Karin Karlsson	Vasagatan 16, 76164 Norrtalje	0745678904	karin.karlsson94@hotmail.com
135	19810328-1122	Mikael Persson	Birgersgatan 82, 72346 Vasteras	0756789015	mikael.persson81@yahoo.com
136	19960609-3344	Marie Gustafsson	Karlavagen 65, 70374 Orebro	0767890126	marie.gustafsson96@outlook.com
137	19890820-5566	Jan Andersson	Sveavagen 34, 58273 Linkoping	0778901237	jan.andersson89@gmail.com
138	19931201-7788	Elisabeth Nilsson	Gotgatan 77, 60223 Norrkoping	0789012348	elisabeth.nilsson93@hotmail.com
139	19860312-9900	Anders Johansson	Valhallavagen 23, 35234 Vaxjo	0790123459	anders.johansson86@yahoo.com
140	19910623-1122	Ingrid Eriksson	Odengatan 56, 39231 Kalmar	0701234570	ingrid.eriksson91@outlook.com
141	19840904-3344	Erik Olsson	Kungsgatan 89, 11456 Stockholm	0712345682	erik.olsson84@gmail.com
142	19921215-5566	Maria Svensson	Drottninggatan 11, 75238 Uppsala	0723456783	maria.svensson92@hotmail.com
143	19870326-7788	Karl Karlsson	Storgatan 68, 76291 Rimbo	0734567894	karl.karlsson87@yahoo.com
144	19940607-9900	Anna Persson	Vasagatan 39, 76164 Norrtalje	0745678905	anna.persson94@outlook.com
145	20080214-3344	Erik Andersson	Kungsgatan 15, 11456 Stockholm	0712345678	erik.andersson08@gmail.com
146	20120618-5566	Maria Nilsson	Drottninggatan 22, 75238 Uppsala	0723456789	maria.nilsson12@hotmail.com
147	20150325-7788	Karl Johansson	Storgatan 7, 76291 Rimbo	0734567890	karl.johansson15@yahoo.com
148	20090503-9900	Anna Eriksson	Vasagatan 45, 76164 Norrtalje	0745678901	anna.eriksson09@outlook.com
149	20170712-1122	Johan Larsson	Birgersgatan 33, 72346 Vasteras	0756789012	johan.larsson17@gmail.com
150	20130924-3344	Kristina Olsson	Karlavagen 18, 70374 Orebro	0767890123	kristina.olsson13@hotmail.com
151	20180506-5566	Per Svensson	Sveavagen 92, 58273 Linkoping	0778901234	per.svensson18@yahoo.com
152	20110817-7788	Eva Karlsson	Gotgatan 5, 60223 Norrkoping	0789012345	eva.karlsson11@outlook.com
153	20140228-9900	Lars Persson	Valhallavagen 66, 35234 Vaxjo	0790123456	lars.persson14@gmail.com
154	20160419-1122	Birgitta Gustafsson	Odengatan 27, 39231 Kalmar	0701234567	birgitta.gustafsson16@hotmail.com
155	20070730-3344	Nils Andersson	Kungsgatan 38, 11456 Stockholm	0712345679	nils.andersson07@yahoo.com
156	20100611-5566	Margareta Nilsson	Drottninggatan 14, 75238 Uppsala	0723456780	margareta.nilsson10@outlook.com
157	20130823-7788	Carl Johansson	Storgatan 55, 76291 Rimbo	0734567891	carl.johansson13@gmail.com
158	20170104-9900	Karin Eriksson	Vasagatan 73, 76164 Norrtalje	0745678902	karin.eriksson17@hotmail.com
159	20090316-1122	Mikael Larsson	Birgersgatan 9, 72346 Vasteras	0756789013	mikael.larsson09@yahoo.com
160	20120527-3344	Marie Olsson	Karlavagen 41, 70374 Orebro	0767890124	marie.olsson12@outlook.com
161	20150808-5566	Jan Svensson	Sveavagen 28, 58273 Linkoping	0778901235	jan.svensson15@gmail.com
162	20080219-7788	Elisabeth Karlsson	Gotgatan 63, 60223 Norrkoping	0789012346	elisabeth.karlsson08@hotmail.com
163	20110502-9900	Anders Persson	Valhallavagen 12, 35234 Vaxjo	0790123457	anders.persson11@yahoo.com
164	20140713-1122	Ingrid Gustafsson	Odengatan 84, 39231 Kalmar	0701234568	ingrid.gustafsson14@outlook.com
165	20161024-3344	Erik Larsson	Kungsgatan 25, 11456 Stockholm	0712345680	erik.larsson16@gmail.com
166	20090305-5566	Maria Olsson	Drottninggatan 37, 75238 Uppsala	0723456781	maria.olsson09@hotmail.com
167	20120616-7788	Karl Svensson	Storgatan 19, 76291 Rimbo	0734567892	karl.svensson12@yahoo.com
168	20150827-9900	Anna Karlsson	Vasagatan 51, 76164 Norrtalje	0745678903	anna.karlsson15@outlook.com
169	20081208-1122	Johan Persson	Birgersgatan 76, 72346 Vasteras	0756789014	johan.persson08@gmail.com
170	20110319-3344	Kristina Gustafsson	Karlavagen 3, 70374 Orebro	0767890125	kristina.gustafsson11@hotmail.com
171	20140530-5566	Per Andersson	Sveavagen 59, 58273 Linkoping	0778901236	per.andersson14@yahoo.com
172	20160811-7788	Eva Nilsson	Gotgatan 31, 60223 Norrkoping	0789012347	eva.nilsson16@outlook.com
173	20091122-9900	Lars Johansson	Valhallavagen 88, 35234 Vaxjo	0790123458	lars.johansson09@gmail.com
174	20130103-1122	Birgitta Eriksson	Odengatan 42, 39231 Kalmar	0701234569	birgitta.eriksson13@hotmail.com
175	20170414-3344	Nils Larsson	Kungsgatan 71, 11456 Stockholm	0712345681	nils.larsson17@yahoo.com
176	20080725-5566	Margareta Olsson	Drottninggatan 94, 75238 Uppsala	0723456782	margareta.olsson08@outlook.com
177	20111006-7788	Carl Svensson	Storgatan 47, 76291 Rimbo	0734567893	carl.svensson11@gmail.com
178	20150117-9900	Karin Karlsson	Vasagatan 16, 76164 Norrtalje	0745678904	karin.karlsson15@hotmail.com
179	20180328-1122	Mikael Persson	Birgersgatan 82, 72346 Vasteras	0756789015	mikael.persson18@yahoo.com
180	20100609-3344	Marie Gustafsson	Karlavagen 65, 70374 Orebro	0767890126	marie.gustafsson10@outlook.com
181	20130820-5566	Jan Andersson	Sveavagen 34, 58273 Linkoping	0778901237	jan.andersson13@gmail.com
182	20161201-7788	Elisabeth Nilsson	Gotgatan 77, 60223 Norrkoping	0789012348	elisabeth.nilsson16@hotmail.com
183	20090312-9900	Anders Johansson	Valhallavagen 23, 35234 Vaxjo	0790123459	anders.johansson09@yahoo.com
184	20120623-1122	Ingrid Eriksson	Odengatan 56, 39231 Kalmar	0701234570	ingrid.eriksson12@outlook.com
185	20150904-3344	Erik Olsson	Kungsgatan 89, 11456 Stockholm	0712345682	erik.olsson15@gmail.com
186	20181215-5566	Maria Svensson	Drottninggatan 11, 75238 Uppsala	0723456783	maria.svensson18@hotmail.com
187	20070326-7788	Karl Karlsson	Storgatan 68, 76291 Rimbo	0734567894	karl.karlsson07@yahoo.com
188	20100607-9900	Anna Persson	Vasagatan 39, 76164 Norrtalje	0745678905	anna.persson10@outlook.com
189	20130918-1122	Johan Gustafsson	Birgersgatan 17, 72346 Vasteras	0756789016	johan.gustafsson13@gmail.com
190	20160229-3344	Kristina Andersson	Karlavagen 72, 70374 Orebro	0767890127	kristina.andersson16@hotmail.com
191	20090510-5566	Per Nilsson	Sveavagen 45, 58273 Linkoping	0778901238	per.nilsson09@yahoo.com
192	20120821-7788	Eva Johansson	Gotgatan 93, 60223 Norrkoping	0789012349	eva.johansson12@outlook.com
193	20151102-9900	Lars Eriksson	Valhallavagen 30, 35234 Vaxjo	0790123460	lars.eriksson15@gmail.com
194	20180413-1122	Birgitta Larsson	Odengatan 67, 39231 Kalmar	0701234571	birgitta.larsson18@hotmail.com
195	20070724-3344	Nils Olsson	Kungsgatan 52, 11456 Stockholm	0712345683	nils.olsson07@yahoo.com
196	20101005-5566	Margareta Svensson	Drottninggatan 88, 75238 Uppsala	0723456784	margareta.svensson10@outlook.com
197	20140116-7788	Carl Karlsson	Storgatan 34, 76291 Rimbo	0734567895	carl.karlsson14@gmail.com
198	20170427-9900	Karin Persson	Vasagatan 61, 76164 Norrtalje	0745678906	karin.persson17@hotmail.com
199	20080708-1122	Mikael Gustafsson	Birgersgatan 43, 72346 Vasteras	0756789017	mikael.gustafsson08@yahoo.com
200	20111019-3344	Marie Andersson	Karlavagen 85, 70374 Orebro	0767890128	marie.andersson11@outlook.com
201	20150130-5566	Jan Nilsson	Sveavagen 12, 58273 Linkoping	0778901239	jan.nilsson15@gmail.com
\.


--
-- Data for Name: person_ensemble; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person_ensemble (person_id, ensemble_id) FROM stdin;
101	1
102	2
103	3
106	4
107	5
145	1
146	1
147	1
148	1
149	1
150	1
151	1
152	1
153	1
154	1
155	2
156	2
157	2
158	2
159	2
160	2
161	2
162	2
163	2
164	2
165	2
166	2
167	3
168	3
169	3
170	3
171	3
172	3
173	3
174	3
175	4
176	4
177	4
178	4
179	4
180	4
181	4
182	4
183	4
184	5
185	5
186	5
187	5
188	5
189	5
190	5
191	5
192	5
193	5
194	5
195	5
196	5
108	6
110	7
111	8
114	9
115	10
116	11
117	12
119	13
101	14
102	15
145	6
146	6
147	6
148	6
149	6
150	6
151	6
152	6
153	6
154	6
155	6
156	7
157	7
158	7
159	7
160	7
161	7
162	7
163	7
164	8
165	8
166	8
167	8
168	8
169	8
170	8
171	8
172	8
173	8
174	8
175	8
176	8
177	8
178	9
179	9
180	9
181	9
182	9
183	9
184	10
185	10
186	10
187	10
188	10
189	10
190	10
191	11
192	11
193	11
194	11
195	11
196	11
197	11
198	11
199	11
145	12
146	12
147	12
148	12
149	12
150	12
151	12
152	12
153	12
154	12
155	12
156	12
157	13
158	13
159	13
160	13
161	13
162	13
163	13
164	13
165	13
166	13
167	13
168	13
169	13
170	13
171	13
172	14
173	14
174	14
175	14
176	14
177	14
178	14
179	15
180	15
181	15
182	15
183	15
184	15
185	15
186	15
187	15
188	15
101	16
145	16
146	16
147	16
148	16
149	16
102	17
150	17
151	17
152	17
153	17
154	17
155	17
156	17
157	17
103	18
158	18
159	18
160	18
161	18
106	19
162	19
163	19
164	19
165	19
166	19
167	19
107	20
168	20
169	20
170	20
171	20
172	20
173	20
174	20
108	21
175	21
176	21
177	21
178	21
179	21
110	22
180	22
181	22
182	22
183	22
184	22
185	22
111	23
186	23
187	23
188	23
189	23
114	24
190	24
191	24
192	24
193	24
194	24
115	25
145	25
146	25
147	25
116	26
148	26
149	26
150	26
151	26
152	26
117	27
153	27
154	27
155	27
156	27
157	27
158	27
159	27
160	27
119	28
161	28
162	28
163	28
164	28
101	29
165	29
166	29
167	29
168	29
169	29
102	30
170	30
171	30
172	30
173	30
174	30
175	30
103	31
176	31
177	31
178	31
179	31
180	31
106	32
181	32
182	32
183	32
184	32
107	33
185	33
186	33
187	33
188	33
189	33
190	33
108	34
191	34
192	34
193	34
194	34
195	34
110	35
145	35
146	35
147	35
148	35
149	35
150	35
151	35
111	36
152	36
153	36
154	36
155	36
114	37
156	37
157	37
158	37
159	37
115	38
160	38
161	38
162	38
163	38
164	38
165	38
116	39
166	39
167	39
168	39
169	39
170	39
171	39
172	39
117	40
173	40
174	40
175	40
176	40
177	40
119	41
178	41
179	41
180	41
181	41
101	42
182	42
183	42
184	42
185	42
102	43
186	43
187	43
188	43
189	43
190	43
103	44
191	44
192	44
193	44
194	44
195	44
196	44
106	45
145	45
146	45
147	45
148	45
149	45
107	46
150	46
151	46
152	46
153	46
108	47
154	47
155	47
156	47
157	47
158	47
110	48
159	48
160	48
161	48
162	48
163	48
164	48
111	49
165	49
166	49
167	49
168	49
169	49
170	49
171	49
114	50
172	50
173	50
174	50
175	50
176	50
177	50
178	50
115	51
179	51
180	51
181	51
182	51
183	51
184	51
116	52
185	52
186	52
187	52
188	52
189	52
117	53
190	53
191	53
192	53
193	53
194	53
195	53
119	54
145	54
146	54
147	54
148	54
149	54
150	54
151	54
101	55
152	55
153	55
154	55
155	55
156	55
\.


--
-- Data for Name: person_group_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person_group_lesson (person_id, group_lesson_id) FROM stdin;
145	1
146	1
147	1
148	1
149	1
150	2
151	2
152	2
153	2
154	2
155	3
156	3
157	3
158	3
159	3
160	4
161	4
162	4
163	4
164	4
165	5
166	5
167	5
168	5
169	5
170	6
171	6
172	6
173	6
174	6
175	7
176	7
177	7
178	7
179	7
180	8
181	8
182	8
183	8
184	8
185	9
186	9
187	9
188	9
189	9
190	10
191	10
192	10
193	10
194	10
195	11
196	11
197	11
198	11
199	11
145	12
146	12
147	12
148	12
149	12
150	13
151	13
152	13
153	13
154	13
155	14
156	14
157	14
158	14
159	14
160	15
161	15
162	15
163	15
164	15
145	16
146	16
147	16
148	16
149	17
150	17
151	17
152	17
153	17
154	17
155	18
156	18
157	18
158	18
159	18
160	18
161	18
162	19
163	19
164	19
165	19
166	20
167	20
168	20
169	20
170	20
171	20
172	21
173	21
174	21
175	21
176	21
177	22
178	22
179	22
180	22
181	22
182	22
183	22
184	23
185	23
186	23
187	23
188	24
189	24
190	24
191	24
192	24
193	25
194	25
195	25
196	25
197	25
198	25
145	26
146	26
147	26
148	26
149	26
150	26
151	27
152	27
153	27
154	27
155	28
156	28
157	28
158	28
159	28
160	28
161	28
162	29
163	29
164	29
165	29
166	29
167	30
168	30
169	30
170	30
171	30
172	30
173	31
174	31
175	31
176	31
177	32
178	32
179	32
180	32
181	32
182	32
183	33
184	33
185	33
186	33
187	33
188	34
189	34
190	34
191	34
192	34
193	34
194	34
195	35
196	35
197	35
198	35
145	36
146	36
147	36
148	36
149	36
150	37
151	37
152	37
153	37
154	37
155	37
156	38
157	38
158	38
159	38
160	39
161	39
162	39
163	39
164	39
165	39
166	39
167	40
168	40
169	40
170	40
171	41
172	41
173	41
174	41
175	41
176	41
177	42
178	42
179	42
180	42
181	43
182	43
183	43
184	43
185	43
186	43
187	44
188	44
189	44
190	44
191	44
192	45
193	45
194	45
195	45
196	45
197	45
198	45
\.


--
-- Data for Name: person_individual_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person_individual_lesson (person_id, individual_lesson_id) FROM stdin;
101	1
145	1
102	2
146	2
103	3
147	3
104	4
148	4
105	5
149	5
106	6
150	6
107	7
151	7
108	8
152	8
109	9
153	9
110	10
154	10
111	11
155	11
112	12
156	12
113	13
157	13
114	14
158	14
115	15
159	15
116	16
160	16
117	17
161	17
118	18
162	18
119	19
163	19
120	20
164	20
101	21
165	21
102	22
166	22
103	23
167	23
104	24
168	24
105	25
169	25
106	26
170	26
107	27
171	27
108	28
172	28
109	29
173	29
110	30
174	30
\.


--
-- Data for Name: person_sibling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person_sibling (person_id, sibling_id) FROM stdin;
121	122
122	121
125	126
126	125
130	131
131	130
135	136
136	135
140	141
141	140
145	146
145	147
146	145
146	147
147	145
147	146
150	151
150	152
151	150
151	152
152	150
152	151
155	156
155	157
155	158
156	155
156	157
156	158
157	155
157	156
157	158
158	155
158	156
158	157
160	161
160	162
160	163
161	160
161	162
161	163
162	160
162	161
162	163
163	160
163	161
163	162
\.


--
-- Data for Name: pricing_scheme; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pricing_scheme (pricing_scheme_id, price, pay, price_valid_from, type_of_lesson_id, instrument_level_id) FROM stdin;
1	100.00	90.00	2023-11-16 00:00:00	2	2
2	100.00	90.00	2023-11-16 00:00:00	2	3
3	75.00	150.00	2023-11-16 00:00:00	3	2
4	75.00	150.00	2023-11-16 00:00:00	3	3
7	150.00	125.00	2023-11-16 00:00:00	2	4
8	100.00	175.00	2023-11-16 00:00:00	3	4
10	125.00	120.00	2024-11-16 00:00:00	2	2
11	125.00	120.00	2024-11-16 00:00:00	2	3
12	100.00	175.00	2024-11-16 00:00:00	3	2
13	100.00	175.00	2024-11-16 00:00:00	3	3
16	175.00	150.00	2024-11-16 00:00:00	2	4
17	125.00	200.00	2024-11-16 00:00:00	3	4
19	50.00	125.00	2023-11-16 00:00:00	4	\N
20	75.00	150.00	2024-11-16 00:00:00	4	\N
\.


--
-- Data for Name: type_of_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type_of_lesson (type_of_lesson_id, type_of_lesson) FROM stdin;
1	Removed lesson type
2	Individual lesson
3	Group lesson
4	Ensemble
\.


--
-- Name: ensemble_ensemble_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ensemble_ensemble_id_seq', 55, true);


--
-- Name: group_lesson_group_lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.group_lesson_group_lesson_id_seq', 45, true);


--
-- Name: individual_lesson_individual_lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.individual_lesson_individual_lesson_id_seq', 80, true);


--
-- Name: instructor_availability_instructor_availability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instructor_availability_instructor_availability_id_seq', 294, true);


--
-- Name: instructor_instructor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instructor_instructor_id_seq', 20, true);


--
-- Name: instrument_instrument_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_instrument_id_seq', 147, true);


--
-- Name: instrument_inventory_instrument_inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_inventory_instrument_inventory_id_seq', 30, true);


--
-- Name: instrument_level_instrument_level_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_level_instrument_level_id_seq', 4, true);


--
-- Name: instrument_type_instrument_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_type_instrument_type_id_seq', 12, true);


--
-- Name: person_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.person_person_id_seq', 201, true);


--
-- Name: pricing_scheme_pricing_scheme_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pricing_scheme_pricing_scheme_id_seq', 20, true);


--
-- Name: type_of_lesson_type_of_lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_of_lesson_type_of_lesson_id_seq', 4, true);


--
-- Name: contact_person contact_person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_person
    ADD CONSTRAINT contact_person_pkey PRIMARY KEY (person_id);


--
-- Name: ensemble ensemble_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble
    ADD CONSTRAINT ensemble_pkey PRIMARY KEY (ensemble_id);


--
-- Name: group_lesson group_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_pkey PRIMARY KEY (group_lesson_id);


--
-- Name: individual_lesson individual_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_pkey PRIMARY KEY (individual_lesson_id);


--
-- Name: instructor_availability instructor_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_availability
    ADD CONSTRAINT instructor_availability_pkey PRIMARY KEY (instructor_availability_id);


--
-- Name: instructor instructor_person_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_person_id_key UNIQUE (person_id);


--
-- Name: instructor instructor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_pkey PRIMARY KEY (instructor_id);


--
-- Name: instrument_inventory instrument_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_inventory
    ADD CONSTRAINT instrument_inventory_pkey PRIMARY KEY (instrument_inventory_id);


--
-- Name: instrument_level instrument_level_instrument_level_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_level
    ADD CONSTRAINT instrument_level_instrument_level_key UNIQUE (instrument_level);


--
-- Name: instrument_level instrument_level_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_level
    ADD CONSTRAINT instrument_level_pkey PRIMARY KEY (instrument_level_id);


--
-- Name: instrument instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_pkey PRIMARY KEY (instrument_id);


--
-- Name: instrument_type instrument_type_instrument_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_type
    ADD CONSTRAINT instrument_type_instrument_type_key UNIQUE (instrument_type);


--
-- Name: instrument_type instrument_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_type
    ADD CONSTRAINT instrument_type_pkey PRIMARY KEY (instrument_type_id);


--
-- Name: lease lease_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lease
    ADD CONSTRAINT lease_pkey PRIMARY KEY (person_id, instrument_inventory_id);


--
-- Name: person_ensemble person_ensemble_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_ensemble
    ADD CONSTRAINT person_ensemble_pkey PRIMARY KEY (person_id, ensemble_id);


--
-- Name: person_group_lesson person_group_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_group_lesson
    ADD CONSTRAINT person_group_lesson_pkey PRIMARY KEY (person_id, group_lesson_id);


--
-- Name: person_individual_lesson person_individual_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_individual_lesson
    ADD CONSTRAINT person_individual_lesson_pkey PRIMARY KEY (person_id, individual_lesson_id);


--
-- Name: person person_person_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_person_number_key UNIQUE (person_number);


--
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (person_id);


--
-- Name: person_sibling person_sibling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_sibling
    ADD CONSTRAINT person_sibling_pkey PRIMARY KEY (person_id, sibling_id);


--
-- Name: pricing_scheme pricing_scheme_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricing_scheme
    ADD CONSTRAINT pricing_scheme_pkey PRIMARY KEY (pricing_scheme_id);


--
-- Name: type_of_lesson type_of_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_of_lesson
    ADD CONSTRAINT type_of_lesson_pkey PRIMARY KEY (type_of_lesson_id);


--
-- Name: type_of_lesson type_of_lesson_type_of_lesson_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_of_lesson
    ADD CONSTRAINT type_of_lesson_type_of_lesson_key UNIQUE (type_of_lesson);


--
-- Name: lease check_lease_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_lease_trigger BEFORE INSERT OR UPDATE ON public.lease FOR EACH ROW EXECUTE FUNCTION public.check_lease_limit();


--
-- Name: contact_person contact_person_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_person
    ADD CONSTRAINT contact_person_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id) ON DELETE CASCADE;


--
-- Name: ensemble ensemble_pricing_scheme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble
    ADD CONSTRAINT ensemble_pricing_scheme_id_fkey FOREIGN KEY (pricing_scheme_id) REFERENCES public.pricing_scheme(pricing_scheme_id);


--
-- Name: group_lesson group_lesson_instrument_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_instrument_level_id_fkey FOREIGN KEY (instrument_level_id) REFERENCES public.instrument_level(instrument_level_id) ON DELETE SET DEFAULT;


--
-- Name: group_lesson group_lesson_instrument_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_instrument_type_id_fkey FOREIGN KEY (instrument_type_id) REFERENCES public.instrument_type(instrument_type_id) ON DELETE SET DEFAULT;


--
-- Name: group_lesson group_lesson_pricing_scheme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_pricing_scheme_id_fkey FOREIGN KEY (pricing_scheme_id) REFERENCES public.pricing_scheme(pricing_scheme_id);


--
-- Name: individual_lesson individual_lesson_instrument_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_instrument_level_id_fkey FOREIGN KEY (instrument_level_id) REFERENCES public.instrument_level(instrument_level_id) ON DELETE SET DEFAULT;


--
-- Name: individual_lesson individual_lesson_instrument_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_instrument_type_id_fkey FOREIGN KEY (instrument_type_id) REFERENCES public.instrument_type(instrument_type_id) ON DELETE SET DEFAULT;


--
-- Name: individual_lesson individual_lesson_pricing_scheme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_pricing_scheme_id_fkey FOREIGN KEY (pricing_scheme_id) REFERENCES public.pricing_scheme(pricing_scheme_id);


--
-- Name: instructor_availability instructor_availability_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_availability
    ADD CONSTRAINT instructor_availability_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id) ON DELETE CASCADE;


--
-- Name: instructor instructor_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id) ON DELETE CASCADE;


--
-- Name: instrument instrument_instrument_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_instrument_level_id_fkey FOREIGN KEY (instrument_level_id) REFERENCES public.instrument_level(instrument_level_id) ON DELETE SET DEFAULT;


--
-- Name: instrument instrument_instrument_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_instrument_type_id_fkey FOREIGN KEY (instrument_type_id) REFERENCES public.instrument_type(instrument_type_id) ON DELETE SET DEFAULT;


--
-- Name: instrument_inventory instrument_inventory_instrument_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_inventory
    ADD CONSTRAINT instrument_inventory_instrument_type_id_fkey FOREIGN KEY (instrument_type_id) REFERENCES public.instrument_type(instrument_type_id) ON DELETE SET DEFAULT;


--
-- Name: instrument instrument_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id) ON DELETE CASCADE;


--
-- Name: lease lease_instrument_inventory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lease
    ADD CONSTRAINT lease_instrument_inventory_id_fkey FOREIGN KEY (instrument_inventory_id) REFERENCES public.instrument_inventory(instrument_inventory_id) ON DELETE CASCADE;


--
-- Name: lease lease_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lease
    ADD CONSTRAINT lease_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id) ON DELETE CASCADE;


--
-- Name: person_ensemble person_ensemble_ensemble_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_ensemble
    ADD CONSTRAINT person_ensemble_ensemble_id_fkey FOREIGN KEY (ensemble_id) REFERENCES public.ensemble(ensemble_id) ON DELETE CASCADE;


--
-- Name: person_ensemble person_ensemble_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_ensemble
    ADD CONSTRAINT person_ensemble_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id) ON DELETE CASCADE;


--
-- Name: person_group_lesson person_group_lesson_group_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_group_lesson
    ADD CONSTRAINT person_group_lesson_group_lesson_id_fkey FOREIGN KEY (group_lesson_id) REFERENCES public.group_lesson(group_lesson_id) ON DELETE CASCADE;


--
-- Name: person_group_lesson person_group_lesson_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_group_lesson
    ADD CONSTRAINT person_group_lesson_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id) ON DELETE CASCADE;


--
-- Name: person_individual_lesson person_individual_lesson_individual_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_individual_lesson
    ADD CONSTRAINT person_individual_lesson_individual_lesson_id_fkey FOREIGN KEY (individual_lesson_id) REFERENCES public.individual_lesson(individual_lesson_id) ON DELETE CASCADE;


--
-- Name: person_individual_lesson person_individual_lesson_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_individual_lesson
    ADD CONSTRAINT person_individual_lesson_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id) ON DELETE CASCADE;


--
-- Name: person_sibling person_sibling_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_sibling
    ADD CONSTRAINT person_sibling_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id) ON DELETE CASCADE;


--
-- Name: person_sibling person_sibling_sibling_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_sibling
    ADD CONSTRAINT person_sibling_sibling_id_fkey FOREIGN KEY (sibling_id) REFERENCES public.person(person_id) ON DELETE CASCADE;


--
-- Name: pricing_scheme pricing_scheme_instrument_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricing_scheme
    ADD CONSTRAINT pricing_scheme_instrument_level_id_fkey FOREIGN KEY (instrument_level_id) REFERENCES public.instrument_level(instrument_level_id) ON DELETE SET DEFAULT;


--
-- Name: pricing_scheme pricing_scheme_type_of_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricing_scheme
    ADD CONSTRAINT pricing_scheme_type_of_lesson_id_fkey FOREIGN KEY (type_of_lesson_id) REFERENCES public.type_of_lesson(type_of_lesson_id) ON DELETE SET DEFAULT;


--
-- PostgreSQL database dump complete
--

