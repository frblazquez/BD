-- Francisco Javier Blázquez Martínez ~ frblazqu@ucm.es
--
-- Double grado Matemáticas-Ingeniería informática.
-- Universidad Complutense de Madrid.
--
-- Descripción:
-- ¿Somos capaces de representar funciones en SQL?


/abolish
/sql
/multiline on
/duplicates on


-- Comentarios:
-- 
-- Representamos la función especificada en FUNCTION de la claúsula with en el intervalo
-- [MIN_X,MAX_X] con una precisión y deformación relativa del eje x y el eje y variables.
--
-- Podemos refinar la precisión del dibujo aumentando estas constantes de ejecución.
--
-- He representado la función seno,coseno,exponencial y raíz cuadrada para probar que el
-- esquema es en efecto general. (todas se muestran entre 0 y 4*pi).

-- Procedimiento:
-- 
-- 1.- Tomar el origen y final del intervalo del dominio (constantes de la cláusula with 
--     que puede cambiar el usuario). 
-- 2.- Dividir este intervalo en tantas divisiones como indique el usuario. 
-- 3.- Tomar un punto para cada uno de los subintervalos tomados. (el menor en este caso).
-- 4.- A partir del aptd. anterior, asignar a cada punto del dominio su imagen.
-- 5.- Tomar el mínimo y máximo de la imagen.
-- 6.- Dividir el rango de la imagen en los subintervalos indicados por el usuario.
-- 7.- Asignar a cada subintervalo de la imagen una representación respetando proporciones.
-- 8.- Tomar para cada punto del dominio, la representación de su punto imagen.


create view FUNCION_SENO as

with
	
	MIN_X(minX)  as (select 0    from dual), 	-- Mínimo valor de x a representar
	MAX_X(maxX)  as (select 4*pi from dual),	-- Máximo valor de x a representar
	DIV_X(divX)  as (select 50   from dual),	-- Número de divisiones en el eje x
	
	STEP_X(stepX)    as (select (maxX-minX)/divX from MAX_X,MIN_X,DIV_X),
	POINTS_X(pointX) as ((select minX from MIN_X) union
                         (select pointX+stepX from POINTS_X,STEP_X,MAX_X where pointX<maxX)),
	FUNCTION(x,y) as (select pointX, sin(pointX) from POINTS_X),

	MIN_Y(minY)   as (select min(y) from FUNCTION),	-- Mínimo valor de y a representar
	MAX_Y(maxY)   as (select max(y) from FUNCTION),	-- Máximo valor de y a representar
	DIV_Y(divY)   as (select 30 from dual),			-- Número de divisiones en el eje y
	STEP_Y(stepY) as (select (maxY-minY)/divY from MAX_Y,MIN_Y,DIV_Y),

	CONVERTER(i, a, b, representation) as

		((select 0,minY-stepY, minY,'' from MIN_Y,STEP_Y) union
         (select i+1,a+stepY,b+stepY, (representation || ' ')
          from CONVERTER,STEP_Y,MAX_Y
          where a<=maxY))

select x,representation 
from   FUNCTION,CONVERTER
where  a<=y and y<b;

create view FUNCION_COSENO as

with
	
	MIN_X(minX)  as (select 0    from dual), 	-- Mínimo valor de x a representar
	MAX_X(maxX)  as (select 4*pi from dual),	-- Máximo valor de x a representar
	DIV_X(divX)  as (select 50   from dual),	-- Número de divisiones en el eje x
	
	STEP_X(stepX)    as (select (maxX-minX)/divX from MAX_X,MIN_X,DIV_X),
	POINTS_X(pointX) as ((select minX from MIN_X) union
                         (select pointX+stepX from POINTS_X,STEP_X,MAX_X where pointX<maxX)),
	FUNCTION(x,y) as (select pointX, cos(pointX) from POINTS_X),

	MIN_Y(minY)   as (select min(y) from FUNCTION),	-- Mínimo valor de y a representar
	MAX_Y(maxY)   as (select max(y) from FUNCTION),	-- Máximo valor de y a representar
	DIV_Y(divY)   as (select 30 from dual),			-- Número de divisiones en el eje y
	STEP_Y(stepY) as (select (maxY-minY)/divY from MAX_Y,MIN_Y,DIV_Y),

	CONVERTER(i, a, b, representation) as

		((select 0,minY-stepY, minY,'' from MIN_Y,STEP_Y) union
         (select i+1,a+stepY,b+stepY, (representation || ' ')
          from CONVERTER,STEP_Y,MAX_Y
          where a<=maxY))

select x,representation 
from   FUNCTION,CONVERTER
where  a<=y and y<b;

create view FUNCION_EXP as

with
	
	MIN_X(minX)  as (select 0    from dual), 	-- Mínimo valor de x a representar
	MAX_X(maxX)  as (select 4*pi from dual),	-- Máximo valor de x a representar
	DIV_X(divX)  as (select 50   from dual),	-- Número de divisiones en el eje x
	
	STEP_X(stepX)    as (select (maxX-minX)/divX from MAX_X,MIN_X,DIV_X),
	POINTS_X(pointX) as ((select minX from MIN_X) union
                         (select pointX+stepX from POINTS_X,STEP_X,MAX_X where pointX<maxX)),
	FUNCTION(x,y) as (select pointX, exp(pointX) from POINTS_X),

	MIN_Y(minY)   as (select min(y) from FUNCTION),	-- Mínimo valor de y a representar
	MAX_Y(maxY)   as (select max(y) from FUNCTION),	-- Máximo valor de y a representar
	DIV_Y(divY)   as (select 30 from dual),			-- Número de divisiones en el eje y
	STEP_Y(stepY) as (select (maxY-minY)/divY from MAX_Y,MIN_Y,DIV_Y),

	CONVERTER(i, a, b, representation) as

		((select 0,minY-stepY, minY,'' from MIN_Y,STEP_Y) union
         (select i+1,a+stepY,b+stepY, (representation || ' ')
          from CONVERTER,STEP_Y,MAX_Y
          where a<=maxY))

select x,representation 
from   FUNCTION,CONVERTER
where  a<=y and y<b;

create view FUNCION_RAIZ as

with
	
	MIN_X(minX)  as (select 0    from dual), 	-- Mínimo valor de x a representar
	MAX_X(maxX)  as (select 4*pi from dual),	-- Máximo valor de x a representar
	DIV_X(divX)  as (select 50   from dual),	-- Número de divisiones en el eje x
	
	STEP_X(stepX)    as (select (maxX-minX)/divX from MAX_X,MIN_X,DIV_X),
	POINTS_X(pointX) as ((select minX from MIN_X) union
                         (select pointX+stepX from POINTS_X,STEP_X,MAX_X where pointX<maxX)),
	FUNCTION(x,y) as (select pointX, sqrt(pointX) from POINTS_X),

	MIN_Y(minY)   as (select min(y) from FUNCTION),	-- Mínimo valor de y a representar
	MAX_Y(maxY)   as (select max(y) from FUNCTION),	-- Máximo valor de y a representar
	DIV_Y(divY)   as (select 30 from dual),			-- Número de divisiones en el eje y
	STEP_Y(stepY) as (select (maxY-minY)/divY from MAX_Y,MIN_Y,DIV_Y),

	CONVERTER(i, a, b, representation) as

		((select 0,minY, minY+stepY,'' from MIN_Y,STEP_Y) union
         (select i+1,a+stepY,b+stepY, (representation || ' ')
          from CONVERTER,STEP_Y,MAX_Y
          where a<maxY))

select x,representation 
from   FUNCTION,CONVERTER
where  a<=y and y<b;


select representation from FUNCION_SENO   order by x;
select representation from FUNCION_COSENO order by x;
select representation from FUNCION_EXP    order by x;
select representation from FUNCION_RAIZ   order by x;

/duplicates off
/multiline off
/datalog
