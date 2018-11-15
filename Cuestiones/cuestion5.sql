-- Francisco Javier Blázquez Martínez ~ frblazqu@ucm.es
--
-- Double grado Matemáticas-Ingeniería informática.
-- Universidad Complutense de Madrid.
--
-- Descripción:
-- Dada una tabla con canciones y número de descargas, asignarle a
-- cada una su posición en el ranking de descargas. A canciones con
-- mismo número de descargas se les asignara la misma posición en el
-- ranking.


/abolish
/sql
/multiline on

-- 1.- Tabla y datos de ejemplo:

CREATE TABLE hits
(
  theme     varchar(50) NOT NULL,
  downloads int         NOT NULL,
  
  PRIMARY KEY (theme,downloads)
);

INSERT INTO hits(theme, downloads) VALUES
('I Will Always Love You', 20),
('If I Didn''t Care', 19),
('In the Summertime', 31),
('It''s Now or Never', 20),
('My Heart will Go On', 25),
('Rock Around the Clock', 25),
('Silent Night', 30),
('We Are the World', 20),
('White Christmas', 50);


-- 2.- Solución obtenida:
-- Vamos a agrupar los distintos números de descargas, ordenarlos, asignarles
-- un número y luego hacer un natural join con la tabla de éxitos.

create view solución(theme,downloads,rank) as

	with

  --Número de descargas (sin repeticiones)
	downloads(n)        as (select distinct downloads from hits),
	
  --Contamos para cada nº de descargas en nº de descargas mayores (mas uno)
	download_rank(n, i) as (select d1.n,count(d2.n)+1
                            from downloads d1 left outer join downloads d2 
                            on d1.n < d2.n
                            group by d1.n)

  --Juntamos con los temas que tienen este número de descargas
	select theme,n,i
	from download_rank inner join hits 
	on n=downloads;

-- 3.- Mostramos la solución obtenida:
select * from solución order by rank;


-- 4.- Echarle la bronca al profesor porque sus hits están desactualizados!
--     Hecho.


/multiline off
/datalog
