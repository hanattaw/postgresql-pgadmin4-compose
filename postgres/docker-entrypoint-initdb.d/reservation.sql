-- Database: reservation

DROP DATABASE IF EXISTS sailor_reservation;

CREATE DATABASE sailor_reservation;

\connect sailor_reservation;

-- Table: public.sailors

DROP TABLE IF EXISTS public.sailors;

CREATE TABLE IF NOT EXISTS public.sailors
(
    sid integer NOT NULL,
    sname character varying(30),
    rating integer,
    age numeric(3,1),
    CONSTRAINT sid_pkey PRIMARY KEY (sid),
    CONSTRAINT sailors_rating_check CHECK (rating >= 1 AND rating <= 10)

);

-- Table: public.boats

DROP TABLE IF EXISTS public.boats;

CREATE TABLE IF NOT EXISTS public.boats
(
    bid integer NOT NULL,
    bname character varying(30),
    color character varying(30),
    CONSTRAINT boats_pkey PRIMARY KEY (bid)
);

-- Table: public.reserves

DROP TABLE IF EXISTS public.reserves;

CREATE TABLE IF NOT EXISTS public.reserves
(
    sid integer NOT NULL,
    bid integer NOT NULL,
    day date NOT NULL,
    CONSTRAINT reserves_pkey PRIMARY KEY (sid, bid),
    CONSTRAINT foreign_boats_bid FOREIGN KEY (bid)
        REFERENCES public.boats (bid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT foreign_sailors_sid FOREIGN KEY (sid)
        REFERENCES public.sailors (sid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
;

--
-- TOC entry 3333 (class 0 OID 16390)
-- Dependencies: 214
-- Data for Name: sailors; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sailors (sid, sname, rating, age) VALUES (22, 'Dustin', 7, 45.0);
INSERT INTO public.sailors (sid, sname, rating, age) VALUES (29, 'Brutus', 1, 33.0);
INSERT INTO public.sailors (sid, sname, rating, age) VALUES (31, 'Lubber', 8, 55.5);
INSERT INTO public.sailors (sid, sname, rating, age) VALUES (32, 'Andy', 8, 25.5);
INSERT INTO public.sailors (sid, sname, rating, age) VALUES (58, 'Rusty', 10, 35.0);
INSERT INTO public.sailors (sid, sname, rating, age) VALUES (64, 'Horatio', 7, 35.0);
INSERT INTO public.sailors (sid, sname, rating, age) VALUES (71, 'Zorba', 10, 16.0);
INSERT INTO public.sailors (sid, sname, rating, age) VALUES (74, 'Horatio', 9, 35.0);
INSERT INTO public.sailors (sid, sname, rating, age) VALUES (85, 'Art', 3, 25.5);
INSERT INTO public.sailors (sid, sname, rating, age) VALUES (95, 'Bob', 3, 63.5);

--
-- TOC entry 3334 (class 0 OID 16395)
-- Dependencies: 215
-- Data for Name: boats; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.boats (bid, bname, color) VALUES (101, 'Interlake', 'blue');
INSERT INTO public.boats (bid, bname, color) VALUES (102, 'Interlake', 'red');
INSERT INTO public.boats (bid, bname, color) VALUES (103, 'Clipper', 'green');
INSERT INTO public.boats (bid, bname, color) VALUES (104, 'Marine', 'red');


--
-- TOC entry 3335 (class 0 OID 16400)
-- Dependencies: 216
-- Data for Name: reserves; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.reserves (sid, bid, day) VALUES (22, 101, '1998-10-10');
INSERT INTO public.reserves (sid, bid, day) VALUES (22, 102, '1998-10-10');
INSERT INTO public.reserves (sid, bid, day) VALUES (22, 103, '1998-08-10');
INSERT INTO public.reserves (sid, bid, day) VALUES (22, 104, '1998-07-10');
INSERT INTO public.reserves (sid, bid, day) VALUES (31, 102, '1998-10-11');
INSERT INTO public.reserves (sid, bid, day) VALUES (31, 103, '1998-06-11');
INSERT INTO public.reserves (sid, bid, day) VALUES (31, 104, '1998-12-11');
INSERT INTO public.reserves (sid, bid, day) VALUES (64, 101, '1998-05-09');
INSERT INTO public.reserves (sid, bid, day) VALUES (64, 102, '1998-08-09');
INSERT INTO public.reserves (sid, bid, day) VALUES (74, 103, '1998-08-09');

-- Table: public.sailors

DROP TABLE IF EXISTS public.young_sailors;

CREATE TABLE IF NOT EXISTS public.young_sailors
(
    sid integer NOT NULL,
    sname character varying(30),
    rating integer,
    age numeric(3,1),
    CONSTRAINT young_sailors_sid_pkey PRIMARY KEY (sid),
    CONSTRAINT young_sailors_rating_check CHECK (rating >= 1 AND rating <= 10)
);

-- FUNCTION: public.young_sailorsupdate()

-- DROP FUNCTION IF EXISTS public.young_sailorsupdate();

CREATE OR REPLACE FUNCTION public.young_sailorsupdate()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
INSERT INTO young_sailors(sid, sname, rating, age)
VALUES(NEW.sid,NEW.sname,NEW.rating,NEW.age);
RETURN NEW;
END;
$BODY$;


-- Trigger: young_sailors_trigger

-- DROP TRIGGER IF EXISTS young_sailors_trigger ON public.sailors;

CREATE TRIGGER young_sailors_trigger
    AFTER INSERT
    ON public.sailors
    FOR EACH ROW
    EXECUTE FUNCTION public.young_sailorsupdate();

