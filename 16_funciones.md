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

|Función| Qué hace? | Ejemplo | Result |
|-|-|-|-|
| `abs(`_numeric_`)` |  valor absoluto | `select abs(-17.4)` | 17.4 |
| `ceil(`_numeric_`)` |  nearest integer greater than or equal to argument | ceil(-42.8) | -42 |
| div(y numeric, x numeric) |  integer quotient of y/x | div(9,4) | 2 |
| exp(dp or numeric) |  exponential | exp(1.0) | 2.71828182845905 |
| floor(dp or numeric) |  nearest integer less than or equal to argument | floor(-42.8) | -43 |
| ln(dp or numeric) |  natural logarithm | ln(2.0) | 0.693147180559945 |
| log(dp or numeric) |  base 10 logarithm | log(100.0) | 2 |
| log(b numeric, x numeric) | logarithm to base b | log(2.0, 64.0) | 6.0000000000 |
| mod(y, x) |  remainder of y/x | mod(9,4) | 1 |
| pi() |  "π" constant | pi() | 3.14159265358979 |
| power(a numeric, b numeric) |  a raised to the power of b | power(9.0, 3.0) | 729 |
| round(dp or numeric) |  round to nearest integer | round(42.4) | 42 |
| round(v numeric, s int) |  round to s decimal places | round(42.4382, 2) | 42.44 |
| sign(dp or numeric) |  sign of the argument (-1, 0, +1) | sign(-8.4) | -1 |
| sqrt(dp or numeric) |  square root | sqrt(2.0) | 1.4142135623731 |
| trunc(dp or numeric) |  truncate toward zero | trunc(42.8) | 42 |
| trunc(v numeric, s int) | truncate to s decimal places | trunc(42.4382, 2) | 42.43 |

## De conversión

- `cast(`_columna_` as `_nuevo tipo de dato_`)`

