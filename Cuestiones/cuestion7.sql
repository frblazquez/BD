-- Francisco Javier Blázquez Martínez ~ frblazqu@ucm.es
--
-- Double grado Matemáticas-Ingeniería informática.
-- Universidad Complutense de Madrid.
--
-- Descripción:
-- Crear una consulta SQL que dada una cota superior devuelva todos los números primos
-- menores o iguales a ese número.


/abolish
/sql
/multiline on

-- Comentarios:
-- 
-- Primera solución obtenida, poco más de 5 líneas de código para la consulta que halla
-- los números primos de entre aquellos naturales entre 2 y la cota proporcionada pero
-- 5 líneas de código sumamente ineficientes. 
-- Al usar not exists (dependiendo del SGBD) podemos suponer que en los peores casos 
-- para cada número entre 2 y la cota se va a ejecutar la subinstrucción, esto es, va
-- a probar para cada número si hay alguno menor que lo divida. En otras palabras, que
-- en vez de al coger el 2 como primo, quitar todos a los que divide, vamos a comprobar
-- para muchos números si el 4 los divide, aunque el cuatro no sea primo. Por lo pronto
-- lo subo porque funciona correctamente, si tengo un rato intentaré crear una consulta
-- más rápida, que aplique la criba de eratóstenes.

create view COTA(N)   as (select 100 from dual);
create view NAT_N(n)  as ((select 2  from dual) union 
                          (select n+1 from NAT_N,COTA where n<N));

create view PRIMOS(p) as
			
			 select primos.n
             from NAT_N primos
             where not exists 
             	(select *
                 from NAT_N candidatos
                 where candidatos.n<primos.n and (primos.n mod candidatos.n)=0);


/multiline off
/datalog
