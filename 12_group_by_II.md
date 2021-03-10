# Agrupaciones II

## La cláusula `distinct`

Ya ustedes han usado la cláusula `distinct` en el `select` para eliminar repetidos. Su resultado es **parecido** al que obtenemos con `group by` (obviamente sin hacer grupos). Vamos a verla más a detalle, para lo cual crearemos la siguiente tabla:

```
CREATE TABLE distinct_demo (
	id serial NOT NULL PRIMARY KEY,
	bcolor VARCHAR,
	fcolor VARCHAR
);
INSERT INTO distinct_demo (bcolor, fcolor)
VALUES
	('red', 'red'),
	('red', 'red'),
	('red', NULL),
	(NULL, 'red'),
	('red', 'green'),
	('red', 'blue'),
	('green', 'red'),
	('green', 'blue'),
	('green', 'green'),
	('blue', 'red'),
	('blue', 'green'),
	('blue', 'blue');
```

### `distinct` con una columna

`select distinct bcolor from distinct_demo order by bcolor;`

Esto regresa `red`, `green`, `blue`, y `null`.

De nuevo, **estos no son grupos**, porque recordemos que lo que va en la cláusula `select` es solo lo que vamos a _presentar_ hacia afuera, no a la estructura de nuestro query.

### `distinct` con varias columnas

`select distinct bcolor, fcolor from distinct_demo order by bcolor, fcolor;`

Esto va a tomar cada **par único** de `bcolor` y `fcolor` como una observación.

### `distinct on`
`select distinct on (bcolor) as bcolor, fcolor from distinct_demo order by bcolor, fcolor;`

Esta forma del `distinct` primero desduplica una columna, y luego **selecciona el 1er registro** correspondiente de la 2a columna.

El resultado es el siguiente:

![](https://sp.postgresqltutorial.com/wp-content/uploads/2020/07/PostgreSQL-Distinct-select-distinct-on.png)

Como podemos ver, en lugar de desduplicar ambas columnas `bcolor` y `fcolor` al mismo tiempo, haciendo **cada par único**, `distinct on` primero desduplica la columna `bcolor` como si hubiera sido obtenida con `distinct` normal, pero para la 2a columna `fcolor`, en lugar de desduplicar, **selecciona el 1er registro que se encuentre** que corresponda a la columna previamente desduplicada.

Recuerdan el siguiente ejercicio que solicitaba **cuál es la orden más reciente por cliente?** Recuerdan que la respuesta implicaba un subselect?

```
select o.order_id , o.order_date, c.company_name
from orders o join customers c on o.customer_id = c.customer_id 
join (
	select c.company_name, max(o.order_date) as max_order_date
	from orders o join customers c on o.customer_id = c.customer_id
	group by c.company_name 
) t on o.order_date = t.max_order_date and c.company_name = t.company_name
```

Pues resulta que con `distinct on` podemos simplificar muchísimo el query:

```
-- contributed by @jchicatti
select distinct on (c.customer_id) c.customer_id, c.company_name, o.order_date, o.order_id 
from orders o join customers c using (customer_id)
order by c.customer_id, o.order_date desc;
```

**Por qué funciona esto?**

Sigamos el orden de ejecución de los queries:

1. Primero unimos las tablas `orders` y `customers` con `customer_id` como punto de intersección. Esto nos da todos los orders con su customer, los cuales estarán repetidos porque 1 `customers` puede tener N `orders`.
2. no hay `where`
3. no hay `group by`
4. no hay `having`
5. seleccionamos `customer_id`, `company_name`, `order_date` y `order_id`
6. aplicamos el `distinct on` al campo `customer_id`: esto significa que desduplicamos el `customer_id` de los campos seleccionados
   - luego obtenemos el 1er registro de `company_name` que le corresponde al `customer_id` desduplicado, el cual no puede ser otro debido a que un `customer_id` tiene como uno de sus atributos el `company_name`
   - luego hacemos lo mismo con el `order_date`, y dado que este es un campo de ordenamiento descendente, entonces el primer registro que tomemos va a ser la fecha máxima de la orden que le corresponde a ese `customer_id`.
   - finalmente, obtenemos el 1er registro de `order_id` que le corresponde al `customer_id` desduplicado, y como estamos ordenando por `order_date` de forma descendente, entonces el 1er registro corresponderá al máximo `order_id`, el cual, coincidentalmente, es el de la fecha máxima. Esto último puede no ser cierto si tenemos gaps entre la numeración de `order_id` o si por alguna razón no se cumple que el `order_id` máximo le corresponda el `order_date` máximo
8. ordenamos por `customer_id` y luego por `order_date`
9. no hay `limit`

Esto resulta en un query más rápido (aunque no lo notemos) y de mucho menor footprint sobre los recursos de nuestra máquina.

![](https://media.tenor.com/images/2625369b0af26548818660d7590ac4b3/tenor.png)

## Grupos dinámicos con funciones

Como hemos visto, en la cláusula `select` podemos poner no solo columnas, sino también funciones.

Lo que no sabían es que igual podemos poner funciones en el `group by`.

Estas funciones ⚠️**no deben ser de agregación**⚠️, sino de **preprocesamiento** del dato que está en la columna que nos vamos a traer.

Ejemplo:

Cómo podemos agrupar por quarter las órdenes en `orders` de la BD Northwind?

```
select c.company_name  , extract(quarter from o.order_date) as q_year, avg(o.freight)
from orders o join customers c using (customer_id)
group by c.company_name , q_year
```

En este `select`, q_year es el alias de una columna que está dada por función para procesamiento de campos `date` o `timestamp`.

La función `extract(`_parte_` from `_campo_de_fecha_`)` obtiene una parte del dato de un campo de fecha. En este caso, `quarter` representa el trimestre del año. 

El resultado es:

![](https://i.imgur.com/qY8f1Ex.png)

Este query agrupa por trimestre del año, concentrando el mismo para todos los años, lo cual es una excelente manera de condensar información en una ventana definida a lo largo de un período.

Dedicaremos 2 sesiones enteras de este parcial a ver diferentes funciones de texto, fechas, aritméticas, estadísticas y combinatorias. Todas ellas se pueden usar tanto en `select` como en `group by`.

## Agrupando múltiples criterios con `grouping sets`, `rollup` y `cube`

Ya hemos visto el uso de `group by`, con una columna (i.e. `nombre` con la tabla `superheroes_anios_servicio`):

| nombre          | equipo                      | **num de grupo (interno a PostgreSQL)** |
|-----------------|-----------------------------|-------------------------------------|
| Tony Stark      | Avengers                    | **1**                                   |
| Wanda Maximoff  | Avengers                    | **2**                                   |
| Wanda Maximoff  | X Men                       | **2**                                   |
| Erik Lensherr   | Acolytes                    | **3**                                   |
| Erik Lensherr   | Brotherhood of Evil Mutants | **3**                                   |
| Natasja Romanov | KGB                         | **4**                                   |
| Natasja Romanov | Avengers                    | **4**                                   |


Y con 2 columnas (i.e. `nombre`y `equipo`):

| nombre          | equipo                      | **num de grupo (interno a PostgreSQL)** |
|-----------------|-----------------------------|-------------------------------------|
| Tony Stark      | Avengers                    | **1**                                   |
| Wanda Maximoff  | Avengers                    | **2**                                   |
| Wanda Maximoff  | X Men                       | **3**                                   |
| Erik Lensherr   | Acolytes                    | **4**                                   |
| Erik Lensherr   | Brotherhood of Evil Mutants | **5**                                   |
| Natasja Romanov | KGB                         | **6**                                   |
| Natasja Romanov | Avengers                    | **7**                                   |

Qué sucede si queremos generar subtotales de los años de servico agrupados primero por `nombre` y luego por `nombre` y `equipo` **en el mismo query**?

Vamos a crear la siguiente tabla para ver este ejemplo:

```
create table sales (
  brand varchar not null,
  segment varchar not null,
  quantity integer not null,
  primary key (brand, segment)
);

insert into sales
values
('ABC', 'Premium', 100),
('ABC', 'Basic', 100),
('XYZ', 'Premium', 100),
('XYZ', 'Basic', 100);
```

Vamos a correr un query que agrupe los registros de este ejemplo por `brand`, por `segment`, por `brand` y `segment` y sin grupo, en un solo comando:

```
select brand, segment, sum(quantity) from sales group by brand, segment
union all
select brand, null, sum(quantity) from sales group by brand
union all
select null, segment, sum(quantity) from sales group by segment
union all
select null, null, sum(quantity) from sales;
```

![](https://i.imgur.com/mnq3fWo.png)

Por qué usamos `null`s? Recuerden que para usar el operador de conjuntos `union` (lo repasamos cuando vimos `join`), los queries que estamos uniendo deben tener las mismas columnas.

Por qué esta es una mala alternativa? Recuerden que los subqueries agregan costo de cómputo, y en este caso estamos multuplicando esa carga por 4.

Cómo podemos hacerlo más eficiente y sin tener que escribir tanto query?

```
select brand, segment, sum(quantity)
from sales
group by grouping sets (
  (brand, segment),
  (brand),
  (segment),
  ()
);
```

Cómo leemos estos resultados?

| brand | segment | sum | interpretación |
|-|-|-|-| 
| `null` | `null` | 400 | _Suma sin agrupación_ |
| XYZ | Basic | 100 | _Agrupación por `brand` y `segment`_ |
| ABC | Premium | 100 | _Agrupación por `brand` y `segment`_ |
| ABC | Basic | 100 | _Agrupación por `brand` y `segment`_ |
| XYZ | Premium | 100 | _Agrupación por `brand` y `segment`_ |
| ABC | `null` | 200 | _Agrupación por `brand`_ |
| XYZ | `null` | 200 | _Agrupación por `brand`_ |
| `null` | Basic | 200 | _Agrupación por `segment`_ |
| `null` | Premium | 200 | _Agrupación por `segment`_ |

Cómo sabemos qué estamos agrupando? Usando la cláusula `grouping` dentro del `select` en conjunto con `grouping sets`:

```
select
	grouping(brand) grouping_brand,
	grouping(segment) grouping_segment,
	brand,
	segment,
	sum (quantity)
from
	sales
group by
	grouping sets (
		(brand),
		(segment),
		()
	)
order by
	brand,
	segment;
```

![](https://i.imgur.com/Brnmti0.png)

Cómo leemos estos resultados?

Si **grouping_brand = 1** entonces el registro **no pertenece** al agrupamiento por `brand`.
Si **grouping_brand = 0** entonces el registro **si pertenece** 

![](https://i.pinimg.com/originals/1d/04/16/1d0416739c31389a56dafaf0a2e8cf79.png)

Confuso. Qué clase de monstruo hizo esta función? Cómo mejoramos legibilidad?

```
select
	not cast(grouping(brand) as boolean) agrupando_con_brand,
	not cast(grouping(segment) as boolean) agrupando_con_segment,
	brand,
	segment,
	sum (quantity)
from
	sales
group by
	grouping sets (
		(brand),
		(segment),
		()
	)
order by
	brand,
	segment;
```
Verboso, pero mejor, no?

### Condensando `grouping set` con `rollup`

En lugar de 

```
...
group by
	grouping sets (
		(brand, segment)
		(brand),
		()
	)
```

Podemos usar

```
select brand, segment, sum(quantity)
from sales
group by rollup (brand, segment);
```

Esto generará los `grouping set`s removiendo recursivamente una columna de agrupamiento.

Esto es útil cuando tenemos grupos categóricos jerárquicos. Consideremos la siguiente tabla `ventas`:

| monto | localidad | municipio | estado | region |
|-|-|-|-|-|
| 10 | Sapioriz | El Oro | Durango | Centro-Norte |
| 100 | Valles Altos | Zapotlanejo | Jalisco | Bajío |
| 200 | Altata | Ahome | Sinaloa | Noroeste |

Tendría muchísimo sentido si lanzáramos un query de la siguiente forma para acumular **jerárquicamente**, los montos por diferentes niveles de agrupación geográfica.

```
select sum(monto) from ventas
group by rollup(region, estado, municipio, localidad);
```

Porque lo que hará PostgreSQL va a hacer lo siguiente:
```
...
group by grouping sets (
	(region, estado, municipio, localidad),
	(region, estado, municipio),
	(region, estado),
	(region),
	()
```
Y dado que en la jerarquía, `region` > `estado` > `municipio` > `localidad`, entonces los niveles de agregación tienen sentido para el problem domain.
	

#### Ejercicio:

De la BD Sakila, cómo podemos obtener el conteo del num de películas por rating que cada actor ha tenido, y generar un subtotal concentrando todos los ratings, y agregar un conteo total?

<details>
  <summary>No se vale ver!</summary>
  <pre><code>
	select concat(a.first_name,' ', a.last_name) as full_name, f.rating , count(a.actor_id) 
	from film_actor fa join film f using (film_id)
	join actor a using (actor_id)
	group by rollup (f.rating, full_name)
	order by 1,2;
  </code></pre>
</details>

### Condensando `grouping set` con `cube`

Igual que `rollup`, pero en lugar de recursivamente reducir la lista de columnas hasta llegar a una columna individual y luego a nulo, lo hace para todas las combinaciones posibles, de modo que una cláusula como esta:

```
...
...
group by cube (a,b,c)
```

Es igual a esta:

```
...
...
group by grouping sets (
   (a,b,c),
   (a,b  ),
   (a,  c),
   (  b,c),
   (a    ),
   (  b  ),
   (    c),
   (     )
)
```
De este modo, cube nos da el producto cruz de los grouping sets que elijamos.

Revisitemos el ejemplo del conteo de películas, pero ahora con `cube`:

<details>
  <summary>No se vale ver!</summary>
  <pre><code>
	select concat(a.first_name,' ', a.last_name) as full_name, f.rating , count(a.actor_id) 
	from film_actor fa join film f using (film_id)
	join actor a using (actor_id)
	group by cube (full_name, f.rating)
	order by 1,2;
  </code></pre>
</details>

