-- FRANCISCO JAVIER BLÁZQUEZ MARTÍNEZ  ~  frblazqu@ucm.es
-- MANUEL ORTEGA SALVADOR              ~  manuor01@ucm.es
--
--   Doble grado Ingeniería informática - Matemáticas
--	 Universidad Complutense de Madrid.
--
-- Comentarios:
-- 
-- Hemos optado por convenio nombrar a las tablas de forma que cada barra baja '_' separe los atributos
-- de esta relación y se representen los nombres de los atributos lo más fielmente posible. De esta forma
-- la relación de empleados y proyectos en los que trabajan se podría nombrar "dniEmp_códigoPr".

-- 0.- Eliminación de tablas anteriores y configuración para SQL:
/abolish
/sql
/multiline on


-- 1.- Definimos las tablas que vamos a necesitar:
create table programadores(dni varchar(9), nombre varchar(30) not null, dirección varchar(50), teléfono varchar(10), primary key (dni));
create table analistas    (dni varchar(9), nombre varchar(30) not null, dirección varchar(50), teléfono varchar(10), primary key (dni));
create table proyectos(código varchar(9), descripción varchar(20), dnidir varchar(9), primary key (código));
create table distribución(códigopr varchar(9), dniemp varchar(9), horas int default 0 check(horas>0), 
                          primary key (códigopr, dniemp), foreign key (códigopr) references proyectos(código));


-- 2.- Introducimos los datos en nuestra base.
insert into  programadores(dni, nombre, dirección, teléfono) values('1','Jacinto','Jazmín 4','91-8888888');
insert into  programadores(dni, nombre, dirección, teléfono) values('2','Herminia','Rosa 4','91-7777777');
insert into  programadores(dni, nombre, dirección, teléfono) values('3','Calixto','Clavel 3','91-1231231');
insert into  programadores(dni, nombre, dirección, teléfono) values('4','Teodora','Petunia 3','91-6666666');

insert into  analistas(dni, nombre, dirección, teléfono) values('4','Teodora','Petunia 3','91-6666666');
insert into  analistas(dni, nombre, dirección, teléfono) values('5','Evaristo','Luna 1','91-1111111');
insert into  analistas(dni, nombre, dirección, teléfono) values('6','Luciana','Júpiter 2','91-8888888');
insert into  analistas(dni, nombre, dirección, teléfono) values('7','Nicodemo','Plutón 3', NULL);

insert into proyectos(código, descripción, dnidir) values('P1','Nómina','4');
insert into proyectos(código, descripción, dnidir) values('P2','Contabilidad','4');
insert into proyectos(código, descripción, dnidir) values('P3','Producción','5');
insert into proyectos(código, descripción, dnidir) values('P4','Clientes','5');
insert into proyectos(código, descripción, dnidir) values('P5','Ventas','6');

insert into distribución(códigopr, dniemp, horas) values('P1','1',10);
insert into distribución(códigopr, dniemp, horas) values('P1','2',40);
insert into distribución(códigopr, dniemp, horas) values('P1','4',5);
insert into distribución(códigopr, dniemp, horas) values('P2','4',10);
insert into distribución(códigopr, dniemp, horas) values('P3','1',10);
insert into distribución(códigopr, dniemp, horas) values('P3','3',40);
insert into distribución(códigopr, dniemp, horas) values('P3','4',5);
insert into distribución(códigopr, dniemp, horas) values('P3','5',30);
insert into distribución(códigopr, dniemp, horas) values('P4','4',20);
insert into distribución(códigopr, dniemp, horas) values('P4','5',10);


-- 3.- Realizamos las consultas

-- 3.1.- Dni de todos los empleados, no usamos distinct por ser clave primaria:
create view vista1 as (select dni from programadores) union     (select dni from analistas);

-- 3.2.- Dni de los programadores que también son analistas:
create view vista2 as (select dni from programadores) intersect (select dni from analistas);

-- 3.3.- Dni de los empleados sin trabajo; no son directores ni asignados a proyectos:


-- 3.4.- Código de los proyectos sin analistas asignados:


-- 3.8.- Utilizando natural join, dni de empleados que son analistas y programadores:
-- create view vista8 as (select dni from ((select dni from analistas) natural join (select dni from programadores));

-- 4.- Mostramos las vistas:
select * from vista1;
select * from vista2;
--select * from vista3;
--select * from vista4;
--select * from vista5;
--select * from vista6;
--select * from vista7;
--select * from vista8;
--select * from vista9;
--select * from vista10;
--select * from vista11;
--select * from vista12;
--select * from vista13;
--select * from vista14;
--select * from vista15;

/multiline off
/datalog 
