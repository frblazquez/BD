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
	- BIGINT
	- VARCHAR(nElems)
	- DECIMAL
	- REAL
	- FLOAT
	- DOUBLE PRECISION
	- CHAR
	- DATE
	- TIME
	- TIMESTAMP


Cualifiers availables:
	- NOT NULL			-- This doesn't let insert elements with this atribute null
	- CHECK(condition)	-- This doesn't let insert elements that don't verify the condition
	- PRIMARY KEY 		-- For those elements (not null) that are part of the table key
	- FOREIGN KEY 		-- For elements that are keys in another table
	- REFERENCES 		-- If the element marked as reference is not in the reference table
						-- we don't let inserting it


2.- DATA MODIFICATION LANGUAGE:

2.1 - Tables and relations schema modification and removal:

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
---- We can update all the tuples or just those verifying a condition.
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

-- If we want duplicates (default case):
SELECT ALL atributes FROM tables WHERE conditions;

-- If an atribute name is repeated we use "table_name." + "atribute_name":
SELECT tablei.atribute FROM table1, ... , tablei, ... , tablen WHERE conditions;

3.2.- Set operators:
-- These always operate taking sql sentences, we can't use:
-- table1_name union table2_name NOT ALLOWED!
-- It's also remarcable that these operators delete duplicates.

-- Union:
SELECT * FROM table1_name UNION     SELECT * FROM table2_name;

-- Intersection:
SELECT * FROM table1_name INTERSECT SELECT * FROM table2_name;

-- Difference (use except! don't use difference):
SELECT * FROM table1_name EXCEPT    SELECT * FROM table2_name;

3.3.- Rows selection, conditions:

-- Inside a where clause we can specify some selection conditions for the rows of our
-- relation. Wich conditions are allowed? How can we specify those conditions?
WHERE ~ Tuples selection predicates ~

- Comparation:           <,>,<=,>=,=,<> (means distinct in sql)
- Range:                 BETWEEN, NOT BETWEEN	
- Null condition:        IS NULL, IS NOT NULL
- Content:               IN, NOT IN 			-- Needs example IN SET ~ IN (1,5,10)
- About other relations: ALL, SOME/ANY
- Existence condition:   EXISTS 
- Pattern identifyer:    LIKE, NOT LIKE 		-- Needs example LIKE PATTERN ~ LIKE '_D%' means second character is 'D'
- Multiple conditions:   AND, OR


3.4.- Ordered output:

-- We can specify the atributes we can order by and if we want to order ascendently or
-- descendently. This operation might have a really high time cost.
ORDER BY ~ Atributes and modifyers ~

ORDER BY atributei ASC, ... , atributej DESC;	-- This request are the same,
ORDER BY atributei    , ... , atributej DESC;	-- Default ordenation is ascendent

3.5.- Rename of relations and atributes:

-- To rename some atributes in an expresion we use "AS":
SELECT atribute1_name AS atribute1_newName, ... , atributen_name AS atributen_newName ...

-- Sometimes, a relation gets involved more than once in a request, we need to rename it,
-- for doing this we just write the new identifyer next to the table name in the from:
SELECT atributes FROM table1_name table1_newName, ... , tablek_name tablek_newName ...

3.6.- Expresions:
-- Many times we won't need an atribute but we'll need a function involving many atributes,
-- we then will have to use agregation functions (we'll discuss about them later) and expressions
-- such as aritmetic functions or literals. We can also use this expressions inside a condition.

- Aritmetic operators: 		+,-,*,/
- Mathematics functions:	abs, power, %, floor, ceiling, round, trunc	-- Floor gets higher int <= value
- String functions: 		lower, upper, rtrim, ltrim, substring, +	-- Ltrim deletes the blank spaces at 
																		-- the front of the string

3.7.- Quering several tables:
-- Inside the from clause we can specify more than one relation to be considered, this will be
-- considered as a cartesian product in relational algebra. Another important point is that inside
-- the from clause we can also rename a relation, this is necessary when we are doing an inside table
-- request.

-- Simple cartesian product:
SELECT atributes FROM table1_name, ... , tablen_name;

-- Join, cartesian product and conditions:
SELECT atributes FROM table1_name, ... , tablen_name WHERE conditions;

-- Outer join, join without loss of information (mostly present in from clause):
table1_name INNER JOIN       table2_name ON conditions;	-- Tuples on the cartesian product that check the condition
table1_name LEFT OUTER JOIN  table2_name ON conditions;	-- Not losing table1_name information 
table1_name RIGHT OUTER JOIN table2_name ON conditions; -- Not losing table2_name information
table1_name FULL OUTER JOIN  table2_name ON conditions; -- Not losing information from both tables

-- Natural join, equal atributes names equal values (mostly present in from clause):
-- We can choose the atributes to consider in the natural join, and avoid loss of information.
table1_name NATURAL JOIN table2_name;
table1_name NATURAL JOIN table2_name USING atributei_name, ... , atributej_name;
table1_name NATURAL JOIN table2_name ON conditions;
table1_name NATURAL RIGHT OUTER JOIN table2_name ON conditions; 

-- If we aren't in a from clause we need to specify the select * from before a relation.

3.8.- Agregation functions and group by:
-- Functions that acts taking the colums of relations, considering atributes. We can specify the
-- colums to consider and how to group the other atributes.

Agregation functions:
	- SUM()	-- Just for numbers
	- AVG()	-- Just for numbers
	- MIN()
	- MAX()
	- COUNT(*) 					-- Number of tuples verifying a condition (also null values)
	- COUNT(atribute_name)		-- Number of values in a column.
	- COUNT(DISTINCT atribute)	-- Number of distinct values in a column.

Group_by:
-- We use this to use the agregate functions over specific groups. We can select only the groups
-- of atributes verifying some condition using a having clause.

SELECT atributes, agregation functions AS column names
  FROM tables
 WHERE conditions

GROUP BY atributes
HAVING   conditions

-- This group the relation by the atributes in group by using only the tuples verifying the where
-- condition. Then this gets the values for the atributes and agregation functions in select list
-- and finally gets only those that verify the having conditions.

3.9.- Select instruction execution:

	1.  Get only the tuples verifying where clause.
	2.  Group these by the atributes in group_by clause.
	3.  Get only those groups verifying having clause.
	4.  Calculate the agregation functions necessaries.
	5.  Order the tuples following the order_by clause.


4.- SUBREQUESTS:
-- DUDA! revisar el inglés!!
-- A subrequest is nothing else than a select clause inside another select instruction. This 
-- subrequest can be placet at select projection list, from or even the where.

-- Subrequest in the projection list:
SELECT atribute1, ... , (SELECT olny_atribute FROM ...) 
FROM   tables 
WHERE  conditions;

-- Subrequest as tables in the from clause:
SELECT atributes 
FROM   table1, ... , (SELECT atributes FROM ...) AS tablen_name 
WHERE  conditions;

-- Subrequest as condition element in the where clause:
SELECT atributes
FROM   tables
WHERE  elem1 condition (SELECT atributes FROM ...);

-- For subrequests returning only one value we can use comparators <>, =, <= ...
-- For subrequests more complicated we can use IN, NOT IN, SOME, ANY, and ALL.
SELECT atributes 
FROM   tables 
WHERE  elem IN (SELECT atribute FROM ...)

SELECT atributes 
FROM   tables
WHERE  elem condition ALL (SELECT atribute FROM ...)

-- Correlationed requests, we need to refer in the subrequest to the request:
SELECT atributes 
FROM   table t   						-- We rename the relation 
WHERE  condition (subrequest) 			-- now we can refer to the request table in the subrequest

-- Correlationed request with exists:
SELECT atributes 
FROM   table t
WHERE  EXISTS (SELECT elements FROM tablek WHERE condition(subrequest))


5.- VIEWS VS TABLES:
-- A table (or relation) is a data schema storing information. A view is going to be 
-- an operation involving tables. Then when using a table we use directly stored data
-- but every time we use a view the system will need to execute an operation to get the 
-- result.
-- Views will be useful for protecting data stored to some users and also to get a safer
-- system by don't letting users to modify de db schema.

CREATE VIEW view_name AS (expression) 

-- Dependence among views:
CREATE VIEW view1 AS (expression using view2)  -- view1 depends directly on view2
CREATE VIEW viewk AS (expression using views)  -- viewk depends on all used views or their dependences
CREATE VIEW viewR AS (expression using viewR)  -- Recursive view definition

-- The problem of actualicing the views, what to do?

-- Materialized views, physical copy containing the result of an expresion:
CREATE MATERIALIZED VIEW view1 AS (expression) -- Need to maintain the view updated

-- Local views, views for just one sql instruction
WITH 
localView1(atribute11, ... , atribute1k) AS expression
localView2(atribute21, ... , atribute2i) AS expression
...				...				 ...				...
localViewn(atributen1, ... , atributenj) AS expression
request(involving localViews);


6.- SQL RECURSIVE:
-- Examples for this time, it's complicated to see a general schema.
