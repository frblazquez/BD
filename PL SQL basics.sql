-- Francisco Javier Blázquez Martínez ~ frblazqu@ucm.es
--
-- Double degree in Mathematics-Computer engineering.
-- Complutense university, Madrid.
--
-- Description: Oracle PL SQL instructions and basic content.


0.- WHAT IS PL/SQL:

SQL is an query language, done for asking for information to an DBMS (DataBase 
manager system). It's really useful for this but it isn't powerful enough for
advanced queries and databases maintenance (among others). So we sometimes need
the tools we have in an structured programming language. This is exactly what
PL/SQL is. It is the way we can include SQL in C++ or Java languajes. 

Now we know what PL/SQL is we are going to start learning PL/SQL sintax and 
common tools.

1.- PL/SQL SYNTAX AND STRUCTURE:

1.0.- Blocks:
-- We will include sql sentences always inside this blocks, with each block 
-- having a concrete functionallity.

    DECLARE
        --Variables
    BEGIN
        --SQL sentences
    EXCEPTION
        --Exceptions treatment
    END;

1.1.- Variables:

    varName [CONSTANT] varType [NOT NULL] [:= default expression ];
    
 -> Default initial value (if not specified) for a variable is NULL.
 -> Not null variables should always have a default expression.
 -> Variables can be used only inside the block where they are declared.
 -> Common varTypes are: Char(n), varchar(n), Integer, boolean, date, number
 -> We can use table_name.attribue%TYPE to especify the attribute type
    
    DECLARE
        EmpName     Employee.name%TYPE
        EmpSalary   Employee.salary%TYPE
        EmpDni      Char(9)
    ...
    
1.2.- Text output:
-- For printing text output in console we will need to use DBMS_OUTPUT package 

    DBMS_OUTPUT.function(...)
    
 -> DBMS_OUTPUT.put('Comment ... ');
 -> DBMS_OUTPUT.put_line('Line comment ...');
 -> DBMS_OUTPUT.new_line();
 
1.2.- Embedded SQL instructions (SELECT INTO):
-- How to bring data form a table to our variables to operate with them? That's 
-- what select into instruction solves.

    DECLARE
        var1 type1;
        ...
        varn typen;
    BEGIN   
        select attribute1, ... , attributen
        into   var1,       ... , varn
        from table1, ... , tablep
        where ...
           
    END;
    
    This instruction will take the query result values into the variables defined.
    
 -> If the result of the query is more than one tuple, ERROR!
 -> If the result of the query is no tuple,            ERROR!
 
1.3.- Embedded SQL instructions (INSERT,UPDATE,DELETE):
    
    DECLARE
        var1 type1;
        ...
        varn typen;
    BEGIN
        update tablei set attribute=operation(var1, ... ,varn) where ...;
        insert into talbej select attributes from ...;
        insert into tablek values (var1, ... , varn);
        delete from talel  where condition(var1, ... ,varn, attribute1, ..., );
        
    END;
    
1.4.- Conditional sentences (IF):
    
    IF condition1 THEN
        -- statements
    ELSIF condition2 THEN
        -- statements
    ELSIF condition3 THEN
        -- statements
    ELSE    
        -- statements
    END IF;
    
1.5.- Conditional sentences (CASE):

    CASE selector 
        WHEN expression1 THEN result1
        WHEN expression2 THEN result2
        ...
        WHEN expressionN THEN resultN
        
        ELSE defaultExpression
    END; 
    
1.6.- Loops:

    LOOP
        --statements
        EXIT WHEN condition;
    END LOOP;
    
    WHILE condition LOOP 
        --statements
    END LOOP;

    FOR counterValue IN [REVERSE] initValue..endValue
    LOOP
        --statements
    END LOOP;
    
    -- CounterValue will automatically be declared and should't be inside the
    -- DECLARE statement.

1.7.- Cursors:

    
    
