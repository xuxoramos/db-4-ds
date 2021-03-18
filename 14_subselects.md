# Subselects

A lo largo de la clase nuestro uso más común del subselect ha sido para hacer match entre un query externo que obtiene datos, y un query interno que llega al registro del cual necesitamos esos datos, como este ejemplo:

```sql
select p.amount , concat(c.first_name, ' ', c.last_name) as cliente, concat(s.first_name, ' ', s.last_name) as staff 
from payment p join customer c using (customer_id)
join staff s using (staff_id)
where p.amount  = (select max(p.amount) from payment p);
```

Y aunque hemos dicho que hay que evitarlos, debemos cubrirlos para poder ver después la mejor alternativa a ellos.

## Error común en uso de subselects

Consideremos el siguiente query:

```sql
select ci.city 
from city ci 
where ci.country_id = (select co.country_id from country co where co.country = 'India');
```

Primero se evalúa el query interior, luego el exterior, lo que significa que primero obtenemos la llave del país que se llame 'India', y luego hacemos match de esa llave con los demás registros de los nombres de `city`. Lo que resulta es esto:

![](https://i.imgur.com/IQtjdiU.png)

Esto es posible porque el subquery **solo regresa 1 registro**. Un subquery usado de esta forma, con una expresión de igualdad `=` debe regresar 1 solo registro. Veamos qué sucede si lo cambiamos para que regrese varios:

```sql
select ci.city 
from city ci 
where ci.country_id = (select co.country_id from country co where co.country <> 'India');
```

![](https://i.imgur.com/cQdsuGP.png)

Sabemos cómo solucionamos esto, no? Con la cláusula **`IN`**.


```sql
select ci.city 
from city ci 
where ci.country_id in (select co.country_id from country co where co.country <> 'India');
```

### Por qué no podemos usar joins para este query?

Intentemos escribir un query para obtener los clientes que no tengan registrados pagos por un monto de 0:

```sql
select distinct c2.first_name, c2.last_name
from payment p join customer c2 using (customer_id)
where p.amount > 0;
```

Dado que aquellos clientes que tienen registrados pagos en 0, también tienen registrados pagos mayores a 0, entonces este query no los elimina de los resultados. Forzosamente requerimos un query que exprese `...where customer_id not in (`_clientes que tienen **al menos 1** pago registrado por un monto de 0_`)`, y esto solo será posible con subqueries.


 ## La cláusula `all`
 
 Sabemos que la cláusula **`in`** hace una comparación del elemento de la izq VS cada uno de los elementos de la lista de la derecha, parecido a comparaciones con operadores booleanos **`or`** encadenados:
 
 	`...where country_id in ('India', 'Pakistan', 'Afghanistan')` **es igual a** `...where country_id = 'India' or country_id = 'Pakistan' or country_id = 'Afghanistan'`
 
 Sabemos también que el operador **`not`** convierte los **`or`** en **`and`**, y los **`=`** en **`<>`**, de forma que un `not in` es lo mismo que:
 
 `...where country_id not in ('India', 'Pakistan', 'Afghanistan')` **es igual a** `...where country_id <> 'India' and country_id <> 'Pakistan' and country_id <> 'Afghanistan'`
 
 Es cuestión de estilos, pero los queries con `not in` pueden refrasearse como:
 
 ```sql
 select c.first_name, c.last_name
 from customer c
 where c.customer_id <> all (
 select customer_id from payment where amount = 0
 );
 ```
 
 El operador `all` toma el operador de igualdad de su izq y lo compara **uno a uno** con la lista de valores que resulte del query de la derecha.
 
 El subquery interior regresa todos los identificadores de los clientes cuyos pagos son 0, mientras que el query exterior regresa los nombres de dichos clientes.
 
**IMPORTANTE:** cuando usemos `not in` o `<> all`, debemos asegurarnos que la lista de valores no vaya a traer un `null`, porque recordemos que estos operadores hacen por debajo un `=` o un `<>`, y sabemos que para comparar `null` no debemos usar igualdades, sino los operadores `is null` o `is not null`.

Por ejemplo:

```sql
select c.first_name, c.last_name
 from customer c
 where c.customer_id not in (122, 452, null)
```

No va a tronar, pero no va a regresar nada, y claramente no es lo que queremos.

### El `all` en el `having`

Un uso poco ortodoxo del `all` es ponerlo en el `having`. Veamos el siguiente query:

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
 
Aquí el subquery interior obtiene todas las rentas por cliente de aquellos que residen en la zona TMEC, mientras que el query exterior obtiene el conteo de las rentas para todos nuestros clientes, **filtrando los grupos con clientes cuyas rentas son mayores a todas las de nuestros clientes en la zona TMEC**.
 
El resultado es:

![](https://i.imgur.com/Fi07GeV.png)

Solo tenemos un cliente cuya cantidad de rentas supera a todos nuestros clientes de la zona TMEC, de un país raro que se llama Runion.

#### Qué es más rápido? `count > all (subquery)` o `count > (subquery con order by y limit 1)`

PostgreSQL tiene el comando `explain` y `explain analyze` que genera un árbol de ejecución con costos por cada fase de la evaluación y preparación del query. Es una de las principales herramientas de **profiling**, que es el proceso de medir los recursos computacionales y tiempo que toma preparar, evaluar y ejecutar cualquier comando SQL.

Vamos a ver la interpretación de la salida de `explain` y `explain analyze` más delante, pero por ahora comparemos los siguientes queries:

```sql
--- count > all (subquery)
explain analyze select r.customer_id , count(*)
from rental r
group by r.customer_id 
having count(*) > all ( -- count > reg1 AND count > reg2 AND ...
	select count(*) rentas_totales
 	from rental r2 join customer c2 using (customer_id)
 	join address a2 using (address_id)
 	join city c3 using (city_id)
 	join country c4 using (country_id)
 	where c4.country in ('United States', 'Mexico', 'Canada')
 	group by c2.customer_id
 );
```

<img src="https://www.pnglib.com/wp-content/uploads/2020/01/versus_5e1705d8d11a9.png" alt="alt text" width="25%" height="25%">

```sql
--- count > (subquery con order by y limit 1)
explain analyze select r.customer_id , count(*)
from rental r
group by r.customer_id 
having count(*) > (
	select count(*) rentas_totales
 	from rental r2 join customer c2 using (customer_id)
 	join address a2 using (address_id)
 	join city c3 using (city_id)
 	join country c4 using (country_id)
 	where c4.country in ('United States', 'Mexico', 'Canada')
 	group by c2.customer_id
 	order by rentas_totales desc limit 1
 );
```

Cuál es más eficiente? No podemos saberlo con 1 sola ejecución, sino que tenemos que obtener una muestra, y cada ejecución debe ir seguida de una pausa para darle tiempo al sistema operativo de liberar recursos. Levantando una muestra de 10 ejecuciones:

**`count > all (subquery)`**
```sql
select (5.500 + 7.537 + 8.936 + 9.018 + 5.961 + 5.832 + 5.913 + 5.816 + 5.755 + 9.557) / 10

?column? |
---------|
6.9825000|
```

**`count > (subquery con order by y limit 1)`**
```sql
select (5.573 + 5.944 + 7.938 + 6.116 + 5.293 + 5.512 + 5.414 + 5.586 + 5.453 + 5.555) / 10

?column? |
---------|
5.8384000|
```

**OJO:** Estos tiempos se verán afectados por la carga actual de su máquina. Yo en particular tengo esto corriendo, lo cual es suficiente para introducir una cantidad no trivial de ruido en nuestras métricas:

<img src="https://i.imgur.com/8PtKXPK.png" alt="alt text" width="25%" height="25%">

## El operador `any`/`some`

Estos operadores arrojan resultados similares al operador `or` encadenado, de forma que:

`...where payment.amount > any (7.99, 8.99, 9.99)` **es igual a** `...where payment.amount > 7.99 or payment.amount > 8.99 or payment.amount > 9.99`

### Ejercicio:

Cómo podemos obtener los clientes cuyo gasto con nosotros supera el revenue concentrado aportado por Bolivia, Paraguay y Chile?

```sql
select c2.customer_id , sum(p2.amount) as pago_total
from payment p2 join customer c2 using (customer_id)
group by c2.customer_id 
having sum(p2.amount) > any (
	select sum(p.amount)
	from payment p join customer c using (customer_id)
	join address a using (address_id)
	join city ci using (city_id)
	join country co using (country_id)
	where co.country in ('Bolivia', 'Paraguay', 'Chile')
	group by co.country 
	);
```

Cómo llegamos a esta respuesta?

1. Dividimos el problema en 2 subqueries: "el revenue concentrado aportado por Bolivia, Paraguay y Chile" y "obtener los clientes cuyo gasto con nosotros supera".
2. Escribimos el subquery interno que resuelve el revenue por país para estos 3 paises
3. Escribimos el query externo: cómo sabemos si la condición va en el `where` o en el `having`? La frase "clientes cuyo gasto con nos" implica un `sum(payment.amount)`, lo que implica un `group by customer_id`, lo que, a su vez, implica un `having sum(payment.amount) >`_revenue de Bolivia, Paraguay y Chile_.
4. Cómo decidimos si usamos `> any` o `> all`? Al listarse los países en el enunciado "Bolivia, Paraguay y Perú" usan un **y**, y no un **o**. Lamentablemente el `> all` no retorna resultados, lo que significa que no hay ningún cliente que supere en pagos los montos de los 3 paises cada uno.

## Resumen

`<> any` **es igual a** `x <> a or x <> b or x <> c`

`= any` **es igual a** `x in (a, b, c)` **que es igual a** `x = a or x = b or x = c`

`<> all` **es igual a** `x not in (a, b, c)` **que es igual a** `x <> a and x <> b and x <> c`

`= all` **es igual a** `x = a and x = b and x = c`, lo cual no tiene mucho sentido, y aunque el query no tronará, no va a regresar nada

## Queries correlacionados

Hasta ahorita hemos visto subqueries que pueden existir independientes de su query externo, como este ejemplo de los ejercicios que hemos hecho:

```sql
select o.order_id , o.order_date, c.company_name
from orders o join customers c on o.customer_id = c.customer_id 
join (
	select c.company_name, max(o.order_date) as max_order_date
	from orders o join customers c on o.customer_id = c.customer_id
	group by c.company_name 
) t on o.order_date = t.max_order_date and c.company_name = t.company_name
```

Como podemos ver, el subquery interno es independiente del query externo, y puede ejecutarse totalmente aparte, sin necesidad de que ese subquery **necesite** información del query externo que lo engloba. En este caso, el subquery interno está actuando como tabla, y veremos como, dependiendo donde lo pongamos, podemos tener subqueries que actúan **como tabla, como lista, como condición en el where, etc**.

Pero qué sucede con un query como este?

```sql
select c.first_name, c.last_name
from customer c
where exists (
	select 1 from payment p 
	where p.amount > 11
	and p.customer_id = c.customer_id
	)
order by c.first_name, c.last_name;
```

Si nos fijamos en la parte de **`and p.customer_id = c.customer_id`**, observarán que en el `from` no estamos haciendo join con `customer`, y parece que estamos haciendo un join a la antigüita, pero más bien estamos conectando el subquery con el mismo resultset del query externo, es decir, **no son independientes**. Este es un **query correlacionado**.

> **IMPORTANTE:** Mientras que en los queries independientes el subquery se ejecuta **solo 1 vez**, en los queries correlacionados se ejecuta **1 vez por cada registro del query externo**, y es por eso que debemos tener cuidado con su performance, porque podemos quedarnos ahí la vida o acabarnos los recursos de la máquina.

### El operador `exists`

Para qué sirven los queries correlacionados? Entre otras cosas, para checar existencia de una relación.

Con los operadores de igualdad `=`, `<>`, `<` y `>`, y los operadores lógicos `in`, `not`, `or`, `and`, tratamos de hacer match de un dato a otro o una lista de otros. El operador `exists` permite obtener solamente si una relación **existe**, sea con 1 renglón, o con N. El operador exists pregunta la existencia de 1 o más rows en un subquery. El resultado de un subquery que está como argumento de un `exists` no recae sobre lo que va en el `select`, sino en los renglones que regresa, por lo que lo importante es todo lo demás.

Por ejemplo, el siguiente query encuentra a todos los clientes que rentaron al menos 1 peli previo al 25 de Mayo de 2005, sin importar cuántas rentas haya tenido:

```sql
select c.first_name, c.last_name
from customer c
where exists (
	select 1 from rental r
	where r.rental_date < '2005-05-25'
	and r.customer_id = c.customer_id 
	);
```

El subquery con el statement `select 1` es solo para que regrese algún dato. Es de uso estándar cuando solo te interesa los renglones que se regresan, y no su contenido.

Ejemplo: Cuales de nuestros clientes han tenido un pago de más de 11?

```sql
select c.first_name, c.last_name
from customer c
where exists (
	select 1 from payment p
	where p.amount > 11
	and p.customer_id = r.customer_id
	)
order by c.first_name, c.last_name;
```

Al igual que el `in`, el `exists` también puede estar sujeto al operador `not`, para de este modo obtener los clientes que han tenido al menos 1 pago menor o igual a 11.

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

### OJO CON EL NULL

Si vamos a usar `exists` debemos tener mucho cuidado de que nuestro subquery **no regrese `null`**, porque en SQL, `exists null` es `TRUE`, y esto puede ponerle en la torre a nuestros resultados. Por ejemplo:

```sql
select c.first_name, c.last_name
from customer c
where exists (select null)
order by c.first_name, c.last_name
```

Esto regresa los 599 clientes totales que tenemos.

![](https://i.imgur.com/zg9QbLF.png)

## Dónde podemos usar subqueries?

Los subqueries son una herramienta poderosa, pero como es difícil usarla bien, y por eso la recomendación general es evitar su uso de ser posible. Tampoco hay que considerarla como tabú, y si no hay de otra y ya se les acabaron las opciones, que no les tiemble la mano para usarlos.

### Como tabla

- `select a, b, c from SUBQUERY`
- `select a, b, c, from X join SUBQUERY using (id)`

### Como filtro de rows

- `select a,b,c from X where X.a in (SUBQUERY)`
- `select a,b,c from X where X.b = (SUBQUERY)`

### Como filtro de gupos

- `select a,b,c from X group by X.a having X.a > (SUBQUERY)`
- `select a,b,c from X group by X.a having X.a = (SUBQUERY)`

### Para formar nuevos datos

Supongamos que queremos dividir nuestros clientes por el revenue que nos aportan para una campaña.

Primero crearemos la tabla con los segmentos:

```sql
select 'pecesillo' segmento, 0 limite_inferior, 74.99 limite_superior
union all
select 'dos dos' segmento, 75 limite_inferior, 149.99 limite_superior
union all
select 'gran pez' segmento, 150 limite_inferior, 9999999.99 limite_superior;
```

Como podemos ver, esto es una tabla que creamos al vuelo y no existe estructuralmente en la BD, pero para efectos de ponerlo como un subquery, es perfectamente válido. Ahora vamos a pegar esta tabla que creamos al vuelo con nuestros clientes para calificarlos:

```sql
select segmentos.segmento, count(*) num_customers
from
(select p.customer_id, count(*) num_rentals, sum(p.amount) tot_payments
from payment p
group by p.customer_id) as payments join 
(select 'pecesillo' segmento, 0 limite_inferior, 74.99 limite_superior
union all
select 'dos dos' segmento, 75 limite_inferior, 149.99 limite_superior
union all
select 'gran pez' segmento, 150 limite_inferior, 9999999.99 limite_superior) as segmentos
on (payments.tot_payments between segmentos.limite_inferior and segmentos.limite_superior)
group by segmentos.segmento;
```

## Próxima clase

_Common table expressions_ para usar subqueries sin (algunos) penalties en performance.

