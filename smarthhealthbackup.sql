--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 16.8

-- Started on 2026-01-04 13:35:31

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
-- TOC entry 2 (class 3079 OID 17021)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 17121)
-- Name: appointments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointments (
    appointment_id integer NOT NULL,
    patient_id uuid,
    doctor_email character varying(100),
    patient_name character varying(100),
    age integer,
    symptoms text,
    location character varying(100),
    appointment_date date,
    appointment_time character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.appointments OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17120)
-- Name: appointments_appointment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointments_appointment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointments_appointment_id_seq OWNER TO postgres;

--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 221
-- Name: appointments_appointment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointments_appointment_id_seq OWNED BY public.appointments.appointment_id;


--
-- TOC entry 217 (class 1259 OID 16791)
-- Name: doctors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctors (
    doctor_id integer NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    specialization character varying(100) NOT NULL,
    is_online boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.doctors OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16790)
-- Name: doctors_doctor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctors_doctor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.doctors_doctor_id_seq OWNER TO postgres;

--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 216
-- Name: doctors_doctor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctors_doctor_id_seq OWNED BY public.doctors.doctor_id;


--
-- TOC entry 220 (class 1259 OID 17085)
-- Name: patient_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_profiles (
    profile_id integer NOT NULL,
    patient_id uuid,
    first_name character varying(100),
    gender character varying(20),
    symptoms text,
    dob date,
    height numeric(5,2),
    weight numeric(5,2),
    blood_group character varying(10),
    address text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.patient_profiles OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17084)
-- Name: patient_profiles_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patient_profiles_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patient_profiles_profile_id_seq OWNER TO postgres;

--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 219
-- Name: patient_profiles_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patient_profiles_profile_id_seq OWNED BY public.patient_profiles.profile_id;


--
-- TOC entry 218 (class 1259 OID 17058)
-- Name: patients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patients (
    patient_id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    email character varying(100),
    password character varying(255)
);


ALTER TABLE public.patients OWNER TO postgres;

--
-- TOC entry 4748 (class 2604 OID 17124)
-- Name: appointments appointment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments ALTER COLUMN appointment_id SET DEFAULT nextval('public.appointments_appointment_id_seq'::regclass);


--
-- TOC entry 4739 (class 2604 OID 16794)
-- Name: doctors doctor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors ALTER COLUMN doctor_id SET DEFAULT nextval('public.doctors_doctor_id_seq'::regclass);


--
-- TOC entry 4746 (class 2604 OID 17088)
-- Name: patient_profiles profile_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_profiles ALTER COLUMN profile_id SET DEFAULT nextval('public.patient_profiles_profile_id_seq'::regclass);


--
-- TOC entry 4914 (class 0 OID 17121)
-- Dependencies: 222
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointments (appointment_id, patient_id, doctor_email, patient_name, age, symptoms, location, appointment_date, appointment_time, created_at) FROM stdin;
33	1e09fefd-4442-411f-aa47-aa536d42d153	ishita.kapoor@gmail.com	mohit	34	i dont know 	Jabalpur, Madhya Pradesh, India	2025-12-29	7:17 PM	2025-12-29 19:16:08.256338
34	1e09fefd-4442-411f-aa47-aa536d42d153	rahul.sharma@gmail.com	mohit	34	4	fg	2025-12-29	9:00 AM	2025-12-29 21:42:00.805097
35	1e09fefd-4442-411f-aa47-aa536d42d153	arjun.kumar@gmail.com	mohit	45	fg	rr	2025-12-30	7:17 PM	2025-12-30 18:07:01.234666
36	1e09fefd-4442-411f-aa47-aa536d42d153	priya.mishra@gmail.com	Rohan	45	skin problem	canada	2025-12-30	6:30 PM	2025-12-30 18:14:08.262916
37	1ea84044-156a-448c-adf8-b3c6be129488	tanya.singh@gmail.com	mohit	66	skin problem	delhi	2026-01-02	7:30 PM	2026-01-02 19:26:44.071183
38	15b829b6-24dd-432c-8073-5496b8217faf	vishal.rao@gmail.com	100 rupe swf 	28	KFJDKFJDKFJK	JHFJDF	2026-01-04	12:00 PM	2026-01-04 11:32:42.197016
\.


--
-- TOC entry 4909 (class 0 OID 16791)
-- Dependencies: 217
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: postgres
--



COPY public.doctors (doctor_id, email, password, specialization, is_online, created_at, updated_at) FROM stdin;
23	vishal.rao@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Cardiologist	t	2025-09-23 08:12:49.843675	2026-01-04 11:33:08.352488
32	tanya.singh@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Ophthalmologist	t	2025-09-23 08:12:49.843675	2026-01-04 12:45:22.351739
2	Doctor@gmail.com	$2b$10$Teg1uOkJQkLFrPpKSrblsuQOmjrL2o8DRX8BRgmYrSvYR3nzQZdke	Brain	t	2025-09-20 14:46:24.830566	2026-01-02 18:57:05.18157
21	rahul.sharma@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Neurologist	t	2025-09-23 08:12:49.843675	2025-11-05 11:41:58.669698
20	neha.singh@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Endocrinologist	t	2025-09-23 08:12:49.843675	2026-01-02 18:59:44.845207
19	arjun.kumar@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	General Physician	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
25	karthik.verma@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Psychiatrist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
26	ishita.kapoor@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Psychologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
27	manish.rao@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Rheumatologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
28	sanya.jain@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Nephrologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
29	abhishek.singh@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Hepatologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
30	meera.kumar@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Dermatologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
31	rajat.shah@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	ENT	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
33	rohit.gupta@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Hematologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
35	siddharth.chawla@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Pediatric Pulmonologist	t	2025-09-23 08:12:49.843675	2025-11-05 11:57:32.136567
37	kunal.desai@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Ophthalmologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
38	aishwarya.joshi@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	General Physician	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
1	himanshu623355@gmail.com	$2b$10$pizPY0mwSILZu9e43Z64..ceh5tXnrwwCDeCOqE3CvEub.TTS0WJi	mba	t	2025-09-15 20:19:14.963312	2025-11-12 07:29:44.935192
22	ananya.patel@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Pulmonologist	t	2025-09-23 08:12:49.843675	2025-11-18 10:53:42.807682
34	anjali.reddy@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Allergist	t	2025-09-23 08:12:49.843675	2025-11-24 12:53:55.004878
36	pooja.nair@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Urologist	t	2025-09-23 08:12:49.843675	2025-12-08 13:49:09.86255
4	justin@gmail.com	$2b$10$AJkCOOzlr16MoGMUP4PNY.nHObhrdEhsv0/7eF3Gun00cW10H7n3G	General Practitioner	t	2025-09-23 07:15:48.681445	2025-12-28 12:23:26.470791
3	subh@gmail.com	$2b$10$yaQ6gNsUzeeXQ2JX7bRpQ.k0YA/zrMF/GR3MPa4KuKa.OHRR30rpi	 Psychiatry	t	2025-09-21 21:04:55.244993	2025-12-29 14:58:16.618451
24	priya.mishra@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Gastroenterologist	t	2025-09-23 08:12:49.843675	2026-01-03 11:09:44.051042
39	vikram.bhatia@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Endocrinologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
41	amitabh.sen@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Pulmonologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
42	sneha.ghosh@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Cardiologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
43	harshad.mehta@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Gastroenterologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
44	neelam.yadav@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Psychiatrist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
45	tanvi.saxena@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Psychologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
47	bhavna.iyer@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Nephrologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
48	saurabh.tiwari@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Hepatologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
49	deepika.kaur@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Dermatologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
50	pranav.nair@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	ENT	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
51	ritika.sinha@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Orthopedic	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
52	jayant.reddy@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Hematologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
53	shreya.sharma@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Allergist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
54	aarav.malhotra@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Pediatric Pulmonologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
56	ankit.verma@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Ophthalmologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
57	shalini.rao@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	General Physician	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
58	rohan.kapoor@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Endocrinologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
60	aditya.choudhary@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Pulmonologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
61	madhuri.patel@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Cardiologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
62	arnav.jain@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Gastroenterologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
64	raghav.bansal@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Psychologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
65	isha.deshmukh@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Rheumatologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
66	tarun.agarwal@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Nephrologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
67	aanya.dubey@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Hepatologist	t	2025-09-23 08:12:49.843675	2025-09-23 08:12:49.843675
59	nikita.singh@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Neurologist	t	2025-09-23 08:12:49.843675	2025-09-23 09:18:10.171738
55	kavya.menon@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Urologist	t	2025-09-23 08:12:49.843675	2025-09-23 09:18:40.791097
40	divya.chatterjee@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Neurologist	t	2025-09-23 08:12:49.843675	2025-10-15 17:41:39.634719
46	ramesh.pillai@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Rheumatologist	t	2025-09-23 08:12:49.843675	2025-10-15 17:42:41.270153
68	kabir.mehra@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Dermatologist	t	2025-09-23 08:12:49.843675	2025-11-05 14:33:16.258525
63	simran.kaur@gmail.com	$2b$10$5g8Ukb32D7/.Sscrzk0nLO1iKfvM06njZbZG.hqecd3jrveGx52Hu	Psychiatrist	t	2025-09-23 08:12:49.843675	2025-11-12 07:33:05.285546
\.


--
-- TOC entry 4912 (class 0 OID 17085)
-- Dependencies: 220
-- Data for Name: patient_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient_profiles (profile_id, patient_id, first_name, gender, symptoms, dob, height, weight, blood_group, address, created_at) FROM stdin;
6	c050394a-2dc3-46c6-85aa-5615cca184a8	raj	Male	gg	2019-07-18	5.00	56.00	B+	uk	2025-12-28 12:15:27.901
7	6336932b-57bd-4379-864e-7e12789cd7d0	harsh	Male	dfdf	2026-01-01	6.00	76.00	AB-	seoni	2025-12-29 14:18:53.106636
5	1e09fefd-4442-411f-aa47-aa536d42d153	mohit kumar soni	male	skin problem	2025-12-03	7.00	98.00	B-	Mumbai	2025-12-30 18:28:10.170708
11	1ea84044-156a-448c-adf8-b3c6be129488	hars patkar	Male	dfdf	2026-01-29	6.00	9.00	AB-	fdsfs	2026-01-02 15:29:29.30656
21	cde51cd4-3e77-48f5-b8d3-77d559dde5e6	sua rupe dega	male	 i dont know	2026-01-21	7.00	67.00	B+	gugufa	2026-01-04 11:11:37.351507
22	15b829b6-24dd-432c-8073-5496b8217faf	100 rupe dega ultra pro max	male hai bia male 	 i dont know	2026-01-07	7.00	67.00	B+	venuzuila	2026-01-04 11:31:59.514296
\.


--
-- TOC entry 4910 (class 0 OID 17058)
-- Dependencies: 218
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patients (patient_id, created_at, updated_at, email, password) FROM stdin;
cde51cd4-3e77-48f5-b8d3-77d559dde5e6	2026-01-04 11:11:09.002234	2026-01-04 11:11:09.002234	knowledgesupreme67@gmail.com	\N
15b829b6-24dd-432c-8073-5496b8217faf	2026-01-04 11:20:54.035002	2026-01-04 11:20:54.035002	h9119796@gmail.com	\N
1e09fefd-4442-411f-aa47-aa536d42d153	2025-12-28 07:37:50.644776	2025-12-28 07:37:50.644776	mohit@gmail.com	$2b$10$KocdzviA6b4cdqsULE5HR.fnCz78TrvVEDX97KZaoLwKQCsP9LHC6
c050394a-2dc3-46c6-85aa-5615cca184a8	2025-12-28 12:14:43.004531	2025-12-28 12:14:43.004531	raj@gmail.com	$2b$10$pCP3jqq7VrYQpfd4UMhz7eKt2sRsxOAIomh2fNwKstlfawqv0Ivc.
6336932b-57bd-4379-864e-7e12789cd7d0	2025-12-29 14:18:20.8047	2025-12-29 14:18:20.8047	harsh@gmail.com	$2b$10$X0wNLlqLe2bDxXEej6yEK.NdZUMttbqHjk/6phS/LXowRC4rf4hNK
1ea84044-156a-448c-adf8-b3c6be129488	2026-01-02 15:28:47.342993	2026-01-02 15:28:47.342993	himanshu623355@gmail.com	\N
\.


--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 221
-- Name: appointments_appointment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointments_appointment_id_seq', 38, true);


--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 216
-- Name: doctors_doctor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctors_doctor_id_seq', 68, true);


--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 219
-- Name: patient_profiles_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patient_profiles_profile_id_seq', 22, true);


--
-- TOC entry 4761 (class 2606 OID 17129)
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (appointment_id);


--
-- TOC entry 4751 (class 2606 OID 16801)
-- Name: doctors doctors_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_email_key UNIQUE (email);


--
-- TOC entry 4753 (class 2606 OID 16799)
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (doctor_id);


--
-- TOC entry 4759 (class 2606 OID 17093)
-- Name: patient_profiles patient_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_profiles
    ADD CONSTRAINT patient_profiles_pkey PRIMARY KEY (profile_id);


--
-- TOC entry 4755 (class 2606 OID 17141)
-- Name: patients patients_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_email_unique UNIQUE (email);


--
-- TOC entry 4757 (class 2606 OID 17065)
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (patient_id);


--
-- TOC entry 4763 (class 2606 OID 17135)
-- Name: appointments appointments_doctor_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_doctor_email_fkey FOREIGN KEY (doctor_email) REFERENCES public.doctors(email);


--
-- TOC entry 4764 (class 2606 OID 17130)
-- Name: appointments appointments_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(patient_id);


--
-- TOC entry 4762 (class 2606 OID 17094)
-- Name: patient_profiles patient_profiles_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_profiles
    ADD CONSTRAINT patient_profiles_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(patient_id) ON DELETE CASCADE;


-- Completed on 2026-01-04 13:35:31

--
-- PostgreSQL database dump complete
--

