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

## Tipos de condiciones

### Igualdad 
Son las condiciones dadas con `=`, `>`, `<` y sus combinaciones `>=`, `<=`. Ojo que podemos combinar los operadores `and`, `or` y `not` junto con los de igualdad par hacer igualdades más complejas, como:

`select r.return_date from rental r where r.rental_date >= '2005-01-01' and <= '2005-12-31'` para las rentas de todo 2005.

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

`select film.title from film where film.title not in ('ACADEMY DINOSAUR', 'AFRICAN EGG', 'AGENT TRUMAN') and film.rating in ('PG', 'PG13');`

#### Rango

Recuerdan el query del inicio que usamos `>=` y `<=`? Podemos hacer lo mismo con rangos usando cláusula `between`:

`select r.rental_date from rental r where r.rental_date between '2005-01-01' and '2005-12-31';`

Ojo con el orden de los umbrales de `between`, inferior priemro, superior segundo. De lo contrario no te va a regresar nada, porque obviamente el tiempo no corre al revés, esto no es Back to the Future.

#### Caso especial `between` con campos `varchar`

El operador `between` usado en textos es como una búsqueda alfabética caracter por caracter. El query 

`select f.title from film f where f.title between 'AA' and 'AZ';` 

va a listar todos los nombres de películas que comiencen con A y cuya 2a letra del título vaya de la A a la Z.

### Matching

Esto se usa con campos `varchar` y forzosamente con la cláusula `like`. Aquí tenemos 2 formas de hacer este match:

- **`like '%OLI%'`**: matching de cualesquiera N caracteres, incluyendo whitespace, caracter de inicio de línea (^), final de línea ($) o nueva línea (\n o \r). Esto va a matchear _POLICIA_, _HOLI_, _POLITICA_ (así sin acento), _COLITA_, etc. Es **case sensitive** y **tilde sensitive**.
- **`like 'POL_TIC_'`**: matching de 1 solo cualquier caracter, incluyendo whitespace, inicio de línea (^) y final de línea ($). Esto va matchear _POLITICA_, _POLÍTICA_, _POLÍTICO_, _POLATICA_ (whatever that means), etc.

Igual podemos combinarlos:

- **`like 'POL_TI%'`**: esto va a matchear _POLÍTICA_, _POLITIQUERÍA_, _POLOTITLÁN_, etc.
- **`like '%PUEST_'`**: esto va a matchear _IMPUESTO_, _COMPUESTA_, _APUESTO_, _INTERPUESTA_, etc.

## Ejercicios:

Usando la BD de Sakila:

1. Cuales pagos no son del cliente con ID 5, y cuyo monto sea mayor a 8 o cuya fecha sea 23 de Agosto de 2005?
2. Cuales pagos son del cliente con ID 5 y cuyo monto no sea mayor a 6 y su fecha tampoco sea del 19 de Junio de 2005?
3. Cuales pagos tienen el monto 1.98, 7.98 o 9.98?
4. Cuales la suma total pagada por los clientes que tienen una letra A en la segunda posición de su apellido y una W en cualquier lugar después de la A?

## Tarea

Construyan un query que regrese emails inválidos con la siguiente tabla:



