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
3. Eliminar grupos de atributos repetidos
4. Crear tablas separadas para entidades separadas

Supongamos que queremos agregar la tabla `servicio` al esquema `hospital`. La tabla servicio es mediante la cual se construirá la factura de nuestro paciente al momento de saldar su cuenta.

Si, ya se que la salud y la seguridad deben ser responsabilidad del estado, pero síganme solo para efectos de ejemplo.

![](https://imgur.com/0TNs8GT.png)

Esta tabla es un asco. No sigue ninguna de las mejores prácticas que hemos acordado. Llevemosla a la 1NF.

Aplicando regla por regla:

1. Cada celda de la tabla debe contener 1 y solo 1 valor:

![](https://imgur.com/RTltr0U.png)

Separamos los valores cada uno en su propio renglón, pero con eso repetimos el nombre del paciente.

2. Cada registro debe ser único

![](https://imgur.com/r4yZJeu.png)

Pudimos definir una llave primaria compuesta para identificar cada renglón como único.

3. Eliminar grupos de atributos repetidos

![](https://imgur.com/FfB7uaj.png)

En lugar de tener varias columnas de costo para un renglón de servicio con múltiples datos, separamos esas columnas para que a cada servicio le toque su precio.

4. Crear tablas separadas para entidades separadas

![](https://imgur.com/f1tnljQ.png)

Como `servicio` es una entidad separada de `paciente`, hacemos tablas independientes para cada una.

Pero perdimos la relación! :O

## 2a Forma Normal (2NF)

1. Cumplir con 1NF
2. 



