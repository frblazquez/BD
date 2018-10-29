-- FRANCISCO JAVIER BLÁZQUEZ MARTÍNEZ  ~  frblazqu@ucm.es
-- MANUEL ORTEGA SALVADOR              ~  manuor01@ucm.es
--
--   Doble grado Ingeniería informática - Matemáticas
--	 Universidad Complutense de Madrid.

-- Para borrar los datos que hayamos insertado antes:
-- DELETE FROM Empleados;
-- DELETE FROM Teléfonos;
-- DELETE FROM "Códigos postales";
-- DELETE FROM Domicilios;

insert into Empleados(Nombre,DNI,Sueldo) values ('Antonio Arjona', '12345678A', 5000);
insert into Empleados(Nombre,DNI,Sueldo) values ('Carlota Cerezo', '12345678C', 1000);
insert into Empleados(Nombre,DNI,Sueldo) values ('Laura López', '12345678L', 1500);
insert into Empleados(Nombre,DNI,Sueldo) values ('Pedro Pérez' ,'12345678P' ,2000);

insert into Teléfonos(DNI, Teléfono) values ('12345678C', '611111111');
insert into Teléfonos(DNI, Teléfono) values ('12345678C', '931111111');
insert into Teléfonos(DNI, Teléfono) values ('12345678L', '913333333');
insert into Teléfonos(DNI, Teléfono) values ('12345678P', '913333333');
insert into Teléfonos(DNI, Teléfono) values ('12345678P', '644444444');

insert into "Códigos postales"("Código postal", Población, Provincia) values ('08050', 'Parets', 'Barcelona');
insert into "Códigos postales"("Código postal", Población, Provincia) values ('14200', 'Peñarroya', 'Córdoba');
insert into "Códigos postales"("Código postal", Población, Provincia) values ('14900', 'Lucena', 'Córdoba');
insert into "Códigos postales"("Código postal", Población, Provincia) values ('28040', 'Madrid', 'Madrid');
insert into "Códigos postales"("Código postal", Población, Provincia) values ('50008', 'Zaragoza', 'Zaragoza');
insert into "Códigos postales"("Código postal", Población, Provincia) values ('28004', 'Arganda', 'Madrid');

insert into Domicilios(DNI,Calle,"Código postal") values ('12345678A', 'Avda. Complutense', '28040');
insert into Domicilios(DNI,Calle,"Código postal") values ('12345678A', 'Cántaro', '28004');
insert into Domicilios(DNI,Calle,"Código postal") values ('12345678P', 'Diamante', '14200');
insert into Domicilios(DNI,Calle,"Código postal") values ('12345678P', 'Carbón', '14900');
insert into Domicilios(DNI,Calle,"Código postal") values ('12345678L', 'Diamante', '14200');

-- 1.- Inserción de una tupla con una clave primaria duplicada:
insert into Empleados values ('David Petrenko', '12345678A', 3000);
/*
insert into Empleados values ('David Petrenko', '12345678A', 3000)
Informe de error -
ORA-00001: restricción única (DG04.SYS_C0011891) violada
*/

-- 2.- Inserción que no incluya todas las columnas que requieren un valor:
insert into Empleados(DNI, Sueldo) values ('12345688Q', 4000);
/*
insert into Empleados(DNI, Sueldo) values ('12345688Q', 4000)
Informe de error -
ORA-01400: no se puede realizar una inserción NULL en ("DG04"."EMPLEADOS"."NOMBRE")
*/

-- 3.- Inserción que no verifique las restricciones de dominio check():
insert into Empleados values ('David Petrenko', '12345678A', 2);
/*
insert into Empleados values ('David Petrenko', '12345678A', 2)
Informe de error -
ORA-02290: restricción de control (DG04.SYS_C0011890) violada
*/

-- 4.- Inserción que no respete una regla de integridad referencial:
insert into Domicilios values ('47399025G', 'General Cadenas Campos', '28039');
/*
insert into Domicilios values ('47399025G', 'General Cadenas Campos', '28039')
Informe de error -
ORA-02291: restricción de integridad (DG04.SYS_C0011895) violada - clave principal no encontrada
*/

-- 5.- Borrado en una tabla padre con alguna hija con foreign key sin ON DELETE CASCADE:
delete from "Códigos postales" where provincia='Madrid';
/*
delete from "Códigos postales" where provincia='Madrid'
Informe de error -
ORA-02292: restricción de integridad (CC04.SYS_C0013029) violada - registro secundario encontrado
*/

-- 6.- Borrado en una tabla padre con alguna hija con foreign key con ON DELETE CASCADE:
-- Borramos a Carlota Cerezo, se borran sus dos teléfonos guardados ('611111111','931111111')
delete from Empleados where DNI='12345678C';   
/*
1 fila eliminado
Se han eliminado los dos teléfonos que tenía asignados Carlota
*/

-- 7.- Borrado en Empleados cuando Teléfonos tiene una regla de borrado ON DELETE SET NULL sobre el campo DNI.
delete from Empleados where DNI='12345678C'; 
/*
delete from Empleados where DNI='12345678C'
Informe de error -
ORA-01407: no se puede actualizar ("CC04"."TELÉFONOS"."DNI") a un valor NULL
*/
-- On delete set null para el dni en la tabla teléfonos. Pero dni es un campo de la clave primaria, no nos
-- va a dejar que sea null, tenemos que poner el error que se da al ejecutar el fichero crear tablas con on
-- delete set null sobre el campo dni como foreign key en la tabla teléfonos?

/*
Create table Teléfonos
(
    DNI Char(9), 
    Teléfono Char(9),
    primary key (DNI, Teléfono),
    foreign key (DNI) references Empleados(DNI) on delete set null
);
*/
