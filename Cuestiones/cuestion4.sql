-- Francisco Javier Blázquez Martínez ~ frblazqu@ucm.es
--
-- Double grado Matemáticas-Ingeniería informática.
-- Universidad Complutense de Madrid.
--
-- Descripción:
-- Hallar con la máxima precisión posible el número e usando
-- herramientas de SQL.


/abolish
/sql
/multiline on

-- OBSERVACIÓN 1:
--
-- Nos valemos de esta expresión para calcular el valor de e:
-- exp(e,x) = sum(n=0,inf)(exp(x,n)/factorial(n))
-- exp(e,1) = e

-- OBSERVACIÓN 2: 
-- 
-- Una serie (como la que queremos calcular) es un par de dos sucesiones,
-- una sucesión de términos y una sucesión de sumas parciales. Se nos plantean
-- dos alternativas, una la de crear recursivamente la sucesión de sumas parciales y 
-- quedarnos con el término más lejano posible (para mayor precisión), otra es la de 
-- crear la sucesión de términos y tratar de sumar los máximos posibles (para mayor 
-- precisión del resultado).
--
-- Optamos por la segunda alternativa. Tendremos una tabla recursiva con los términos a 
-- sumar (teóricamente infinitos, tantos como soporte el sistema) y llamaremos con las
-- funciones de álgebra relacional extendida a sumar todos estos.

/*
Primera aproximación, infinitos términos de la serie:

create view serieEuler(e) as

with
	términosSerie(n,nfact,nfactInverso) as
	((select 0.0,1.0,1.0 from dual) 
	 union
	(select n+1,(n+1)*nfact,1/((n+1)*nfact) from términosSerie))

select sum(nfactInverso) from términosSerie;

Error obtenido:
Exception: error(evaluation error(float_overflow),evaluation_error(_2333is(170.0+1)*
7.257315615307994E+306,2,float_overflow,inf))
*/

-- Solución obtenida: Necesaria acotación (ver claúsula where de términosSerie)
create view serieEuler(e) as

with
	términosSerie(n,nfact,nfactInverso) as
	((select 0.0,1.0,1.0 from dual) 
	 union
	(select n+1,(n+1)*nfact,1/((n+1)*nfact) from términosSerie where n<18.0))

select sum(nfactInverso) from términosSerie;

-- Mostramos la salida: Precisión obtenida de 16 dígitos (error < 10-¹6)
select * from serieEuler;

/multiline off
/datalog
