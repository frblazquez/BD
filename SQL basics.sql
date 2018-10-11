-- Francisco Javier Blázquez Martínez ~ frblazqu@ucm.es
--
-- Double degree in Mathematics-Computer engineering.
-- Complutense university, Madrid.
--
-- Description: SQL instruction and basic content.

1.- DATA DEFINITION LANGUAGE:

1.1.- Tables and relations creation:

CREATE TABLE table_name
(
	atribute1_name type, -- Cualifiers
	atribute2_name type, -- Cualifiers
	atribute3_name type, -- Cualifiers
	...            ...
	...            ...
	atributen_name type, -- Cualifiers

	PRIMARY KEY(atributei_name, ..., atributej_name),
 -- FOREIGN KEY(atributek_name) REFERENCES other_table(atribute)
);

Common types: 
	- INT
	- VARCHAR(nElems)
	- DECIMAL
	- CHAR
	- DATE

Cualifiers availables:
	- NOT NULL			-- This doesn't let insert elements with this atribute null
	- CHECK(condition)	-- This doesn't let insert elements that don't verify the condition
	- PRIMARY KEY 		-- For those elements (not null) that are part of the table key
	- FOREIGN KEY 		-- For elements that are keys in another table
	- REFERENCES 		-- If the element marked as reference is not in the reference table
						-- we don't let inserting it
	
	-- DUDA! don't let inserting? insert? to insert?

2.- DATA MODIFICATION LANGUAGE:

2.1 - Tables and relations schema modification and deletion:
	-- DUDA! deletion??

-- To add a new field (not inserting element):
ALTER TABLE table_name ADD atribute_name type;

-- To modify an atribute:
ALTER TABLE table_name MODIFY atribute_name newType;

-- To delete a whole field:
ALTER TABLE table_name DROP atribute_name;

-- To delete a whole table (CAUTION!):
DROP TABLE  table_name;
	-- DUDA! las tablas a las que referencia deben ser borradas antes?? Si. ¿Por qué?

2.2.- Tables and relations content modification and deletion:

-- To delete elements:
DELETE FROM table_name;	-- DUDA! No borra el esquema pero sí todas las tuplas ¿no?
DELETE FROM table_name WHERE conditions;

-- To modify the tuples of the relation:
---- We can update all the tuples or just those that verify a condition.
	-- DUDA! those that?? no creo que sea correcto
UPDATE table_name SET atributei = expresioni, ... , atributej = expresionj;
UPDATE table_name SET atributes = expresions WHERE conditions;

-- To insert new elements into "table_name(atribute1_name, ... , atributen_name)":
---- We can insert specifying the atributes order or avoid specifying these if we follow
---- the table schema. We can also insert multiple values using '()' and commas. 
---- It's posible to insert a subset of atributes, the others will be initialized as null.
----
---- We'll see later that it's even possible to insert the result we get from a request. 
---- However we can't insert in a table the result of a request using that same table!!.
INSERT INTO table_name(atribute1_name, ... , atributen_name) VALUES (atribute1_value, ... , atributen_value);
INSERT INTO table_name(atributei_name, ... , atributej_name) VALUES (atributei_value, ... , atributej_value);
INSERT INTO table_name(atributei1_name,... ,atributeik_name) VALUES (atributei1_value,... ,atributeik_value);
INSERT INTO table_name VALUES (atribute1_value, ... , atributen_value);
INSERT INTO table_name VALUES
(atribute11_value, ... , atribute1n_value),
(atribute21_value, ... , atribute2n_value),
...			...			...			...
...			...			...			...
(atributem1_value, ... , atributemn_value);

3.- DATA MANIPULATION LANGUAGE:

3.1.- Select instruction:
-- In the datalog system, we used many instruction direcly related to operations used
-- in relational algebra. SQL however is english-language based. We won't have a proyection
-- instruction, cartesian product, division... Select instruction mostly englobes all of
-- this operations.

-- General schema:
SELECT atribute1_name, ... , atributen_name			-- Projection list, atributes or expresions to project
													--
  FROM  table1_name, ......... , tablek_name		-- Relations or views to take atributes from
  WHERE coindition1, ......... , conditionm			-- Tuples selection condition
  													--
  GROUP BY atributei_name, ... , atributej_name		-- Atributes to group
  HAVING   condition1, ....... , conditionl			-- Atributes selection condition
  													--
  ORDER BY atributer_name, ... , atributep_name;	-- Atributes name to order (descending default)
  														--DUDA! Repasito de inglés a esta parte

-- All rows proyection:
SELECT * FROM table_name;

-- Basic schema:
SELECT  atribute1_name, ... , atributen_name		-- Atributes we finally get
  FROM  table1_name, ...... , tablek_name			-- Relations where we get the tuples
  WHERE condition1, ....... , conditionr;			-- Condition for a tuple to be selected

-- If we don't want duplicates (Mostly used):
SELECT DISTINCT atributes FROM tables WHERE conditions;












