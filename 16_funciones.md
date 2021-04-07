# Funciones

Una función toma un input y saca un output.

Dicho output puede ser luego usado en un `select`, en un `where` o en un `group by`.

Pueden actuar sobre strings (o campos `varchar`), numéricos (campos `integer`, `numeric`, `bigint`, etc), fechas (`date`, `timestamp`, etc) o booleanos (operadores `not`, `or`, `and` y de igualdades `<`, `>`, `=`).

Una función que recibe un tipo de dato o columna, puede regresar otro tipo de dato totalmente diferente.

## Booleanos

Ya los vimos, pero repasemos algunos que van usualmente en el `where`:

- `a between x and y` es idéntico a `a >= x and a <= y`
- `a not between x and y` es idéntico a `a < x or a > y`
- Recuerden que el `not` convierte los `and` en `or` y los `>` en `<=` y viceversa
- `is null` e `is not null`: recuerden que _columna_`=null` evalúa a _undefined_.

Y los que vimos para **evaluar columnas**:
- `bool_or(`_columna_`)` y `bool_and(`_columna_`)`: recuerden que _columna_ debe ser boolean, o castearla a boolean con `cast(`_columna_` as boolean)`.

## De conversión

- `cast(`_columna_` as `_nuevo tipo de dato_`)`
- ...o su _forma corta_: _antiguo tipo de dato_`::`_nuevo tipo de dato_ (i.e. `select '2020-12-31 23:59:59'::timestamp as newyearseve` es lo mismo que `select cast('2020-12-31 23:59:59'as timestamp) as newyearseve`)

## Numéricos

Ya vimos algunos estadísticos, pero enteramente numéricos, veamos:

|Función| Qué hace? | Ejemplo | Resultado |
|-|-|-|-|
| `abs(`_numeric_`)` |  valor absoluto | `select abs(-17.4)` | **17.4** |
| `ceil(`_numeric_`)` |  entero más cercano, mayor o igual al argumento | `select ceil(-42.8)` | **-42** |
| `div(`_x_`,`_y_`)` |  cociente entero de `x/y` | `select div(9,4)` | **2** |
| `exp(`_numérico o doble precisión_`)` |  exponencial _e_ | `select exp(1)` | **2.71828182845905** |
| `floor(`_numérico o doble precisión_`)` |  entero más cercano, menor o igual al argumento | `select floor(-42.8)` | **-43** |
| `ln(`_numérico o doble precisión_`)` |  logaritmo natural, recíproco de _e_ | `select ln(1)` | **0** |
| `log(`_numérico o doble precisión_`)` |  logaritmo base 10 | `select log(100)` | **2** |
| `log(`_b_`,`_x_`)` | logaritmo base _b_ de _x_ | `select log(2, 64)` | **6** |
| `mod(`_x_`,`_y_`)` |  operación módulo: residual de la división _x/y_ | `select mod(9,4)` | **1** |
| `pi()` |  constante  "π" | `select pi()` | **3.14159265358979** |
| `power(`_a_`,`_b_`)` |  _a_ elevado a la _b_ potencia | `select power(9, 3)` | **729** |
| `round(`_numérico_`)` |  redondeo al entero más cercano: del 1 al 4 redondea hacia abajo, y del 5 al 9 redondea hacia arriba | `select round(42.4)` | **42** |
| `round(`_a_`,`_b_`)` |  redondeo de _a_ a _b_ posiciones decimales, mismas reglas que arriba | `select round(42.4382, 2)` | **42.44** |
| `sign(`_a_`)` |  signo de _a_ (-1, 0, +1) | `select sign(-8.4)` | **-1** |
| `sqrt(`_numérico_`)` |  raíz cuadrada | `select sqrt(2)` | **1.4142135623731** |
| `trunc(`_numérico_`)` |  truncar la parte decimal | `select trunc(42.8)` | **42** |
| `sin(`_numérico_`)` | seno trigonométrico | `select sin(45)` | **0.8509035245341184** |
| `cos(`_numérico_`)` | coseno trigonométrico | `select cos(45)` | **0.5253219888177297** |
| `tan(`_numérico_`)` | truncar _a_ por _b_ posiciones decimales | `select tan(45)` | **1.6197751905438615** |
| `cot(`_numérico_`)` | truncar _a_ por _b_ posiciones decimales | `select cot(45)` | **0.6173696237835551** |

### Ejemplos

Lo chido de estas funciones es que, contrario a las funciones de agregación (`avg()`, `sum()`, etc), las numéricas **si se pueden anidar** y combinarse con funciones de agregación, e incluso podemos anidar una numérica con una de agregación.

 1. `select avg(ln(o.freight)) from orders o`: el promedio de los logaritmos naturales de los fletes
 2. `select sin(pi()/2)`: seno de un ángulo de 90 grados
 3. el promedio de ticket por cliente de Northwind redondeado a 3 decimales:
 ```sql
select c.customer_id , round(cast(avg(od.quantity*unit_price) as numeric), 2)
from order_details od 
join orders o using (order_id)
join customers c using (customer_id)
group by c.customer_id
 ```
 4. _Z_ score (normalización estadística) a 2 decimales de los pagos de Sakila
 ```sql
 select (p.amount - avg(p.amount))/stddev(p.amount) from payment p
 ```
 Esto parece que no jala, verdad? _Common table expressions_ to the rescue!
 ```sql
 with stats_payments as (
	select avg(p.amount) as avg_amount, stddev(p.amount) as stddev_amount from payment p
 )
 select round((p.amount - sp.avg_amount)/sp.stddev_amount, 2) z_amount
 from stats_payments sp, payment p;
 ```
 > **Nota sobre `from stats_payments, payment`:** cuando tenemos este tipo de `from` sin `join`, lo único que hace SQL es una correspondencia simple renglón VS renglón, sin ninguna equivalencia, solo pone un result set al lado de otro.

## Generación de nums pseudoaleatorios

Para los matemáticos: no hay números completamente aleatorios generados por máquinas (salvo las quantum computers), todos tienen algún algoritmo que emula verdadera aleatoriedad.

Por tanto, si queremos usar números pseudoaleatorios para usos como criptografía, las funciones a continuación **are not the way to go**.

|Función| Qué hace? | Ejemplo | Resultado |
|-|-|-|-|
| `random()` | número pseudoaleatorio real entre 0.0 y 1.0: para otros números, combinar con `round()` y una multiplicación simple | `select random()` | **0.0969721257729077** |
| `setseed(`_double precision_`)` | establecer la "semilla" entre -1 y 1 para la generación de nums pseudoaleatorios | `select setseed(-0.5)` | **_sin valor de retorno_** |
| `generate_series(`_inicio_`,`_final_`,`_incremento_`)`| genera una tablita dinámica representando una serie, de _inicio_ a _final_ con un incremento entre ellas dada por _incremento_, donde _inicio_ y _final_ pueden ser `numeric`, `date` o `timestamp` | ` select * from generate_series('2020-01-01 00:00'::timestamp, '2020-12-31 23:59'::timestamp, '1 hour')` |

### Ejemplo: simular GDP

El GDP de los países que toman decisiones económicas moderadamente buenas se ve así:

![](https://dataschool.com/assets/images/learn-sql/extras/random-sequences/random-sequence-3.svg)

Obviamente aquí aparece la falacia del capitalismo, el hecho que la economía supone crecimiento infinito a lo largo del tiempo.

Supongamos que queremos simular una curva de GDP como la de arriba:

```sql
select fecha, (row_number() over()), round(((random() + 1) * (row_number() over()))::numeric, 2) as gdp
from generate_series('1939-01-01'::date, '2020-12-31'::date, '1 month') as fecha;
```
Qué está pasando aquí? Sigamos la ejecución:

1. `from`: se genera una serie que va de 1939 a 2020 con incrementos de 1 mes. **OJO: ESTA NO ES UNA SECUENCIA** como las conocemos; una secuencia es un objeto estructural de la BD, mientras que una serie es como una tabla.
2. no hay `where`, no hay `group by`, no hay `having`.
3. `select`: tenemos en el execution space la serie de fechas mes con mes de 1939 a 2020, ahora solo debemos recurrir a `random()` para generar datos aleatorios.
4. para qué sirve `row_number()` y `over()`? Para generar un consecutivo al vuelo para esta tablita dinámica a lo largo de todos los registros. Para qué queremos esto? Necesitamos ese consecutivo incremental para multiplicarlo por el resultado de `random()` y simular un comportamiento que tiene varianza a lo largo del tiempo, pero con una tendencia definitivamente creciente, como los GDPs (al menos a como lo esperan los economistas 🤷)

El resto de los ejemplos continúan la misma estructura.

### Ejemplo: simular casos COVID19

Los casos COVID tienen la siguiente forma:

![](https://dataschool.com/assets/images/learn-sql/extras/random-sequences/random-sequence-4.svg)

Podemos lograr este comportamiento con el siguiente query:

```sql
select fecha, (row_number() over()), (random() * exp(row_number() over())) as covid_cases
from generate_series('1939-01-01'::date, '2020-12-31'::date, '1 month') as fecha;
```

### Ejemplo: simular exponential decay

![](https://dataschool.com/assets/images/learn-sql/extras/random-sequences/random-sequence-5.svg)

```sql
select fecha, (row_number() over()), exp(-1 * ((random()) * (row_number() over()))) as covid_cases
from generate_series('1939-01-01'::date, '2020-12-31'::date, '1 month') as fecha;
```

### Ejemplo: simular crecimiento de cultivo de bacterias

![](https://dataschool.com/assets/images/learn-sql/extras/random-sequences/random-sequence-6.svg)

```sql
select fecha, (row_number() over()), log((random() + 1) * (row_number() over())) as covid_cases
from generate_series('1939-01-01'::date, '2020-12-31'::date, '1 month') as fecha;
```

### Ejemplo: generar 1000 correos electrónicos "aleatorios":

```sql
select
  'user_' || seq || '@' || (
    case (random() * 2)::integer
      when 0 then 'gmail'
      when 1 then 'hotmail'
      when 2 then 'yahoo'
    end
  ) || '.com' as email
from generate_series(1, 1000) seq;
```

Qué está pasando aquí?

1. `from`: se genera una tablita dinámica en memoria con una serie de 1 a 1000.
2. sin `where`, sin `group by`, sin `having`.
3. `select`: aprovechamos el operador `||`, que emula la función `concat()`, para juntar los strings `user_`, el valor de la tablita dinámica que va de 1 a 1000, el caracter `@` y lo que salga de la cláusula `case`, que vamos a explicar abajo:
4. el `case` [lo vimos ya anteriormente](https://github.com/xuxoramos/db-4-ds/blob/gh-pages/8_ejercicios.md#c%C3%B3mo-creamos-una-columna-en-customers-que-nos-diga-si-un-cliente-es-bueno-regular-o-malo), sirve como un `if...else if...else if...else`. En este caso, estamos obteniendo un número aleatorio entre 0 y 2, y como lo estamos _casteando_ a **integer**, con eso le **quitamos la parte decimal, dejando solo la entera**, y con eso hacemos comparaciones: si el num aleatorio es 0, entonces regresar `gmail`, si es 1 regresa `hotmail`, y si es 2 regresa `yahoo`.
5. Una vez terminada la cláusula `case`, continuamos concatenando ahora el sufijo `.com` a lo que haya salido del `case` y asignamos `email` como alias.

Qué obtenemos?

![](https://i.imgur.com/McgBeyX.png)

Ya posteriormente podemos pasarle este select a un `insert` para meter los 1000 correos de trancazo a la tabla:

```sql
insert into users(email)
select
  'user_' || seq || '@' || (
    case (random() * 2)::integer
      when 0 then 'gmail'
      when 1 then 'hotmail'
      when 2 then 'yahoo'
    end
  ) || '.com' as email
from generate_series(1, 1000) seq;
```

## Funciones con strings

| Función | Tipo de retorno | Qué hace? | Ejemplo(s) | Resultado |
|-|-|-|-|-|
| _string_` \|\| `_string_ | text | Concatenación de strings | `select 'Post' \|\| 'greSQL'` | **PostgreSQL** |
| `concat(`_string1_`,`_string2_`,`_..._`,`_stringN_`)` | text | Igual que `||`. Los `null` son ignorados. | `select concat('abcde', 2, null, 22)` | **abcde222** |
| `length(`_string_`)` | int | Número de caracteres en un string | `select length('PostgreSQL')` | **10** |
| `position(`_substring_` in `_string_`)` | int | Posición donde _substring_ comienza dentro de _string_. Esta función es _case sensitive_. | `select position('gre' in 'PostgreSQL')` | **5** |
| `substr(`_string_`,`_desde_`,`_cuántos_`)` | text | Extraer de _string_ comenzando por el caracter en la posición _desde_ hasta _cuántos_ posiciones después | `select substr('alphabet', 3, 2)` | **ph** |
| `trim([leading \| trailing \| both] [`_caracter a recortar_`] from `_string_`)` | text | Remover el mayor número de ocurrencias contínuas de _caracter a recortar_ (espacio en blanco si no se pone nada) del lado izquierdo (`leading`), derecho (`trailing`) o ambos (`both`), de la cadena _string_ | 1.`select trim(both 'X' from 'XXxMrDraKexXX')`\n2.`select trim(both from '   x   ')` | 1.**xMrDraKex**<br/>2.**x** |
| `upper(`_string_`)` | text | Pasar _string_ a todo mayúsculas | `select upper('no me grites')` | **NO ME GRITES** |
| `lower(`_string_`)` | text | Pasar _string_ a todo minúsculas | `select lower('NO ME GRITES')` | **no me grites** |
| `initcap(`_string_`)` | text | Pasar a mayúscula el 1er caracter de cada palabra separada por espacio en blanco | `select initcap('jesús salvador ramos cardona')` | **Jesús Salvador Ramos Cardona** |
| `lpad(`_string_`,`_longitud_`,[`_relleno_`])` | text | Rellenar el texto _string_ con el caracter _relleno_ hasta lograr un número de caracteres de _longitud_. Si _longitud_ es menor a los caracteres en _string_ entonces se trunca _string_ por la derecha  | 1.`select lpad('holamundo', 10, '_')`<br/>2.`select lpad('holamundo', 4, '_')` | 1.**\_holamundo**<br/>2.**hola** |
| `repeat(`_string o caracter a repetir_`,`_num de veces a repetir_`)` | text | Repetir _string_ por _num de veces_ | `select 'We''re up all night for good fun! ' \|\| repeat('We''re up all night to get lucky! ', 5)` | **Were up all night for good fun! Were up all night to get lucky! Were up all night to get lucky! Were up all night to get lucky! Were up all night to get lucky! Were up all night to get lucky!** |
| `replace(`_string_`,`_substring a reemplazar_`,`_reemplazo_`)` | text | Reemplazar todas las ocurrencias de _substring a reemplazar_ por _reemplazo_ dentro de _string_ | `select replace('abcdefabcdef', 'cd', 'XX')` | **abXXefabXXef** |
| `reverse(`_string_`)` | text | Reversar _string_ | `select reverse('Was it a car or a cat I saw?')` | **?was I tac a ro rac a ti saW** |
| `rpad(`_string_`,`_longitud_`,[`_relleno_`])` | text | El recíproco de `lpad`, excepto las reglas sobre truncado en caso de que _longitud_ sea mayor que la longitud de _string_, que son las mismas. | `select rpad('holamundo', 4, '_')` | **holamundo_** |
| `split_part(`_string_`,`_delimiter_`,`_num de substring_`)` | text | Partir _string_ cada _delimiter_ y retornar el substring separado con _num de substring_ | `select split_part('2020-12-12', '-', 2)`| **12** |
| `strpos(`_string_`,`_substring_`)` | int | Posición en donde _substring_ se encuentra dentro de _string_ | `select strpos('high', 'ig')` | **2** |
| `translate(`_string_`,`_from_`,`_to_`)` | text | Correspondencia de 1 a 1 entre _from_ y _to_, y luego reemplazo en _string_. | `select translate('Las actitudes son más importantes que las aptitudes', 'aeiou', 'eeeee')` | **Les ectetedes sen más empertentes qee les eptetedes** |


## Ejemplo integrador: Benford's Law

La Ley de Benford es una herramienta que podemos usar para detectar valores fraudulentos en una columna que represente dinero. La ley dice que:

> "En una colección de números provenientes de fenómenos reales, el primero dígito de dichos números tiende a ser pequeño: 1 el 30% de las veces, mientras que el 9 aparecerá solo el 5% de las veces."

Esto significa que si alguna columna que represente dinero no cumple con las propiedades de arriba, probablemente estemos ante un caso de datos fabricados.

En cualquier lenguaje de programación, verificar esta propiedad lleva 2 pasos:

1. La distribución de la columna numérica de interés sigue una distribución log-normal.

![](https://miro.medium.com/max/4200/0*OeCKcqoQ5iB0fqiT.png)

2. Obtener el 1er dígito de todos los valores de la columna en cuestión y verificar que el 1 aparezca ~30% de las veces mediante un histograma

Lo primero que debemos hacer es instalar la función `histogram(`_tabla_`,`_campo numérico_`)` de [aquí](https://faraday.ai/blog/how-to-do-histograms-in-postgresql/)

Luego vamos a obtener el histograma de todos los `unit_price * quantity` de todos los registros de `order_details`:

```sql
select * from histogram('order_details', 'unit_price * quantity');
```

![](https://i.imgur.com/6zXsJO6.png)

Como podemos ver, al menos estamos cumpliendo con la 1er propiedad, que la distribución de los datos de la columna se ajuste a una lognormal.

Verifiquemos ahora la 2a propiedad:

```sql
select substr((od.unit_price * od.quantity)::text, 1, 1) as primer_digito, count(*)
from order_details od 
group by primer_digito
order by primer_digito;
```

Qué estamos haciendo aquí?

1. estamos cargando `order_details` en nuestro execution space
2. `group by primer_digito` agrupamos por cada 1er dígito encontrado
3. `order by primer_digito` ordenamos por ese 1er dígito encontrado
4. seleccionamos la multiplicación de `unit_price * quantity`, luego la _casteamos_ a tipo `text` y obtenmemos el 1er caracter de cada resultado
5. contamos estos renglones

Ahora resta verificar si los números que comienzan con el dígito `1` componen ~30% de todos los primeros dígitos:

```sql
with benford_freqs as (
	select substr((od.unit_price * od.quantity)::text, 1, 1) as primer_digito, count(*) as freq
	from order_details od 
	group by primer_digito
	order by primer_digito
),
benford_totals as (
	select sum(freq) as tot from benford_freqs 
)
select bf.primer_digito , bf.freq, round((bf.freq/bt.tot) * 100, 2)
from benford_freqs bf, benford_totals bt;
```

![](https://i.imgur.com/dqWoRps.png)

Con una proporción de **~28%**, podemos decir que las órdenes de la BD de Northwind no son fabricadas y si son reales.

...

...

...

No lo son, pero le echaron ganas :)

![](https://i.kym-cdn.com/entries/icons/facebook/000/028/021/work.jpg)

## Funciones y operadores con `date` y variantes

### Operadores con `date`

Para saber cómo realizar operaciones y las funciones que actúan sobre fechas, debemos definir 3 tipos de dato en PostgreSQL:

1. `date`: fecha, sin hora
2. `time`: hora, sin fecha
3. `timestamp`: fecha + hora
4. `interval`: una duración entre 2 `time` (en horas), `date` (en días), o `timestamp` (en días u horas)

Ahora si, primero los operadores:

| Operador | Ejemplo | Resultado | Explicación |
|-|-|-|-|
| + | `select '2001-09-28'::date + 7` | **2001-10-05** | 1) Conversión de `string` a `date`, 2) suma de `7` (por default, y si no se especifican qué son esos `7`, serán `days`).
| + | `select '2001-09-28'::date + '1 hour'::interval` | **2001-09-28 01:00:00** | 1) Conversión de `string` a `date`, 2) convertir la cadena `1 hour` en tipo `interval`, 3) sumarle 1h a un `date` convierte ese `date` a `timestamp`.
| + | `select '2001-09-28'::date + '03:00'::time` | **2001-09-28 03:00:00** | 1) Conversión de `string` a `date`, 2) conversión de la cadena `3:00` en `time`, 3) suma de `3:00` como `time` a `date`, convirtiéndolo en `timestamp`
| + | `select '1 day'::interval + '1 hour'::interval` | **1 day 01:00:00** | Conversión de strings a `interval` y suma de ambos
| + | `select '2001-09-28 01:00'::timestamp + '23 hours'::interval` | **2001-09-29 00:00:00** | Suma de un `interval` de 23h a un `timestamp` de un día a la 1am, lo cual da como resultado de un timestamp del siguiente día a las 00h
| + | `select '01:00'::time + '3 hours'::interval` | **04:00:00** | Suma de un `interval` de 3h a un `time` de 1am, dando como resultado las 4am.
| - | `select  -'23 hours'::interval` | **-23:00:00** | Creamos un intervalo de 23h contrario al flujo del tiempo.
| - | `select (('2000-10-01'::date - '2001-09-28'::date) \|\| 'days')::interval` | **3** | Restar _fecha final_ menos _fecha inicial_, resultando en un `interval` de 3 días. Si invertimos las fechas para que sea _fecha inicial_ menos _fecha final_, el `interval` resulta negativo, es decir, un intervalo que va contrario al flujo del tiempo.
| - | `select '2001-10-01'::date - 7` | **2001-09-24** | Resta del numérico `7` de una fecha X, resultando en un "go back in time"
| - | `select '2001-09-28'::date - '1 hour'::interval` | **2001-09-27 23:00:00** | Recuerden que todos los `date`, al instanciarlos, tienen por default las 00h, por lo que al restarle 1h, nos regresamos a la noche anterior, a las 11pm.
| - | `select '05:00'::time - '03:00'::time` | **02:00:00** | Las 5am menos las 2am resultan en un `interval` de 2h.
| - | `select '05:00'::time - '2 hours'::interval` | **03:00:00** | Las 5am menos un `interval` de 2h nos da las 3am.
| - | `select '2001-09-28 23:00'::timestamp - '23 hours'::interval` | **2001-09-28 00:00:00** | Una `timestamp` de una fecha X a las 11pm menos un intervalo de las 11pm
| - | `select '1 day'::interval - '1 hour'::interval` | **1 day -01:00:00** | Creamos un intervalo conjunto de +1 `day` y -1 `hour`. Si sumáramos esto a `2020-01-01`, resultaría en un `timestamp` de `2020-01-01 23:00:00`
| - | `select '2001-09-29 03:00'::timestamp - '2001-09-27 12:00'::timestamp` | **1 day 15:00:00** | Restar _timestamp final_ menos _timestamp inicial_ resulta en un intervalo de días y una fracción expresada en horas.
| * | `select 900 * '1 second'::interval` | **00:15:00** | 900 como entero multiplicado por un `interval` de 1 seg resulta en 900 segundos, o 15 min.
| * | `select 21 * '1 day':interval` | **21 days** | 21 como entero * `1 day` como `interval` es un `interval` de 21 días.
| * | `select 3.5 * '1 hour'::interval` | **03:30:00** | 3.5 horas == `03:30:00`
| / | `select '1 hour'::interval / 1.5` | **00:40:00** | 60 min / 1.5 (float) = 40 min

### Funciones con `date`

| Funcóon | Tipo de retorno | Qué hace? | Ejemplo | Resultado |
|-|-|-|-|-|
| `age(`_timestamp final_`,`_timestamp inicinal_`)` | `interval` | Expresa un `interval` en forma _human-readable_, como se expresaría una edad, restando _timestamp inicial_ de _timestamp final_; los resultados se vuelven negativos si se invierten los argumentos. | `select age('2001-04-10'::timestamp, '1957-06-13'::timestamp)` | **43 years 9 mons 27 days** |
| `age(`_timestamp_`)` | `interval` | Mismo que el anterior, excepto que el _timestamp final_ es `now()` a las 00h. | `select age('1957-06-13 00:00:00'::timestamp)` | **63 years 9 mons 22 days** (now() = 2021-04-05 23:45:00) |
| `current_date` (constante, no función) | `date` | Fecha actual |   |   |
| `current_time` (constante, no función) | `time` con zona horaria | Hora actual |   |   |
| `current_timestamp` (constante, no función) | `timestamp` con zona horaria | Fecha con hora actual |   |   |
| `date_part(['hour'\|'minute'\|'year'\|'day'\|'month'],`_timestamp_`)` o bien `extract(['hour'\|'minute'\|'year'\|'day'] from `_timestamp_`)` | `double precision` | Obtener una parte (hora, minuto, año, mes, día) de _timestamp_. | `select date_part('hour', '2001-02-16 20:38:40'::timestamp)` | **20** |
| `date_part(['hour'\|'minute'\|'year'\|'day'\|'month'],`_interval_`)` o bien `extract(['hour'\|'minute'\|'year'\|'day'\|'month'] from `_interval_`)` | double precision | Obtener | `select extract('hour' from '40 days 3 months 2 hour'::interval)`  | **3** |
| `date_trunc(['hour'\|'minute'\|'year'\|'day'\|'month'],`_timestamp_`)` | timestamp | Truncar _timestamp_ hasta la precisión dada. | `select date_trunc('hour', '2001-02-16 20:38:40'::timestamp)` | **2001-02-16 20:00:00** |


### Tarea 1

Una aplicación frecuente de Ciencia de Datos aplicada a la industria del microlending es el de calificaciones crediticias (credit scoring). Puede interpretarse de muchas formas: propensión a pago, probabilidad de default, etc. La intuición nos dice que las variables más importantes son el saldo o monto del crédito, y la puntualidad del pago; sin embargo, otra variable que frecuentemente escapa a los analistas es el tiempo entre cada pago. La puntualidad es una pésima variable para anticipar default o inferir capacidad de pago de micropréstamos, por su misma naturaleza. Si deseamos examinar la viabilidad de un producto de crédito para nuestras videorental stores:

1. Cuál es el promedio, en formato human-readable, de tiempo entre cada pago por cliente de la BD Sakila?
2. Sigue una distribución normal?
3. Qué tanto difiere ese promedio del tiempo entre rentas por cliente?

Fecha de entrega: Viernes 9 de Abril, antes de las 23:59:59
Valor: 1 puntos sobre el final
Medio de entrega: su propio repositorio de Github

### Tarea 2

Como parte de la modernización de nuestras video rental stores, vamos a automatizar la recepción y entrega de discos con robots.

[![Brazo robótico manejando storage](http://img.youtube.com/vi/CVN93H6EuAU/0.jpg)](http://www.youtube.com/watch?v=CVN93H6EuAU "Brazo robótico manejando storage")

Parte de la infraestructura es diseñar contenedores cilíndricos giratorios para facilitar la colocación y extracción de discos por brazos automatizados. Cada cajita de Blu-Ray mide 20cm x 13.5cm x 1.5cm, y para que el brazo pueda manipular adecuadamente cada cajita, debe estar contenida dentro de un arnés que cambia las medidas a 30cm x 21cm x 8cm para un espacio total de 5040 centímetros cúbicos y un peso de 500 gr por película.

Se nos ha encargado formular la medida de dichos cilindros de manera tal que quepan todas las copias de los Blu-Rays de cada uno de nuestros stores. Las medidas deben ser estándar, es decir, la misma para todas nuestras stores, y en cada store pueden ser instalados más de 1 de estos cilindros. Cada cilindro aguanta un peso máximo de 50kg como máximo. El volúmen de un cilindro se calcula de [ésta forma.](volume of a cylinder)

Esto no se resuelve con 1 solo query. El problema se debe partir en varios cachos y deben resolver cada uno con SQL.

La información que no esté dada por el enunciado del problema o el contenido de la BD, podrá ser establecida como supuestos o assumptions, pero deben ser razonables para el problem domain que estamos tratando.

Fecha de entrega: Viernes 9 de Abril, antes de las 23:59:59
Valor: 2 punto sobre el final
Medio de entrega: su propio repositorio de Github
