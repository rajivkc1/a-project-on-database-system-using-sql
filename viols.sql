/* An INSERT command creating a key violation 
eg: on employee table*/
INSERT INTO employee (4002,'Valentino Khatri','valentinostarbewucke@wvh.org','590-413-5031','05/07/1976','Non-Binary','Doctor','231,783');

/* An UPDATE command creating a key violation 
eg: on patient table*/
UPDATE patient SET ssn = '483-84-0472' WHERE name = 'Adria Deveril' and dob = '4/8/1990';

/* An INSERT command creating a referential integrity violation */
INSERT INTO govern (4100, 'WV-766', '12:00 PM');

/* A DELETE command creating a referential integrity violation */
DELETE FROM checks_in WHERE pid = '1030';

/* An UPDATE command creating a referential integrity violation */
UPDATE govern SET room_no = 'WV-100' WHERE eid = 4001;