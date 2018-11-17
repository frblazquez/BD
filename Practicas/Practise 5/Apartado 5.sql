-- FRANCISCO JAVIER BLÁZQUEZ MARTÍNEZ   ~ frblazqu@ucm.es
-- MANUEL ORTEGA SALVADOR               ~ manuor01@ucm.es
--
-- Doble grado Ingeniería informática - Matemáticas
--	Universidad Complutense de Madrid.

/*
    This method checks wether "Código postal" attribute in "Códigos postales I"
    table is a primary key or not.
*/
CREATE OR REPLACE PROCEDURE comprobar_PK IS
    
    /* We define a cursor to point the tuples with some value NULL */
    CURSOR tuplasConClavePrimRep IS 
    
        SELECT DISTINCT cp1."Código postal"
        FROM "Códigos postales I" cp1, "Códigos postales I" cp2
        WHERE (cp1."Código postal" = cp2."Código postal" 
              AND (cp1.Población != cp2.Población 
              OR   cp1.Provincia != cp2.Provincia))
              OR   cp1."Código postal" IS NULL;
               
    /* Variables needed for doing FETCH */
    postCode "Códigos postales I"."Código postal"%TYPE;
    
    /* Exception to be thrown */
    tuplesWithNull exception;
    duplicatedPrimKey exception;
    
BEGIN
    
    OPEN tuplasConClavePrimRep;
    
    FETCH tuplasConClavePrimRep INTO  postCode;
    
    WHILE tuplasConClavePrimRep%FOUND LOOP
        
        IF postCode IS NULL THEN
            RAISE tuplesWithNull;  
        ELSE
            RAISE duplicatedPrimKey;
        END IF;
        
        FETCH tuplasConClavePrimRep INTO  postCode;
    END LOOP;
    
    CLOSE tuplasConClavePrimRep;

EXCEPTION

    WHEN tuplesWithNull THEN
        DBMS_OUTPUT.put_line('Se ha encontrado una tupla con clave primaria nula');
    WHEN duplicatedPrimKey THEN
        DBMS_OUTPUT.put_line('Se ha encontrado uba clave primaria repetida');
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Oh,Oh; this is unexpected!');
END;


