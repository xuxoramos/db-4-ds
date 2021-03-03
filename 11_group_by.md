# Agrupaciones, agregados y sumarizaciones

La operación `group by` _agrupa_ renglones de acuerdo a un criterio, principalmente para poder aplicar funciones de _agregación_ a cada grupo.

Por [definición](https://en.wikipedia.org/wiki/Aggregate_function), una función de agregación se debe aplicar a un conjunto de renglones agrupados previamente para formar un único valor de resumen.

## Funciones simples de agregación en PostgreSQL

Las funciones de agregación más comunes que usarán en clase, en el proyecto final, y en la vida, son las siguientes:

| función                    | qué hace?                                                                                                                   | dónde va?                       | qué tipo de columna toma como argumento?                                                                                                                   |
|----------------------------|-----------------------------------------------------------------------------------------------------------------------------|---------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| sum(x)                     | Sumatoria de la columna x a lo largo de los renglones seleccionados                                                         | en el `select` o en el `having` | `integer`, `bigint`, `smallint`, `numeric`, `real`, `interval`, `money`                                                                                    |
| max(x) / min(x)            | Máximo / mínimo valor de los registros del campo x                                                                          | en el `select` o en el `having` | Todos los tipos (incluyendo `enum`). Para `varchar`, A > B > C > Z.                                                                                        |
| count(x)                   | Número de observaciones o renglones del campo x                                                                             | en el `select` o en el `having` | Cualquier columna de cualquie tipo. **`*`** representa todas las columnas, pero es más lento para tablas de +500,000 registros. Mejor usar 1 sola columna. |
| avg(x)                     | [Promedio aritmético](https://en.wikipedia.org/wiki/Arithmetic_mean) de la columna x a lo largo de renglones seleccionados. | en el `select` o en el `having` | `integer`, `bigint`, `smallint`, `numeric`, `real`, `interval`, `money`                                                                                    |
| bool_and(x) / bool_or(x)   | Ejecuta los operadores `and` u `or` a lo largo de los renglones de la columna enviada como paráme                           | en el `select` o en el `having` | `boolean`                                                                                                                                                  |
| string_agg(x, _delimiter_) | Concatena en un solo string todos los valores de la columna x, separado por el caracter en el argumento `delimiter`         | en el `select` o en el `having` | `text`, `varchar`, `char`                                                                                                                                  |

## Funciones estadísticas de agregación

Hay algunas funciones que nos permiten calcular correlaciones, covarianzas, promedios y desviaciones estándar, tanto de la población como de la muestra. También existen funciones para hacer regresiones lineales. Están padres y todo, pero para hacer este trabajo de análisis, es mejor utilizar plataformas hechas para eso como el tidyverse de R o Pandas de Python. De todos modos les pongo las más comunes:

| función                              | qué hace?                                           |
|--------------------------------------|-----------------------------------------------------|
| corr(x, y)                           | coeficiente de correlación                          |
| covar_pop(x, y) / covar_samp(x, y)   | covarianza de la población / de la muestra          |
| var_pop(x, y) / var_samp(x, y)       | varianza de la población / de la muestra            |
| stddev_pop(x) / stddev_samp(x) | desviación estándar de la población / de la muestra |

**IMPORTANTE:** Todas estas funciones requieren que x y y (osea, las columnas numéricas que pasamos como argumento) sean de tipo `double precision` o convertidas a este tipo antes de ser usadas en las funciones.

## Explicación visual

![](https://miro.medium.com/max/1644/0*Z4rGZFc-KBPVItZi.png)

## Anatomía de un `group by`
```
select columna1, columna2, función_agregación(columna3)
from tabla
group by columna1, columna2
```
Como podemos ver, es requisito incluir las columnas por las que agrupamos con `group by` y ponerlas de nuevo en el `select`.

Veamos el siguiente ejemplo:

```
``` 


de lo contrario nos vamos a encontrar con el error que ya es tradición en este HHH grupo:




### Orden de ejecución de las sentencias SQL

Para entender el error anterior, debemos conocer el orden de ejecución de los comandos SQL.

PostgreSQL (y realmente la mayoría de los RDBMS) evalúa las cláusulas `group by` después del `from` y el `where`, pero antes del `having`, `select`, `distinct`, `order by` y `limit`.

![](https://sp.postgresqltutorial.com/wp-content/uploads/2020/07/PostgreSQL-GROUP-BY-1.png)

## Ejercicios con 1 solo grupo

## Agrupación con múltiples columnas

A diferencia del agrupado por 1 columna, el agrupado por más de 1 columna nos permite armar múltiples grupos.

Tomemos por ejemplo un agrupado de `orders` VS 

```
select c.company_name as customer, s.company_name as shipper, avg(o.freight) as flete
from orders o join shippers s on (o.ship_via = s.shipper_id) 
join order_details od on (od.order_id = o.order_id) 
join customers c on (c.customer_id = o.customer_id)
group by c.company_name, s.company_name  
```

