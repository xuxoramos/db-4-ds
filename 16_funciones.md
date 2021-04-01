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

| Return Type | Description | Example | Result |  |
|-|-|-|-|-|
| abs(x) | (same as input) | absolute value | abs(-17.4) | 17.4 |
| cbrt(dp) | dp | cube root | cbrt(27.0) | 3 |
| ceil(dp or numeric) | (same as input) | nearest integer greater than or equal to argument | ceil(-42.8) | -42 |
| ceiling(dp or numeric) | (same as input) | nearest integer greater than or equal to argument (same as ceil) | ceiling(-95.3) | -95 |
| degrees(dp) | dp | radians to degrees | degrees(0.5) | 28.6478897565412 |
| div(y numeric, x numeric) | numeric | integer quotient of y/x | div(9,4) | 2 |
| exp(dp or numeric) | (same as input) | exponential | exp(1.0) | 2.71828182845905 |
| floor(dp or numeric) | (same as input) | nearest integer less than or equal to argument | floor(-42.8) | -43 |
| ln(dp or numeric) | (same as input) | natural logarithm | ln(2.0) | 0.693147180559945 |
| log(dp or numeric) | (same as input) | base 10 logarithm | log(100.0) | 2 |
| log(b numeric, x numeric) | numeric | logarithm to base b | log(2.0, 64.0) | 6.0000000000 |
| mod(y, x) | (same as argument types) | remainder of y/x | mod(9,4) | 1 |
| pi() | dp | "π" constant | pi() | 3.14159265358979 |
| power(a dp, b dp) | dp | a raised to the power of b | power(9.0, 3.0) | 729 |
| power(a numeric, b numeric) | numeric | a raised to the power of b | power(9.0, 3.0) | 729 |
| radians(dp) | dp | degrees to radians | radians(45.0) | 0.785398163397448 |
| round(dp or numeric) | (same as input) | round to nearest integer | round(42.4) | 42 |
| round(v numeric, s int) | numeric | round to s decimal places | round(42.4382, 2) | 42.44 |
| sign(dp or numeric) | (same as input) | sign of the argument (-1, 0, +1) | sign(-8.4) | -1 |
| sqrt(dp or numeric) | (same as input) | square root | sqrt(2.0) | 1.4142135623731 |
| trunc(dp or numeric) | (same as input) | truncate toward zero | trunc(42.8) | 42 |
| trunc(v numeric, s int) | numeric | truncate to s decimal places | trunc(42.4382, 2) | 42.43 |
| width_bucket(op numeric, b1 numeric, b2 numeric, count int) | int | return the bucket to which operand would be assigned in an equidepth histogram with count buckets, in the range b1 to b2 | width_bucket(5.35, 0.024, 10.06, 5) | 3 |
| width_bucket(op dp, b1 dp, b2 dp, count int) | int | return the bucket to which operand would be assigned in an equidepth histogram with count buckets, in the range b1 to b2 | width_bucket(5.35, 0.024, 10.06, 5) | 3 |

## De conversión

- `cast(`_columna_` as `_nuevo tipo de dato_`)`

