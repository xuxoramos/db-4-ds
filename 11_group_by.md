# Orden de ejecución de SQL queries

A continuación un slide de una presentación de productos Microsoft para ilustrar el orden de ejecución de los queries de acuerdo al compilador de SQL.

No hagan caso al paso final de conversión a XML, esto en PostgreSQL no sucede, si no lo pedimos.

![image](https://user-images.githubusercontent.com/1316464/136132578-50266551-571c-453b-905f-80e4b7ea8476.png)

El compilador de SQL cambia el orden de ejecución:

1. Primero ejecuta el `from` y sus respectivos `join`, esto para subir al _transaction log_ el dataset crudo con el que vamos a trabajar.
2. Luego sucede el _filtering_ de los renglones que no van a participar en el query con la cláusula `where`.
3. Se arman los grupos con `group by` de acuerdo a las columnas seleccionadas para este propósito. Pueden ser 1 o N, obviamente tener 1 solo grupo, o 18 grupos en una tabla **con 18 registros** con ambas muy mala idea, y lo idóneo es que los grupos nos ayuden a **reducir la complejidad** del análisis.
4. Se filtran los grupos que no queremos en el query con `having`, ya sea con la misma función de agregación que aparece en el `select`, o bien con otra totalmente diferente.
5. Seleccionamos las columnas (existentes o recién creadas, o bien datos fijos) que queremos que aparezcan en el resultset final.
6. Ordenamos el resultado con `order by`, sea ascendente o descendente.
7. Se ejecuta la cláusula `limit` para seleccionar solamente algunos renglones del resultado final.

# Agrupaciones, agregados y sumarizaciones

La operación `group by` _agrupa_ renglones de acuerdo a un criterio, principalmente para poder aplicar funciones de _agregación_ a cada grupo.

Por [definición](https://en.wikipedia.org/wiki/Aggregate_function), una función de agregación se debe aplicar a un conjunto de renglones agrupados previamente para formar un único valor de resumen.

## Funciones simples de agregación en PostgreSQL

Las funciones de agregación más comunes que usarán en clase, en el proyecto final, y en la vida, son las siguientes:

| función                    | qué hace?                                                                                                                   | dónde va?                       | qué tipo de columna toma como argumento?                                                                                                                   |
|----------------------------|-----------------------------------------------------------------------------------------------------------------------------|---------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| sum(x)                     | Sumatoria de la columna x a lo largo de los renglones seleccionados                                                         | en el `select` o en el `having` | `integer`, `bigint`, `smallint`, `numeric`, `real`, `interval`, `money`                                                                                    |
| max(x) / min(x)            | Máximo / mínimo valor de los registros del campo x                                                                          | en el `select` o en el `having` | Todos los tipos (incluyendo `enum`). Para `varchar`, A < B < C < Z.                                                                                        |
| count(x)                   | Número de observaciones o renglones del campo x                                                                             | en el `select` o en el `having` | Cualquier columna de cualquie tipo. **`*`** representa todas las columnas, pero es más lento para tablas de +500,000 registros. Mejor usar 1 sola columna. |
| avg(x)                     | [Promedio aritmético](https://en.wikipedia.org/wiki/Arithmetic_mean) de la columna x a lo largo de renglones seleccionados. | en el `select` o en el `having` | `integer`, `bigint`, `smallint`, `numeric`, `real`, `interval`, `money`                                                                                    |
| bool_and(x) / bool_or(x)   | Ejecuta los operadores `and` u `or` a lo largo de los renglones de la columna enviada como paráme                           | en el `select` o en el `having` | `boolean`                                                                                                                                                  |
| string_agg(x, _delimiter_) | Concatena en un solo string todos los valores de la columna x, separado por el caracter en el argumento `delimiter`         | en el `select` o en el `having` | `text`, `varchar`, `char`                                                                                                                                  |

## Funciones estadísticas de agregación

Hay algunas funciones que nos permiten calcular correlaciones, covarianzas, promedios y desviaciones estándar, tanto de la población como de la muestra. También existen funciones para hacer regresiones lineales.

Están padres y todo, pero para hacer este trabajo de análisis, es mejor utilizar plataformas hechas para eso como el tidyverse de R o Pandas de Python.

> **IMPORTANTE:** Es un best-practice el paradigma de que _el análisis debe ser "vecino" de los datos_. Esto significa que el procesamiento y análisis debe, en la medida de lo posible, vivir en la misma infraestructura. Esto de todos modos no es razón para usar SQL para análisis avanzado como regresiones lineales, aún cuando logremos el máximo performance. El tradeoff de ganar _flexibilidad de cambio_, _readability_, _fault tolerance_ y _error control_ VS perder un poco de _performance_ justifica que el análisis se lleve a cabo en la misma infraestructura, pero en diferente plataforma (R, Python, Tableau, etc).

De todos modos les pongo las más comunes:

| función                              | qué hace?                                           |
|--------------------------------------|-----------------------------------------------------|
| corr(x, y)                           | coeficiente de correlación                          |
| covar_pop(x, y) / covar_samp(x, y)   | covarianza de la población / de la muestra          |
| var_pop(x, y) / var_samp(x, y)       | varianza de la población / de la muestra            |
| stddev_pop(x) / stddev_samp(x) | desviación estándar de la población / de la muestra |

**IMPORTANTE:** Todas estas funciones requieren que x y y (osea, las columnas numéricas que pasamos como argumento) sean de tipo `double precision` o convertidas a este tipo antes de ser usadas en las funciones. Algunos SQL Clients (como DBeaver) trabajan con el driver para ahorrarnos esta conversión.

## Explicación visual

![](https://miro.medium.com/max/1644/0*Z4rGZFc-KBPVItZi.png)

## Errores comunes en `group by`

### No incluir los campos del `group by` en el `select`

La anatomía del `group by` podemos decir que es:
```
select columna1, columna2, función_agregación(columna3)
from tabla
group by columna1, columna2
```
**OJO:** es requisito incluir las columnas por las que agrupamos con `group by` y ponerlas de nuevo en el `select`. De lo contrario obtendremos un error que ya es tradición en este HHH grupo:

![](https://i.imgur.com/EYwGbzB.png)

Por qué sucede esto?

Imaginemos la siguiente tabla `superheroes_anios_servicio` y query:

| nombre          | equipo                      | anios_servicio |
|-----------------|-----------------------------|----------------|
| Tony Stark      | Avengers                    | 10             |
| Wanda Maximoff  | Avengers                    | 5              |
| Wanda Maximoff  | X Men                       | 3              |
| Erik Lensherr   | Acolytes                    | 10             |
| Erik Lensherr   | Brotherhood of Evil Mutants | 12             |
| Natasja Romanov | KGB                         | 8              |
| Natasja Romanov | Avengers                    | 10             |

```
select nombre, equipo, sum(anios_servicio)
from superheroes_anios_servicio
group by nombre
``` 

Vamos a obtener el error descrito arriba. Por qué?

Para entender el error anterior, debemos conocer el orden de ejecución de los comandos SQL.

PostgreSQL (y realmente la mayoría de los RDBMS) evalúa las cláusulas en este orden:

![](https://sp.postgresqltutorial.com/wp-content/uploads/2020/07/PostgreSQL-GROUP-BY-1.png)

Entonces tenemos la siguiente secuencia de ejecución para el query de ejemplo sobre la tabla `superheroes_anios_servicio`:

1. se arma el dataset sobre el cual vamos a correr el query, ya sea tomando 1 sola tabla, o conectándolas con la serie de `joins` que aparezcan en el `from`. En este caso, solo es la tabla `superheroes_anios_servicio`.
2. se filtran los rows de ese dataset con las condiciones que aparezcan en el `where`. En este caso, no hay `where`.
3. se toman las columnas del `group by` y se forman los grupos. En este caso, se forma 1 solo grupo con el campo `nombre`.
4. se filtran los grupos con las condiciones en el `having`. En este caso no hay `having`.
5. se filtran las columnas que queremos regresar en el query con los argumentos del `select`. En este caso tomamos `nombre`, `equipo` y la sumatoria de `anios_servicio`.
    - :warning: Aquí es donde truena todo como ejote. El motor de PostgreSQL no sabe qué regresar en el query porque armó un grupo con `nombre`, hizo la sumatoria de `anios_servicio` y además tiene que anexar la columna `equipo`, pero **con qué valor?** Tomemos a Wanda Maximoff. Su renglón resultante de ese query será que tiene 8 años de servicio, pero **con qué equipo?** Avengers? X Men? Ambos?

![](https://i.kym-cdn.com/entries/icons/facebook/000/022/628/Screen_Shot_2017-04-05_at_2.58.07_PM.jpg)

### Usar funciones de agregación en el `where`

En este HHH grupo también hemos tenido errores con este tipo de queries:

`SELECT city FROM weather WHERE temp_lo = max(temp_lo);`

El origen de este error está también en el orden de evaluación del comando `select`. Sigamos esta ejecución:

1. traemos al espacio de ejecución la tabla `weather`.
2. intentamos filtrar los renglones con la función `max()` en la cláusula `where`.
    - :warning: aquí es donde sucede el error, porque la función `max` debe seleccionar el máximo de todos los renglones filtrados por el `where`, y por tanto para que esto funcione debe ser evaluado antes que el mismo `where`, lo cual es una violación a las reglas de compilación de SQL. Es un problema de tipo "fue primero el huevo, o la gallina?"

![image](https://user-images.githubusercontent.com/1316464/109833084-97998200-7c06-11eb-94a5-abc237157b05.png)

## Ejercicios con 1 solo grupo

Usando la base de datos Northwind, ayúdenme a obtener:

1. El flete promedio que enviamos por cada shipping company.
```
select s.company_name , avg(o.freight) 
from orders o join shippers s on (o.ship_via = s.shipper_id)
group by s.shipper_id;
```
2. La correlación entre el monto pagado por un producto en una orden y el descuento aplicado.
```
select od.product_id , corr(od.unit_price * od.quantity, od.discount) 
from orders o join order_details od using (order_id)
group by od.product_id
```
3. Si algún producto de cada categoría está descontinuado.
```
select c.category_name , bool_or(cast(p.discontinued as boolean))
from products p join categories c using (category_id)
group by c.category_name
```

### Una notita sobre cast()

La función `cast(columna as tipo_nuevo)` nos permite convertir _al vuelo_ entre tipos de datos, para uso en algún comando SQL, sin necesariamente modificar estructuralmente el tipo de columna.

Ejemplos:
```
> select cast(0 as boolean)

bool |
-----|
false|

> select cast(1 as boolean)
 
bool |
-----|
true |

> select cast(10 as boolean)
 
bool |
-----|
true |

> select cast(99999999999 as boolean)
 
bool |
-----|
true |

> select cast('a' as boolean)
 
ERROR: invalid input syntax for type boolean: "a"

> select cast(10.34 as varchar)
 
varchar|
-------|
10.34  |

> select cast('10.34' as numeric)
 
numeric|
-------|
10.34  |
```

## Continuemos con los ejercicios

4. Qué pasa si repetimos el ejercicio de arriba, pero con la función de agregación `string_agg(x, delim)`?
```
select string_agg(c.category_name, ',')
from products p join categories c using (category_id)
group by c.category_name
```
6. Si hay relación entre el reorder level de un producto y las cantidades promedio de las órdenes de ese mismo producto (este no lo he resuelto).
> :warning: Este ejercicio tiene poco sentido porque para que la función `corr(x,y)` sea efectiva, debe haber una correspondencia de puntos, y lo que propongo aquí implica que `x` es `products.reorder_level`, lo cual es un solo dato VS las transacciones del mismo producto, que son N datos.

## Agrupación con múltiples columnas

A diferencia del agrupado por 1 columna, el agrupado por más de 1 columna nos permite armar múltiples grupos.

Retomando el ejemplo de la tabla `superheroes_anios_servicio`

| nombre          | equipo                      | anios_servicio |
|-----------------|-----------------------------|----------------|
| Tony Stark      | Avengers                    | 10             |
| Wanda Maximoff  | Avengers                    | 5              |
| Wanda Maximoff  | X Men                       | 3              |
| Erik Lensherr   | Acolytes                    | 10             |
| Erik Lensherr   | Brotherhood of Evil Mutants | 12             |
| Natasja Romanov | KGB                         | 8              |
| Natasja Romanov | Avengers                    | 10             |

Si al query original agregamos el `equipo` como parte de los grupos, entonces ya funcionaría.

La cláusula `group by nombre, equipo` armaría los siguientes grupos, para quien **la función de agregación correrá de forma separada**, por cada uno.

| nombre          | equipo                      | **num de grupo (interno a PostgreSQL)** |
|-----------------|-----------------------------|-------------------------------------|
| Tony Stark      | Avengers                    | **1**                                   |
| Wanda Maximoff  | Avengers                    | **2**                                   |
| Wanda Maximoff  | X Men                       | **3**                                   |
| Erik Lensherr   | Acolytes                    | **4**                                   |
| Erik Lensherr   | Brotherhood of Evil Mutants | **5**                                   |
| Natasja Romanov | KGB                         | **6**                                   |
| Natasja Romanov | Avengers                    | **7**                                   |

Todas las funciones de agregación **se reinicializan** al comenzar a actuar sobre un grupo diferente:

1. `sum()` se resetea a 0
2. `avg()` resetea su numerador a 0, mientras que el denominador se mantiene como `count()` de observaciones del grupo
3. `count()` se resetea a 0
4. `bool_and() / bool_or()` se resetean a `null`

### Ejercicios:
1. Cuál es el promedio de flete gastado para enviar productos de un proveedor a un cliente?
```
select c.company_name as customer, s.company_name as shipper, avg(o.freight) as flete
from orders o join shippers s on (o.ship_via = s.shipper_id) 
join order_details od on (od.order_id = o.order_id) 
join customers c on (c.customer_id = o.customer_id)
group by c.company_name, s.company_name;
```
2. Cuál es nuestra balanza comercial por país?
```
-- Este query fue finalmente resuelto por el grupo de BD1 de OI2021 a las 15:14
-- Felicidades :D <3
select country,
	case 
		when export_amount is null and import_amount is null then 0
		when export_amount is null and import_amount > 0 then import_amount*-1
		when import_amount is null and export_amount > 0 then export_amount
		else export_amount - import_amount
	end as balanza_comercial
from (
	select c.country as country, sum(od.unit_price*od.quantity*(1-od.discount)) as export_amount
	from orders o join customers c using (customer_id)
	join order_details od using (order_id)
	join products p using (product_id)
	join suppliers s using (supplier_id)
	where s.country != c.country 
	group by c.country
) as exports full outer join (
	select s.country as country , sum(od.unit_price*od.quantity) as import_amount
	from orders o join customers c using (customer_id)
	join order_details od using (order_id)
	join products p using (product_id)
	join suppliers s using (supplier_id)
	where s.country != c.country
	group by s.country
) as imports using (country);
```

## Próxima clase
Agrupaciones II

