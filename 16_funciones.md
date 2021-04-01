# Funciones

Una función toma un input y saca un output.

Dicho output puede ser luego usado en un `select`, en un `where` o en un `group by`.

Pueden actuar sobre strings (o campos `varchar`), numéricos (campos `integer`, `numeric`, `bigint`, etc), fechas (`date`, `timestamp`, etc) o booleanos (operadores `not`, `or`, `and` y de igualdades `<`, `>`, `=`).

Una función que recibe un tipo de dato o columna, puede regresar otro tipo de dato totalmente diferente.

## Booleanos

Ya los vimos, pero repasemos algunos:

- `a between x and y` es idéntico a `a >= x and a <= y`
- `a not between x and y` es idéntico a `a < x or a > y`
- Recuerden que el `not` convierte los `and` en `or` y los `>` en `<=` y viceversa

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
| sign(dp or numeric) |  sign of the argument (-1, 0, +1) | sign(-8.4) | -1 |
| sqrt(dp or numeric) |  square root | sqrt(2.0) | 1.4142135623731 |
| trunc(dp or numeric) |  truncate toward zero | trunc(42.8) | 42 |
| trunc(v numeric, s int) | truncate to s decimal places | trunc(42.4382, 2) | 42.43 |

Lo chido de estas funciones es que, contrario a las funciones de agregación (`avg()`, `sum()`, etc), las numéricas **si se pueden anidar**.

Veamos la Identidad de Euler:

```
select exp(pi()) + 1

## De conversión

- `cast(`_columna_` as `_nuevo tipo de dato_`)`

