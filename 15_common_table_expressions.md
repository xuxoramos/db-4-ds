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

Los CTEs son una manera de **sacar los subqueries internos y convertirlos en queries externos**, autocontenidos y evaluables, y de este modo hacerlos más legibles y modificables. Esto nos permite construir queries complejos porque los hacemos **de adentro hacia afuera**, es decir, primero definimos los _building blocks_, luego con el query final determinamos como los acomodamos para construir nuestro resultado.

Igual la mayoría de las veces ofrecen una ventaja en performance porque son ejecutados 1 sola vez y cargados a memoria, **y una vez cargados, podemos referirnos a ellos N veces sin volver a cargarlos**, contrario a los subqueries, donde cada vez que los definimos, se ejecutan en un espacio de memoria separado.

Los CTEs solamente funcionan acompañando las siguientes cláusulas del comando `select`:
- `select`
- `from`
- `where`
- `group by` mediate aliases del `select`
- otros comandos como `create view`, `insert`, `delete`, etc.

## Sintaxis

```sql
with cte_alias1 as ( -- 1a common table expression
  select a, b, c from X where X.a is not null group by X.b
),
cte_alias2 as ( -- 2a common table expession
  select d, e, f from Y where Y.d is null group by Y.e
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


Es importante mencionar que tanto los queries que van dentro de los CTEs, como los queries externos o exteriores, **pueden tomar cualquier forma**. Incluso es posible tener 3 CTEs, y que cada uno referencie el anterior, en cadena:

```sql
with cte_alias1 as ( -- 1a common table expression
  select a, b, c from X where X.a is not null group by X.b
),
cte_alias2 as ( -- 2a common table expession
  select d, e, cte_alias1.a from Y join cte_alias1 using (e) where Y.d is null group by Y.e
),
...

select a,e,b,f from cte_alias1 join cte_alias2 on (cte_alias1.a = cte_alias2.e)
```

## Ejemplos

Vamos a tomar algunos ejercicios de la sesión (13 - group by III)[https://github.com/xuxoramos/db-4-ds/blob/gh-pages/13_group_by_III.md] y vamos a modificarlos para usar CTEs:

### Cuántos ACTORES tienen apellidos repetidos?

Con subqueries:

```sql
select sum(t.actores_apellido_repetido) from (
	select a.last_name, count(a.actor_id) actores_apellido_repetido  from actor a
	group by a.last_name 
	having count(a.actor_id) > 1
	) as t;
```

Con CTEs:

```sql
with t as (
  select a.last_name, count(a.actor_id) actores_apellido_repetido  from actor a
	group by a.last_name 
	having count(a.actor_id) > 1
)
select sum(t.actores_apellido_repetido) from t;
```

Cuánto tarda?

- Con subqueries: ~.43ms
- Con CTEs: ~.58ms

### Cuál es la orden más reciente por cliente?

Con subqueries:

```sql
select distinct o.order_id , o.order_date, c.company_name
from orders o join customers c on o.customer_id = c.customer_id 
join (
	select c.company_name, max(o.order_date) as max_order_date
	from orders o join customers c on o.customer_id = c.customer_id
	group by c.company_name 
) t on o.order_date = t.max_order_date;
```

Con CTEs:

```sql
with t as (
  select c.company_name, max(o.order_date) as max_order_date
	from orders o join customers c on o.customer_id = c.customer_id
	group by c.company_name
)
select distinct o.order_id , o.order_date, c.company_name
from orders o join customers c using (customer_id)
join t on (o.order_date = t.max_order_date);
```

Cuánto tarda?
- Con subqueries: 6.4ms
- Con CTEs: 3.28ms

### Cuántas rentas tiene cada cliente que reside en la zona TMEC?

Con subqueries:

```sql
select r.customer_id , count(*)
from rental r
group by r.customer_id 
having count(*) > all (
	select count(*)
 	from rental r2 join customer c2 using (customer_id)
 	join address a2 using (address_id)
 	join city c3 using (city_id)
 	join country c4 using (country_id)
 	where c4.country in ('United States', 'Mexico', 'Canada')
 	group by c2.customer_id 
 );
```

Con CTEs:

```sql
with t as (
	select count(*)
 	from rental r2 join customer c2 using (customer_id)
 	join address a2 using (address_id)
 	join city c3 using (city_id)
 	join country c4 using (country_id)
 	where c4.country in ('United States', 'Mexico', 'Canada')
 	group by c2.customer_id 
)
select r.customer_id , count(*)
from rental r
group by r.customer_id 
having count(*) > all (t);
```

⚠️NO JALA!!!⚠️

![](https://i.imgur.com/Jt67tnt.png)

Como dijimos, los CTEs no funcionan dentro del `having`.

### Cuales clientes NO tienen pagos de más de 11 USD?

Con subquery correlacionado:

```sql
select c.first_name, c.last_name
from customer c
where not exists (
	select 1 from payment p
	where p.amount > 11
	and p.customer_id = r.customer_id
	)
order by c.first_name, c.last_name;
```

Con CTE:

...

...

...

...

...

...

...

...

...

...

...

...

...

...

...

...

...

...

...

...

...

...

...

...

...


![](https://lh3.googleusercontent.com/proxy/A4_c2TX-Vw6w6lg5jyhzQKe_CfFJjAqRcdD_uMJgrM1gPxBmxh4viA2Eow1sCb6y6pOzmpup1nxW-PEDXKMzv2kIw6J5RVjQ6dQgtkrfDyR5IFGHM4adwW9jgchPBGHbaqq60At3E66t)

En estricto y ortodoxo sentido, los correlated queries no funcionan con los CTEs, porque por definición, los correlated queries necesitan hacer referencia a las tablas del query exterior que lo envuelve, por lo que los hace **dependientes**, y los CTEs solo sirven para extraer subqueries no correlacionados, porque cuando los extraigamos al CTE, deben, literal, _**stand on their own**_.

Cómo podemos darle la vuelta?

Cambiando los `exist` por `in`, siempre y cuando el query intente responder una pregunta sobre **datos positivos**, es decir, registros que si cumplen un criterio.

Si el query es como el que intentamos convertir a CTEs, sobre **datos negativos**, entonces **no será posible**, y tendremos que conformarnos con subqueries correlacionados a como los vimos la sesión anterior.

![](https://i.imgur.com/50teHx6.png)

### Ejercicio rudo

Tomemos nuestro último query de la clase pasada, y convirtámoslo en CTEs:

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

## Cuándo y cuándo no debemos usar CTEs?

Aparte de mejorar la legibilidad y modificabilidad, y a veces el performance, las CTEs son idóneos para hacer agregaciones a varios niveles, por ejemplo, un query que pide "el promedio de los máximos" inmediatamente nos imaginaremos un `avg(max(column))`, es decir 2 agregaciones encadenadas.

Vamos a escribir un query para sacar el promedio del máximo y promedio del mínimo de los fletes de la BD de Northwind.

Nuestra intuición sería escribir algo como esto:

```sql
select s.company_name, min(o.freight) as min_freight, max(o.freight) as max_freight, avg(min(o.freight)) as avg_min_freight, avg(max(o.freight)) as avg_max_freight
from orders o join shippers s on (o.ship_via = s.shipper_id)
group by s.company_name;
```

![](https://i.imgur.com/hd7jNFZ.png)

⚠️NO JALA!!!⚠️

No podemos anidar ni encadenar llamadas a funciones de agregación! Qué clase de lenguaje entonces es SQL?

### Ejercicio

Cómo podemos lograrlo con CTEs?






