---- Connecting sys as sysdba
connect sys/sys as sysdba;

-- Setting the spool file
SPOOL C:\BD2\project_part6_spool.txt

-- Showing the actual time when the script was run
SELECT to_char(sysdate,'DD Month YYYY Day HH:MI"SS') FROM dual;

-- QUESTION 1

-- Connecting to the schema

DROP USER des03 CASCADE;

@C:\BD1\7Northwoods.sql

SET SERVEROUTPUT ON

-- Declaring a procedure

CREATE OR REPLACE PROCEDURE q1p6 AS

-- Step 1: Declare the cursor

	CURSOR fac_cursor IS
	SELECT f_id, f_last, f_first, f_rank
	FROM faculty;

	v_fid faculty.f_id%TYPE;
	v_flast faculty.f_last%TYPE;
	v_ffirst faculty.f_first%TYPE;
	v_frank faculty.f_rank%TYPE;


	CURSOR stu_cursor (par_f_id student.f_id%TYPE) IS
	SELECT s_id, s_last, s_first, s_dob, s_class
	FROM student
	WHERE f_id = par_f_id;

	v_sid student.s_id%TYPE;
	v_slast student.s_last%TYPE;
	v_sfirst student.s_first%TYPE;
	v_sdob student.s_dob%TYPE;
	v_sclass student.s_class%TYPE;

	BEGIN

-- Step 2: Open cursor

		OPEN fac_cursor;

-- Step 3: Fetch the cursor;

		FETCH fac_cursor INTO v_fid, v_flast, v_ffirst, v_frank;

		WHILE fac_cursor%FOUND LOOP

			DBMS_OUTPUT.PUT_LINE('******************************************************************************');
			DBMS_OUTPUT.PUT_LINE('Faculty ID: ' || v_fid || '.');
			DBMS_OUTPUT.PUT_LINE('Faculty Last Name: ' || v_flast || '. Faculty First Name: ' || v_ffirst || '.');
			DBMS_OUTPUT.PUT_LINE('Faculty Rank: ' || v_frank || '.');
			DBMS_OUTPUT.PUT_LINE('******************************************************************************');

			-- Using the inner cursor

				OPEN stu_cursor(v_fid);

				FETCH stu_cursor INTO v_sid, v_slast, v_sfirst, v_sdob, v_sclass;

				WHILE stu_cursor%FOUND LOOP

					DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------');
					DBMS_OUTPUT.PUT_LINE('Student ID: ' || v_sid || '.');
					DBMS_OUTPUT.PUT_LINE('Student Last Name: ' || v_slast || '. Student First Name: ' || v_sfirst || '.');
					DBMS_OUTPUT.PUT_LINE('Date of Birth: ' || v_sdob || '.');
					DBMS_OUTPUT.PUT_LINE('Student Class: ' || v_sclass || '.');
					DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------');

				FETCH stu_cursor INTO v_sid, v_slast, v_sfirst, v_sdob, v_sclass;
				
				END LOOP;

				CLOSE stu_cursor;
					
		FETCH fac_cursor INTO v_fid, v_flast, v_ffirst, v_frank;

		END LOOP;

-- Step 4: Close the cursor

		CLOSE fac_cursor;

	END;

/

EXEC q1p6;


-- QUESTION 2

-- Preparing the schema

connect sys/sys as sysdba;

DROP USER des04 CASCADE;
 
@C:\BD1\7Software.sql

SET SERVEROUTPUT ON


-- Declaring a procedure

CREATE OR REPLACE PROCEDURE q2p6 AS

	CURSOR cons_cursor IS
	SELECT c_id, c_last, c_first
	FROM consultant;

	v_cid consultant.c_id%TYPE;
	v_clast consultant.c_last%TYPE;
	v_cfirst consultant.c_first%TYPE;


	CURSOR skill_cursor (pc_c_id consultant.c_id%TYPE) IS
	SELECT skill_description, certification
	FROM consultant_skill cs, skill s
	WHERE c_id = pc_c_id AND cs.skill_id = s.skill_id;

	v_skilldesc skill.skill_description%TYPE;
	v_certification consultant_skill.certification%TYPE;

	BEGIN

-- Step 2: Opening the cursor

		OPEN cons_cursor;

-- Step 3: Fetch the cursor

		FETCH cons_cursor INTO v_cid, v_clast, v_cfirst;

		WHILE cons_cursor%FOUND LOOP

			DBMS_OUTPUT.PUT_LINE('******************************************************************************');
			DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || v_cid || '.');
			DBMS_OUTPUT.PUT_LINE('Consultant First Name: ' || v_clast || '. Consultant Last Name: ' || v_cfirst || '.');
			DBMS_OUTPUT.PUT_LINE('******************************************************************************');

			-- Inner cursor

			OPEN skill_cursor (v_cid);

			FETCH skill_cursor INTO v_skilldesc, v_certification;

			WHILE skill_cursor%FOUND LOOP

				DBMS_OUTPUT.PUT_LINE('Certification: ' || v_certification || '. Description: ' || v_skilldesc || '.');

			FETCH skill_cursor INTO v_skilldesc, v_certification;

			END LOOP;

			CLOSE skill_cursor;
	
		FETCH cons_cursor INTO v_cid, v_clast, v_cfirst;

		END LOOP;

-- Step 4: Close the cursor

		CLOSE cons_cursor;

	END;

/

EXEC q2p6;

-- QUESTION 3

-- Preparing the schema

connect sys/sys as sysdba;

DROP USER des02 CASCADE;

@C:\BD1\7clearwater.sql

SET SERVEROUTPUT ON

-- Declaring the procedure 

CREATE OR REPLACE PROCEDURE q3p6 AS

-- Declaring the cursor

	CURSOR items_cursor IS
	SELECT UNIQUE iv.item_id, item_desc, cat_id
	FROM inventory iv, item it
	WHERE iv.item_id = it.item_id;

	v_itemid inventory.item_id%TYPE;
	v_itemdesc item.item_desc%TYPE;
	v_catid item.cat_id%TYPE;

	CURSOR inventory_cursor(par_item_id inventory.item_id%TYPE) IS
	SELECT color, inv_size, inv_price, inv_qoh
	FROM inventory
	WHERE par_item_id = item_id;

	v_color inventory.color%TYPE;
	v_invsize inventory.inv_size%TYPE;
	v_invprice inventory.inv_price%TYPE;
	v_invqoh inventory.inv_qoh%TYPE;

	BEGIN

-- Opening the cursor

	OPEN items_cursor;

-- Fetch the cursor

	FETCH items_cursor INTO v_itemid, v_itemdesc, v_catid;

		WHILE items_cursor%FOUND LOOP

			DBMS_OUTPUT.PUT_LINE('***********************************************************************');
			DBMS_OUTPUT.PUT_LINE('Item ID: ' || v_itemid || '. Item Description: ' || v_itemdesc || '. 
			Category ID: ' || v_catid || '.');
			DBMS_OUTPUT.PUT_LINE('***********************************************************************');

-- Inner cursor

			OPEN inventory_cursor(v_itemid);

			FETCH inventory_cursor INTO v_color, v_invsize, v_invprice, v_invqoh;

			WHILE inventory_cursor%FOUND LOOP

				DBMS_OUTPUT.PUT_LINE('Color: ' || v_color || '. Size: ' || v_invsize || '. Price: $' || v_invprice || '. Quantity on hand: ' || v_invqoh || '.');

			FETCH inventory_cursor INTO v_color, v_invsize, v_invprice, v_invqoh;

			END LOOP;

			CLOSE inventory_cursor;

		FETCH items_cursor INTO v_itemid, v_itemdesc, v_catid;

		END LOOP;
	
-- Closing the cursor;

	CLOSE items_cursor;

	END;

/

EXEC q3p6;

-- QUESTION 4

-- Declaring the procedure 

CREATE OR REPLACE PROCEDURE q4p6 AS

-- Declaring the cursor

	CURSOR items_cursor IS
	SELECT UNIQUE iv.item_id, item_desc, cat_id
	FROM inventory iv, item it
	WHERE iv.item_id = it.item_id;

	v_itemid inventory.item_id%TYPE;
	v_itemdesc item.item_desc%TYPE;
	v_catid item.cat_id%TYPE;

	CURSOR inventory_cursor(par_item_id inventory.item_id%TYPE) IS
	SELECT color, inv_size, inv_price, inv_qoh
	FROM inventory
	WHERE par_item_id = item_id;

	v_color inventory.color%TYPE;
	v_invsize inventory.inv_size%TYPE;
	v_invprice inventory.inv_price%TYPE;
	v_invqoh inventory.inv_qoh%TYPE;
	v_value NUMBER;

	BEGIN

-- Opening the cursor

	OPEN items_cursor;

-- Fetch the cursor

	FETCH items_cursor INTO v_itemid, v_itemdesc, v_catid;

		WHILE items_cursor%FOUND LOOP

			DBMS_OUTPUT.PUT_LINE('***********************************************************************');
			DBMS_OUTPUT.PUT_LINE('Item ID: ' || v_itemid || '. Item Description: ' || v_itemdesc || '. 
			Category ID: ' || v_catid || '.');
			DBMS_OUTPUT.PUT_LINE('***********************************************************************');

-- Inner cursor

			OPEN inventory_cursor(v_itemid);

			FETCH inventory_cursor INTO v_color, v_invsize, v_invprice, v_invqoh;

			WHILE inventory_cursor%FOUND LOOP

				v_value := v_invprice * v_invqoh;
				DBMS_OUTPUT.PUT_LINE('Color: ' || v_color || '. Size: ' || v_invsize || '. Price: $' || v_invprice || '. Quantity on hand: ' || v_invqoh || '.');
				DBMS_OUTPUT.PUT_LINE('Item value: $' || v_value || '.');

			FETCH inventory_cursor INTO v_color, v_invsize, v_invprice, v_invqoh;

			END LOOP;

			CLOSE inventory_cursor;

		FETCH items_cursor INTO v_itemid, v_itemdesc, v_catid;

		END LOOP;
	
-- Closing the cursor;

	CLOSE items_cursor;

	END;

/

EXEC q4p6;

-- QUESTION 5

-- Preparing the schema

connect sys/sys as sysdba;

DROP USER des04 CASCADE;
 
@C:\BD1\7Software.sql

SET SERVEROUTPUT ON


-- Declaring the procedure

CREATE OR REPLACE PROCEDURE q5p6 (in_cid NUMBER, in_cert VARCHAR2) AS

-- Starting the declaration for the cursor

	CURSOR update_cert IS
	SELECT c.c_id, skill_description, certification
	FROM consultant c, consultant_skill cs, skill s
	WHERE cs.skill_id = s.skill_id AND c.c_id = cs.c_id AND c.c_id = in_cid
	FOR UPDATE OF certification;

	v_skilldesc skill.skill_description%TYPE;
	v_cert consultant_skill.certification%TYPE;
	v_clast consultant.c_last%TYPE;
	v_cfirst consultant.c_first%TYPE;
	v_cid consultant.c_id%TYPE;
	temp_cert VARCHAR2(2);

	BEGIN

-- Opening the cursor

		OPEN update_cert;

		SELECT c_id, c_last, c_first
		INTO v_cid, v_clast, v_cfirst
		FROM consultant
		WHERE c_id = in_cid;

		FETCH update_cert INTO v_cid, v_skilldesc, v_cert;		

		IF (in_cert <> 'Y' AND in_cert <> 'N') THEN

			DBMS_OUTPUT.PUT_LINE('Wrong option. You must insert Y or N.');
			DBMS_OUTPUT.PUT_LINE('Certification informed: ' || in_cert || '.');

		ELSE

			DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || v_cid || '. Last name: ' || v_clast || '. First name: ' || v_cfirst || '.');
			DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------.');
			
			WHILE update_cert%FOUND LOOP
	
				temp_cert := v_cert;
				v_cert := in_cert;

				UPDATE consultant_skill SET certification = in_cert
				WHERE CURRENT OF update_cert; 

				DBMS_OUTPUT.PUT_LINE('Skill Description: ' || v_skilldesc || '.');
				DBMS_OUTPUT.PUT_LINE('New certification: ' || v_cert || '.');
				DBMS_OUTPUT.PUT_LINE('Old certification: ' || temp_cert || '.');

				FETCH update_cert INTO v_cid, v_skilldesc, v_cert;

			END LOOP;
		
		CLOSE update_cert;

		END IF;

	EXCEPTION
	WHEN NO_DATA_FOUND THEN
	DBMS_OUTPUT.PUT_LINE('Consultant number ' || v_cid || ' do not exist.');
	DBMS_OUTPUT.PUT_LINE('Try again.');

	END;

/

EXEC q5p6(100,'Y')
EXEC q5p6(101,'N')
EXEC q5p6(103,'G')
EXEC q5p6(104,'Y')


SPOOL OFF