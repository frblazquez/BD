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
-- What can we do if an query returns more than one tuple? We create an cursor
-- and then we can move throught the tuples returned.
-- A cursor has an pointer pointing to the tuples returned. We can make the pointer
-- advance.

    DECLARE
        ...
        CURSOR cursorName IS selectSentence;
        ...
    BEGIN   
        ...
        OPEN cursorName;
        ...
        FETCH cursorName INTO var1, ... ,varN;
        ...
        CLOSE cursorName;
        ...
    
    END;
    
 -> When we open the cursor, the select sentence is executed and the pointer
    is placed at the first tuple returned.
 -> The cursor stored the tuple data in the variables (the types must be exactly
    the same than the table attributes) and the pointer moves to the next tuple.
 -> When the cursor is closed the occupied memory is released. We can reopen the
    cursor later.
    
    How to know the cursor state? Cursor attributes!
 -> %NOTFOUND   - Returns true if last fetch did not return a tuple.
 -> %FOUND      - Returns true if last fetch returned a tuple.
 -> %ROWCOUNT   - Returns the tuples traveled.
 -> %ISOPEN     - Returns true if the cursor is opened.
        
    Sometimes we want a cursor to depend on some parameters, this is, we want to
    calculate the select sentence wich result our cursor will point depending on
    some values. We can create cursors depending on parameters this way:
    
    CURSOR cursorName(param1 type1, ... , paramN typeN) IS selectSentence(params);
    
    To open this cursor we give it the params between parenthesis.
    
    OPEN cursorName(param1Value, ... ,paramNValue);
    
1.8.- Records:
-- This is nothing else but a struct or a TAD we can define. Some variables grouped
-- with an easy common access. This should be done on a DECLARE clause. 

    TYPE recordName IS RECORD
    (
        field1Name type1,
        field2Name type2,
        ...
        fieldNName typeN
    );
    
 -> We can define a record with the structure of a tuple with %ROWTYPE. Example:
    record1Name table1%ROWTYPE;

1.9.- Exceptions:
-- We can create our own exceptions, throw them, treat them and react against 
-- errors Oracle throws during an program execution.

    DECLARE
        ...
    BEGIN   
        ...
    EXCEPTION
        WHEN exception1 [or exception2 or ... ] THEN
            --statements
        WHEN exceptionI THEN
            --statements
        ...
        ...
        WHEN OTHERS THEN
            --statements
    END;
    
    We can also declare our exceptions inside the DECLARE clause and throw them
    when we tetect some kind of error. The type they should have is EXCEPTION.
    We throw this exceptions with a RAISE statement.
    
    DECLARE
        ...
        excptName EXCEPTION;
        ...
    BEGIN   
        ...
        IF excptCondition THEN
            RAISE excptName;
        END IF;
        ...

1.10.- Procedures:
-- As in imperative programming languajes, these lets us to re-use the code. These
-- are named blocks wich we can refer.

CREATE [OR REPLACE] PROCEDURE procName[(param1 mode1 type1, ... , paramN modeN typeN)] IS
    -- declarations
    BEGIN
    -- statements
    EXCEPTION
    -- Exceptions treatment
    END;
    
 -> Mode is the parameter type, IN, OUT OR IN OUT

1.11.- Functions:
-- These are nothing but procedures returning one value

CREATE [OR REPLACE] FUNCTION funcName[(param1 mode1 type1, ... , paramN modeN typeN)]
                    RETURN dataType IS
    -- declarations
    BEGIN
    -- statements
    -- RETURN instruction
    EXCEPTION
    -- Exceptions treatment
    END;
    
 -> Mode is the parameter type, IN, OUT OR IN OUT
