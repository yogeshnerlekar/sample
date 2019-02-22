/*============================================================================================
	Index-by tables
============================================================================================*/
--Example 1:

DECLARE
    -- Associative array indexed by string: 
    TYPE population IS TABLE OF NUMBER  -- Associative array type
      INDEX BY VARCHAR2(64);
  
    city_population  population;        -- Associative array variable
    i                VARCHAR2(64);
  
BEGIN
    -- Add new elements to associative array:  
    city_population('Smallville')  := 2000;
    city_population('Midland')     := 750000;
    city_population('Megalopolis') := 1000000;
  
    -- Change value associated with key 'Smallville':  
    city_population('Smallville') := 2001;
  
    -- Print associative array:  
    i := city_population.FIRST;
  
    WHILE i IS NOT NULL LOOP
      DBMS_Output.PUT_LINE
        ('Population of ' || i || ' is ' || TO_CHAR(city_population(i)));
      i := city_population.NEXT(i);
    END LOOP;
    
END;
-------------------------------------------------
--Example 2:

DECLARE
    TYPE emp_coll  IS TABLE OF VARCHAR2(60)
    INDEX BY PLS_INTEGER; 
     
    emp_rec  emp_coll;
    v_empid  NUMBER(3):=100;
BEGIN
   FOR i IN 1..20
    LOOP
      SELECT last_name INTO emp_rec(i) 
      FROM emp WHERE employee_id=v_empid;
     
       v_empid:=v_empid+1;
    END LOOP;
    
    ------------
    emp_rec(25):='Oracle';
    
    
   -- FOR i IN 1..25
   FOR i IN emp_rec.first..emp_rec.last
    LOOP
      IF emp_rec.EXISTS(i) THEN
      dbms_output.put_line('Index i= '||i||' Value= '||emp_rec(i)) ;
      END IF;  
    END LOOP;
    
    dbms_output.put_line('First = '||emp_rec.first);
    dbms_output.put_line('Last  = '||emp_rec.last);
    dbms_output.put_line('Count = '||emp_rec.count);
    dbms_output.put_line('Limit = '||emp_rec.limit);
    
    dbms_output.put_line('Prior of 20 = '||emp_rec.prior(20)); --prior index
    dbms_output.put_line('Next of 20 = '||emp_rec.next(20)); --next index
    --------------------------------------------
    emp_rec.delete(1,5);    
    dbms_output.put_line('Count After Delete = '||emp_rec.count);
END;    

/*============================================================================================
		NESTED TABLE
============================================================================================*/

--Example 1:

DECLARE
    TYPE emp_coll  IS TABLE OF VARCHAR2(60);   
       
    emp_rec  emp_coll:=emp_coll('a','b','c','d');
    
BEGIN
    
    FOR i IN emp_rec.first..emp_rec.last
      LOOP
        dbms_output.put_line('Index i= '||i||' Value= '||emp_rec(i)) ;
      END LOOP;
      
     emp_rec.extend(10); 
     emp_rec(10):='e';
     dbms_output.put_line('-----------------------');
     
         --emp_rec.delete(1,3);
         
      FOR i IN emp_rec.first..emp_rec.last
      LOOP
        --IF emp_rec.EXISTS(i) THEN -- check the index value which always exists
        IF emp_rec(i) IS NOT NULL THEN --check the value on that index
        dbms_output.put_line('Index i= '||i||' Value= '||emp_rec(i)) ;
        END IF;
        
      END LOOP;
      
     dbms_output.put_line('-----------------------'); 
    dbms_output.put_line('First = '||emp_rec.first);
    dbms_output.put_line('Last  = '||emp_rec.last);
    dbms_output.put_line('Count = '||emp_rec.count);
    dbms_output.put_line('Limit = '||emp_rec.limit);
    
    dbms_output.put_line('Prior of 10  = '||emp_rec.prior(10)); --prior index
    dbms_output.put_line('Next of 10 = '||emp_rec.next(10)); --next index
    
    emp_rec.delete(1,5);    
    dbms_output.put_line('Count After Delete = '||emp_rec.count);
    
  
END;    
---------------------------------------------------
--Example 2:-

DECLARE
    TYPE emp_coll  IS TABLE OF VARCHAR2(60);   
   -- emp_rec  emp_coll :=emp_coll(); --initializes 
    emp_rec  emp_coll ;
    
    v_empid   NUMBER(4):=100;
BEGIN
   emp_rec   :=emp_coll(); --initializes 
   
    FOR i IN 1..14
      LOOP
        emp_rec.extend(1);
        SELECT last_name INTO emp_rec(i) 
        FROM emp WHERE employee_id=v_empid;
        v_empid:=v_empid+1;
        
    END LOOP;
      
    ---print          
    FOR i IN emp_rec.first..emp_rec.last
    LOOP
       
      IF emp_rec(i) IS NOT NULL THEN --check the value on that index
      dbms_output.put_line('Index i= '||i||' Value= '||emp_rec(i)) ;
      END IF;
        
    END LOOP;
 
END;    

-----------------------------------------------------
--Example 3

DECLARE
    TYPE emp_coll  IS TABLE OF emp%ROWTYPE ; 
     
    emp_rec  emp_coll:=emp_coll();
    v_empid  NUMBER(3):=100;
BEGIN
    
    FOR i IN 1..10 
      LOOP
         emp_rec.extend(1);
        SELECT * INTO emp_rec(i)  
        FROM emp WHERE employee_id=v_empid;
        v_empid:=v_empid+1;
      END LOOP;
      
    FOR i IN 1..10 
      LOOP
        dbms_output.put_line(emp_rec(i).last_name);
      END LOOP;
          
END;
------------------------------------------------------
--Example 3 with cursor

DECLARE
    TYPE emp_coll  IS TABLE OF VARCHAR2(40) ; 
     
    emp_rec  emp_coll:=emp_coll();
    i  NUMBER(3):=1;
    
    CURSOR c1 IS
    SELECT last_name FROM emp WHERE department_id=80;
    
BEGIN
    
   OPEN c1;
   LOOP
     emp_rec.extend(1);
     FETCH c1 INTO emp_rec(i);
     EXIT WHEN c1%NOTFOUND; 
         i:=i+1;
    END LOOP;
      
    FOR i IN 1..10 
      LOOP
        IF emp_rec.exists(i) THEN
        dbms_output.put_line(emp_rec(i));
        END IF;  
      END LOOP;
          
END;

/*============================================================================================
		VARRAY 

============================================================================================*/


DECLARE
    TYPE emp_coll  IS VARRAY(5) OF VARCHAR2(60);   
   -- emp_rec  emp_coll :=emp_coll(); --initializes 
    emp_rec  emp_coll ;
    
    v_empid   NUMBER(4):=100;
BEGIN
   emp_rec   :=emp_coll(); --initializes 
   
    FOR i IN 1..5
      LOOP
        emp_rec.extend(1);
        SELECT last_name INTO emp_rec(i) 
        FROM emp WHERE employee_id=v_empid;
        v_empid:=v_empid+1;
        
    END LOOP;
    
   -- emp_rec.extend(1);
   -- emp_rec(6):='test';  
    ---print          
    FOR i IN emp_rec.first..emp_rec.last
    LOOP
       
      IF emp_rec(i) IS NOT NULL THEN --check the value on that index
      dbms_output.put_line('Index i= '||i||' Value= '||emp_rec(i)) ;
      END IF;
        
    END LOOP;
 
END;    
