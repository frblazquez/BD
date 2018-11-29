-- Francisco Javier Bl�zquez Mart�nez ~ frblazqu@ucm.es
--
-- Double grado Matem�ticas-Ingenier�a inform�tica.
-- Universidad Complutense de Madrid.
--
-- Descripci�n:
-- Crear una consulta SQL que dada una cota superior devuelva todos los n�meros primos
-- menores o iguales a ese n�mero.


/abolish
/sql
/multiline on

-- Comentarios:
-- 
-- Primera soluci�n obtenida, poco m�s de 5 l�neas de c�digo para la consulta que halla
-- los n�meros primos de entre aquellos naturales entre 2 y la cota proporcionada pero
-- 5 l�neas de c�digo sumamente ineficientes. 
-- Al usar not exists (dependiendo del SGBD) podemos suponer que en los peores casos 
-- para cada n�mero entre 2 y la cota se va a ejecutar la subinstrucci�n, esto es, va
-- a probar para cada n�mero si hay alguno menor que lo divida. En otras palabras, que
-- en vez de al coger el 2 como primo, quitar todos a los que divide, vamos a comprobar
-- para muchos n�meros si el 4 los divide, aunque el cuatro no sea primo. Por lo pronto
-- lo subo porque funciona correctamente, si tengo un rato intentar� crear una consulta
-- m�s r�pida, que aplique la criba de erat�stenes.

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
