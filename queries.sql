/* Please run these updates first. This will change date type of the asscoiated field names 
from VARCHAR to DATE, which will be easier when working with dates.*/

UPDATE patient
SET dob = STR_TO_DATE(dob, '%m/%d/%Y');
UPDATE employee
SET dob = STR_TO_DATE(dob, '%m/%d/%Y');
UPDATE assigned
SET admit_date = STR_TO_DATE(admit_date, '%m/%d/%Y');
UPDATE assigned
SET discharge_date = STR_TO_DATE(discharge_date, '%m/%d/%Y');
UPDATE checks_in
SET date_ = STR_TO_DATE(date_, '%m/%d/%Y');
UPDATE govern
SET date_ = STR_TO_DATE(date_, '%m/%d/%Y');

/* 1. Find id, name, position, salary, birthdate, gender, and the number of employees supervised 
for the employees who are supervisors and group them by thier positions and then by salary. */

SELECT eid, name, position, salary, dob, gender, COUNT(supervisor.eidY) as no_of_supervisee
FROM employee
INNER JOIN supervisor
ON employee.eid = supervisor.eidY
GROUP BY supervisor.eidY
ORDER BY position DESC, salary DESC;

+------+------------------+-----------+---------+------------+--------+------------------+
| eid  | name             | position  | salary  | dob        | gender | no_of_supervisee |
+------+------------------+-----------+---------+------------+--------+------------------+
| 4003 | Corbet Mitchel   | Nurse     | 107,767 | 1988-10-29 | Female |               10 |
| 4011 | Robenia Ettritch | Nurse     | 105,920 | 1985-09-24 | Female |               10 |
| 4010 | Blayne Pears     | Nurse     | 104,308 | 1986-02-13 | Male   |               10 |
| 4037 | Penny Theodoris  | Doctor    | 283,309 | 1986-01-16 | Male   |                7 |
| 4025 | Raina Hargate    | Doctor    | 280,522 | 1972-11-10 | Male   |                6 |
| 4066 | Eva Thaller      | Doctor    | 279,761 | 1970-02-18 | Female |                7 |
| 4062 | Gregoor Gallahue | Doctor    | 278,427 | 1981-02-10 | Male   |                8 |
| 4022 | Christel Orpin   | Assistant | 18      | 1966-05-10 | Male   |                7 |
| 4039 | Nonna Legging    | Assistant | 18      | 1969-04-29 | Male   |                7 |
| 4069 | Kiri Rainbow     | Assistant | 18      | 1982-08-13 | Female |                8 |
+------+------------------+-----------+---------+------------+--------+------------------+
10 rows in set (0.00 sec)


/* 2. Number of patients admitted-to by room type between 04/01/2021 - 04/11/2021 
(10 days) along with the average number of days spent by a patient in each type of room.*/

SELECT room.room_type, COUNT(assigned.pid) as no_of_admits,  
(sum(DATEDIFF(assigned.discharge_date, assigned.admit_date)) / COUNT(assigned.pid)) as avg_per_type
FROM assigned
INNER JOIN room
ON assigned.room_no = room.room_no
WHERE assigned.admit_date BETWEEN '2021-04-01' AND '2021-04-11' AND  assigned.discharge_date 
	BETWEEN '2021-04-01' AND '2021-04-11'
GROUP BY room.room_type;

+---------------+--------------+--------------+
| room_type     | no_of_admits | avg_per_type |
+---------------+--------------+--------------+
| day room      |            7 |       3.4286 |
| delivery room |           13 |       3.2308 |
| er            |            7 |       3.0000 |
| icu           |           11 |       3.6364 |
| non-icu       |            9 |       4.1111 |
| surgery       |           17 |       4.3529 |
+---------------+--------------+--------------+
6 rows in set (0.01 sec)

/* 3.  Find the name and eid of the nurse(s) who governed rooms more than 20 times in the month of 
March i.e. between 2021-04-01 to 2021-04-30. Arrange the result in decreasing order of the number of 
times the rooms a nurse governs a room.*/

SELECT e.eid, e.name, X.no_of_times
FROM employee e
JOIN (
    SELECT g.eid, COUNT(g.room_no) as no_of_times
    FROM govern g
    WHERE date_ BETWEEN '2021-04-01' AND '2021-04-31'
    GROUP BY g.eid
    HAVING COUNT(g.room_no) >= 20
    ) X
ON e.eid = X.eid
ORDER BY  X.no_of_times DESC;

+------+------------------------+-------------+
| eid  | name                   | no_of_times |
+------+------------------------+-------------+
| 4016 | Heath Scollick         |          31 |
| 4024 | Janene Erington        |          31 |
| 4074 | Stephannie Gredden     |          29 |
| 4019 | Nadeen Lordon          |          28 |
| 4001 | Cori Jamary            |          27 |
| 4083 | Idell Shailer          |          27 |
| 4032 | Bradley Peasgood       |          27 |
| 4034 | Kirsteni Simak         |          27 |
| 4027 | Reta Holdforth         |          25 |
| 4075 | Lorine Langtree        |          24 |
| 4049 | Minnaminnie MacKnocker |          24 |
| 4085 | Steve Siegertsz        |          23 |
| 4060 | Carolus Vidineev       |          23 |
| 4050 | Bette-ann Crebott      |          22 |
| 4058 | Josiah Ebenezer        |          22 |
| 4047 | Charmion Dinan         |          21 |
| 4054 | Vernon Pointing        |          20 |
+------+------------------------+-------------+
17 rows in set (0.01 sec)


/* 4. Find the name(s) and cost of the diagnosis which resulted in a long hospital stay. Suppose for 
this hypothetical database, the length of stay past 19 is considered long. */

SELECT procedure_.diagnosis, 
        procedure_.cost, 
        DATEDIFF(assigned.discharge_date, assigned.admit_date) as length_stay
FROM procedure_
INNER JOIN patient ON procedure_.pid = patient.pid
INNER JOIN assigned ON patient.pid = assigned.pid
WHERE DATEDIFF(assigned.discharge_date, assigned.admit_date) > 19
GROUP BY procedure_.diagnosis;

+----------------------------+---------+-------------+
| diagnosis                  | cost    | length_stay |
+----------------------------+---------+-------------+
| Angioplasty                | 28,200  |          23 |
| Cataract surgery (per eye) | 3,500   |          21 |
| Child Delivery             | 20,000  |          26 |
| ER Visit                   | 1,500   |          26 |
| Face lift                  | 11,000  |          22 |
| Gastric bypass             | 25,000  |          23 |
| Gastric sleeve             | 16,500  |          21 |
| Heart bypass               | 123,000 |          29 |
| Heart valve replacement    | 170,000 |          26 |
| Hip replacement            | 40,364  |          21 |
| Hip resurfacing            | 28,000  |          28 |
| Hysterectomy               | 15,400  |          26 |
| IVF treatments             | 12,400  |          28 |
| Knee replacement           | 35,000  |          24 |
| Lap band                   | 14,000  |          28 |
| Lasik (both eyes)          | 4,000   |          21 |
| Liposuction                | 5,500   |          25 |
| Rhinoplasty                | 6,500   |          26 |
| Spinal fusion              | 110,000 |          27 |
| Tummy tuck                 | 8,000   |          26 |
+----------------------------+---------+-------------+
20 rows in set (0.00 sec)

 
/* 5. Find eid and name(s) of the doctors who carried the maximum number of procedures along with 
the number of such procedures, suppose denoted by 'y'. */

SELECT x.eid, x.name, x.position, x.y
FROM (SELECT procedure_.eid, employee.name, employee.position, COUNT(procedure_.eid) as y
        FROM procedure_
        JOIN employee ON employee.eid = procedure_.eid
        GROUP BY procedure_.eid) x
HAVING x.y = (SELECT MAX(x1.y1)
                FROM
                (SELECT COUNT(procedure_.eid) y1
                FROM procedure_
                GROUP BY procedure_.eid) x1);


+------+-------------+----------+----+
| eid  | name        | position | y  |
+------+-------------+----------+----+
| 4042 | Astrix Nund | Doctor   | 45 |
+------+-------------+----------+----+
1 row in set (0.00 sec)



/* 6. Find name, age, and health condition diagnosised with for the patients who were checked in 
and admitted the very same day between 2021-04-10 to 2021-04-30. */

SELECT patient.pid, patient.name, 
floor(DATEDIFF(CURRENT_DATE(), patient.dob) / 365.25) as age_yrs,
checks_in.date_ as date_chek_in, procedure_.diagnosis
FROM patient
JOIN checks_in ON patient.pid = checks_in.pid
JOIN assigned ON assigned.pid = patient.pid
JOIN procedure_ ON procedure_.pid = patient.pid
WHERE checks_in.date_ = assigned.admit_date AND checks_in.date_ BETWEEN '2021-04-10' AND '2021-04-30'
ORDER BY checks_in.date_;

+------+----------------------+---------+--------------+-----------------+
| pid  | name                 | age_yrs | date_chek_in | diagnosis       |
+------+----------------------+---------+--------------+-----------------+
| 1560 | Darcy Peirone        |      67 | 2021-04-10   | Gastric bypass  |
| 1230 | Vivianne Huddlestone |      27 | 2021-04-10   | Dental implant  |
| 1560 | Darcy Peirone        |      67 | 2021-04-10   | Liposuction     |
| 1560 | Darcy Peirone        |      67 | 2021-04-10   | Face lift       |
| 1134 | Gene Britee          |      26 | 2021-04-11   | Dental implant  |
| 1134 | Gene Britee          |      26 | 2021-04-11   | IVF treatments  |
| 1669 | Lena Giacobilio      |      49 | 2021-04-12   | Breast implants |
| 1853 | Cherilynn Orsi       |      22 | 2021-04-12   | Hip resurfacing |
| 1030 | Mychal Clews         |      26 | 2021-04-13   | Rhinoplasty     |
| 1829 | Allene Rump          |      54 | 2021-04-13   | Hip resurfacing |
| 1223 | Noellyn Luffman      |      24 | 2021-04-14   | Child Delivery  |
| 1265 | Mahmoud Biggins      |      79 | 2021-04-15   | Gastric sleeve  |
| 1411 | Martainn Gilham      |      46 | 2021-04-19   | Gastric sleeve  |
| 1444 | Lissa Callcott       |      53 | 2021-04-19   | Heart bypass    |
| 1067 | Cly Bodell           |      39 | 2021-04-29   | ER Visit        |
| 1067 | Cly Bodell           |      39 | 2021-04-29   | Face lift       |
| 1067 | Cly Bodell           |      39 | 2021-04-29   | Rhinoplasty     |
| 1371 | Rodge Pounsett       |      62 | 2021-04-29   | Child Delivery  |
+------+----------------------+---------+--------------+-----------------+
18 rows in set (0.01 sec)


/* 7. List name, id, gender, and diagnosis-name of all the patients cared by the doctor named
 Valentino Starbucke */

SELECT patient.pid, patient.name, patient.gender, procedure_.diagnosis
FROM patient
JOIN procedure_ on patient.pid = procedure_.pid
JOIN employee on procedure_.eid = employee.eid
WHERE employee.name = 'Valentino Starbucke'
ORDER BY patient.name;

+------+--------------------+------------+-------------------------+
| pid  | name               | gender     | diagnosis               |
+------+--------------------+------------+-------------------------+
| 1439 | Annice Dandison    | Male       | Gastric bypass          |
| 1367 | Bank Dominichetti  | Male       | Face lift               |
| 1796 | Christie Windmill  | Non-Binary | Dental implant          |
| 1478 | Dalt Junkin        | Female     | Angioplasty             |
| 1463 | Domini Tolotti     | Non-Binary | Gastric sleeve          |
| 1572 | Duane Curzey       | Male       | Hip replacement         |
| 1562 | Elianora Rubinfeld | Female     | Child Delivery          |
| 1022 | Even Muffen        | Non-Binary | Spinal fusion           |
| 1406 | Fitzgerald Wincer  | Non-Binary | Heart valve replacement |
| 1014 | Giustina Tourne    | Female     | Face lift               |
| 1846 | Gretel MacGarvey   | Male       | Tummy tuck              |
| 1338 | Gustie Doerrling   | Female     | Hip replacement         |
| 1354 | Lenka Vischi       | Male       | Hip replacement         |
| 1396 | Logan Gonnel       | Male       | ER Visit                |
| 1075 | Lorin Cheeld       | Male       | Heart bypass            |
| 1175 | Odetta Cradoc      | Male       | Hysterectomy            |
| 1619 | Simone Tatem       | Female     | Angioplasty             |
| 1494 | Skippie Carmo      | Male       | Dental implant          |
| 1802 | Sue Potbury        | Female     | Dental implant          |
| 1328 | Tanitansy Althorp  | Male       | Gastric sleeve          |
| 1646 | Trev O'' Dooley     | Female     | Gastric sleeve          |
| 1457 | Wallache Hinge     | Male       | Breast implants         |
| 1457 | Wallache Hinge     | Male       | Hysterectomy            |
| 1006 | Winonah Lemme      | Non-Binary | Spinal fusion           |
+------+--------------------+------------+-------------------------+
24 rows in set (0.00 sec)


/* 8. Find pid and name of the patience present at room # WV-100 on 2021-04-16 from 1:00 pm to 5:00 pm. */

SELECT patient.pid, patient.name, govern.time_, govern.date_, room.room_no
FROM patient
JOIN assigned ON assigned.pid = patient.pid
JOIN room ON room.room_no = assigned.room_no
JOIN govern ON govern.room_no = room.room_no
WHERE govern.date_ = '2021-04-16' 
        AND govern.time_ BETWEEN '1:00 PM' AND '5:00 PM' 
        AND room.room_no = 'WV-100';
		
+------+-------------------+---------+------------+---------+
| pid  | name              | time_   | date_      | room_no |
+------+-------------------+---------+------------+---------+
| 1075 | Lorin Cheeld      | 3:29 PM | 2021-04-16 | WV-100  |
| 1344 | Martguerita Dobie | 3:29 PM | 2021-04-16 | WV-100  |
| 1387 | Ileana Orange     | 3:29 PM | 2021-04-16 | WV-100  |
| 1451 | Lucais Matthesius | 3:29 PM | 2021-04-16 | WV-100  |
| 1488 | Mara Seeney       | 3:29 PM | 2021-04-16 | WV-100  |
| 1676 | Randa Hainge      | 3:29 PM | 2021-04-16 | WV-100  |
| 1780 | Desmund Goulston  | 3:29 PM | 2021-04-16 | WV-100  |
| 1805 | Penny Duligal     | 3:29 PM | 2021-04-16 | WV-100  |
+------+-------------------+---------+------------+---------+
8 rows in set (0.00 sec)


/* 9. Find the care recieved and cost inccured by a patience named Even Muffen. */

SELECT procedure_.diagnosis, procedure_.cost
FROM procedure_
JOIN patient ON patient.pid = procedure_.pid
WHERE patient.name = 'Even Muffen';

+---------------+---------+
| diagnosis     | cost    |
+---------------+---------+
| Rhinoplasty   | 6,500   |
| Heart bypass  | 123,000 |
| Spinal fusion | 110,000 |
+---------------+---------+
3 rows in set (0.01 sec)


/* 10. Find the rooms that have been occupied by patients the least number of times and find
the minimum number of time (let be 'y'). */

SELECT x.room_no, x.y
FROM (
SELECT room.room_no, COUNT(assigned.pid) as y
FROM assigned
JOIN room ON room.room_no = assigned.room_no
GROUP BY assigned.room_no
) x
HAVING x.y = (SELECT MIN(a.b)
             FROM (
             SELECT COUNT(assigned.pid) b
                 FROM assigned
                 GROUP BY assigned.room_no
             ) a
             );
			 
+---------+---+
| room_no | y |
+---------+---+
| WV-21   | 2 |
+---------+---+
1 row in set (0.00 sec)





