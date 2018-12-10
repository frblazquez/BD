-- Francisco Javier Blázquez Martínez ~ frblazqu@ucm.es
--
-- Double grado Matemáticas-Ingeniería informática.
-- Universidad Complutense de Madrid.
--
-- Descripción: Dibujar la función definida implícitamente como x² + y² = 1.


/abolish
/sql
/multiline on
/duplicates on

-- Comentarios: IMPORTANTE LEER PÁRRAFO EN MAYÚSCULAS!
--
-- He tratado de explicar paso a paso lo que he ido haciendo para que sea más 
-- sencillo de corregir, no se si lo he conseguido con éxito así que incluyo
-- aquí otras aclaraciones.
--
-- 1.- Particionar el dominio (en la línea del acertijo anterior)
-- 2.- Obtener los puntos imagen para cada punto del dominio
-- 3.- Particionar el espacio imagen, con la diferencia con respecto al acertijo
--     anterior de que en este caso particionamos de forma distinta los valores 
--     positivos de los negativos (el por qué de esto es el siguiente apartado).
-- 4.- Asignar a cada subintervalo del espacio imagen una representación, la dife-
--     rencia con respecto al acertijo anterior es que esta representación cambia
--     para los valores positivos y los negativos (dos consultas diferentes) y que
--     hay que completar con espacios en blanco hasta llegar a los 25 caracteres.
-- 5.- Asignar a cada punto del dominio la representación de sus valores negativos
--     concatenados a los positivos (negativos izquierda, positivos derecha).
--
-- X_IMAGES: Vista que contiene puntos de x, imagen positiva (mas) y neg. (menos).
-- POS_REP:  Vista que contiene subintervalos positivos de Y y representación.
-- NEG_REP:  Vista que contiene subintervalos negativos de Y y representación.
--           En esta vista ini y fin se permutan para que fin sea mayor que ini.
-- POS_Y_REPRESENTATION: Vista POS_REP sin completar a 25 caracteres.
-- NEG_Y_REPRESENTATION: Vista NEG_REP sin completar a 25 caracteres.
--
--
-- DEBIDO AL ALTO COSTE DE PROCESAMIENTO DE LA CONSULTA FINAL, LA QUE DEBE GENERAR
-- EL DIBUJO EN CONSOLA, ESTA RESULTA EN UN TIMEOUT EXCEDED. NO HE PODIDO POR TANTO
-- PROBAR LA CORRECCIÓN DE ESTA ÚLTIMA CONSULTA. SI HE TESTEADO LAS ANTERIORES POR
-- LO QUE CONFÍO EN LA CORRECCIÓN DE ESTA (SIMPLEMENTA HACE UN INNER JOIN).
--
-- Represento tras esta consulta fallida la parte de mi trabajo más cercana al objetivo
-- que no presenta time limit, la representación de los subintervalos.

-- 1.- Partición del espacio de dominio:
create view PARTITION_X(x) as

with

	MIN_X(m) as (select -1.0 from dual),
	MAX_X(M) as (select  1.0 from dual),
	DIV_X(d) as (select  50  from dual),
	STEPX(s) as (select (M-m)/d from MIN_X,MAX_X,DIV_X),

	PARTITION(x) as ((select m    from MIN_X) union
                     (select x+s  from PARTITION,STEPX,MAX_X where x+s<M) union
                     (select M    from MAX_X))

select * from PARTITION;

-- 2.- Imágenes para los puntos elegidos del dominio:
create view X_IMAGES(x,mas,menos) as

select x, sqrt(1.0 - x*x), -sqrt(1.0 - x*x) from PARTITION_X;

-- 3.- Partición del espacio de imagen:

---- 3.1.- Partición para los valores positivos:
create view PARTITION_Y_POSITIVES(i,y) as

with

	MIN_Y(m) as (select 0.0 from dual),
	MAX_Y(M) as (select 1.0 from dual),
	DIV_Y(d) as (select 25  from dual),
	STEPY(s) as (select (M-m)/d from MIN_Y,MAX_Y,DIV_Y),

	PARTITION(i,x) as ((select 0,m     from MIN_Y) union
                       (select i+1,x+s from PARTITION,STEPY,MAX_Y where x+s<M) union
                       (select d,M     from DIV_Y,MAX_Y))

select * from PARTITION;

---- 3.2.- Partición para los valores negativos:
create view PARTITION_Y_NEGATIVES(i,y) as

select 25-i, -1.0+y from PARTITION_Y_POSITIVES;

-- 4.- Asignación a cada intervalo del espacio imagen una representación:

---- 4.1.- Espacios en blanco para cada subintervalo (hasta 25):
create view SPACES(i,s) as

	(select 0,'' from dual) union (select i+1, s||' ' from SPACES where i<25); 

---- 4.2.- Subintervalo de valores positivos <-> representación:
create view POS_Y_REPRESENTATION(i,ini,fin,rep) as

with 
	
	POS_Y_INTERVALS(i,ini,fin) as 
						(select A.i, A.y, B.y 
                        from PARTITION_Y_POSITIVES A, PARTITION_Y_POSITIVES B 
                        where A.i+1=B.i)

select i,ini,fin, s||'.' from POS_Y_INTERVALS natural join SPACES;

---- Esta es la vista completada a 25 caracteres de longitud!
create view POS_REP(i,ini,fin,rep) as

select POS_Y_REPRESENTATION.i, ini, fin, rep||s
from SPACES, POS_Y_REPRESENTATION 
where SPACES.i=25-POS_Y_REPRESENTATION.i;

---- 4.2.- Subintervalo de valores negativos <-> representación:
create view NEG_Y_REPRESENTATION(i,ini,fin,rep) as

with 
	
	NEG_Y_INTERVALS(i,ini,fin) as 
						(select A.i, A.y, B.y 
                        from PARTITION_Y_NEGATIVES A, PARTITION_Y_NEGATIVES B 
                        where A.i+1=B.i)

select i,ini,fin,'.'||s from NEG_Y_INTERVALS natural join SPACES;

---- Esta es la vista completada a 25 caracteres de longitud!
create view NEG_REP(i,fin,ini,rep) as

select NEG_Y_REPRESENTATION.i, ini, fin, s||rep 
from SPACES, NEG_Y_REPRESENTATION 
where SPACES.i=25-NEG_Y_REPRESENTATION.i;

-- 5.- A cada valor de la imagen, un único intervalo de la partición de la imagen
--     la contiene, una única representación posible:
--
-- CONSULTA QUE DIBUJA EL CÍRCULO, RESULTA EN TIME LIMIT EXCEDED!!
select NEG_REP.rep || POS_REP.rep 
from NEG_REP,POS_REP,X_IMAGES 
where NEG_REP.ini <= menos and NEG_REP.fin>menos and
      POS_REP.ini <= mas   and POS_REP.fin>mas
order by x;

-- Representación de los subintervalos positivos:
-- select * from POS_REP;
-- select rep from POS_REP;
   select i,rep from POS_REP;

-- Representación de los subintervalos negativos:
-- select * from NEG_REP;
-- select rep from NEG_REP;
   select i,rep from NEG_REP;

-- Representación de los puntos dominio <-> imágenes:
-- select * from X_IMAGES;

/duplicates off
/multiline off
/datalog
