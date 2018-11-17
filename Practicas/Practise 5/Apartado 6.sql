-- FRANCISCO JAVIER BLÁZQUEZ MARTÍNEZ  ~ frblazqu@ucm.es
-- MANUEL ORTEGA SALVADOR              ~ manuor01@ucm.es
--
-- Doble grado Ingeniería informática - Matemáticas
--	Universidad Complutense de Madrid.

/*
    This procedure checks whether "Código pstal" attribute in "Domicilios I"
    table is a foreign key from "Códigos postales I" table.
*/
CREATE OR REPLACE PROCEDURE comprobar_FK(numErrorsLimit IN integer) IS
    
    /* We define a cursor to point the tuples with some value NULL */
    CURSOR  foreignKeyViolations IS 
    
        SELECT "Domicilios I"."Código postal","Domicilios I".DNI
        FROM   "Domicilios I","Códigos postales I"
        WHERE  "Domicilios I"."Código postal" 
        NOT IN (select "Código postal" from   "Códigos postales");
               
    /* Variables needed for doing FETCH */
    postCode "Domicilios I"."Código Postal"%TYPE;
    empDni   "Domicilios I".DNI%TYPE;
    
    /* Counter variable */
    counter integer := 0;
    
    /* Exception to be thrown */
    FK_VIOLATION Exception;
    
BEGIN
    
    OPEN  foreignKeyViolations;
    
    FETCH foreignKeyViolations INTO  postCode,empDni;
    
    WHILE foreignKeyViolations%FOUND and counter<numErrorsLimit LOOP
        DBMS_OUTPUT.put_line('El código postal ' || postCode || ' (empleado con DNI ' || empDni ||  ') es una FK_VIOLATION.');
        counter := counter+1;
        
        FETCH foreignKeyViolations INTO  postCode,empDni;
    END LOOP;
    
    CLOSE foreignKeyViolations;
    
    IF counter!=0 THEN
        RAISE FK_VIOLATION;
    END IF;

EXCEPTION

    WHEN FK_VIOLATION THEN
        DBMS_OUTPUT.put_line('Se han encontrado ' || counter || ' violaciones de clave foránea.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Oh,Oh, this is unexpected!');
END;

/*
EXECUTE comprobar_PK(1);
EXECUTE comprobar_FK(2);

select * from "Códigos postales I";
select * from "Domicilios I";

SHOW ERRORS;

UPDATE "Códigos postales I" 
SET "Código postal"='14900'
WHERE "Código postal" IS NULL;

INSERT INTO "Domicilios I" VALUES
('47399024A', 'Petrenko', '33333');

INSERT INTO "Domicilios I" VALUES
('47399024B', 'PetrenkoB', '33334');
*/
