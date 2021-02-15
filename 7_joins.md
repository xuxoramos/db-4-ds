# Joins

Podemos considerar los joins como un producto cartesiano con un filtro para seleccionar solo algunas de las combinaciones finales.

Veremos varios tipos de cláusulas `join`:

1. `A inner join B`: registros que hagan match en ambas tablas `A` y `B`
2. `A full outer join B`: todos los registros de ambas tablas `A` y `B`, hagan match o no
3. `A left outer join B`: todos los registros de la tabla `A` junto con su match (o `null` si no hay) de la tabla `B`
4. `A left outer join B on A.id = B.id **and B.id is null**`: todos los registros de la tabla `A` junto con su match de la tabla `B`

Los incisos 3 y 4 tienen su recíproco también con el caso de `right join`.

## `A inner join B`
![](https://blog.codinghorror.com/content/images/uploads/2007/10/6a0120a85dcdae970b012877702708970c-pi.png)

Regresa los registros de `A` que hacen match con `B`, y que ninguno de ambos son null, como se muestra aquí:

![](https://imgur.com/HQHxFxP.png)

