# Agrupaciones II

## La cláusula `distinct`

## Grupos dinámicos con funciones

Como hemos visto, en la cláusula `select` podemos poner no solo columnas, sino también funciones.

Lo que no sabían es que igual podemos poner funciones en el `group by`.

Estas funciones ⚠️**no deben ser de agregación**⚠️, sino de **preprocesamiento** del dato que está en la columna que nos vamos a traer.

Ejemplo:

Cómo podemos agrupar por año-mes las órdenes en `orders` de la BD Northwind?



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
...
group by
	grouping sets (
		(brand, segment)
		(brand),
		(segment),
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

#### Ejercicio:

De la BD Sakila, cómo podemos obtener el conteo del num de películas por rating que cada actor ha tenido, y generar un subtotal concentrando todos los ratings, y agregar un conteo total?

<details>
  <summary>No se vale ver!</summary>
  <codeblock>
	select concat(a.first_name,' ', a.last_name) as full_name, f.rating , count(a.actor_id) 
	from film_actor fa join film f using (film_id)
	join actor a using (actor_id)
	group by cube (full_name, f.rating)
	order by 1,2;
  </codeblock>
</details>

### Condensando `grouping set` con `cube`

Igual que `rollup`, pero en lugar de recursivamente reducir la lista de columnas hasta llegar a grupos individuales, lo hace para todas las combinaciones posibles, de modo que una cláusula como esta:

```
...
...
group by cube (a,b,c)
```

Es igual a este:

```
...
...
group by grouping sets (
   (a,b,c),
   (a,b  ).
   (a,  c)
   
)
```
