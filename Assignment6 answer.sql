-- Q01 Find all sailors
SELECT sid, sname, rating, age
FROM sailors
;
 sid |  sname  | rating | age  
-----+---------+--------+------
  22 | Dustin  |      7 | 45.0
  29 | Brutus  |      1 | 33.0
  31 | Lubber  |      8 | 55.5
  32 | Andy    |      8 | 25.5
  58 | Rusty   |     10 | 35.0
  64 | Horatio |      7 | 35.0
  71 | Zorba   |     10 | 16.0
  74 | Horatio |      9 | 35.0
  85 | Art     |      3 | 25.5
  95 | Bob     |      3 | 63.5
(10 rows)

-- Q02 Find all reserves.
SELECT sid, bid, day
FROM reserves
;
 sid | bid |    day     
-----+-----+------------
  22 | 101 | 1998-10-10
  22 | 102 | 1998-10-10
  22 | 103 | 1998-08-10
  22 | 104 | 1998-07-10
  31 | 102 | 1998-10-11
  31 | 103 | 1998-06-11
  31 | 104 | 1998-12-11
  64 | 101 | 1998-05-09
  64 | 102 | 1998-08-09
  74 | 103 | 1998-08-09
(10 rows)

-- Q03 Find all boats.
SELECT * FROM boats
;
bid |   bname   | color 
-----+-----------+-------
 101 | Interlake | blue
 102 | Interlake | red
 103 | Clipper   | green
 104 | Marine    | red
(4 rows)

-- Q11 Find all sailors with a rating above 7.
SELECT S.sid, S.sname, S.rating, S.age
FROM sailors AS S
WHERE S.rating >7
;
 sid |  sname  | rating | age  
-----+---------+--------+------
  31 | Lubber  |      8 | 55.5
  58 | Rusty   |     10 | 35.0
  71 | Zorba   |     10 | 16.0
  74 | Horatio |      9 | 35.0
  32 | Andy    |      8 | 25.5
(5 rows)

-- Q16, Q2 Find the sids and names of sailors who has reserved a read boat.
SELECT R.sid
FROM boats B, reserves R
WHERE B.bid=R.bid AND B.color = 'red'
;
 sid 
-----
  22
  22
  31
  64
  31
(5 rows)
-- Q3 Find the colors of boats reserved by Lubber.
SELECT B.color
FROM sailors S, reserves R, boats B
WHERE S.sid=R.sid AND R.bid=B.bid AND S.sname='Lubber'
;
 color 
-------
 red
 green
 red
(3 rows)


-- Q17 Find the names of sailors whow have sailed two different boats on the same day.
SELECT S.sname
FROM sailors S, reserves R1, reserves R2
WHERE S.sid=R1.sid AND S.sid=R2.sid
    AND R1.day=R2.day
    AND R1.bid <> R2.bid
;
 sname  
--------
 Dustin
 Dustin
(2 rows)

-- Q20 Find all sids of sailors who have a rating of 10 or reserved boat 104
SELECT S.sid
FROM sailors s
WHERE S.rating=10
UNION
SELECT R.sid
FROM reserves R
WHERE R.bid=104
;
 sid 
-----
  31
  71
  22
  58
(4 rows)

-- Q21 Find the names of sailors who have hot reserved a red boat
SELECT S.sname
FROM sailors S
WHERE S.sid NOT IN (SELECT R.sid
                    FROM reserves R
                    WHERE R.bid IN (SELECT B.bid
                                    FROM boats B
                                    WHERE B.color = 'red'))
;
  sname  
---------
 Brutus
 Rusty
 Zorba
 Horatio
 Art
 Bob
 Andy
(7 rows)

-- Q28 Count the number of sailors
SELECT COUNT(*)
FROM sailors S 
;
 count 
-------
    10
(1 row)

-- Q29 Count the number of different sailor names
SELECT COUNT(DISTINCT S.sname)
FROM sailors S 
;
 count 
-------
     9
(1 row)

-- Q30 Find the names of sailors who are older than the oldest sailor with a rating of 10
SELECT S.sname
FROM sailors S
WHERE S.age > (SELECT MAX(S2.age)
                FROM sailors S2
                WHERE S2.rating=10)
;
-- or
SELECT S.sname
FROM sailors S 
WHERE S.age  > ALL (SELECT S2.age
                    FROM sailors S2
                    WHERE S2.rating = 10)
;
sname  
--------
 Dustin
 Lubber
 Bob
(3 rows)

SELECT S.sname
FROM sailors S 
WHERE S.age  > ALL (SELECT S2.age
                    FROM sailors S2
                    WHERE S2.rating = 10)
;

-- Q31 Find the age of the youngest sailor for each rating level
SELECT S.rating, MIN (S.age)
FROM sailors S 
GROUP BY S.rating
;
 rating | min  
--------+------
      9 | 35.0
      3 | 25.5
     10 | 16.0
      7 | 35.0
      1 | 33.0
      8 | 25.5
(6 rows)

-- Q32 Find the sage of the youngest sailor who is eligible to vote (i.e., is at least 18 years old) for each rating level with at least two such sailors.
SELECT S.rating, MIN(S.age) AS minage
FROM sailors S 
WHERE S.age >=18
GROUP BY S.rating
HAVING COUNT(*) > 1
;
 rating | minage 
--------+--------
      3 |   25.5
      7 |   35.0
      8 |   25.5
(3 rows)

-- Q33 For each red boat, find the number of reservations for this boat
SELECT B.bid, COUNT(*) AS reservationcount
FROM boats B, reserves R 
WHERE R.bid=B.bid AND B.color = 'red'
GROUP BY B.bid
;
 bid | reservationcount 
-----+------------------
 102 |                3
 104 |                2
(2 rows)


-- Q34 Find the average age of sailors for each rating level that has at least two sailors
SELECT S.rating, AVG(S.age) AS avgage
FROM sailors S 
GROUP BY S.rating
HAVING COUNT(*) > 1
;
 rating |       avgage        
--------+---------------------
      3 | 44.5000000000000000
     10 | 25.5000000000000000
      7 | 40.0000000000000000
      8 | 40.5000000000000000
(4 rows)

-- Q35 Find the average age of sailors who are of voting age (i.e. at least 18 years old) for each rating level that has at least two sailors.
SELECT S.rating, AVG(S.age) AS avgage
FROM sailors S
WHERE S.age >=18
GROUP BY S.rating
HAVING 1 < (SELECT COUNT(*) 
            FROM sailors S2
            WHERE S.rating=S2.rating)
;
 rating |       avgage        
--------+---------------------
      3 | 44.5000000000000000
     10 | 35.0000000000000000
      7 | 40.0000000000000000
      8 | 40.5000000000000000
(4 rows)

-- Q36 Find the average age of sailors who are of voting age (i.e., at least 18 years old) for each rating level that has at least two such sailors
SELECT S.rating, AVG(S.age) AS avgage
FROM sailors S
WHERE S.age >=18
GROUP BY S.rating
HAVING 1 < (SELECT COUNT(*) 
            FROM sailors S2
            WHERE S.rating=S2.rating AND S2.age >=18)
;
 rating |       avgage        
--------+---------------------
      3 | 44.5000000000000000
      7 | 40.0000000000000000
      8 | 40.5000000000000000
(3 rows)



