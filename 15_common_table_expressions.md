# Common Table Expressions (CTE)

Los common table expressions son una forma de mejorar la:

- legibilidad
- debuggeabilidad
- performance (a veces)

De nuestros queries CUANDO estamos usando subqueries.

Recuerdan el ejemplo de la clase anterior donde creamos una tabla al vuelo para luego hacerle join con otra agrupada que si existía?

```sql
select segmentos.segmento, count(*) num_customers
from
  (select p.customer_id, count(*) num_rentals, sum(p.amount) tot_payments
  from payment p
  group by p.customer_id)
as payments join 
  (select 'pecesillo' segmento, 0 limite_inferior, 74.99 limite_superior
  union all
  select 'dos dos' segmento, 75 limite_inferior, 149.99 limite_superior
  union all
  select 'gran pez' segmento, 150 limite_inferior, 9999999.99 limite_superior)
as segmentos
on (payments.tot_payments between segmentos.limite_inferior and segmentos.limite_superior)
group by segmentos.segmento;
```

![](https://i.imgur.com/EwCbLvy.jpg)

Cómo podemos mejorar la legibilidad de este query, aparte de meter chorros de espacios, identaciones, etc?

Los CTEs son una manera de **sacar los subqueries internos y convertirlos en queries externos**, autocontenidos y evaluables, y de este modo hacerlos más legibles y modificables.

Igual la mayoría de las veces ofrecen una ventaja en performance porque son ejecutados 1 sola vez y cargados a memoria, **siempre y cuando los referenciemos 1 sola vez**. Si referenciamos 2 veces un CTE, se cargará en el mismo espacio 2 veces.

## Sintaxis

```sql
with cte_alias1 as ( -- 1a common table expression
  select a, b, c from X where X.a is not null group by X.b
),
cte_alias2 as ( -- 2a common table expession
  select d,e,f from Y where Y.d is null group by Y.e
),
...

select a,e,b,f from cte_alias1 join cte_alias2 on (cte_alias1.a = cte_alias2.e)
```

Expliquémoslo punto por punto:

1. `with alias1...` indica que se va a abrir un espacio en memoria para guardar un resultset
2. `select a,b,c...` es el query cuyos resultados van a formar ese resultset o dataset que se cargará en memoria. En nuestra analogía, sería el 1er subquery interno.
3. `with alias2...` indica que se va a abrir otro espacio en memoria para un 2o resultset
4. `select d,e,f...` es el query cuyos resultados van a formar ese resultset o dataset que se cargará en memoria. En nuestra analogía, sería el 2o subquery interno.
5. `select a,e,b,f...` el query real que usará los otros 2 CTEs que ya están en memoria, para construir un resultset final. En nuestra analogía, este es el query externo.


Es importante mencionar que tanto los queries que van dentro de los CTEs, como los queries externos o exteriores, **pueden tomar cualquier forma**. Incluso es posible tener 3 CTEs, y que cada uno referencie el anterior, en cadena.

## Ejemplo
