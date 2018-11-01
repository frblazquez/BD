-- FRANCISCO JAVIER BL�ZQUEZ MART�NEZ  ~  frblazqu@ucm.es
-- MANUEL ORTEGA SALVADOR              ~  manuor01@ucm.es
--
--   Doble grado Ingenier�a inform�tica - Matem�ticas
--	 Universidad Complutense de Madrid.
--
-- Comentarios:

/abolish
/multiline on
/sql

-- 1.- Creaci�n de tablas:
Create table Empleados
(
    Nombre string not null, 
    DNI Char(9), 
    Sueldo float, 
    primary key (DNI),
    check(Sueldo between 736.0 and 5000.0)
);
Create table "C�digos postales"
(
    "C�digo postal" Char(5),
    Poblaci�n string,
    Provincia string,
    primary key("C�digo postal")
);
Create table Domicilios
(
    DNI Char(9), 
    Calle string, 
    "C�digo postal" Char(5),
    primary key (DNI, Calle, "C�digo postal"),
    foreign key (DNI) references Empleados(DNI),
    foreign key ("C�digo postal") references "C�digos postales"("C�digo postal")
);
Create table Tel�fonos
(
    DNI Char(9), 
    Tel�fono Char(9),
    primary key (DNI, Tel�fono),
    foreign key (DNI) references Empleados(DNI)
);

-- 2.- Inserci�n de elementos:
insert into Empleados values ('Antonio Arjona', '12345678A', 5000.0);
insert into Empleados values ('Carlota Cerezo', '12345678C', 1000.0);
insert into Empleados values ('Laura L�pez', '12345678L', 1500.0);
insert into Empleados values ('Pedro P�rez' ,'12345678P' ,2000.0);

insert into Tel�fonos values ('12345678C', '611111111');
insert into Tel�fonos values ('12345678C', '931111111');
insert into Tel�fonos values ('12345678L', '913333333');
insert into Tel�fonos values ('12345678P', '913333333');
insert into Tel�fonos values ('12345678P', '644444444');

insert into "C�digos postales" values ('08050', 'Parets', 'Barcelona');
insert into "C�digos postales" values ('14200', 'Pe�arroya', 'C�rdoba');
insert into "C�digos postales" values ('14900', 'Lucena', 'C�rdoba');
insert into "C�digos postales" values ('28040', 'Madrid', 'Madrid');
insert into "C�digos postales" values ('50008', 'Zaragoza', 'Zaragoza');
insert into "C�digos postales" values ('28004', 'Arganda', 'Madrid');

insert into Domicilios values ('12345678A', 'Avda. Complutense', '28040');
insert into Domicilios values ('12345678A', 'C�ntaro', '28004');
insert into Domicilios values ('12345678P', 'Diamante', '14200');
insert into Domicilios values ('12345678P', 'Carb�n', '14900');
insert into Domicilios values ('12345678L', 'Diamante', '14200');

-- 3.- Consultas:

-- 3.1.- Listado de los empleados con domicilio ordenados por C�digo postal y Nombre:
create view vista1 as

select distinct Nombre,Calle,"C�digo postal" 
from Empleados natural join Domicilios
order by "C�digo postal",Nombre;

-- 3.2.- Empleados que tengan tel�fono ordenados por nombre:
create view vista2 as

select Nombre,Domicilios.DNI,Calle,"C�digo postal",Tel�fono
from (Empleados natural join Tel�fonos) natural left outer join Domicilios 
order by Nombre;

-- 3.3.- Listado de todos los empleados ordenados por nombre (Esquema de valores nulos fijo):
create view vista3 as 

select Nombre,Empleados.DNI,Calle,"C�digo postal",Tel�fono
from (Empleados natural left outer join Tel�fonos) left outer join Domicilios
order by Nombre;

-- 3.4.- Listado de todos los empleados ordenados por nombre (Esquema de valores nulos fijo):
create view vista4 as

select Nombre,DNI,Calle,Poblaci�n,Provincia,"C�digo postal"
from (Empleados natural left outer join Domicilios) natural left outer join "C�digos postales"
order by Nombre;

-- 3.5.- Listado de todos los empleados ordenados por nombre (Esquema de valores nulos fijo):
create view vista5 as

select Nombre,DNI,Calle,Poblaci�n,Provincia,"C�digo postal",Tel�fono
from ((Empleados natural left outer join Domicilios) natural left outer join "C�digos postales")
       natural left outer join Tel�fonos
order by Nombre;

-- 3.6.- Incrementa los salarios de todos los empleados un 10% (acotado por 1900�):
update Empleados set Sueldo=1.1*Sueldo where 1.1*Sueldo<=1900.0;

create view vista6 as select * from Empleados;

-- 3.7.- Deshacer la operaci�n anterior (NO LA DESHACE SIEMPRE!!):
update Empleados set Sueldo=Sueldo/(1.1) where Sueldo<=1900.0;

create view vista7 as select * from Empleados;

-- 3.8.- Probar los apartados 6 y 7 con una acotaci�n de 1600�, �Qu� sucede?:

-- update Empleados set Sueldo=1.1*Sueldo where 1.1*Sueldo<=1600.0;
-- update Empleados set Sueldo=Sueldo/(1.1) where Sueldo<=1600.0;
-- 
-- create view vista8 as select * from Empleados;

-- Lo que sucede es que mientras que Carlota est� algo triste por volver a su salario
-- original antes de que la subida y Antonio y Pedro est�n indiferentes por completo
-- con el mismo salario de siempre, Laura est� rabiando porque no solo nunca vi� una
-- subida sino que vi� una bajada (ahora cobra unos 140� menos).
--
-- El problema viene causado porque una operaci�n no es inversa a la anterior, esto es,
-- hay rangos que no experimentan subida pero que s� que experimentan bajada de salarios.

-- 3.9.- Listado con n� de empleados, salario m�nimo, m�ximo y medio.
create view vista9 as

select count(*),min(Sueldo),max(Sueldo),avg(Sueldo)
from Empleados;

-- 3.10.- Suledo medio por poblaci�n y n�mero de empleados, ordenado por poblaci�n:
create view vista10 as
	
select count(*),avg(Sueldo),Poblaci�n 
from (Empleados natural left outer join Domicilios) 
	            natural left outer join "C�digos postales"
group by Poblaci�n
order by Poblaci�n;

-- 3.11.- Obtener los empleados con m�s de un tel�fono ordenados por nombre:
create view vista11a as

select distinct Nombre,Empleados.DNI,t1.Tel�fono
from Empleados, Tel�fonos t1, Tel�fonos t2
where Empleados.DNI=t1.DNI and Empleados.DNI=t2.DNI and t1.Tel�fono != t2.Tel�fono
order by Nombre;

  -- Eliminame si quieres, pensaba que quedaba mejor, m�s corto.
create view vista11b as

select * from 

(select Nombre,DNI 
from Empleados Emp
where (select count(Tel�fono) from Tel�fonos where Tel�fonos.DNI=Emp.DNI)>1)

natural join Tel�fonos
order by Nombre;


/multiline off
/datalog

