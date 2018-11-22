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


-- Comentarios:
-- Partimos de una función dada en una tabla como puntos del dominio y correspondientes
-- imágenes (habitualmente podrá ser calculada gracias al polinomio de taylor, ver la 
-- cuestión 4).
-- La tabla con los datos de nuestra función tendrá un rango de valores del dominio y
-- un rango de valores de la imagen que nos interesa conocer para poder dibujar nuestra
-- función.

-- 1.- Función a representar. (f(x) = sen(x) en nuestro caso):
create table funcion
(
	puntoDominio float,
	puntoImagen  float,
  
  	primary key (puntoDominio) -- Nos garantiza que sea una función!
);

insert into funcion values
(0.0,0.0),
(0.2,0.199),
(0.4,0.389),
(0.6,0.565),
(0.8,0.717),
(1.0,0.841),
(1.2,0.932),
(1.4,0.985),
(1.6,1.0),
(1.8,0.974),
(2.0,0.909),
(2.2,0.808),
(2.4,0.675),
(2.6,0.516),
(2.8,0.335),
(3.0,0.141),
(3.2,-0.058),
(3.4,-0.256),
(3.6,-0.443),
(3.8,-0.612),
(4.0,-0.757),
(4.2,-0.872),
(4.4,-0.952),
(4.6,-0.994),
(4.8,-1.000),
(5.0,-0.959),
(5.2,-0.883),
(5.4,-0.773),
(5.6,-0.631),
(5.8,-0.465),
(6.0,-0.279),
(6.2,-0.083),
(6.4,0.0),
(6.8,0.199),
(7.0,0.389),
(7.2,0.565),
(7.4,0.717),
(7.6,0.841),
(7.8,0.932),
(8.0,0.985),
(8.2,1.0),
(8.4,0.974),
(8.6,0.909),
(8.8,0.808),
(9.0,0.675),
(9.2,0.516),
(9.4,0.335),
(9.6,0.141),
(9.8,-0.058),
(10.0,-0.256),
(10.2,-0.443),
(10.4,-0.612),
(10.6,-0.757),
(10.8,-0.872),
(11.0,-0.952),
(11.2,-0.994),
(11.4,-1.000),
(11.6,-0.959),
(11.8,-0.883),
(12.0,-0.733),
(12.2,-0.531),
(12.4,-0.215),
(12.6,-0.013);


-- 2.- Rango de la imagen de nuestra función:

create view RANGO_IMAGEN(miny,maxy) as 

select min(puntoImagen),max(puntoImagen) from funcion;

-- 3.- Numero de divisiones del rango de la imagen y a partir de este longitud de
--     los subintervalos de división de la imagen:

create view NUM_DIVISIONES(numDiv) as select 30 from dual;

create view STEP_IMG(step) as

select (maxy-miny)/numDiv from RANGO_IMAGEN,NUM_DIVISIONES;

-- 4.- Creamos ahora una vista de conversión intervalos imagen - string.
--     Esta vista asigna a intervalos de la imagen una representación de string

create view converter as

	with conv(indice, minim, maxim, representation) as
	
	((select 0,miny-step,miny,'' from RANGO_IMAGEN,STEP_IMG)
	 union
     (select indice+1,minim+step,maxim+step, (representation || ' ')
      from   conv,RANGO_IMAGEN,STEP_IMG
      where  minim<maxy))

select * from conv;


-- 5.- Para dibujar nuestra función, asignamos a cada punto del dominio la repre-
--     sentación de su imagen (usando la vista anterior):
create view plot as

select puntoDominio, representation 
from funcion, converter
where minim<=puntoImagen and maxim>puntoImagen;

select * from plot;

/multiline off
/datalog
