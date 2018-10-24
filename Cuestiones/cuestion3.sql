-- Francisco Javier Blázquez Martínez ~ frblazqu@ucm.es
--
-- Double grado Matemáticas-Ingeniería informática.
-- Universidad Complutense de Madrid.
--
-- Comentarios:	
-- OJO! /abolish aparece comentado para usar los datos de datos.dl.
-- He partido del esquema de tablas de datos.dl.
-- He usado la tabla intervalos del fichero datos.dl pero indico como obtenerla.
-- He optado por mostrar la solución como pares consulta-respuesta (solo es proyectar).


-- /abolish
/sql
/multiline on

-- 1.- Definimos las tablas que vamos a necesitar:
/*
create table viajes
(
	id     int,
	desde  date,
  	hasta  date,
	primary key (id)
);

create table consultas
(
	id    int,
	fecha date,
	primary key(id)
);

create table nacimiento
(
  	birth date,
	primary key (birth)
);
*/

-- 2.- Introducimos los datos en nuestra base:
/*
insert into  viajes values
	(1, date(1985,10,26),date(1955,10,26)),
	(2, date(1955,11,12),date(1985,10,26)),
	(3, date(1985,10,26),date(2015,10,21)),
	(4, date(2015,10,21),date(1985,10,26)),
	(5, date(1985,10,26),date(1955,11,12)),
	(6, date(1955,11,20),date(1885,9,2)),
	(7, date(1885,9,7),date(1985,10,27));

insert into consultas values
	(1, date(1955,11,5)),
	(2, date(1955,11,12)),
	(3, date(1985,10,26)),
	(4, date(2015,10,21));

insert into nacimiento values
	(date(1968, 6, 12));
*/

-- 3.- Resolvemos las consultas: 

/*
-- OBTENCIÓN DE LA TABLA INTERVALOS:
-- Relación de fechas f1, f2 tal que f1Rf2 => Marty pasa el intervalo f1,f2 en Hill Valley 
-- Podría haber errores si usaramos un select distinct.
-- El hecho de que Marty sea inmortal hace necesario añadir el intervalo vueltaUltimoViaje - finDelMundo

create view intervalos as

((select v1.hasta, v2.desde from viajes v1, viajes v2 where v1.id+1=v2.id)
union
(select birth,desde from nacimiento,viajes where id=1))
union
(select max(hasta),cast('9999-12-31' as date) from viajes);

*/

-- Ahora que ya sabemos como crear la relación "Intervalos" la usamos para mostrar la solución.
create view respuestaAlFicheroDl as

select fecha,count(*)
from fechas,intervalos
where fecha>=desde and fecha<=hasta
group by fecha;

select * from respuestaAlFicheroDl;

/multiline off
/datalog
