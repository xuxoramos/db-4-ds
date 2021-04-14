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

Para estas funciones, y para las siguientes, vamos a cargar datos de [Yahoo Finance](https://finance.yahoo.com/) del mercado de capitales. Particularmente vamos a descargar la serie de precios diaria para el [DogeCoin}(https://en.wikipedia.org/wiki/Dogecoin) y vamos a calcular su retorno diario y su retorno anual. Los pasos son:

1. Crear la tabla `t_stock`:

```sql
CREATE TABLE t_stock (
  d date,
  open numeric,
  high numeric,
  low numeric,
  close numeric,
  adj_close numeric,
  volume int8
);
```

Aunque esta tabla no tiene una llave primaria, creo que podemos inferir que `d date` es un muy buen candidato para serlo. 

Los demás campos se referirán al precio del instrumento que vamos a descargar: cierre, apertura, máximo, mínimo, volumen operado y precio de cierre ajustado.

2. Descargar la serie de precios histórica de [Yahoo Finance](https://query1.finance.yahoo.com/v7/finance/download/DOGE-USD?period1=1586874050&period2=1618410050&interval=1d&events=history&includeAdjustedClose=true)

3. Ir a la tabla `t_stock` en nuestro DBeaver, dar click derecho y dar click en `Import Data`

![](https://i.imgur.com/iTROKtS.png)

4. Seleccionar la opción `Import CSV file(s)` y dar click en `Next`. Saldrá una ventanita para ir por nuestro CSV que acabamos de descargar. Selecciónenlo.

![](https://i.imgur.com/EqAoaEK.png)

5. Saldrá una ventana de descripción del proceso de import. Scrolleen hacia abajo para encontrar un renglón que dice `NULL value mark` y en el espacio en blanco de la derecha escriban el valor **`null`** y dar click en `Next`.

![](https://i.imgur.com/jjYx5gt.png)

Esto es para que PostgreSQL reconozca el texto `null` en el archivo como un **valor `NULL`** en la base de datos, dado que tenemos días donde no se operó DogeCoin y por tanto no tenemos datos para esas fechas.

6. Esta es la pantalla de configuración del import. Den click en `Columns...` para poder mapear de las columnas del archivo CSV a las columnas de la tabla:

![](https://i.imgur.com/mho7LSV.png)

7. Vamos a mapear las columnas así:

  - Source: "Date"      Target: "d"
  - Source: "Open"      Target: "open"
  - Source: "High"      Target: "high"
  - Source: "Low"       Target: "low"
  - Source: "Close"     Target: "close"
  - Source: "Adj Close" Target: "adj_close"
  - Source: "Volume"    Target: "volume"

![](https://i.imgur.com/sam2QWB.png)

Verifiquen que en esta pantalla, la columna de la derecha `Mapping` diga `existing` en todos los renglones, de lo contrario PostgreSQL creará nuevas columnas en lugar de usar las existentes.

8. Tenemos una pantalla de configuración del proceso de carga que va a suceder (transacciones y creación de columnas). Dejen todo como está, no muevan nada y den `Next`

![](https://i.imgur.com/OcrqQcQ.png)

9. Finalmente tenemos la pantalla de confirmación. Igual, den click en `Start` para comenzar el import:

![](https://i.imgur.com/CuMvntI.png)

10. Voilá! Habemus data!

![](https://i.imgur.com/zoz2g9y.png)

### Ahora si, window functions













