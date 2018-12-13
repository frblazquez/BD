-- Francisco Javier Blázquez Martínez ~ frblazqu@ucm.es
--
-- Double grado Matemáticas-Ingeniería informática.
-- Universidad Complutense de Madrid.
--
-- Descripción: Rectas cualesquiera del plano con el algoritmo de Bresenham.


/abolish
/sql
/multiline on
/duplicates on

-- Comentarios:

-- Minimum and maximum point
/set m 0
/set M 40

-- Start point (1,1)
/set x0 5 
/set y0 5

-- End point (6,3)
/set x1 30
/set y1 15

-- Delta incrementation
/set d ($y1$ - $y0$)/($x1$ - $x0$)


create view points(x,y,delt) as

(select $x0$, $y0$, 0 from dual)
 union
(select x+1,y+floor(delt + $d$), delt+$d$ - floor(delt + $d$)
 from points
 where x<$x1$);


create view matrix_rep as

with
	
	axis(x)     as ((select $m$ from dual)
                     union
                    (select x+1 from axis where x<$M$)),

	matrix(x,y) as ((select a.x,b.x from axis a, axis b)
                     except
                    (select x,y from points)),

	repr(x,y,s) as ((select x,y,' ' from matrix)
                     union
                    (select x,y,'*' from points))

select * from repr;



/* PARA CONCATENAR ESPACIOS A LA RECTA Y PODER VISUALIZARLA!

create view spaces(i,s) as

(select 0,'' from dual)
 union
(select i+1,s||' ' from spaces where i<40);

create view plot(x,y,rep) as

select p.x, p.y, (select s from spaces where i=p.y)|| '*' || (select s from spaces where i=40-p.y)
from points p;

select rep from plot order by x;
*/

/duplicates off
/multiline off
/datalog
