 Oracle PL/SQL BULK COLLECT: FORALL Example
=========================
What is BULK COLLECT?
BULK COLLECT reduces context switches between SQL and PL/SQL engine and allows SQL engine 
to fetch the records at once.

Oracle PL/SQL provides the functionality of fetching the records in bulk rather than fetching one-by-one. 
This BULK COLLECT can be used in 'SELECT' statement to populate the records in bulk or in fetching the cursor 
in bulk. 
Since the BULK COLLECT fetches the record in BULK, the INTO clause should always contain 
a collection type variable. 

The main advantage of using BULK COLLECT is it increases the performance by reducing the interaction 
between database and PL/SQL engine.

Syntax:

SELECT <columnl> BULK COLLECT INTO bulk_varaible FROM <table name>;
FETCH <cursor_name> BULK COLLECT INTO <bulk_varaible >;

------------

FORALL Clause
The FORALL allows to perform the DML operations on data in bulk. 
It is similar to that of FOR loop statement except in FOR loop 
things happen at the record-level whereas in FORALL there is no LOOP concept. 
Instead the entire data present in the given range is processed at the same time.

Syntax:

FORALL <loop_variable>in<lower range> .. <higher range> 

<DML operations>;





----------dxf


In the above syntax, the given DML operation will be executed for the entire data that is present between lower and higher range.
-----------------

LIMIT Clause
The bulk collect concept loads the entire data into the target collection variable as a bulk i.e. the whole data 
will be populated into the collection variable in a single-go. But this is not advisable when the total record that 
needs to be loaded is very large, because when PL/SQL tries to load the entire data it consumes more session memory. 
Hence, it is always good to limit the size of this bulk collect operation.

However, this size limit can be easily achieved by introducing the ROWNUM condition in the 'SELECT' statement, 
whereas in the case of cursor this is not possible.

To overcome this Oracle has provided 'LIMIT' clause that defines the number of records that needs to be included in the bulk.

Syntax:

FETCH <cursor_name> BULK COLLECT INTO <bulk_variable> LIMIT <size>;

DECLARE
CURSOR guru99_det IS SELECT emp_name FROM emp;
TYPE lv_emp_name_tbl IS TABLE OF VARCHAR2(50);
lv_emp_name lv_emp_name_tbl;
BEGIN
OPEN guru99_det;
FETCH guru99_det BULK COLLECT INTO lv_emp_name LIMIT 5000;
FOR c_emp_name IN lv_emp_name.FIRST .. lv_emp_name.LAST
LOOP
Dbms_output.put_line(‘Employee Fetched:‘||c_emp_name);
END LOOP:
FORALL i IN lv_emp_name.FIRST .. lv emp_name.LAST
UPDATE emp SET salaiy=salary+5000 WHERE emp_name=lv_emp_name(i);
COMMIT;	
Dbms_output.put_line(‘Salary Updated‘);
CLOSE guru99_det;
END;
/
-------------------------------------
--Example 1


DECLARE
    TYPE emp_coll  IS TABLE OF VARCHAR2(40) ; 
     
    emp_rec  emp_coll:=emp_coll();
    i  NUMBER(3):=1;
    
BEGIN
    
   SELECT last_name BULK COLLECT INTO emp_rec
    FROM emp WHERE department_id=80;
   
    FOR i IN emp_rec.first()..emp_rec.last()
      LOOP
        IF emp_rec.exists(i) THEN
        dbms_output.put_line(emp_rec(i));
        END IF;  
      END LOOP;
      
      FORALL i IN emp_rec.first()..emp_rec.last()
      UPDATE emp SET salary=salary+100 WHERE last_name=emp_rec(i);
        
END;
-----------------------------------

DECLARE
    TYPE emp_coll  IS TABLE OF VARCHAR2(40) ; 
     
    emp_rec  emp_coll:=emp_coll();
    i  NUMBER(3):=1;
    l_error_count  NUMBER(8);
BEGIN
    
   SELECT last_name BULK COLLECT INTO emp_rec
    FROM emp WHERE department_id=80;
   
    FOR i IN emp_rec.first()..emp_rec.last()
      LOOP
        IF emp_rec.exists(i) THEN
        dbms_output.put_line(emp_rec(i));
        END IF;  
      END LOOP;
      --CREATE TABLE test_bulk(LAST_name VARCHAR2(6), salary NUMBER(10))
      FORALL i IN emp_rec.first()..emp_rec.last() SAVE EXCEPTIONS
      INSERT INTO test_bulk VALUES(emp_rec(i), 10000);
      
      COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
   COMMIT;   
   l_error_count := SQL%BULK_EXCEPTIONS.count;
   DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
   FOR i IN 1 .. l_error_count LOOP
        DBMS_OUTPUT.put_line('Error: ' || i || 
          ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
          ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
   END LOOP;
              
END;

--
--SELECT * FROM test_bulk;

