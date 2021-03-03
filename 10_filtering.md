# Filtrado - cláusula `WHERE`

Recordemos la estructura del comando `select`:

| nombre de la cláusula | Propósito |  
|-|-|
| `select` _columna1, columna2,...,columna_n_ | Determina las columnas, objetos o columnas transformadas con funciones, que incluiremos en este espacio de ejecución |  
| `from` _tabla1 [join tabla2 on (llave copiada)]_| Determina las tablas a las que pertenecen las columnas que _seleccionamos_ arriba |  
| `where` _condición booleana_ | Filtra renglones no deseados para efectos de la consulta |  
| `group by` _campo a agrupar_| Agrupa y agrega valores utilizando columnas que tengan la misma data |
| `having` _condición booleana_ |  Filtra grupos no deseados para el objetivo de nuestra consulta |
| `order by` _campo de ordenamiento [asc/desc]_ |  Ordena de forma `asc` y `desc` los resultados de la consulta |

Ya hemos visto una probadita del `select`, lo que podemos **sacar** de la BD. Hasta ahora hemos visto solamente columnas de tablas, pero posterior a esta sesión veremos funciones para transformar el contenido de las columnas.

También hemos visto ya a detalle el `from` con la cláusula `join`, que es con lo que armamos el set de datos de los cuales sacaremos columnas con `select`.

Ahora desmenuzaremos el `where`, que es donde definiremos qué renglones nos traeremos para nuestra consulta.

## Lógica booleana

La base del `where` es la combinación de expresiones conectadas por operadores booleanos `or`, `and`, `not` y otras funciones auxiliares. Primero, para los que no conocen boolean logic:

### Operador `or`
| Expresión            | Resultado |
|----------------------|-----------|
| where TRUE or TRUE   | TRUE      |
| where TRUE or FALSE  | TRUE      |
| where FALSE or TRUE  | TRUE      |
| where FALSE or FALSE | FALSE     |

### Operador `and` y `or`
| Expresión                        | Resultado |
|----------------------------------|-----------|
| where (TRUE or TRUE) and TRUE    | TRUE      |
| where (TRUE or FALSE) and TRUE   | TRUE      |
| where (FALSE or TRUE) and TRUE   | TRUE      |
| where (FALSE or FALSE) and TRUE  | FALSE     |
| where (TRUE or TRUE) and FALSE   | FALSE     |
| where (TRUE or FALSE) and FALSE  | FALSE     |
| where (FALSE or TRUE) and FALSE  | FALSE     |
| where (FALSE or FALSE) and FALSE | FALSE     |

### Operador `and`, `or` y `not`
| Expresión                            | Resultado |
|--------------------------------------|-----------|
| where not (TRUE or TRUE) and TRUE    | FALSE     |
| where not (TRUE or FALSE) and TRUE   | FALSE     |
| where not (FALSE or TRUE) and TRUE   | FALSE     |
| where not (FALSE or FALSE) and TRUE  | TRUE      |
| where not (TRUE or TRUE) or FALSE   | TRUE      |
| where not (TRUE or FALSE) or FALSE  | TRUE      |
| where not (FALSE or TRUE) or FALSE  | TRUE      |
| where not (FALSE or FALSE) or FALSE | TRUE      |

### Representaciones visuales de operadores lógicos (pa que quede claro)

Con calabazas:
![](https://cdn-blog.adafruit.com/uploads/2020/10/ElGY4auUUAMS6f4.png)

O con facial hair:
![](https://recruitingtools.com/wp-content/uploads/sites/2/2016/05/tumblr_o37frctj7M1uuf4n4o1_1280.jpg)

## Tipos de condiciones

### Igualdad 
Son las condiciones dadas con `=`, `>`, `<` y sus combinaciones `>=`, `<=`. Ojo que podemos combinar los operadores `and`, `or` y `not` junto con los de igualdad par hacer igualdades más complejas, como:

`select r.return_date from rental r where r.rental_date >= '2005-01-01' and r.rental_date <= '2005-12-31'` para las rentas de todo 2005.

#### Una nota sobre como trata PostgreSQL las fechas 'YYYY-mm-dd'

PostgreSQL tiene un default de formato de fecha de 'YYYY-mm-dd' (la 'm' y la 'd' minúsculas implica que mes y día estan dados por número y no por nombres), por lo que queries como el anterior, pueden interpretarse como tal sin ninguna transformación (que veremos después).

Cuando el query se hace con estos strings de fecha, pero el campo subyacente es `timestamp` en lugar de `date`, entonces tiene una parte de hora, como la que se ve a continuación:

![](https://i.imgur.com/ibYi6pJ.png)

En este caso, la cláusula `...where r.rental_date >= '2005-01-01' and r.rental_date <= '2005-12-31'` se le anexa de forma subyacente el default de la parte de hora `00:00:00` sin que lo sepamos, de forma que lo que llega al PostgreSQL es `...where r.rental_date >= '2005-01-01 00:00:00' and r.rental_date <= '2005-12-31 00:00:00'`.

Esto tiene la implicación que una cláusula de igualdad como `where r.rental_date = '2005-01-01'` rara vez va a ser true, a menos que tengamos un registro cuyo `rental_date` sea efectivamente `2005-01-01 00:00:00`. Es por ello que cuando tratamos fechas, generalmente son con operadores `<` o `>` y sus variantes.

### Desigualdad
Podemos hacerlo con `!=` o con `<>`, e igual podemos combinarlos con los operadores lógicos de arriba para condiciones más complejas. Por ejemplo, el query 

`select fa.actor_id where film_actor.actor_id != 1`

puede refrasearse como `where film_actor.actor_id <> 1`

y ambos tendrían el mismo resultado.

### Inclusión

Hay 2 formas de inclusión:

#### Lista

`select film.title from film where film.title in ('ACADEMY DINOSAUR', 'AFRICAN EGG', 'AGENT TRUMAN');`

Que también está sujeta a los operadores lógicos principales, de forma que podemos expresar:

`select film.title from film where film.title not in ('ACADEMY DINOSAUR'film.title = 'ACADEMY DINOSAUR'film.title = 'ACADEMY DINOSAUR', 'AFRICAN EGG', 'AGENT TRUMAN') and film.rating in ('PG', 'PG-13');`

El statement de arriba es idéntico a:

`select film.title from film where film.title = 'ACADEMY DINOSAUR' or film.title = 'AFRICAN EGG' or film.title = 'AGENT TRUMAN'`

##### Una nota sobre `enum`
El campo `film.rating` es de tipo `enum`. Qué es un enum?

Un `enum` en SQL (y en otros lenguajes de programación) es un tipo de dato, como lo es `numeric`, o `date` o `varchar`. Consiste en un pequeño diccionario `key=value` cuya posición indica "graduación" o niveles.

Consideren los siguientes statements:

```
CREATE TYPE mood AS ENUM ('depressive', 'sad', 'ok', 'happy', 'exhilarated');

CREATE TABLE person (
    name text,
    current_mood mood
);

INSERT INTO person VALUES ('Moe', 'happy');
```
Lo que está pasando aquí es que estamos creando el enum llamado `mood` y luego lo estamos usando en la tabla `person` con el campo `current_mood`, **precisamente de tipo `mood`**, y finalmente estamos insertando la persona llamada "Moe" cuyo "nivel" de `mood` es `happy`.

La ventaja principal de un `enum` es que pueden representar ordenamiento o niveles, de forma que podemos tener un query como este:

`select p.name from person p where current_mood >= 'ok';`

Que es algo que dificilmente se podría si en lugar de un `enum` fuera una tabla, a la que de todos modos tendríamos que agregar un campo que represente **el valor numérico de `happy`, `sad`, etc**.

Finalmente, aparte de niveles y ordenamiento, los enums nos sirven para constreñir los tipos de contenidos que un campo puede admitir, en lugar de dejar abierto y arriesgarnos a, por ejemplo, faltas de ortografía, faltas de estandarización, o inconsistencias.

Pueden usar `enum` en lugar de una tabla en sus diseños de BD si un campo requiere ordenamiento y niveles.

#### Rango

Recuerdan el query del inicio que usamos `>=` y `<=`? Podemos hacer lo mismo con rangos usando cláusula `between`:

`select r.rental_date from rental r where r.rental_date between '2005-01-01' and '2005-12-31';`

Ojo con las siguientes condiciones para el `between`:
1. orden de los umbrales de `between`: inferior priemro, superior segundo, de lo contrario no te va a regresar nada, porque obviamente el tiempo no corre al revés.
2. es un intervalo cerrado, por lo tanto `X between A and B` representa [A, B] y no (A, B).
3. el `between` forzosamente es acompañado por `and` para poder formar el intervalo correctamente. No tiene sentido, y ni va a funcionar algo como `X between A or B`.

#### Caso especial `between` con campos `varchar`

El operador `between` usado en textos es como una búsqueda alfabética caracter por caracter. El query 

`select f.title from film f where f.title between 'AA' and 'AZ';` 

va a listar todos los nombres de películas que comiencen con A y cuya 2a letra del título vaya de la A a la Z.

No es la mejor manera de buscar strings. Para la mejor manera, mejor usar Matching (ver abajo).

### Matching

Esto se usa con campos `varchar` y forzosamente con la cláusula `like`. Aquí tenemos 2 formas de hacer este match:

- **`like '%OLI%'`**: matching de cualesquiera N caracteres, incluyendo whitespace, caracter de inicio de línea (^), final de línea ($) o nueva línea (\n o \r). Esto va a matchear _POLICIA_, _HOLI_, _POLITICA_ (así sin acento), _COLITA_, etc. Es **case sensitive** y **tilde sensitive**.
- **`like 'POL_TIC_'`**: matching de 1 solo cualquier caracter, incluyendo whitespace, inicio de línea (^) y final de línea ($). Esto va matchear _POLITICA_, _POLÍTICA_, _POLÍTICO_, _POLATICA_ (whatever that means), etc.

Igual podemos combinarlos:

- **`like 'POL_TI%'`**: esto va a matchear _POLÍTICA_, _POLITIQUERÍA_, _POLOTITLÁN_, etc.
- **`like '%PUEST_'`**: esto va a matchear _IMPUESTO_, _COMPUESTA_, _APUESTO_, _INTERPUESTA_, etc.

### Manejando `null`

Expliquémoslo rápido con un meme

![](https://imgur.com/EBFDYfu.png)

Queda claro, no?

`...where rental.return_date = null` **no va a tronar**, pero **tampoco** te va a regresar lo que esperas.

`where rental.return_date is null` o `...is not null` es la forma correcta.


#### Nota sobre expresiones regulares

Las expresiones regulares son formas sofisticadas de matching de strings. Es un tema complejo y difícilmente lo usarán en la vida real, así que dejamos como ejercicio al lector que se familiaricen con ellas. **No aparecerán en ninguna evaluación y además probablemente no será necesario usarlas en el proyecto final**.

Ver un tutorial [aquí](https://www.regular-expressions.info/postgresql.html).

## Ejercicios:

Usando la BD de Sakila:

### Cuales pagos no son del cliente con ID 5, y cuyo monto sea mayor a 8 o cuya fecha sea 23 de Agosto de 2005?
```
select p.customer_id , p.payment_date, p.amount 
from payment p  
where p.customer_id <> 5 and (p.amount > 8 or p.payment_date = '2005-08-23');
```
Este query tiene la particularidad de que el predicado `p.payment_date = '2005-08-23'` probalemente va a ser `FALSE` porque recuerden que a bajo nivel, esta comparación es realmente `p.payment_date = '2005-08-23 00:00:00'` debido a que el campo `payment_date` es de tipo `timestamp`, es decir, fecha + hora, y es poco probable que un registro se haya insertado **exactamente** a las 00h.

### Cuales pagos son del cliente con ID 5 y cuyo monto no sea mayor a 6 y su fecha tampoco sea del 19 de Junio de 2005?
```
select p.customer_id , p.payment_date, p.amount 
from payment p
where p.customer_id = 5 and not (p.amount > 6 or p.payment_date = '2005-06-19');
```
Qué sucede si desagrupamos los últimos 2 predicados y dejamos la cláusula como `...where p.customer_id = 5 and not p.amount > 6 or p.payment_date = '2005-06-19'`?

A falta de agrupación, como en todos los lenguajes de programación, la evaluación se hace **de izquierda a derecha**, por lo que el operador `not` afectaría solo al predicado `p.amount > 6` y no a todo el grupo.

### Cuales pagos tienen el monto 1.98, 7.98 o 9.98?
```
select p.payment_id , p.amount from payment p where p.amount in (1.98, 7.98, 9.98)
```

### Cuales la suma total pagada por los clientes que tienen una letra A en la segunda posición de su apellido y una W en cualquier lugar después de la A?
```
select c.last_name , sum(p.amount) 
from payment p join customer c using (customer_id)
where c.last_name like '_A%W%' group by c.customer_id
```
Opcionalmente, podemos no agrupar por `c.customer_id` y sumar todos los clientes.

## Tarea

En cualquier esquema de su instalación de PostgreSQL, creen la siguiente tabla:

| nombre               | email                                                              |
|----------------------|--------------------------------------------------------------------|
| Wanda Maximoff       | wanda.maximoff@avengers.org                                        |
| Pietro Maximoff      | pietro@mail.sokovia.ru                                             |
| Erik Lensherr        | fuck_you_charles@brotherhood.of.evil.mutants.space                 |
| Charles Xavier       | i.am.secretely.filled.with.hubris@xavier-school-4-gifted-youngste. |
| Anthony Edward Stark | iamironman@avengers.gov                                            |
| Steve Rogers         | americas_ass@anti_avengers                                         |
| The Vision           | vis@westview.sword.gov                                             |
| Clint Barton         | bul@lse.ye                                                         |
| Natasja Romanov      | blackwidow@kgb.ru                                                  |
| Thor                 | god_of_thunder-^_^@royalty.asgard.gov                              |
| Logan                | wolverine@cyclops_is_a_jerk.com                                    |
| Ororo Monroe         | ororo@weather.co                                                   |
| Scott Summers        | o@x                                                                |
| Nathan Summers       | cable@xfact.or                                                     |
| Groot                | iamgroot@asgardiansofthegalaxyledbythor.quillsux                   |
| Nebula               | idonthaveelektras@complex.thanos                                   |
| Gamora               | thefiercestwomaninthegalaxy@thanos.                                |
| Rocket               | shhhhhhhh@darknet.ru                                               |

Construyan un query que regrese emails inválidos.
