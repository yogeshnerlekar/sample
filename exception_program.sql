DECLARE 
  v_dept_name  dept.department_name%TYPE;
  n  NUMBER(10);
BEGIN
  --block 1
  BEGIN
    SELECT department_name INTO v_dept_name
    FROM dept WHERE department_id  =800;
    
    dbms_output.put_line(v_dept_name);
  --  n:=10/0;
    
  EXCEPTION 
    
    WHEN no_data_found OR too_many_rows THEN
      dbms_output.put_line('No rows selected ');
    
  END;
  --block 1
  
  BEGIN
    SELECT department_name INTO v_dept_name
    FROM dept 
    WHERE department_id =50;
    
    dbms_output.put_line(v_dept_name);
  EXCEPTION 
    WHEN OTHERS THEN  
      dbms_output.put_line('Block 2 Others');
  END;
  
END;  
-------------------------------------------

DECLARE
  v_lname   emp.last_name%TYPE;
  v_sal     NUMBER(10);
  my_excp   EXCEPTION;
  PRAGMA Exception_Init(my_excp,-1422);
  invalid_sal       EXCEPTION;
  
BEGIN
 
     BEGIN
       SELECT last_name,salary INTO v_lname,v_sal
       FROM emp WHERE employee_id=100;
            dbms_output.put_line('after select ');
            
       IF  v_sal >5000 THEN
        -- RAISE invalid_sal;
        raise_application_error(-19000,'Salary > 5000 ');
       END IF;
        
            
     EXCEPTION 
       WHEN my_excp   THEN  
         dbms_output.put_line('my exception in inner block '
         ||SQLERRM);
       WHEN invalid_sal   THEN 
          dbms_output.put_line('Salary is > 5000'
          ||SQLERRM); 
     END;       
END;


        
  


















