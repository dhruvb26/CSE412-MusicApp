--
-- PostgreSQL database dump
--

\restrict AucTtIBTbj2w7DFee9KcbNbHCWWJDGDK5mEkjVd9N9dDsBAtaIIcyjtkRLQ9ymV

-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.13

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: User; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."User" (
    user_id integer NOT NULL,
    username character varying(100) NOT NULL,
    isadmin boolean DEFAULT false NOT NULL
);


--
-- Name: album; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.album (
    album_id integer NOT NULL,
    title character varying(200) NOT NULL,
    type character varying(50),
    release_date date,
    artist_id integer NOT NULL,
    image_url text
);


--
-- Name: artist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artist (
    artist_id integer NOT NULL,
    name character varying(150) NOT NULL,
    country character varying(100),
    type character varying(50),
    image_url text
);


--
-- Name: credits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.credits (
    artist_id integer NOT NULL,
    song_id integer NOT NULL,
    role character varying(100)
);


--
-- Name: review; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.review (
    user_id integer NOT NULL,
    song_id integer NOT NULL,
    rating integer
);


--
-- Name: song; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.song (
    song_id integer NOT NULL,
    title character varying(200) NOT NULL,
    duration character varying(10),
    album_id integer NOT NULL,
    track_number integer
);


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."User" (user_id, username, isadmin) FROM stdin;
1	user_1	t
2	user_2	f
3	user_3	f
4	user_4	f
5	user_5	f
6	user_6	f
7	user_7	f
8	user_8	f
9	user_9	f
10	user_10	f
\.


--
-- Data for Name: album; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.album (album_id, title, type, release_date, artist_id, image_url) FROM stdin;
1	I NEVER LIKED YOU	studio	2022-04-29	1	https://i.scdn.co/image/ab67616d0000b2731692599c8c0f98e470c68106
2	ASTROWORLD	studio	2018-08-03	2	https://i.scdn.co/image/ab67616d0000b273daec894c14c0ca42d76eeb32
3	Luv Is Rage 2	studio	2017-08-25	3	https://i.scdn.co/image/ab67616d0000b273f23aee9d3be9fcbca1bc6352
4	Trip At Knight (Complete Edition)	studio	2021-08-21	4	https://i.scdn.co/image/ab67616d0000b273d01b8867ca76ba7a4c15a9a4
5	Die Lit	studio	2018-05-11	6	https://i.scdn.co/image/ab67616d0000b273a1e867d40e7bb29ced5c0194
6	DAMN.	studio	2017-04-14	7	https://i.scdn.co/image/ab67616d0000b2738b52c6b9bc4e43d873869699
7	Whole Lotta Red	studio	2020-12-25	6	https://i.scdn.co/image/ab67616d0000b27398ea0e689c91f8fea726d9bb
8	Dark Knight Dummo (Feat. Travis Scott)	single	2017-12-05	4	https://i.scdn.co/image/ab67616d0000b273a71dac1ff25a97b23b416032
9	Dark Lane Demo Tapes	studio	2020-05-01	8	https://i.scdn.co/image/ab67616d0000b273bba7cfaf7c59ff0898acba1f
10	The Melodic Blue	studio	2021-09-22	9	https://i.scdn.co/image/ab67616d0000b2733bcf586e8df6f8ef4a36ca3c
11	Donda	studio	2021-08-29	10	https://i.scdn.co/image/ab67616d0000b273cad190f1a73c024e5a40dddd
12	UTOPIA	studio	2023-07-28	2	https://i.scdn.co/image/ab67616d0000b27304481c826dd292e5e4983b3f
13	a Gift & a Curse	studio	2023-06-16	14	https://i.scdn.co/image/ab67616d0000b2731e0b04676fae1205f4853706
14	Mr. Morale & The Big Steppers	studio	2022-05-13	7	https://i.scdn.co/image/ab67616d0000b2732e02117d76426a08ac7c174f
15	NOT ALL HEROES WEAR CAPES (Deluxe)	studio	2018-11-06	17	https://i.scdn.co/image/ab67616d0000b2732887f8c05b5a9f1cb105be29
16	Rodeo	studio	2015-09-04	2	https://i.scdn.co/image/ab67616d0000b273d3b5affd8824b4ed301b7137
17	Playboi Carti	studio	2017-04-14	6	https://i.scdn.co/image/ab67616d0000b273e31a279d267f3b3d8912e6f1
18	i am > i was	studio	2018-12-21	13	https://i.scdn.co/image/ab67616d0000b2731afd2e526e3723dd4a9fb4c8
19	SAVAGE MODE II	studio	2020-10-02	13	https://i.scdn.co/image/ab67616d0000b2736a7e6ceda5e779fbb6ec1ba8
20	DIE FOR MY BITCH	studio	2019-07-19	9	https://i.scdn.co/image/ab67616d0000b273683757f1fd40a7f7ef64bec1
21	good kid, m.A.A.d city	studio	2012-01-01	7	https://i.scdn.co/image/ab67616d0000b2732cd55246d935a8a77cb4859e
22	SR3MM	studio	2018-05-04	23	https://i.scdn.co/image/ab67616d0000b27342bb10c2f8224e5c11e4aa92
23	JACKBOYS	studio	2019-12-27	26	https://i.scdn.co/image/ab67616d0000b273b920fc01c37be38130418a34
24	Pink Tape	studio	2023-06-30	3	https://i.scdn.co/image/ab67616d0000b273d7f97f84ffeaf2077813ef24
25	IGOR	studio	2019-05-17	30	https://i.scdn.co/image/ab67616d0000b27330a635de2bb0caa4e26f6abb
26	For All The Dogs	studio	2023-10-06	8	https://i.scdn.co/image/ab67616d0000b2737d384516b23347e92a587ed1
27	Life of a DON	studio	2021-10-08	28	https://i.scdn.co/image/ab67616d0000b27372951fef63d89bee5e8224c7
28	B4 The Storm	studio	2020-08-28	32	https://i.scdn.co/image/ab67616d0000b273c4adc981dc6656e52c916088
29	i am > i was (Deluxe)	studio	2018-12-24	13	https://i.scdn.co/image/ab67616d0000b273cce1ca6942d29857e254043d
30	HNDRXX	studio	2017-07-27	1	https://i.scdn.co/image/ab67616d0000b2737567ec7d3c07783e4f2111e0
31	Immortal	single	2019-10-31	13	https://i.scdn.co/image/ab67616d0000b273bf9b0593804f19a707f8fd61
32	Luv Is Rage 2 (Deluxe)	studio	2017-11-17	3	https://i.scdn.co/image/ab67616d0000b273d7e1c68ed8e464b03095afda
33	FUTURE	studio	2017-06-30	1	https://i.scdn.co/image/ab67616d0000b273e0b64c8be3c4e804abcb2696
34	Trip At Knight	studio	2021-08-20	4	https://i.scdn.co/image/ab67616d0000b2733552d176c46bba8463024495
35	née-nah	single	2024-01-10	13	https://i.scdn.co/image/ab67616d0000b2735dff65aa66b221b03aa3506b
36	american dream	studio	2024-01-12	13	https://i.scdn.co/image/ab67616d0000b2731e146244cf70b7aab703c057
37	Birds In The Trap Sing McKnight	studio	2016-09-16	2	https://i.scdn.co/image/ab67616d0000b2738752a7355996e64709247c53
38	VULTURES 1	studio	2024-02-09	45	https://i.scdn.co/image/ab67616d0000b2730a31b4026a452ae8c3f97a76
39	WE DON'T TRUST YOU	studio	2024-03-22	1	https://i.scdn.co/image/ab67616d0000b273cec3fc072352b5f4f637d9fa
40	DAYS BEFORE RODEO	studio	2014-08-18	2	https://i.scdn.co/image/ab67616d0000b273a2a7386de6494fc9275e1abb
41	SET IT OFF	studio	2023-10-13	49	https://i.scdn.co/image/ab67616d0000b2738473cdc72d9c6f9a2787e070
42	THE SCOTTS	single	2020-04-24	50	https://i.scdn.co/image/ab67616d0000b27309db38c6c41528684f6ca6a7
43	Down In Atlanta	single	2022-11-18	52	https://i.scdn.co/image/ab67616d0000b2739c3bd14ef94886822d576396
44	Faith Of A Mustard Seed	studio	2024-07-26	53	https://i.scdn.co/image/ab67616d0000b273859800419c1d986dfc6caff7
\.


--
-- Data for Name: artist; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.artist (artist_id, name, country, type, image_url) FROM stdin;
1	Future	US	solo	https://i.scdn.co/image/ab6761610000e5eb7565b356bc9d9394eefa2ccb
2	Travis Scott	US	solo	https://i.scdn.co/image/ab6761610000e5eb19c2790744c792d05570bb71
3	Lil Uzi Vert	US	solo	https://i.scdn.co/image/ab6761610000e5eb62c272d76220f2e9dad56704
4	Trippie Redd	US	solo	https://i.scdn.co/image/ab6761610000e5ebf2db81b3312a1f167fc54096
5	XXXTENTACION	US	solo	https://i.scdn.co/image/ab6761610000e5ebf0c20db5ef6c6fbe5135d2e4
6	Playboi Carti	US	solo	https://i.scdn.co/image/ab6761610000e5ebba50ca67ffc3097f6ea1710a
7	Kendrick Lamar	US	solo	https://i.scdn.co/image/ab6761610000e5eb39ba6dcd4355c03de0b50918
8	Drake	CA	solo	https://i.scdn.co/image/ab6761610000e5eb4293385d324db8558179afd9
9	Baby Keem	US	solo	https://i.scdn.co/image/ab6761610000e5ebe45a6e4cee2ef5f4c0fec713
10	Kanye West	GB	solo	https://i.scdn.co/image/ab6761610000e5eb6e835a500e791bf9c27a422a
11	SZA	US	solo	https://i.scdn.co/image/ab6761610000e5ebfd0a9fb6c252a3ba44079acf
12	James Blake	DE	solo	https://i.scdn.co/image/ab6761610000e5ebeea5ea7752893d8898dbd163
13	21 Savage	US	solo	https://i.scdn.co/image/ab6761610000e5eb4f8f76117470957c0e81e5b2
14	Gunna	US	solo	https://i.scdn.co/image/ab6761610000e5eba998bc86f87b9fe7e2466110
15	Sam Dew	US	solo	https://i.scdn.co/image/ab6761610000e5eb51ecfd1ae9e8e2c1ba5e6e85
16	Tanna Leone	Los Angeles	solo	https://i.scdn.co/image/ab6761610000e5eb0c9f7a40780df6c42cc3b82d
17	Metro Boomin	US	solo	https://i.scdn.co/image/ab6761610000e5eb28f1e72b31e756ea3f3a51e7
18	Kacy Hill	US	solo	https://i.scdn.co/image/ab6761610000e5ebb4f780d4b377adb07c8b16dd
19	Juicy J	GB	solo	https://i.scdn.co/image/ab6761610000e5eb116fc50265ef72d7e66723a5
20	Justin Bieber	CA	solo	https://i.scdn.co/image/ab6761610000e5ebaf20f7db5288bce9beede034
21	Young Thug	CA	solo	https://i.scdn.co/image/ab6761610000e5eb9f2fb33940aac624dc5d100d
22	Jay Rock	US	solo	https://i.scdn.co/image/ab6761610000e5eb9c48431caf52a2d0f38433ff
23	Rae Sremmurd	US	solo	https://i.scdn.co/image/ab6761610000e5ebca1568791bf7ac0cf34dbc66
24	Swae Lee	US	solo	https://i.scdn.co/image/ab6761610000e5ebbccdbb98ab5d54454cd0fe85
25	Slim Jxmmi	Unknown	solo	https://i.scdn.co/image/ab6761610000e5eb0f8d832dfa56744c867179c8
26	JACKBOYS	US	solo	https://i.scdn.co/image/ab6761610000e5eb440b705481183f0ddaa521d7
27	Sheck Wes	US	solo	https://i.scdn.co/image/ab6761610000e5ebf8728bd0c78cf9df934e17a4
28	Don Toliver	US	solo	https://i.scdn.co/image/ab6761610000e5ebc52b798deb89eb8414a51b7b
29	The Weeknd	CA	solo	https://i.scdn.co/image/ab6761610000e5ebc1719ac9e6a75c1c25835018
30	Tyler, The Creator	US	solo	https://i.scdn.co/image/ab6761610000e5ebdf2728294ff77dd11eeb18fb
31	J. Cole	GB	solo	https://i.scdn.co/image/ab6761610000e5ebc401ea77e86ee984b1ba9fc2
32	Internet Money	US	solo	https://i.scdn.co/image/ab6761610000e5eb30cc15d302e22803fcb5ad34
33	NAV	CA	solo	https://i.scdn.co/image/ab6761610000e5ebf2f2bac430fcc17842ce69a6
34	Quavo	US	solo	https://i.scdn.co/image/ab6761610000e5ebd52229f479361a2375f6021c
35	2 Chainz	US	solo	https://i.scdn.co/image/ab6761610000e5ebf556662d187b9191c421be1c
36	Chief Keef	US	solo	https://i.scdn.co/image/ab6761610000e5ebe816aaf5f96c04fdfa8fadc7
37	Rob49	US	solo	https://i.scdn.co/image/ab6761610000e5eb84205494615587fd24e917ff
38	Yung Lean	SE	solo	https://i.scdn.co/image/ab6761610000e5eb9203ea92f4c538f41e6eea8c
39	Dave Chappelle	US	solo	https://i.scdn.co/image/ab6761610000e5eb342f9f48ebc8abd33c825d0f
40	Westside Gunn	Buffalo	solo	https://i.scdn.co/image/ab6761610000e5eb5c37923fb58eead7ad4c0f1f
41	Bryson Tiller	US	solo	https://i.scdn.co/image/ab6761610000e5ebb0ff28b9d4bed74c66901b2b
42	Doja Cat	US	solo	https://i.scdn.co/image/ab6761610000e5eb8a0644455ebfa7d3976f5101
43	Brent Faiyaz	US	solo	https://i.scdn.co/image/ab6761610000e5eb582fbf712f5b6a9bf65d9b84
44	Yeat	US	solo	https://i.scdn.co/image/ab6761610000e5eb3cb51ac0d2a735316c536315
45	¥$	US	solo	https://i.scdn.co/image/ab6761610000e5eba670555775b5381ac0519658
46	Ty Dolla $ign	US	solo	https://i.scdn.co/image/ab6761610000e5eb4ef6e245168c33922bc6df1a
47	Rich The Kid	US	solo	https://i.scdn.co/image/ab6761610000e5eb1002e85418167bb8c6916783
48	Rihanna	US	solo	https://i.scdn.co/image/ab6761610000e5ebcb565a8e684e3be458d329ac
49	Offset	US	solo	https://i.scdn.co/image/ab6761610000e5eb0f794f3394223026afa7776d
50	THE SCOTTS	GB	solo	https://i.scdn.co/image/ab6761610000e5ebd51dd9e8a876c829dedcc8d1
51	Kid Cudi	US	solo	https://i.scdn.co/image/ab6761610000e5eb5f00bb6dd7a7008d14156630
52	Pharrell Williams	US	solo	https://i.scdn.co/image/ab6761610000e5ebf0789cd783c20985ec3deb4e
53	Mustard	US	solo	https://i.scdn.co/image/ab6761610000e5eb54406b7007a449aeaac06c44
\.


--
-- Data for Name: credits; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.credits (artist_id, song_id, role) FROM stdin;
1	1	vocalist
2	2	vocalist
2	3	vocalist
2	4	vocalist
3	5	vocalist
4	6	vocalist
5	6	featured vocalist
2	7	vocalist
6	8	vocalist
7	9	vocalist
6	10	vocalist
6	11	vocalist
6	12	vocalist
4	13	vocalist
2	13	featured vocalist
2	14	vocalist
8	15	vocalist
9	16	vocalist
6	17	vocalist
10	18	vocalist
2	19	vocalist
2	20	vocalist
11	20	featured vocalist
1	20	featured vocalist
2	21	vocalist
12	21	featured vocalist
13	21	featured vocalist
2	22	vocalist
6	22	featured vocalist
2	23	vocalist
2	24	vocalist
6	25	vocalist
6	26	vocalist
1	26	featured vocalist
6	27	vocalist
6	28	vocalist
6	29	vocalist
14	30	vocalist
7	31	vocalist
7	32	vocalist
7	33	vocalist
7	34	vocalist
9	34	featured vocalist
15	34	featured vocalist
7	35	vocalist
16	35	featured vocalist
17	36	vocalist
2	36	featured vocalist
2	37	vocalist
18	37	featured vocalist
2	38	vocalist
6	39	vocalist
6	40	vocalist
6	41	vocalist
2	42	vocalist
13	43	vocalist
13	44	vocalist
17	44	featured vocalist
9	45	vocalist
13	46	vocalist
2	47	vocalist
19	47	featured vocalist
2	48	vocalist
20	48	featured vocalist
21	48	featured vocalist
7	49	vocalist
22	49	featured vocalist
23	50	vocalist
24	50	featured vocalist
25	50	featured vocalist
2	50	featured vocalist
17	51	vocalist
13	51	featured vocalist
6	52	vocalist
13	53	vocalist
17	53	featured vocalist
13	54	vocalist
17	54	featured vocalist
13	55	vocalist
17	55	featured vocalist
8	55	featured vocalist
13	56	vocalist
17	56	featured vocalist
26	57	vocalist
27	57	featured vocalist
3	58	vocalist
2	58	featured vocalist
26	59	vocalist
2	59	featured vocalist
28	59	featured vocalist
2	60	vocalist
29	60	featured vocalist
24	60	featured vocalist
2	61	vocalist
26	62	vocalist
2	62	featured vocalist
21	62	featured vocalist
30	63	vocalist
8	64	vocalist
31	64	featured vocalist
28	65	vocalist
2	65	featured vocalist
3	66	vocalist
28	66	featured vocalist
32	67	vocalist
14	67	featured vocalist
28	67	featured vocalist
33	67	featured vocalist
13	68	vocalist
13	69	vocalist
13	70	vocalist
13	71	vocalist
13	72	vocalist
13	73	vocalist
13	74	vocalist
2	75	vocalist
2	76	vocalist
2	77	vocalist
2	78	vocalist
13	79	vocalist
2	80	vocalist
2	81	vocalist
2	82	vocalist
2	83	vocalist
34	83	featured vocalist
2	84	vocalist
1	84	featured vocalist
35	84	featured vocalist
2	85	vocalist
24	85	featured vocalist
36	85	featured vocalist
2	86	vocalist
10	86	featured vocalist
2	87	vocalist
2	88	vocalist
2	89	vocalist
2	90	vocalist
29	90	featured vocalist
2	91	vocalist
2	92	vocalist
2	93	vocalist
2	94	vocalist
2	95	vocalist
8	95	featured vocalist
2	96	vocalist
2	97	vocalist
37	97	featured vocalist
13	97	featured vocalist
2	98	vocalist
38	98	featured vocalist
39	98	featured vocalist
2	99	vocalist
21	99	featured vocalist
2	100	vocalist
40	100	featured vocalist
1	101	vocalist
30	102	vocalist
30	103	vocalist
13	104	vocalist
9	105	vocalist
7	105	featured vocalist
3	106	vocalist
1	107	vocalist
4	108	vocalist
6	108	featured vocalist
13	109	vocalist
2	109	featured vocalist
17	109	featured vocalist
6	110	vocalist
41	110	featured vocalist
13	111	vocalist
13	112	vocalist
13	113	vocalist
42	113	featured vocalist
13	114	vocalist
21	114	featured vocalist
17	114	featured vocalist
13	115	vocalist
2	115	featured vocalist
17	115	featured vocalist
13	116	vocalist
43	116	featured vocalist
8	117	vocalist
44	117	featured vocalist
2	118	vocalist
13	119	vocalist
17	119	featured vocalist
21	119	featured vocalist
13	120	vocalist
17	120	featured vocalist
2	121	vocalist
2	122	vocalist
9	123	vocalist
9	124	vocalist
9	125	vocalist
9	126	vocalist
2	126	featured vocalist
9	127	vocalist
9	128	vocalist
45	129	vocalist
10	129	featured vocalist
46	129	featured vocalist
47	129	featured vocalist
6	129	featured vocalist
1	130	vocalist
17	130	featured vocalist
1	131	vocalist
17	131	featured vocalist
29	131	featured vocalist
1	132	vocalist
17	132	featured vocalist
2	132	featured vocalist
6	132	featured vocalist
1	133	vocalist
17	133	featured vocalist
7	133	featured vocalist
1	134	vocalist
17	134	featured vocalist
1	135	vocalist
17	135	featured vocalist
2	135	featured vocalist
1	136	vocalist
1	137	vocalist
29	137	featured vocalist
1	138	vocalist
48	138	featured vocalist
45	139	vocalist
10	139	featured vocalist
46	139	featured vocalist
2	140	vocalist
49	141	vocalist
2	141	featured vocalist
50	142	vocalist
2	142	featured vocalist
51	142	featured vocalist
52	143	vocalist
2	143	featured vocalist
53	144	vocalist
2	144	featured vocalist
\.


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.review (user_id, song_id, rating) FROM stdin;
2	1	1
5	1	2
4	1	2
9	1	1
10	1	4
1	2	1
4	2	2
9	2	5
9	3	2
7	3	2
8	3	5
1	4	2
7	4	3
5	4	2
4	4	3
2	5	4
6	5	3
10	5	3
8	6	5
2	6	4
9	6	3
10	7	3
4	7	1
1	7	2
5	7	1
2	7	4
8	8	3
3	8	3
6	8	2
5	8	1
3	9	5
4	9	2
8	9	4
5	9	5
6	9	1
1	10	3
7	10	3
2	10	2
6	11	2
8	11	4
3	11	3
4	11	5
9	11	3
10	12	4
7	12	3
4	12	2
9	12	4
2	12	1
3	13	2
7	13	5
2	13	4
10	14	4
9	14	3
1	14	1
5	14	3
5	15	4
3	15	4
1	15	3
3	16	5
2	16	3
9	16	5
4	16	2
6	16	2
9	17	1
10	17	3
8	17	1
2	17	3
5	17	2
4	18	5
2	18	1
8	18	1
3	19	2
8	19	5
5	19	5
10	19	4
4	19	5
4	20	3
7	20	3
8	20	5
2	20	2
6	20	1
9	21	2
10	21	2
1	21	1
4	21	1
6	21	1
4	22	3
8	22	2
9	22	2
10	22	5
7	22	2
2	23	4
6	23	4
7	23	4
1	24	1
7	24	3
2	24	2
4	24	2
9	24	4
7	25	2
5	25	4
4	25	1
9	26	1
1	26	5
2	26	2
3	26	4
8	27	2
7	27	1
3	27	4
1	27	4
8	28	3
7	28	5
3	28	2
5	28	2
10	29	5
1	29	3
8	29	5
3	30	1
9	30	1
2	30	5
4	30	4
10	30	2
10	31	1
2	31	4
9	31	3
5	31	2
6	31	2
7	32	2
5	32	4
6	32	1
1	32	4
10	33	1
2	33	5
4	33	5
5	33	2
6	33	1
6	34	3
3	34	4
9	34	3
9	35	1
5	35	1
3	35	3
2	35	1
10	35	2
6	36	2
5	36	5
8	36	3
1	36	1
7	36	3
1	37	3
3	37	3
8	37	5
7	38	5
1	38	1
2	38	2
9	38	1
6	38	5
3	39	4
1	39	3
6	39	1
4	39	2
2	39	3
7	40	5
3	40	2
1	40	2
6	40	4
4	40	3
2	41	4
1	41	4
4	41	2
6	42	3
4	42	2
1	42	2
7	42	3
2	43	3
6	43	5
7	43	5
1	43	1
3	44	5
5	44	1
2	44	5
7	44	3
6	45	4
10	45	5
2	45	4
4	45	3
1	45	4
9	46	5
4	46	3
7	46	1
6	47	5
2	47	3
9	47	3
7	47	3
5	47	5
4	48	4
7	48	2
10	48	5
7	49	5
1	49	3
5	49	2
10	49	5
6	50	4
8	50	4
4	50	5
3	50	1
5	50	5
10	51	3
2	51	2
5	51	2
4	51	2
1	51	1
8	52	5
2	52	4
7	52	5
7	53	4
4	53	2
1	53	1
4	54	2
9	54	4
1	54	5
2	54	4
8	55	5
9	55	5
6	55	4
9	56	4
8	56	2
5	56	2
4	56	3
2	56	3
5	57	3
6	57	5
2	57	2
4	58	4
3	58	2
2	58	4
6	59	5
8	59	4
1	59	2
7	59	4
1	60	5
7	60	4
6	60	3
9	60	5
10	60	2
4	61	3
7	61	4
1	61	4
6	61	4
3	62	4
10	62	5
1	62	4
2	62	4
8	62	2
5	63	4
6	63	2
8	63	3
7	64	3
5	64	1
8	64	1
9	64	1
4	65	1
1	65	1
10	65	2
3	65	4
2	66	5
4	66	4
5	66	3
3	66	5
10	66	1
5	67	1
10	67	1
7	67	4
4	68	1
10	68	2
2	68	3
1	68	3
9	68	4
6	69	1
9	69	3
1	69	4
8	69	1
7	69	3
8	70	2
7	70	2
9	70	3
10	70	5
5	70	3
2	71	3
8	71	2
10	71	5
7	72	3
1	72	4
6	72	2
8	72	2
5	72	3
10	73	3
9	73	1
4	73	1
7	73	4
4	74	4
8	74	4
1	74	1
5	74	2
7	74	2
10	75	3
8	75	5
9	75	3
7	75	5
6	76	4
5	76	3
4	76	1
2	76	5
3	77	2
4	77	4
5	77	5
9	77	5
2	77	2
4	78	3
3	78	3
1	78	5
5	78	1
9	79	3
3	79	4
2	79	1
5	80	4
8	80	4
6	80	2
1	80	3
2	80	1
8	81	1
10	81	1
3	81	2
5	81	1
2	82	5
7	82	5
10	82	5
9	83	4
8	83	4
5	83	5
5	84	5
10	84	1
2	84	2
4	84	3
2	85	2
4	85	2
9	85	1
3	85	1
7	85	4
10	86	4
5	86	1
4	86	3
8	86	1
7	86	1
4	87	2
5	87	2
2	87	1
3	87	3
10	87	5
8	88	1
5	88	4
9	88	5
2	88	5
7	89	3
10	89	3
1	89	1
10	90	5
1	90	3
3	90	4
8	91	3
3	91	5
7	91	4
2	91	4
6	91	4
6	92	1
3	92	3
7	92	4
5	92	4
1	93	4
2	93	3
5	93	3
7	93	5
9	93	4
1	94	2
9	94	3
10	94	4
8	94	1
5	95	5
3	95	3
8	95	4
1	96	5
4	96	2
5	96	5
9	97	4
2	97	2
8	97	1
3	98	4
5	98	5
7	98	4
8	98	2
9	98	2
4	99	5
9	99	2
2	99	3
7	99	3
5	100	1
10	100	5
8	100	2
9	100	4
6	100	3
9	101	4
8	101	3
4	101	2
10	101	4
7	101	1
8	102	4
7	102	2
1	102	2
9	102	5
2	103	4
9	103	4
1	103	2
7	103	2
8	104	3
6	104	5
7	104	1
9	105	4
6	105	4
1	105	5
2	105	2
5	106	2
2	106	4
8	106	2
1	106	1
6	106	1
6	107	3
7	107	2
4	107	5
10	107	2
3	108	1
10	108	4
4	108	4
3	109	2
8	109	3
5	109	1
9	109	2
2	109	4
10	110	3
7	110	3
8	110	3
4	110	4
2	111	2
7	111	5
6	111	5
5	111	3
7	112	3
1	112	5
10	112	4
4	113	5
6	113	2
10	113	3
3	113	1
1	114	3
8	114	1
10	114	3
3	114	1
5	114	3
7	115	2
4	115	2
9	115	3
5	115	2
8	115	3
6	116	1
8	116	1
3	116	2
7	116	5
2	116	4
5	117	5
2	117	4
6	117	3
7	118	3
2	118	2
8	118	1
10	118	5
6	118	5
2	119	4
5	119	4
3	119	1
5	120	4
2	120	1
4	120	5
7	121	4
6	121	5
10	121	2
2	122	4
10	122	4
5	122	1
6	122	2
8	123	2
6	123	1
9	123	3
1	123	4
4	124	1
8	124	1
10	124	1
1	124	3
3	125	5
4	125	1
9	125	2
4	126	2
6	126	2
10	126	1
5	126	2
3	126	5
3	127	1
1	127	2
6	127	2
10	127	3
3	128	3
1	128	2
7	128	5
2	129	4
8	129	3
9	129	5
8	130	5
4	130	5
1	130	5
8	131	1
1	131	4
7	131	4
2	131	4
8	132	1
2	132	3
10	132	2
3	132	3
9	132	3
10	133	5
5	133	4
9	133	5
7	133	1
2	134	5
4	134	4
8	134	2
7	134	3
6	134	4
5	135	3
3	135	4
2	135	1
7	135	1
6	136	2
9	136	1
10	136	5
2	136	4
7	136	1
10	137	3
6	137	1
9	137	2
3	137	4
2	138	3
9	138	3
5	138	5
7	139	5
10	139	5
9	139	1
5	140	1
3	140	3
6	140	3
1	140	2
10	140	4
3	141	1
2	141	5
4	141	4
8	142	3
3	142	3
5	142	3
10	142	5
1	143	2
3	143	5
2	143	3
7	144	4
10	144	4
5	144	2
9	144	1
\.


--
-- Data for Name: song; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.song (song_id, title, duration, album_id, track_number) FROM stdin;
1	712PM	2:53	1	1
2	HOUSTONFORNICATION	3:37	2	16
3	STARGAZING	4:30	2	1
4	BUTTERFLY EFFECT	3:10	2	15
5	XO Tour Llif3	3:02	3	16
6	Danny Phantom (feat. XXXTENTACION)	2:16	4	13
7	5% TINT	3:16	2	9
8	Long Time - Intro	3:31	5	1
9	HUMBLE.	2:57	6	8
10	Sky	3:13	7	19
11	Rockstar Made	3:13	7	1
12	New Tank	1:29	7	9
13	Dark Knight Dummo (Feat. Travis Scott)	4:16	8	1
14	SICKO MODE	5:12	2	3
15	War	3:00	9	14
16	hooligan	2:36	10	2
17	R.I.P.	3:12	5	2
18	Off The Grid	5:39	11	4
19	SIRENS	3:24	12	6
20	TELEKINESIS (feat. SZA & Future)	5:53	12	18
21	TIL FURTHER NOTICE (feat. James Blake & 21 Savage)	5:14	12	19
22	FE!N (feat. Playboi Carti)	3:11	12	8
23	CAN'T SAY	3:18	2	13
24	NO BYSTANDERS	3:38	2	6
25	Die4Guy	2:11	7	22
26	Teen X (feat. Future)	3:25	7	10
27	Over	2:46	7	20
28	F33l Lik3 Dyin	3:24	7	24
29	ILoveUIHateU	2:15	7	21
30	fukumean	2:05	13	6
31	N95	3:15	14	2
32	United In Grief	4:15	14	1
33	Count Me Out	4:43	14	1
34	Savior	3:44	14	5
35	Mr. Morale	3:30	14	7
36	Overdue (with Travis Scott)	2:46	15	2
37	90210 (feat. Kacy Hill)	5:39	16	5
38	Antidote	4:22	16	9
39	Magnolia	3:01	17	2
40	Location	2:48	17	1
41	Vamp Anthem	2:04	7	12
42	ASTROTHUNDER	2:22	2	11
43	can't leave without it	3:25	18	8
44	Runnin	3:15	19	2
45	ORANGE SODA	2:09	20	12
46	ball w/o you	3:15	18	10
47	Wasted (feat. Juicy J)	3:55	16	4
48	Maria I'm Drunk (feat. Justin Bieber & Young Thug)	5:49	16	11
49	Money Trees	6:26	21	5
50	CLOSE (feat. Travis Scott) - From SR3MM	3:13	22	2
51	Don't Come Out The House (with 21 Savage)	2:48	15	3
52	Foreign	2:22	5	11
53	RIP Luv	3:34	19	14
54	Glock In My Lap	3:13	19	3
55	Mr. Right Now (feat. Drake)	3:13	19	4
56	Said N Done	3:51	19	15
57	GANG GANG	4:04	23	3
58	Aye (feat. Travis Scott)	3:27	24	3
59	WHAT TO DO? (feat. Don Toliver)	4:10	23	6
60	CIRCUS MAXIMUS (feat. The Weeknd & Swae Lee)	4:18	12	12
61	Impossible	4:02	16	10
62	OUT WEST (feat. Young Thug)	2:37	23	5
63	EARFQUAKE	3:10	25	2
64	First Person Shooter (feat. J. Cole)	4:07	26	6
65	Flocky Flocky (feat. Travis Scott)	3:03	27	4
66	Patience (feat. Don Toliver)	4:22	24	20
67	Lemonade (feat. NAV)	3:15	28	17
68	a lot	4:48	29	1
69	can't leave without it	3:25	29	8
70	asmr	2:51	29	9
71	pad lock	3:11	29	12
72	monster	3:53	29	13
73	4L	4:48	29	15
74	ball w/o you	3:15	29	10
75	STOP TRYING TO BE GOD	5:38	2	5
76	CAROUSEL	3:00	2	2
77	R.I.P. SCREW	3:05	2	4
78	YOSEMITE	2:30	2	12
79	monster	3:53	18	13
80	NC-17	2:36	2	10
81	COFFEE BEAN	3:29	2	17
82	Pornography	3:51	16	1
83	Oh My Dis Side (feat. Quavo)	5:51	16	2
84	3500 (feat. Future & 2 Chainz)	7:41	16	3
85	Nightcrawler (feat. Swae Lee & Chief Keef)	5:21	16	7
86	Piss On Your Grave (feat. Kanye West)	2:46	16	8
87	I Can Tell	3:55	16	13
88	Apple Pie	3:39	16	14
89	Never Catch Me	2:56	16	16
90	Pray 4 Love (feat. The Weeknd)	5:07	16	6
91	HYAENA	3:42	12	1
92	THANK GOD	3:04	12	2
93	MY EYES	4:11	12	4
94	GOD'S COUNTRY	2:07	12	5
95	MELTDOWN (feat. Drake)	4:06	12	7
96	I KNOW ?	3:31	12	10
97	TOPIA TWINS (feat. Rob49 & 21 Savage)	3:43	12	11
98	PARASAIL (feat. Yung Lean & Dave Chappelle)	2:34	12	13
99	SKITZO (feat. Young Thug)	6:06	12	14
100	LOST FOREVER (feat. Westside Gunn)	2:43	12	15
101	Solo	4:25	30	16
102	NEW MAGIC WAND	3:15	25	6
103	ARE WE STILL FRIENDS?	4:25	25	12
104	Immortal	4:14	31	1
105	family ties (with Kendrick Lamar)	4:12	10	10
106	20 Min	3:40	32	20
107	Mask Off	3:24	33	7
108	Miss The Rage	3:56	34	6
109	née-nah	3:40	35	1
110	Fell In Luv (feat. Bryson Tiller)	3:26	5	10
111	all of me	3:18	36	2
112	redrum	4:30	36	3
113	n.h.i.e.	2:23	36	4
114	pop ur shit	3:13	36	6
115	née-nah	3:40	36	9
116	should've wore a bonnet	3:06	36	12
117	IDGAF (feat. Yeat)	4:20	26	7
118	SKELETONS	2:25	2	7
119	Rich Nigga Shit (feat. Young Thug)	3:10	19	5
120	Many Men	3:21	19	7
121	coordinate	3:46	37	3
122	lose	3:20	37	12
123	16	2:36	10	16
124	trademark usa	4:30	10	1
125	scars	4:26	10	11
126	durag activity (with Travis Scott)	3:44	10	12
127	no sense	2:53	10	3
128	vent	2:16	10	15
129	CARNIVAL	4:24	38	12
130	We Don't Trust You	3:46	39	1
131	Young Metro	3:25	39	2
132	Type Shit	3:48	39	4
133	Like That	4:27	39	6
134	Slimed In	3:14	39	7
135	Cinderella	2:49	39	9
136	My Collection	4:15	30	1
137	Comin Out Strong (feat. The Weeknd)	4:14	30	2
138	Selfish (feat. Rihanna)	4:11	30	15
139	BURN	1:51	38	9
140	Drugs You Should Try It	3:28	40	4
141	SAY MY GRACE (feat. Travis Scott)	2:53	41	2
142	THE SCOTTS	2:45	42	1
143	Down In Atlanta	2:44	43	1
144	Parking Lot	2:52	44	5
\.


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (user_id);


--
-- Name: album album_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_pkey PRIMARY KEY (album_id);


--
-- Name: artist artist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist
    ADD CONSTRAINT artist_pkey PRIMARY KEY (artist_id);


--
-- Name: credits credits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credits
    ADD CONSTRAINT credits_pkey PRIMARY KEY (artist_id, song_id);


--
-- Name: review review_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (user_id, song_id);


--
-- Name: song song_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song
    ADD CONSTRAINT song_pkey PRIMARY KEY (song_id);


--
-- Name: album album_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artist(artist_id);


--
-- Name: credits credits_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credits
    ADD CONSTRAINT credits_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artist(artist_id);


--
-- Name: credits credits_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credits
    ADD CONSTRAINT credits_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.song(song_id);


--
-- Name: review review_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.song(song_id);


--
-- Name: review review_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: song song_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song
    ADD CONSTRAINT song_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(album_id);


--
-- PostgreSQL database dump complete
--

\unrestrict AucTtIBTbj2w7DFee9KcbNbHCWWJDGDK5mEkjVd9N9dDsBAtaIIcyjtkRLQ9ymV

