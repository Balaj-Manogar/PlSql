DECLARE
  country_id COUNTRIES.country_id%TYPE ;
  country_name COUNTRIES.country_name%TYPE ;

  CURSOR cursor_country_details IS
    SELECT country_id, country_name FROM COUNTRIES
      WHERE country_id = 'AU';

BEGIN
  OPEN cursor_country_details;
  FETCH cursor_country_details INTO
    country_id, country_name;
  dbms_output.put_LINE('ID: ' || country_id || ', Name: ' || country_name);
  dbms_output.put('ID: ' || country_id || ', Name: ' || country_name);
  CLOSE cursor_country_details;
END;


--  CURSORS IN LOOP
DECLARE
  CURSOR CURSOR_EMPLOYEE_IDS_189 IS
    SELECT *
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID >= 189;
  V_EMP_IDS_189 CURSOR_EMPLOYEE_IDS_189%ROWTYPE;

BEGIN
  OPEN CURSOR_EMPLOYEE_IDS_189;
  LOOP
    FETCH CURSOR_EMPLOYEE_IDS_189 INTO V_EMP_IDS_189;
    EXIT WHEN CURSOR_EMPLOYEE_IDS_189%NOTFOUND;
    dbms_output.put_line(
        'ROW NO:  ' || CURSOR_EMPLOYEE_IDS_189%ROWCOUNT || ', ID: ' || V_EMP_IDS_189.EMPLOYEE_ID
        || ', NAME: ' || V_EMP_IDS_189.FIRST_NAME );
  END LOOP;
  IF CURSOR_EMPLOYEE_IDS_189%ISOPEN THEN
    CLOSE CURSOR_EMPLOYEE_IDS_189;
  END IF;
END;

--  CURSORS with defined row count
DECLARE
  CURSOR CURSOR_EMPLOYEE_IDS_189(rows number default 5) IS
    SELECT *
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID >= 189 and  rownum<= rows;
  V_EMP_IDS_189 CURSOR_EMPLOYEE_IDS_189%ROWTYPE;

BEGIN
  OPEN CURSOR_EMPLOYEE_IDS_189(2);
  LOOP
    FETCH CURSOR_EMPLOYEE_IDS_189 INTO V_EMP_IDS_189;
    EXIT WHEN CURSOR_EMPLOYEE_IDS_189%NOTFOUND;
    dbms_output.put_line(
        'ROW NO:  ' || CURSOR_EMPLOYEE_IDS_189%ROWCOUNT || ', ID: ' || V_EMP_IDS_189.EMPLOYEE_ID
        || ', NAME: ' || V_EMP_IDS_189.FIRST_NAME );
  END LOOP;
  IF CURSOR_EMPLOYEE_IDS_189%ISOPEN THEN
    CLOSE CURSOR_EMPLOYEE_IDS_189;
  END IF;
END;

-- Explicit cursor auto open, fetch, close for loop
DECLARE
  CURSOR CURSOR_EMPLOYEE_IDS_189 IS
    SELECT *
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID >= 189;

BEGIN
  
  FOR V_EMP_IDS_189 IN CURSOR_EMPLOYEE_IDS_189 LOOP
    dbms_output.put_line(
        'ROW NO:  ' || CURSOR_EMPLOYEE_IDS_189%ROWCOUNT || ', ID: ' || V_EMP_IDS_189.EMPLOYEE_ID
        || ', NAME: ' || V_EMP_IDS_189.FIRST_NAME);
  END LOOP;
END; 

-- Explicit cursor auto open, fetch, close for loop WITH COUNT
DECLARE
  CURSOR CURSOR_EMPLOYEE_IDS_189 (ROWS NUMBER DEFAULT 5) IS
    SELECT *
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID >= 189 AND ROWNUM <= ROWS;

BEGIN
  FOR V_EMP_IDS_189 IN CURSOR_EMPLOYEE_IDS_189(2) LOOP
    dbms_output.put_line(
        'ROW NO:  ' || CURSOR_EMPLOYEE_IDS_189%ROWCOUNT || ', ID: ' || V_EMP_IDS_189.EMPLOYEE_ID
        || ', NAME: ' || V_EMP_IDS_189.FIRST_NAME);
  END LOOP;
END; 
  FOR V_EMP_IDS_189 IN CURSOR_EMPLOYEE_IDS_189(2) LOOP
    dbms_output.put_line(
        'ROW NO:  ' || CURSOR_EMPLOYEE_IDS_189%ROWCOUNT || ', ID: ' || V_EMP_IDS_189.EMPLOYEE_ID
        || ', NAME: ' || V_EMP_IDS_189.FIRST_NAME);
  END LOOP;
END; 

-- Implicit cursor FOR Loop
BEGIN
  FOR V_EMP_IDS_189 IN (SELECT *
  FROM EMPLOYEES
  WHERE EMPLOYEE_ID >= 189 AND ROWNUM <=5) LOOP
    dbms_output.put_line(
        'ROW NO:  ' || SQL%ROWCOUNT || ', ID: ' || V_EMP_IDS_189.EMPLOYEE_ID
        || ', NAME: ' || V_EMP_IDS_189.FIRST_NAME);
  END LOOP;
END;

-- NESTED CURSORS
DECLARE
  CURSOR CUR_DEPARTMENT(ROWCOUNT NUMBER DEFAULT 2) IS
    SELECT *
    FROM DEPARTMENTS
    WHERE ROWNUM <= ROWCOUNT;
  CURSOR CUR_EMPLOYEE(ID EMPLOYEES.DEPARTMENT_ID%TYPE) IS
    SELECT FIRST_NAME FROM EMPLOYEES where DEPARTMENT_ID = ID;
BEGIN
  <<dept>>
  FOR dept in CUR_DEPARTMENT LOOP
    dbms_output.put_line('---------------------------------');
    dbms_output.put_line('Department name: ' || dept.DEPARTMENT_NAME);

    <<employee>>
    FOR employee IN CUR_EMPLOYEE(DEPT.DEPARTMENT_ID) LOOP
      dbms_output.put_line('NAME' || employee.FIRST_NAME);
    END LOOP;
    dbms_output.put_line('---------------------------------');

  END LOOP;
END;
