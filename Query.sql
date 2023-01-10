
-- (1) Find sailors who’ve reserves at least one boat
SELECT S.sid
FROM sailors S, reserves R
WHERE S.sid=R.sid
;

-- (2) Find sid’s of sailors who’ve reserved a red “or” a green boat 
SELECT S.sid
FROM sailors S, boats B, reserves R                               
WHERE S.sid=R.sid AND R.bid=B.bid             
    AND (B.color='red' OR B.color='green');
;

SELECT S.sid
FROM sailors S, boats B, reserves R                               
WHERE S.sid=R.sid AND R.bid=B.bid AND B.color='red'

UNION                               

SELECT S.sid                                                                
FROM sailors S, boats B, reserves R
WHERE S.sid=R.sid AND R.bid=B.bid AND B.color='green'
;

-- (3) Find names of sailors who’ve reserved boat #103: 
SELECT S.sname
FROM sailors S
WHERE S.sid IN (SELECT R.sid
                FROM reserves R
                WHERE R.bid=103)
;

-- (4) EXISTS
SELECT S.sname
FROM sailors S
WHERE EXISTS (SELECT *
                FROM reserves R
                WHERE R.bid=103 AND S.sid=R.sid)
;

-- (5) Find sailors whose rating is greater than that of some sailor called Horatio 
SELECT *
FROM sailors S
WHERE S.rating > ANY (SELECT S2.rating
FROM sailors S2
WHERE S2.sname='Horatio')
;

-- (6) Find sid’s of sailors who’ve reserved both a red and a green boat 
SELECT S.sid, S.sname
FROM sailors S, boats B, reserves R
WHERE S.sid=R.sid AND R.bid=B.bid AND B.color='red'
    AND S.sid IN (SELECT S2.sid
                    FROM sailors S2, boats B2, reserves R2
                    WHERE S2.sid=R2.sid AND R2.bid=B2.bid 
                    AND B2.color='green')
;

SELECT S.sid
FROM sailors S, boats B, reserves R 
WHERE S.sid=R.sid AND R.bid=B.bid
    AND B.color='red'

INTERSECT

SELECT S.sid
FROM sailors S, boats B, reserves R 
WHERE S.sid=R.sid AND R.bid=B.bid
AND B.color='green'
;

-- (7) Find sailors who’ve reserved all boats. 
SELECT S.sname
FROM sailors S
WHERE NOT EXISTS ((SELECT B.bid 
                   FROM boats B)
                   EXCEPT
                   (SELECT R.bid 
                    FROM reserves R 
                    WHERE R.sid=S.sid))
;

SELECT S.sname
FROM sailors S
WHERE NOT EXISTS (SELECT B.bid 
                  FROM boats B 
                  WHERE NOT EXISTS (SELECT R.bid
                                    FROM reserves R 
                                    WHERE R.bid=B.bid AND R.sid=S.sid))
;

-- (8) Find name and age of the oldest sailor(s) 
SELECT S.sname, MAX(S.age)
FROM sailors S   
;

SELECT S.sname, S.age
FROM sailors S
WHERE S.age = (SELECT MAX (S2.age) 
                FROM sailors S2)
;

SELECT S.sname,S.age
FROM sailors S
WHERE (SELECT MAX (S2.age)
        FROM sailors S2) = S.age
;


-- (9) Find the age of the youngest sailor with age ≥ 18, for each rating with at least 2 such sailors
SELECT MIN (S.age)
FROM sailors S
WHERE S.rating = 1
;                                    

SELECT MIN (S.age)
FROM sailors S
WHERE S.rating = 2
; 

SELECT MIN (S.age)
FROM sailors S
WHERE S.rating = 3
;

SELECT MIN (S.age)
FROM sailors S
WHERE S.rating = 4
;

SELECT MIN (S.age)
FROM sailors S
WHERE S.rating = 5
;

SELECT S.*
FROM sailors S
WHERE S.age > 18
;

SELECT S.rating, MIN(S.age)
FROM sailors S
WHERE S.age >= 18
GROUP BY S.rating
;

SELECT S.rating, MIN(S.age), COUNT(*)
FROM sailors S
WHERE S.age >= 18
GROUP BY S.rating
HAVING COUNT(*) > 1
;

SELECT S.rating, MIN(S.age)
FROM sailors S
WHERE S.age >= 18
GROUP BY S.rating
HAVING COUNT(*) > 1
;

-- (10) For each red boat, find the number of reservations for this boat 
SELECT B.bid, COUNT (*) AS scount
FROM sailors S, boats B, reserves R
WHERE S.sid=R.sid
        AND R.bid=B.bid 
        AND B.color='red' 
GROUP BY B.bid
;

-- (11) Find the age of the youngest sailor with age > 18, for each rating with at least 2 sailors (of any age) 
SELECT S.rating, MIN (S.age) FROM sailors S
WHERE S.age > 18
GROUP BY S.rating
HAVING 1 < (SELECT COUNT (*)
            FROM sailors S2
            WHERE S.rating=S2.rating)


-- (12) CREATE young sailors table
CREATE TABLE IF NOT EXISTS public.young_sailors
(
    sid integer NOT NULL,
    sname character varying(30),
    rating integer,
    age numeric(3,1),
    CONSTRAINT young_sailors_sid_pkey PRIMARY KEY (sid),
    CONSTRAINT young_sailors_rating_check CHECK (rating >= 1 AND rating <= 10)
);


-- (13) Function 
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

ALTER FUNCTION public.young_sailorsupdate()
    OWNER TO postgres;


-- (14) Trigger: young_sailors_trigger
-- DROP TRIGGER IF EXISTS young_sailors_trigger ON public.sailors;

CREATE TRIGGER young_sailors_trigger
    AFTER INSERT
    ON public.sailors
    FOR EACH ROW
    EXECUTE FUNCTION public.young_sailorsupdate();


-- (15) Try to insert new sailors
INSERT INTO sailors (sid, sname, rating, age) 
VALUES (111, 'Dang', 1, 30.5)
;

SELECT sid, sname, rating, age
FROM young_sailors
;
