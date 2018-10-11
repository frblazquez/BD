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


