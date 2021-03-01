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
| where not (TRUE or TRUE) and FALSE   | TRUE      |
| where not (TRUE or FALSE) and FALSE  | TRUE      |
| where not (FALSE or TRUE) and FALSE  | TRUE      |
| where not (FALSE or FALSE) and FALSE | TRUE      |

## Tipos de condiciones

### Igualdad 
Son las condiciones dadas con `=`, `>`, `<` y sus combinaciones `>=`, `<=`. Ojo que podemos combinar los operadores `and`, `or` y `not` junto con los de igualdad par hacer igualdades más complejas.

### Desigualdad
Podemos hacerlo con `!=` o con `<>`, e igual podemos combinarlos con los operadores lógicos de arriba para condiciones más complejas. Por ejemplo, el query 

`select * where film_actor.actor_id != 1`

puede refrasearse como `where film_actor.actor_id <> 1`

y ambos tendrían el mismo resultado.

### Inclusión
`where film.title in ('ACADEMY DINOSAUR', 'AFRICAN EGG', 'AGENT TRUMAN')`, o bien `where r.rental_date between '2005-01-01' and '2005-12-31'` - ojo con el orden de los umbrales de `between`, inferior priemro, superior segundo.
  - Caso especial `between` con campos `varchar`: el operador `between` usado en textos es como una búsqueda alfabética caracter por caracter. El query `select f.title from film f where f.title between 'AA' and 'AZ';` va a listar todos los nombres de películas que comiencen con A y cuya 2a letra del título vaya de la A a la Z.
### Matching
`where film.title like %OLE%'`: el operador `like` toma como argumento un string con el cual intentar hacer match; `_` para hacer match de cualquier 1 caracter, `%` para cualesquiera N caracteres. 

