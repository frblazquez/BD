-- FRANCISCO JAVIER BL�ZQUEZ MART�NEZ  ~  frblazqu@ucm.es
-- MANUEL ORTEGA SALVADOR              ~  manuor01@ucm.es
--
--   Doble grado Ingenier�a inform�tica - Matem�ticas
--	 Universidad Complutense de Madrid.
--
-- Comentarios:
-- 
-- Hemos optado por convenio nombrar a las tablas de forma que cada barra baja '_' separe los atributos
-- de esta relaci�n y se representen los nombres de los atributos lo m�s fielmente posible. De esta forma
-- la relaci�n de empleados y proyectos en los que trabajan se podr�a nombrar "dniEmp_c�digoPr".

-- 0.- Eliminaci�n de tablas anteriores y configuraci�n para SQL:

-- 0.1.- Eliminar las relaciones que tuviera la bd
/abolish
-- 0.2.- Para procesar solo instrucciones SQL
/sql
-- 0.3.- Para permitir la inserci�n multilinea de instrucciones
/multiline on	


-- 1.- Definimos las tablas que vamos a necesitar:
create table programadores
(
	dni       varchar(9), 
	nombre    varchar(30) not null, 
	direcci�n varchar(50), 
	tel�fono  varchar(10), 
	primary key (dni)
);

create table analistas
(
	dni       varchar(9), 
	nombre    varchar(30) not null, 
	direcci�n varchar(50), 
	tel�fono  varchar(10), 
	primary key (dni)
);

create table proyectos
(
	c�digo      varchar(9), 
	descripci�n varchar(20), 
	dnidir      varchar(9), 
	primary key (c�digo)
);

create table distribuci�n
(
	c�digopr varchar(9), 
	dniemp varchar(9), 
	horas int default 0 check(horas>0), 
    primary key (c�digopr, dniemp), 
    foreign key (c�digopr) references proyectos(c�digo)
);

-- 2.- Introducimos los datos en nuestra base.
insert into  programadores values
	('1','Jacinto' ,'Jazm�n 4' ,'91-8888888'),
	('2','Herminia','Rosa 4'   ,'91-7777777'),
	('3','Calixto' ,'Clavel 3' ,'91-1231231'),
	('4','Teodora' ,'Petunia 3','91-6666666');

insert into  analistas values
	('4','Teodora' ,'Petunia 3','91-6666666'),
	('5','Evaristo','Luna 1'   ,'91-1111111'),
	('6','Luciana' ,'J�piter 2','91-8888888'),
	('7','Nicodemo','Plut�n 3' , NULL);

insert into proyectos values
	('P1','N�mina'      ,'4'),
	('P2','Contabilidad','4'),
	('P3','Producci�n'  ,'5'),
	('P4','Clientes'    ,'5'),
	('P5','Ventas'      ,'6');

insert into distribuci�n values
	('P1','1',10),
	('P1','2',40),
	('P1','4',5 ),
	('P2','4',10),
	('P3','1',10),
	('P3','3',40),
	('P3','4',5 ),
	('P3','5',30),
	('P4','4',20),
	('P4','5',10);

-- 3.- Realizamos las consultas
create view empleados as (select * from programadores) union (select * from analistas);
create view proyectosEvaristo as (select c�digopr from distribuci�n where dniemp='5');

-- 3.1.- Dni de todos los empleados, no usamos distinct por ser clave primaria:
create view vista1 as select dni from empleados;

-- 3.2.- Dni de los programadores que tambi�n son analistas:
create view vista2 as (select dni from programadores) intersect (select dni from analistas);

-- 3.3.- Dni de los empleados sin trabajo; no son directores ni asignados a proyectos:
create view vista3 as ((select *      from vista1)        except -- Todos los dnis
	                   (select dniemp from distribuci�n)) except -- Menos empleados asignados
                       (select dnidir from proyectos);			 -- Menos directores

-- 3.4.- C�digo de los proyectos sin analistas asignados:
create view vista4 as

(select c�digo   from proyectos) except 
(select c�digopr from analistas inner join distribuci�n on dni=dniemp);

-- 3.5.- Dni de los analistas que dirijan proyectos pero que no sean programadores:
create view vista5 as ((select dni from analistas) except    -- Dni de analistas
					   (select *   from vista2))   intersect -- Menos los que son programadores
                       (select dnidir from proyectos);		 -- Que adem�s son directores

-- 3.6.- Descripci�n de proyectos con nombres de programadores y horas asignadas a ellos
create view vista6 as

select descripci�n,nombre,horas
from proyectos,programadores,distribuci�n
where c�digo=c�digopr and dniemp=dni;

-- 3.7.- Tel�fonos compartidos por empleados:
create view vista7 as

select e1.tel�fono 
from empleados e1, empleados e2
where e1.dni<>e2.dni and e1.tel�fono=e2.tel�fono;

-- 3.8.- Utilizando natural join, dni de empleados que son analistas y programadores:
create view vista8 as select * 
from (select dni from analistas) natural join (select dni from programadores);

-- Cuidadito con esta porque creo que no funciona como aparenta
create view vista8b as select dni from analistas natural join programadores using dni;

-- 3.9.- N�mero totales de horas que trabaja cada empleado:
create view vista9 as

select dni, sum(horas) as sumaHoras		
from empleados,distribuci�n
where dni=dniemp
group by dni;

--Para mostrar tambi�n los trabajadores no asignados como 0 horas:
--union 		
--
--select dni,0				
--from (select * from vista1) except (select dniemp from distribuci�n);

-- 3.10.- Dni de todos los empleados, nombre y c�digo de proyecto asignado:
create view vista10 as

select dni,nombre,c�digopr
from empleados left outer join distribuci�n on dni=dniemp;

-- 3.11.- Dni y nombre de los que no tenemos un n�mero de tel�fono registrado:
create view vista11 as select dni,nombre from empleados where tel�fono is null;

-- 3.12.- Determinar el dni de los empleados que verifican:
--
--	(total de horas trabaja)          (total horas por proyecto)
--  ------------------------ <  media(---------------------------)
--  (num proyectos  trabaja)          (numero empleados proyecto)

create view segundoTermino(media) as

(select avg(cociente) from (
	select c�digopr, (sum(horas)/count(dniemp)) as cociente
	from distribuci�n
	group by c�digopr));

create view empleadosNumProyectos(dniemp,numProyectos) as

(select dniemp,count(*) as numProyectos
from distribuci�n
group by dniemp);

create view vista12 as
select dni
from vista9,empleadosNumProyectos,segundoTermino
where dni=dniemp and (sumaHoras/numProyectos < media);

-- 3.13.- Dni de empleados que trabajen en todos los proyectos que trabaja Evaristo (con divisi�n):

-- 3.14.- Dni de empleados que trabajen en todos los proyectos que trabaja Evaristo (sin divisi�n):
create view empleadosNoTrabajanSiempreEvaristo as

select dni
from ((select dni,c�digopr from vista1 inner join proyectosEvaristo)
	   except
	  (select dniemp,c�digopr from distribuci�n));

create view vista14 as

(select * from vista1) except (select * from empleadosNoTrabajanSiempreEvaristo);

-- 3.15.- Para cada proyecto y empleado (que no trabaje con Evaristo) mostrar n�mero de horas ampliado un 20%:
create view vista15 as

select c�digopr,dniemp,1.2*horas 
from distribuci�n 
where dniemp not in 
	(select dniemp 
     from distribuci�n 
     where c�digopr in (select * from proyectosEvaristo));


-- 3.16.- Empleados que dependen de evaristo (son dirigidos por �l o algui�n que depende de Evaristo):
create view vista16 as

with proyectosDependenEvaristo(c�digo) as
(
(select c�digo from proyectos where dnidir='5')
union 
(select c�digo from proyectos where dnidir in 							-- El dni del director
 					(select dniemp from distribuci�n where c�digopr in 	-- Es el dni de un empleado
                    (select * from proyectosDependenEvaristo)))		-- De un proyecto que depende de Evaristo
)		

select nombre from empleados,distribuci�n 
where dni=dniemp and dniemp<>'5' and c�digopr in (select * from proyectosDependenEvaristo);

-- 4.- Mostramos las vistas:
select * from vista1;
select * from vista2;
select * from vista3;
select * from vista4;
select * from vista5;
select * from vista6;
select * from vista7;
select * from vista8;
select * from vista9;
select * from vista10;
select * from vista11;
select * from vista12;
--select * from vista13;
select * from vista14;
select * from vista15;
select * from vista16;

/multiline off
/datalog 

