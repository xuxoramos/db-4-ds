# Normalización

Normalizar una BD es aplicar una serie de reglas para evitar inconsistencias en las consultas de datos, anomalías de en operaciones de inserción, actualización y borrado, evitar redundancia y proteger integridad de los datos.

Una BD normalizada nos da la suficiente flexibilidad para agregar catálogos, relaciones y tipos de datos sin modificar severamente la estructura.

La normalización nos lleva a través de _7 formas normales_, de las cuales solo veremos 3.

En general, una vez que tu BD está en 3a forma normal (3NF), ya está lista para producción.

Algunas de estas reglas ya las hemos visto como buenas prácticas, así que esto no debe ser complicado.

## Qué anomalías evitamos con la normalización?
1. **Anomalías de `insert`:** al insertar un registro con columnas `estado` y `municipio`, combinarlos de formas no consistentes con la realidad (i.e. municipio de `Atizapán`, estado de `Zacatecas`)
2. **Anomalías de `update`:** al querer actualizar 1 y solo 1 registro, accidentalmente actualizar varios debido a llaves inconsistentes.
3. **Anomalías de `delete`:** al querer borrar 1 y solo 1 registro, accidentalmente chutarnos varios debido a llaves inconsistentes.

## 1a Forma Normal (1NF)

Hay diferentes formas de expresar las reglas, pero en favor de ser concretos y no confusos:

1. Cada celda de la tabla debe contener 1 y solo 1 valor
2. Cada registro debe ser único
3. Eliminar nombres de atributos, o grupos de atributos repetidos

Supongamos que queremos agregar la tabla `servicio` al esquema `hospital`. La tabla servicio es mediante la cual se construirá la factura de nuestro paciente al momento de saldar su cuenta.

Si, ya se que la salud y la seguridad deben ser responsabilidad del estado, pero síganme solo para efectos de ejemplo.

![](https://imgur.com/PJ1mwEW.png)

Esta tabla es un asco. No sigue ninguna de las mejores prácticas que hemos acordado. Llevemosla a la 1NF.

Aplicando regla por regla:

1. Cada celda de la tabla debe contener 1 y solo 1 valor:

![](https://imgur.com/fkfi3C5.png)

Separamos los valores cada uno en su propio renglón, pero con eso repetimos el nombre del paciente.

2. Cada registro debe ser único

![](https://imgur.com/zYv9uKe.png)

Pudimos definir una llave primaria compuesta para identificar cada renglón como único.

3. Eliminar nombres de atributos, o grupos de atributos repetidos

![](https://imgur.com/a2E6uyx.png)

En lugar de tener varias columnas de costo para un renglón de servicio con múltiples datos, separamos esas columnas para que a cada servicio le toque su precio.

## 2a Forma Normal (2NF)

1. Cumplir con las reglas de la 1NF
2. Todos los atributos o columnas de una tabla deben pertenecer a la entidad que representa.
3. Excepto relaciones N a M, la PK no debe ser compuesta y debe ser de 1 solo atributo.

Veamos como se transforma la tabla `servicio` aplicando todas las reglas de la 2NF. Ya cumplimos la 1NF, así que vamos desde la regla 2.

2. Todos los atributos o columnas de una tabla deben pertenecer a la entidad que representa.

Un atributo X pertenece a una entidad Y si para saber X podemos depender de la PK de Y. Todo atributo que no pertenezca a la entidad, debe quedar fuera de la tabla. De este modo se descubren otras entidades, sus relaciones, y algunos catálogos.

![](https://imgur.com/f1tnljQ.png)

Como `servicio` es una entidad separada de `paciente`, hacemos tablas independientes para cada una. Adicionalmente, como el departamento responsable de proveer el servicio no pertenece al servicio, entonces igual lo extraemos a la tabla `departamento_hospital`.

Al hacer esto, hemos eliminado la necesidad de tener nombres de pacientes, de servicios y de departamentos repetidos, lo cual nos permite cumplir con la siguiente regla de la 2NF.

3. Excepto relaciones N a M, la PK no debe ser compuesta y debe ser de 1 solo atributo.

![](https://imgur.com/t7syTzQ.png)

Pero las _**best practices**_ para llaves primarias que hemos visto anteriormente nos recomiendan que:

1. no sea un _atributo primario_ de la entidad que la tabla representa
2. sea un entero secuencial

Entonces nos quedarían de esta forma:

![](https://imgur.com/TohYkux.png)


## 3era Forma Normal (3NF)

1. Cumplir con las reglas de la 2NF
2. No hay dependencias transitivas (no hay atributo A que para llegar a él se requiera del atributo B al que a su vez se llega por la PK)

Después de tener la tabla `servicio` en 2NF, nos quedamos con el `id`, el `nombre` y el `costo` del servicio.

Pero realmente el `costo` depende del `id`?

Si suponemos que el costo del servicio está dado por un `tabulador`, nuestra tabla de servicio queda del siguiente modo:

![](https://imgur.com/FtHpsas.png)

Con esto tenemos una _dependencia transitiva_: el `costo` está dado por el `tabulador`, y el `tabulador` del servicio lo da el `id` servicio.

Para cumplir con la 3NF, debemos sacar a otra tabla el atributo que inicia la cadenita de dependencias transitivas: el `costo`.

![](https://imgur.com/VpelFc9.png)

Y ya si nos ponemos exquisitos y aplicamos las _best practices_:

![](https://imgur.com/ejoBTyY.png)

## Summary en forma de juramento gringo

1. Requerir la existencia de una llave primaria automáticamente nos pone en 1NF (la llave)
2. Requerir que todos los atributos dependan de toda la llave primaria nos pone en 2NF (toda la llave)
3. Requerir que todos los atributos dependan solamente de la llave primaria nos pone en automático en 3NF (nada más que la llave)

## Una nota sobre criterio

Como dijimos anteriormente, al estar diseñando BDs, es importante tomar en cuenta que muchas de las decisiones son subjetivas y sujetas a su criterio. En general, una BD que evite anomalías en operaciones de borrado, actualización e inserción, y que siga las prácticas que hemos visto en clase, quedará en automático en 3NF.

## 4NF y posteriores

La mayoría de las aplicaciones de la vida real serán suficientes con que tengamos nuestra BD en 3NF. Las NF posteriores garantizan aún mayor cobertura VS anomalías, mayor consistencia en algunos casos frontera, etc. 

Del mismo modo, "normalización" se dió cuando el storage era caro, pero ahora en 2021 la razón más importante es estructura, y optimización de escritura.
