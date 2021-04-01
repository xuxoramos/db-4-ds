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
| `pi()` |  constante "π" | `select pi()` | **3.14159265358979** |
| `power(`_a_`,`_b_`)` |  _a_ elevado a la _b_ potencia | `select power(9, 3)` | **729** |
| `round(`_numérico_`)` |  redondeo al entero más cercano: del 1 al 4 redondea hacia abajo, y del 5 al 9 redondea hacia arriba | `select round(42.4)` | **42** |
| `round(`_a_`,`_b_`)` |  redondeo de _a_ a _b_ posiciones decimales | `select round(42.4382, 2)` | **42.44** |
| `sign(`_a_`)` |  signo de _a_ (-1, 0, +1) | `select sign(-8.4)` | **-1** |
| `sqrt(`_numérico_`)` |  raíz cuadrada | `select sqrt(2)` | **1.4142135623731** |
| `trunc(`_numérico_`)` |  truncar la parte decimal | `select trunc(42.8)` | **42** |
| `sin(`_numérico_`)` | seno trigonométrico | `select sin(45)` | **0.8509035245341184** |
| `cos(`_numérico_`)` | coseno trigonométrico | `select cos(45)` | **0.5253219888177297** |
| `tan(`_numérico_`)` | truncar _a_ por _b_ posiciones decimales | `select trunc(42.4382, 2)` | **42.43** |
| `cot(`_numérico_`)` | truncar _a_ por _b_ posiciones decimales | `select trunc(42.4382, 2)` | **42.43** |

### Generación de nums pseudoaleatorios

Para los matemáticos: no hay números completamente aleatorios generados por máquinas (salvo las quantum computers), todos tienen algún algoritmo que emula verdadera aleatoriedad.

Por tanto, si queremos usar números pseudoaleatorios para usos como criptografía, las funciones a continuación **are not the way to go**.

|Función| Qué hace? | Ejemplo | Resultado |
|-|-|-|-|
| `random()` | número pseudoaleatorio real entre 0.0 y 1.0: para otros números, combinar con `round()` y una multiplicación simple | `select random()` | **0.0969721257729077** |
| `setseed(`_double precision_`)` | establecer la "semilla" entre -1 y 1 para la generación de nums pseudoaleatorios | `select setseed(-0.5)` | **_sin valor de retorno_** |

### Ejemplos

Lo chido de estas funciones es que, contrario a las funciones de agregación (`avg()`, `sum()`, etc), las numéricas **si se pueden anidar**, e incluso podemos anidar una numérica con una de agregación.


```
select exp(pi()) + 1
``` 

## De conversión

- `cast(`_columna_` as `_nuevo tipo de dato_`)`

