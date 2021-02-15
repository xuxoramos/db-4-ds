# Joins

Podemos considerar los joins como un producto cartesiano con un filtro para seleccionar solo algunas de las combinaciones finales.

Veremos varios tipos de cláusulas `join`:

1. `A inner join B`: registros que hagan match en ambas tablas `A` y `B`
2. `A full outer join B`: todos los registros de ambas tablas `A` y `B`, hagan match o no
3. `A left outer join B`: todos los registros de la tabla `A` junto con su match (o `null` si no hay) de la tabla `B`
4. `A left outer join B on A.id = B.id` **`and B.id is null`**: todos los registros de la tabla `A` junto con su match de la tabla `B`

Los incisos 3 y 4 tienen su recíproco también con el caso de `right join`.

## `A inner join B`
![](https://blog.codinghorror.com/content/images/uploads/2007/10/6a0120a85dcdae970b012877702708970c-pi.png)

Regresa los registros de `A` que hacen match con `B`, y que ninguno de ambos son null, como se muestra aquí:

![](https://imgur.com/HQHxFxP.png)

En la BD de Northwind, tenemos la relación entre las tablas `customers` y `orders`:

![](https://i.imgur.com/jsv4dK3.png)

Si hacemos un `inner join` sobre `customers.id_customer` y `orders.customer_id` entre ambas, obtendremos solamente los registros de ambas tablas **que hagan match en la relación**.

`select c.customer_id , o.order_id from customers c inner join orders o on (o.customer_id = c.customer_id);`

Alternativamente, podemos quitarle el `inner` y solo dejar `join` y obtendríamos el mismo resultado.

Este es el join más natural y el que usaremos con más frecuencia.

### `A join B on (A.id = B.id) join C on (B.id = C.id)`

Los `inner join` o `join` naturales entre > 2 tablas también nos permiten _entrar_ por una entidad e ir recorriendo todo el modelo de datos hasta llegar al dato que queremos conocer.

Imaginemos el siguiente modelo de datos:

![](https://i.imgur.com/48oEXrP.png)

Si queremos responder la pregunta _"qué profesores imparten clase a qué estudiantes?"_, podemos partir este requerimiento en otras 2 preguntas:

1. _"qué cursos toma cada estudiante?"
2. _"qué cursos imparte cada profesor?"

Y podemos responder cada una por separado:
1. `select s.first_name, s.last_name, c.name from student s join student_course sc on (s.id = sc.student_id) join course c on (sc.course_id = c.id);`
2. `select * from teacher t join course c on (t.id = c.teacher_id);`

> **IMPORTANTE:** podemos vernos tentados a responder esta pregunta en términos solamente de campos `id`, pero esto realmente no sirve como entregable a quien estamos ayudando a tomar decisiones basadas en dato duro y evidencia, dado que las llaves realmente no dicen nada. Para responder esta pregunta efectivamente, debemos recurrir a atributos que identifiquen las entidades que vamos a conectar.

Como podemos ver, ya hemos hecho un `join` de 3 tablas para obtener los nombres de los `student` y sus `courses`, pero ahora debemos hacer un join con una 4a tabla para poder obtener los nombres de los profesores:

```
select s.first_name, s.last_name, c.name, t.first_name, t.last_name 
from student s join student_course sc on (s.id = sc.student_id) 
join course c on (sc.course_id = c.id) 
join teacher t on (c.teacher_id = t.id);
```

### Ejercicio

Pregunta: _"qué nombres tienen los clientes que ordenaron productos tipo 'queso' y qué nombres de productos fueron?"_

### Normalización y utilidad de datos

Como podemos ver con estos ejercicios, para que los datos sean útiles para consumo humano, **parece** que debemos entregarlos _desnormalizados_ hasta la 1NF. Es decir, nombres repetibles, renglones repetidos, etc.

Entonces, para qué invertimos tanto tiempo en el buen diseño de BDs y en normalización? No es más útil poder guardar todo justo en formato para consumo humano? Desnormalizado y sin llaves que estén aisladas del problem domain?

La respuesta es: _depende_. Las bases de datos relacionales que soportan sistemas transaccionales deben ser rápidas para escribir, y deben garantizar que mientras escribimos en ellas, no sucedan anomalías de insert, delete y update. Una tabla desnormalizada nos expone a tiempos de escritura más altos que unas normalizadas, y a anomalías de escritura, aunque sea más _human-readable_.

Estas limitantes funcionales que nos imponen las diferentes representaciones de la realidad la llamamos _impedance mismatch_, y en computación estamos llenas de ellas (ya hemos hablado de la impedance mismatch entre modelos ER y diagramas de clase al representar cosas como herencia y composición). En nuestro caso, representar la realidad como tablas desnormalizadas nos aumenta la utilidad de datos, pero nos expone a pronto introducir entropía en nuestro modelo al insertar nuevas observaciones o modificarla para reflejar cambios en la realidad.

## `A full outer join B`

![](https://blog.codinghorror.com/content/images/uploads/2007/10/6a0120a85dcdae970b012877702725970c-pi.png)

También podemos escribirlo como `full join`, y obtiene todos los registros de `A` y `B`, incluso los que no cumplen la relación entre ambos, dejándolos en `null` demambos lados en ese caso, como en la sig. figura:

![](https://i.imgur.com/EjuGWo3.png)

Siguiendo nuestro ejemplo sobre la relación entre `customers` y `orders`, recordemos que con un `join` natural (o `inner join`) sobre la PK/FK de `customer` nos regresa 830 registros:

![](https://i.imgur.com/hQDIhRc.png)

Sin embargo, si cambiamos a un `full join`, podemos ver que tenemos 832:

`select c.customer_id , o.order_id from customers c full join orders o on (o.customer_id = c.customer_id);` 

![](https://i.imgur.com/dJvKdQP.png)

Los 2 registros que aparecen ahora y que antes no teníamos son clientes que tenemos registrados, **pero que no han puesto una orden nunca en su vida**.

### "Pa k kieres saber eso jaja saludos"

La utilidad de un `full join` o `full outer join` está en identificar _las relaciones que no están ahí_. A veces la falta de información es más útil que su presencia. En el ejemplo de arriba, podemos ver que los clientes PARIS y FISSA nunca nos han comprado nada. Qué podemos hacer? Descuentos exclusivos para ellos? Seguimiento? Marketing dirigido?

Finalmente, estas son las **acciones** que deben ser generadas con datos, y es nuestra responsabilidad como analistas de datos, administradores de BD o desarrolladores de software, empujar esta cultura en nuestras organizaciones.


## `A left outer join B`
![](https://blog.codinghorror.com/content/images/uploads/2007/10/6a0120a85dcdae970b01287770273e970c-pi.png)

Similar al `full outer join` o al `full join`, esta cláusula regresa todos los registros de `A`, cumplan o no su relación con `B`, dejando en `null` aquellos en `A` que no tengan match, como en la siguiente figura:

![](https://i.imgur.com/aFkWV6T.png)







