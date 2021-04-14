# Window Functions

Una window function nos permite combinar funciones de agregación (`avg()`, `sum()`, `corr()`, etc) con resultados individuales para poder tener algo como esto:

![](https://i.imgur.com/DNewUP3.png)

Si quisiéramos lograr esto con los comandos e instrucciones que sabemos hasta ahorita, intentaríamos algo así:

```sql
select p.product_name as product_name, 
c.category_name as category, 
avg(p.unit_price) as avg_price
from products p join categories c using (category_id)
group by c.category_name
```

Y pues nos saldría el mismo error de siempre cada vez que queremos hacer estas cosas:

![](https://i.imgur.com/Z0d6dTF.png)

No podemos darle la vuenta con `distinct on` porque tendríamos que agrupar por `product_name`, y pues eso no resulta en lo que queremos arriba.

## Definición

Las window functions son similares a las funciones de agregación en que operan sobre un grupo de renglones.

A diferencia de las funciones de agregación, las window functions no **reducen** el número de renglones del resultado.

![](https://miro.medium.com/max/2400/1*tnYxTRQVXh_xSuqlG3lcDQ.png)

La palabra _window_ implica una ventana de renglones sobre la cual la función actúa.

Cómo podemos entonces lograr el resultado de arriba?

```sql
select p.product_name as prod_name, 
c.category_name as category, 
avg(p.unit_price) over (partition by c.category_name) as avg_price
from products p join categories c using (category_id);
```

La cláusula `partition by` funciona _parecido_ a un `group by`, pero sin colapsar los renglones, calculando el promedio del precio de los productos dentro de cada `category_name`, y luego asignando este valor repetido a cada renglón del _window_.

## Orden de ejecución

La cláusula `partition by` se ejecuta **después** del `having` y antes del `order by`:

![](https://i.imgur.com/fo6mfJG.png)

## Sintaxis exclusiva de PostgreSQL

```sql
select
  window_function1(argumentos) over w,
  window_function2(argumentos) over w,
from tabla
window w as (
  [partition by columna o expresión]
  [order by columna o expresión [asc|desc] [nulls first|nulls last]]
)
```

## Funciones disponibles para operar como window functions

Aparte de las funciones de agregación `avg()`, `sum()`, `min()`, `max()`, `count()`, etc, es posible definir window functions con las siguientes funciones:

|Función|Descripción|
|-|-|
| `first_value(`_columna_`)` | Regresar el valor de _columna_ del 1er registro de su propia partición. |
| `lag(`_columna_`,`_N_`,`_valor default_`)` | Regresar el valor de _columna_ a _N_ posiciones antes del registro actual dentro de su propia partición; regresa _default_ si _N_ se pasa más allá del inicio de su partición. |
| `last_value(`_columna_`)` | Regresar el valor de _columna_ del último registro de su propia partición. |
| `lead(`_columna_`,`_N_`,`_valor default_`)` | Regresar el valor de _columna_ a _N_ posiciones después del registro actual dentro de su propia partición; regresa _default_ si _N_ se pasa más allá del final de su partición.|
| `ntile(`_num de grupos_`)` | Dividir los renglones de la partición en _num de grupos_ iguales lo mejor posible y asignar a cada renglón un número de parte. |
| `percent_rank()` | Divide la partición en percentiles; es necesario que la partición se haga con `order by` de una columna numérica. |
| `rank()` | Asigna un rango numérico a los registros dentro de su propia partición, de menor a mayor o al revés. |
| `row_number()` | Numerar el registro actual dentro de su propia partición comenzando por 1. |

### `row_number()`

Número de renglón por categoría de producto en Northwind:

```sql
select p.product_name as prod_name, 
c.category_name as category, 
row_number() over w as rownum
from products p join categories c using (category_id)
window w as (partition by c.category_name);
```

### `rank()`

Rankeo de precios por categoría de producto:

```sql
select p.product_name as prod_name, 
c.category_name as category, 
rank() over w as rownum
from products p join categories c using (category_id)
window w as (partition by c.category_name order by p.unit_price);
```

Es posible que en el rankeo definido por la función haya _gaps_, por ejemplo:

![](https://i.imgur.com/rF7D9d2.png)

Estos gaps son porque cuando 1 o más renglones tiene el mismo valor, entonces tendrán el mismo rank, y el conteo continúa a pesar de ello. En este ejemplo, el 2o rank dado como `4` implica que el valor está repetido, aunque lleve el contador interno a 5. El siguiente `4` lo lleva a 6, y así sucesivamente hasta que la window function cambia de valor, en cuyo momento pone el contador a como va en ese momento.

Si queremos evitar estos _gaps_ podemos usar la función **`dense_rank()`** en lugar de `rank()`.

Es importante que definamos la ventana con `partition` **y aparte** con `order by` (y opcionalmente, `desc` o `asc`), de lo contrario la función `rank()` no sabrá qué valor es 1o y qué valor es último para ninguna partición.

Igual si usamos `desc`, el num 1 de la partición será el mayor, y si usamos `asc`, el num 1 de la partición será el menor.

### `first_value()` y `last_value()`

Para estas funciones, y para las siguientes, vamos a cargar datos de [Yahoo Finance](https://finance.yahoo.com/) del mercado de capitales. Particularmente vamos a descargar la serie de precios diaria para el índice [_Standard&Poors 500_](https://finance.yahoo.com/quote/%5EGSPC?p=^GSPC&.tsrc=fin-srch).

Primero vamos a crear la tabla `t_stock`:

```sql
CREATE TABLE t_stock (
  
  d date,
  open numeric,
  high numeric,
  low numeric,
  close numeric,
  volume int8,
  adj_close numeric
);
```

Aunque esta tabla no tiene una llave primaria, creo que podemos inferir que `d date` es un muy buen candidato para serlo. 

Los demás campos se referirán al precio del instrumento que vamos a descargar: cierre, apertura, máximo, mínimo, volumen operado y precio de cierre ajustado.








