-- FRANCISCO JAVIER BLÁZQUEZ MARTÍNEZ  ~  frblazqu@ucm.es
-- MANUEL ORTEGA SALVADOR              ~  manuor01@ucm.es
--
--   Doble grado Ingeniería informática - Matemáticas
--	 Universidad Complutense de Madrid.
--
-- Comentarios:

/abolish
/multiline on
/sql

-- 1.- Creación de tablas:
Create table Empleados
(
    Nombre string not null, 
    DNI Char(9), 
    Sueldo float, 
    primary key (DNI),
    check(Sueldo between 736.0 and 5000.0)
);
Create table "Códigos postales"
(
    "Código postal" Char(5),
    Población string,
    Provincia string,
    primary key("Código postal")
);
Create table Domicilios
(
    DNI Char(9), 
    Calle string, 
    "Código postal" Char(5),
    primary key (DNI, Calle, "Código postal"),
    foreign key (DNI) references Empleados(DNI),
    foreign key ("Código postal") references "Códigos postales"("Código postal")
);
Create table Teléfonos
(
    DNI Char(9), 
    Teléfono Char(9),
    primary key (DNI, Teléfono),
    foreign key (DNI) references Empleados(DNI)
);

-- 2.- Inserción de elementos:
insert into Empleados values ('Antonio Arjona', '12345678A', 5000.0);
insert into Empleados values ('Carlota Cerezo', '12345678C', 1000.0);
insert into Empleados values ('Laura López', '12345678L', 1500.0);
insert into Empleados values ('Pedro Pérez' ,'12345678P' ,2000.0);

insert into Teléfonos values ('12345678C', '611111111');
insert into Teléfonos values ('12345678C', '931111111');
insert into Teléfonos values ('12345678L', '913333333');
insert into Teléfonos values ('12345678P', '913333333');
insert into Teléfonos values ('12345678P', '644444444');

insert into "Códigos postales" values ('08050', 'Parets', 'Barcelona');
insert into "Códigos postales" values ('14200', 'Peñarroya', 'Córdoba');
insert into "Códigos postales" values ('14900', 'Lucena', 'Córdoba');
insert into "Códigos postales" values ('28040', 'Madrid', 'Madrid');
insert into "Códigos postales" values ('50008', 'Zaragoza', 'Zaragoza');
insert into "Códigos postales" values ('28004', 'Arganda', 'Madrid');

insert into Domicilios values ('12345678A', 'Avda. Complutense', '28040');
insert into Domicilios values ('12345678A', 'Cántaro', '28004');
insert into Domicilios values ('12345678P', 'Diamante', '14200');
insert into Domicilios values ('12345678P', 'Carbón', '14900');
insert into Domicilios values ('12345678L', 'Diamante', '14200');

-- 3.- Consultas:

-- 3.1.- Listado de los empleados con domicilio ordenados por Código postal y Nombre:
create view vista1 as

select distinct Nombre,Calle,"Código postal" 
from Empleados natural join Domicilios
order by "Código postal",Nombre;

-- 3.2.- Empleados que tengan teléfono ordenados por nombre:
create view vista2 as

select Nombre,Domicilios.DNI,Calle,"Código postal",Teléfono
from (Empleados natural join Teléfonos) natural left outer join Domicilios 
order by Nombre;

-- 3.3.- Listado de todos los empleados ordenados por nombre (Esquema de valores nulos fijo):
create view vista3 as 

select Nombre,Empleados.DNI,Calle,"Código postal",Teléfono
from (Empleados natural left outer join Teléfonos) left outer join Domicilios
order by Nombre;

-- 3.4.- Listado de todos los empleados ordenados por nombre (Esquema de valores nulos fijo):
create view vista4 as

select Nombre,DNI,Calle,Población,Provincia,"Código postal"
from (Empleados natural left outer join Domicilios) natural left outer join "Códigos postales"
order by Nombre;

-- 3.5.- Listado de todos los empleados ordenados por nombre (Esquema de valores nulos fijo):
create view vista5 as

select Nombre,DNI,Calle,Población,Provincia,"Código postal",Teléfono
from ((Empleados natural left outer join Domicilios) natural left outer join "Códigos postales")
       natural left outer join Teléfonos
order by Nombre;

-- 3.6.- Incrementa los salarios de todos los empleados un 10% (acotado por 1900€):
update Empleados set Sueldo=1.1*Sueldo where 1.1*Sueldo<=1900.0;

create view vista6 as select * from Empleados;

-- 3.7.- Deshacer la operación anterior (NO LA DESHACE SIEMPRE!!):
update Empleados set Sueldo=Sueldo/(1.1) where Sueldo<=1900.0;

create view vista7 as select * from Empleados;

-- 3.8.- Probar los apartados 6 y 7 con una acotación de 1600€, ¿Qué sucede?:

-- update Empleados set Sueldo=1.1*Sueldo where 1.1*Sueldo<=1600.0;
-- update Empleados set Sueldo=Sueldo/(1.1) where Sueldo<=1600.0;
-- 
-- create view vista8 as select * from Empleados;

-- Lo que sucede es que mientras que Carlota está algo triste por volver a su salario
-- original antes de que la subida y Antonio y Pedro están indiferentes por completo
-- con el mismo salario de siempre, Laura está rabiando porque no solo nunca vió una
-- subida sino que vió una bajada (ahora cobra unos 140€ menos).
--
-- El problema viene causado porque una operación no es inversa a la anterior, esto es,
-- hay rangos que no experimentan subida pero que sí que experimentan bajada de salarios.

-- 3.9.- Listado con nº de empleados, salario mínimo, máximo y medio.
create view vista9 as

select count(*),min(Sueldo),max(Sueldo),avg(Sueldo)
from Empleados;

-- 3.10.- Suledo medio por población y número de empleados, ordenado por población:
create view vista10 as
	
select count(*),avg(Sueldo),Población 
from (Empleados natural left outer join Domicilios) 
	            natural left outer join "Códigos postales"
group by Población
order by Población;

-- 3.11.- Obtener los empleados con más de un teléfono ordenados por nombre:
create view vista11a as

select distinct Nombre,Empleados.DNI,t1.Teléfono
from Empleados, Teléfonos t1, Teléfonos t2
where Empleados.DNI=t1.DNI and Empleados.DNI=t2.DNI and t1.Teléfono != t2.Teléfono
order by Nombre;

  -- Eliminame si quieres, pensaba que quedaba mejor, más corto.
create view vista11b as

select * from 

(select Nombre,DNI 
from Empleados Emp
where (select count(Teléfono) from Teléfonos where Teléfonos.DNI=Emp.DNI)>1)

natural join Teléfonos
order by Nombre;


/multiline off
/datalog

